from setuptools import setup

name = "mcpackutil"

setup(
    name=name,
    version="1.0.1",
    description="A CLI and library for working with Minecraft resource packs",
    author="DeflatedPickle",
    url="https://github.com/DeflatedPickle/mcpackutil",
    license="MIT",
    classifiers=[
        "License :: OSI Approved :: MIT License",
    ],
    keywords=[
        name,
        "minecraft",
        "resource pack"
    ],
    packages=[
        name
    ],
    entry_points={
        "console_scripts": [
            "mcpackutil=mcpackutil.cli:main"
        ]
    }
)
