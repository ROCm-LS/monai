<p align="center">
  <img src="https://raw.githubusercontent.com/Project-MONAI/MONAI/dev/docs/images/MONAI-logo-color.png" width="50%" alt='project-monai'>
</p>

**M**edical **O**pen **N**etwork for **AI** for **AMD ROCm&trade;**

MONAI for AMD ROCm is a [PyTorch](https://pytorch.org/)-based, [open-source](LICENSE) framework for deep learning in healthcare imaging, part of the [PyTorch Ecosystem](https://pytorch.org/ecosystem/), enabled for AMD Instinct GPUs.
Its ambitions are as follows:

- Developing a community of academic, industrial and clinical researchers collaborating on a common foundation;
- Creating state-of-the-art, end-to-end training workflows for healthcare imaging;
- Providing researchers with the optimized and standardized way to create and evaluate deep learning models.

## Features

> _Please see [the technical highlights](https://docs.monai.io/en/latest/highlights.html) and [What's New](https://docs.monai.io/en/latest/whatsnew.html) of the milestone releases._

- flexible pre-processing for multi-dimensional medical imaging data;
- compositional & portable APIs for ease of integration in existing workflows;
- domain-specific implementations for networks, losses, evaluation metrics and more;
- customizable design for varying user expertise;
- multi-GPU multi-node data parallelism support.

## Requirements

MONAI for AMD ROCm works with Python 3.10, and depends directly on NumPy and [PyTorch for AMD ROCm](https://pytorch.org/blog/pytorch-for-amd-rocm-platform-now-available-as-python-package/) with many optional dependencies.
* AMD MONAI supports [ROCm-LS/hipCIM](https://rocm.docs.amd.com/projects/hipCIM/en/latest/index.html) for accelerated image loading and processing on AMD Instinct GPUs.
* See the `requirements*.txt` files for dependency version information.

## Installation

To install [the current release](https://pypi.amd.com/simple/amd-monai/), you can simply run:

```bash
pip install amd_monai --extra-index-url=https://pypi.amd.com/simple
```

Please refer to [the installation guide](https://rocm.docs.amd.com/projects/MONAI/en/latest/installation/installation.html) for other installation options.

## Getting Started

[MedNIST demo](https://colab.research.google.com/github/Project-MONAI/tutorials/blob/main/2d_classification/mednist_tutorial.ipynb) and [MONAI for PyTorch Users](https://colab.research.google.com/github/Project-MONAI/tutorials/blob/main/modules/developer_guide.ipynb) are available on Colab.

Examples and notebook tutorials are located at [Project-MONAI/tutorials](https://github.com/Project-MONAI/tutorials).

Technical documentation is available at [MONAI for AMD ROCm documentation](https://rocm.docs.amd.com/projects/MONAI/en/latest/index.html).

## Citation

If you have used MONAI in your research, please cite us! The citation can be exported from: <https://arxiv.org/abs/2211.02701>.

## Model Zoo

[The MONAI Model Zoo](https://github.com/Project-MONAI/model-zoo) is a place for researchers and data scientists to share the latest and great models from the community.
Utilizing [the MONAI Bundle format](https://docs.monai.io/en/latest/bundle_intro.html) makes it easy to [get started](https://github.com/Project-MONAI/tutorials/tree/main/model_zoo) building workflows with MONAI.

## Contributing

For guidance on making a contribution to MONAI, see the [contributing guidelines](CONTRIBUTING.md).

## Community

Join the conversation on Twitter/X [@ProjectMONAI](https://twitter.com/ProjectMONAI), [LinkedIn](https://www.linkedin.com/company/projectmonai), or join our [Slack channel](https://forms.gle/QTxJq3hFictp31UM9).

Ask and answer questions over on [MONAI's GitHub Discussions tab](https://github.com/Project-MONAI/MONAI/discussions).

## Links

- Website: <https://instinct.docs.amd.com/latest/life-science/MONAI.html>
- Code: <https://github.com/ROCm-LS/MONAI>
- Issue tracker: <https://github.com/ROCm-LS/MONAI/issues>
- PyPI package: <https://pypi.amd.com/simple/amd-monai/>
