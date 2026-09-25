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

    bankInfo = NNS_SndArcGetBankInfo(bankNo);
    if (bankInfo == NULL) {
        return 4;
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
