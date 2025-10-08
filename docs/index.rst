.. meta::
  :description: MONAI is a domain-optimized, open-source framework based on PyTorch, designed specifically for deep learning in healthcare imaging.
  :keywords: ROCm-LS, life sciences, MONAI for AMD ROCm documentation, MONAI for AMD ROCm document

.. _index:

*********************************
MONAI for AMD ROCm documentation
*********************************

The Medical Open Network for AI (MONAI) is a domain-optimized, open-source framework based on PyTorch, explicitly designed for deep learning in healthcare imaging. MONAI 1.0.0 for AMD ROCm is a HIP port of `MONAI upstream version 1.5.0 <https://docs.monai.io/en/1.5.0/whatsnew_1_5.html>`_. It is API-compatible with upstream MONAI without requiring any code changes.

MONAI for AMD ROCm, a ROCm-enabled version of `MONAI <https://monai.io/>`_, is built on top of `PyTorch for AMD ROCm <https://pytorch.org/blog/pytorch-for-amd-rocm-platform-now-available-as-python-package/>`_, helping healthcare and life science innovators to leverage GPU acceleration with AMD Instinct GPUs for high-performance inference and training of medical AI applications.

MONAI for AMD ROCm offers open, scalable, and high-performance solutions for life science and healthcare workloads.

The MONAI for AMD ROCm key features include:

- Flexible preprocessing for multidimensional medical imaging data

- Compositional and portable APIs for smooth integration into existing workflows

- Domain-specific implementations for networks, losses, evaluation metrics, and more

- Customizable design according to user expertise

.. note::

  MONAI for AMD ROCm is in an early access state. Running production workloads is not recommended.

The code is open and hosted at `<https://github.com/ROCm-LS/monai>`_.

The documentation is structured as follows:

.. grid:: 2
  :gutter: 3

  .. grid-item-card:: Install

    * :ref:`Installation <installing-monai>`

  .. grid-item-card:: Reference

    * :ref:`monai-features`
    * :ref:`model-zoo`

  .. grid-item-card:: Related content

    * `MONAI blog <https://rocm.blogs.amd.com/artificial-intelligence/monai-rocm/README.html>`_

To contribute to MONAI for AMD ROCm, refer to
`Contributing to MONAI for AMD ROCm <https://github.com/ROCm-LS/monai/blob/main/CONTRIBUTING.md>`_.

You can find licensing information on the
:doc:`Licensing <license>` page.
