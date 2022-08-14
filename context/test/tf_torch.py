def test():
    # from pycaret.datasets import get_data
    # from pycaret.classification import setup
    import tensorflow as tf
    import torch

    # data = get_data('diabetes')
    # setup(data, target='Class variable', use_gpu=True, silent=True)
    assert tf.test.is_gpu_available()
    assert torch.cuda.is_available()
