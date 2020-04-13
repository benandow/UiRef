#!/bin/bash

mkdir -p /ext/disassembled
mkdir -p /ext/reassembled
python3 /src/ApkRewriter/UiRefApkRewriter.py "/ext/apks" "/ext/disassembled" "/ext/reassembled"

mkdir -p /ext/layouts
python3 /src/ApkRewriter/UiRefRenderer.py "/src/android-linux-sdk/platform-tools/adb" "${1}" "/ext/reassembled" "/ext/layouts"

java -jar labelresolver.jar "/ext/layouts"

find /ext/layouts -type f -name "*.xml" > "/ext/data/LAYOUT_FILES.txt"

ADAGRAM_DYLIB_PATH="/src/SemanticResolution/lib"
JULIA_PATH="/src/julia/lib"
LD_LIBRARY_PATH="${ADAGRAM_DYLIB_PATH}:${JULIA_PATH}" python3 /src/SemanticResolution/SemanticsResolver.py



