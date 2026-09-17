import { ApiRecord } from "@/lib/petfood-api/types";
import { percent, valueOf } from "@/lib/utils";

const guaranteed = [
  ["Protein", ["protein", "crudeProtein", "proteinPercent"]],
  ["Fat", ["fat", "crudeFat", "fatPercent"]],
  ["Fiber", ["fiber", "crudeFiber", "fiberPercent"]],
  ["Moisture", ["moisture", "moisturePercent"]],
] as const;

const dryMatter = [
  ["Dry Matter Protein", ["dryMatterProtein", "proteinDryMatter"]],
  ["Dry Matter Fat", ["dryMatterFat", "fatDryMatter"]],
  ["Dry Matter Fiber", ["dryMatterFiber", "fiberDryMatter"]],
] as const;

export function NutritionSection({ product }: { product: ApiRecord }) {
  const nutrition = (valueOf(product, ["nutrition", "guaranteedAnalysis"]) ?? product) as ApiRecord;
  return (
    <div className="grid gap-4 lg:grid-cols-2">
      <section className="rounded-2xl border border-stone-200 bg-white p-5">
        <h2 className="text-lg font-semibold text-stone-950">Guaranteed Analysis</h2>
        <div className="mt-4 grid grid-cols-2 gap-3">
          {guaranteed.map(([label, keys]) => (
            <div key={label} className="rounded-xl bg-stone-50 p-4">
              <p className="text-sm text-stone-600">{label}</p>
              <p className="mt-1 text-2xl font-semibold text-stone-950">{percent(valueOf(nutrition, [...keys]))}</p>
            </div>
          ))}
        </div>
      </section>
      <section className="rounded-2xl border border-stone-200 bg-white p-5">
        <h2 className="text-lg font-semibold text-stone-950">Dry Matter</h2>
        <p className="mt-2 text-sm leading-6 text-stone-600">Calculated values. Dry matter removes moisture from the calculation, making foods with different moisture levels easier to compare.</p>
        <div className="mt-4 space-y-3">
          {dryMatter.map(([label, keys]) => (
            <div key={label} className="flex items-center justify-between rounded-xl bg-teal-50 px-4 py-3">
              <span className="text-sm font-medium text-teal-950">{label}</span>
              <span className="font-semibold text-teal-950">{percent(valueOf(nutrition, [...keys]))}</span>
            </div>
          ))}
        </div>
      </section>
    </div>
  );
}
