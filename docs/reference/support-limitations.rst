.. meta::
   :description: MONAI is a domain-optimized, open-source framework based on PyTorch, designed specifically for deep learning in healthcare imaging.
   :keywords: ROCm-LS, life sciences, MONAI on ROCm features, MONAI on ROCm limitations, MONAI on ROCm known issues

.. _monai-features:

===================================
Supported features and limitations
===================================

This topic discusses the supported features and limitations of MONAI 1.5.2 on ROCm as compared to the `MONAI upstream version 1.5.2 <https://github.com/Project-MONAI/MONAI/releases/tag/1.5.2>`_.

Supported features
-------------------

- Deep learning inference

  - Accelerated inference for MONAI models using ROCm and `HIP <https://rocm.docs.amd.com/projects/HIP/en/latest/>`_ backends.

  - Supports common MONAI model architectures for segmentation, classification, and registration, as well as advanced AI capabilities such as generative models, federated learning, and AutoML.

- Seamless integration with `hipCIM <https://rocm.docs.amd.com/projects/hipCIM/en/latest/index.html>`_

  - Supports hipCIM for pre-processing and post-processing of medical images.

  - Efficiently handles whole-slide imaging (WSI) data through GPU-optimized implementations of color augmentation, spatial transformations, and intensity scaling.

  - Provides accelerated transforms, morphological operations, and data augmentation that outperform CPU-only pipelines, particularly in workflows such as whole-slide imaging, patch extraction, and real-time augmentation.

- GPU acceleration

  - Leverages AMD Instinct™ GPUs for high-throughput inference.

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

  - Provides access to a wide collection of pretrained models from the `MONAI Model Zoo <https://project-monai.github.io/model-zoo.html#/>`_, ready for fine-tuning on custom datasets.

  - Facilitates using the `MONAI Bundle format <https://monai.readthedocs.io/en/latest/bundle_intro.html>`_ to easily start building workflows or integrating new models into your projects with the help of `tutorials <https://github.com/Project-MONAI/tutorials/tree/main/model_zoo>`_.

For more information about the MONAI Model Zoo, see :ref:`model-zoo`.

Limitations
------------

- MONAI on ROCm only supports features from amd-cupy 13.5.1 and later, and hipCIM 25.10.00 and later.

- There is no support for:

  - GPU direct storage (KvikIO, cuFile).

  - rocTX tracing.
