import "server-only";
import { petfoodFetch } from "./client";
import { normalizeList } from "./normalize";
import { ApiRecord, DirectoryQuery } from "./types";

export async function getIngredients(query: DirectoryQuery = {}) {
  return normalizeList<ApiRecord>(await petfoodFetch("/api/v1/ingredients", query));
}

export async function getIngredient(id: string) {
  return petfoodFetch<ApiRecord>(`/api/v1/ingredients/${encodeURIComponent(id)}`);
}

export async function getIngredientProducts(id: string, query: DirectoryQuery = {}) {
  return normalizeList<ApiRecord>(await petfoodFetch(`/api/v1/ingredients/${encodeURIComponent(id)}/products`, query));
}
