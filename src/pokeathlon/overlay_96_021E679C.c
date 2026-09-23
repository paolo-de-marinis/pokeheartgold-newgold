#include "global.h"

#include "pokeathlon/pokeathlon.h"

// The performance.narc member of a Pokemon on the course: its species'
// record and, after it, one for each form.
int ov96_021E679C(int species, int form) {
    return ov96_0221AAE8[species] + form;
}
