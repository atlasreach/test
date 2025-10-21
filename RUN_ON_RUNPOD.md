# Run BLIP Captioning on RunPod

## Quick Start

```bash
# 1. SSH into your RunPod
ssh root@149.36.0.112 -p 25114 -i ~/.ssh/id_ed25519

# 2. Run setup (installs dependencies, checks GPU)
bash setup_and_run.sh

# 3. Make sure images are in ../images-repo

# 4. Run the captioning script
python3 blip_caption.py
```

## Configuration

Edit `blip_caption.py` to adjust:
- `IMAGE_DIR` - where your images are located (default: `../images-repo`)
- `OUT_CSV` - output filename (default: `captions_blip.csv`)
- `TRIGGER` - prefix for captions (default: `"nksan-girl woman"`)

## Output

The script will create `captions_blip.csv` with:
- Column 1: filename (relative path)
- Column 2: prompt (trigger + BLIP caption)
