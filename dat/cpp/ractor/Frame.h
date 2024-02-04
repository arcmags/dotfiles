#ifndef FRAME_H
#define FRAME_H

#include "Widget.h"

class Frame : public Widget {
    public:
        Frame(int L, int R, int T, int B);
        void Draw();
};

#endif
