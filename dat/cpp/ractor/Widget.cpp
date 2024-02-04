#include <functional>
#include <vector>
#include "Rectangle.h"
#include "Widget.h"

Widget::Widget(int widgetL, int widgetR, int widgetT, int widgetB)
    : widgetBox(widgetL,widgetR,widgetT,widgetB) {
}
Widget::~Widget() {}

int Widget::GetLeft() const {
    return widgetBox.GetLeft();
}
int Widget::GetRight() const {
    return widgetBox.GetRight();
}
int Widget::GetTop() const {
    return widgetBox.GetTop();
}
int Widget::GetBottom() const {
    return widgetBox.GetBottom();
}

void Widget::SetLeft(int X) {
    widgetBox.SetLeft(X);
}
void Widget::SetTop(int Y) {
    widgetBox.SetTop(Y);
}
void Widget::SetRight(int X) {
    widgetBox.SetRight(X);
}
void Widget::SetBottom(int Y) {
    widgetBox.SetBottom(Y);
}

bool Widget::Contains(int X, int Y) const {
    return widgetBox.Contains(X,Y);
}

void Widget::OnMouseClick(int X, int Y) {}

void Widget::OnResize() {
    for (std::function<void()> func : resizers) {
        func();
    }
}

void Widget::AddResizer(std::function<void()> func) {
    resizers.push_back(func);
}
