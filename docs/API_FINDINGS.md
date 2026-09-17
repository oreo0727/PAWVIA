# API Findings

Date: September 17, 2026

Live health check:

```json
{"status":"ok","database":"ok","applicationVersion":"1.0.0.0"}
```

Authenticated response inspection is pending because no development API key was available in this shell. The iOS Codable models are intentionally tolerant of common field variants observed/anticipated from the web integration, but they should be tightened after inspecting real authenticated responses.

Endpoints still requiring real-data validation:

- `GET /api/v1/products?pageSize=5`
- `GET /api/v1/products/{id}`
- `GET /api/v1/products/barcode/{barcode}`
- `GET /api/v1/products/compare?ids=...`
- `GET /api/v1/brands`
- `GET /api/v1/brands/{id}`
- `GET /api/v1/brands/{id}/products`
- `GET /api/v1/ingredients`
- `GET /api/v1/ingredients/{id}`
- `GET /api/v1/ingredients/{id}/products`

Known UX risk until real responses are inspected:

- Nutrition may be missing or nested under fields the tolerant decoder does not yet cover.
- Ingredient order depends on the API returning ordered arrays or raw label text.
- Verification statuses may use names beyond the known set.
