import Link from "next/link";
import { Barcode, Bone, Building2, Home, Sprout } from "lucide-react";
import { CompareNavLink } from "@/components/compare/compare-nav-link";

const nav = [
  { href: "/", label: "Home", icon: Home },
  { href: "/foods", label: "Foods", icon: Bone },
  { href: "/brands", label: "Brands", icon: Building2 },
  { href: "/ingredients", label: "Ingredients", icon: Sprout },
];

export function Header() {
  return (
    <header className="sticky top-0 z-20 border-b border-stone-200 bg-[#fbfaf7]/95 backdrop-blur">
      <div className="mx-auto flex max-w-6xl items-center justify-between gap-4 px-4 py-3 sm:px-6">
        <Link href="/" className="text-base font-bold text-stone-950">PetFood Intelligence</Link>
        <nav className="hidden items-center gap-1 md:flex">
          {nav.map(({ href, label }) => <Link key={href} href={href} className="rounded-full px-3 py-2 text-sm font-medium text-stone-700 hover:bg-stone-100">{label}</Link>)}
          <CompareNavLink />
        </nav>
        <Link href="/barcode" className="inline-flex min-h-10 items-center gap-2 rounded-full bg-teal-800 px-4 text-sm font-semibold text-white">
          <Barcode className="h-4 w-4" /> Barcode
        </Link>
      </div>
      <nav className="mx-auto grid max-w-6xl grid-cols-5 border-t border-stone-200 bg-white px-2 py-1 md:hidden">
        {nav.map(({ href, label, icon: Icon }) => (
          <Link key={href} href={href} className="flex flex-col items-center gap-1 rounded-xl px-1 py-2 text-[11px] font-medium text-stone-700">
            <Icon className="h-4 w-4" /> {label}
          </Link>
        ))}
        <Link href="/compare" className="flex flex-col items-center gap-1 rounded-xl px-1 py-2 text-[11px] font-medium text-stone-700">
          <span className="h-4 w-4">≡</span> Compare
        </Link>
      </nav>
    </header>
  );
}
