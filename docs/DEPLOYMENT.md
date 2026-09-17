# Deployment

Set these environment variables in the hosting platform:

```bash
PETFOOD_API_URL=https://your-api-origin
PETFOOD_API_KEY=your-secret-key
```

Do not define `NEXT_PUBLIC_PETFOOD_API_KEY`.

Before release:

```bash
npm run lint
npm test
npm run build
grep -R "PETFOOD_API_KEY\\|your-secret-key" .next/static .next/server/app || true
```

The secret should not appear in browser bundles, HTML, or static assets.
