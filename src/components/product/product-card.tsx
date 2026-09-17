import Link from "next/link";
import { ApiRecord } from "@/lib/petfood-api/types";
import { textOf, valueOf } from "@/lib/utils";
import { VerificationBadge } from "./verification-badge";
import { AddToCompareButton } from "@/components/compare/add-to-compare-button";

export function productId(product: ApiRecord) {
  return textOf(product, ["id", "productId", "slug"], "");
}

export function productName(product: ApiRecord) {
  return textOf(product, ["name", "productName", "title"], "Unnamed product");
}

export function brandName(product: ApiRecord) {
  const brand = valueOf(product, ["brand"]);
  return typeof brand === "object" && brand ? textOf(brand, ["name", "brandName"]) : textOf(product, ["brandName", "brand"], "Unknown brand");
}

export function ProductCard({ product }: { product: ApiRecord }) {
  const id = productId(product);
  return (
    <article className="rounded-2xl border border-stone-200 bg-white p-4 shadow-sm">
      <Link href={id ? `/foods/${id}` : "/foods"} className="block">
        <div className="aspect-[4/3] rounded-xl bg-gradient-to-br from-teal-50 to-amber-50" />
        <div className="mt-4">
          <p className="text-sm font-medium text-stone-500">{brandName(product)}</p>
          <h2 className="mt-1 text-lg font-semibold leading-snug text-stone-950">{productName(product)}</h2>
          <p className="mt-2 text-sm text-stone-600">
            {[textOf(product, ["species"], ""), textOf(product, ["foodForm", "form"], "")].filter(Boolean).join(" / ") || "Product details"}
          </p>
        </div>
      </Link>
      <div className="mt-4 flex flex-wrap items-center justify-between gap-3">
        <VerificationBadge status={valueOf(product, ["verificationStatus", "verification", "sourceStatus"])} />
        {id ? <AddToCompareButton product={{ id, name: productName(product), brand: brandName(product) }} /> : null}
      </div>
    </article>
  );
}
