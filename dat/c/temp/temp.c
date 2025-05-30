#include <stdio.h>
#include <string.h>
//#include <ncurses.h>

int main(int argc, char *argv[]) {
    if (argc > 1 &&
    (strcmp(argv[1], "-H") == 0 || strcmp(argv[1], "--help") == 0)) {
        printf("Usage:\n\
  temp [option...]\n\n\
c template program.\n\n\
Options:\n\
  -H, --help    print help and exit\n");
        return(0);
    }
    return 0;
}
