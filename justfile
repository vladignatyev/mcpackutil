#!/usr/bin/env just --justfile

clean:
    rmdir /s /q "dist/"

_requirements:
	pip install -r requirements.txt

build: _requirements clean
    python3 setup.py sdist bdist_wheel

install: build
    pip install -e ./

test: install
    packutil extract version
    packutil extract asset

upload: build
    twine upload dist/*