.. meta::
   :description: MONAI is a domain-optimized, open-source framework based on PyTorch, designed specifically for deep learning in healthcare imaging.
   :keywords: ROCm-LS, life sciences, MONAI for AMD ROCm installation, Build MONAI for AMD ROCm

.. _installing-monai:

==============================
Installing MONAI for AMD ROCm
==============================

This topic discusses how to install MONAI for AMD ROCm using the following options:

- :ref:`From source (for developers) <source-install>`

- :ref:`Using package manager (for users) <package-install>`

System requirements
--------------------

- Ubuntu version: 22.04

- ROCm version:  6.4.3

- Python version: 3.10

- AMD GPU: AMD Instinct MI300X GPUs

- `PyTorch for AMD ROCm <https://pytorch.org/blog/pytorch-for-amd-rocm-platform-now-available-as-python-package/>`_ version: 2.8.0+rocm 6.4

- NumPy 1.24 and later and earlier than 3.0

For more information about dependencies, see the ``requirements*.txt`` file.

.. _source-install:

Installing from source
-----------------------

To build MONAI for AMD ROCm from source, follow the steps given in this section. This installation method should be used by MONAI for AMD ROCm developers. If you're a MONAI for AMD ROCm user, see :ref:`package-install`.

1. Set up the Docker image using ROCm Docker image from Dockerhub.

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

3. Download the MONAI for AMD ROCm repository.

   Checkout the latest version of MONAI for AMD ROCm from the git repository:

   .. code-block:: shell

      git clone git@github.com:ROCm-LS/monai.git
      cd monai

4. Create and activate the development environment for building MONAI for AMD ROCm.

   .. code-block:: shell

      python3 -m venv monai_dev
      source monai_dev/bin/activate
      pip install --upgrade pip
      pip install torch torchvision torchaudio      \
                  --index-url https://download.pytorch.org/whl/rocm6.4
      pip install amd-hipcim --extra-index-url=https://pypi.amd.com/simple
      pip install -r requirements-dev.txt -c amd-constraints.txt

5. Build and install MONAI for AMD ROCm on a ROCm based AMD system using the development environment.

   To build and install the development version of MONAI for AMD ROCm, use:

   .. code-block:: shell

      BUILD_MONAI=1 FORCE_CUDA=1 python3 setup.py develop

   To build and package an optimized wheel for installation, use:

   .. code-block:: shell

      BUILD_MONAI=1 FORCE_CUDA=1 python3 setup.py develop -O1 bdist_wheel

   The preceding command builds the package in non-debug mode and the wheel file is generated under the ``dist`` directory.

.. _package-install:

Installing using package manager
----------------------------------

To install MONAI for AMD ROCm using package manager, follow the steps given in this section. This installation method should be used by MONAI for AMD ROCm users. If you're a MONAI for AMD ROCm developer, see :ref:`source-install`

1. Set up the Docker image using ROCm Docker image from Dockerhub.

   .. code-block:: shell

      docker pull rocm/dev-ubuntu-22.04
      docker run --cap-add=SYS_PTRACE --ipc=host --privileged=true   \
         --shm-size=512GB --network=host --device=/dev/kfd     \
         --device=/dev/dri --group-add video -it               \
         -v $HOME:$HOME  --name ${LOGNAME}_rocm                \
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

6. Install MONAI optimized for AMD Instinct GPUs from the AMD PyPi repository.

   .. code-block:: shell

      pip install amd-monai --extra-index-url=https://pypi.amd.com/simple

Verify installation
--------------------

Use these commands to verify the MONAI for AMD ROCm installation:

- Print MONAI for AMD ROCm version.

  .. code-block:: shell

   $ python -c "import monai; print(monai.__version__)"

   1.0.0

- Print MONAI for AMD ROCm package info.

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
