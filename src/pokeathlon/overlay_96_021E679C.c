#include "global.h"

#include "pokeathlon/pokeathlon.h"

// The performance.narc member of a Pokemon on the course: its species'
// record and, after it, one for each form. The table is retail's, one entry
// a species to 493; an added species has no record and runs with member 0,
// its form not added, as its summary shows it (CalcBoxMonPokeathlonPerformance).
// Read past its end, it gave whatever rodata follows it as the member.
int ov96_021E679C(int species, int form) {
    if (species >= (int)NELEMS(ov96_0221AAE8)) {
        return 0;
    }
    return ov96_0221AAE8[species] + form;
}
