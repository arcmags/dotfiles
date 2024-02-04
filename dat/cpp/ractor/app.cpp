#include <ncurses.h>
#include "Label.h"
#include "Button.h"
#include "Slider.h"
#include "Checkbox.h"
#include "List.h"
#include "Frame.h"
#include "Mandelbrot.h"
#include "Window.h"

int main(int argc, char **argv) {

    Window screen = Window();
    attron(A_BOLD);

    Frame* mainFrame = new Frame(0,COLS-1,0,LINES-2);
    mainFrame->AddResizer([&]() {
        mainFrame->SetBottom(LINES-2);
        mainFrame->SetRight(COLS-1);
    });
    screen.Add(mainFrame);

    Label* mainLabel = new Label(COLS/2-7,0,"Mandelbrot ASCII");
    mainLabel->AddResizer([&]() {
        mainLabel->SetLeft(COLS/2-8);
        mainLabel->SetRight(COLS/2+8);
    });
    screen.Add(mainLabel);

    Mandelbrot* mandelbrot = new Mandelbrot(1,COLS-2,1,LINES-3);
    mandelbrot->AddResizer([&]() {
        mandelbrot->SetRight(COLS-2);
        mandelbrot->SetBottom(LINES-3);
    });
    screen.Add(mandelbrot);

    Button* zoomOutButton = new Button(2, LINES-1, "Zoom Out");
    zoomOutButton->AddListener([&]() {
        mandelbrot->SetScale(-1);
    });
    zoomOutButton->AddResizer([&]() {
        zoomOutButton->SetTop(LINES-1);
        zoomOutButton->SetBottom(LINES-1);
    });
    screen.Add(zoomOutButton);

    Button* zoomInButton = new Button(12, LINES-1, "Zoom In");
    zoomInButton->AddListener([&]() {
        mandelbrot->SetScale(1);
    });
    zoomInButton->AddResizer([&]() {
        zoomInButton->SetTop(LINES-1);
        zoomInButton->SetBottom(LINES-1);
    });
    screen.Add(zoomInButton);

    Button* resetButton = new Button(COLS-12, LINES-1, "Reset");
    resetButton->AddListener([&]() {
        mandelbrot->SetScale(0);
    });
    resetButton->AddResizer([&]() {
        resetButton->SetLeft(COLS-12);
        resetButton->SetTop(LINES-1);
        resetButton->SetRight(resetButton->GetLeft()+4);
        resetButton->SetBottom(LINES-1);
    });
    screen.Add(resetButton);

    Button* quitButton = new Button(COLS-5, LINES-1, "Quit");
    quitButton->AddListener([&]() {
        screen.Stop();
    });
    quitButton->AddResizer([&]() {
        quitButton->SetLeft(COLS-5);
        quitButton->SetTop(LINES-1);
        quitButton->SetRight(COLS-1);
        quitButton->SetBottom(LINES-1);
    });
    screen.Add(quitButton);

    screen.AddKeyListener([&](char key) {
        if (key=='r') {
            mandelbrot->SetScale(0);
        } else if (key=='x') {
            mandelbrot->SetScale(1);
        } else if (key=='z') {
            mandelbrot->SetScale(-1);
        }
    });

    screen.Loop();
    return 0;
}
