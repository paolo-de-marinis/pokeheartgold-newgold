#include "global.h"

#include "application/pokedex/pokedex_internal.h"

#include "bg_window.h"

// The Dex's windows are added from a table, from the first, and every window
// it adds is removed here: the front page's twenty (ov18_021EE3FC), the
// pages' hundred and one (ov18_021EEE58) and the other pages' sets.
void ov18_021EE35C(PokedexAppData *pokedexApp, const WindowTemplate *templates, u32 count) {
    u32 i;

    for (i = 0; i < count; i++) {
        AddWindow(pokedexApp->bgConfig, &pokedexApp->windows[i], &templates[i]);
    }
}

void ov18_021EE388(PokedexAppData *pokedexApp) {
    u32 i;

    for (i = 0; i < NELEMS(pokedexApp->windows); i++) {
        if (pokedexApp->windows[i].pixelBuffer != NULL) {
            RemoveWindow(&pokedexApp->windows[i]);
        }
    }
}
