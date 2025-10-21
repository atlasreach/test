#!/bin/bash
# Setup script for BLIP captioning on RunPod

echo "🚀 Setting up BLIP Image Captioning..."

# Check if we're on the right machine
if ! command -v nvidia-smi &> /dev/null; then
    echo "⚠️  Warning: nvidia-smi not found. Are you on the GPU machine?"
fi

# Install dependencies
echo "📦 Installing dependencies..."
pip install torch torchvision transformers pillow tqdm --quiet

# Check CUDA availability
python3 << 'PYCHECK'
import torch
print(f"🔧 CUDA available: {torch.cuda.is_available()}")
if torch.cuda.is_available():
    print(f"🎮 GPU: {torch.cuda.get_device_name(0)}")
PYCHECK

# Create images-repo directory if it doesn't exist
if [ ! -d "../images-repo" ]; then
    echo "📁 Creating ../images-repo directory..."
    mkdir -p ../images-repo
    echo "⚠️  Please add your images to ../images-repo before running the script!"
else
    IMG_COUNT=$(find ../images-repo -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | wc -l)
    echo "🖼️  Found $IMG_COUNT images in ../images-repo"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "To run the captioning script:"
echo "  python3 blip_caption.py"
