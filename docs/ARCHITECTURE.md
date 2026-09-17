# Architecture

This repository is frontend-only. Next.js App Router server components call the existing PetFood API through server-only modules under `src/lib/petfood-api`.

Browser code talks only to Next.js pages and client components. The API key is read only from server-side environment variables.

Client JavaScript is limited to comparison selection in `localStorage` and interactive buttons.

## Native iOS

The native app lives in `ios/` and uses SwiftUI, Observation, NavigationStack, URLSession, and VisionKit DataScannerViewController.

Feature folders:

- `App`: lifecycle and tab shell
- `Networking`: configuration, transport, API client, typed errors
- `Models`: Codable API models
- `Stores`: local scan history, favorites, comparison selection
- `Views`: home, search, scanner, product snapshot, history, compare

The scan flow is designed around barcode first, immediate lookup, and a factual product snapshot. Local stores use `UserDefaults` and never store API credentials.
