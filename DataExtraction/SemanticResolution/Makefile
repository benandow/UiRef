#Written by Ben Andow

# Compiler = gcc
CC = gcc

# PATH variables
PYTHON_PATH="/usr/local/Cellar/python@2/2.7.15_1/Frameworks/Python.framework/Versions/2.7"
#PYTHON_PATH=/usr/local/Cellar/python/2.7.12/Frameworks/Python.framework/Versions/2.7
PYTHON_INCL="/usr/local/Cellar/python@2/2.7.15_1/Frameworks/Python.framework/Versions/2.7/include/python2.7"
#PYTHON_INCL=$(PYTHON_PATH)/include/python2.7/
JULIA_PATH="/Applications/Julia-0.6.app/Contents/Resources/julia"


# Compiler flags:
# 	-dynamiclib
CFLAGS = -v -dynamiclib -fPIC -I$(JULIA_PATH)/include/julia -L$(JULIA_PATH)/lib -L$(JULIA_PATH)/lib -I$(JULIA_PATH)/include  -I$(PYTHON_INCL) `$(PYTHON_PATH)/bin/python-config --cflags` `$(PYTHON_PATH)/bin/python-config --c flags` `$(PYTHON_PATH)/bin/python-config --ldflags` -L$(JULIA_PATH)/lib/julia -ljulia -Wl,-rpath,'$(JULIA_PATH)/lib' -Wl,-rpath,'$(JULIA_PATH)/lib/julia' -DJULIA_ENABLE_THREADING=1

#Target
TARGET = adagramDisambigModule

all: $(TARGET)

$(TARGET): $(TARGET).c
	$(CC) $(CFLAGS) -o $(TARGET).so $(TARGET).c
#	$(RM) -r $(TARGET).so.dSYM	

clean:
	$(RM) $(TARGET).so

