import "server-only";
import { petfoodFetch } from "./client";
import { normalizeList } from "./normalize";
import { ApiRecord, DirectoryQuery } from "./types";

export async function getBrands(query: DirectoryQuery = {}) {
  return normalizeList<ApiRecord>(await petfoodFetch("/api/v1/brands", query));
}

export async function getBrand(id: string) {
  return petfoodFetch<ApiRecord>(`/api/v1/brands/${encodeURIComponent(id)}`);
}

export async function getBrandProducts(id: string, query: DirectoryQuery = {}) {
  return normalizeList<ApiRecord>(await petfoodFetch(`/api/v1/brands/${encodeURIComponent(id)}/products`, query));
}
