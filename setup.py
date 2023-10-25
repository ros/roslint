from setuptools import setup
from catkin_pkg.python_setup import generate_distutils_setup

setup(**generate_distutils_setup(
    packages=['roslint'],
    package_dir={
        '': 'src'
    },
    entry_points={
        'catkin_tools.commands.catkin.verbs': [
            'roslint = roslint.main:description',
        ],
    },
))
