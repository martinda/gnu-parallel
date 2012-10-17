#!/usr/bin/env python

from distutils.core import setup

setup(
    name = 'gnuparallel',
    version = '0.1',
    description = 'Load GNU parallel result files.',
    author = 'Drew Frank',
    author_email = 'drewfrank@gmail.com',
    packages = [
        'gnuparallel'
    ],
    install_requires = ['pandas']
)
