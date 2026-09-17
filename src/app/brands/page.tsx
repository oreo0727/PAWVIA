import Link from "next/link";
import { PageHeading } from "@/components/page-heading";
import { SearchInput } from "@/components/ui/search-input";
import { Button } from "@/components/ui/button";
import { EmptyState, ErrorState } from "@/components/ui/states";
import { getBrands } from "@/lib/petfood-api/brands";
import { textOf } from "@/lib/utils";

export default async function BrandsPage({ searchParams }: PageProps<"/brands">) {
  const params = await searchParams;
  try {
    const results = await getBrands({ q: typeof params.q === "string" ? params.q : undefined, pageSize: 24 });
    return (
      <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6">
        <PageHeading title="Brands" body="Browse brand records and the products connected to them." />
        <form className="mb-6 flex gap-3 rounded-2xl border border-stone-200 bg-white p-3">
          <SearchInput name="q" defaultValue={typeof params.q === "string" ? params.q : ""} placeholder="Search brands" className="min-h-12 flex-1" />
          <Button type="submit">Search</Button>
        </form>
        {results.items.length ? <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">{results.items.map((brand, index) => {
          const id = textOf(brand, ["id", "brandId", "slug"], String(index));
          return <Link key={id} href={`/brands/${id}`} className="rounded-2xl border border-stone-200 bg-white p-5 font-semibold text-stone-950 hover:border-teal-300">{textOf(brand, ["name", "brandName"], "Unnamed brand")}</Link>;
        })}</div> : <EmptyState title="No brands found." />}
      </div>
    );
  } catch (error) {
    return <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6"><PageHeading title="Brands" /><ErrorState error={error} /></div>;
  }
}
