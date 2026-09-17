import { getProducts } from "@/lib/petfood-api/products";
import { ErrorState, EmptyState } from "@/components/ui/states";
import { ProductCard } from "@/components/product/product-card";
import { SearchInput } from "@/components/ui/search-input";
import { Button } from "@/components/ui/button";
import { PageHeading } from "@/components/page-heading";

export default async function FoodsPage({ searchParams }: PageProps<"/foods">) {
  const params = await searchParams;
  try {
    const results = await getProducts({
      q: typeof params.q === "string" ? params.q : undefined,
      species: typeof params.species === "string" ? params.species : undefined,
      foodForm: typeof params.foodForm === "string" ? params.foodForm : undefined,
      page: typeof params.page === "string" ? Number(params.page) : 1,
      pageSize: 12,
    });
    return (
      <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6">
        <PageHeading title="Foods" body="Search products and inspect label data, nutrition, source status, and ingredients." />
        <form className="mb-6 flex flex-col gap-3 rounded-2xl border border-stone-200 bg-white p-3 sm:flex-row">
          <SearchInput name="q" defaultValue={typeof params.q === "string" ? params.q : ""} placeholder="Search food name, brand, or ingredient" className="min-h-12 flex-1" />
          <select name="species" defaultValue={typeof params.species === "string" ? params.species : ""} className="min-h-12 rounded-full border border-stone-200 bg-white px-4">
            <option value="">Dog and cat</option><option value="Dog">Dog</option><option value="Cat">Cat</option>
          </select>
          <Button type="submit">Search</Button>
        </form>
        {results.items.length ? <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">{results.items.map((product, index) => <ProductCard key={String(product.id ?? index)} product={product} />)}</div> : <EmptyState title="No foods found." />}
      </div>
    );
  } catch (error) {
    return <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6"><PageHeading title="Foods" /><ErrorState error={error} /></div>;
  }
}
