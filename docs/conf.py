# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

import re
import sys
from pathlib import Path

sys.path.append(str(Path(__file__).resolve().parent.parent))


'''
html_theme is usually unchanged (rocm_docs_theme).
flavor defines the site header display, select the flavor for the corresponding portals
flavor options: rocm, rocm-docs-home, rocm-blogs, rocm-ds, instinct, ai-developer-hub, local, generic
'''
html_theme = "rocm_docs_theme"
html_theme_options = {"flavor": "rocm-ls"}

'''
docs_header_version is used to manually configure the version in the header. If
there exists a non-null value mapped to docs_header_version, then the header in
the documentation page will contain the given version string.
'''
# html_context = {
#     "docs_header_version": "25.09"
# }


# This section turns on/off article info
setting_all_article_info = True
all_article_info_os = ["linux"]
all_article_info_author = ""

# Dynamically extract component version
version_number = "1.0.0"

# for PDF output on Read the Docs
project = "MONAI 1.0.0 for AMD ROCm"
author = "Advanced Micro Devices, Inc."
copyright = "Copyright (c) 2025 Advanced Micro Devices, Inc. All rights reserved."
version = version_number
release = version_number

external_toc_path = "./sphinx/_toc.yml" # Defines Table of Content structure definition path

extensions = [
    "rocm_docs",
    "breathe",
    "sphinx.ext.intersphinx",
    "sphinx.ext.autodoc",  # Automatically create API documentation from Python docstrings
    "sphinx.ext.autosummary",
    "sphinx.ext.doctest",
    "sphinx_copybutton",
]

autodoc_default_options = {
    "members": True,
    "undoc-members": True,
    "special-members": "__init__, __getitem__",
    "inherited-members": True,
    "show-inheritance": True,
    "imported-members": False,
    "member-order": "bysource",  # bysource: seems unfortunately not to work for Cython modules
}

html_title = f"{project} documentation"

external_projects_current_project = "MONAI for AMD ROCm"
