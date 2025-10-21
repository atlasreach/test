import os, csv, sys
from pathlib import Path
from PIL import Image
import torch
from tqdm import tqdm
from transformers import BlipProcessor, BlipForConditionalGeneration

# -------- CONFIG --------
IMAGE_DIR = Path(".")                 # use images in the current /test repo
OUT_CSV   = "captions_blip.csv"
TRIGGER   = "nksan-girl woman"        # change or "" to remove
MAX_TOKENS = 32
# ------------------------

def main():
    device = "cuda" if torch.cuda.is_available() else "cpu"
    print(f"🔧 Using device: {device}")

    processor = BlipProcessor.from_pretrained("Salesforce/blip-image-captioning-base")
    model = BlipForConditionalGeneration.from_pretrained(
        "Salesforce/blip-image-captioning-base"
    ).to(device)

    exts = {".jpg",".jpeg",".png",".webp"}
    image_paths = [p for p in IMAGE_DIR.rglob("*") if p.suffix.lower() in exts and p.is_file() and '.git' not in str(p)]
    if not image_paths:
        print(f"❌ No images found in {IMAGE_DIR.resolve()}")
        sys.exit(1)

    print(f"🖼️ Found {len(image_paths)} images.\n")

    with open(OUT_CSV, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["filename","prompt"])
        for p in tqdm(image_paths, desc="Captioning"):
            try:
                img = Image.open(p).convert("RGB")
                inputs = processor(images=img, return_tensors="pt").to(device)
                out = model.generate(**inputs, max_new_tokens=MAX_TOKENS)
                caption = processor.decode(out[0], skip_special_tokens=True).strip()
                prompt = f"{TRIGGER}, {caption}" if TRIGGER else caption
                rel = str(p.relative_to(IMAGE_DIR))
                writer.writerow([rel, prompt])
            except Exception as e:
                print(f"⚠️  Failed on {p}: {e}")

    print(f"\n✅ DONE → {OUT_CSV}")

if __name__ == "__main__":
    main()
