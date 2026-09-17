# PetFood Intelligence Consumer App

Mobile-first Next.js consumer frontend for the existing PetFood Intelligence API.

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

## Routes

`/`, `/foods`, `/foods/[id]`, `/barcode`, `/brands`, `/brands/[id]`, `/ingredients`, `/ingredients/[id]`, `/compare`.

## Current API Verification

`GET /health` at `http://127.0.0.1:5081` returned OK on September 17, 2026. Authenticated endpoint inspection was not completed because `PETFOOD_API_KEY` was not set in the shell.
