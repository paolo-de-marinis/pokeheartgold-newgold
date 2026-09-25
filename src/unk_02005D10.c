#include "global.h"

#include "constants/species.h"

// The last species HeartGold records a cry for, and how many wave archives
// the sound archive holds once the added cries are in it. An added cry is a
// wave archive alone, played on bank 1's instrument (NNSi_SndArcLoadBank), so
// the number PlayCry asks for is bounded by the wave archives, not the banks.
// The last identifier the base archive has a cry for. The egg, the bad egg
// and the twelve alternate forms sit at 494 to 507 and have none, so the
// added species -- and sAddedCryBanks -- start at 508. This said 494, which
// put every added species thirteen entries along its own table: Lillipup
// played Karrablast's cry, and the last thirteen read past the end of the
// table entirely for whatever halfword followed it.
#define NUM_SPECIES_WITH_CRIES 507
#define ARCHIVE_WAVE_ARC_COUNT 1310

#include "heap.h"
#include "newgold/diag.h"
#include "sound_radio.h"
#include "sys_task.h"
#include "sys_task_api.h"

extern void GF_SndSetState(u32 state);
extern void *GF_SdatGetAttrPtr(u32 attr);
extern void GF_Snd_SaveState(int *level_p);
extern void GF_Snd_LoadState(int level);
extern void GF_Snd_LoadSeq(int seqNo);
extern void GF_Snd_LoadSeqEx(int seqNo, u32 loadFlag);
extern NNSSndHandle *GF_GetSoundHandle(int playerNo);
extern int GF_GetSndHandleByPlayerNo(int playerNo);
extern void sub_02004920(u16 seqNo);
extern void GF_SndWorkSetGbSoundsVolume(u8 volume);
extern u32 GF_SndPlayerCountPlayingSeqByPlayerNo(u32 playerNo);
extern void GF_SndHandleMoveVolume(int handleNo, int volume, int frames);
extern BOOL SoundSys_GetGBSoundsState(void);
extern u16 GF_GetCurrentPlayingBGM();
extern void sub_020053A8(u8 a0, u8 a1);
extern void GF_SetVolumeBySeqNo(u16 a0, u16 a1);
extern void GF_SndHandleSetInitialVolume(s32 a0, s32 a1);
extern BOOL sub_02005738(int a0);
extern void sub_02005600(int a0);
extern void sub_020058B8(int a0);
extern void sub_02005680(int a0);
extern void sub_02005774(int a0, int a1);
extern BOOL sub_02006D04(void *a0, u32 a1, s32 a2, s32 a3);
extern void sub_02006DB8(void);
extern void sub_02006E3C(u8 a0);
extern u8 GF_GetPlayerNoBySeq(int seqNo);
extern int GF_NNS_SndPlayerGetSeqNo(NNSSndHandle *handle);
extern void GF_GetBankInfoBySeqNo(u16 seqNo);
extern u16 GF_GetBankBySeqNo(int seqNo);
extern void GF_SetCurrentPlayingBGM(u16 seqNo);
extern void sub_02004A60(u16 seqNo);
extern void sub_02004AB8(u16 seqNo);
extern void sub_020051A4(int seqNo, int a1);
extern int sub_02005328(int a0);
extern void sub_02005464(int seqNo, int a1);
extern void sub_0200592C(u16 seqNo, int a1, int a2);
extern void sub_02005990(int a0);
extern void sub_020059E0(int a0);
extern BOOL sub_02005BFC(void);
extern void sub_02005728(int a0);
extern void sub_02005748(int a0, u8 a1);
extern void sub_02005760(int a0, int a1);
extern void sub_020057AC(int a0, int a1, int a2, int a3, int a4);
extern u16 GBSounds_GetGBSeqNoByDSSeqNo(u16 seqNo);
extern void GBSounds_SetAllocatableChannels(void);
extern void NNS_SndPlayerStopSeq(NNSSndHandle *handle, int fadeFrame);
extern void NNS_SndPlayerStopSeqBySeqNo(int seqNo, int fadeFrame);
extern void NNS_SndPlayerStopSeqAll(int fadeFrame);
extern void NNS_SndPlayerSetTrackPan(NNSSndHandle *handle, u32 track, int pan);
extern void GF_SndHandleSetTrackPan(int handleNo, int track, int pan);
extern void GF_SndHandleSetTrackPitch(int handleNo, int track, int pitch);

BOOL sub_02005D10(u16 seqNo);
BOOL PlayBGM(u16 seqNo);
void sub_02005DA0(u16 seqNo, int handleNo);
BOOL sub_02005DC4(u16 seqNo, int unused, int handleNo);
BOOL sub_02005DF4(u16 seqNo, int unused, int handleNo);
BOOL sub_02005E44(u16 seqNo);
void StopBGM(u16 seqNo, int fadeFrame);
void sub_02005EEC(void);
void GF_SndStartFadeInBGM(u32 a0, u32 a1, u32 a2);
void GF_SndStartFadeOutBGM(u16 a0, u16 a1);
BOOL GF_SndGetFadeTimer(void);
u32 sub_02005F94(u16 seqNo);
void Sound_Stop(void);
void sub_02005FD8(void);
BOOL sub_0200602C(u16 seqNo, int a1);
BOOL PlaySE(int seqNo);
BOOL sub_0200606C(u16 seqNo, int playerNo);
BOOL sub_02006088(u16 seqNo);
BOOL sub_020060BC(int handleNo, int playerNo, int bankNo, int playerPrio, u32 seqNo);
BOOL sub_02006118(u16 seqNo, u16 a1);
BOOL PlaySE_SetPitch(u16 seqNo, int pitch);
void StopSE(u16 seqNo, int fadeFrame);
void sub_0200615C(int handleIdx, int fadeFrame);
void sub_0200616C(void);
BOOL IsSEPlaying(u16 seqNo);
u32 sub_02006190(u32 playerNo);
BOOL GF_IsAnySEPlaying(void);
void sub_020061B4(u16 seqNo, int a1, int a2);
void sub_020061D0(int playerNo, int a1);
void sub_020061EC(int a0);
BOOL PlayCry(int species, int form);
BOOL sub_020062E0(u16 species, u8 a1, u8 form);
void sub_02006300(int a0);
BOOL IsCryFinished(void);
BOOL PlayCryEx(int mode, int species, int pan, int volume, int heapId, int form);
void sub_02006820(int species, int track, int volume);
void sub_02006838(int frames, int heapId);
void sub_02006884(SysTask *task, void *data);
void sub_020068F8(void);
void sub_02006920(int p0, u16 species, int pan, int volume, int heapId, u8 a5, u8 form);
BOOL sub_02006A0C(u32 species, u32 form);
void sub_02006A30(void);
BOOL sub_02006AC0(int species, int track, int form);
void sub_02006AF4(int species, int unused, int volAdj, int panHalf, int heapId);
BOOL PlayFanfare(u16 seqNo);
BOOL sub_02006B84(void *unused);
void sub_02006BB0(int a0);
BOOL IsFanfarePlaying(void);
void sub_02006C04(u16 unused);
BOOL sub_02006C14(int handleNo, int playerNo, int bankNo, int playerPrio, u16 seqNo, u8 checkGB);

typedef struct {
    s32 counter;
    SysTask *task;
} UnkStruct_02006838;

BOOL sub_02005D10(u16 seqNo) {
    BOOL result;
    int handleNo;
    handleNo = GF_GetSndHandleByPlayerNo(GF_GetPlayerNoBySeq(seqNo));
    result = sub_02006C14(handleNo, -1, -1, -1, seqNo, 1);
    if (!result) {
        sub_02004920(seqNo);
    }
    sub_02005DA0(seqNo, handleNo);
    return result;
}

BOOL PlayBGM(u16 seqNo) {
    u8 playerNo;
    int handleNo;
    BOOL result;
    playerNo = GF_GetPlayerNoBySeq(seqNo);
    handleNo = GF_GetSndHandleByPlayerNo(playerNo);
    if (playerNo == 7) {
        result = sub_02005DC4(seqNo, playerNo, handleNo);
    } else if (playerNo == 1) {
        result = sub_02005DF4(seqNo, playerNo, handleNo);
    } else {
        GF_AssertFail();
        return 0;
    }
    sub_020059E0(0);
    if (!result) {
        sub_02004920(seqNo);
    }
    sub_02005DA0(seqNo, handleNo);
    return result;
}

void sub_02005DA0(u16 seqNo, int handleNo) {
    sub_02004A60(seqNo);
    sub_02005464(seqNo, handleNo);
    GF_SndSetState(1);
    if (handleNo == 0) {
        GF_SndWorkSetGbSoundsVolume(0x80);
    }
}

BOOL sub_02005DC4(u16 seqNo, int unused, int handleNo) {
    GF_Snd_LoadState(sub_02005328(3));
    GF_Snd_LoadSeq(seqNo);
    return sub_02006C14(handleNo, -1, -1, -1, seqNo, 1);
}

BOOL sub_02005DF4(u16 seqNo, int unused, int handleNo) {
    u16 *p20;
    int bank;
    GF_SdatGetAttrPtr(0x13);
    p20 = GF_SdatGetAttrPtr(0x20);
    bank = GF_GetBankBySeqNo(GF_NNS_SndPlayerGetSeqNo(GF_GetSoundHandle(0)));
    sub_020051A4(seqNo, bank);
    SndRadio_StopSeq(0);
    bank = GF_GetBankBySeqNo(*p20);
    return sub_02006C14(handleNo, -1, bank, -1, seqNo, 1);
}

BOOL sub_02005E44(u16 seqNo) {
    u8 *p15;
    BOOL result;
    p15 = GF_SdatGetAttrPtr(0x15);
    if (*p15 != 4) {
        GF_AssertFail();
        return 0;
    }
    if (GF_GetPlayerNoBySeq(seqNo) != 7) {
        GF_AssertFail();
        return 0;
    }
    GF_Snd_LoadSeqEx(seqNo, 1);
    result = sub_02006C14(7, -1, -1, -1, seqNo, 1);
    if (!result) {
        sub_02004920(seqNo);
    }
    SndRadio_StopSeq(0);
    sub_02004A60(seqNo);
    GF_SndSetState(1);
    return result;
}

void StopBGM(u16 seqNo, int fadeFrame) {
    u16 gbSeqNo;
    u8 playerNo;
    NNS_SndPlayerStopSeqBySeqNo(seqNo, fadeFrame);
    gbSeqNo = GBSounds_GetGBSeqNoByDSSeqNo(seqNo);
    if (seqNo != gbSeqNo) {
        NNS_SndPlayerStopSeqBySeqNo(gbSeqNo, fadeFrame);
    }
    playerNo = GF_GetPlayerNoBySeq(seqNo);
    if (playerNo != 0xFF) {
        NNS_SndHandleReleaseSeq(GF_GetSoundHandle(GF_GetSndHandleByPlayerNo(playerNo)));
    }
    sub_02005EEC();
}

void sub_02005EEC(void) {
    SndRadio_StopSeq(0);
    sub_02004A60(0);
    GF_SetCurrentPlayingBGM(0);
    sub_02004AB8(0);
    GF_SndSetState(0);
}

void GF_SndStartFadeInBGM(u32 a0, u32 a1, u32 a2) {
    u8 playerNo;
    int handleNo;
    playerNo = GF_GetPlayerNoBySeq(GF_GetCurrentPlayingBGM());
    if (playerNo != 0xFF) {
        handleNo = GF_GetSndHandleByPlayerNo(playerNo);
        if (a2 == 0) {
            GF_SndHandleMoveVolume(handleNo, 0, 0);
        }
        GF_SndHandleMoveVolume(handleNo, a0, a1);
        sub_02005990(a1);
        GF_SndSetState(3);
    }
}

void GF_SndStartFadeOutBGM(u16 a0, u16 a1) {
    u8 playerNo;
    playerNo = GF_GetPlayerNoBySeq(GF_GetCurrentPlayingBGM());
    if (playerNo != 0xFF) {
        if (!GF_SndGetFadeTimer()) {
            GF_SndHandleMoveVolume(GF_GetSndHandleByPlayerNo(playerNo), a0, a1);
            sub_02005990(a1);
        }
        GF_SndSetState(4);
    }
}

BOOL GF_SndGetFadeTimer(void) {
    u16 *p;
    p = GF_SdatGetAttrPtr(7);
    return *p;
}

u32 sub_02005F94(u16 seqNo) {
    return GF_SndPlayerCountPlayingSeqByPlayerNo(GF_GetPlayerNoBySeq(seqNo));
}

void Sound_Stop(void) {
    u8 *p10;
    u8 *p11;
    p10 = GF_SdatGetAttrPtr(0x10);
    p11 = GF_SdatGetAttrPtr(0x11);
    NNS_SndPlayerStopSeqAll(0);
    if (*p10 == 1) {
        sub_02005728(0xE);
    }
    if (*p11 == 1) {
        sub_02005728(0xF);
    }
    GF_SndSetState(0);
}

void sub_02005FD8(void) {
    u8 *p10;
    u8 *p11;
    int i;
    p10 = GF_SdatGetAttrPtr(0x10);
    p11 = GF_SdatGetAttrPtr(0x11);
    NNS_SndPlayerStopSeq(GF_GetSoundHandle(7), 0);
    sub_02005EEC();
    for (i = 0; i < 4; i++) {
        sub_0200615C(i + 3, 0);
    }
    sub_02006300(0);
    if (*p10 == 1) {
        sub_02005728(0xE);
    }
    if (*p11 == 1) {
        sub_02005728(0xF);
    }
}

BOOL sub_0200602C(u16 seqNo, int a1) {
    BOOL result;
    result = PlaySE(seqNo);
    sub_020061B4(seqNo, 0xFFFF, a1);
    return result;
}

BOOL PlaySE(int seqNo) {
    int handleNo;
    handleNo = GF_GetSndHandleByPlayerNo(GF_GetPlayerNoBySeq(seqNo));
    return sub_020060BC(handleNo, -1, -1, -1, seqNo);
}

BOOL sub_0200606C(u16 seqNo, int playerNo) {
    int handleNo;
    handleNo = GF_GetSndHandleByPlayerNo(playerNo);
    return sub_020060BC(handleNo, playerNo, -1, -1, seqNo);
}

BOOL sub_02006088(u16 seqNo) {
    u16 *p20;
    int handleNo;
    int bank;
    p20 = GF_SdatGetAttrPtr(0x20);
    handleNo = GF_GetSndHandleByPlayerNo(GF_GetPlayerNoBySeq(seqNo));
    bank = GF_GetBankBySeqNo(*p20);
    return sub_020060BC(handleNo, -1, bank, -1, seqNo);
}

BOOL sub_020060BC(int handleNo, int playerNo, int bankNo, int playerPrio, u32 seqNo) {
    BOOL result;
    if (sub_02005BFC() == 1 && (u32)(seqNo - 0x5DC) <= 1) {
        return 0;
    }
    result = sub_02006C14(handleNo, playerNo, bankNo, playerPrio, (u16)seqNo, 0);
    sub_02005464(seqNo, handleNo);
    if (!result) {
        sub_02004920((u16)seqNo);
    }
    return result;
}

BOOL sub_02006118(u16 seqNo, u16 a1) {
    BOOL result;
    result = PlaySE(seqNo);
    if (result) {
        GF_SetVolumeBySeqNo(seqNo, a1);
    }
    return result;
}

BOOL PlaySE_SetPitch(u16 seqNo, int pitch) {
    BOOL result;
    result = PlaySE(seqNo);
    if (result) {
        sub_0200592C(seqNo, 0xFFFF, pitch);
    }
    return result;
}

void StopSE(u16 seqNo, int fadeFrame) {
    NNS_SndPlayerStopSeqBySeqNo(seqNo, fadeFrame);
}

void sub_0200615C(int handleIdx, int fadeFrame) {
    NNS_SndPlayerStopSeq(GF_GetSoundHandle(handleIdx), fadeFrame);
}

void sub_0200616C(void) {
    int i;
    for (i = 0; i < 4; i++) {
        sub_0200615C(i + 3, 0);
    }
}

BOOL IsSEPlaying(u16 seqNo) {
    return GF_SndPlayerCountPlayingSeqByPlayerNo(GF_GetPlayerNoBySeq(seqNo));
}

u32 sub_02006190(u32 playerNo) {
    return GF_SndPlayerCountPlayingSeqByPlayerNo(playerNo);
}

BOOL GF_IsAnySEPlaying(void) {
    int i;
    for (i = 0; i < 4; i++) {
        if (GF_SndPlayerCountPlayingSeqByPlayerNo(i + 3) == 1) {
            return TRUE;
        }
    }
    return FALSE;
}

void sub_020061B4(u16 seqNo, int a1, int a2) {
    NNSSndHandle *handle;
    handle = GF_GetSoundHandle(GF_GetSndHandleByPlayerNo(GF_GetPlayerNoBySeq(seqNo)));
    NNS_SndPlayerSetTrackPan(handle, a1, a2);
}

void sub_020061D0(int playerNo, int a1) {
    NNSSndHandle *handle;
    handle = GF_GetSoundHandle(GF_GetSndHandleByPlayerNo(playerNo));
    NNS_SndPlayerSetTrackPan(handle, 0xFFFF, a1);
}

void sub_020061EC(int a0) {
    int handleNo;
    int i;
    handleNo = GF_GetSndHandleByPlayerNo(3);
    for (i = 0; i < 4; i++) {
        NNS_SndPlayerSetTrackPan(GF_GetSoundHandle(handleNo + i), 0xFFFF, a0);
    }
}

// HeartGold's cries are bank N for species N, and its species stop at 494.
// The ones New Gold adds have banks of their own past the end of the archive,
// except the two regional forms, which use the cry their base species has.
// The numbers are where tools/newgold/import/import_cries.py put them.
static const u16 sAddedCryBanks[] = {
    778, // Lillipup
    779, // Herdier
    780, // Stoutland
    781, // Purrloin
    782, // Liepard
    783, // Tympole
    784, // Palpitoad
    785, // Seismitoad
    786, // Sewaddle
    787, // Swadloon
    788, // Leavanny
    789, // Yamask
    790, // Cofagrigus
    791, // Trubbish
    792, // Garbodor
    793, // Emolga
    794, // Karrablast
    795, // Escavalier
    796, // Foongus
    797, // Amoonguss
    798, // Joltik
    799, // Galvantula
    800, // Ferroseed
    801, // Ferrothorn
    802, // Klink
    803, // Klang
    804, // Klinklang
    805, // Elgyem
    806, // Beheeyem
    807, // Litwick
    808, // Lampent
    809, // Chandelure
    810, // Shelmet
    811, // Accelgor
    812, // Bouffalant
    813, // Bunnelby
    814, // Diggersby
    815, // Fletchling
    816, // Fletchinder
    817, // Talonflame
    818, // Litleo
    819, // Pyroar
    820, // Espurr
    821, // Meowstic
    822, // Sylveon
    823, // Dedenne
    824, // Phantump
    825, // Trevenant
    826, // Pumpkaboo
    827, // Gourgeist
    828, // Noibat
    829, // Noivern
    830, // Applin
    831, // Flapple
    832, // Appletun
    833, // Sizzlipede
    834, // Centiskorch
    835, // Wyrdeer
    836, // Kleavor
    837, // Ursaluna
    838, // Annihilape
    839, // Farigiraf
    840, // Dudunsparce
    841, // Dipplin
    842, // Hydrapple
    79, // Slowpoke Galarian
    80, // Slowbro Galarian
    843, // Victini
    844, // Snivy
    845, // Servine
    846, // Serperior
    847, // Tepig
    848, // Pignite
    849, // Emboar
    850, // Oshawott
    851, // Dewott
    852, // Samurott
    853, // Patrat
    854, // Watchog
    855, // Pansage
    856, // Simisage
    857, // Pansear
    858, // Simisear
    859, // Panpour
    860, // Simipour
    861, // Munna
    862, // Musharna
    863, // Pidove
    864, // Tranquill
    865, // Unfezant
    866, // Blitzle
    867, // Zebstrika
    868, // Roggenrola
    869, // Boldore
    870, // Gigalith
    871, // Woobat
    872, // Swoobat
    873, // Drilbur
    874, // Excadrill
    875, // Audino
    876, // Timburr
    877, // Gurdurr
    878, // Conkeldurr
    879, // Throh
    880, // Sawk
    881, // Venipede
    882, // Whirlipede
    883, // Scolipede
    884, // Cottonee
    885, // Whimsicott
    886, // Petilil
    887, // Lilligant
    888, // Basculin
    889, // Sandile
    890, // Krokorok
    891, // Krookodile
    892, // Darumaka
    893, // Darmanitan
    894, // Maractus
    895, // Dwebble
    896, // Crustle
    897, // Scraggy
    898, // Scrafty
    899, // Sigilyph
    900, // Tirtouga
    901, // Carracosta
    902, // Archen
    903, // Archeops
    904, // Zorua
    905, // Zoroark
    906, // Minccino
    907, // Cinccino
    908, // Gothita
    909, // Gothorita
    910, // Gothitelle
    911, // Solosis
    912, // Duosion
    913, // Reuniclus
    914, // Ducklett
    915, // Swanna
    916, // Vanillite
    917, // Vanillish
    918, // Vanilluxe
    919, // Deerling
    920, // Sawsbuck
    921, // Frillish
    922, // Jellicent
    923, // Alomomola
    924, // Tynamo
    925, // Eelektrik
    926, // Eelektross
    927, // Axew
    928, // Fraxure
    929, // Haxorus
    930, // Cubchoo
    931, // Beartic
    932, // Cryogonal
    933, // Stunfisk
    934, // Mienfoo
    935, // Mienshao
    936, // Druddigon
    937, // Golett
    938, // Golurk
    939, // Pawniard
    940, // Bisharp
    941, // Rufflet
    942, // Braviary
    943, // Vullaby
    944, // Mandibuzz
    945, // Heatmor
    946, // Durant
    947, // Deino
    948, // Zweilous
    949, // Hydreigon
    950, // Larvesta
    951, // Volcarona
    952, // Cobalion
    953, // Terrakion
    954, // Virizion
    955, // Tornadus
    956, // Thundurus
    957, // Reshiram
    958, // Zekrom
    959, // Landorus
    960, // Kyurem
    961, // Keldeo
    962, // Meloetta
    963, // Genesect
    964, // Chespin
    965, // Quilladin
    966, // Chesnaught
    967, // Fennekin
    968, // Braixen
    969, // Delphox
    970, // Froakie
    971, // Frogadier
    972, // Greninja
    973, // Scatterbug
    974, // Spewpa
    975, // Vivillon
    976, // Flabebe
    977, // Floette
    978, // Florges
    979, // Skiddo
    980, // Gogoat
    981, // Pancham
    982, // Pangoro
    983, // Furfrou
    984, // Honedge
    985, // Doublade
    986, // Aegislash
    987, // Spritzee
    988, // Aromatisse
    989, // Swirlix
    990, // Slurpuff
    991, // Inkay
    992, // Malamar
    993, // Binacle
    994, // Barbaracle
    995, // Skrelp
    996, // Dragalge
    997, // Clauncher
    998, // Clawitzer
    999, // Helioptile
    1000, // Heliolisk
    1001, // Tyrunt
    1002, // Tyrantrum
    1003, // Amaura
    1004, // Aurorus
    1005, // Hawlucha
    1006, // Carbink
    1007, // Goomy
    1008, // Sliggoo
    1009, // Goodra
    1010, // Klefki
    1011, // Bergmite
    1012, // Avalugg
    1013, // Xerneas
    1014, // Yveltal
    1015, // Zygarde
    1016, // Diancie
    1017, // Hoopa
    1018, // Volcanion
    1019, // Rowlet
    1020, // Dartrix
    1021, // Decidueye
    1022, // Litten
    1023, // Torracat
    1024, // Incineroar
    1025, // Popplio
    1026, // Brionne
    1027, // Primarina
    1028, // Pikipek
    1029, // Trumbeak
    1030, // Toucannon
    1031, // Yungoos
    1032, // Gumshoos
    1033, // Grubbin
    1034, // Charjabug
    1035, // Vikavolt
    1036, // Crabrawler
    1037, // Crabominable
    1038, // Oricorio
    1039, // Cutiefly
    1040, // Ribombee
    1041, // Rockruff
    1042, // Lycanroc
    1043, // Wishiwashi
    1044, // Mareanie
    1045, // Toxapex
    1046, // Mudbray
    1047, // Mudsdale
    1048, // Dewpider
    1049, // Araquanid
    1050, // Fomantis
    1051, // Lurantis
    1052, // Morelull
    1053, // Shiinotic
    1054, // Salandit
    1055, // Salazzle
    1056, // Stufful
    1057, // Bewear
    1058, // Bounsweet
    1059, // Steenee
    1060, // Tsareena
    1061, // Comfey
    1062, // Oranguru
    1063, // Passimian
    1064, // Wimpod
    1065, // Golisopod
    1066, // Sandygast
    1067, // Palossand
    1068, // Pyukumuku
    1069, // Type Null
    1070, // Silvally
    1071, // Minior
    1072, // Komala
    1073, // Turtonator
    1074, // Togedemaru
    1075, // Mimikyu
    1076, // Bruxish
    1077, // Drampa
    1078, // Dhelmise
    1079, // Jangmo O
    1080, // Hakamo O
    1081, // Kommo O
    1082, // Tapu Koko
    1083, // Tapu Lele
    1084, // Tapu Bulu
    1085, // Tapu Fini
    1086, // Cosmog
    1087, // Cosmoem
    1088, // Solgaleo
    1089, // Lunala
    1090, // Nihilego
    1091, // Buzzwole
    1092, // Pheromosa
    1093, // Xurkitree
    1094, // Celesteela
    1095, // Kartana
    1096, // Guzzlord
    1097, // Necrozma
    1098, // Magearna
    1099, // Marshadow
    1100, // Poipole
    1101, // Naganadel
    1102, // Stakataka
    1103, // Blacephalon
    1104, // Zeraora
    1105, // Meltan
    1106, // Melmetal
    1107, // Grookey
    1108, // Thwackey
    1109, // Rillaboom
    1110, // Scorbunny
    1111, // Raboot
    1112, // Cinderace
    1113, // Sobble
    1114, // Drizzile
    1115, // Inteleon
    1116, // Skwovet
    1117, // Greedent
    1118, // Rookidee
    1119, // Corvisquire
    1120, // Corviknight
    1121, // Blipbug
    1122, // Dottler
    1123, // Orbeetle
    1124, // Nickit
    1125, // Thievul
    1126, // Gossifleur
    1127, // Eldegoss
    1128, // Wooloo
    1129, // Dubwool
    1130, // Chewtle
    1131, // Drednaw
    1132, // Yamper
    1133, // Boltund
    1134, // Rolycoly
    1135, // Carkol
    1136, // Coalossal
    1137, // Silicobra
    1138, // Sandaconda
    1139, // Cramorant
    1140, // Arrokuda
    1141, // Barraskewda
    1142, // Toxel
    1143, // Toxtricity
    1144, // Clobbopus
    1145, // Grapploct
    1146, // Sinistea
    1147, // Polteageist
    1148, // Hatenna
    1149, // Hattrem
    1150, // Hatterene
    1151, // Impidimp
    1152, // Morgrem
    1153, // Grimmsnarl
    1154, // Obstagoon
    1155, // Perrserker
    1156, // Cursola
    1157, // Sirfetchd
    1158, // Mr Rime
    1159, // Runerigus
    1160, // Milcery
    1161, // Alcremie
    1162, // Falinks
    1163, // Pincurchin
    1164, // Snom
    1165, // Frosmoth
    1166, // Stonjourner
    1167, // Eiscue
    1168, // Indeedee
    1169, // Morpeko
    1170, // Cufant
    1171, // Copperajah
    1172, // Dracozolt
    1173, // Arctozolt
    1174, // Dracovish
    1175, // Arctovish
    1176, // Duraludon
    1177, // Dreepy
    1178, // Drakloak
    1179, // Dragapult
    1180, // Zacian
    1181, // Zamazenta
    1182, // Eternatus
    1183, // Kubfu
    1184, // Urshifu
    1185, // Zarude
    1186, // Regieleki
    1187, // Regidrago
    1188, // Glastrier
    1189, // Spectrier
    1190, // Calyrex
    1191, // Basculegion
    1192, // Sneasler
    1193, // Overqwil
    1194, // Enamorus
    1195, // Sprigatito
    1196, // Floragato
    1197, // Meowscarada
    1198, // Fuecoco
    1199, // Crocalor
    1200, // Skeledirge
    1201, // Quaxly
    1202, // Quaxwell
    1203, // Quaquaval
    1204, // Lechonk
    1205, // Oinkologne
    1206, // Tarountula
    1207, // Spidops
    1208, // Nymble
    1209, // Lokix
    1210, // Pawmi
    1211, // Pawmo
    1212, // Pawmot
    1213, // Tandemaus
    1214, // Maushold
    1215, // Fidough
    1216, // Dachsbun
    1217, // Smoliv
    1218, // Dolliv
    1219, // Arboliva
    1220, // Squawkabilly
    1221, // Nacli
    1222, // Naclstack
    1223, // Garganacl
    1224, // Charcadet
    1225, // Armarouge
    1226, // Ceruledge
    1227, // Tadbulb
    1228, // Bellibolt
    1229, // Wattrel
    1230, // Kilowattrel
    1231, // Maschiff
    1232, // Mabosstiff
    1233, // Shroodle
    1234, // Grafaiai
    1235, // Bramblin
    1236, // Brambleghast
    1237, // Toedscool
    1238, // Toedscruel
    1239, // Klawf
    1240, // Capsakid
    1241, // Scovillain
    1242, // Rellor
    1243, // Rabsca
    1244, // Flittle
    1245, // Espathra
    1246, // Tinkatink
    1247, // Tinkatuff
    1248, // Tinkaton
    1249, // Wiglett
    1250, // Wugtrio
    1251, // Bombirdier
    1252, // Finizen
    1253, // Palafin
    1254, // Varoom
    1255, // Revavroom
    1256, // Cyclizar
    1257, // Orthworm
    1258, // Glimmet
    1259, // Glimmora
    1260, // Greavard
    1261, // Houndstone
    1262, // Flamigo
    1263, // Cetoddle
    1264, // Cetitan
    1265, // Veluza
    1266, // Dondozo
    1267, // Tatsugiri
    1268, // Clodsire
    1269, // Kingambit
    1270, // Great Tusk
    1271, // Scream Tail
    1272, // Brute Bonnet
    1273, // Flutter Mane
    1274, // Slither Wing
    1275, // Sandy Shocks
    1276, // Iron Treads
    1277, // Iron Bundle
    1278, // Iron Hands
    1279, // Iron Jugulis
    1280, // Iron Moth
    1281, // Iron Thorns
    1282, // Frigibax
    1283, // Arctibax
    1284, // Baxcalibur
    1285, // Gimmighoul
    1286, // Gholdengo
    1287, // Wo Chien
    1288, // Chien Pao
    1289, // Ting Lu
    1290, // Chi Yu
    1291, // Roaring Moon
    1292, // Iron Valiant
    1293, // Koraidon
    1294, // Miraidon
    1295, // Walking Wake
    1296, // Iron Leaves
    1297, // Poltchageist
    1298, // Sinistcha
    1299, // Okidogi
    1300, // Munkidori
    1301, // Fezandipiti
    1302, // Ogerpon
    1303, // Archaludon
    1304, // Gouging Fire
    1305, // Raging Bolt
    1306, // Iron Boulder
    1307, // Iron Crown
    1308, // Terapagos
    1309, // Pecharunt
    3, // Mega Venusaur
    6, // Mega Charizard X
    6, // Mega Charizard Y
    9, // Mega Blastoise
    15, // Mega Beedrill
    18, // Mega Pidgeot
    65, // Mega Alakazam
    80, // Mega Slowbro
    94, // Mega Gengar
    115, // Mega Kangaskhan
    127, // Mega Pinsir
    130, // Mega Gyarados
    142, // Mega Aerodactyl
    150, // Mega Mewtwo X
    150, // Mega Mewtwo Y
    181, // Mega Ampharos
    208, // Mega Steelix
    212, // Mega Scizor
    214, // Mega Heracross
    229, // Mega Houndoom
    248, // Mega Tyranitar
    254, // Mega Sceptile
    257, // Mega Blaziken
    260, // Mega Swampert
    282, // Mega Gardevoir
    302, // Mega Sableye
    303, // Mega Mawile
    306, // Mega Aggron
    308, // Mega Medicham
    310, // Mega Manectric
    319, // Mega Sharpedo
    323, // Mega Camerupt
    334, // Mega Altaria
    354, // Mega Banette
    359, // Mega Absol
    362, // Mega Glalie
    373, // Mega Salamence
    376, // Mega Metagross
    380, // Mega Latias
    381, // Mega Latios
    384, // Mega Rayquaza
    428, // Mega Lopunny
    445, // Mega Garchomp
    448, // Mega Lucario
    460, // Mega Abomasnow
    475, // Mega Gallade
    875, // Mega Audino
    1016, // Mega Diancie
    382, // Kyogre Primal
    383, // Groudon Primal
    19, // Rattata Alolan
    20, // Raticate Alolan
    26, // Raichu Alolan
    27, // Sandshrew Alolan
    28, // Sandslash Alolan
    37, // Vulpix Alolan
    38, // Ninetales Alolan
    50, // Diglett Alolan
    51, // Dugtrio Alolan
    52, // Meowth Alolan
    53, // Persian Alolan
    74, // Geodude Alolan
    75, // Graveler Alolan
    76, // Golem Alolan
    88, // Grimer Alolan
    89, // Muk Alolan
    103, // Exeggutor Alolan
    105, // Marowak Alolan
    20, // Raticate Alolan Large
    105, // Marowak Alolan Large
    1032, // Gumshoos Large
    1035, // Vikavolt Large
    1040, // Ribombee Large
    1049, // Araquanid Large
    1051, // Lurantis Large
    1055, // Salazzle Large
    1074, // Togedemaru Large
    1075, // Mimikyu Large
    1075, // Mimikyu Busted Large
    1081, // Kommo O Large
    52, // Meowth Galarian
    77, // Ponyta Galarian
    78, // Rapidash Galarian
    83, // Farfetchd Galarian
    110, // Weezing Galarian
    122, // Mr Mime Galarian
    144, // Articuno Galarian
    145, // Zapdos Galarian
    146, // Moltres Galarian
    199, // Slowking Galarian
    222, // Corsola Galarian
    263, // Zigzagoon Galarian
    264, // Linoone Galarian
    892, // Darumaka Galarian
    893, // Darmanitan Galarian
    789, // Yamask Galarian
    933, // Stunfisk Galarian
    25, // Pikachu Cosplay
    25, // Pikachu Rock Star
    25, // Pikachu Belle
    25, // Pikachu Pop Star
    25, // Pikachu Ph D
    25, // Pikachu Libre
    25, // Pikachu Original Cap
    25, // Pikachu Hoenn Cap
    25, // Pikachu Sinnoh Cap
    25, // Pikachu Unova Cap
    25, // Pikachu Kalos Cap
    25, // Pikachu Alola Cap
    25, // Pikachu Partner Cap
    25, // Pikachu World Cap
    351, // Castform Sunny
    351, // Castform Rainy
    351, // Castform Snowy
    421, // Cherrim Sunshine
    422, // Shellos East Sea
    423, // Gastrodon East Sea
    483, // Dialga Origin
    484, // Palkia Origin
    888, // Basculin Blue Striped
    888, // Basculin White Striped
    893, // Darmanitan Zen Mode
    893, // Darmanitan Zen Mode Galarian
    919, // Deerling Summer
    919, // Deerling Autumn
    919, // Deerling Winter
    920, // Sawsbuck Summer
    920, // Sawsbuck Autumn
    920, // Sawsbuck Winter
    955, // Tornadus Therian
    956, // Thundurus Therian
    959, // Landorus Therian
    960, // Kyurem White
    960, // Kyurem Black
    961, // Keldeo Resolute
    962, // Meloetta Pirouette
    963, // Genesect Douse Drive
    963, // Genesect Shock Drive
    963, // Genesect Burn Drive
    963, // Genesect Chill Drive
    972, // Greninja Battle Bond
    972, // Greninja Ash
    975, // Vivillon Polar
    975, // Vivillon Tundra
    975, // Vivillon Continental
    975, // Vivillon Garden
    975, // Vivillon Elegant
    975, // Vivillon Meadow
    975, // Vivillon Modern
    975, // Vivillon Marine
    975, // Vivillon Archipelago
    975, // Vivillon High Plains
    975, // Vivillon Sandstorm
    975, // Vivillon River
    975, // Vivillon Monsoon
    975, // Vivillon Savanna
    975, // Vivillon Sun
    975, // Vivillon Ocean
    975, // Vivillon Jungle
    975, // Vivillon Fancy
    975, // Vivillon Poke Ball
    976, // Flabebe Yellow Flower
    976, // Flabebe Orange Flower
    976, // Flabebe Blue Flower
    976, // Flabebe White Flower
    977, // Floette Yellow Flower
    977, // Floette Orange Flower
    977, // Floette Blue Flower
    977, // Floette White Flower
    977, // Floette Eternal Flower
    978, // Florges Yellow Flower
    978, // Florges Orange Flower
    978, // Florges Blue Flower
    978, // Florges White Flower
    983, // Furfrou Heart
    983, // Furfrou Star
    983, // Furfrou Diamond
    983, // Furfrou Debutante
    983, // Furfrou Matron
    983, // Furfrou Dandy
    983, // Furfrou La Reine
    983, // Furfrou Kabuki
    983, // Furfrou Pharaoh
    986, // Aegislash Blade
    826, // Pumpkaboo Small
    826, // Pumpkaboo Large
    826, // Pumpkaboo Super
    827, // Gourgeist Small
    827, // Gourgeist Large
    827, // Gourgeist Super
    1013, // Xerneas Active
    1015, // Zygarde 10
    1015, // Zygarde 10 Power Construct
    1015, // Zygarde 50 Power Construct
    1015, // Zygarde 10 Complete
    1015, // Zygarde 50 Complete
    1017, // Hoopa Unbound
    1038, // Oricorio Pom Pom
    1038, // Oricorio Pau
    1038, // Oricorio Sensu
    1041, // Rockruff Own Tempo
    1042, // Lycanroc Midnight
    1042, // Lycanroc Dusk
    1043, // Wishiwashi School
    1071, // Minior Meteor Orange
    1071, // Minior Meteor Yellow
    1071, // Minior Meteor Green
    1071, // Minior Meteor Blue
    1071, // Minior Meteor Indigo
    1071, // Minior Meteor Violet
    1071, // Minior Core Red
    1071, // Minior Core Orange
    1071, // Minior Core Yellow
    1071, // Minior Core Green
    1071, // Minior Core Blue
    1071, // Minior Core Indigo
    1071, // Minior Core Violet
    1075, // Mimikyu Busted
    1097, // Necrozma Dusk Mane
    1097, // Necrozma Dawn Wings
    1097, // Necrozma Ultra Dusk Mane
    1097, // Necrozma Ultra Dawn Wings
    1098, // Magearna Original
    25, // Pikachu Partner
    133, // Eevee Partner
    1139, // Cramorant Gulping
    1139, // Cramorant Gorging
    1143, // Toxtricity Low Key
    1146, // Sinistea Antique
    1147, // Polteageist Antique
    1161, // Alcremie Berry Sweet
    1161, // Alcremie Love Sweet
    1161, // Alcremie Star Sweet
    1161, // Alcremie Clover Sweet
    1161, // Alcremie Flower Sweet
    1161, // Alcremie Ribbon Sweet
    1167, // Eiscue Noice Face
    1169, // Morpeko Hangry
    1180, // Zacian Crowned
    1181, // Zamazenta Crowned
    1182, // Eternatus Eternamax
    1184, // Urshifu Rapid Strike
    1185, // Zarude Dada
    1190, // Calyrex Ice Rider
    1190, // Calyrex Shadow Rider
    1194, // Enamorus Therian
    58, // Growlithe Hisuian
    59, // Arcanine Hisuian
    100, // Voltorb Hisuian
    101, // Electrode Hisuian
    157, // Typhlosion Hisuian
    211, // Qwilfish Hisuian
    215, // Sneasel Hisuian
    852, // Samurott Hisuian
    887, // Lilligant Hisuian
    904, // Zorua Hisuian
    905, // Zoroark Hisuian
    942, // Braviary Hisuian
    1008, // Sliggoo Hisuian
    1009, // Goodra Hisuian
    1012, // Avalugg Hisuian
    1021, // Decidueye Hisuian
    836, // Kleavor Lord
    887, // Lilligant Lady
    59, // Arcanine Lord
    101, // Electrode Lord
    1012, // Avalugg Lord
    865, // Unfezant Female
    921, // Frillish Female
    922, // Jellicent Female
    819, // Pyroar Female
    821, // Meowstic Female
    1168, // Indeedee Female
    1191, // Basculegion Female
    1214, // Maushold Family Of Three
    1220, // Squawkabilly Blue Plumage
    1220, // Squawkabilly Yellow Plumage
    1220, // Squawkabilly White Plumage
    1253, // Palafin Hero
    1267, // Tatsugiri Droopy
    1267, // Tatsugiri Stretchy
    840, // Dudunsparce Three Segment
    1285, // Gimmighoul Roaming
    194, // Wooper Paldean
    128, // Tauros Combat
    128, // Tauros Blaze
    128, // Tauros Aqua
    1205, // Oinkologne Female
    1255, // Revavroom Segin
    1255, // Revavroom Schedar
    1255, // Revavroom Navi
    1255, // Revavroom Ruchbah
    1255, // Revavroom Caph
    1293, // Koraidon Limited Build
    1293, // Koraidon Sprinting Build
    1293, // Koraidon Swimming Build
    1293, // Koraidon Gliding Build
    1294, // Miraidon Low Power Mode
    1294, // Miraidon Drive Mode
    1294, // Miraidon Aquatic Mode
    1294, // Miraidon Glide Mode
    1297, // Poltchageist Masterpiece
    1298, // Sinistcha Masterpiece
    1302, // Ogerpon Wellspring Mask
    1302, // Ogerpon Hearthflame Mask
    1302, // Ogerpon Cornerstone Mask
    1302, // Ogerpon Teal Mask Terastal
    1302, // Ogerpon Wellspring Mask Terastal
    1302, // Ogerpon Hearthflame Mask Terastal
    1302, // Ogerpon Cornerstone Mask Terastal
    837, // Ursaluna Bloodmoon
    1308, // Terapagos Terastal
    1308, // Terapagos Stellar
    3, // Gigantamax Venusaur
    6, // Gigantamax Charizard
    9, // Gigantamax Blastoise
    12, // Gigantamax Butterfree
    25, // Gigantamax Pikachu
    52, // Gigantamax Meowth
    68, // Gigantamax Machamp
    94, // Gigantamax Gengar
    99, // Gigantamax Kingler
    131, // Gigantamax Lapras
    133, // Gigantamax Eevee
    143, // Gigantamax Snorlax
    792, // Gigantamax Garbodor
    1106, // Gigantamax Melmetal
    1109, // Gigantamax Rillaboom
    1112, // Gigantamax Cinderace
    1115, // Gigantamax Inteleon
    1120, // Gigantamax Corviknight
    1123, // Gigantamax Orbeetle
    1131, // Gigantamax Drednaw
    1136, // Gigantamax Coalossal
    831, // Gigantamax Flapple
    832, // Gigantamax Appletun
    1138, // Gigantamax Sandaconda
    1143, // Gigantamax Toxtricity
    1143, // Gigantamax Toxtricity Low Key
    834, // Gigantamax Centiskorch
    1150, // Gigantamax Hatterene
    1153, // Gigantamax Grimmsnarl
    1161, // Gigantamax Alcremie
    1171, // Gigantamax Copperajah
    1176, // Gigantamax Duraludon
    1184, // Gigantamax Urshifu
    1184, // Gigantamax Urshifu Rapid Strike
    26, // Mega Raichu X
    26, // Mega Raichu Y
    36, // Mega Clefable
    71, // Mega Victreebel
    121, // Mega Starmie
    149, // Mega Dragonite
    154, // Mega Meganium
    160, // Mega Feraligatr
    227, // Mega Skarmory
    358, // Mega Chimecho
    359, // Mega Absol Z
    398, // Mega Staraptor
    445, // Mega Garchomp Z
    448, // Mega Lucario Z
    478, // Mega Froslass
    485, // Mega Heatran
    491, // Mega Darkrai
    849, // Mega Emboar
    874, // Mega Excadrill
    883, // Mega Scolipede
    898, // Mega Scrafty
    926, // Mega Eelektross
    809, // Mega Chandelure
    938, // Mega Golurk
    966, // Mega Chesnaught
    969, // Mega Delphox
    972, // Mega Greninja
    819, // Mega Pyroar
    977, // Mega Floette
    821, // Mega Meowstic
    821, // Mega Meowstic Female
    992, // Mega Malamar
    994, // Mega Barbaracle
    996, // Mega Dragalge
    1005, // Mega Hawlucha
    1015, // Mega Zygarde
    1037, // Mega Crabominable
    1065, // Mega Golisopod
    1077, // Mega Drampa
    1098, // Mega Magearna
    1098, // Mega Magearna Original
    1104, // Mega Zeraora
    1162, // Mega Falinks
    1241, // Mega Scovillain
    1259, // Mega Glimmora
    1267, // Mega Tatsugiri
    1267, // Mega Tatsugiri Droopy
    1267, // Mega Tatsugiri Stretchy
    1284, // Mega Baxcalibur
};

static int CryBankForSpecies(int species) {
    if (species > NUM_SPECIES_WITH_CRIES && species <= NUM_SPECIES) {
        return sAddedCryBanks[species - NUM_SPECIES_WITH_CRIES - 1];
    }
    return species;
}

BOOL PlayCry(int species, int form) {
    u8 *p12;
    void **p24;
    u8 *p35;
    int result;
#ifdef NEWGOLD_DIAG
    u32 diagAsked = (u32)species | ((u32)form << 16);
#endif
    p12 = GF_SdatGetAttrPtr(0x12);
    p24 = GF_SdatGetAttrPtr(0x24);
    p35 = GF_SdatGetAttrPtr(0x35);
    if (sub_02006A0C(species, form) == 1) {
        species = 0x1EE;
    }
    if (species != 0x1EE) {
        species = CryBankForSpecies(species);
        if ((u32)species >= ARCHIVE_WAVE_ARC_COUNT || species == 0) {
            species = 1;
        }
    }
    if (species == 0x1B9) {
        if (sub_02006D04(*p24, 0, 0x7F, 0) == 1) {
            sub_02006E3C(0);
            return 1;
        }
    }
    if (*p12 == 0) {
        if (*p35 == 0) {
            sub_02006300(0);
        }
        result = sub_02006C14(1, -1, species, -1, 2, 0);
        sub_02005464(species, 1);
    } else {
        result = sub_02006C14(8, -1, species, -1, 2, 0);
        sub_02005464(species, 8);
    }
#ifdef NEWGOLD_DIAG
    Diag_Cry(diagAsked, species, result);
#endif
    sub_02006E3C(0);
    return result;
}

BOOL sub_020062E0(u16 species, u8 a1, u8 form) {
    sub_02006920(0, species, 0, 0x7F, 0xB, a1, form);
    return 1;
}

void sub_02006300(int a0) {
    u8 *p10;
    u8 *p11;
    p10 = GF_SdatGetAttrPtr(0x10);
    p11 = GF_SdatGetAttrPtr(0x11);
    GF_SdatGetAttrPtr(0xF);
    NNS_SndPlayerStopSeq(GF_GetSoundHandle(1), a0);
    NNS_SndPlayerStopSeq(GF_GetSoundHandle(8), a0);
    if (*p10 == 1) {
        sub_020058B8(0xE);
        sub_02005680(0xE);
    }
    if (*p11 == 1) {
        sub_020058B8(0xF);
        sub_02005680(0xF);
    }
    sub_02006DB8();
    sub_02006A30();
}

BOOL IsCryFinished(void) {
    u8 *p10;
    u8 *p11;
    p10 = GF_SdatGetAttrPtr(0x10);
    p11 = GF_SdatGetAttrPtr(0x11);
    GF_SdatGetAttrPtr(0xF);
    GF_SdatGetAttrPtr(0x2E);
    if (*p10 == 1) {
        return sub_02005738(0xE);
    }
    if (*p11 == 1) {
        return sub_02005738(0xF);
    }
    return GF_SndPlayerCountPlayingSeqByPlayerNo(0);
}

BOOL PlayCryEx(int mode, int species, int pan, int volume, int heapId, int form) {
    int bank;
    int panHalf;
    int volAdj;
    u8 *p10;
    u8 *p11;
    u8 *p12;
    u8 *p1e;

    heapId = heapId;
    p10 = GF_SdatGetAttrPtr(0x10);
    p11 = GF_SdatGetAttrPtr(0x11);
    p12 = GF_SdatGetAttrPtr(0x12);
    p1e = GF_SdatGetAttrPtr(0x1E);
    GF_SdatGetAttrPtr(0x24);

    if (sub_02006A0C(species, form) == 1) {
        species = 0x1EE;
    }
    // A species and its bank were the same number until the added ones needed
    // one, so the mapping went into PlayCry and into here, and then this
    // function handed its already-mapped number back to PlayCry -- which
    // mapped it a second time. That is only harmless while the bank falls
    // outside the species range: 199 of the 534 added banks do not, Cryogonal
    // at 997 among them, and those played another Pokemon's cry. So the
    // species stays a species here, for PlayCry and sub_02006AC0, which map it
    // themselves; `bank` is what the archive is asked for.
    bank = species;
    if (bank != 0x1EE) {
        bank = CryBankForSpecies(bank);
        if ((u32)bank >= ARCHIVE_WAVE_ARC_COUNT || bank == 0) {
            bank = 1;
        }
    }

    panHalf = pan / 2 + 0x40;

    volAdj = volume;
    volAdj -= 30;
    if (volAdj <= 0) {
        volAdj = 1;
    }

    *p12 = 0;
    if (*p10 == 1) {
        sub_020058B8(0xE);
        sub_02005680(0xE);
    }
    if (*p11 == 1) {
        sub_020058B8(0xF);
        sub_02005680(0xF);
    }

    if (species == 0x1B9) {
        switch (mode) {
        case 0:
        case 1:
        case 2:
        case 5:
        case 11:
        case 12:
            PlayCry(0x1B9, form);
            if (*p1e == 0) {
                GF_SndHandleSetTrackPan(1, 0xFFFF, pan);
                sub_02006820(bank, 1, volume);
            } else if (*p10 == 1) {
                sub_02005748(0xE, (u8)panHalf);
                sub_02005774(0xE, volume);
            } else {
                GF_SndHandleSetTrackPan(1, 0xFFFF, pan);
                sub_02006820(bank, 1, volume);
            }
            return 1;
        default:
            sub_02006E3C(1);
            break;
        }
    }

    switch (mode) {
    case 0:
        PlayCry(species, form);
        GF_SndHandleSetTrackPan(1, 0xFFFF, pan);
        sub_02006820(bank, 1, volume);
        break;
    case 1:
        PlayCry(species, form);
        GF_SndHandleSetTrackPan(1, 0xFFFF, pan);
        sub_02006820(bank, 1, volume);
        sub_02006838(0x14, heapId);
        break;
    case 2:
        PlayCry(species, form);
        GF_SndHandleSetTrackPan(1, 0xFFFF, pan);
        sub_02006820(bank, 1, volume);
        GF_SndHandleSetTrackPitch(1, 0xFFFF, 0x40);
        sub_02006AC0(species, 0x14, form);
        GF_SndHandleSetTrackPan(8, 0xFFFF, pan);
        sub_02006820(bank, 8, volAdj);
        break;
    case 3:
        PlayCry(species, form);
        GF_SndHandleSetTrackPan(1, 0xFFFF, pan);
        sub_02006820(bank, 1, volume);
        sub_02006838(0x1E, heapId);
        GF_SndHandleSetTrackPitch(1, 0xFFFF, 0xC0);
        sub_02006AC0(species, 0x10, form);
        GF_SndHandleSetTrackPan(8, 0xFFFF, pan);
        sub_02006820(bank, 8, volAdj);
        break;
    case 4:
        sub_02005600(0xE);
        sub_020057AC(bank, volume, panHalf, 0xE, heapId);
        sub_02005748(0xE, (u8)panHalf);
        sub_02006838(0xF, heapId);
        sub_02005760(0xE, 0x8600);
        sub_02006AF4(bank, -64, volAdj, panHalf, heapId);
        sub_02005760(0xF, 0x8600);
        break;
    case 5:
        PlayCry(species, form);
        GF_SndHandleSetTrackPan(1, 0xFFFF, pan);
        sub_02006820(bank, 1, volume);
        GF_SndHandleSetTrackPitch(1, 0xFFFF, -224);
        break;
    case 6:
        PlayCry(species, form);
        GF_SndHandleSetTrackPan(1, 0xFFFF, pan);
        sub_02006820(bank, 1, volume);
        GF_SndHandleSetTrackPitch(1, 0xFFFF, 0x2C);
        sub_02006AC0(species, -64, form);
        GF_SndHandleSetTrackPan(8, 0xFFFF, pan);
        sub_02006820(bank, 8, volAdj);
        break;
    case 7:
        PlayCry(species, form);
        GF_SndHandleSetTrackPan(1, 0xFFFF, pan);
        sub_02006820(bank, 1, volume);
        sub_02006838(0xB, heapId);
        GF_SndHandleSetTrackPitch(1, 0xFFFF, -128);
        break;
    case 8:
        PlayCry(species, form);
        GF_SndHandleSetTrackPan(1, 0xFFFF, pan);
        sub_02006820(bank, 1, volume);
        sub_02006838(0x3C, heapId);
        GF_SndHandleSetTrackPitch(1, 0xFFFF, 0x3C);
        break;
    case 9:
        sub_02005600(0xE);
        sub_020057AC(bank, volume, panHalf, 0xE, heapId);
        sub_02005748(0xE, (u8)panHalf);
        sub_02006838(0xD, heapId);
        sub_02005760(0xE, 0x6800);
        break;
    case 10:
        PlayCry(species, form);
        GF_SndHandleSetTrackPan(1, 0xFFFF, pan);
        sub_02006820(bank, 1, volume);
        sub_02006838(0x64, heapId);
        GF_SndHandleSetTrackPitch(1, 0xFFFF, -44);
        break;
    case 11:
        PlayCry(species, form);
        GF_SndHandleSetTrackPan(1, 0xFFFF, pan);
        sub_02006820(bank, 1, volume);
        GF_SndHandleSetTrackPitch(1, 0xFFFF, -96);
        break;
    case 12:
        PlayCry(species, form);
        GF_SndHandleSetTrackPan(1, 0xFFFF, pan);
        sub_02006820(bank, 1, volume);
        sub_02006838(0x14, heapId);
        GF_SndHandleSetTrackPitch(1, 0xFFFF, -96);
        break;
    case 13:
        PlayCry(species, form);
        sub_02006820(bank, 1, 0x7F);
        sub_02006AC0(species, 0x14, form);
        GF_SndHandleSetTrackPan(8, 0xFFFF, pan);
        GF_SndHandleMoveVolume(8, volume, 0);
        break;
    case 14:
        PlayCry(species, form);
        break;
    default:
        break;
    }

    return 1;
}

void sub_02006820(int species, int track, int volume) {
    GF_SndHandleSetInitialVolume(track, volume);
    sub_02005464(species, track);
}

void sub_02006838(int frames, int heapId) {
    SysTask **taskPtr;
    UnkStruct_02006838 *data;
    u8 *p;
    SysTask *task;
    taskPtr = GF_SdatGetAttrPtr(0x23);
    sub_020068F8();
    data = Heap_Alloc((enum HeapID)heapId, sizeof(UnkStruct_02006838));
    if (data == NULL) {
        GF_ASSERT(FALSE);
        return;
    }
    p = (u8 *)data;
    p[0] = 0;
    p[1] = 0;
    p[2] = 0;
    p[3] = 0;
    p[4] = 0;
    p[5] = 0;
    p[6] = 0;
    p[7] = 0;
    data->counter = frames;
    task = SysTask_CreateOnMainQueue(sub_02006884, data, 0);
    data->task = task;
    *taskPtr = task;
}

void sub_02006884(SysTask *task, void *data_) {
    UnkStruct_02006838 *data;
    u8 *p10;
    u8 *p11;
    data = data_;
    p10 = GF_SdatGetAttrPtr(0x10);
    p11 = GF_SdatGetAttrPtr(0x11);
    if (data->counter == 10) {
        GF_SndHandleMoveVolume(1, 0, data->counter);
        GF_SndHandleMoveVolume(8, 0, data->counter);
    }
    data->counter -= 1;
    if (!IsCryFinished()) {
        data->counter = 0;
    }
    if (data->counter <= 0) {
        sub_02006300(0);
        if (*p10 == 1) {
            sub_020058B8(0xE);
            sub_02005680(0xE);
        }
        if (*p11 == 1) {
            sub_020058B8(0xF);
            sub_02005680(0xF);
        }
        sub_020068F8();
    }
}

void sub_020068F8(void) {
    SysTask **taskPtr;
    void *data;
    taskPtr = GF_SdatGetAttrPtr(0x23);
    if (*taskPtr != NULL) {
        data = SysTask_GetData(*taskPtr);
        SysTask_Destroy(*taskPtr);
        Heap_Free(data);
    }
    *taskPtr = NULL;
}

void sub_02006920(int p0, u16 species, int pan, int volume, int heapId, u8 a5, u8 form) {
    u8 *p6ptr;
    u32 *g0;
    u16 *g1;
    u32 *g2;
    u32 *g3;
    u32 *g4;
    u8 *g5;
    u8 *p35ptr;

    p6ptr = GF_SdatGetAttrPtr(6);
    p35ptr = GF_SdatGetAttrPtr(0x35);
    if (*p6ptr == 0) {
        g0 = GF_SdatGetAttrPtr(0x29);
        g1 = GF_SdatGetAttrPtr(0x2D);
        g2 = GF_SdatGetAttrPtr(0x2A);
        g3 = GF_SdatGetAttrPtr(0x2B);
        g4 = GF_SdatGetAttrPtr(0x2C);
        g5 = GF_SdatGetAttrPtr(0x2E);
    } else {
        g0 = GF_SdatGetAttrPtr(0x2F);
        g1 = GF_SdatGetAttrPtr(0x33);
        g2 = GF_SdatGetAttrPtr(0x30);
        g3 = GF_SdatGetAttrPtr(0x31);
        g4 = GF_SdatGetAttrPtr(0x32);
        g5 = GF_SdatGetAttrPtr(0x34);
    }

    if (*p35ptr == 1) {
        *p6ptr ^= 1;
    }

    if (sub_02006A0C(species, form) == 1) {
        species = 0x1EE;
    }

    if (species != 0) {
        if (a5 == 0) {
            PlayCryEx(p0, species, pan, volume, heapId, form);
        } else {
            *g0 = p0;
            *g1 = species;
            *g2 = pan;
            *g3 = volume;
            *g4 = heapId;
            *g5 = a5;
        }
    }
}

BOOL sub_02006A0C(u32 species, u32 form) {
    if (species == 0x1EC && form == 1) {
        return 1;
    }
    if (species == 0x1EE) {
        return 1;
    }
    return 0;
}

void sub_02006A30(void) {
    u32 *p29;
    u16 *p2d;
    u32 *p2a;
    u32 *p2b;
    u32 *p2c;
    u8 *p2e;
    u32 *p2f;
    u16 *p33;
    u32 *p30;
    u32 *p31;
    u32 *p32;
    u8 *p34;

    p29 = GF_SdatGetAttrPtr(0x29);
    p2d = GF_SdatGetAttrPtr(0x2D);
    p2a = GF_SdatGetAttrPtr(0x2A);
    p2b = GF_SdatGetAttrPtr(0x2B);
    p2c = GF_SdatGetAttrPtr(0x2C);
    p2e = GF_SdatGetAttrPtr(0x2E);
    p2f = GF_SdatGetAttrPtr(0x2F);
    p33 = GF_SdatGetAttrPtr(0x33);
    p30 = GF_SdatGetAttrPtr(0x30);
    p31 = GF_SdatGetAttrPtr(0x31);
    p32 = GF_SdatGetAttrPtr(0x32);
    p34 = GF_SdatGetAttrPtr(0x34);

    *p29 = 0;
    *p2d = 0;
    *p2a = 0;
    *p2b = 0;
    *p2c = 0;
    *p2e = 0;
    *p2f = 0;
    *p33 = 0;
    *p30 = 0;
    *p31 = 0;
    *p32 = 0;
    *p34 = 0;
}

BOOL sub_02006AC0(int species, int track, int form) {
    u8 *p12;
    BOOL result;
    p12 = GF_SdatGetAttrPtr(0x12);
    *p12 = 1;
    sub_02006E3C(1);
    result = PlayCry(species, form);
    GF_SndHandleSetTrackPitch(8, 0xFFFF, track);
    return result;
}

void sub_02006AF4(int species, int unused, int volAdj, int panHalf, int heapId) {
    u8 *p12;
    p12 = GF_SdatGetAttrPtr(0x12);
    *p12 = 1;
    sub_02005600(0xF);
    sub_020057AC(species, volAdj, panHalf, 0xF, heapId);
}

BOOL PlayFanfare(u16 seqNo) {
    u8 playerNo;
    BOOL result;
    GF_GetBankInfoBySeqNo(seqNo);
    sub_02006C04(seqNo);
    playerNo = GF_GetPlayerNoBySeq(GF_GetCurrentPlayingBGM());
    if (playerNo != 0xFF) {
        sub_020053A8(playerNo, 1);
    } else {
        SndRadio_PausePlayer(1);
    }
    GF_Snd_SaveState(GF_SdatGetAttrPtr(0x1D));
    GF_Snd_LoadSeqEx(seqNo, 3);
    result = sub_02006C14(2, -1, -1, -1, seqNo, 0);
    sub_02005464(seqNo, 2);
    return result;
}

BOOL sub_02006B84(void *unused) {
    u16 *p0e;
    p0e = GF_SdatGetAttrPtr(0xE);
    if (GF_SndPlayerCountPlayingSeqByPlayerNo(2) != 0) {
        return 1;
    }
    if (*p0e != 0) {
        *p0e -= 1;
        return 1;
    }
    return 0;
}

void sub_02006BB0(int a0) {
    NNS_SndPlayerStopSeq(GF_GetSoundHandle(2), a0);
    GF_Snd_LoadState(sub_02005328(6));
}

BOOL IsFanfarePlaying(void) {
    u8 playerNo;
    if (sub_02006B84(GF_SdatGetAttrPtr(0xE)) == 1) {
        return 1;
    }
    sub_02006BB0(0);
    playerNo = GF_GetPlayerNoBySeq(GF_GetCurrentPlayingBGM());
    if (playerNo != 0xFF) {
        sub_020053A8(playerNo, 0);
    }
    SndRadio_PausePlayer(0);
    return 0;
}

void sub_02006C04(u16 unused) {
    u16 *p;
    p = GF_SdatGetAttrPtr(0xE);
    *p = 0xF;
}

BOOL sub_02006C14(int handleNo, int playerNo, int bankNo, int playerPrio, u16 seqNo, u8 checkGB) {
    NNSSndHandle *handle;
    BOOL result;
    u16 seq;
    u16 gbSeqNo;
    u8 remappedPlayerNo;
    seq = seqNo;
    if (checkGB == 1 && SoundSys_GetGBSoundsState() == 1) {
        gbSeqNo = GBSounds_GetGBSeqNoByDSSeqNo(seqNo);
        if (seqNo != gbSeqNo) {
            seq = gbSeqNo;
            bankNo = 0x2BD;
            sub_02004AB8(gbSeqNo);
            remappedPlayerNo = GF_GetPlayerNoBySeq(gbSeqNo);
            if (playerNo != -1) {
                remappedPlayerNo = (u8)playerNo;
            }
            if (remappedPlayerNo == 7) {
                GF_Snd_LoadSeqEx(gbSeqNo, 1);
            }
        }
    }
    handle = GF_GetSoundHandle(handleNo);
    result = NNS_SndArcPlayerStartSeqEx(handle, playerNo, bankNo, playerPrio, seq);
    GBSounds_SetAllocatableChannels();
    return result;
}
