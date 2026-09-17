export type ApiRecord = Record<string, unknown>;
export type QueryValue = string | number | boolean | undefined | null;

export type ApiList<T = ApiRecord> = {
  items: T[];
  page?: number;
  pageSize?: number;
  total?: number;
  totalPages?: number;
  raw?: unknown;
};

export type ProductQuery = {
  q?: string;
  species?: string;
  brand?: string;
  foodForm?: string;
  page?: number;
  pageSize?: number;
};

export type DirectoryQuery = {
  q?: string;
  page?: number;
  pageSize?: number;
};

export type ApiErrorKind = "configuration" | "unauthorized" | "not-found" | "rate-limit" | "unavailable" | "server" | "unknown";

export class PetfoodApiError extends Error {
  constructor(
    message: string,
    public readonly kind: ApiErrorKind,
    public readonly status?: number,
  ) {
    super(message);
  }
}
