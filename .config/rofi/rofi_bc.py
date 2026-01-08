#!/usr/bin/env python3

# Requires linux program `bc`

import sys
import subprocess


def run_bc(expr: str) -> str:
    # bc expects line-based input; ensure newline at end
    expr = expr.strip()
    if not expr:
        return ""

    out = subprocess.check_output(
        ["bc", "-l"],
        input=expr + "\n",
        text=True,
        stderr=subprocess.STDOUT,
    )
    subprocess.run(["wl-copy"], input=out.strip(), text=True)
    return out.strip()


if len(sys.argv) == 1:
    print("Type an expression and press Enter")
    sys.exit(0)

expr = sys.argv[1]

try:
    result = run_bc(expr)
    if result:
        print(f"{expr} = {result}")
except subprocess.CalledProcessError as e:
    print(e.output.strip() or "Error")
