def test():
    from pycaret.datasets import get_data
    from pycaret.classification import setup
    # import tensorflow as tf
    # import torch

    data = get_data('diabetes')
    setup(data, target='Class variable', use_gpu=True, silent=True)
    # assert tf.config.list_physical_devices('GPU'), "There are no GPUs available for TensorFlow!"
    # assert torch.cuda.is_available(), "There are no GPUs available for PyTorch!"
