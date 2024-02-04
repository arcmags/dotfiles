#include <vector>
#include <functional>
#include <ncurses.h>
#include "Widget.h"
#include "Slider.h"

Slider::Slider(int X, int Y, int maxValue, int defaultValue) :
    Widget(X,X+maxValue,Y,Y),
    value(defaultValue),
    maxValue(maxValue) {
}

void Slider::Draw() {
    move(GetTop(),GetLeft());
    int i;
    for (i=0;i<=maxValue;i++) {
        if (i==value) {
            addch('o');
        } else {
            addch('.');
        }
    }
}

int Slider::GetValue() const {
    return value;
}

int Slider::GetMax() const {
    return maxValue;
}

void Slider::AddListener(std::function<void(int)> func) {
    listeners.push_back(func);
}

void Slider::OnMouseClick(int X, int Y) {
    value=X;
    for (auto func : listeners) {
        func(value);
    }
}
