#ifndef CHECKBOX_H
#define CHECKBOX_H

#include <vector>
#include <string>
#include <functional>
#include "Widget.h"

class Checkbox : public Widget {
    private:
        std::vector<std::function<void(bool)>> listeners;
        std::string text;
        bool isChecked;
    public:
        Checkbox(int X, int Y, const std::string& text);
        bool IsChecked() const;
        void IsChecked(bool setChecked);
        void Draw();
        void AddListener(std::function<void(bool)> func);
        void OnMouseClick(int X, int Y);
};

#endif
