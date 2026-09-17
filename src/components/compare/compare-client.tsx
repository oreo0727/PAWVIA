"use client";

import { X } from "lucide-react";
import { useCompare } from "./compare-provider";

export function CompareSelection() {
  const { items, remove, clear } = useCompare();
  if (!items.length) return <p className="text-sm text-stone-600">Add 2 to 5 foods from search results or product pages to compare them here.</p>;
  return (
    <div className="space-y-3">
      <div className="flex flex-wrap gap-2">
        {items.map((item) => (
          <span key={item.id} className="inline-flex items-center gap-2 rounded-full bg-teal-50 px-3 py-2 text-sm font-medium text-teal-950">
            {item.name}
            <button type="button" onClick={() => remove(item.id)} aria-label={`Remove ${item.name}`}>
              <X className="h-4 w-4" />
            </button>
          </span>
        ))}
      </div>
      <button type="button" onClick={clear} className="text-sm font-semibold text-stone-600 underline">Clear comparison</button>
    </div>
  );
}
