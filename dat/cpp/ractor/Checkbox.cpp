#include <vector>
#include <string>
#include <ncurses.h>
#include <functional>
#include "Widget.h"
#include "Checkbox.h"

Checkbox::Checkbox(int X, int Y, const std::string& text) :
    Widget(X,X+text.length()+3,Y,Y),
    text(text),
    isChecked(false) {
}

bool Checkbox::IsChecked() const{
    return isChecked;
}

void Checkbox::IsChecked(bool setChecked) {
    isChecked=setChecked;
}

void Checkbox::Draw() {
    mvaddch(GetTop(),GetLeft(),'[');
    if (isChecked) {
        addch('x');
    } else {
        addch(' ');
    }
    printw("] ");
    printw(text.c_str());
}

void Checkbox::AddListener(std::function<void(bool)> func) {
    listeners.push_back(func);
}

void Checkbox::OnMouseClick(int X, int Y) {
    isChecked=!isChecked;
    for (auto func : listeners) {
        func(isChecked);
    }
}
