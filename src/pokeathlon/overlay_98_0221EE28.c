#include "global.h"

#include "constants/species.h"

#include "bg_window.h"
#include "msgdata.h"
#include "text.h"

// What ov98_0221EE28 reads of the screen it prints on: the windows, the
// species names and the string the text is built in.
typedef struct Ov98Screen {
    u8 filler_00[4];
    Window *windows;           // 0x04
    MsgData *unk_08;           // 0x08
    MsgData *speciesNames;     // 0x0C
    MessageFormat *msgFormat;  // 0x10
    String *string;            // 0x14
} Ov98Screen;

void ov98_0221EE28(Ov98Screen *screen, int windowId, u16 species);

// A species' name in one of the screen's windows: the team of a course
// record (ov99_021E6144). A record keeps its species in nine bits, and one
// written before bb0a9def3 can hold 494..511 -- an added species, or one cut
// to nine bits; it is printed as no species ("-----"), which is how a record
// keeps an added species now, rather than failing the assertion retail had
// here, which resets the game.
void ov98_0221EE28(Ov98Screen *screen, int windowId, u16 species) {
    MsgData *speciesNames = screen->speciesNames;

    if (species > MAX_SPECIES) {
        species = SPECIES_NONE;
    }
    ReadMsgDataIntoString(speciesNames, species, screen->string);
    FillWindowPixelBuffer(&screen->windows[windowId], 0);
    AddTextPrinterParameterizedWithColor(&screen->windows[windowId], 0, screen->string, 0, 0, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(1, 2, 0), NULL);
    ScheduleWindowCopyToVram(&screen->windows[windowId]);
}
