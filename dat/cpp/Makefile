## Makefile ::

C = gcc
CFLAGS = -g -Wall -pedantic
CLIBS =
CPP = g++
CPPFLAGS = -g -Wall -pedantic -std=c++11
CPPLIBS =
H = ghc
HEXE=
HFLAGS =
HMODULES=

EXE = main

$(EXE): *.o
	$(CPP) $(CPPFLAGS) -o $@ $^ $(CPPLIBS)

%.o: %.c Makefile
	$(C) $(CFLAGS) -c -o $@ $< $(CLIBS)
%.o: %.cpp %.h Makefile
	$(CPP) $(CPPFLAGS) -c -o $@ $< $(CPPLIBS)
$(HEXE): $(HEXE).hs $(HMODULES)
	$(H) $(HFLAGS) $(HEXE)

clean:
	rm -f *.o $(EXE)
run : $(EXE)
	./$(EXE)
new: clean $(EXE)
