import math
import time
import random

t1 = time.time()
for _ in range(1000000):
    x = random.uniform(-math.pi, math.pi)

    term = 1
    expression = 1
    for i in range(1, 8):
        term = -1 * term / (2 * i * (2 * i - 1))
        term = term * x * x 
        expression = expression + term

print(time.time() - t1)