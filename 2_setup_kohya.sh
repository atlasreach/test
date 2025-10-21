#!/bin/bash
# Setup Kohya LoRA training suite

echo "🚀 Setting up Kohya LoRA training..."

cd /workspace 2>/dev/null || cd ~ || cd /

# Clone Kohya
if [ ! -d "kohya_ss" ]; then
    echo "📦 Cloning Kohya ss..."
    git clone https://github.com/bmaltais/kohya_ss.git
else
    echo "✅ Kohya already cloned"
fi

cd kohya_ss

# Install requirements
echo "📦 Installing dependencies..."
pip install -r requirements.txt --quiet

echo ""
echo "✅ Kohya setup complete!"
echo ""
echo "Next steps:"
echo "1. Download SDXL base model (see 3_download_sdxl.sh)"
echo "2. Run training script (see 4_train_lora.sh)"
