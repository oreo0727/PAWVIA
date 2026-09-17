import { ApiList } from "./types";

export function normalizeList<T extends Record<string, unknown>>(raw: unknown): ApiList<T> {
  if (Array.isArray(raw)) return { items: raw as T[], raw };
  const source = raw && typeof raw === "object" ? (raw as Record<string, unknown>) : {};
  const items = source.items ?? source.data ?? source.results ?? source.products ?? source.brands ?? source.ingredients ?? [];
  return {
    items: Array.isArray(items) ? (items as T[]) : [],
    page: typeof source.page === "number" ? source.page : undefined,
    pageSize: typeof source.pageSize === "number" ? source.pageSize : undefined,
    total: typeof source.total === "number" ? source.total : typeof source.totalCount === "number" ? source.totalCount : undefined,
    totalPages: typeof source.totalPages === "number" ? source.totalPages : undefined,
    raw,
  };
}
