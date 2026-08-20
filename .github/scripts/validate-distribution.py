#!/usr/bin/env python3
"""Validate the generated OpenCart distribution archive."""

from __future__ import annotations

import stat
import sys
import zipfile
from pathlib import Path, PurePosixPath


ROOT = Path(__file__).resolve().parents[2]
ARCHIVE = ROOT / "dist" / "OpenCart_4.1.0.3_IT.zip"
MAX_ENTRIES = 50_000
MAX_UNCOMPRESSED_SIZE = 512 * 1024 * 1024
REQUIRED_FILES = {
    "index.php",
    "admin/index.php",
    "install/index.php",
    "system/startup.php",
    "config.php",
    "admin/config.php",
}
EXCLUDED_TOP_LEVEL = {".git", ".github", "dist", "docker"}
EXCLUDED_ROOT_FILES = {
    ".dockerignore",
    "Makefile",
    "build.sh",
    "docker-compose.yml",
}


def fail(message: str) -> None:
    print(f"Distribution validation failed: {message}", file=sys.stderr)
    raise SystemExit(1)


def excluded(relative: str) -> bool:
    path = PurePosixPath(relative)
    parts = path.parts

    if not parts:
        return True
    if parts[0] in EXCLUDED_TOP_LEVEL or relative in EXCLUDED_ROOT_FILES:
        return True
    if relative in {"config.php", "admin/config.php"}:
        return True
    if relative.startswith("system/storage/cache/template/"):
        return True
    if relative.startswith("system/storage/logs/") and relative.endswith(".log"):
        return True
    if relative.startswith("system/storage/session/sess_"):
        return True
    if relative.startswith("image/cache/catalog/"):
        return True
    if path.name in {".DS_Store", "Thumbs.db", "desktop.ini"}:
        return True
    return False


def expected_files() -> set[str]:
    expected: set[str] = set()

    for path in ROOT.rglob("*"):
        if path.is_symlink():
            fail(f"source contains a symbolic link: {path.relative_to(ROOT)}")
        if path.is_file():
            relative = path.relative_to(ROOT).as_posix()
            if not excluded(relative):
                expected.add(relative)

    expected.update({"config.php", "admin/config.php"})
    return expected


def validate_archive(expected: set[str]) -> None:
    if not ARCHIVE.is_file():
        fail(f"missing archive: {ARCHIVE.relative_to(ROOT)}")

    try:
        archive = zipfile.ZipFile(ARCHIVE)
    except (OSError, zipfile.BadZipFile) as error:
        fail(f"archive cannot be opened: {error}")

    with archive:
        entries: dict[str, zipfile.ZipInfo] = {}
        total_size = 0

        if len(archive.infolist()) > MAX_ENTRIES:
            fail(f"archive contains more than {MAX_ENTRIES} entries")

        for info in archive.infolist():
            name = info.filename
            path = PurePosixPath(name)

            if (
                not name
                or "\\" in name
                or path.is_absolute()
                or ".." in path.parts
                or not path.parts
            ):
                fail(f"unsafe archive path: {name!r}")

            if path.parts[0] in EXCLUDED_TOP_LEVEL or name in EXCLUDED_ROOT_FILES:
                fail(f"excluded development file present in archive: {name}")

            file_type = (info.external_attr >> 16) & 0o170000
            if file_type == stat.S_IFLNK:
                fail(f"archive contains a symbolic link: {name}")
            if info.flag_bits & 0x1:
                fail(f"archive contains an encrypted entry: {name}")
            if info.compress_type not in {zipfile.ZIP_STORED, zipfile.ZIP_DEFLATED}:
                fail(f"unsupported compression method for: {name}")

            total_size += info.file_size
            if total_size > MAX_UNCOMPRESSED_SIZE:
                fail("archive exceeds the 512 MiB uncompressed size limit")

            if info.is_dir():
                continue
            if name in entries:
                fail(f"archive contains a duplicate entry: {name}")
            entries[name] = info

        actual = set(entries)
        if actual != expected:
            missing = sorted(expected - actual)[:20]
            extra = sorted(actual - expected)[:20]
            fail(f"archive/source file list mismatch; missing={missing}, extra={extra}")

        missing_required = sorted(REQUIRED_FILES - actual)
        if missing_required:
            fail(f"required runtime files are missing: {missing_required}")

        for config in ("config.php", "admin/config.php"):
            if archive.read(entries[config]) != b"":
                fail(f"{config} must be empty in the distribution")


def main() -> None:
    expected = expected_files()
    validate_archive(expected)
    print(
        f"Validated {ARCHIVE.relative_to(ROOT)} "
        f"with {len(expected)} runtime files."
    )


if __name__ == "__main__":
    main()
