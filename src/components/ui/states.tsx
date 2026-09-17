import { AlertCircle, SearchX } from "lucide-react";
import { PetfoodApiError } from "@/lib/petfood-api/types";

export function EmptyState({ title = "No results yet.", body = "Try a different search or filter." }) {
  return (
    <div className="rounded-2xl border border-dashed border-stone-300 bg-white p-8 text-center">
      <SearchX className="mx-auto h-8 w-8 text-stone-500" />
      <h2 className="mt-3 text-lg font-semibold text-stone-950">{title}</h2>
      <p className="mt-2 text-sm text-stone-600">{body}</p>
    </div>
  );
}

export function ErrorState({ error }: { error: unknown }) {
  const message =
    error instanceof PetfoodApiError && error.kind === "configuration"
      ? "API credentials are not configured for this environment."
      : error instanceof PetfoodApiError && error.kind === "rate-limit"
        ? "The service is temporarily receiving too many requests."
        : error instanceof PetfoodApiError && error.kind === "not-found"
          ? "We could not find that record."
          : "We could not reach the PetFood API right now.";
  return (
    <div className="rounded-2xl border border-rose-200 bg-rose-50 p-6">
      <AlertCircle className="h-6 w-6 text-rose-700" />
      <h2 className="mt-3 font-semibold text-rose-950">Something needs attention</h2>
      <p className="mt-2 text-sm leading-6 text-rose-900">{message}</p>
    </div>
  );
}
