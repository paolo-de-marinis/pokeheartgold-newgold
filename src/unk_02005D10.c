#include "global.h"

#include "constants/species.h"

// The last species HeartGold records a cry for, and how many banks the sound
// archive holds once the added ones are in it.
// The last identifier the base archive has a cry for. The egg, the bad egg
// and the twelve alternate forms sit at 494 to 507 and have none, so the
// added species -- and sAddedCryBanks -- start at 508. This said 494, which
// put every added species thirteen entries along its own table: Lillipup
// played Karrablast's cry, and the last thirteen read past the end of the
// table entirely for whatever halfword followed it.
#define NUM_SPECIES_WITH_CRIES 507
#define ARCHIVE_BANK_COUNT     1375

#include "heap.h"
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
// The numbers are where tools/newgold/import_cries.py put them.
static const u16 sAddedCryBanks[] = {
    843, // Lillipup
    844, // Herdier
    845, // Stoutland
    846, // Purrloin
    847, // Liepard
    848, // Tympole
    849, // Palpitoad
    850, // Seismitoad
    851, // Sewaddle
    852, // Swadloon
    853, // Leavanny
    854, // Yamask
    855, // Cofagrigus
    856, // Trubbish
    857, // Garbodor
    858, // Emolga
    859, // Karrablast
    860, // Escavalier
    861, // Foongus
    862, // Amoonguss
    863, // Joltik
    864, // Galvantula
    865, // Ferroseed
    866, // Ferrothorn
    867, // Klink
    868, // Klang
    869, // Klinklang
    870, // Elgyem
    871, // Beheeyem
    872, // Litwick
    873, // Lampent
    874, // Chandelure
    875, // Shelmet
    876, // Accelgor
    877, // Bouffalant
    878, // Bunnelby
    879, // Diggersby
    880, // Fletchling
    881, // Fletchinder
    882, // Talonflame
    883, // Litleo
    884, // Pyroar
    885, // Espurr
    886, // Meowstic
    887, // Sylveon
    888, // Dedenne
    889, // Phantump
    890, // Trevenant
    891, // Pumpkaboo
    892, // Gourgeist
    893, // Noibat
    894, // Noivern
    895, // Applin
    896, // Flapple
    897, // Appletun
    898, // Sizzlipede
    899, // Centiskorch
    900, // Wyrdeer
    901, // Kleavor
    902, // Ursaluna
    903, // Annihilape
    904, // Farigiraf
    905, // Dudunsparce
    906, // Dipplin
    907, // Hydrapple
    79, // Slowpoke Galarian
    80, // Slowbro Galarian
    908, // Victini
    909, // Snivy
    910, // Servine
    911, // Serperior
    912, // Tepig
    913, // Pignite
    914, // Emboar
    915, // Oshawott
    916, // Dewott
    917, // Samurott
    918, // Patrat
    919, // Watchog
    920, // Pansage
    921, // Simisage
    922, // Pansear
    923, // Simisear
    924, // Panpour
    925, // Simipour
    926, // Munna
    927, // Musharna
    928, // Pidove
    929, // Tranquill
    930, // Unfezant
    931, // Blitzle
    932, // Zebstrika
    933, // Roggenrola
    934, // Boldore
    935, // Gigalith
    936, // Woobat
    937, // Swoobat
    938, // Drilbur
    939, // Excadrill
    940, // Audino
    941, // Timburr
    942, // Gurdurr
    943, // Conkeldurr
    944, // Throh
    945, // Sawk
    946, // Venipede
    947, // Whirlipede
    948, // Scolipede
    949, // Cottonee
    950, // Whimsicott
    951, // Petilil
    952, // Lilligant
    953, // Basculin
    954, // Sandile
    955, // Krokorok
    956, // Krookodile
    957, // Darumaka
    958, // Darmanitan
    959, // Maractus
    960, // Dwebble
    961, // Crustle
    962, // Scraggy
    963, // Scrafty
    964, // Sigilyph
    965, // Tirtouga
    966, // Carracosta
    967, // Archen
    968, // Archeops
    969, // Zorua
    970, // Zoroark
    971, // Minccino
    972, // Cinccino
    973, // Gothita
    974, // Gothorita
    975, // Gothitelle
    976, // Solosis
    977, // Duosion
    978, // Reuniclus
    979, // Ducklett
    980, // Swanna
    981, // Vanillite
    982, // Vanillish
    983, // Vanilluxe
    984, // Deerling
    985, // Sawsbuck
    986, // Frillish
    987, // Jellicent
    988, // Alomomola
    989, // Tynamo
    990, // Eelektrik
    991, // Eelektross
    992, // Axew
    993, // Fraxure
    994, // Haxorus
    995, // Cubchoo
    996, // Beartic
    997, // Cryogonal
    998, // Stunfisk
    999, // Mienfoo
    1000, // Mienshao
    1001, // Druddigon
    1002, // Golett
    1003, // Golurk
    1004, // Pawniard
    1005, // Bisharp
    1006, // Rufflet
    1007, // Braviary
    1008, // Vullaby
    1009, // Mandibuzz
    1010, // Heatmor
    1011, // Durant
    1012, // Deino
    1013, // Zweilous
    1014, // Hydreigon
    1015, // Larvesta
    1016, // Volcarona
    1017, // Cobalion
    1018, // Terrakion
    1019, // Virizion
    1020, // Tornadus
    1021, // Thundurus
    1022, // Reshiram
    1023, // Zekrom
    1024, // Landorus
    1025, // Kyurem
    1026, // Keldeo
    1027, // Meloetta
    1028, // Genesect
    1029, // Chespin
    1030, // Quilladin
    1031, // Chesnaught
    1032, // Fennekin
    1033, // Braixen
    1034, // Delphox
    1035, // Froakie
    1036, // Frogadier
    1037, // Greninja
    1038, // Scatterbug
    1039, // Spewpa
    1040, // Vivillon
    1041, // Flabebe
    1042, // Floette
    1043, // Florges
    1044, // Skiddo
    1045, // Gogoat
    1046, // Pancham
    1047, // Pangoro
    1048, // Furfrou
    1049, // Honedge
    1050, // Doublade
    1051, // Aegislash
    1052, // Spritzee
    1053, // Aromatisse
    1054, // Swirlix
    1055, // Slurpuff
    1056, // Inkay
    1057, // Malamar
    1058, // Binacle
    1059, // Barbaracle
    1060, // Skrelp
    1061, // Dragalge
    1062, // Clauncher
    1063, // Clawitzer
    1064, // Helioptile
    1065, // Heliolisk
    1066, // Tyrunt
    1067, // Tyrantrum
    1068, // Amaura
    1069, // Aurorus
    1070, // Hawlucha
    1071, // Carbink
    1072, // Goomy
    1073, // Sliggoo
    1074, // Goodra
    1075, // Klefki
    1076, // Bergmite
    1077, // Avalugg
    1078, // Xerneas
    1079, // Yveltal
    1080, // Zygarde
    1081, // Diancie
    1082, // Hoopa
    1083, // Volcanion
    1084, // Rowlet
    1085, // Dartrix
    1086, // Decidueye
    1087, // Litten
    1088, // Torracat
    1089, // Incineroar
    1090, // Popplio
    1091, // Brionne
    1092, // Primarina
    1093, // Pikipek
    1094, // Trumbeak
    1095, // Toucannon
    1096, // Yungoos
    1097, // Gumshoos
    1098, // Grubbin
    1099, // Charjabug
    1100, // Vikavolt
    1101, // Crabrawler
    1102, // Crabominable
    1103, // Oricorio
    1104, // Cutiefly
    1105, // Ribombee
    1106, // Rockruff
    1107, // Lycanroc
    1108, // Wishiwashi
    1109, // Mareanie
    1110, // Toxapex
    1111, // Mudbray
    1112, // Mudsdale
    1113, // Dewpider
    1114, // Araquanid
    1115, // Fomantis
    1116, // Lurantis
    1117, // Morelull
    1118, // Shiinotic
    1119, // Salandit
    1120, // Salazzle
    1121, // Stufful
    1122, // Bewear
    1123, // Bounsweet
    1124, // Steenee
    1125, // Tsareena
    1126, // Comfey
    1127, // Oranguru
    1128, // Passimian
    1129, // Wimpod
    1130, // Golisopod
    1131, // Sandygast
    1132, // Palossand
    1133, // Pyukumuku
    1134, // Type Null
    1135, // Silvally
    1136, // Minior
    1137, // Komala
    1138, // Turtonator
    1139, // Togedemaru
    1140, // Mimikyu
    1141, // Bruxish
    1142, // Drampa
    1143, // Dhelmise
    1144, // Jangmo O
    1145, // Hakamo O
    1146, // Kommo O
    1147, // Tapu Koko
    1148, // Tapu Lele
    1149, // Tapu Bulu
    1150, // Tapu Fini
    1151, // Cosmog
    1152, // Cosmoem
    1153, // Solgaleo
    1154, // Lunala
    1155, // Nihilego
    1156, // Buzzwole
    1157, // Pheromosa
    1158, // Xurkitree
    1159, // Celesteela
    1160, // Kartana
    1161, // Guzzlord
    1162, // Necrozma
    1163, // Magearna
    1164, // Marshadow
    1165, // Poipole
    1166, // Naganadel
    1167, // Stakataka
    1168, // Blacephalon
    1169, // Zeraora
    1170, // Meltan
    1171, // Melmetal
    1172, // Grookey
    1173, // Thwackey
    1174, // Rillaboom
    1175, // Scorbunny
    1176, // Raboot
    1177, // Cinderace
    1178, // Sobble
    1179, // Drizzile
    1180, // Inteleon
    1181, // Skwovet
    1182, // Greedent
    1183, // Rookidee
    1184, // Corvisquire
    1185, // Corviknight
    1186, // Blipbug
    1187, // Dottler
    1188, // Orbeetle
    1189, // Nickit
    1190, // Thievul
    1191, // Gossifleur
    1192, // Eldegoss
    1193, // Wooloo
    1194, // Dubwool
    1195, // Chewtle
    1196, // Drednaw
    1197, // Yamper
    1198, // Boltund
    1199, // Rolycoly
    1200, // Carkol
    1201, // Coalossal
    1202, // Silicobra
    1203, // Sandaconda
    1204, // Cramorant
    1205, // Arrokuda
    1206, // Barraskewda
    1207, // Toxel
    1208, // Toxtricity
    1209, // Clobbopus
    1210, // Grapploct
    1211, // Sinistea
    1212, // Polteageist
    1213, // Hatenna
    1214, // Hattrem
    1215, // Hatterene
    1216, // Impidimp
    1217, // Morgrem
    1218, // Grimmsnarl
    1219, // Obstagoon
    1220, // Perrserker
    1221, // Cursola
    1222, // Sirfetchd
    1223, // Mr Rime
    1224, // Runerigus
    1225, // Milcery
    1226, // Alcremie
    1227, // Falinks
    1228, // Pincurchin
    1229, // Snom
    1230, // Frosmoth
    1231, // Stonjourner
    1232, // Eiscue
    1233, // Indeedee
    1234, // Morpeko
    1235, // Cufant
    1236, // Copperajah
    1237, // Dracozolt
    1238, // Arctozolt
    1239, // Dracovish
    1240, // Arctovish
    1241, // Duraludon
    1242, // Dreepy
    1243, // Drakloak
    1244, // Dragapult
    1245, // Zacian
    1246, // Zamazenta
    1247, // Eternatus
    1248, // Kubfu
    1249, // Urshifu
    1250, // Zarude
    1251, // Regieleki
    1252, // Regidrago
    1253, // Glastrier
    1254, // Spectrier
    1255, // Calyrex
    1256, // Basculegion
    1257, // Sneasler
    1258, // Overqwil
    1259, // Enamorus
    1260, // Sprigatito
    1261, // Floragato
    1262, // Meowscarada
    1263, // Fuecoco
    1264, // Crocalor
    1265, // Skeledirge
    1266, // Quaxly
    1267, // Quaxwell
    1268, // Quaquaval
    1269, // Lechonk
    1270, // Oinkologne
    1271, // Tarountula
    1272, // Spidops
    1273, // Nymble
    1274, // Lokix
    1275, // Pawmi
    1276, // Pawmo
    1277, // Pawmot
    1278, // Tandemaus
    1279, // Maushold
    1280, // Fidough
    1281, // Dachsbun
    1282, // Smoliv
    1283, // Dolliv
    1284, // Arboliva
    1285, // Squawkabilly
    1286, // Nacli
    1287, // Naclstack
    1288, // Garganacl
    1289, // Charcadet
    1290, // Armarouge
    1291, // Ceruledge
    1292, // Tadbulb
    1293, // Bellibolt
    1294, // Wattrel
    1295, // Kilowattrel
    1296, // Maschiff
    1297, // Mabosstiff
    1298, // Shroodle
    1299, // Grafaiai
    1300, // Bramblin
    1301, // Brambleghast
    1302, // Toedscool
    1303, // Toedscruel
    1304, // Klawf
    1305, // Capsakid
    1306, // Scovillain
    1307, // Rellor
    1308, // Rabsca
    1309, // Flittle
    1310, // Espathra
    1311, // Tinkatink
    1312, // Tinkatuff
    1313, // Tinkaton
    1314, // Wiglett
    1315, // Wugtrio
    1316, // Bombirdier
    1317, // Finizen
    1318, // Palafin
    1319, // Varoom
    1320, // Revavroom
    1321, // Cyclizar
    1322, // Orthworm
    1323, // Glimmet
    1324, // Glimmora
    1325, // Greavard
    1326, // Houndstone
    1327, // Flamigo
    1328, // Cetoddle
    1329, // Cetitan
    1330, // Veluza
    1331, // Dondozo
    1332, // Tatsugiri
    1333, // Clodsire
    1334, // Kingambit
    1335, // Great Tusk
    1336, // Scream Tail
    1337, // Brute Bonnet
    1338, // Flutter Mane
    1339, // Slither Wing
    1340, // Sandy Shocks
    1341, // Iron Treads
    1342, // Iron Bundle
    1343, // Iron Hands
    1344, // Iron Jugulis
    1345, // Iron Moth
    1346, // Iron Thorns
    1347, // Frigibax
    1348, // Arctibax
    1349, // Baxcalibur
    1350, // Gimmighoul
    1351, // Gholdengo
    1352, // Wo Chien
    1353, // Chien Pao
    1354, // Ting Lu
    1355, // Chi Yu
    1356, // Roaring Moon
    1357, // Iron Valiant
    1358, // Koraidon
    1359, // Miraidon
    1360, // Walking Wake
    1361, // Iron Leaves
    1362, // Poltchageist
    1363, // Sinistcha
    1364, // Okidogi
    1365, // Munkidori
    1366, // Fezandipiti
    1367, // Ogerpon
    1368, // Archaludon
    1369, // Gouging Fire
    1370, // Raging Bolt
    1371, // Iron Boulder
    1372, // Iron Crown
    1373, // Terapagos
    1374, // Pecharunt
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
    940, // Mega Audino
    1081, // Mega Diancie
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
    1097, // Gumshoos Large
    1100, // Vikavolt Large
    1105, // Ribombee Large
    1114, // Araquanid Large
    1116, // Lurantis Large
    1120, // Salazzle Large
    1139, // Togedemaru Large
    1140, // Mimikyu Large
    1140, // Mimikyu Busted Large
    1146, // Kommo O Large
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
    957, // Darumaka Galarian
    958, // Darmanitan Galarian
    854, // Yamask Galarian
    998, // Stunfisk Galarian
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
    953, // Basculin Blue Striped
    953, // Basculin White Striped
    958, // Darmanitan Zen Mode
    958, // Darmanitan Zen Mode Galarian
    984, // Deerling Summer
    984, // Deerling Autumn
    984, // Deerling Winter
    985, // Sawsbuck Summer
    985, // Sawsbuck Autumn
    985, // Sawsbuck Winter
    1020, // Tornadus Therian
    1021, // Thundurus Therian
    1024, // Landorus Therian
    1025, // Kyurem White
    1025, // Kyurem Black
    1026, // Keldeo Resolute
    1027, // Meloetta Pirouette
    1028, // Genesect Douse Drive
    1028, // Genesect Shock Drive
    1028, // Genesect Burn Drive
    1028, // Genesect Chill Drive
    1037, // Greninja Battle Bond
    1037, // Greninja Ash
    1040, // Vivillon Polar
    1040, // Vivillon Tundra
    1040, // Vivillon Continental
    1040, // Vivillon Garden
    1040, // Vivillon Elegant
    1040, // Vivillon Meadow
    1040, // Vivillon Modern
    1040, // Vivillon Marine
    1040, // Vivillon Archipelago
    1040, // Vivillon High Plains
    1040, // Vivillon Sandstorm
    1040, // Vivillon River
    1040, // Vivillon Monsoon
    1040, // Vivillon Savanna
    1040, // Vivillon Sun
    1040, // Vivillon Ocean
    1040, // Vivillon Jungle
    1040, // Vivillon Fancy
    1040, // Vivillon Poke Ball
    1041, // Flabebe Yellow Flower
    1041, // Flabebe Orange Flower
    1041, // Flabebe Blue Flower
    1041, // Flabebe White Flower
    1042, // Floette Yellow Flower
    1042, // Floette Orange Flower
    1042, // Floette Blue Flower
    1042, // Floette White Flower
    1042, // Floette Eternal Flower
    1043, // Florges Yellow Flower
    1043, // Florges Orange Flower
    1043, // Florges Blue Flower
    1043, // Florges White Flower
    1048, // Furfrou Heart
    1048, // Furfrou Star
    1048, // Furfrou Diamond
    1048, // Furfrou Debutante
    1048, // Furfrou Matron
    1048, // Furfrou Dandy
    1048, // Furfrou La Reine
    1048, // Furfrou Kabuki
    1048, // Furfrou Pharaoh
    1051, // Aegislash Blade
    891, // Pumpkaboo Small
    891, // Pumpkaboo Large
    891, // Pumpkaboo Super
    892, // Gourgeist Small
    892, // Gourgeist Large
    892, // Gourgeist Super
    1078, // Xerneas Active
    1080, // Zygarde 10
    1080, // Zygarde 10 Power Construct
    1080, // Zygarde 50 Power Construct
    1080, // Zygarde 10 Complete
    1080, // Zygarde 50 Complete
    1082, // Hoopa Unbound
    1103, // Oricorio Pom Pom
    1103, // Oricorio Pau
    1103, // Oricorio Sensu
    1106, // Rockruff Own Tempo
    1107, // Lycanroc Midnight
    1107, // Lycanroc Dusk
    1108, // Wishiwashi School
    1136, // Minior Meteor Orange
    1136, // Minior Meteor Yellow
    1136, // Minior Meteor Green
    1136, // Minior Meteor Blue
    1136, // Minior Meteor Indigo
    1136, // Minior Meteor Violet
    1136, // Minior Core Red
    1136, // Minior Core Orange
    1136, // Minior Core Yellow
    1136, // Minior Core Green
    1136, // Minior Core Blue
    1136, // Minior Core Indigo
    1136, // Minior Core Violet
    1140, // Mimikyu Busted
    1162, // Necrozma Dusk Mane
    1162, // Necrozma Dawn Wings
    1162, // Necrozma Ultra Dusk Mane
    1162, // Necrozma Ultra Dawn Wings
    1163, // Magearna Original
    25, // Pikachu Partner
    133, // Eevee Partner
    1204, // Cramorant Gulping
    1204, // Cramorant Gorging
    1208, // Toxtricity Low Key
    1211, // Sinistea Antique
    1212, // Polteageist Antique
    1226, // Alcremie Berry Sweet
    1226, // Alcremie Love Sweet
    1226, // Alcremie Star Sweet
    1226, // Alcremie Clover Sweet
    1226, // Alcremie Flower Sweet
    1226, // Alcremie Ribbon Sweet
    1232, // Eiscue Noice Face
    1234, // Morpeko Hangry
    1245, // Zacian Crowned
    1246, // Zamazenta Crowned
    1247, // Eternatus Eternamax
    1249, // Urshifu Rapid Strike
    1250, // Zarude Dada
    1255, // Calyrex Ice Rider
    1255, // Calyrex Shadow Rider
    1259, // Enamorus Therian
    58, // Growlithe Hisuian
    59, // Arcanine Hisuian
    100, // Voltorb Hisuian
    101, // Electrode Hisuian
    157, // Typhlosion Hisuian
    211, // Qwilfish Hisuian
    215, // Sneasel Hisuian
    917, // Samurott Hisuian
    952, // Lilligant Hisuian
    969, // Zorua Hisuian
    970, // Zoroark Hisuian
    1007, // Braviary Hisuian
    1073, // Sliggoo Hisuian
    1074, // Goodra Hisuian
    1077, // Avalugg Hisuian
    1086, // Decidueye Hisuian
    901, // Kleavor Lord
    952, // Lilligant Lady
    59, // Arcanine Lord
    101, // Electrode Lord
    1077, // Avalugg Lord
    930, // Unfezant Female
    986, // Frillish Female
    987, // Jellicent Female
    884, // Pyroar Female
    886, // Meowstic Female
    1233, // Indeedee Female
    1256, // Basculegion Female
    1279, // Maushold Family Of Three
    1285, // Squawkabilly Blue Plumage
    1285, // Squawkabilly Yellow Plumage
    1285, // Squawkabilly White Plumage
    1318, // Palafin Hero
    1332, // Tatsugiri Droopy
    1332, // Tatsugiri Stretchy
    905, // Dudunsparce Three Segment
    1350, // Gimmighoul Roaming
    194, // Wooper Paldean
    128, // Tauros Combat
    128, // Tauros Blaze
    128, // Tauros Aqua
    1270, // Oinkologne Female
    1320, // Revavroom Segin
    1320, // Revavroom Schedar
    1320, // Revavroom Navi
    1320, // Revavroom Ruchbah
    1320, // Revavroom Caph
    1358, // Koraidon Limited Build
    1358, // Koraidon Sprinting Build
    1358, // Koraidon Swimming Build
    1358, // Koraidon Gliding Build
    1359, // Miraidon Low Power Mode
    1359, // Miraidon Drive Mode
    1359, // Miraidon Aquatic Mode
    1359, // Miraidon Glide Mode
    1362, // Poltchageist Masterpiece
    1363, // Sinistcha Masterpiece
    1367, // Ogerpon Wellspring Mask
    1367, // Ogerpon Hearthflame Mask
    1367, // Ogerpon Cornerstone Mask
    1367, // Ogerpon Teal Mask Terastal
    1367, // Ogerpon Wellspring Mask Terastal
    1367, // Ogerpon Hearthflame Mask Terastal
    1367, // Ogerpon Cornerstone Mask Terastal
    902, // Ursaluna Bloodmoon
    1373, // Terapagos Terastal
    1373, // Terapagos Stellar
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
    857, // Gigantamax Garbodor
    1171, // Gigantamax Melmetal
    1174, // Gigantamax Rillaboom
    1177, // Gigantamax Cinderace
    1180, // Gigantamax Inteleon
    1185, // Gigantamax Corviknight
    1188, // Gigantamax Orbeetle
    1196, // Gigantamax Drednaw
    1201, // Gigantamax Coalossal
    896, // Gigantamax Flapple
    897, // Gigantamax Appletun
    1203, // Gigantamax Sandaconda
    1208, // Gigantamax Toxtricity
    1208, // Gigantamax Toxtricity Low Key
    899, // Gigantamax Centiskorch
    1215, // Gigantamax Hatterene
    1218, // Gigantamax Grimmsnarl
    1226, // Gigantamax Alcremie
    1236, // Gigantamax Copperajah
    1241, // Gigantamax Duraludon
    1249, // Gigantamax Urshifu
    1249, // Gigantamax Urshifu Rapid Strike
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
    914, // Mega Emboar
    939, // Mega Excadrill
    948, // Mega Scolipede
    963, // Mega Scrafty
    991, // Mega Eelektross
    874, // Mega Chandelure
    1003, // Mega Golurk
    1031, // Mega Chesnaught
    1034, // Mega Delphox
    1037, // Mega Greninja
    884, // Mega Pyroar
    1042, // Mega Floette
    886, // Mega Meowstic
    886, // Mega Meowstic Female
    1057, // Mega Malamar
    1059, // Mega Barbaracle
    1061, // Mega Dragalge
    1070, // Mega Hawlucha
    1080, // Mega Zygarde
    1102, // Mega Crabominable
    1130, // Mega Golisopod
    1142, // Mega Drampa
    1163, // Mega Magearna
    1163, // Mega Magearna Original
    1169, // Mega Zeraora
    1227, // Mega Falinks
    1306, // Mega Scovillain
    1324, // Mega Glimmora
    1332, // Mega Tatsugiri
    1332, // Mega Tatsugiri Droopy
    1332, // Mega Tatsugiri Stretchy
    1349, // Mega Baxcalibur
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
    p12 = GF_SdatGetAttrPtr(0x12);
    p24 = GF_SdatGetAttrPtr(0x24);
    p35 = GF_SdatGetAttrPtr(0x35);
    if (sub_02006A0C(species, form) == 1) {
        species = 0x1EE;
    }
    if (species != 0x1EE) {
        species = CryBankForSpecies(species);
        if ((u32)species >= ARCHIVE_BANK_COUNT || species == 0) {
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
        if ((u32)bank >= ARCHIVE_BANK_COUNT || bank == 0) {
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
