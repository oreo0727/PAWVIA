"use client";

import { createContext, ReactNode, useContext, useEffect, useMemo, useState } from "react";

export type CompareItem = { id: string; name: string; brand?: string };

type CompareContextValue = {
  items: CompareItem[];
  add: (item: CompareItem) => void;
  remove: (id: string) => void;
  clear: () => void;
  has: (id: string) => boolean;
};

const CompareContext = createContext<CompareContextValue | undefined>(undefined);
const key = "petfood.compare";

export function CompareProvider({ children }: { children: ReactNode }) {
  const [items, setItems] = useState<CompareItem[]>([]);

  useEffect(() => {
    const raw = window.localStorage.getItem(key);
    if (raw) setItems(JSON.parse(raw));
  }, []);

  useEffect(() => {
    window.localStorage.setItem(key, JSON.stringify(items));
  }, [items]);

  const value = useMemo<CompareContextValue>(() => ({
    items,
    add: (item) => setItems((current) => current.some((p) => p.id === item.id) || current.length >= 5 ? current : [...current, item]),
    remove: (id) => setItems((current) => current.filter((item) => item.id !== id)),
    clear: () => setItems([]),
    has: (id) => items.some((item) => item.id === id),
  }), [items]);

  return <CompareContext.Provider value={value}>{children}</CompareContext.Provider>;
}

export function useCompare() {
  const context = useContext(CompareContext);
  if (!context) throw new Error("useCompare must be used within CompareProvider");
  return context;
}
