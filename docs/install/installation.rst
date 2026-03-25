.. meta::
   :description: MONAI is a domain-optimized, open-source framework based on PyTorch, designed specifically for deep learning in healthcare imaging.
   :keywords: ROCm-LS, life sciences, MONAI for AMD ROCm installation, Build MONAI for AMD ROCm

.. _installing-monai:

============================
MONAI on ROCm installation
============================

To install MONAI on ROCm, you have the following options:

- :ref:`Use package manager <package-install>` (recommended)

- :ref:`Build from source <source-install>`

System requirements
--------------------

- Ubuntu version: 22.04

- ROCm version:  6.4.3

- Python version: 3.10

- AMD Instinct™ GPU: MI300X

- `PyTorch for AMD ROCm <https://pytorch.org/blog/pytorch-for-amd-rocm-platform-now-available-as-python-package/>`_ version: 2.8.0+rocm 6.4

- NumPy version: No earlier than 1.24 and no later than 2.4

For the complete list of dependencies, see the `requirements.txt <https://github.com/ROCm-LS/monai/blob/main/requirements.txt>`_ file.

.. _package-install:

Installing using package manager
----------------------------------

To install MONAI on ROCm using package manager, follow the steps given in this section.

1. Set up the Docker image using the ROCm Docker image from Docker Hub.

   .. code-block:: shell

      docker pull rocm/dev-ubuntu-22.04
      docker run --cap-add=SYS_PTRACE --ipc=host --privileged=true   \
         --shm-size=512GB --network=host --device=/dev/kfd     \
         --device=/dev/dri --group-add video -it               \
         -v $HOME:$HOME  --name ${LOGNAME}_rocm                \
                                           rocm/dev-ubuntu-22.04

2. Install the required system dependencies.

   .. code-block:: shell

      sudo apt update
      sudo apt install -y software-properties-common lsb-release gnupg
      sudo apt-key adv --fetch-keys https://apt.kitware.com/keys/kitware-archive-latest.asc
      sudo add-apt-repository -y "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"
      sudo apt update
      sudo apt install -y git wget gcc g++ ninja-build git-lfs       \
                        yasm libopenslide-dev python3.10-venv        \
                        cmake rocjpeg rocjpeg-dev rocthrust-dev      \
                        hipcub hipblas hipblas-dev hipfft hipsparse  \
                        hiprand rocsolver rocrand-dev rocm-hip-sdk

3. Create and activate the development environment.

   .. code-block:: shell

      python3 -m venv monai_dev
      source monai_dev/bin/activate
      pip install --upgrade pip

4. Install the required Python dependencies.

   .. code-block:: shell

      pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.4
      pip install amd-hipcim --extra-index-url=https://pypi.amd.com/simple

5. Install the optional dependencies depending on the workload.

   .. code-block:: shell

      pip install ITK nibabel gdown tqdm lmdb psutil pandas einops mlflow \
            pynrrd clearml transformers pydicom fire ignite         \
            parameterized tensorboard pytorch-ignite onnx

6. Install MONAI on ROCm from the AMD PyPI repository.

   .. code-block:: shell

      pip install amd-monai --extra-index-url=https://pypi.amd.com/simple

.. _source-install:

Building from source
-----------------------

To build MONAI on ROCm from source, follow the steps given in this section.

1. Set up the Docker image using the ROCm Docker image from Docker Hub.

   .. code-block:: shell

      docker pull rocm/dev-ubuntu-22.04
      docker run --cap-add=SYS_PTRACE --ipc=host --privileged=true   \
         --shm-size=512GB --network=host --device=/dev/kfd     \
         --device=/dev/dri --group-add video -it               \
         -v $HOME:$HOME  --name ${LOGNAME}_monai               \
                                           rocm/dev-ubuntu-22.04:6.4.1

2. Install the required system dependencies.

   .. code-block:: shell

      sudo apt update
      sudo apt install -y software-properties-common lsb-release gnupg
      sudo apt-key adv --fetch-keys https://apt.kitware.com/keys/kitware-archive-latest.asc
      sudo add-apt-repository -y "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"
      sudo apt update
      sudo apt install -y git wget gcc g++ ninja-build git-lfs       \
                  yasm libopenslide-dev python3.10-venv        \
                  cmake rocjpeg rocjpeg-dev rocthrust-dev      \
                  hipcub hipblas hipblas-dev hipfft hipsparse  \
                  hiprand rocsolver rocrand-dev rocm-hip-sdk

3. Download the latest version of MONAI on ROCm from the GitHub repository:

   .. code-block:: shell

      git clone git@github.com:ROCm-LS/monai.git
      cd monai

4. Create and activate the development environment for building MONAI on ROCm.

   .. code-block:: shell

      python3 -m venv monai_dev
      source monai_dev/bin/activate
      pip install --upgrade pip
      pip install torch torchvision torchaudio      \
                  --index-url https://download.pytorch.org/whl/rocm6.4
      pip install amd-hipcim --extra-index-url=https://pypi.amd.com/simple
      pip install -r requirements-dev.txt -c amd-constraints.txt

5. Build and install MONAI on ROCm on a ROCm-based AMD system using the development environment.

   To build and install the development version of MONAI on ROCm, use:

   .. code-block:: shell

      BUILD_MONAI=1 FORCE_CUDA=1 python3 setup.py develop

   To build and package an optimized wheel for installation, use:

   .. code-block:: shell

      BUILD_MONAI=1 FORCE_CUDA=1 python3 setup.py develop -O1 bdist_wheel

   The preceding command builds the package in non-debug mode and the wheel file is generated under the ``dist`` directory.

Verify installation
--------------------

Use these commands to verify the MONAI on ROCm installation:

- Print the MONAI on ROCm version.

  .. code-block:: shell

   $ python -c "import monai; print(monai.__version__)"

   1.5.0

- Print the MONAI on ROCm package info.

  .. code-block:: shell

   $ pip show -v amd-monai

   Name: amd-monai
   Version: 1.0.0
   Summary: AI Toolkit for Healthcare Imaging
   Home-page: https://rocm.docs.amd.com/projects/monai/en/latest/
   Author: AMD Corporation
   Author-email:
   License: Apache License 2.0
   Location: /scratch/users/souchatt/docker/souchatt_monai/monai
   Editable project location: /scratch/users/souchatt/docker/souchatt_monai/monai
   Requires: numpy, torch
   Required-by:
   Metadata-Version: 2.1
   Installer:
   Classifiers:
      Intended Audience :: Developers
      Intended Audience :: Education
      Intended Audience :: Science/Research
      Intended Audience :: Healthcare Industry
      Programming Language :: C++
      Programming Language :: Python :: 3
      Programming Language :: Python :: 3.10
      Topic :: Scientific/Engineering
      Topic :: Scientific/Engineering :: Artificial Intelligence
      Topic :: Scientific/Engineering :: Medical Science Apps.
      Topic :: Scientific/Engineering :: Information Analysis
      Topic :: Software Development
      Topic :: Software Development :: Libraries
      Typing :: Typed
   Entry-points:
   Project-URLs:
      Documentation, https://rocm.docs.amd.com/projects/monai/en/latest/
      Bug Tracker, https://github.com/ROCm-LS/monai/issues
      Source Code, https://github.com/ROCm-LS/monai/
