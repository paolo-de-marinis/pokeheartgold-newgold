#include "constants/sndseq.h"

#include "pokemon_summary_app.h"
#include "unk_02005D10.h"
#include "system.h"

typedef char PokemonSummaryArgsCheck[offsetof(PokemonSummaryAppPrefix, args) == 0x22C ? 1 : -1];
typedef char PokemonSummaryMonCheck[offsetof(PokemonSummaryAppPrefix, mon.moves) == 0x264 ? 1 : -1];
typedef char PokemonSummaryPageCheck[offsetof(PokemonSummaryAppPrefix, page) == 0x7BC ? 1 : -1];
typedef char PokemonSummaryRibbonCountCheck[offsetof(PokemonSummaryAppPrefix, ribbonCount) == 0x7C6 ? 1 : -1];
typedef char PokemonSummaryArgsUnk17Check[offsetof(PokemonSummaryArgs, unk17) == 0x17 ? 1 : -1];

#define SUMMARY_PAGE_STATS   1
#define SUMMARY_PAGE_RIBBONS 2

extern void sub_02089E30(PokemonSummaryAppPrefix *summary, int delta);
extern u32 sub_02089E98(PokemonSummaryAppPrefix *summary);
extern void sub_0208A2C0(PokemonSummaryAppPrefix *summary, int delta);
extern int sub_0208A2E0(PokemonSummaryAppPrefix *summary, int delta);
extern void sub_0208ADB8(PokemonSummaryAppPrefix *summary, int a1);
extern int sub_0208ADCC(PokemonSummaryAppPrefix *summary);
extern int sub_0208AEB4(PokemonSummaryAppPrefix *summary);
extern int sub_0208AEC4(PokemonSummaryAppPrefix *summary);
extern u32 sub_0208B044(PokemonSummaryAppPrefix *summary, int state);
extern u32 sub_0208B0B0(PokemonSummaryAppPrefix *summary, int a1, int state);

u32 sub_02088B40(PokemonSummaryAppPrefix *summary) {
    int keys;
    int move;
    int ribbon;

    if (summary->unk7BF_4 == 1) {
        summary->args->unk17 = 1;
        return 0x15;
    }

    keys = gSystem.newAndRepeatedKeys;

    // New Gold shows what is behind the stats: L for the effort values, R for
    // the individual values, Select for the stats themselves. Nothing is
    // remembered — the page's own redraw puts the stats back — so this only
    // answers while the stats page is the one on screen.
    if (summary->page == SUMMARY_PAGE_STATS) {
        u32 mode = SUMMARY_STATS_RAW;

        if (keys & PAD_BUTTON_L) {
            mode = SUMMARY_STATS_EVS;
        } else if (keys & PAD_BUTTON_R) {
            mode = SUMMARY_STATS_IVS;
        } else if (!(keys & PAD_BUTTON_SELECT)) {
            mode = SUMMARY_STATS_NONE;
        }

        if (mode != SUMMARY_STATS_NONE) {
            PlaySE(SEQ_SE_DP_SELECT5);
            PokemonSummary_ShowStatValues(summary, mode);
            return 2;
        }
    }

    if (keys & PAD_KEY_LEFT) {
        sub_02089E30(summary, -1);
        return 2;
    }
    if (keys & PAD_KEY_RIGHT) {
        sub_02089E30(summary, 1);
        return 2;
    }
    if (keys & PAD_KEY_UP) {
        sub_0208A2C0(summary, -1);
        return 0x13;
    }
    if (keys & PAD_KEY_DOWN) {
        sub_0208A2C0(summary, 1);
        return 0x13;
    }

    if (gSystem.newKeys & PAD_BUTTON_B) {
        PlaySE(SEQ_SE_GS_GEARCANCEL);
        summary->args->unk17 = 1;
        sub_0208ADB8(summary, 0);
        return sub_0208B044(summary, 0x15);
    }

    if (gSystem.newKeys & PAD_BUTTON_A) {
        switch (summary->page) {
        case SUMMARY_PAGE_STATS:
            PlaySE(SEQ_SE_DP_SYU01);
            summary->unk7BD &= ~0xF;
            return 3;
        case SUMMARY_PAGE_RIBBONS:
            if (summary->ribbonCount != 0) {
                PlaySE(SEQ_SE_DP_DECIDE);
                summary->unk7C4 = 0;
                return 0xA;
            }
            break;
        }
    }

    if (summary->page == SUMMARY_PAGE_STATS) {
        move = sub_0208ADCC(summary);
        if (move != -1 && summary->mon.moves[move] != 0) {
            PlaySE(SEQ_SE_DP_SYU01);
            summary->unk7BD = (summary->unk7BD & ~0xF) | ((u8)move & 0xF);
            return 3;
        }
    }

    if (summary->page == SUMMARY_PAGE_RIBBONS) {
        ribbon = sub_0208AEC4(summary);
        if (ribbon != -1 && ribbon < 9 && ribbon < summary->ribbonCount) {
            PlaySE(SEQ_SE_DP_DECIDE);
            summary->unk7C4 = ribbon;
            return 0xA;
        }
    }

    if (summary->args->unk11 == 2) {
        int hit = sub_0208AEB4(summary);
        if (hit == 0) {
            if (sub_0208A2E0(summary, -1) != -1) {
                PlaySE(SEQ_SE_DP_DECIDE);
                return sub_0208B0B0(summary, 0, 0x14);
            }
            return 2;
        }
        if (hit == 1) {
            if (sub_0208A2E0(summary, 1) != -1) {
                PlaySE(SEQ_SE_DP_DECIDE);
                return sub_0208B0B0(summary, 1, 0x14);
            }
            return 2;
        }
    }

    return sub_02089E98(summary);
}
