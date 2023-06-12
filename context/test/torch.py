import torch


def test():
    assert torch.cuda.is_available(), "There are no GPUs available for PyTorch!"
