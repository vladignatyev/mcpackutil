#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from setuptools import setup

from mcpackutil.cli import _fversion, name, author

setup(
    name=name,
    version=_fversion(),
    description="A CLI and library for working with Minecraft resource packs",
    author=author,
    url=f"https://github.com/{author}/{name}",
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
            f"{name}={name}.cli:main"
        ]
    }
)
