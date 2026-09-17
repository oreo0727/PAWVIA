import { describe, expect, it } from "vitest";
import { normalizeList } from "./normalize";

describe("normalizeList", () => {
  it("supports plain arrays", () => {
    expect(normalizeList([{ id: "1" }]).items).toEqual([{ id: "1" }]);
  });

  it("supports common paged response envelopes", () => {
    const list = normalizeList({ items: [{ id: "1" }], page: 2, totalCount: 12 });
    expect(list.items).toHaveLength(1);
    expect(list.page).toBe(2);
    expect(list.total).toBe(12);
  });
});
