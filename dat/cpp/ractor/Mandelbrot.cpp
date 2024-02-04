#include <vector>
#include <string>
#include <functional>
#include <ncurses.h>
#include "Mandelbrot.h"

Mandelbrot::Mandelbrot(int L, int R, int T, int B) :
    Widget(L,R,T,B),
    startX(-2),
    startY(.75),
    scale(3),
    yToX(1.66),
    maxIterations(40),
    symbols({'*','$','@','#','%'}) {
    start_color();
    init_pair(1, COLOR_WHITE, COLOR_BLACK);
    init_pair(2, COLOR_RED, COLOR_BLACK);
    init_pair(3, COLOR_YELLOW, COLOR_BLACK);
    init_pair(4, COLOR_GREEN, COLOR_BLACK);
    init_pair(5, COLOR_BLUE, COLOR_BLACK);
    init_pair(6, COLOR_CYAN, COLOR_BLACK);
    init_pair(7, COLOR_MAGENTA, COLOR_BLACK);
    init_pair(8, COLOR_WHITE, COLOR_BLUE);
    attron(COLOR_PAIR(1));
}

void Mandelbrot::Draw() {
    double xDelta = scale / (double)COLS;
    double yDelta = xDelta * yToX;
    int yI;
    int xI;
    double x;
    double y;
    int max;
    char charX;
    for (yI=GetTop(); yI<=GetBottom(); yI++) {
        for (xI=GetLeft(); xI<=GetRight(); xI++) {
            move(yI,xI);
            x = startX + ((double)xI) * xDelta;
            y = startY - ((double)yI) * yDelta;
            double xO=x;
            double yO=y;
            double xN;
            max=0;
            while (x*x+y*y <= 4 && max < maxIterations) {
                xN= x*x - y*y + xO;
                y = 2*x*y + yO;
                x=xN;
                max++;
            }
            /* julia set: */
            /*while (x*x+y*y <= 4 && max < maxIterations) {*/
                /*xN= x*x - y*y + -0.4;*/
                /*y = 2*x*y + 0.6;*/
                /*x = xN;*/
                /*max++;*/
            /*}*/
            if (max < maxIterations) {
                charX=symbols[max%5];
                if (max < 3) {
                    charX='.';
                }
                if (max == 3) {
                    charX=',';
                }
                attron(COLOR_PAIR((max/5)%6+2));
                addch(charX);
            }
        }
    }
    attron(COLOR_PAIR(1));
    move((GetTop()+GetBottom())/2,(GetLeft()+GetRight())/2);
    addch('+');
    move(GetBottom()-1,1);
    printw("Re = ");
    printw(std::to_string(startX+scale/2).c_str());
    move(GetBottom(),1);
    printw("Im = ");
    printw(std::to_string(startY-scale/2/yToX).c_str());
}

void Mandelbrot::SetScale(int zoom) {
    if (zoom==1) {
        startX = startX + scale*0.025;
        startY = startY - scale*0.015060;
        scale = scale*0.95;
        maxIterations= maxIterations + 1;
    } else if (zoom==-1) {
        startX = startX - scale*0.0263158;
        startY = startY + scale*0.0158529;
        scale = scale*1.052632;
        maxIterations= maxIterations -1;
    } else if (zoom==0) {
        startX = -2;
        startY = 0.75;
        scale = 3;
        maxIterations= 40;
    }
}

void Mandelbrot::OnMouseClick(int X, int Y) {
    double delX=X-(GetRight()-GetLeft())/2;
    double delY=Y-(GetBottom()-GetTop())/2;
    startX=startX + scale/(GetRight()-GetLeft())*delX;
    startY=startY - scale/(GetRight()-GetLeft())*delY*yToX;
}
