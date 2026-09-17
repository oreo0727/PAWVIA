# API Integration

Base URL: `PETFOOD_API_URL`, defaulting locally to `http://127.0.0.1:5081`.

Authentication header: `X-Api-Key`, sourced from `PETFOOD_API_KEY`.

Implemented modules:

- `products.ts`: products, product detail, barcode lookup, comparison
- `brands.ts`: brand directory, brand detail, brand products
- `ingredients.ts`: ingredient directory, ingredient detail, ingredient products

The API client normalizes common list envelopes (`items`, `data`, `results`, `products`, `brands`, `ingredients`) because authenticated response shapes could not be inspected without the key.

Observed live check:

- `GET /health`: returned `{"status":"ok","database":"ok","applicationVersion":"1.0.0.0"}`

Pending with a configured key:

- `GET /api/v1/products?pageSize=5`
- product detail, barcode, compare
- brand and ingredient endpoints
