#ifndef BUTTON_H
#define BUTTON_H

#include <vector>
#include <string>
#include <functional>
#include "Widget.h"

class Button : public Widget {
    private:
        std::vector<std::function<void()>> listeners;
        std::string text;
    public:
        Button(int X, int Y, const std::string& text);
        void Draw();
        void AddListener(std::function<void()> func);
        void OnMouseClick(int X, int Y);
};

#endif
