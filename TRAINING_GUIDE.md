# SDXL LoRA Training Guide for RunPod

Complete pipeline to train a custom LoRA model on your images.

## Prerequisites
- RTX 4090 RunPod (24GB VRAM recommended)
- Images and captions ready in `/test`
- `captions_blip.csv` generated

## Step-by-Step Instructions

### Step 1: Create Text Captions
```bash
cd /test
python3 1_create_txt_captions.py
```
This creates `.txt` files next to each image with the caption from your CSV.

### Step 2: Setup Kohya Training Suite
```bash
bash 2_setup_kohya.sh
```
Clones and installs Kohya LoRA training tools.

### Step 3: Download SDXL Base Model
```bash
bash 3_download_sdxl.sh
```
- You'll need a HuggingFace token (free): https://huggingface.co/settings/tokens
- Downloads SDXL 1.0 base model (~6.9GB)

### Step 4: Train Your LoRA
```bash
bash 4_train_lora_rtx4090.sh
```

**Training settings (RTX 4090 optimized):**
- Resolution: 1024x1024
- Batch size: 3
- Steps: 2000 (~10-20 minutes on RTX 4090)
- LoRA rank: 32
- Saves checkpoint every 500 steps

**Output:**
- Checkpoints: `/test/lora_output/nksan_lora-XXXXXX.safetensors`
- Logs: `/test/lora_logs/`

### Step 5: Use Your LoRA

Load the final `.safetensors` file in:
- **ComfyUI**: Add to `models/loras/` folder
- **Automatic1111**: Add to `models/Lora/` folder
- **Fooocus**: Add to `models/loras/` folder

**Example prompt:**
```
nksan-girl woman, red dress, city street, golden hour, photorealistic, professional photography
```

## Troubleshooting

### Out of Memory (OOM)
Edit `4_train_lora_rtx4090.sh`:
- Reduce `--train_batch_size=3` to `2` or `1`
- Reduce `--resolution=1024,1024` to `896,896`

### Training too slow/fast
- **Too slow**: Increase `--train_batch_size`
- **Too fast** (overfit): Increase `--max_train_steps` to 3000+

### Poor quality results
- Train longer (3000-4000 steps)
- Increase `--network_dim=64` and `--network_alpha=64`
- Check your captions are descriptive

## Files Overview
- `1_create_txt_captions.py` - Converts CSV to .txt caption files
- `2_setup_kohya.sh` - Installs Kohya training suite
- `3_download_sdxl.sh` - Downloads SDXL base model
- `4_train_lora_rtx4090.sh` - Main training script
