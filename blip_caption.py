import os, csv, sys
from pathlib import Path
from PIL import Image
import torch
from tqdm import tqdm
from transformers import BlipProcessor, BlipForConditionalGeneration

# -------- CONFIG --------
IMAGE_DIR = Path("../images-repo")   # folder containing your images
OUT_CSV   = "captions_blip.csv"      # output CSV name
TRIGGER   = "nksan-girl woman"       # prefix token for training prompts
# -------------------------

def main():
    device = "cuda" if torch.cuda.is_available() else "cpu"
    print(f"🔧 Using device: {device}")

    # Load BLIP model
    processor = BlipProcessor.from_pretrained("Salesforce/blip-image-captioning-base")
    model = BlipForConditionalGeneration.from_pretrained(
        "Salesforce/blip-image-captioning-base"
    ).to(device)

    # Collect all image paths
    image_paths = [p for p in IMAGE_DIR.rglob("*") if p.suffix.lower() in {".jpg",".jpeg",".png"}]
    if not image_paths:
        print(f"❌ No images found in {IMAGE_DIR.resolve()}")
        sys.exit(1)
    print(f"🖼️ Found {len(image_paths)} images to caption.\n")

    # Caption each image and write to CSV
    with open(OUT_CSV, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["filename", "prompt"])
        for p in tqdm(image_paths, desc="Captioning"):
            try:
                image = Image.open(p).convert("RGB")
                inputs = processor(images=image, return_tensors="pt").to(device)
                out = model.generate(**inputs, max_new_tokens=32)
                caption = processor.decode(out[0], skip_special_tokens=True).strip()
                if TRIGGER:
                    caption = f"{TRIGGER}, {caption}"
                writer.writerow([str(p.relative_to(IMAGE_DIR)), caption])
            except Exception as e:
                print(f"⚠️  Failed on {p.name}: {e}")

    print(f"\n✅ DONE! Captions saved to → {OUT_CSV}")

if __name__ == "__main__":
    main()
