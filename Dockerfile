FROM ubuntu:18.04

RUN apt-get update
RUN apt-get upgrade -y

# Install Java
RUN apt-get install -y openjdk-8-jdk openjdk-8-jre wget unzip 

# Install Android command line tools
RUN mkdir /src
RUN wget -O /src/commandlinetools-linux-6200805_latest.zip https://dl.google.com/android/repository/commandlinetools-linux-6200805_latest.zip
RUN unzip /src/commandlinetools-linux-6200805_latest.zip -d /src/android-linux-sdk
ENV ANDROID_HOME="/src/android-linux-sdk"
ENV PATH="$ANDROID_HOME/tools:$ANDROID_HOME/tools/platform-tools:$PATH"
RUN yes | /src/android-linux-sdk/tools/bin/sdkmanager --sdk_root="/src/android-linux-sdk" --licenses
RUN /src/android-linux-sdk/tools/bin/sdkmanager --sdk_root="/src/android-linux-sdk" "platforms;android-29" "build-tools;29.0.3" "build-tools;29.0.2" "build-tools;29.0.1" "build-tools;29.0.0" "cmdline-tools;latest"


# Build Payload app
COPY ./src/GuiRipperApp /src/GuiRipperApp
WORKDIR "/src/GuiRipperApp"
ENV ANDROID_SDK_ROOT="/src/android-linux-sdk/tools"
RUN /src/GuiRipperApp/gradlew assembleRelease
RUN mv /src/GuiRipperApp/build/outputs/apk/release/GuiRipperApp-release-unsigned.apk /src/guiripper.apk


# Install ApkTool
WORKDIR "/src"
RUN wget -O /src/apktool https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
RUN chmod u+x /src/apktool
RUN wget -O /src/apktool.jar https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.4.1.jar

# Copy other modules
COPY ./src/ApkRewriter /src/ApkRewriter

# Extract payload
RUN /src/apktool d /src/guiripper.apk
RUN mv /src/guiripper/smali /src/ApkRewriter/payload
RUN rm -rf /src/ApkRewriter/payload/com/example

#Install Python
RUN apt-get install -y python3
RUN apt-get install -y python3-pip

# Install Python modules
RUN pip3 install lxml
RUN pip3 install spacy
RUN pip3 install Pillow
RUN pip3 install nltk
RUN python3 -m nltk.downloader stopwords
RUN pip3 install spacy
RUN python3 -m spacy download en_core_web_sm


# Compile Label Resolver
COPY ./src/LabelResolver /src/LabelResolver
WORKDIR "/src/LabelResolver"
RUN apt-get install -y maven
RUN mvn clean compile assembly:single
RUN mv /src/LabelResolver/target/uiref-0.0.1-SNAPSHOT-jar-with-dependencies.jar /src/labelresolver.jar

WORKDIR "/src"

COPY ./src/SemanticResolution /src/SemanticResolution

# Install Julia and AdaGram module
RUN apt-get install -y git
RUN wget -O /src/julia-1.1.1-linux-x86_64.tar.gz https://julialang-s3.julialang.org/bin/linux/x64/1.1/julia-1.1.1-linux-x86_64.tar.gz
RUN tar xzvf /src/julia-1.1.1-linux-x86_64.tar.gz
RUN mv /src/julia-1.1.1 /src/julia
ENV PATH="/src/julia/bin:$PATH"
RUN julia /src/SemanticResolution/installAdaGram.jl
RUN apt-get install -y git

# Compile bridge
WORKDIR "/src/SemanticResolution"
RUN make

WORKDIR "/src"

COPY ./src/runUIRef.sh /src/runUIRef.sh
RUN chmod u+x /src/runUIRef.sh

ENV PATH="$ANDROID_HOME/platform-tools:$PATH"



ENTRYPOINT ["/src/runUIRef.sh"]

