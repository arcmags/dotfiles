#ifndef LIST_H
#define LIST_H

#include <vector>
#include <string>
#include <functional>
#include "Widget.h"


class List : public Widget {
    private:
        std::vector<std::string> list;
        int selectedIndex;
        std::vector<std::function<void(int)>> listeners;
    public:
        // CONSTRUCTORS
        List(int X, int Y, const std::vector<std::string>& list);
        int GetMaxLength(const std::vector<std::string>& list) const;
        // CLASS METHODS
        int GetSelectedIndex() const;
        const std::string& GetSelected() const;
        void Draw();
        void AddListener(std::function<void(int)> func);
        void OnMouseClick(int X, int Y);
};

#endif
