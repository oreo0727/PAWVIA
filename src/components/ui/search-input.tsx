import { Search } from "lucide-react";
import { InputHTMLAttributes } from "react";
import { cn } from "@/lib/utils";

export function SearchInput({ className, ...props }: InputHTMLAttributes<HTMLInputElement>) {
  return (
    <label className={cn("relative block", className)}>
      <span className="sr-only">{props["aria-label"] ?? props.placeholder ?? "Search"}</span>
      <Search className="pointer-events-none absolute left-4 top-1/2 h-5 w-5 -translate-y-1/2 text-stone-500" />
      <input
        {...props}
        className="h-full w-full rounded-full border border-stone-200 bg-white py-3 pl-12 pr-4 text-base text-stone-950 shadow-sm transition placeholder:text-stone-500 focus:border-teal-700"
      />
    </label>
  );
}
