#include <vector>
#include <string>
#include <functional>
#include <ncurses.h>
#include "Widget.h"
#include "List.h"

List::List(int X, int Y, const std::vector<std::string>& list) :
    Widget(X,X+GetMaxLength(list),Y,Y+list.size()-1),
    list(list),
    selectedIndex(-1) {
}

int List::GetMaxLength(const std::vector<std::string>& list) const {
    int length=0;
    for (std::string s : list ) {
        if ((int)s.length()>length) {
            length=s.length();
        }
    }
    return length-1;
}

void List::Draw() {
    int i=0;
    for (auto s : list ) {
        move(GetTop()+i,GetLeft());
        if (i==selectedIndex) {
            attron(A_REVERSE);
            printw(list[i].c_str());
            attroff(A_REVERSE);
        } else {
            printw(list[i].c_str());
        }
        i++;
    }
}

int List::GetSelectedIndex() const {
    return selectedIndex;
}

const std::string& List::GetSelected() const {
    return list[selectedIndex];
}

void List::AddListener(std::function<void(int)> func) {
    listeners.push_back(func);
}

void List::OnMouseClick(int X, int Y) {
    if (Y==selectedIndex) {
        selectedIndex=-1;
    } else {
        selectedIndex=Y;
    }
    for (auto func : listeners) {
        func(selectedIndex);
    }
}
