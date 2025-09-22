.. meta::
   :description: MONAI is a domain-optimized, open-source framework based on PyTorch, designed specifically for deep learning in healthcare imaging.
   :keywords: ROCm-LS, life sciences, MONAI for AMD ROCm features, MONAI for AMD ROCm limitations, MONAI for AMD ROCm known issues

.. _monai-features:

===================================
Supported features and limitations
===================================

MONAI 1.0.0 for AMD ROCm is based on `MONAI upstream version 1.5.0 <https://github.com/Project-MONAI/MONAI/commit/d388d1c6fec8cb3a0eebee5b5a0b9776ca59ca83>`_ and includes the following features.

Features
---------

Here are the MONAI for AMD ROCm features:

- Deep learning inference

  - Accelerated inference for MONAI models using AMD ROCm and `HIP <https://rocm.docs.amd.com/projects/HIP/en/latest/>`_ backends

  - Supports common MONAI model architectures for segmentation, classification, and registration, along with advanced AI capabilities such as generative models, federated learning, and AutoML

- Seamless integration with `hipCIM <https://rocm.docs.amd.com/projects/hipCIM/en/latest/index.html>`_

  - Supports hipCIM for pre-processing and post-processing of medical images

  - Efficient handling of whole-slide imaging (WSI) data through GPU-optimized implementations of color augmentation, spatial transformations, and intensity scaling

  - Accelerated transforms, morphological operations, and data augmentation that outperform CPU-only pipelines, particularly in workflows such as whole-slide imaging, patch extraction, and real-time augmentation

- GPU acceleration

  - Leverages AMD Instinct GPUs for high-throughput inference

  - Optimized memory and compute performance for large-scale medical datasets

- Extensibility

  - Compatible with MONAI's modular design

  - Supports Python APIs and plugin-based extensions

- Interoperability

  - Works with `PyTorch for AMD ROCm <https://pytorch.org/blog/pytorch-for-amd-rocm-platform-now-available-as-python-package/>`_

  - Compatible with CuPy and other GPU-accelerated libraries

- Optimized for 3D medical imaging

  - Supports CT, MRI, Ultrasound, and other volumetric modalities with domain-specific optimizations

- Prebuilt training pipelines optimized for AMD Instinct GPUs

  - Supports segmentation, classification, and detection tasks, reducing setup overhead

- Model Zoo with pretrained models

  - Provides access to a wide collection of pretrained models from the `MONAI Model Zoo <https://github.com/Project-MONAI/model-zoo>`_, ready for fine-tuning on custom datasets

  - Examples include UNet, SegResNet, SwinUNETR, and various organ-specific models

  - Utilizing the `MONAI Bundle format <https://docs.monai.io/en/latest/bundle_intro.html>`_ makes it easy to `get started <https://github.com/Project-MONAI/tutorials/tree/main/model_zoo>`_ on building workflows with MONAI.

Limitations
------------

- MONAI for AMD ROCm only supports features from amd-cupy > 13.4.0 and hipCIM >= 1.0.00

- There is no support for:

  - GPU direct storage (KvikIO, cuFile)

  - rocTX tracing

Known issues
-------------

- No support for Python <3.10 and PyTorch <1.13.1 .

- Deprecated transforms such as AddChannel, AsChannelFirst, and others.

- Some advanced or rare image file formats and non-NIfTI DICOM derivatives might not have first-class support.

- Legacy neural network architectures such as deprecated versions of DynUnet and old TorchVision wrappers are not supported.

- Automatic installation of optional dependencies is not available. Some features require explicit installation.
