# Example: What /init generates

This is an example of what `/init` produces when run on a Node.js + Express project. Your output will vary based on your actual stack.

---

# OrderFlow API

Express REST API for managing customer orders and fulfillment.

## Stack

| Component | Technology |
|-----------|-----------|
| Runtime | Node.js 22 |
| Framework | Express 5 |
| Language | TypeScript 5.4 |
| Database | PostgreSQL 16 (via Prisma) |
| Cache | Redis 7 |
| Test Runner | Vitest |
| Linter | ESLint (flat config) |
| Formatter | Prettier |
| Package Manager | pnpm |

## Architecture

```
src/
├── config/          # routes, database, redis
├── modules/         # domain-driven modules
│   ├── orders/      # controllers, services, schemas, tests
│   ├── customers/
│   ├── payments/
│   └── notifications/
├── shared/          # middleware, helpers, error classes
└── index.ts         # entry point
```

Pattern: **modular monolith** — each module has controllers, services, schemas, and tests.

## Commands

| Command | Description |
|---------|-------------|
| `pnpm dev` | Dev server with hot reload |
| `pnpm test` | Vitest in watch mode |
| `pnpm test --run` | Single test run |
| `pnpm lint` | ESLint check |
| `pnpm build` | TypeScript compilation |
| `pnpm db:migrate` | Run Prisma migrations |
| `pnpm db:seed` | Seed development data |

## Conventions

- **Branch format:** `feature/OF-123/add-order-tracking` (prefix/ticket/description)
- **Commit format:** `feat(orders): add tracking endpoint [OF-123]` (conventional commits)
- **File naming:** kebab-case (`order.controller.ts`, `create-order.schema.ts`)
- **Function naming:** camelCase (`getOrderById`, `validatePayment`)
- **Test files:** `*.test.ts` colocated in module directory

## Key Files

| File | Purpose |
|------|---------|
| `src/index.ts` | App entry point, middleware setup |
| `src/config/routes/v1/` | All route definitions |
| `src/shared/middleware/auth.ts` | JWT authentication |
| `src/shared/middleware/validate.ts` | Zod schema validation |
| `src/shared/responses.ts` | Response helpers (sendSuccess, sendError) |
| `prisma/schema.prisma` | Database schema |
| `.github/workflows/ci.yml` | CI pipeline (lint + test + build) |
