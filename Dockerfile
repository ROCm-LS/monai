# Copyright © Advanced Micro Devices, Inc., or its affiliates.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ARG BASE_IMAGE=rocm/dev-ubuntu-24.04:7.2-complete
FROM ${BASE_IMAGE}

# Install compilers & dependencies
RUN apt-get update                                                        &&  \
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

ENV ROCM_HOME="/opt/rocm"

# Install amdgpu-install package, then amdgpu-lib for mesa-amdgpu-va-drivers, then rocjpeg
# Auto-detects ROCm version from /opt/rocm/.info/version and Ubuntu codename from lsb_release
# URL pattern: https://repo.radeon.com/amdgpu-install/{VERSION}/ubuntu/{CODENAME}/amdgpu-install_{VERSION}.{VERNUM}-1_all.deb
# where VERSION = MAJOR.MINOR if patch=0, else MAJOR.MINOR.PATCH (e.g., 7.2 or 7.0.2)
# where VERNUM = major*10000 + minor*100 + patch (e.g., 7.2.0 -> 70200, 7.0.2 -> 70002)
RUN if ! dpkg -s amdgpu-install >/dev/null 2>&1; then \
        rm -f /etc/apt/sources.list.d/amdgpu.list /etc/apt/sources.list.d/rocm.list && \
        ROCM_VERSION=$(cat /opt/rocm/.info/version) && \
        UBUNTU_CODENAME=$(lsb_release -cs) && \
        echo "Detected ROCm version: ${ROCM_VERSION}, Ubuntu codename: ${UBUNTU_CODENAME}" && \
        MAJOR=$(echo ${ROCM_VERSION} | cut -d. -f1) && \
        MINOR=$(echo ${ROCM_VERSION} | cut -d. -f2) && \
        PATCH=$(echo ${ROCM_VERSION} | cut -d. -f3) && \
        PATCH=${PATCH:-0} && \
        VERNUM=$((MAJOR * 10000 + MINOR * 100 + PATCH)) && \
        if [ "${PATCH}" = "0" ]; then SHORT_VERSION="${MAJOR}.${MINOR}"; else SHORT_VERSION="${MAJOR}.${MINOR}.${PATCH}"; fi && \
        AMDGPU_URL="https://repo.radeon.com/amdgpu-install/${SHORT_VERSION}/ubuntu/${UBUNTU_CODENAME}/amdgpu-install_${SHORT_VERSION}.${VERNUM}-1_all.deb" && \
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

# Create virtual environment first
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install PyTorch with ROCm support (version-dependent index URL)
# Detects PyTorch version from setup.cfg if available
COPY ./setup.cfg /tmp/
RUN echo "========================================" && \
    echo "Detecting PyTorch version..." && \
    echo "========================================" && \
    SETUP_FILE="/tmp/setup.cfg" && \
    if [ -f "${SETUP_FILE}" ]; then \
        TORCH_VERSION_RAW=$(grep -oP 'torch[<=]=\K[0-9]+\.[0-9]+\.[0-9]+' "${SETUP_FILE}" 2>/dev/null | head -1); \
        if [ -n "${TORCH_VERSION_RAW}" ]; then \
            TORCH_VERSION="${TORCH_VERSION_RAW}"; \
            echo "✓ Detected PyTorch version from setup.cfg: ${TORCH_VERSION}"; \
        else \
            echo "⚠ No torch version found in setup.cfg, will use latest"; \
            TORCH_VERSION=""; \
        fi; \
    else \
        echo "⚠ setup.cfg not found, will use latest PyTorch"; \
        TORCH_VERSION=""; \
    fi && \
    ROCM_MINOR_VERSION=$(cat /opt/rocm/.info/version | cut -d. -f2) && \
    if [ "${ROCM_MINOR_VERSION}" -ge 1 ]; then \
        PYTORCH_INDEX_URL="https://download.pytorch.org/whl/rocm7.1"; \
    else \
        PYTORCH_INDEX_URL="https://download.pytorch.org/whl/rocm7.0"; \
    fi && \
    echo "Using PyTorch index URL: ${PYTORCH_INDEX_URL}" && \
    if [ -n "${TORCH_VERSION}" ]; then \
        echo "Installing torch==${TORCH_VERSION} torchvision"; \
        pip install --no-cache-dir "torch==${TORCH_VERSION}" torchvision --index-url "${PYTORCH_INDEX_URL}"; \
    else \
        echo "Installing latest torch torchvision"; \
        pip install --no-cache-dir torch torchvision --index-url "${PYTORCH_INDEX_URL}"; \
    fi

# Install development requirements and amd-hipcim
COPY ./requirements*.txt /tmp/
COPY ./amd-constraints.txt /tmp/

RUN pip install --no-cache-dir --upgrade pip wheel && \
    pip install --no-cache-dir amd-hipcim --extra-index-url=https://pypi.amd.com/rocm-7.0.2/simple/ && \
    pip install --no-cache-dir -r /tmp/requirements-dev.txt -c /tmp/amd-constraints.txt --build-constraint /tmp/amd-constraints.txt

COPY . /monai 

WORKDIR /monai

RUN git config --global --add safe.directory /monai

# Build MONAI from source (editable install)
RUN BUILD_MONAI=1 FORCE_CUDA=1 python3 setup.py develop

# Temporary: Workaround for CuPy 13.5.1, rocm 7.2 issue with gcc include path
ENV CPATH="/usr/lib/gcc/x86_64-linux-gnu/13/include"

RUN python3 -c "import torch; print('Torch version:', torch.__version__)" && \
    python3 -c "import cupy; print('amd cupy version:', cupy.__version__)" && \
    python3 -c "import monai; print('monai version:', monai.__version__)" && \
    python3 -c "import cucim; print('hipcim version:', cucim.__version__)"
