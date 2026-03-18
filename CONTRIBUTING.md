- [Introduction](#introduction)
- [The contribution process](#the-contribution-process)
  * [Preparing pull requests](#preparing-pull-requests)
    1. [Checking the coding style](#checking-the-coding-style)
    1. [Unit testing](#unit-testing)
    1. [Building the documentation](#building-the-documentation)
    1. [Adding new optional dependencies](#adding-new-optional-dependencies)
    1. [Signing your work](#signing-your-work)
    1. [Utility functions](#utility-functions)
  * [Submitting pull requests](#submitting-pull-requests)


## Introduction


Welcome to Project MONAI for AMD ROCm&trade;! We're excited you're here and want to contribute. This documentation is intended for individuals and institutions interested in contributing to MONAI for AMD ROCm&trade;. MONAI for AMD ROCm&trade; is an open-source project and, as such, its success relies on its community of contributors willing to keep improving it. Your contribution will be a valued addition to the code base; we simply ask that you read this page and understand our contribution process, whether you are a seasoned open-source contributor or whether you are a first-time contributor.

### Communicate with us

We are happy to talk with you about your needs for MONAI for AMD ROCm&trade; and your ideas for contributing to the project. One way to do this is to create an issue discussing your thoughts. It might be that a very similar feature is under development or already exists, so an issue is a great starting point. If you are looking for an issue to resolve that will help Project MONAI, see the [*good first issue*](https://github.com/ROCm-LS/MONAI/labels/good%20first%20issue) and [*Contribution wanted*](https://github.com/ROCm-LS/MONAI/labels/Contribution%20wanted) labels.

### Does it belong in PyTorch for AMD ROCm&trade; instead of MONAI for AMD ROCm&trade;?

MONAI for AMD ROCm&trade; is mainly based on the PyTorch for [AMD ROCm&trade;](https://pytorch.org/blog/pytorch-for-amd-rocm-platform-now-available-as-python-package/) and Numpy libraries. These libraries implement what we consider to be best practice for general scientific computing and deep learning functionality. MONAI for AMD ROCm&trade; builds on these with a strong focus on medical applications. As such, it is a good idea to consider whether your functionality is medical-application specific or not. General deep learning functionality may be better off in PyTorch for AMD ROCm&trade;; you can find their contribution guidelines [here](https://pytorch.org/docs/stable/community/contribution_guide.html).

## The contribution process

_Pull request early_

We encourage you to create pull requests early. It helps us track the contributions under development, whether they are ready to be merged or not. [Create a draft pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/changing-the-stage-of-a-pull-request) until it is ready for formal review.

Please note that, as per PyTorch for AMD ROCm&trade;, MONAI for AMD ROCm&trade; uses American English spelling. This means classes and variables should be: normali**z**e, visuali**z**e, colo~~u~~r, etc.

### Preparing pull requests
To ensure the code quality, MONAI for AMD ROCm&trade; relies on several linting tools ([flake8 and its plugins](https://gitlab.com/pycqa/flake8), [black](https://github.com/psf/black), [isort](https://github.com/timothycrosley/isort), [ruff](https://github.com/astral-sh/ruff)),
static type analysis tools ([mypy](https://github.com/python/mypy), [pytype](https://github.com/google/pytype)), as well as a set of unit/integration tests.

This section highlights all the necessary preparation steps required before sending a pull request.
To collaborate efficiently, please read through this section and follow them.

* [Checking the coding style](#checking-the-coding-style)
* [Licensing information](#licensing-information)
* [Unit testing](#unit-testing)
* [Building documentation](#building-the-documentation)
* [Signing your work](#signing-your-work)

#### Checking the coding style
Coding style is checked and enforced by flake8, black, isort, and ruff, using [a flake8 configuration](./setup.cfg) similar to [PyTorch's](https://github.com/pytorch/pytorch/blob/master/.flake8).
Before submitting a pull request, we recommend that all linting should pass, by running the following command locally:

```bash
# optionally update the dependencies and dev tools
python -m pip install -U pip
python -m pip install -U -r requirements-dev.txt -c amd-constraints.txt

# run the linting and type checking tools
./runtests.sh --codeformat

# try to fix the coding style errors automatically
./runtests.sh --autofix
```

Full linting and type checking may take some time. If you need a quick check, run
```bash
# run ruff only
./runtests.sh --ruff
```

#### Licensing information
All source code files should start with this paragraph:

```
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

```

##### Exporting modules

If you intend for any variables/functions/classes to be available outside of the file with the edited functionality, then:

- Create or append to the `__all__` variable (in the file in which functionality has been added), and
- Add to the `__init__.py` file.

#### Unit testing
MONAI for AMD ROCm&trade; tests are located under `tests/`.

- The unit test's file name currently follows `test_[module_name].py` or `test_[module_name]_dist.py`.
- The `test_[module_name]_dist.py` subset of unit tests requires a distributed environment to verify the module with distributed GPU-based computation.
- The integration test's file name follows `test_integration_[workflow_name].py`.

A bash script (`runtests.sh`) is provided to run all tests locally.
Please run ``./runtests.sh -h`` to see all options.

To run a particular test, for example `tests/losses/test_dice_loss.py`:
```
python -m tests.losses.test_dice_loss
```

Before submitting a pull request, we recommend that all linting and unit tests
should pass, by running the following command locally:

```bash
./runtests.sh -f -u --net --coverage
```
or (for new features that would not break existing functionality):

```bash
./runtests.sh --quick --unittests
```

#### Building the documentation
MONAI for AMD ROCm&trade;'s documentation is located at `docs/`.

```bash
# install the doc-related dependencies
pip install --upgrade pip
pip install -r docs/requirements.txt

# build the docs
cd docs/
make html
```
The above commands build html documentation, they are used to automatically generate [https://docs.monai.io](https://docs.monai.io).

The Python code docstring are written in
[reStructuredText](https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html) and
the documentation pages can be in either [reStructuredText](https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html) or [Markdown](https://en.wikipedia.org/wiki/Markdown).  In general the Python docstrings follow the [Google style](https://google.github.io/styleguide/pyguide.html#38-comments-and-docstrings).

Before submitting a pull request, it is recommended to:
- edit the relevant `.rst` files in [`docs/source`](./docs/source) accordingly.
- build html documentation locally
- check the auto-generated documentation (by browsing `./docs/build/html/index.html` with a web browser)
- type `make clean` in `docs/` folder to remove the current build files.

Please type `make help` in `docs/` folder for all supported format options.


#### Adding new optional dependencies
In addition to the minimal requirements of PyTorch for AMD ROCm&trade; and Numpy, MONAI for AMD ROCm&trade;'s core modules are built optionally based on 3rd-party packages.
The current set of dependencies is listed in [installing dependencies](https://docs.monai.io/en/stable/installation.html#installing-the-recommended-dependencies).

To allow for flexible integration of MONAI for AMD ROCm&trade; with other systems and environments,
the optional dependency APIs are always invoked lazily. For example,
```py
from monai.utils import optional_import
itk, _ = optional_import("itk", ...)

class ITKReader(ImageReader):
    ...
    def read(self, ...):
        return itk.imread(...)
```
The availability of the external `itk.imread` API is not required unless `monai.data.ITKReader.read` is called by the user.
Integration tests with minimal requirements are deployed to ensure this strategy.

To add new optional dependencies, please communicate with the core team during pull request reviews,
and add the necessary information (at least) to the following files:
- [setup.cfg](https://github.com/Project-MONAI/MONAI/blob/dev/setup.cfg)  (for package's `[options.extras_require]` config)
- [requirements-dev.txt](https://github.com/Project-MONAI/MONAI/blob/dev/requirements-dev.txt) (pip requirements file)
- [docs/requirements.txt](https://github.com/Project-MONAI/MONAI/blob/dev/docs/requirements.txt) (docs pip requirements file)
- [environment-dev.yml](https://github.com/Project-MONAI/MONAI/blob/dev/environment-dev.yml) (conda environment file)
- [installation.md](https://github.com/Project-MONAI/MONAI/blob/dev/docs/source/installation.md) (documentation)

When writing unit tests that use 3rd-party packages, it is a good practice to always consider
an appropriate fallback default behaviour when the packages are not installed in
the testing environment. For example:
```py
from monai.utils import optional_import
plt, has_matplotlib = optional_import("matplotlib.pyplot")

@skipUnless(has_matplotlib, "Matplotlib required")
class TestBlendImages(unittest.TestCase):
```
It skips the test cases when `matplotlib.pyplot` APIs are not available.

Alternatively, add the test file name to the ``exclude_cases`` in `tests/min_tests.py` to completely skip the test
cases when running in a minimal setup.



#### Signing your work
MONAI for AMD ROCm&trade; enforces the [Developer Certificate of Origin](https://developercertificate.org/) (DCO) on all pull requests.
All commit messages should contain the `Signed-off-by` line with an email address. The [GitHub DCO app](https://github.com/apps/dco) is deployed on MONAI. The pull request's status will be `failed` if commits do not contain a valid `Signed-off-by` line.

Git has a `-s` (or `--signoff`) command-line option to append this automatically to your commit message:
```bash
git commit -s -m 'a new commit'
```
The commit message will be:
```
    a new commit

    Signed-off-by: Your Name <yourname@example.org>
```

Full text of the DCO:
```
Developer Certificate of Origin
Version 1.1

Copyright (C) 2004, 2006 The Linux Foundation and its contributors.
1 Letterman Drive
Suite D4700
San Francisco, CA, 94129

Everyone is permitted to copy and distribute verbatim copies of this
license document, but changing it is not allowed.


Developer's Certificate of Origin 1.1

By making a contribution to this project, I certify that:

(a) The contribution was created in whole or in part by me and I
    have the right to submit it under the open source license
    indicated in the file; or

(b) The contribution is based upon previous work that, to the best
    of my knowledge, is covered under an appropriate open source
    license and I have the right under that license to submit that
    work with modifications, whether created in whole or in part
    by me, under the same open source license (unless I am
    permitted to submit under a different license), as indicated
    in the file; or

(c) The contribution was provided directly to me by some other
    person who certified (a), (b) or (c) and I have not modified
    it.

(d) I understand and agree that this project and the contribution
    are public and that a record of the contribution (including all
    personal information I submit with it, including my sign-off) is
    maintained indefinitely and may be redistributed consistent with
    this project or the open source license(s) involved.
```

#### Utility functions
MONAI for AMD ROCm&trade; provides a set of generic utility functions and frequently used routines.
These are located in [``monai/utils``](./monai/utils/) and in the module folders such as [``networks/utils.py``](./monai/networks/).
Users are encouraged to use these common routines to improve code readability and reduce the code maintenance burdens.

Notably,
- ``monai.module.export`` decorator can make the module name shorter when importing,
for example, ``import monai.transforms.Spacing`` is the equivalent of ``monai.transforms.spatial.array.Spacing`` if
``class Spacing`` defined in file `monai/transforms/spatial/array.py` is decorated with ``@export("monai.transforms")``.

For string definition, [f-string](https://www.python.org/dev/peps/pep-0498/) is recommended to use over `%-print` and `format-print`. So please try to use `f-string` if you need to define any string object.


### Submitting pull requests
All code changes to the dev branch must be done via [pull requests](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/proposing-changes-to-your-work-with-pull-requests).
1. Create a new ticket or take a known ticket from [the issue list][monai issue list].
1. Check if there's already a branch dedicated to the task.
1. If the task has not been taken, [create a new branch in your fork](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request-from-a-fork)
of the codebase named `[ticket_id]-[task_name]`.
For example, branch name `19-ci-pipeline-setup` corresponds to [issue #19](https://github.com/Project-MONAI/MONAI/issues/19).
Ideally, the new branch should be based on the latest `dev` branch.
1. Make changes to the branch ([use detailed commit messages if possible](https://chris.beams.io/posts/git-commit/)).
1. Make sure that new tests cover the changes and the changed codebase [passes all tests locally](#unit-testing).
1. [Create a new pull request](https://help.github.com/en/desktop/contributing-to-projects/creating-a-pull-request) from the task branch to the dev branch, with detailed descriptions of the purpose of this pull request.
1. Check [the CI/CD status of the pull request][github ci], make sure all CI/CD tests passed.
1. Wait for reviews; if there are reviews, make point-to-point responses, make further code changes if needed.
1. If there are conflicts between the pull request branch and the dev branch, pull the changes from the dev and resolve the conflicts locally.
1. Reviewer and contributor may have discussions back and forth until all comments addressed.
1. Wait for the pull request to be merged.




<p align="right">
  <a href="#introduction">⬆️ Back to Top</a>
</p>
