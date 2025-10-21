#!/bin/bash
# Setup Kohya LoRA training suite

echo "🚀 Setting up Kohya LoRA training..."

cd /workspace 2>/dev/null || cd ~ || cd /

# Remove old incomplete installation
if [ -d "kohya_ss" ]; then
    echo "🧹 Removing old Kohya installation..."
    rm -rf kohya_ss
fi

# Clone Kohya
echo "📦 Cloning Kohya ss..."
git clone https://github.com/bmaltais/kohya_ss.git

cd kohya_ss

# Check if train_network.py exists
if [ ! -f "train_network.py" ]; then
    echo "❌ Kohya clone failed or incomplete!"
    exit 1
fi

# Install requirements
echo "📦 Installing dependencies (this may take a few minutes)..."
pip install -r requirements.txt

echo ""
echo "✅ Kohya setup complete!"
echo "📁 Location: $(pwd)"
echo ""
echo "Next steps:"
echo "1. Download SDXL base model (see 3_download_sdxl.sh)"
echo "2. Run training script (see 4_train_lora_rtx4090.sh)"
