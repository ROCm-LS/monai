.. meta::
   :description: MONAI is a domain-optimized, open-source framework based on PyTorch, designed specifically for deep learning in healthcare imaging.
   :keywords: ROCm-LS, life sciences, MONAI on ROCm installation, Build MONAI for AMD ROCm

.. _installing-monai:

===========================
MONAI on ROCm installation
===========================

To install MONAI on ROCm, you have the following options:

- :ref:`Use package manager <package-install>` (recommended)

- :ref:`Build from source <source-install>`

System requirements
--------------------

.. raw:: html

   <div class="pst-scrollable-table-container">
      <table id="monai-sys-requirements" class="table">
         <thead>
            <tr>
                <th>ROCm version</th>
                <th>Ubuntu version</th>
                <th>Python version</th>
                <th>AMD Instinct™ GPU</th>
                <th>PyTorch for AMD ROCm version</th>
                <th>NumPy version</th>
            </tr>
         </thead>
         <colgroup>
            <col span="1">
            <col span="1">
         </colgroup>
         <tbody class="monai-system">
            <tr>
               <td>7.2.0, 7.0.2</td>
               <td>24.04</td>
               <td>3.12</td>
               <td>MI355X, MI325X, or MI300X</td>
               <td>2.8.0 and later</td>
               <td>No earlier than 1.24 and no later than 2.4</td>
            </tr>
         </tbody>
      </table>
   </div>

For the complete list of dependencies, see the `requirements.txt <https://github.com/ROCm-LS/monai/blob/main/requirements.txt>`_ file.

Setting up the environment
---------------------------

To set up the environment for MONAI on ROCm installation, follow these steps:

1. Set up the Docker image using the ROCm or Ubuntu Docker image from Docker Hub.

   - For ROCm 7.2.0, run:

     .. code-block:: shell

      docker run --cap-add=SYS_PTRACE --ipc=host --privileged=true   \
      --shm-size=512GB --network=host --device=/dev/kfd        \
      --device=/dev/dri --group-add video -it                  \
      -v $HOME:$HOME  --name ${LOGNAME}_monai                  \
                              rocm/dev-ubuntu-24.04:7.2-complete

   - For ROCm 7.0.2, run:

     .. code-block:: shell

      docker run --cap-add=SYS_PTRACE --ipc=host --privileged=true   \
      --shm-size=512GB --network=host --device=/dev/kfd        \
      --device=/dev/dri --group-add video -it                  \
      -v $HOME:$HOME  --name ${LOGNAME}_monai                  \
                            rocm/dev-ubuntu-24.04:7.0.2-complete

2. Install the required system dependencies.

   .. code-block:: shell

      apt-get update                                                        &&  \
      apt-get install -y software-properties-common lsb-release gnupg wget  &&  \
      apt-key adv --fetch-keys                                                  \
                  https://apt.kitware.com/keys/kitware-archive-latest.asc &&  \
      add-apt-repository -y "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" && \
      apt-get update && \
      apt-get install -y --no-install-recommends \
         build-essential git gcc g++ cmake \
         ninja-build yasm python3-venv \
         openssh-client \
         libopenslide-dev libwebp-dev \
         libzstd-dev && \
      rm -rf /var/lib/apt/lists/*

      ROCM_VERSION=$(cat /opt/rocm/.info/version) && \
      UBUNTU_CODENAME=$(lsb_release -cs) && \
      echo "Detected ROCm version: ${ROCM_VERSION}, Ubuntu codename: ${UBUNTU_CODENAME}" && \
      MAJOR=$(echo ${ROCM_VERSION} | cut -d. -f1) && \
      MINOR=$(echo ${ROCM_VERSION} | cut -d. -f2) && \
      PATCH=$(echo ${ROCM_VERSION} | cut -d. -f3) && \
      PATCH=${PATCH:-0} && \
      VERNUM=$((MAJOR * 10000 + MINOR * 100 + PATCH)) && \
      if [ "${PATCH}" = "0" ]; then ROCM_SHORT_VERSION="${MAJOR}.${MINOR}"; else ROCM_SHORT_VERSION="${MAJOR}.${MINOR}.${PATCH}"; fi

      if ! dpkg -s amdgpu-install >/dev/null 2>&1; then \
         rm -f /etc/apt/sources.list.d/amdgpu.list /etc/apt/sources.list.d/rocm.list && \
         AMDGPU_URL="https://repo.radeon.com/amdgpu-install/${ROCM_SHORT_VERSION}/ubuntu/${UBUNTU_CODENAME}/amdgpu-install_${ROCM_SHORT_VERSION}.${VERNUM}-1_all.deb" && \
         echo "Downloading: ${AMDGPU_URL}" && \
         wget "${AMDGPU_URL}" -O amdgpu-install.deb && \
         apt-get update && \
         DEBIAN_FRONTEND=noninteractive apt-get install -y ./amdgpu-install.deb && \
         rm amdgpu-install.deb; \
      else \
         echo "amdgpu-install already present, skipping install"; \
      fi && \
      apt-get update && \
      apt-get install -y --no-install-recommends amdgpu-lib && \
      apt-get install -y --no-install-recommends rocjpeg rocjpeg-dev && \
      rm -rf /var/lib/apt/lists/*

3. Create the Python virtual environment.

   .. code-block:: shell

      python3 -m venv monai_dev
      source monai_dev/bin/activate
      pip install --upgrade pip
      pip install torch torchvision torchaudio      \
                  --index-url https://download.pytorch.org/whl/rocm7.1
      pip install amd-hipcim --extra-index-url=https://pypi.amd.com/rocm-${ROCM_VERSION}/simple/

4. Set the environment variables.

   .. code-block:: shell

      export HIP_PATH=/opt/rocm
      export PATH=$HIP_PATH/bin:$PATH
      export ROCM_PATH=/opt/rocm
      export LD_LIBRARY_PATH=$HIP_PATH/lib:$LD_LIBRARY_PATH
      export ROCM_HOME=/opt/rocm
      export AMDGPU_TARGETS=gfx942
      export HIP_VISIBLE_DEVICES=0

.. _package-install:

Installing using package manager
----------------------------------

For MONAI on ROCm installation using a package manager, follow the steps given in this section.

1. Install the optional system dependencies depending on the workload.

   .. code-block:: shell

      pip install ITK nibabel gdown tqdm lmdb psutil pandas einops mlflow \
                  pynrrd clearml transformers pydicom fire ignite         \
                  parameterized tensorboard pytorch-ignite onnx

2. Install MONAI on ROCm from the AMD PyPI repository.

   .. code-block:: shell

      pip install amd-monai --extra-index-url=https://pypi.amd.com/rocm-${ROCM_VERSION}/simple

.. _source-install:

Building from source
---------------------

To build MONAI on ROCm from source, follow the steps given in this section.

1. Download the latest version of MONAI on ROCm from the GitHub repository.

   .. code-block:: shell

      git clone git@github.com:ROCm-LS/monai.git
      cd monai

2. Create and activate the development environment for building MONAI on ROCm.

   .. code-block:: shell

      pip install -r requirements-dev.txt -c amd-constraints.txt --build-constraint amd-constraints.txt

3. Build and install MONAI on ROCm on a ROCm-based AMD system using the development environment.

   - To build and install the development version of MONAI on ROCm, use:

     .. code-block:: shell

      BUILD_MONAI=1 FORCE_CUDA=1 python3 setup.py develop

   - To build and package an optimized wheel for installation, use:

     .. code-block:: shell

      BUILD_MONAI=1 FORCE_CUDA=1 python3 setup.py develop -O1 bdist_wheel

     The preceding command builds the package in non-debug mode and the wheel file is generated under the ``dist`` directory.

Verify installation
--------------------

Use these commands to verify the MONAI on ROCm installation:

- Print the MONAI on ROCm version.

  .. code-block:: shell

   $ python -c "import monai; print(monai.__version__)"

   1.5.2

- Print the MONAI on ROCm package info.

  .. code-block:: shell

   $ pip show -v amd-monai

   Name: amd-monai
   Version: 1.5.2
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
      Programming Language :: Python :: 3.12
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
