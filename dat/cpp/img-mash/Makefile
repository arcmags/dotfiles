## img-mash/makefile ::

EXE = img-mash
CPPFLAGS = `Magick++-config --cxxflags --cppflags`
CPPLIBS = `Magick++-config --ldflags --libs` -lfmt

$(EXE): img-mash.cpp Makefile
	g++ $(CPPFLAGS) -o $@ $< $(CPPLIBS)

clean:
	rm -f $(EXE)
new: clean $(EXE)
