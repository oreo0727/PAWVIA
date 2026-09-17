import Link from "next/link";
import { PageHeading } from "@/components/page-heading";
import { SearchInput } from "@/components/ui/search-input";
import { Button } from "@/components/ui/button";
import { EmptyState, ErrorState } from "@/components/ui/states";
import { getIngredients } from "@/lib/petfood-api/ingredients";
import { textOf } from "@/lib/utils";

export default async function IngredientsPage({ searchParams }: PageProps<"/ingredients">) {
  const params = await searchParams;
  try {
    const results = await getIngredients({ q: typeof params.q === "string" ? params.q : undefined, pageSize: 30 });
    return (
      <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6">
        <PageHeading title="Ingredients" body="Explore ingredient records without unsupported health claims or scoring." />
        <form className="mb-6 flex gap-3 rounded-2xl border border-stone-200 bg-white p-3">
          <SearchInput name="q" defaultValue={typeof params.q === "string" ? params.q : ""} placeholder="Search ingredients" className="min-h-12 flex-1" />
          <Button type="submit">Search</Button>
        </form>
        {results.items.length ? <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">{results.items.map((ingredient, index) => {
          const id = textOf(ingredient, ["id", "ingredientId", "slug"], String(index));
          return <Link key={id} href={`/ingredients/${id}`} className="rounded-2xl border border-stone-200 bg-white p-5 hover:border-teal-300"><span className="font-semibold text-stone-950">{textOf(ingredient, ["name", "displayName"], "Unnamed ingredient")}</span><span className="mt-2 block text-sm text-stone-600">{textOf(ingredient, ["category"], "")}</span></Link>;
        })}</div> : <EmptyState title="No ingredients found." />}
      </div>
    );
  } catch (error) {
    return <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6"><PageHeading title="Ingredients" /><ErrorState error={error} /></div>;
  }
}
