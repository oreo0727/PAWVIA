import "server-only";
import { PetfoodApiError, QueryValue } from "./types";

function config() {
  const baseUrl = process.env.PETFOOD_API_URL ?? "http://127.0.0.1:5081";
  const apiKey = process.env.PETFOOD_API_KEY;
  if (!apiKey) throw new PetfoodApiError("PetFood API key is not configured.", "configuration");
  return { baseUrl: baseUrl.replace(/\/$/, ""), apiKey };
}

function withQuery(path: string, query?: Record<string, QueryValue>) {
  const params = new URLSearchParams();
  for (const [key, value] of Object.entries(query ?? {})) {
    if (value !== undefined && value !== null && value !== "") params.set(key, String(value));
  }
  return params.size ? `${path}?${params.toString()}` : path;
}

function classify(status: number) {
  if (status === 401 || status === 403) return "unauthorized";
  if (status === 404) return "not-found";
  if (status === 429) return "rate-limit";
  if (status >= 500) return "server";
  return "unknown";
}

export async function petfoodFetch<T>(path: string, query?: Record<string, QueryValue>, init?: RequestInit): Promise<T> {
  const { baseUrl, apiKey } = config();
  const response = await fetch(`${baseUrl}${withQuery(path, query)}`, {
    ...init,
    headers: { Accept: "application/json", "X-Api-Key": apiKey, ...init?.headers },
    next: { revalidate: 60 },
  }).catch(() => {
    throw new PetfoodApiError("PetFood API is unavailable.", "unavailable");
  });

  if (!response.ok) throw new PetfoodApiError("PetFood API request failed.", classify(response.status), response.status);
  return (await response.json()) as T;
}
