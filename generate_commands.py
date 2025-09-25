"""
Builds the commands to quickly create all the dotfiles directories and symlink the config files in here to those
directories
"""

import os
import re

ignore_paths = [
    r".*\.git",
    r".*\.git/.*",
    r".*\.keep",
    r".*\.idea",
    r".*\.idea/.*",
    r".*generate_commands.py",
]

home = os.path.expanduser("~")


def should_ignore(path):
    matches = [re.fullmatch(pattern, path) for pattern in ignore_paths]
    not_none = [match for match in matches if match]
    return bool(not_none)


class ShouldIgnoreException(Exception):
    pass


def resolve(*args):
    return os.path.normpath(os.path.join(*args))


def build_paths(root, child):
    path_src = resolve(root, child)
    if not should_ignore(path_src):
        path_tgt = resolve(home, path_src)
        return os.path.lexists(path_tgt), path_src, path_tgt
    else:
        raise ShouldIgnoreException


def build_commands():
    for root, dirs, files in os.walk("."):

        for some_dir in dirs:
            try:
                exists, src, tgt = build_paths(root, some_dir)
                print("{}mkdir {}".format("# " if exists else "", tgt))
            except ShouldIgnoreException:
                pass

        for some_file in files:
            try:
                exists, src, tgt = build_paths(root, some_file)
                print("ln -s{} {} {}".format("f" if exists else "", os.path.abspath(src), tgt))
            except ShouldIgnoreException:
                pass


build_commands()
