#ifndef POKEHEARTGOLD_PC_BOX_DISPLAY_H
#define POKEHEARTGOLD_PC_BOX_DISPLAY_H

#include "bg_window.h"
#include "message_format.h"
#include "message_printer.h"
#include "msgdata.h"
#include "pokemon_types_def.h"

typedef struct PCBoxDisplayMon {
    BoxPokemon *mon;
    u16 species;
    u16 heldItem;
    u32 personality;
    u8 type1;
    u8 type2;
    // Original truncated field. No overlay 14 instruction uses record offset
    // 0x0E, so nothing reads it; the byte is kept to hold every later offset.
    u8 unusedAbility;
    u8 nature;
    u16 markings;
    u8 level : 7;
    u8 isEgg : 1;
    u8 gender : 7;
    u8 showGender : 1;
    u16 moves[MAX_MON_MOVES];
    // Appended so the remaining PC assembly keeps every original offset.
    u16 ability;
} PCBoxDisplayMon;

// Only the prefix of the existing PC graphics allocation is identified here.
// Do not allocate or copy the complete graphics state using this type's size.
typedef struct PCBoxGraphicsStatePrefix {
    u8 unk0[0x1C];
    MessagePrinter *messagePrinter;
    MsgData *msgData;
    MessageFormat *messageFormat;
    String *messageBuffer;
    u32 unk2C;
    // ov14_021F4ED0 and ov14_021F4F00 create and remove exactly 44 windows.
    Window windows[44];
} PCBoxGraphicsStatePrefix;

PCBoxDisplayMon *ov14_021E7358(BoxPokemon *mon);
struct PCBoxApp;
void ov14_021F5190(struct PCBoxApp *app, PCBoxDisplayMon *mon, int windowID);
void ov14_021F521C(PCBoxGraphicsStatePrefix *state, PCBoxDisplayMon *mon, int windowID);
void ov14_021F528C(PCBoxGraphicsStatePrefix *state, PCBoxDisplayMon *mon, int windowID);

#endif // POKEHEARTGOLD_PC_BOX_DISPLAY_H
