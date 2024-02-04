#ifndef WIDGET_H
#define WIDGET_H

#include <functional>
#include <vector>
#include "Rectangle.h"

class Widget {
    private:
        Rectangle widgetBox;
        std::vector<std::function<void()>> resizers;
    public:
        Widget(int widgetL, int widgetR, int widgetT, int widgetB);
        virtual ~Widget();
        int GetLeft() const;
        int GetRight() const;
        int GetTop() const;
        int GetBottom() const;
        void SetLeft(int X);
        void SetTop(int Y);
        void SetBottom(int Y);
        void SetRight(int X);
        bool Contains(int X, int Y) const;
        virtual void Draw() = 0;
        virtual void OnMouseClick(int X, int Y);
        void AddResizer(std::function<void()> func);
        void OnResize();
};

#endif
