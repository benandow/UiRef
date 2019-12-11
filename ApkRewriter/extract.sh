#!/bin/bash

if [ $# -lt 1 ]; then
	echo "Usage: extract <apk name>"
	exit
fi

apk_name=${1%.apk}


apktool d "${apk_name}.apk"
mkdir -p "payload/com/benandow/android/gui/layoutRendererApp/"
rm "payload/com/benandow/android/gui/layoutRendererApp/*"
cp "${apk_name}/smali/com/benandow/android/gui/layoutRendererApp/*" payload/com/benandow/android/gui/layoutRendererApp/
rm -rf "${apk_name}"

