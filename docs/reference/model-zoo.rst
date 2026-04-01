.. meta::
   :description: The MONAI Model Zoo is a hub for researchers and data scientists to share, discover, and deploy the latest models from across the biomedical imaging community.
   :keywords: ROCm-LS, life sciences, MONAI model zoo, Pretrained models, MONAI

.. _model-zoo:

****************
MONAI Model Zoo
****************

The `MONAI Model Zoo <https://project-monai.github.io/model-zoo.html#/>`_ is a hub for researchers and data scientists to share, discover, and deploy the latest models from across the biomedical imaging community. By using the standardized `MONAI Bundle format <https://monai.readthedocs.io/en/latest/bundle_intro.html>`_, you can easily start building workflows or integrating new models into your projects with the help of `tutorials <https://github.com/Project-MONAI/tutorials/tree/main/model_zoo>`_.

MONAI on ROCm provides seamless compatibility with the vast majority of models in the Model Zoo, helping both researchers and clinicians to accelerate state-of-the-art AI pipelines directly on AMD Instinct™ GPUs. Segmentation, detection, and classification models, including 2D and 3D workflows, run out of the box with minimal setup.

EXAONEPath model (hf_exaonepath-crc-msi-predictor) on ROCm
-----------------------------------------------------------

EXAONEPath 2.0 is a foundation model designed to deliver highly efficient, directly supervised patch-level representation learning for whole-slide images (WSIs). Except for a few other model zoo entries designed exclusively for specific hardware, advanced computational pathology models, such as EXAONEPath 2.0, are now supported on AMD hardware.
Unlike typical patch-based self-supervised learning (SSL), EXAONEPath 2.0 leverages end-to-end slide-level supervision for powerful biomarker and molecular characteristic prediction with improved data efficiency.

.. _set-exaonepath:

Setting up EXAONEPath 2.0 on ROCm
-----------------------------------

To run EXAONEPath 2.0 on AMD platforms using MONAI on ROCm, follow these steps:

1. Install MONAI on ROCm. For installation instructions, see :ref:`installing-monai`.

2. Clone the EXAONEPath 2.0 repo:

   .. code-block:: shell

    git clone https://huggingface.co/LGAI-EXAONE/EXAONE-Path-2.0

3. Install EXAONEPath-specific dependencies:

   .. code-block:: shell

    pip install pydantic==2.10.3                   \
            openslide-bin==4.0.0.6             \
            openslide-python==1.4.1            \
            rectangle_packer==2.0.2            \
            opencv-python-headless==4.11.0.86  \
            huggingface_hub

4. Go to the EXAONEPath repo directory:

   .. code-block:: shell

    cd EXAONE-Path-2.0

5. Run inference using EXAONEPath:

   .. code-block:: shell

    (Replace YOUR_HUGGING_FACE_ACCESS_TOKEN with your actual token)

    from exaonepath import EXAONEPathV20
    hf_token = "YOUR_HUGGING_FACE_ACCESS_TOKEN"
    model = EXAONEPathV20.from_pretrained("LGAI-EXAONE/EXAONE-Path-2.0", use_auth_token=hf_token)

    svs_path = "samples/sample.svs"
    patch_features = model(svs_path)[0]
    print(patch_features)

Key takeaways
--------------

- Most MONAI Model Zoo models run out of the box on ROCm, fully utilizing the AMD Instinct GPUs.

- EXAONEPath 2.0 is now supported on AMD platforms using MONAI on ROCm. The setup instructions are provided in :ref:`set-exaonepath`.

This reinforces MONAI on ROCm as a truly open, high-performance AI platform that removes vendor lock-in and unleashes broader access to foundational pathology models.
