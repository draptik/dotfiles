#!/usr/bin/env python3
import sys
import webbrowser

websites = {
    "Google": "https://www.google.com",
    "Github": "https://www.github.com",
    "Stack Overflow": "https://stackoverflow.com",
}

if len(sys.argv) == 1:
    for site in websites:
        print(site)
else:
    site = sys.argv[1]
    if site in websites:
        webbrowser.open(websites[site])
