"use client";

import Link from "next/link";
import { GitCompare } from "lucide-react";
import { useCompare } from "./compare-provider";

export function CompareNavLink() {
  const { items } = useCompare();
  return (
    <Link href="/compare" className="inline-flex items-center gap-2 rounded-full px-3 py-2 text-sm font-medium text-stone-700 hover:bg-stone-100">
      <GitCompare className="h-4 w-4" />
      Compare{items.length ? ` (${items.length})` : ""}
    </Link>
  );
}
