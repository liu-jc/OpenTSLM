# SPDX-FileCopyrightText: 2025 Stanford University, ETH Zurich, and the project authors (see CONTRIBUTORS.md)
# SPDX-FileCopyrightText: 2025 This source file is part of the OpenTSLM open-source project.
#
# SPDX-License-Identifier: MIT

# constants.py

import os

AMLT_BLOB_ROOT_DIR = os.getenv("AMLT_BLOB_ROOT_DIR")
if AMLT_BLOB_ROOT_DIR is None:
    # Path to this file's directory
    # BASE_DIR = os.path.dirname(os.path.abspath(__file__))
    BASE_DIR = "/home/junchengliu/OpenTSLM_local_nogit/"
else:
    # BASE_DIR = "/mnt/default_storage/juncheng/OpenTSLM"
    BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# Path to raw data directory
RAW_DATA = os.path.join(BASE_DIR, "..", "..", "..", "data")
# RAW_DATA = os.path.join(BASE_DIR, "data")
