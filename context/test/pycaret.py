from pycaret.datasets import get_data
from pycaret.classification import setup


def test():
    data = get_data('diabetes')
    setup(data, target='Class variable', use_gpu=True)
