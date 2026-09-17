const copy: Record<string, { label: string; text: string; tone: string }> = {
  UNVERIFIED: { label: "Unverified", text: "Data source confidence has not been established.", tone: "bg-stone-100 text-stone-700" },
  COMMUNITY: { label: "Community Data", text: "This product information comes from community/open data and has not yet been verified against the manufacturer.", tone: "bg-amber-100 text-amber-900" },
  MANUFACTURER_VERIFIED: { label: "Manufacturer Verified", text: "Product information has been checked against manufacturer-provided data.", tone: "bg-teal-100 text-teal-900" },
  PACKAGE_VERIFIED: { label: "Package Verified", text: "Product information has been checked against package label data.", tone: "bg-sky-100 text-sky-900" },
};

export function VerificationBadge({ status }: { status?: unknown }) {
  const key = typeof status === "string" ? status : "UNVERIFIED";
  const item = copy[key] ?? copy.UNVERIFIED;
  return (
    <span title={item.text} className={`inline-flex w-fit items-center rounded-full px-3 py-1 text-xs font-semibold ${item.tone}`}>
      {item.label}
    </span>
  );
}
