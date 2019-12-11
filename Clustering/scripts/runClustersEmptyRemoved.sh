#!/bin/bash

cwd=$(pwd)
d="${1}"
cd "${d}/EMPTY_REMOVED"
python "${cwd}/extract_csv_files.py" "${d}_EMPTY_REMOVED.csv"
python "${cwd}/cluster.py" "FV_${d}_EMPTY_REMOVED.csv" 2 30 20
cd "${cwd}"
