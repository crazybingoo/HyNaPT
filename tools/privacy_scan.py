#!/usr/bin/env python3
"""Fail when a public working tree contains common clinical-data hazards."""

from __future__ import annotations

import re
import sys
from pathlib import Path


FORBIDDEN_SUFFIXES = {
    ".mat", ".edf", ".eeg", ".set", ".fdt", ".vhdr", ".vmrk",
    ".dat", ".h5", ".hdf5", ".fig", ".asv",
}
TEXT_SUFFIXES = {".m", ".md", ".txt", ".py", ".yml", ".yaml", ".cff"}
ABSOLUTE_WINDOWS_PATH = re.compile(r"(?i)\b[A-Z]:[\\/]")
SUBJECT_IDENTIFIER = re.compile(r"(?i)\b(?:patient|subject)[-_ ]?\d{2,}\b")


def main() -> int:
    root = Path(sys.argv[1] if len(sys.argv) > 1 else ".").resolve()
    findings: list[str] = []

    for path in root.rglob("*"):
        if not path.is_file() or ".git" in path.parts:
            continue
        relative = path.relative_to(root)
        if path.suffix.lower() in FORBIDDEN_SUFFIXES:
            findings.append(f"forbidden data type: {relative}")
            continue
        if path.suffix.lower() not in TEXT_SUFFIXES and path.name not in {
            ".gitignore", ".gitattributes"
        }:
            continue
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            findings.append(f"unreadable text file: {relative}")
            continue
        if ABSOLUTE_WINDOWS_PATH.search(text):
            findings.append(f"absolute local path: {relative}")
        if SUBJECT_IDENTIFIER.search(text):
            findings.append(f"identifier-like token: {relative}")

    if findings:
        print("Privacy scan failed:")
        for finding in findings:
            print(f"- {finding}")
        return 1

    print("Privacy scan passed: no forbidden data files or identifier patterns found.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
