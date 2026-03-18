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

ARG BASE_IMAGE=rocm/dev-ubuntu-24.04:7.0.2-complete
FROM ${BASE_IMAGE}
RUN cat /etc/os-release
RUN cat /opt/rocm/.info/version

COPY . /monai 

WORKDIR /monai
RUN ls -l /monai
RUN ls -l requirements-dev.txt amd-constraints.txt

ENV HIP_PATH=/opt/rocm
ENV PATH=$HIP_PATH/bin:$PATH
ENV ROCM_PATH=/opt/rocm
ENV LD_LIBRARY_PATH=$HIP_PATH/lib:$LD_LIBRARY_PATH
ENV ROCM_HOME=/opt/rocm
ENV AMDGPU_TARGETS="gfx942"

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

RUN git config --global --add safe.directory /monai

ENV VENV_FOLDER=/monai_dev
ENV PATH="$VENV_FOLDER/bin:$PATH"

# Set up Python virtual environment and install dependencies
RUN python3 -m venv ${VENV_FOLDER} && \
    ${VENV_FOLDER}/bin/pip install --upgrade pip setuptools wheel && \
    ${VENV_FOLDER}/bin/pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm7.0 && \
    ${VENV_FOLDER}/bin/pip install amd-hipcim --extra-index-url=https://pypi.amd.com/rocm-7.0.2/simple && \
    ${VENV_FOLDER}/bin/pip install -r requirements-dev.txt -c amd-constraints.txt --build-constraint amd-constraints.txt


# Build MONAI from source
RUN export BUILD_MONAI=1 && \
    export FORCE_CUDA=1 && \
    ${VENV_FOLDER}/bin/python3 setup.py develop -O1 && \
    ${VENV_FOLDER}/bin/python3 setup.py bdist_wheel
    
RUN ${VENV_FOLDER}/bin/python3 -c "import torch; print('Torch version:', torch.__version__)"
RUN ${VENV_FOLDER}/bin/python3 -c "import cupy; print('amd cupy version:', cupy.__version__)"
RUN ${VENV_FOLDER}/bin/python3 -c "import monai; print('monai version:', monai.__version__)"
RUN ${VENV_FOLDER}/bin/python3 -c "import cucim; print('hipcim version:', cucim.__version__)"