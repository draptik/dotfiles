#!/usr/bin/env python3
"""
organize_ebooks.py

Walks a directory tree (including subfolders) containing ebook files in
multiple formats (pdf, epub, mobi, azw3, etc.), groups files that share the
same basename (ignoring extension) regardless of which folder they're
currently in, and places each group into its own new folder.

This produces a clean "one folder per book, all formats inside" structure,
which Calibre's "Add books from folders and sub-folders" action (in its
default single-book-per-folder mode) handles reliably.

USAGE:
    python3 organize_ebooks.py /path/to/source /path/to/output [--copy] [--dry-run]

    /path/to/source   Top-level folder to scan recursively for ebook files.
    /path/to/output   Where the new one-folder-per-book structure will be
                      created. Must not already exist (created for you),
                      or use --into-existing to add into an existing folder.

    --copy            Copy files instead of moving them (originals untouched).
                       Default is to COPY (safer). Use --move to move instead.
    --move            Move files instead of copying (originals removed).
    --dry-run         Show what would happen without touching any files.
    --formats         Comma-separated list of extensions to include
                       (default: pdf,epub,mobi,azw,azw3,fb2,txt,djvu,doc,docx,rtf,cbz,cbr)

BEHAVIOR NOTES:
    - Basename matching ignores extension and is case-insensitive.
      "Dune.pdf" and "dune.EPUB" are treated as the same book.
    - Files with a basename that appears only once (no sibling formats)
      still get their own folder, so nothing is skipped.
    - If two different source folders both contain a file with the same
      basename (e.g. "Dune.pdf" in two different places), they will be
      grouped together as if they were the same book. Review the summary
      printed at the end to catch any unwanted merges before importing
      into Calibre.
    - Existing folder structure in the source is NOT preserved in the
      output; every book gets a fresh folder named after its basename.
    - Filesystem-unsafe characters in basenames are sanitized for the
      new folder names.

RECOMMENDED WORKFLOW:
    1. Run with --dry-run first and read the summary carefully.
    2. Run for real with --copy (default) into a new output folder.
    3. Spot-check a few of the resulting folders.
    4. Point Calibre's "Add books from folders and sub-folders" action
       (single book per folder mode) at the output folder.
    5. Once you've confirmed the Calibre import looks correct, you can
       delete the original source files if you used --copy.
"""

import argparse
import os
import re
import shutil
import sys
from collections import defaultdict

DEFAULT_FORMATS = [
    "pdf",
    "epub",
    "mobi",
    "azw",
    "azw3",
    "fb2",
    "txt",
    "djvu",
    "doc",
    "docx",
    "rtf",
    "cbz",
    "cbr",
]


def sanitize_folder_name(name: str) -> str:
    """Remove characters that are problematic in folder names on common filesystems."""
    name = name.strip()
    name = re.sub(r'[<>:"/\\|?*]', "_", name)
    name = re.sub(r"\s+", " ", name)
    # Avoid trailing dots/spaces (problematic on Windows)
    name = name.rstrip(" .")
    if not name:
        name = "untitled"
    return name


def scan_source(source_dir: str, formats: set) -> dict:
    """
    Walk source_dir recursively, group files by basename (no extension,
    case-insensitive). Returns dict: basename_key -> list of full file paths.
    """
    groups = defaultdict(list)
    for root, _dirs, files in os.walk(source_dir):
        for fname in files:
            stem, ext = os.path.splitext(fname)
            ext = ext.lower().lstrip(".")
            if ext not in formats:
                continue
            key = stem.strip().lower()
            full_path = os.path.join(root, fname)
            groups[key].append(full_path)
    return groups


def print_summary(groups: dict):
    total_files = sum(len(v) for v in groups.values())
    multi_format_books = sum(1 for v in groups.values() if len(v) > 1)
    single_format_books = sum(1 for v in groups.values() if len(v) == 1)

    print("=" * 70)
    print("SCAN SUMMARY")
    print("=" * 70)
    print(f"Total ebook files found:        {total_files}")
    print(f"Books with multiple formats:    {multi_format_books}")
    print(f"Books with only one format:     {single_format_books}")
    print(f"Total book folders to create:   {len(groups)}")
    print()

    # Flag groups where the source files came from more than one directory,
    # since that's the case most likely to be an unwanted accidental merge.
    cross_folder_groups = []
    for key, paths in groups.items():
        parent_dirs = {os.path.dirname(p) for p in paths}
        if len(parent_dirs) > 1:
            cross_folder_groups.append((key, paths))

    if cross_folder_groups:
        print(f"NOTE: {len(cross_folder_groups)} book(s) had matching-basename files")
        print("found in DIFFERENT source folders. Double-check these are really")
        print("the same book before proceeding:")
        print("-" * 70)
        for key, paths in cross_folder_groups[:25]:
            print(f"  '{key}':")
            for p in paths:
                print(f"      {p}")
        if len(cross_folder_groups) > 25:
            print(f"  ... and {len(cross_folder_groups) - 25} more")
        print("-" * 70)
        print()


def organize(groups: dict, output_dir: str, do_move: bool, dry_run: bool):
    os.makedirs(output_dir, exist_ok=True)

    created = 0
    for key, paths in groups.items():
        # Use the basename of the first file (with its original casing) as
        # the folder name, since 'key' itself is lowercased for matching.
        original_stem = os.path.splitext(os.path.basename(paths[0]))[0]
        folder_name = sanitize_folder_name(original_stem)
        dest_folder = os.path.join(output_dir, folder_name)

        # Handle rare case of folder name collisions after sanitizing
        suffix = 1
        final_dest_folder = dest_folder
        while os.path.exists(final_dest_folder) and not dry_run:
            suffix += 1
            final_dest_folder = f"{dest_folder} ({suffix})"
        dest_folder = final_dest_folder

        if dry_run:
            print(f"[DRY RUN] Would create: {dest_folder}")
            for p in paths:
                action = "move" if do_move else "copy"
                print(f"    {action}: {p}")
        else:
            os.makedirs(dest_folder, exist_ok=True)
            for p in paths:
                dest_file = os.path.join(dest_folder, os.path.basename(p))
                # Avoid overwriting if a file with same name already there
                if os.path.exists(dest_file):
                    base, ext = os.path.splitext(dest_file)
                    dest_file = f"{base}_dup{ext}"
                if do_move:
                    shutil.move(p, dest_file)
                else:
                    shutil.copy2(p, dest_file)
            created += 1

    if not dry_run:
        print(f"Done. Created {created} book folder(s) in: {output_dir}")


def main():
    parser = argparse.ArgumentParser(
        description="Reorganize ebook files into one-folder-per-book structure for Calibre import."
    )
    parser.add_argument("source", help="Top-level source folder to scan recursively")
    parser.add_argument("output", help="Destination folder for the organized structure")
    parser.add_argument(
        "--move", action="store_true", help="Move files instead of copying"
    )
    parser.add_argument(
        "--copy",
        action="store_true",
        help="Copy files instead of moving (this is the default; flag provided for explicitness)",
    )
    parser.add_argument(
        "--dry-run", action="store_true", help="Preview without changing any files"
    )
    parser.add_argument(
        "--formats",
        default=",".join(DEFAULT_FORMATS),
        help="Comma-separated list of file extensions to include",
    )
    args = parser.parse_args()

    source_dir = os.path.abspath(args.source)
    output_dir = os.path.abspath(args.output)

    if not os.path.isdir(source_dir):
        print(f"ERROR: source folder does not exist: {source_dir}")
        sys.exit(1)

    if os.path.abspath(source_dir) == os.path.abspath(output_dir):
        print("ERROR: source and output folders must be different.")
        sys.exit(1)

    formats = {f.strip().lower() for f in args.formats.split(",") if f.strip()}

    print(f"Scanning: {source_dir}")
    print(f"Formats included: {', '.join(sorted(formats))}")
    print()

    groups = scan_source(source_dir, formats)

    if not groups:
        print(
            "No matching ebook files found. Check the --formats list and source path."
        )
        sys.exit(0)

    print_summary(groups)

    if args.dry_run:
        print("Running in --dry-run mode. No files will be changed.")
        print()

    organize(groups, output_dir, do_move=args.move, dry_run=args.dry_run)


if __name__ == "__main__":
    main()
