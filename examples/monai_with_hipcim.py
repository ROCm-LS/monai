from cucim import CuImage
from monai.transforms import Compose, ScaleIntensity, RandRotate, ToTensor
import matplotlib.pyplot as plt
import numpy as np
import torch
from monai.transforms import EnsureChannelFirst

# Load image
# Download image and keep in /monai_sample_images/ folder
image_path = "/monai_sample_images/77917-ome_base.tif"
print("Loading image using CuCIM...")
img = CuImage(image_path)
print(f"Image size (W x H): {img.size()}")

# Extract region
region = img.read_region(location=[50000, 40000], size=(512, 512))
region_np = np.array(region)

# Drop alpha if present
if region_np.shape[-1] == 4:
    print("Detected RGBA image, trimming to RGB.")
    region_np = region_np[:, :, :3]

print(f"Region shape (H x W x C): {region_np.shape}")

# MONAI transforms with channel_first=True
monai_transforms = Compose([
    EnsureChannelFirst(channel_dim=-1),  # Makes sure data is [C, H, W]
    ToTensor(),
    ScaleIntensity(),
    RandRotate(range_x=15, prob=1.0)
])

transformed = monai_transforms(region_np)
print(f"Transformed tensor shape: {transformed.shape}")
print(f"Tensor dtype: {transformed.dtype}")
print(f"Min: {torch.min(transformed)}, Max: {torch.max(transformed)}")

# Convert back to HWC for imsave
img_np = transformed.permute(1, 2, 0).numpy()
img_np = np.clip(img_np, 0, 1)
plt.imsave("transformed_patch.png", img_np)
print("Saved transformed RGB patch to 'transformed_patch.png'")
