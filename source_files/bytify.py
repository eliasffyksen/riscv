#!/usr/bin/env python3
from sys import stdin

for line in stdin:
    line = line[:-1]
    nline = ''
    while len(line):
        nline += line[-2:] + '\n'
        line = line[:-2]
    print(nline, end='')
