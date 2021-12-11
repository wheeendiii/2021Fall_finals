from setuptools import setup, Extension

module = Extension ('final_project_cython', sources=['final_project_cython_functions.pyx'])

setup(
    name='cythonTest',
    version='1.0',
    author='Kay Avila, Kangyang Wang, Wendy Zhu',
    ext_modules=[module]
)