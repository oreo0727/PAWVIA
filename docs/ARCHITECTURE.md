# Architecture

This repository is frontend-only. Next.js App Router server components call the existing PetFood API through server-only modules under `src/lib/petfood-api`.

Browser code talks only to Next.js pages and client components. The API key is read only from server-side environment variables.

Client JavaScript is limited to comparison selection in `localStorage` and interactive buttons.
