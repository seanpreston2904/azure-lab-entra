#!/usr/bin/env python3
"""Turn a `terraform plan -no-color` text capture into a PR-friendly markdown
comment: one collapsible <details> block per resource change."""

import re
import sys

ACTION_LABELS = [
    (re.compile(r"will be created$"), "\U0001F7E2 Create"),
    (re.compile(r"will be destroyed$"), "\U0001F534 Destroy"),
    (re.compile(r"will be updated in-place$"), "\U0001F7E1 Update"),
    (re.compile(r"will be replaced$"), "\U0001F7E0 Replace"),
    (re.compile(r"must be replaced$"), "\U0001F7E0 Replace"),
    (re.compile(r"will be read during apply$"), "\U0001F535 Read"),
    (re.compile(r"will be imported$"), "\U0001F535 Import"),
]

HEADER_RE = re.compile(r"^  # (.+?) (will be .+|must be replaced)$")


def label_for(header_text: str) -> str:
    for pattern, label in ACTION_LABELS:
        if pattern.search(header_text):
            return label
    return "⚪ Change"


def split_blocks(lines: list[str]) -> list[list[str]]:
    blocks: list[list[str]] = []
    current: list[str] | None = None

    for line in lines:
        if HEADER_RE.match(line):
            if current:
                blocks.append(current)
            current = [line]
        elif current is not None:
            if line == "" or line.startswith("Plan:"):
                blocks.append(current)
                current = None
            else:
                current.append(line)

    if current:
        blocks.append(current)

    return blocks


def main() -> None:
    solution = sys.argv[1]
    plan_path = sys.argv[2]

    with open(plan_path) as f:
        lines = f.read().splitlines()

    summary_line = next(
        (
            l
            for l in lines
            if l.startswith("Plan:") or l.startswith("No changes.") or l.startswith("Error:")
        ),
        None,
    )

    blocks = split_blocks(lines)

    marker = f"<!-- terraform-plan:{solution} -->"
    parts = [marker, f"### Terraform Plan — `{solution}`"]

    if summary_line:
        parts.append(f"**{summary_line.strip()}**")

    if not blocks:
        if not summary_line or not summary_line.startswith("No changes"):
            parts.append("```\n" + "\n".join(lines[-60:]) + "\n```")
    else:
        for block in blocks:
            header = block[0]
            match = HEADER_RE.match(header)
            address = match.group(1) if match else "resource"
            label = label_for(header)
            body = "\n".join(block)
            parts.append(
                f"<details>\n<summary>{label} — <code>{address}</code></summary>\n\n"
                f"```hcl\n{body}\n```\n\n</details>"
            )

    print("\n\n".join(parts))


if __name__ == "__main__":
    main()
