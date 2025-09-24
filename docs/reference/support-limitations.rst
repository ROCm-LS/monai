.. meta::
   :description: MONAI is a domain-optimized, open-source framework based on PyTorch, designed specifically for deep learning in healthcare imaging.
   :keywords: ROCm-LS, life sciences, MONAI for AMD ROCm features, MONAI for AMD ROCm limitations, MONAI for AMD ROCm known issues

.. _monai-features:

===================================
Supported features and limitations
===================================

MONAI 1.0.0 for AMD ROCm is based on `MONAI upstream version 1.5.0 <https://github.com/Project-MONAI/MONAI/commit/d388d1c6fec8cb3a0eebee5b5a0b9776ca59ca83>`_ and includes the following features and limitations.

Features
---------

Here are the MONAI for AMD ROCm features:

- Deep learning inference

  - Accelerated inference for MONAI models using AMD ROCm and `HIP <https://rocm.docs.amd.com/projects/HIP/en/latest/>`_ backends.

  - Supports common MONAI model architectures for segmentation, classification, and registration, along with advanced AI capabilities such as generative models, federated learning, and AutoML.

- Seamless integration with `hipCIM <https://rocm.docs.amd.com/projects/hipCIM/en/latest/index.html>`_

  - Supports hipCIM for pre-processing and post-processing of medical images.

  - Efficiently handles whole-slide imaging (WSI) data through GPU-optimized implementations of color augmentation, spatial transformations, and intensity scaling.

  - Provides accelerated transforms, morphological operations, and data augmentation that outperform CPU-only pipelines, particularly in workflows such as whole-slide imaging, patch extraction, and real-time augmentation.

- GPU acceleration

  - Leverages AMD Instinct GPUs for high-throughput inference.

  - Delivers optimized memory and compute performance for large-scale medical datasets.

- Extensibility

  - Compatible with MONAI's modular design.

  - Supports Python APIs and plugin-based extensions.

- Interoperability

  - Works with `PyTorch for AMD ROCm <https://pytorch.org/blog/pytorch-for-amd-rocm-platform-now-available-as-python-package/>`_.

  - Compatible with CuPy and other GPU-accelerated libraries.

- Optimized for 3D medical imaging

  - Supports CT, MRI, Ultrasound, and other volumetric modalities with domain-specific optimizations.

- Prebuilt training pipelines optimized for AMD Instinct GPUs

  - Supports segmentation, classification, and detection tasks, reducing setup overhead.

- Model Zoo with pretrained models

  - Provides access to a wide collection of pretrained models from the `MONAI Model Zoo <https://monai.io/model-zoo.html#/>`_, which is a hub for researchers and data scientists to share, discover, and deploy the latest models from across the biomedical imaging community.

  - Facilitates utilizing the `MONAI Bundle format <https://docs.monai.io/en/latest/bundle_intro.html>`_ to easily `get started <https://github.com/Project-MONAI/tutorials/tree/main/model_zoo>`_ on building workflows or integrating new models into your projects.

  - Provides seamless compatibility with the vast majority of models in the Model Zoo, helping both researchers and clinicians to accelerate state-of-the-art AI pipelines directly on AMD Instinct GPUs.

  - Requires minimal setup as segmentation, detection, and classification models including 2D and 3D workflows run out of the box.

Limitations
------------

- MONAI for AMD ROCm only supports features from amd-cupy > 13.5.1 and hipCIM >= 1.0.00.

- There is no support for:

  - GPU direct storage (KvikIO, cuFile).

  - rocTX tracing.

