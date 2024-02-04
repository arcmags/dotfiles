#include "Rectangle.h"

Rectangle::Rectangle(int rectL, int rectR, int rectT, int rectB) :
    rectL(rectL), rectR(rectR), rectT(rectT), rectB(rectB) {
}

int Rectangle::GetLeft() const {
    return rectL;
}
int Rectangle::GetRight() const {
    return rectR;
}
int Rectangle::GetTop() const {
    return rectT;
}
int Rectangle::GetBottom() const {
    return rectB;
}

int Rectangle::GetWidth() const {
    return rectR-rectL+1;
}
int Rectangle::GetHeight() const {
    return rectB-rectT+1;
}

void Rectangle::SetLeft(int newL) {
    rectL=newL;
}
void Rectangle::SetRight(int newR) {
    rectR=newR;
}
void Rectangle::SetTop(int newT) {
    rectT=newT;
}
void Rectangle::SetBottom(int newB) {
    rectB=newB;
}

bool Rectangle::Contains(int X, int Y) const {
    if (X>=rectL && X<=rectR && Y>=rectT && Y<=rectB) {
        return true;
    } else {
        return false;
    }
}
bool Rectangle::Intersects(const Rectangle& rect) const {
    if (Contains(rect.rectL,rect.rectT) || Contains(rect.rectL,rect.rectB) ||
        Contains(rect.rectR,rect.rectT) || Contains(rect.rectR,rect.rectB) ||
        rect.Contains(rectL,rectT) || rect.Contains(rectL,rectB) ||
        rect.Contains(rectR,rectT) || rect.Contains(rectR,rectB)) {
        return true;
    } else {
        return false;
    }
}
