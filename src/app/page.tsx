import Link from "next/link";
import { Barcode, Beef, Building2, GitCompare, Search, ShieldCheck, Sprout } from "lucide-react";
import { Button } from "@/components/ui/button";
import { SearchInput } from "@/components/ui/search-input";

const links = [
  { href: "/foods", label: "Browse Foods", icon: Beef },
  { href: "/brands", label: "Explore Brands", icon: Building2 },
  { href: "/ingredients", label: "Explore Ingredients", icon: Sprout },
  { href: "/compare", label: "Compare Foods", icon: GitCompare },
];

export default function Home() {
  return (
    <div>
      <section className="mx-auto grid min-h-[calc(100svh-8rem)] max-w-6xl gap-10 px-4 pb-10 pt-8 sm:px-6 lg:grid-cols-[1.1fr_0.9fr] lg:items-center">
        <div className="max-w-2xl">
          <div className="mb-5 inline-flex items-center gap-2 rounded-full border border-teal-200 bg-teal-50 px-3 py-1 text-sm font-medium text-teal-900">
            <ShieldCheck className="h-4 w-4" /> Data source confidence, clearly labeled
          </div>
          <h1 className="text-5xl font-semibold leading-tight text-stone-950 sm:text-6xl">Know what&apos;s in their bowl.</h1>
          <p className="mt-5 max-w-xl text-lg leading-8 text-stone-700">Search dog and cat foods by product, brand, ingredient, or barcode.</p>
          <form action="/foods" className="mt-8 flex flex-col gap-3 sm:flex-row">
            <SearchInput name="q" placeholder="Search foods, brands, or ingredients" className="min-h-14 flex-1" />
            <Button type="submit" size="lg"><Search className="h-5 w-5" /> Search Foods</Button>
          </form>
          <div className="mt-4">
            <Button asChild href="/barcode" variant="secondary"><Barcode className="h-5 w-5" /> Enter Barcode</Button>
          </div>
        </div>
        <div className="rounded-[2rem] border border-stone-200 bg-white p-5 shadow-sm">
          <div className="rounded-[1.5rem] bg-amber-50 p-6">
            <p className="text-sm font-semibold uppercase tracking-wide text-amber-900">How it works</p>
            <ol className="mt-5 space-y-4 text-stone-800">
              {["Find a food", "See what's inside", "Compare the facts"].map((item, index) => (
                <li key={item} className="flex gap-4">
                  <span className="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-white font-semibold text-teal-800 shadow-sm">{index + 1}</span>
                  <span className="pt-1 text-lg font-medium">{item}</span>
                </li>
              ))}
            </ol>
            <p className="mt-6 text-sm leading-6 text-stone-700">Verification describes where product data came from and how confidently it has been checked. It is not a health, safety, or recommendation score.</p>
          </div>
        </div>
      </section>
      <section className="border-y border-stone-200 bg-white">
        <div className="mx-auto grid max-w-6xl gap-3 px-4 py-8 sm:grid-cols-2 sm:px-6 lg:grid-cols-4">
          {links.map(({ href, label, icon: Icon }) => (
            <Link key={href} href={href} className="rounded-2xl border border-stone-200 p-5 transition hover:border-teal-300 hover:bg-teal-50">
              <Icon className="h-6 w-6 text-teal-800" />
              <p className="mt-4 font-semibold text-stone-950">{label}</p>
            </Link>
          ))}
        </div>
      </section>
    </div>
  );
}
