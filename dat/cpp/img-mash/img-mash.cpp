/* img-mash.cpp :: */
/* Mashup input image and save a new .png file in same directory as image. */
/* Print mashed image name to stdout. */

#include <Magick++.h>
#include <iostream>
#include <unistd.h>
#include <filesystem>
#include <fmt/format.h>

using namespace std;
using namespace Magick;

int main(int argc,char **argv) {
    string blue = "\e[1;38;5;12m";
    string red = "\e[1;38;5;9m";
    string reset = "\e[0m";
    if (!isatty(fileno(stderr)) || !isatty(fileno(stdout))) {
        blue = "";
        red = "";
        reset = "";
    }
    const string help = "Usage: img-mash <IMAGE>\nSave mashed image to new .png.\n";

    if (argc == 1) {
        cout << help;
        return 1;
    }
    const string arg = argv[1];

    if (arg == "--help" || arg == "-H" || arg == "-h") {
        cout << help;
        return 0;
    }
    if (argc > 2) {
        cerr << red << "E: " << reset << "too many arguments" << endl;
        return 1;
    }

    InitializeMagick(*argv);
    Image input;
    try {
        input.read(arg);
    }
    catch( Exception &error_ ) {
        cerr << red << "E: " << reset << "unable to open image: " << arg << endl;
        return 1;
    }

    int f = 1;
    int i = arg.find_last_of(".");
    string name = "";
    if (i < 1) {
        name = arg;
    }
    else {
        name = arg.substr(0,i);
    }
    string file = fmt::format("{}{:02}.png", name, f);
    while (filesystem::exists(file)) {
        file = fmt::format("{}{:02}.png", name, f++);
    }

    Image output(input.size(), "black");
    int width = input.size().width();
    int height = input.size().height();

    srand (time(NULL));
    int l = rand() % 46 + 4;
    int x_off = rand() % width;
    int y_off = rand() % height;
    for (int h = 0; h < height; h++) {
        if (l <= 0) {
            x_off = rand() % width;
            l = rand() % 46 + 4;
        }
        l += -1;
        for (int w = 0; w < width; w++) {
            output.pixelColor(w,h,input.pixelColor((w + x_off) % width,(h + y_off) % height));
        }
    }

    output.write(file);
    cout << file << endl;
    return 0;
}
