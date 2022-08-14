from pycaret.datasets import get_data
from pycaret.classification import *

data = get_data('diabetes')
setup(data, target='Class variable', use_gpu=True)
