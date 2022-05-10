#!/bin/sh
source venv/bin/activate
# flask deploy # initialize database on first run
exec waitress-serve --port=5000 eehbv:app