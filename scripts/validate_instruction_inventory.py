#!/usr/bin/env python3
"""Validate the P1 instruction classification inventory."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
INVENTORY = ROOT / "docs" / "audit" / "p1-classification.json"

ALLOWED_CLASSIFICATIONS = {
    "GLOBAL",
    "REPO",
    "SKILL",
    "PROFILE",
    "AGENT",
    "RUNTIME_OBSERVATION",
    "STALE",
    "UNKNOWN",
}

REQUIRED_ITEM_FIELDS = {
    "id",
    "sources",
    "summary",
    "classification",
    "mechanism",
    "evidence_strength",
    "disposition",
    "rationale",
}


def main() -> int:
    data = json.loads(INVENTORY.read_text(encoding="utf-8"))

    source_ids = set()
    for source in data["sources"]:
        source_id = source["id"]
        if source_id in source_ids:
            raise SystemExit(f"duplicate source id: {source_id}")
        source_ids.add(source_id)

        sha = source.get("blob_sha")
        if sha is not None and (len(sha) != 40 or any(c not in "0123456789abcdef" for c in sha)):
            raise SystemExit(f"invalid blob sha for {source_id}: {sha}")

    item_ids = set()
    for item in data["items"]:
        missing = REQUIRED_ITEM_FIELDS - item.keys()
        if missing:
            raise SystemExit(f"{item.get('id', '<unknown>')} missing fields: {sorted(missing)}")

        item_id = item["id"]
        if item_id in item_ids:
            raise SystemExit(f"duplicate item id: {item_id}")
        item_ids.add(item_id)

        if item["classification"] not in ALLOWED_CLASSIFICATIONS:
            raise SystemExit(
                f"{item_id} has invalid classification: {item['classification']}"
            )

        unknown_sources = set(item["sources"]) - source_ids
        if unknown_sources:
            raise SystemExit(
                f"{item_id} references unknown sources: {sorted(unknown_sources)}"
            )

        if not item["summary"].strip() or not item["rationale"].strip():
            raise SystemExit(f"{item_id} has empty summary/rationale")

    required_classes = {"GLOBAL", "REPO", "SKILL", "PROFILE", "AGENT", "RUNTIME_OBSERVATION", "STALE", "UNKNOWN"}
    observed_classes = {item["classification"] for item in data["items"]}
    missing_classes = required_classes - observed_classes
    if missing_classes:
        raise SystemExit(f"classification coverage missing: {sorted(missing_classes)}")

    print(
        f"validated {len(data['items'])} instruction records "
        f"from {len(data['sources'])} versioned sources"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
