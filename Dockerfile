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

ARG BASE_IMAGE=rocm/dev-ubuntu-22.04:6.4.1
FROM ${BASE_IMAGE}

COPY . /monai 

WORKDIR /monai
RUN ls -l /monai
RUN ls -l requirements-dev.txt amd-constraints.txt

ENV AMDGPU_TARGETS="gfx942"

# Install dependencies
RUN apt-get update && \
    apt-get install -y software-properties-common lsb-release gnupg && \
    apt-key adv --fetch-keys https://apt.kitware.com/keys/kitware-archive-latest.asc && \
    add-apt-repository -y "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" && \
    apt-get update && \
    apt-get install -y git wget gcc g++ ninja-build git-lfs \
                   yasm libopenslide-dev python3.10 python3.10-venv \
                   cmake rocjpeg rocjpeg-dev rocthrust-dev \
                   hipcub hipblas hipblas-dev hipfft hipsparse \
                   hiprand rocsolver rocrand-dev rocm-hip-sdk

RUN git config --global --add safe.directory /monai

ENV VENV_FOLDER=/monai_dev
ENV PATH="$VENV_FOLDER/bin:$PATH"

# Set up Python virtual environment and install dependencies
RUN python3.10 -m venv ${VENV_FOLDER} && \
    ${VENV_FOLDER}/bin/pip install --upgrade pip setuptools wheel && \
    ${VENV_FOLDER}/bin/pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.4 && \
    ${VENV_FOLDER}/bin/pip install amd-hipcim --extra-index-url=https://pypi.amd.com/simple && \
    ${VENV_FOLDER}/bin/pip install -r requirements-dev.txt -c amd-constraints.txt

# Build MONAI from source
RUN export BUILD_MONAI=1 && \
    export FORCE_CUDA=1 && \
    ${VENV_FOLDER}/bin/python3 setup.py develop -O1 && \
    ${VENV_FOLDER}/bin/python3 setup.py bdist_wheel
    
RUN ${VENV_FOLDER}/bin/python3 -c "import torch; print('Torch version:', torch.__version__)"
RUN ${VENV_FOLDER}/bin/python3 -c "import cupy; print('amd cupy version:', cupy.__version__)"
RUN ${VENV_FOLDER}/bin/python3 -c "import monai; print('monai version:', monai.__version__)"
