import { clsx, type ClassValue } from "clsx";

export function cn(...inputs: ClassValue[]) {
  return clsx(inputs);
}

export function valueOf(record: unknown, keys: string[]): unknown {
  if (!record || typeof record !== "object") return undefined;
  const source = record as Record<string, unknown>;
  for (const key of keys) {
    if (source[key] !== undefined && source[key] !== null && source[key] !== "") return source[key];
  }
  return undefined;
}

export function textOf(record: unknown, keys: string[], fallback = "Not available") {
  const value = valueOf(record, keys);
  return typeof value === "string" || typeof value === "number" ? String(value) : fallback;
}

export function listOf<T = unknown>(record: unknown, keys: string[]): T[] {
  const value = valueOf(record, keys);
  return Array.isArray(value) ? (value as T[]) : [];
}

export function percent(value: unknown) {
  if (value === undefined || value === null || value === "") return "Not available";
  if (typeof value === "number") return `${value}%`;
  return String(value).includes("%") ? String(value) : `${value}%`;
}
