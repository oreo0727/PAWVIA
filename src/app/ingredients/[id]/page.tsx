import type { Metadata } from "next";
import { PageHeading } from "@/components/page-heading";
import { ProductCard } from "@/components/product/product-card";
import { EmptyState, ErrorState } from "@/components/ui/states";
import { getIngredient, getIngredientProducts } from "@/lib/petfood-api/ingredients";
import { textOf } from "@/lib/utils";

export async function generateMetadata({ params }: PageProps<"/ingredients/[id]">): Promise<Metadata> {
  try {
    const ingredient = await getIngredient((await params).id);
    return { title: `${textOf(ingredient, ["name", "displayName"], "Ingredient")} in Pet Food` };
  } catch {
    return { title: "Ingredient" };
  }
}

export default async function IngredientPage({ params }: PageProps<"/ingredients/[id]">) {
  const id = (await params).id;
  try {
    const [ingredient, products] = await Promise.all([getIngredient(id), getIngredientProducts(id, { pageSize: 24 })]);
    return (
      <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6">
        <PageHeading title={textOf(ingredient, ["name", "displayName"], "Ingredient")} body={textOf(ingredient, ["description", "category"], "Foods containing this ingredient according to the PetFood API.")} />
        {products.items.length ? <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">{products.items.map((product, index) => <ProductCard key={String(product.id ?? index)} product={product} />)}</div> : <EmptyState title="No matching foods found." />}
      </div>
    );
  } catch (error) {
    return <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6"><ErrorState error={error} /></div>;
  }
}
