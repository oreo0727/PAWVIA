import type { Metadata } from "next";
import { AddToCompareButton } from "@/components/compare/add-to-compare-button";
import { IngredientList } from "@/components/product/ingredient-list";
import { brandName, productName } from "@/components/product/product-card";
import { NutritionSection } from "@/components/product/nutrition";
import { VerificationBadge } from "@/components/product/verification-badge";
import { ErrorState } from "@/components/ui/states";
import { getProduct } from "@/lib/petfood-api/products";
import { textOf, valueOf } from "@/lib/utils";

const factRows: Array<[string, string[]]> = [
  ["Calories", ["calories", "kcal", "caloriesPerCup"]],
  ["Barcode", ["barcode", "upc", "ean", "gtin"]],
  ["Nutritional Adequacy", ["nutritionalAdequacy", "aafcoStatement"]],
  ["Sources", ["sources", "sourceUrl", "dataSource"]],
];

export async function generateMetadata({ params }: PageProps<"/foods/[id]">): Promise<Metadata> {
  try {
    const product = await getProduct((await params).id);
    return { title: `${productName(product)} by ${brandName(product)}` };
  } catch {
    return { title: "Food" };
  }
}

export default async function FoodDetailPage({ params }: PageProps<"/foods/[id]">) {
  const id = (await params).id;
  try {
    const product = await getProduct(id);
    return (
      <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6">
        <section className="grid gap-6 lg:grid-cols-[0.8fr_1.2fr]">
          <div className="aspect-[4/3] rounded-[2rem] bg-gradient-to-br from-teal-50 to-amber-50" />
          <div className="flex flex-col justify-center">
            <p className="text-lg font-medium text-stone-600">{brandName(product)}</p>
            <h1 className="mt-2 text-4xl font-semibold tracking-tight text-stone-950">{productName(product)}</h1>
            <p className="mt-3 text-stone-600">{[textOf(product, ["species"], ""), textOf(product, ["foodForm", "form"], "")].filter(Boolean).join(" / ")}</p>
            <div className="mt-5 flex flex-wrap gap-3">
              <VerificationBadge status={valueOf(product, ["verificationStatus", "verification", "sourceStatus"])} />
              <AddToCompareButton product={{ id, name: productName(product), brand: brandName(product) }} />
            </div>
          </div>
        </section>
        <div className="mt-8 grid gap-5">
          <IngredientList product={product} />
          <NutritionSection product={product} />
          <section className="grid gap-4 rounded-2xl border border-stone-200 bg-white p-5 sm:grid-cols-2 lg:grid-cols-4">
            {factRows.map(([label, keys]) => <div key={label}><p className="text-sm text-stone-500">{label}</p><p className="mt-1 font-semibold text-stone-900">{textOf(product, keys)}</p></div>)}
          </section>
        </div>
      </div>
    );
  } catch (error) {
    return <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6"><ErrorState error={error} /></div>;
  }
}
