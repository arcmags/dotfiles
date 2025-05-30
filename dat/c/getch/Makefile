program = getch

$(program): $(program).c
	gcc -Wall -lcurses -o $(program) $(program).c

.PHONY: clean
clean:
	rm -f $(program)
