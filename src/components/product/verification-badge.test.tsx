import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";
import { VerificationBadge } from "./verification-badge";

describe("VerificationBadge", () => {
  it("labels community data without health claims", () => {
    render(<VerificationBadge status="COMMUNITY" />);
    expect(screen.getByText("Community Data")).toBeInTheDocument();
    expect(screen.queryByText(/healthy|recommended|safe/i)).not.toBeInTheDocument();
  });
});
