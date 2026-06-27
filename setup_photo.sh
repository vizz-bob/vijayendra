#!/bin/bash
# Run this once in Terminal to add your profile photo to the portfolio
# Usage: bash setup_photo.sh

SRC="/Volumes/MyCloud1/PiBox_Backup/Bobby/A_laptop_data_after_Concentrix/desktop_Jan2022/Imp_doc_bobby_pics/IMG_20201120_023625.psd"
DEST_DIR="$(dirname "$0")/assets/images"
TMP="/tmp/profile_raw.png"

echo "Converting PSD → PNG..."
sips -s format png "$SRC" --out "$TMP"

echo "Cropping and resizing to 400×400 square..."
python3 - << 'PYEOF'
from PIL import Image
import sys, os

img = Image.open("/tmp/profile_raw.png").convert("RGB")
w, h = img.size

# Square crop from centre (slight upward offset to favour face)
s = min(w, h)
left = (w - s) // 2
top  = max(0, (h - s) // 2 - int(h * 0.05))
img  = img.crop((left, top, left + s, top + s))
img  = img.resize((400, 400), Image.LANCZOS)

out = os.path.join(os.path.dirname(os.path.abspath("/tmp/profile_raw.png")),
                   "profile.jpg").replace("/tmp", 
                   os.path.expanduser("~/Library/Application Support"))

dest = os.path.join(os.path.dirname(os.path.abspath(__file__)) if "__file__" in dir() else ".",
                    "assets/images/profile.jpg")

# Fallback: write alongside script
import subprocess
repo = subprocess.check_output(["dirname", __file__]).decode().strip() if "__file__" in dir() else "."
dest = "/Volumes/Testing/Bobby_GitIO/assets/images/profile.jpg"
os.makedirs(os.path.dirname(dest), exist_ok=True)
img.save(dest, "JPEG", quality=92)
print(f"✓ Saved to {dest}")
PYEOF

echo ""
echo "Done! Your profile photo has been added to assets/images/profile.jpg"
echo "If PIL is not installed, run:  pip3 install Pillow"
