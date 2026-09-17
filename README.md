# PetFood Intelligence Consumer Apps

Consumer frontends for the existing PetFood Intelligence API.

- `src/`: Next.js web frontend
- `ios/`: native SwiftUI iPhone application

## Local Setup

Create `.env.local` with server-side values:

```bash
PETFOOD_API_URL=http://127.0.0.1:5081
PETFOOD_API_KEY=your-secret-key
```

The browser never calls the PetFood API directly and `PETFOOD_API_KEY` must never be exposed through `NEXT_PUBLIC_*`.

## Commands

```bash
npm run dev
npm run lint
npm test
npm run build
```

## iOS

Open `ios/PetFoodIntelligence.xcodeproj` in Xcode. Copy `ios/Config/Secrets.example.xcconfig` to `ios/Config/Secrets.xcconfig` and set the development API key. The checked-in `Secrets.xcconfig` placeholder is ignored by Git once local changes are made.

Simulator builds use `http://127.0.0.1:5081` through the Mac SSH tunnel. A physical iPhone cannot use the Mac's `127.0.0.1`; configure a device-reachable development API URL without exposing the remote API insecurely.

## Routes

`/`, `/foods`, `/foods/[id]`, `/barcode`, `/brands`, `/brands/[id]`, `/ingredients`, `/ingredients/[id]`, `/compare`.

## Current API Verification

`GET /health` at `http://127.0.0.1:5081` returned OK on September 17, 2026. Authenticated endpoint inspection was not completed because `PETFOOD_API_KEY` was not set in the shell.
