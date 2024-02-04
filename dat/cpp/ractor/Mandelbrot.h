#ifndef MANDELBROT_H
#define MANDELBROT_H

#include <string>
#include "Widget.h"

class Mandelbrot : public Widget {
    private:
        double startX;
        double startY;
        double scale;
        double yToX;
        int maxIterations;
        std::vector<char> symbols;
    public:
        Mandelbrot(int L, int R, int T, int B);
        void Draw();
        void SetScale(int zoom);
        void OnMouseClick(int X, int Y);
};

#endif
