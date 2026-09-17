"use client";

import { GitCompare, X } from "lucide-react";
import { CompareItem, useCompare } from "./compare-provider";

export function AddToCompareButton({ product }: { product: CompareItem }) {
  const compare = useCompare();
  const selected = compare.has(product.id);
  return (
    <button
      type="button"
      onClick={() => selected ? compare.remove(product.id) : compare.add(product)}
      className="inline-flex min-h-9 items-center gap-1.5 rounded-full border border-stone-200 px-3 text-xs font-semibold text-stone-700 transition hover:bg-stone-50"
      aria-pressed={selected}
    >
      {selected ? <X className="h-4 w-4" /> : <GitCompare className="h-4 w-4" />}
      {selected ? "Remove" : "Compare"}
    </button>
  );
}
