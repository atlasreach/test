#!/usr/bin/env python3
"""
Reads captions_blip.csv and creates .txt files next to each image.
Kohya LoRA training expects image.jpg + image.txt pairs.
"""
import csv
import sys
from pathlib import Path

# Config
CSV_PATH = Path("captions_blip.csv")
IMG_DIR = Path(".")  # Images are in /test root directory

def main():
    if not CSV_PATH.exists():
        print(f"❌ Could not find {CSV_PATH}")
        sys.exit(1)

    print(f"📄 Reading captions from {CSV_PATH}")
    print(f"📁 Images directory: {IMG_DIR.resolve()}")

    created = 0
    skipped = 0

    with open(CSV_PATH, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            filename = row["filename"].strip()
            prompt = row["prompt"].strip()

            # Image path (relative to IMG_DIR)
            img_path = IMG_DIR / filename

            if not img_path.exists():
                print(f"⚠️  Skip (missing): {filename}")
                skipped += 1
                continue

            # Create .txt file with same name + .txt extension
            txt_path = img_path.with_suffix(img_path.suffix + ".txt")
            txt_path.write_text(prompt, encoding="utf-8")
            created += 1

    print(f"\n✅ Done!")
    print(f"   Created: {created} caption files")
    if skipped > 0:
        print(f"   Skipped: {skipped} missing images")

if __name__ == "__main__":
    main()
