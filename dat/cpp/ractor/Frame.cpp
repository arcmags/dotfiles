#include <ncurses.h>
#include "Frame.h"
#include "Widget.h"

Frame::Frame(int L, int R, int T, int B) :
    Widget(L,R,T,B) {
}

void Frame::Draw() {
    int x;
    int y;
    for (x=GetLeft();x<=GetRight();x++) {
        mvaddch(GetTop(),x,'-');
        mvaddch(GetBottom(),x,'-');
    }
    for (y=GetTop();y<GetBottom();y++) {
        mvaddch(y,GetLeft(),'|');
        mvaddch(y,GetRight(),'|');
    }
    mvaddch(GetTop(),GetLeft(),'+');
    mvaddch(GetTop(),GetRight(),'+');
    mvaddch(GetBottom(),GetLeft(),'+');
    mvaddch(GetBottom(),GetRight(),'+');
}
