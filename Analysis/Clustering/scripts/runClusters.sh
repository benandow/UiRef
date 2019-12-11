#!/bin/bash

cwd=$(pwd)
d="${1}"
cd "${d}"
python "${cwd}/extract_csv_files.py" "${d}.csv"
python "${cwd}/cluster.py" "FV_${d}.csv" 2 30 20
cd "${cwd}"
