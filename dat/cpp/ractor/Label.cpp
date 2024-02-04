#include <string>
#include <ncurses.h>
#include "Widget.h"
#include "Label.h"

Label::Label(int X, int Y, const std::string& text) :
    Widget(X,X+text.length()-1,Y,Y),
    text(text) {
}

void Label::SetText(const std::string& newText) {
    SetRight(GetLeft()+newText.length()-1);
    text=newText;
}

void Label::Draw() {
    mvprintw(GetTop(),GetLeft(),text.c_str());
}
