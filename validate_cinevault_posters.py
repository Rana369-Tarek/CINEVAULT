from __future__ import annotations

import csv
import hashlib
from collections import defaultdict
from pathlib import Path

try:
    from PIL import Image, UnidentifiedImageError
except ImportError:
    raise SystemExit("Pillow is required. Install it with: py -m pip install pillow")

ROOT = Path(__file__).resolve().parent
POSTER_DIR = ROOT / "assets" / "posters"
DATA_DIR = ROOT / "data"
SUPPORTED = {".jpg", ".jpeg", ".png", ".webp", ".bmp", ".gif"}


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as file:
        for chunk in iter(lambda: file.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def main() -> None:
    if not POSTER_DIR.is_dir():
        raise SystemExit(f"Poster folder not found: {POSTER_DIR}")

    DATA_DIR.mkdir(parents=True, exist_ok=True)
    files = sorted(
        (path for path in POSTER_DIR.iterdir() if path.is_file() and path.suffix.lower() in SUPPORTED),
        key=lambda p: p.name.casefold(),
    )

    hash_to_names: dict[str, list[str]] = defaultdict(list)
    rows: list[dict[str, str | int]] = []
    unreadable: list[str] = []
    nonportrait: list[str] = []

    for path in files:
        row: dict[str, str | int] = {
            "filename": path.name,
            "status": "OK",
            "width": "",
            "height": "",
            "width_height_ratio": "",
            "sha256": "",
            "notes": "",
        }
        try:
            with Image.open(path) as image:
                image.verify()
            with Image.open(path) as image:
                width, height = image.size
                image_format = image.format or "unknown"
            ratio = width / height if height else 0
            digest = sha256_file(path)
            hash_to_names[digest].append(path.name)

            row["width"] = width
            row["height"] = height
            row["width_height_ratio"] = f"{ratio:.3f}"
            row["sha256"] = digest
            row["notes"] = f"Format: {image_format}"

            if width <= 0 or height <= 0:
                row["status"] = "INVALID_DIMENSIONS"
                unreadable.append(path.name)
            elif ratio < 0.40 or ratio > 0.90:
                row["status"] = "REVIEW_ASPECT_RATIO"
                row["notes"] += "; unusual poster ratio; review visually, not auto-rejected"
                nonportrait.append(path.name)
        except (UnidentifiedImageError, OSError, ValueError) as exc:
            row["status"] = "UNREADABLE"
            row["notes"] = str(exc).replace("\n", " ")[:250]
            unreadable.append(path.name)
        rows.append(row)

    duplicates = {digest: names for digest, names in hash_to_names.items() if len(names) > 1}
    duplicate_names = {name for names in duplicates.values() for name in names}
    for row in rows:
        if row["filename"] in duplicate_names and row["status"] == "OK":
            row["status"] = "EXACT_DUPLICATE"
            row["notes"] = (str(row["notes"]) + "; byte-identical duplicate detected; do not delete automatically").strip("; ")

    report_path = DATA_DIR / "poster_validation_report.csv"
    with report_path.open("w", newline="", encoding="utf-8-sig") as report:
        writer = csv.DictWriter(report, fieldnames=["filename", "status", "width", "height", "width_height_ratio", "sha256", "notes"])
        writer.writeheader()
        writer.writerows(rows)

    summary_path = DATA_DIR / "poster_validation_summary.txt"
    valid = sum(1 for row in rows if row["status"] == "OK")
    with summary_path.open("w", encoding="utf-8") as summary:
        summary.write(f"Image files scanned: {len(files)}\n")
        summary.write(f"Readable image files: {len(files) - len(unreadable)}\n")
        summary.write(f"Exact duplicate groups: {len(duplicates)}\n")
        summary.write(f"Files involved in exact duplicates: {len(duplicate_names)}\n")
        summary.write(f"Files needing aspect-ratio visual review: {len(nonportrait)}\n")
        summary.write(f"Unreadable/invalid files: {len(unreadable)}\n")
        summary.write("\nEXACT DUPLICATES (same file content):\n")
        if duplicates:
            for index, names in enumerate(duplicates.values(), 1):
                summary.write(f"{index}. " + " | ".join(names) + "\n")
        else:
            summary.write("None detected.\n")
        summary.write("\nFILES NEEDING VISUAL ASPECT-RATIO REVIEW (not automatically invalid):\n")
        summary.write("\n".join(nonportrait) if nonportrait else "None detected.")
        summary.write("\n\nUNREADABLE FILES:\n")
        summary.write("\n".join(unreadable) if unreadable else "None detected.")
        summary.write("\n\nImportant: this scan verifies file integrity, dimensions, and exact binary duplicates only. It cannot prove that a poster matches the movie/show title; that requires visual review. No poster files were modified or deleted.\n")

    print(f"Image files scanned: {len(files)}")
    print(f"Readable image files: {len(files) - len(unreadable)}")
    print(f"Exact duplicate groups: {len(duplicates)}")
    print(f"Files involved in exact duplicates: {len(duplicate_names)}")
    print(f"Aspect-ratio visual reviews: {len(nonportrait)}")
    print(f"Unreadable files: {len(unreadable)}")
    print(f"Detailed report: {report_path}")
    print(f"Summary: {summary_path}")
    print("No poster files were modified or deleted.")


if __name__ == "__main__":
    main()