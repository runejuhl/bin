#!/usr/bin/env python

# As we can't setuid interpreted scripts, we can do the following instead:

# cython --embed brightness.py
# gcc -I/usr/include/python2.7 -lpython2.7 -o brightness brightness.c
# chown root brightness
# chmod u+s brightness

from sys import argv

MAX = int(open('/sys/class/backlight/intel_backlight/max_brightness').read().strip())
ACTUAL = int(open('/sys/class/backlight/intel_backlight/actual_brightness').read().strip())
LEVELS = 10
STEP = int(MAX/LEVELS)

if len(argv) > 1 and argv[1] == 'down':
    STEP *= -1

value = ACTUAL+STEP
if value < 0:
    value = 0
if value > MAX:
    value = MAX

with open('/sys/class/backlight/intel_backlight/brightness', 'w') as f:
    f.write(str(value))
