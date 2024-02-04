## ractor/Makefile ::

EXE = ractor
WIDGETS = Button.o Checkbox.o Frame.o Label.o List.o Mandelbrot.o Slider.o Window.o

CPP = g++
CPPFLAGS = -g -Wall -pedantic -std=c++11
CPPLIBS = -lncurses

$(EXE): app.o Rectangle.o Widget.o $(WIDGETS)
	$(CPP) $(CPPFLAGS) -o $@ $^ $(CPPLIBS)

$(WIDGETS): Widget.o
Widget.o : Rectangle.o

%.o: %.cpp %.h Makefile
	$(CPP) $(CPPFLAGS) -c -o $@ $< $(CPPLIBS)

clean:
	rm -f *.o main $(EXE)
run: $(EXE)
	./$(EXE)
new: clean $(EXE)
