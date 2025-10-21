#!/bin/bash
# Download SDXL base model from HuggingFace

echo "📥 Downloading SDXL base model..."

# Install HF CLI if not present
pip install -q huggingface_hub

# Disable hf_transfer
export HF_HUB_ENABLE_HF_TRANSFER=0

echo ""
echo "⚠️  You need a HuggingFace token to download SDXL."
echo "Get one at: https://huggingface.co/settings/tokens"
echo ""

# Login to HF
huggingface-cli login

# Download SDXL base
echo ""
echo "📥 Downloading stabilityai/stable-diffusion-xl-base-1.0..."
python3 << 'EOF'
import os
os.environ["HF_HUB_ENABLE_HF_TRANSFER"] = "0"
from huggingface_hub import snapshot_download
import os

# Download to a clean location
model_path = snapshot_download(
    "stabilityai/stable-diffusion-xl-base-1.0",
    cache_dir="/workspace/models"
)
print(f"\n✅ Model downloaded to: {model_path}")
print(f"\nUse this path in your training script!")

# Create a symlink for easy access
import pathlib
link_path = pathlib.Path("/workspace/models/sdxl-base")
if not link_path.exists():
    link_path.symlink_to(model_path)
    print(f"📌 Symlink created: {link_path}")
EOF
