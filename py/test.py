import matplotlib.pyplot as plt
from math import sqrt
import numpy as np
from numpy.lib.function_base import average

r = 100
x_c = 300
y_c = 300

def v1(r, x_c, y_c):
    ps = []
    x = 0
    y = r
    while x <= r:
        y0 = 0
        while y0 < y:
            ps.append((x_c+x, y_c+y0))
            ps.append((x_c+x, y_c-y0))
            ps.append((x_c-x, y_c+y0))
            ps.append((x_c-x, y_c-y0))
            y0 += 1
        y = int(sqrt(r**2 - x**2))
        x += 1
    return ps

def v2(r, x_c, y_c):
    ps = []
    x = 0
    y = 0
    while (x <= r):
        y = 0
        while (y <= r):
            if (x**2 + y**2) <= r**2:
                ps.append((x_c+x, y_c+y))
                ps.append((x_c+x, y_c-y))
                ps.append((x_c-x, y_c+y))
                ps.append((x_c-x, y_c-y))
            y += 1
        x += 1
    return ps

def v3(r):
    t1 = r / 16
    x = r
    y = 0
    ps = []
    while x >= y:
        y0 = 0
        while y0 < y:
            ps.append((x, y0))
            ps.append((y0, x))
            y0 += 1
        # Pixel (x, y) and all symmetric pixels are colored (8 times)
        
        y = y + 1
        t1 = t1 + y
        t2 = t1 - x
        if t2 >= 0:
            t1 = t2
            x = x - 1
    return ps


def v4(r):
    ps = []
    x = 0
    y = r
    s = 3 - 2 * r
    while y >= x:
        y0 = x
        while y0 < y:
            ps.append((x, y0))
            ps.append((y0, x))
            ps.append((x, -y0))
            ps.append((y0, -x))
            ps.append((-x, y0))
            ps.append((-y0, x))
            ps.append((-x, -y0))
            ps.append((-y0, -x))
            y0 += 1
        x += 1
        if s > 0:
            y -= 1
            s = s + 4 *(x-y)+10
        else:
            s = s + 4*x + 6
    return ps

def tr_up(x_left, y_left, base, height):
    ps = []
    
    x = 0
    y = 0
    dydx = height // (base//2)

    while x < base//2:
        y0 = y
        while y0 <= height:
            ps.append((x_left+x, y_left+y0))
            ps.append((x_left-x, y_left+y0))
            y0 +=1
        x += 1
        y += dydx

    return ps

def tr_down(x_left, y_left, base, height):
    ps = []
    
    x = 0
    y = 0
    dydx = height // (base//2)

    while x < base//2:
        y0 = y
        while y0 <= height:
            ps.append((x_left+x, y_left-y0))
            ps.append((x_left-x, y_left-y0))
            y0 +=1
        x += 1
        y += dydx

    return ps

def tr_left(x_left, y_left, base, height):
    ps = []
    
    x = 0
    limitY = 0
    dydx = base//2 / height

    while x < height:
        y = 0
        while y <= limitY:
            ps.append((x_left+x, y_left+y))
            ps.append((x_left+x, y_left-y))
            y +=1
        x += 1
        limitY += dydx

    return ps

def tr_right(x_left, y_left, base, height):
    ps = []
    
    x = 0
    limitY = 0
    dydx = base//2 / height

    while x < height:
        y = 0
        while y <= limitY:
            ps.append((x_left-x, y_left+y))
            ps.append((x_left-x, y_left-y))
            y +=1
        x += 1
        limitY += dydx

    return ps


# import time
#
# t1 = []
# t2 = []
# l1 = 0
# l2 = 0
#
# for i in range(10000):
#     s1 = time.time()
#     p1 = tr_v1(100, 50, 100, 100)
#     ss1 = time.time()
#     t1.append(ss1-s1)
#
#     s2 = time.time()
#     p2 = tr_v2(100, 50, 100, 100)
#     ss2 = time.time()
#     t2.append(ss2 - s2)
#
# print(f'1 -> {average(t1)}, {l1}')
# print(f'2 -> {average(t2)}, {l2}')
# print(f'{average(t2)/average(t1)}')

ps = tr_down(50, 75, 100, 50)
ps2 = tr_up(50, 75, 100, 50)
ps3 = tr_left(50, 75, 100, 50)
ps4 = tr_right(50, 75, 100, 50)
figure, axes = plt.subplots(1)
# axes.scatter([p[0] for p in ps], [p[1] for p in ps])
# axes.scatter([p[0] for p in ps2], [p[1] for p in ps2])
# axes.scatter([p[0] for p in ps3], [p[1] for p in ps3])
axes.scatter([p[0] for p in ps4], [p[1] for p in ps4])
axes.set_aspect(1)
plt.show()
