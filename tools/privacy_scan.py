#!/usr/bin/env python3
"""Fail when a public working tree contains common clinical-data hazards."""

from __future__ import annotations

import re
import sys
import zipfile
from pathlib import Path


FORBIDDEN_SUFFIXES = {
    ".mat", ".edf", ".eeg", ".set", ".fdt", ".vhdr", ".vmrk",
    ".dat", ".h5", ".hdf5", ".fig", ".asv", ".xls", ".doc",
    ".docx", ".pdf", ".rtf", ".csv", ".tsv", ".parquet", ".feather",
    ".dcm", ".dicom", ".nii", ".sav",
}
SPREADSHEET_SUFFIXES = {".xlsx", ".xlsm"}
TEXT_SUFFIXES = {
    ".m", ".md", ".txt", ".py", ".r", ".json", ".yml", ".yaml",
    ".cff", ".toml",
}
ABSOLUTE_WINDOWS_PATH = re.compile(r"(?i)(?<![A-Za-z0-9])[A-Z]:[\\/]")
ABSOLUTE_HOME_PATH = re.compile(r"(?i)(?:/home/[^/\s]+|/Users/[^/\s]+)")
SUBJECT_IDENTIFIER = re.compile(
    r"(?i)\b(?:patient|subject|participant|seizure)[-_ ]?0*\d+\b"
)
CASE_IDENTIFIER = re.compile(r"(?i)\bcase[-_]?0*\d+\b")
CHANNEL_IDENTIFIER = re.compile(
    r"(?i)\b(?:channel|electrode|contact)[-_ ]?[A-Za-z]{0,3}\d{1,3}\b"
)
ALLOWED_SPREADSHEET = "Source_Data.xlsx"
EMAIL_ADDRESS = re.compile(r"(?i)\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b")
ORCID_IDENTIFIER = re.compile(r"(?i)\b(?:https?://orcid\.org/)?\d{4}-\d{4}-\d{4}-\d{3}[\dX]\b")
ROW_LEVEL_IDENTIFIER_FIELD = re.compile(
    r"(?i)\b(?:case|patient|participant|subject|seizure|channel|electrode|contact)"
    r"(?:[-_](?:id|label|name|code)|\s+(?:id|identifier|code))\b"
)


def scan_text(text: str, relative: Path, findings: list[str]) -> None:
    if ABSOLUTE_WINDOWS_PATH.search(text) or ABSOLUTE_HOME_PATH.search(text):
        findings.append(f"absolute local path: {relative}")
    if SUBJECT_IDENTIFIER.search(text) or CASE_IDENTIFIER.search(text):
        findings.append(f"participant identifier-like token: {relative}")
    if CHANNEL_IDENTIFIER.search(text):
        findings.append(f"channel identifier-like token: {relative}")
    if ROW_LEVEL_IDENTIFIER_FIELD.search(text):
        findings.append(f"row-level identifier field: {relative}")
    if EMAIL_ADDRESS.search(text):
        findings.append(f"email address: {relative}")
    if ORCID_IDENTIFIER.search(text):
        findings.append(f"ORCID-like identifier: {relative}")


def scan_xlsx(path: Path, relative: Path, findings: list[str]) -> None:
    if path.name != ALLOWED_SPREADSHEET:
        findings.append(f"unapproved spreadsheet: {relative}")
        return
    try:
        with zipfile.ZipFile(path) as archive:
            for member in archive.namelist():
                normalized = member.replace("\\", "/").lower()
                if normalized.startswith(("xl/embeddings/", "xl/externallinks/", "customxml/")):
                    findings.append(f"embedded or externally linked workbook content: {relative}")
                if not member.endswith(".xml"):
                    continue
                payload = archive.read(member).decode("utf-8", errors="replace")
                if normalized in {"docprops/core.xml", "docprops/custom.xml"} and re.search(
                    r"(?is)<(?:dc:creator|cp:lastModifiedBy|property)[^>]*>\s*[^<\s]",
                    payload,
                ):
                    findings.append(f"workbook personal metadata: {relative}")
                scan_text(payload, relative, findings)
    except (OSError, zipfile.BadZipFile) as error:
        findings.append(f"unreadable spreadsheet {relative}: {error}")


def main() -> int:
    root = Path(sys.argv[1] if len(sys.argv) > 1 else ".").resolve()
    findings: list[str] = []

    for path in root.rglob("*"):
        if not path.is_file() or ".git" in path.parts:
            continue
        relative = path.relative_to(root)
        if "back" in relative.parts:
            continue
        # The scanner source necessarily contains the signatures it detects.
        if relative == Path("tools/privacy_scan.py"):
            continue
        lowered_name = path.name.lower()
        if SUBJECT_IDENTIFIER.search(lowered_name) or CASE_IDENTIFIER.search(lowered_name) or CHANNEL_IDENTIFIER.search(lowered_name):
            findings.append(f"identifier-like filename: {relative}")
        suffix = path.suffix.lower()
        if suffix in FORBIDDEN_SUFFIXES:
            findings.append(f"forbidden data type: {relative}")
            continue
        if suffix in SPREADSHEET_SUFFIXES:
            scan_xlsx(path, relative, findings)
            continue
        if suffix not in TEXT_SUFFIXES and path.name not in {".gitignore", ".gitattributes"}:
            continue
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            findings.append(f"unreadable text file: {relative}")
            continue
        scan_text(text, relative, findings)

    if findings:
        print("Privacy scan failed:")
        for finding in sorted(set(findings)):
            print(f"- {finding}")
        return 1

    print("Privacy scan passed: no forbidden data files, local paths, or identifier patterns found.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
