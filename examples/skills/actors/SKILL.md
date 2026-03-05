# /actors — Ruby Service Actor Pattern

Write service actors using `service_actor-rails`. Each actor does one thing.

## Actor Types

| Type | When | Base Class |
|------|------|------------|
| **Simple** | Single operation (find, save, assign) | `ApplicationActor` |
| **Play** | Orchestrate multiple actors in sequence | `ApplicationActor` |
| **Resilient** | Needs DB transaction + rollback | `ApplicationActor` with `play` |

**Decision tree:** Need composition? → Play. Need rollback? → Resilient. Otherwise → Simple.

## Template: Simple Actor

```ruby
# app/actors/orders/build.rb
module Orders
  class Build < ApplicationActor
    input :customer, type: Customer
    input :items, type: Array
    input :notes, type: String, default: nil, allow_nil: true

    output :order, type: Order

    def call
      self.order = Order.new(
        customer: customer,
        items: items,
        notes: notes,
        status: :pending
      )
    end
  end
end
```

## Template: Play Actor

```ruby
# app/actors/orders/create.rb
module Orders
  class Create < ApplicationActor
    input :customer, type: Customer
    input :items, type: Array
    input :notes, type: String, default: nil, allow_nil: true

    output :order, type: Order

    play Orders::Build,
         Orders::Validate,
         Orders::Save,
         Notifications::Schedule
  end
end
```

## Template: Resilient Actor (Transaction)

```ruby
# app/actors/orders/cancel.rb
module Orders
  class Cancel < ApplicationActor
    input :order, type: Order

    output :order, type: Order

    def call
      ActiveRecord::Base.transaction do
        super
      end
    end

    play Orders::UpdateStatus,
         Payments::Refund,
         Notifications::SendCancellation
  end
end
```

Rollback runs in **reverse order** — if `Payments::Refund` fails, `Orders::UpdateStatus` rolls back first.

## Actor Catalog

| Actor | Responsibility | Naming |
|-------|---------------|--------|
| `Build` | Instantiate model (no save) | `[Domain]::Build` |
| `Find` | Query with includes | `[Domain]::Find` |
| `Save` | Persist to DB | `[Domain]::Save` |
| `Validate` | Business rule validation | `[Domain]::Validate` |
| `Assign` | Set attributes on existing record | `[Domain]::Assign` |
| `Filter` | Apply query scopes | `[Domain]::Filter` |
| `Destroy` | Delete record | `[Domain]::Destroy` |
| `Create` | Play: Build → Validate → Save | `[Domain]::Create` |
| `Update` | Play: Find → Assign → Validate → Save | `[Domain]::Update` |

## Error Handling

```ruby
# Business rule failure — returns 422 by default
def call
  fail!(error: :insufficient_stock) unless items_available?
  fail!(error: :customer_suspended, status: :forbidden) unless customer.active?
end
```

- Use `fail!` with **snake_case symbol keys** — never human-readable strings.
- Add `:status` only for non-422 responses (`:not_found`, `:forbidden`, `:conflict`).

## Invocation

```ruby
# In a controller — use .result for the full result object
result = Orders::Create.result(customer: current_customer, items: params[:items])

if result.success?
  render json: OrderSerializer.new(result.order), status: :created
else
  render json: { error: result.error }, status: result.status || :unprocessable_entity
end

# When you trust the inputs (e.g., inside another actor) — use .call
Orders::Save.call(order: order)
```

## Custom Validators

```ruby
# app/actors/concerns/custom_validators.rb
input :quantity, type: Integer, in: ->(val) { val.positive? }
input :email, type: String, in: ->(val) { val.match?(URI::MailTo::EMAIL_REGEXP) }
input :scheduled_at, type: DateTime, in: ->(val) { val > Time.current }
```

## Rules

- **ALWAYS** use typed inputs (`type: String`, `type: Integer`, etc.) — never untyped.
- **ALWAYS** use `fail!` with snake_case symbol keys for errors — never strings, never `raise`.
- **ALWAYS** use `includes(...)` in Find actors to prevent N+1 queries.
- **ALWAYS** wrap Play actors in a transaction if any step writes to the DB.
- **NEVER** put business logic in controllers — it goes in actors.
- **NEVER** create a Play for a single step — use a simple actor.
- **NEVER** use human-readable error messages in `fail!` — use error keys that the frontend maps to i18n.
- **NEVER** put multiple responsibilities in one actor — split into Build + Validate + Save.
- **NEVER** call actors during serialization — fetch all data before serializing.

## Checklist

- [ ] Actor has typed inputs and outputs
- [ ] One responsibility per actor
- [ ] Play actors compose 2+ simple actors
- [ ] Errors use `fail!(error: :snake_case_key)`
- [ ] Find actors use `includes()` for associations
- [ ] Transaction wraps any Play that writes to DB
- [ ] Controller uses `.result` and checks `.success?`
