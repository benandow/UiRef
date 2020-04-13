# UiRef: User Input REsolution Framework #

This repository hosts the source code for the UiRef tool.
UiRef resolves the semantics of user input widgets.

# Instructions: #

* Place APKs in /ext/apks

* Build the docker image: docker build -t benandow/uiref .

* Launch an Android emulator on the host. I recommend running on an emulator with a resolution of 1280 x 768 pixels (Nexus 4). If you use a different resolution, you will need to experimentally determine the distance threshold and set the MAX\_DIST variable in src/LabelResolver/src/main/java/com/benandow/uiref/labelResolver/LabelResolver.java.

* Run the docker image: docker run --net host --privileged -v /dev/bus/usb:/dev/bus/usb -v "$(pwd)/ext:/ext" benandow/uiref "\<emulator-identiifer\>"


# Publication #

Full details on UiRef can be found in the following publication:

Benjamin Andow, Akhil Acharya, Dengfeng Li, William Enck, Kapil Singh, and Tao Xie. UiRef: Analysis of Sensitive User Inputs in Android Applications, Proceedings of the ACM Conference on Security and Privacy in Wireless and Mobile Networks (WiSec), July 2017. Boston, MA, USA.


# License #

UiRef is licensed under the BSD-3-Clause License (See LICENSE.txt).



