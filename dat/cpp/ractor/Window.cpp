#include <vector>
#include <ncurses.h>
#include <functional>
#include "Widget.h"
#include "Window.h"

Window::Window() :
    Widget(-1,-1,-1,-1),
    notStopped(true) {
    initscr();
    noecho();
    curs_set(false);
    keypad(stdscr, true);
    mousemask(BUTTON1_CLICKED, NULL);
}

Window::~Window() {
    for (auto w : widgets) {
        delete(w);
    }
}

void Window::Add(Widget* widget) {
     widgets.push_back(widget);
}

void Window::Draw() {
    clear();
    for (auto w : widgets) {
        w->Draw();
    }
}

void Window::Loop() {
    MEVENT mevent;
    int key;
    while (notStopped) {
        Draw();
        key = getch();
        if (key == 'q') {
            Stop();
        } else if (key==KEY_MOUSE) {
            getmouse(&mevent);
            for (auto w : widgets) {
                if (w->Contains(mevent.x,mevent.y)) {
                    w->OnMouseClick(mevent.x-w->GetLeft(),mevent.y-w->GetTop());
                }
            }
        } else if (key==KEY_RESIZE) {
            endwin();
            for (auto w : widgets) {
                w->OnResize();
            }
        } else {
            for (std::function<void(char)> func : keyListeners) {
                func(key);
            }
        }
        refresh();
    }
    endwin();
}

void Window::AddKeyListener(std::function<void(char)> func) {
    keyListeners.push_back(func);
}

void Window::Stop() {
    notStopped=false;
}
