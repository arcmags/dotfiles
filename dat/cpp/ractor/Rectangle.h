#ifndef RECTANGLE_H
#define RECTANGLE_H

class Rectangle {
    private:
        int rectL;
        int rectR;
        int rectT;
        int rectB;
    public:
        Rectangle(int rectL, int rectR, int rectT, int rectB);
        int GetLeft() const;
        int GetRight() const;
        int GetTop() const;
        int GetBottom() const;
        int GetWidth() const;
        int GetHeight() const;
        void SetLeft(int newL);
        void SetRight(int newR);
        void SetTop(int newT);
        void SetBottom(int newB);
        bool Contains(int X, int Y) const;
        bool Intersects(const Rectangle& rect) const;
};

#endif
