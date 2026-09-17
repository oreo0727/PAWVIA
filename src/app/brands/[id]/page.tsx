import type { Metadata } from "next";
import { PageHeading } from "@/components/page-heading";
import { ProductCard } from "@/components/product/product-card";
import { EmptyState, ErrorState } from "@/components/ui/states";
import { getBrand, getBrandProducts } from "@/lib/petfood-api/brands";
import { textOf } from "@/lib/utils";

export async function generateMetadata({ params }: PageProps<"/brands/[id]">): Promise<Metadata> {
  try {
    const brand = await getBrand((await params).id);
    return { title: `${textOf(brand, ["name", "brandName"], "Brand")} Pet Foods` };
  } catch {
    return { title: "Brand" };
  }
}

export default async function BrandPage({ params }: PageProps<"/brands/[id]">) {
  const id = (await params).id;
  try {
    const [brand, products] = await Promise.all([getBrand(id), getBrandProducts(id, { pageSize: 24 })]);
    return (
      <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6">
        <PageHeading title={textOf(brand, ["name", "brandName"], "Brand")} body="Products connected to this brand in the PetFood API." />
        {products.items.length ? <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">{products.items.map((product, index) => <ProductCard key={String(product.id ?? index)} product={product} />)}</div> : <EmptyState title="No products found for this brand." />}
      </div>
    );
  } catch (error) {
    return <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6"><ErrorState error={error} /></div>;
  }
}
