#!/bin/bash
# Simple SDXL download script - only essential files

echo "📥 Downloading SDXL base model (essential files only)..."

# Disable hf_transfer
export HF_HUB_ENABLE_HF_TRANSFER=0

python3 << 'EOF'
import os
os.environ["HF_HUB_ENABLE_HF_TRANSFER"] = "0"
from huggingface_hub import snapshot_download
import pathlib

print("🔧 Downloading SDXL base model...")
print("⏳ This will download ~10GB (only PyTorch files, skipping ONNX/Flax/OpenVINO)")

model_path = snapshot_download(
    "stabilityai/stable-diffusion-xl-base-1.0",
    cache_dir="/workspace/models",
    allow_patterns=["*.safetensors", "*.json", "*.txt"],
    ignore_patterns=["*.onnx*", "*openvino*", "*flax*", "*.msgpack"]
)

print(f"\n✅ Model downloaded to: {model_path}")

# Create easy symlink
link = pathlib.Path("/workspace/models/sdxl-base")
if not link.exists():
    link.symlink_to(model_path)
    print(f"📌 Symlink created: {link}")
else:
    print(f"📌 Symlink already exists: {link}")

print("\n🎉 Ready for training!")
print(f"Use this path in training: /workspace/models/sdxl-base")
EOF
