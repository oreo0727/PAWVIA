import "server-only";
import { petfoodFetch } from "./client";
import { normalizeList } from "./normalize";
import { ApiRecord, ProductQuery } from "./types";

export async function getProducts(query: ProductQuery = {}) {
  return normalizeList<ApiRecord>(await petfoodFetch("/api/v1/products", query));
}

export async function getProduct(id: string) {
  return petfoodFetch<ApiRecord>(`/api/v1/products/${encodeURIComponent(id)}`);
}

export async function getProductByBarcode(barcode: string) {
  return petfoodFetch<ApiRecord>(`/api/v1/products/barcode/${encodeURIComponent(barcode)}`);
}

export async function compareProducts(ids: string[]) {
  return normalizeList<ApiRecord>(await petfoodFetch("/api/v1/products/compare", { ids: ids.join(",") }));
}
