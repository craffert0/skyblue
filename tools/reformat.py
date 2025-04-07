#! /usr/bin/env python3

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import re
import subprocess

for f in [
    x
    for x in subprocess.run(
        ["git", "diff", "--cached", "--name-only", "--diff-filter=ACM"],
        capture_output=True,
        text=True,
    ).stdout.split("\n")
    if x != ""
]:
    if re.search("\\.py$", f):
        subprocess.run(["black", "-q", f])
    elif re.search("\\.(cc|h)$", f):
        subprocess.run(["clang-format", "-i", f])
    elif re.search("\\.swift$", f):
        subprocess.run(["swiftformat", "--quiet", "--swiftversion", "6", f])
