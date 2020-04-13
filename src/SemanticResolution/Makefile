#Written by Ben Andow

# Compiler = gcc
CC = gcc

# PATH variables
#PYTHON_PATH="/usr/local/Cellar/python@2/2.7.15_1/Frameworks/Python.framework/Versions/2.7"
PYTHON_PATH=/usr/bin
#PYTHON_INCL="/usr/local/Cellar/python@2/2.7.15_1/Frameworks/Python.framework/Versions/2.7/include/python2.7"
PYTHON_INCL=/usr/include/python3.6
JULIA_PATH=/src/julia
#JULIA_PATH="/Applications/Julia-0.6.app/Contents/Resources/julia"


# Compiler flags:
# 	-dynamiclib
CFLAGS = -v -dynamiclib -fPIC -I$(JULIA_PATH)/include/julia -L$(JULIA_PATH)/lib -L$(JULIA_PATH)/lib -I$(JULIA_PATH)/include  -I$(PYTHON_INCL) `$(PYTHON_PATH)/python3.6-config --cflags` `$(PYTHON_PATH)/python3.6-config --ldflags` -L$(JULIA_PATH)/lib/julia -ljulia -Wl,-rpath,'$(JULIA_PATH)/lib' -Wl,-rpath,'$(JULIA_PATH)/lib/julia' -DJULIA_ENABLE_THREADING=1 -lpython3.6m -shared

#Target
TARGET = adagramDisambigModule

all: $(TARGET)

$(TARGET): $(TARGET).c
	$(CC) $(TARGET).c -o $(TARGET).so $(CFLAGS)
#	$(RM) -r $(TARGET).so.dSYM	

clean:
	$(RM) adagramDisambigModule.c.*

