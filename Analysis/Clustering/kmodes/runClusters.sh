#!/bin/bash


cwd=$(pwd)

for d in $(find * -type d); do
	cd "${d}"
	python "${cwd}/extract_csv_files.py" "${d}_full.csv"
	python "${cwd}/cluster.py" "OUTPUT_${d}_full.csv" 5 20 20
	cd "${cwd}"
done
