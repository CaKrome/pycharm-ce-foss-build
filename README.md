# pycharm-ce-foss-build

This is a script that automatically build PyCharm Community Edition, it includes some modifications from https://github.com/archlinux/svntogit-community/blob/packages/pycharm-community-edition/trunk/PKGBUILD

# Motivation

PyCharm Community Edition is a popular Python IDE, however the official binaries include some proprietary plugins, see this thread: https://youtrack.jetbrains.com/issue/IDEA-266631, thus a real free software rebuild is needed.

This build uses the modifications/patches from ```pycharm-community-edition``` in the repo of Arch Linux, and make it available to all amd64 architecture GNU/Linux distros.

# Usage

Execute [pycharm-build.sh](pycharm-build.sh)
The resulting binaries can be found in out/pycharm-ce/artifacts.

## Dependencies
OpenJDK version 11, ```ant``` and ```git```.

# License

The binaries are licensed under Apache License, Version 2.0.
The build script is licensed under GNU General Public License Version 3.
