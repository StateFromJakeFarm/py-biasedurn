#!/usr/bin/env python3

"""
setup.py file for SWIG example
"""

from shutil import which
from subprocess import run
from distutils.core import setup, Extension

# Use swig to build files required for install
if which('swig') is None:
    raise EnvironmentError('"swig" must be installed and present in PATH')
run('swig -c++ -python biasedurn.i'.split())

# Install module
biasedurn_module = Extension('_biasedurn',
                             define_macros = [('MAXCOLORS', 10000)],
                             sources=['biasedurn_wrap.cxx', 'urn.cpp', 'stoc3.cpp', 
                                      'stoc2.cpp', 'stoc1.cpp', 'wnchyppr.cpp', 
                                      'fnchyppr.cpp', 
                                      'mersenne.cpp', 'mother.cpp', 'userintf.cpp'])
setup(name = 'biasedurn',
      version = '0.1',
      author      = "Vahan Nanumyan",
      description = """First try to bind biased urn to python""",
      ext_modules = [biasedurn_module],
      py_modules = ["biasedurn"])
