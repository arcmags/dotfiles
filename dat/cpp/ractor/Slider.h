#ifndef SLIDER_H
#define SLIDER_H

#include <vector>
#include <functional>
#include "Widget.h"

class Slider : public Widget {
    private:
        int value;
        int maxValue;
        std::vector<std::function<void(int)>> listeners;
    public:
        Slider(int X, int Y, int maxValue, int defaultValue);
        int GetValue() const;
        int GetMax() const;
        void Draw();
        void AddListener(std::function<void(int)> func);
        void OnMouseClick(int X, int Y);
};

#endif
