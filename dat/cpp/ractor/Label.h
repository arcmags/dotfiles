#ifndef LABEL_H
#define LABEL_H

#include <string>
#include "Widget.h"

class Label : public Widget {
    private:
        std::string text;
    public:
        Label(int X, int Y, const std::string& text);
        void SetText(const std::string& newText);
        void Draw();
};

#endif
