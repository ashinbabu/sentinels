# Busco Backend (Node.js + Express + MongoDB)

## Setup

1. Copy `.env.example` to `.env` and set values.
2. Install dependencies:
   - `npm install`
3. Start backend:
   - `npm run dev`

## Core Collections

- `users`
- `buses`
- `routes`
- `trips`
- `qrcodes`
- `tickets`
- `payments`

## API Endpoints (MVP)

- `POST /api/register`
- `POST /api/login`
- `GET /api/get-qr-details?qr_code=...`
- `GET /api/fare?trip_id=...&destination=...`
- `POST /api/create-ticket` (JWT required)
- `POST /api/get-tickets`
- `GET /api/tickets/:ticketId/verify` (JWT required)

## Response Contract

Success:
```json
{ "status": "success", "message": "ok", "data": {} }
```

Failure:
```json
{ "status": "failure", "error": "message", "code": "ERR_CODE" }
```
