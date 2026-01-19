# SPDX-FileCopyrightText: 2025 Stanford University, ETH Zurich, and the project authors (see CONTRIBUTORS.md)
# SPDX-License-Identifier: MIT

"""
Distributed training utilities for dataset loading.

In multi-node/multi-GPU training, only rank 0 should download data,
and other processes should wait until the download is complete.
"""

import torch.distributed as dist


def is_main_process() -> bool:
    """Check if this is the main process (rank 0) in distributed training.
    
    Returns True if:
    - Not in distributed mode (single GPU/CPU)
    - In distributed mode and rank == 0
    """
    if dist.is_initialized():
        return dist.get_rank() == 0
    return True


def synchronize_processes():
    """Synchronize all processes in distributed training.
    
    This is a no-op if not in distributed mode.
    Use this after data download to ensure all processes wait for rank 0.
    """
    if dist.is_initialized():
        dist.barrier()


def download_with_distributed_lock(download_func, description: str = "data"):
    """Execute a download function with distributed synchronization.
    
    Only rank 0 executes the download, other ranks wait.
    
    Args:
        download_func: Function to execute (should handle the actual download)
        description: Description of what's being downloaded (for logging)
    
    Usage:
        download_with_distributed_lock(
            lambda: download_my_data(),
            description="MyDataset"
        )
    """
    if is_main_process():
        print(f"Downloading {description} (rank 0 only)...")
        download_func()
        print(f"Download of {description} complete.")
    
    # All processes wait here until rank 0 finishes
    synchronize_processes()
