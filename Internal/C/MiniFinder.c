#include <Types.h>
#include <QuickDraw.h>
#include <Fonts.h>
#include <Windows.h>
#include <Menus.h>
#include <TextEdit.h>
#include <Dialogs.h>
#include <Events.h>

/*
 * MiniFinder.c
 * A minimal replacement for the Finder.
 * This program initializes the Mac Toolbox and enters a loop.
 */

void main(void) {
    WindowPtr myWindow;
    Rect bounds;
    EventRecord myEvent;

    // Initialize the Toolbox
    InitGraf(&qd.thePort);
    InitFonts();
    InitWindows();
    InitMenus();
    TEInit();
    InitDialogs(nil);
    InitCursor();

    // Draw a desktop background (Gray)
    FillRect(&qd.screenBits.bounds, &qd.gray);

    // Create a simple window
    SetRect(&bounds, 50, 50, 300, 200);
    myWindow = NewWindow(nil, &bounds, "\pMiniFinder", true, noGrowDocProc, (WindowPtr)-1, true, 0);

    // Main Event Loop
    while (true) {
        if (WaitNextEvent(everyEvent, &myEvent, 60, nil)) {
            switch (myEvent.what) {
                case mouseDown:
                    break;
                case keyDown:
                    break;
            }
        }
    }
}
