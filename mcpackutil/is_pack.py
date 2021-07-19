#!/usr/bin/env python
# -*- coding: utf-8 -*-

import zipfile
from pathlib import Path
from zipfile import ZipFile

meta = "pack.mcmeta"
root = "assets/.mcassetsroot"


def is_pack(file: str) -> bool:
    path = Path(file)

    if path.is_dir():
        return handle_folder(path)
    elif zipfile.is_zipfile(file):
        return handle_zip(path)


def handle_folder(file: Path) -> bool:
    return file.relative_to(meta).is_file()


def handle_zip(file: Path) -> bool:
    with ZipFile(file) as zf:
        try:
            try:
                zf.getinfo(root)
                return True
            except KeyError:
                pass

            zf.getinfo(meta)
            return True
        except KeyError:
            return False
