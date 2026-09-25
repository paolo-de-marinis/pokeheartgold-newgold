#include <nitro/code32.h>
#include <nnsys.h>

// The rest of the NitroSystem sound library is still lib/asm/nnsys.s and
// nnsys_2.s, which this function sat between; these are its own, unnamed in
// the SDK's headers.
struct SNDWaveArc;
struct SNDBankData *LoadBank(u32 fileId, NNSSndHeapHandle heap, BOOL bSetAddr);
BOOL LoadSingleWaves(struct SNDWaveArc *waveArc, struct SNDBankData *bank, int index, u32 fileId, NNSSndHeapHandle heap);
int NNSi_SndArcLoadWaveArc(int waveArcNo, u32 loadFlag, NNSSndHeapHandle heap, BOOL bSetAddr, struct SNDWaveArc **pData);
void SND_AssignWaveArc(struct SNDBankData *bank, int index, struct SNDWaveArc *waveArc);

int NNSi_SndArcLoadBank(int bankNo, u32 loadFlag, NNSSndHeapHandle heap, BOOL bSetAddr, struct SNDBankData **pData) {
    const NNSSndArcBankInfo *bankInfo;
    const NNSSndArcWaveArcInfo *waveArcInfo;
    struct SNDBankData *bank;
    struct SNDWaveArc *waveArc;
    int result;
    int i;
    NNSSndArcBankInfo cry;

    bankInfo = NNS_SndArcGetBankInfo(bankNo);
    if (bankInfo == NULL) {
        // A cry is a wave archive with no bank of its own, as hg-engine has
        // them: every cry bank was the same 76-byte instrument, and a bank's
        // record and file table entries are sound heap the music needs. So a
        // number with a wave archive and no bank plays that wave archive on
        // bank 1's instrument. Each cry player heap loads a copy of its own:
        // StartSeq passes bSetAddr FALSE, and LoadBank reuses only a copy
        // the file table knows, which nothing makes of bank 1 (no group or
        // scene loads a cry's bank or sequence; test_cries checks the
        // groups). So two cries at once do not relink one bank.
        if (NNS_SndArcGetWaveArcInfo(bankNo) == NULL) {
            return 4;
        }
        cry = *NNS_SndArcGetBankInfo(1);
        cry.waveArcNo[0] = bankNo;
        bankInfo = &cry;
    }
    if (loadFlag & 2) {
        bank = LoadBank(bankInfo->fileId, heap, bSetAddr);
        if (bank == NULL) {
            return 8;
        }
    } else {
        bank = NNS_SndArcGetFileAddress(bankInfo->fileId);
    }
    for (i = 0; i < 4; i++) {
        if (bankInfo->waveArcNo[i] == 0xFFFF) {
            continue;
        }
        waveArcInfo = NNS_SndArcGetWaveArcInfo(bankInfo->waveArcNo[i]);
        if (waveArcInfo == NULL) {
            return 5;
        }
        result = NNSi_SndArcLoadWaveArc(bankInfo->waveArcNo[i], loadFlag, heap, bSetAddr, &waveArc);
        if (result != 0) {
            return result;
        }
        if ((waveArcInfo->flags & 1) && (loadFlag & 4)) {
            if (!LoadSingleWaves(waveArc, bank, i, waveArcInfo->fileId, heap)) {
                return 9;
            }
        }
        if (bank != NULL && waveArc != NULL) {
            SND_AssignWaveArc(bank, i, waveArc);
        }
    }
    if (pData != NULL) {
        *pData = bank;
    }
    return 0;
}
