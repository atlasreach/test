#!/bin/bash
# Fix PyTorch for RTX 5090 (Blackwell architecture)

echo "🔧 Fixing PyTorch installation for RTX 5090..."

# Uninstall current PyTorch
echo "📦 Uninstalling old PyTorch..."
pip uninstall torch torchvision torchaudio -y

# Install PyTorch with CUDA 12.4 (better compatibility with RTX 5090)
echo "📦 Installing PyTorch with CUDA 12.4..."
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

# Verify installation
echo ""
echo "✅ Verifying PyTorch installation:"
python3 << 'EOF'
import torch
print(f"PyTorch version: {torch.__version__}")
print(f"CUDA available: {torch.cuda.is_available()}")
if torch.cuda.is_available():
    print(f"CUDA version: {torch.version.cuda}")
    print(f"GPU: {torch.cuda.get_device_name(0)}")
    print(f"GPU compute capability: {torch.cuda.get_device_capability(0)}")
EOF

echo ""
echo "🚀 Ready to run: python3 blip_caption.py"
