#include <stdio.h>
#include <string.h>
#include <ncurses.h>

int main(int argc, char *argv[]) {
    if (argc > 1 &&
    (strcmp(argv[1], "-H") == 0 || strcmp(argv[1], "--help") == 0)) {
        printf("Usage:\n\
  getch [option...]\n\n\
Print keypress as detected by ncurses getch().\n\n\
Options:\n\
  -H, --help    print help and exit\n");
        return(0);
    }

    int key;
    initscr();
    keypad(stdscr, TRUE);
    noecho();
    nonl();
    scrollok(stdscr, TRUE);

    for (;;) {
        key = getch();
        printw("key: %s (%d)\n", keyname(key), key);
    }

    endwin();
    return 0;
}
