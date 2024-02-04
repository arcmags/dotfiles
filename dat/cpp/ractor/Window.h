#ifndef WINDOW_H
#define WINDOW_H

#include <functional>
#include <vector>
#include "Widget.h"

class Window : public Widget {
    private:
        std::vector<std::function<void(char)>> keyListeners;
        std::vector<Widget*> widgets;
        bool notStopped;
    public:
        Window();
        ~Window();
        void Add(Widget* widget);
        void Draw();
        void Loop();
        void Stop();
        void AddKeyListener(std::function<void(char)> func);
};

#endif
