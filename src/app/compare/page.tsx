import { CompareSelection } from "@/components/compare/compare-client";
import { PageHeading } from "@/components/page-heading";

const rows = ["Brand", "Product", "Food form", "Protein", "Fat", "Fiber", "Moisture", "Dry matter protein", "Dry matter fat", "Dry matter fiber", "Calories", "Ingredient count", "Verification status"];

export default function ComparePage() {
  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6">
      <PageHeading title="Compare Foods" body="Select 2 to 5 foods and compare factual label fields side by side. No winners, scores, or recommendations." />
      <section className="rounded-2xl border border-stone-200 bg-white p-5">
        <CompareSelection />
      </section>
      <div className="no-scrollbar mt-6 overflow-x-auto rounded-2xl border border-stone-200 bg-white">
        <table className="w-full min-w-[720px] text-left text-sm">
          <thead className="bg-stone-50 text-stone-600"><tr><th className="p-4 font-semibold">Field</th><th className="p-4 font-semibold">Selected foods</th></tr></thead>
          <tbody>
            {rows.map((row) => <tr key={row} className="border-t border-stone-100"><td className="p-4 font-medium text-stone-950">{row}</td><td className="p-4 text-stone-500">Add foods to populate comparison data.</td></tr>)}
          </tbody>
        </table>
      </div>
    </div>
  );
}
