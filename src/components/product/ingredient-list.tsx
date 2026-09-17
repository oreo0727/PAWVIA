import Link from "next/link";
import { ApiRecord } from "@/lib/petfood-api/types";
import { listOf, textOf, valueOf } from "@/lib/utils";

export function IngredientList({ product }: { product: ApiRecord }) {
  const ingredients = listOf<ApiRecord | string>(product, ["ingredients", "ingredientList", "labelIngredients"]);
  const raw = textOf(product, ["ingredientText", "ingredientsText", "labelText"], "");
  return (
    <section className="rounded-2xl border border-stone-200 bg-white p-5">
      <h2 className="text-lg font-semibold text-stone-950">Ingredients</h2>
      {ingredients.length ? (
        <ol className="mt-4 space-y-2">
          {ingredients.map((ingredient, index) => {
            const label = typeof ingredient === "string" ? ingredient : textOf(ingredient, ["name", "displayName", "sourceText"]);
            const id = typeof ingredient === "object" ? textOf(ingredient, ["id", "ingredientId"], "") : "";
            return (
              <li key={`${label}-${index}`} className="flex gap-3 rounded-xl bg-stone-50 px-4 py-3">
                <span className="text-sm font-semibold text-stone-500">{index + 1}</span>
                {id ? <Link href={`/ingredients/${id}`} className="font-medium text-teal-900 underline">{label}</Link> : <span className="font-medium text-stone-800">{label}</span>}
              </li>
            );
          })}
        </ol>
      ) : raw ? (
        <p className="mt-4 text-stone-700">{raw}</p>
      ) : (
        <p className="mt-4 text-stone-600">Not available</p>
      )}
      {valueOf(product, ["ingredientText", "ingredientsText"]) && ingredients.length ? <p className="mt-4 text-sm text-stone-600">{textOf(product, ["ingredientText", "ingredientsText"])}</p> : null}
    </section>
  );
}
