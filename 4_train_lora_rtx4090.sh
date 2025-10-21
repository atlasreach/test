#!/bin/bash
# LoRA Training script optimized for RTX 4090 (24GB VRAM)

# ========== CONFIG ==========
MODEL_DIR="/workspace/models/sdxl-base"  # Adjust if you downloaded elsewhere
DATA_DIR="/test"                          # Your images with .txt captions
OUT_DIR="/test/lora_output"
LOG_DIR="/test/lora_logs"
OUT_NAME="nksan_lora"
# ============================

echo "🎨 Starting SDXL LoRA training..."
echo "📁 Model: $MODEL_DIR"
echo "📁 Data: $DATA_DIR"
echo "📁 Output: $OUT_DIR"
echo ""

# Create output directories
mkdir -p "$OUT_DIR" "$LOG_DIR"

# Navigate to Kohya directory
cd /workspace/kohya_ss 2>/dev/null || cd ~/kohya_ss || { echo "❌ Kohya not found!"; exit 1; }

# RTX 4090 optimized settings (24GB VRAM)
accelerate launch --num_processes=1 --mixed_precision=bf16 train_network.py \
  --sdxl \
  --network_module=networks.lora \
  --pretrained_model_name_or_path "$MODEL_DIR" \
  --train_data_dir "$DATA_DIR" \
  --output_dir "$OUT_DIR" \
  --logging_dir "$LOG_DIR" \
  --output_name "$OUT_NAME" \
  --save_every_n_steps 500 \
  --save_model_as safetensors \
  --caption_extension ".txt" \
  --shuffle_caption \
  --resolution=1024,1024 \
  --train_batch_size=3 \
  --max_train_steps=2000 \
  --optimizer_type=AdamW \
  --learning_rate=1e-4 \
  --unet_lr=1e-4 \
  --text_encoder_lr=5e-5 \
  --lr_scheduler=cosine \
  --lr_warmup_steps=100 \
  --network_dim=32 \
  --network_alpha=32 \
  --gradient_checkpointing \
  --persistent_data_loader_workers \
  --min_bucket_reso=512 \
  --max_bucket_reso=1536 \
  --bucket_reso_steps=64

echo ""
echo "✅ Training complete!"
echo "📦 LoRA checkpoints saved to: $OUT_DIR"
echo ""
echo "Use your trigger word in prompts: 'nksan-girl woman'"
