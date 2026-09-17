import Link from "next/link";
import { Barcode } from "lucide-react";
import { getProductByBarcode } from "@/lib/petfood-api/products";
import { ProductCard } from "@/components/product/product-card";
import { EmptyState, ErrorState } from "@/components/ui/states";
import { Button } from "@/components/ui/button";
import { PageHeading } from "@/components/page-heading";

export default async function BarcodePage({ searchParams }: PageProps<"/barcode">) {
  const params = await searchParams;
  const code = typeof params.code === "string" ? params.code.trim() : "";
  let content = null;
  if (code) {
    try {
      content = <ProductCard product={await getProductByBarcode(code)} />;
    } catch (error) {
      content = <EmptyState title="We don't have this product yet." body="Barcode lookup is ready, and product submission can be added when the backend supports it." />;
      if (!(error instanceof Error)) content = <ErrorState error={error} />;
    }
  }
  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <PageHeading title="Barcode Lookup" body="Enter a UPC, EAN, or GTIN from a package label." />
      <form className="rounded-2xl border border-stone-200 bg-white p-4">
        <label className="text-sm font-semibold text-stone-700" htmlFor="code">UPC / EAN / GTIN</label>
        <div className="mt-2 flex flex-col gap-3 sm:flex-row">
          <input id="code" name="code" defaultValue={code} inputMode="numeric" className="min-h-12 flex-1 rounded-full border border-stone-200 px-4" />
          <Button type="submit"><Barcode className="h-5 w-5" /> Look Up</Button>
        </div>
        <Button asChild href="/barcode" variant="ghost" className="mt-3">Prepare Camera Scan</Button>
      </form>
      <div className="mt-6">{content}</div>
      {code && <Link href="#" className="mt-4 inline-flex text-sm font-semibold text-stone-500 aria-disabled:pointer-events-none" aria-disabled>Submit Product</Link>}
    </div>
  );
}
