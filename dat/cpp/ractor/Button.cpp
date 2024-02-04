#include <vector>
#include <string>
#include <ncurses.h>
#include <functional>
#include "Widget.h"
#include "Button.h"

Button::Button(int X, int Y, const std::string& text) :
    Widget(X,X+text.length()-1,Y,Y),
    text(text) {
}

void Button::Draw() {
    attron(A_REVERSE);
    mvprintw(GetTop(),GetLeft(),text.c_str());
    attroff(A_REVERSE);
}

void Button::AddListener(std::function<void()> func) {
    listeners.push_back(func);
}

void Button::OnMouseClick(int X, int Y) {
    for (std::function<void()> func : listeners) {
        func();
    }
}
