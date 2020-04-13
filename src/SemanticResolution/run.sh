#!/bin/bash

#otool -L 
# install_name_tool adagramDisambigModule.so -change /System/Library/Frameworks/Python.framework/Versions/2.7/Python /Users/benandow/anaconda2/python.app/Contents/lib/libpython2.7.dylib

# Need to install AdaGram on Julia first
ADAGRAM_DYLIB_PATH="/Users/benandow/Desktop/UiRefOpenSource/uiref/SemanticResolution/lib"
JULIA_PATH="/Applications/Julia-0.6.app/Contents/Resources/julia/lib"
#PYTHON_EXEC_PATH="/usr/local/Cellar/python/2.7.12/Frameworks/Python.framework/Versions/2.7/bin/"

DYLD_LIBRARY_PATH="${ADAGRAM_DYLIB_PATH}:${JULIA_PATH}" "python" SemanticsResolver.py "${1}"
