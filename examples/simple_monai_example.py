import os
import torch
import matplotlib.pyplot as plt
from monai.transforms import (
    LoadImage,
    EnsureChannelFirst,
    ScaleIntensity,
    ToTensor
)
from monai.data import DataLoader, Dataset

# Define a simple transform to load and preprocess the image
transform = [
    LoadImage(image_only=True),
    EnsureChannelFirst(),
    ScaleIntensity(),
    ToTensor()
]

# Define a simple dataset
data_dir = "/monai_sample_images"
images = [os.path.join(data_dir, f) for f in os.listdir(data_dir) if f.endswith('.nii.gz')]
print("Images found:", images)
dataset = Dataset(data=images, transform=transform)
print("Number of samples in dataset:", len(dataset))

# Create a data loader
data_loader = DataLoader(dataset, batch_size=1, shuffle=True)

# Load and visualize a sample image
for batch_data in data_loader:
    image = batch_data[0][0]
    print("Image shape:", image.shape)
    print("Image data type:", image.dtype)
    print("Image max value:", torch.max(image))
    print("Image min value:", torch.min(image))
    break

