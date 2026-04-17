# busco - Make a Ton 6.0

We all have suffered the hassle of carrying cash or perfect change for traveling in unreserved local buses.Also not able to find whether a coming bus is crowded before hand, busCo aims to solve this problem

# Team Members:
1. Aneetta Sara Shany
2. Ashin Babu
3. Nithin Kurian

## Mobile deployment notes

- The Flutter app now reads API URL from `--dart-define=API_BASE_URL=...`.
- Default API URL fallback is `http://10.0.2.2:3000/api/` for Android emulator.
- Android camera and internet permissions are configured for QR scanning + API access.
- iOS camera usage description is configured for QR scanning.

## MVP flow implemented

`login -> scan QR -> fetch trip -> choose destination/seat -> confirm payment -> create ticket -> view tickets`

## Backend recommendation and scaffold

- Recommended stack: **Node.js + Express + MongoDB Atlas** with JWT auth.
- A backend scaffold is added under `/backend` with:
  - core Mongo models for users, buses, routes, trips, qrcodes, tickets, payments
  - auth, QR details, fare, ticket create/history/verify routes
  - standardized response contract and basic validation

See `/backend/README.md` for run instructions and API summary.
