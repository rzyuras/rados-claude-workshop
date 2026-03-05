# /controllers — Express Controller Pattern

Write controllers for the Express 5 BFF following the established patterns.

## Architecture

```
src/modules/[domain]/
├── controllers/
│   └── [domain].controller.ts    # thin — delegates to service
├── services/
│   └── [domain].service.ts       # business logic + external calls
├── schemas/
│   └── [domain].schemas.ts       # Zod validation schemas
└── routes.ts                     # route definitions
```

Controllers are **thin wrappers**. They validate input, call a service, and return a formatted response. No business logic.

## Template

```typescript
import { Request, Response } from "express";
import { endpoint } from "@shared/endpoint";
import { sendSuccess, sendCreated, sendNoContent } from "@shared/responses";
import { DomainService } from "../services/domain.service";

export const getItems = endpoint(async (req: Request, res: Response) => {
  const { userId } = res.locals;
  const items = await DomainService.getAll(userId);
  sendSuccess(res, items);
});

export const createItem = endpoint(async (req: Request, res: Response) => {
  const { userId } = res.locals;
  const item = await DomainService.create(userId, req.body);
  sendCreated(res, item);
});

export const deleteItem = endpoint(async (req: Request, res: Response) => {
  const { id } = req.params;
  await DomainService.delete(id);
  sendNoContent(res);
});
```

## Response Helpers

| Action | Helper | Status | Envelope |
|--------|--------|--------|----------|
| Read one/many | `sendSuccess(res, data)` | 200 | `{ data }` |
| Create | `sendCreated(res, data)` | 201 | `{ data }` |
| Update | `sendSuccess(res, data)` | 200 | `{ data }` |
| Delete | `sendNoContent(res)` | 204 | — |
| Error | `sendError(res, status, message)` | 4xx/5xx | `{ error }` |

## Route Definition

```typescript
import { Router } from "express";
import { validate } from "@shared/middleware/validate";
import { authenticate } from "@shared/middleware/auth";
import { createItemSchema } from "../schemas/domain.schemas";
import * as controller from "../controllers/domain.controller";

const router = Router();

router.get("/", authenticate, controller.getItems);
router.post("/", authenticate, validate(createItemSchema), controller.createItem);
router.delete("/:id", authenticate, controller.deleteItem);

export default router;
```

## Middleware Chain Order

```
authenticate → validate(schema) → controller → endpoint() catches errors
```

## Rules

- **ALWAYS** wrap every controller function with `endpoint()` — it handles try/catch and error formatting.
- **ALWAYS** use response helpers (`sendSuccess`, `sendCreated`, etc.) — never `res.json()` or `res.status()` directly.
- **ALWAYS** validate request body with Zod schemas via `validate()` middleware before the controller runs.
- **ALWAYS** extract user context from `res.locals` (set by auth middleware), never from the request body.
- **NEVER** put business logic in controllers — delegate to services. Controllers are routing glue.
- **NEVER** use try/catch in controllers — `endpoint()` handles all errors uniformly.
- **NEVER** skip the `authenticate` middleware on protected routes.
- **NEVER** return raw service/database errors to the client — use `sendError` with a clean message.

## Example: Booking Controller

```typescript
import { Request, Response } from "express";
import { endpoint } from "@shared/endpoint";
import { sendSuccess, sendCreated } from "@shared/responses";
import { BookingService } from "../services/booking.service";

export const getUpcoming = endpoint(async (req: Request, res: Response) => {
  const { userId } = res.locals;
  const { page, limit } = req.query;
  const bookings = await BookingService.getUpcoming(userId, { page: Number(page), limit: Number(limit) });
  sendSuccess(res, bookings);
});

export const create = endpoint(async (req: Request, res: Response) => {
  const { userId } = res.locals;
  const booking = await BookingService.create(userId, {
    serviceId: req.body.serviceId,
    companyId: req.body.companyId,
    dateTime: req.body.dateTime,
  });
  sendCreated(res, booking);
});
```

## Checklist

- [ ] Controller function wrapped with `endpoint()`
- [ ] Response uses helper (`sendSuccess`, `sendCreated`, `sendNoContent`)
- [ ] No try/catch in the controller
- [ ] No business logic — only calls service methods
- [ ] Route has `authenticate` middleware
- [ ] Request body validated with Zod schema via `validate()`
- [ ] User context from `res.locals`, not `req.body`
