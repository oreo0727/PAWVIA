import Link from "next/link";
import { ButtonHTMLAttributes, ReactNode } from "react";
import { cn } from "@/lib/utils";

type Props = ButtonHTMLAttributes<HTMLButtonElement> & {
  variant?: "primary" | "secondary" | "ghost";
  size?: "md" | "lg";
  asChild?: boolean;
  href?: string;
  children: ReactNode;
};

export function Button({ className, variant = "primary", size = "md", asChild, href, children, ...props }: Props) {
  const classes = cn(
    "inline-flex items-center justify-center gap-2 rounded-full font-semibold transition disabled:cursor-not-allowed disabled:opacity-50",
    size === "lg" ? "min-h-14 px-6 text-base" : "min-h-11 px-4 text-sm",
    variant === "primary" && "bg-teal-800 text-white hover:bg-teal-900",
    variant === "secondary" && "border border-stone-200 bg-white text-stone-950 hover:bg-stone-50",
    variant === "ghost" && "text-stone-700 hover:bg-stone-100",
    className,
  );
  if (asChild && href) return <Link href={href} className={classes}>{children}</Link>;
  return <button className={classes} {...props}>{children}</button>;
}
