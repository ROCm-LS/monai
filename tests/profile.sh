#!/bin/bash
# filepath: find_and_run_rocprof.sh

LOGFILE="rocprof_run.txt"
FAILED_FILES=()

echo "rocprofv3 run started at $(date)" > "$LOGFILE"

find . -type f -name "*.py" | while read -r file; do
    if grep -q '^import unittest' "$file" || grep -q '^from unittest' "$file"; then
        echo "Running rocprofv3 on $file" | tee -a "$LOGFILE"
        /opt/rocm/bin/rocprofv3 -S -D --kernel-trace -- pytest -vv -s "$file" >> "$LOGFILE" 2>&1 | tee -a "$LOGFILE"
        STATUS=$?
        if [ $STATUS -eq 139 ]; then
            FAILED_FILES+=("$file")
        fi
    fi
done