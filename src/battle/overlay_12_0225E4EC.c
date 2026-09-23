#include "global.h"

#include "constants/moves.h"

#include "battle/battle.h"
#include "battle/battle_controller_opponent.h"
#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"

#include "heap.h"
#include "sys_task.h"

typedef struct RecordedMoveInput {
    BattleSystem *battleSystem;
    u8 filler_04[0x18];
    u8 unk_1C;
    u8 battlerId;
} RecordedMoveInput;

void ov12_02261EB8(BattleSystem *battleSystem);
void ov12_02261ED4(BattleSystem *battleSystem);
void ov12_02262FE0(BattleSystem *battleSystem, int battlerId, int input);
void ov12_0226430C(BattleSystem *battleSystem, int battlerId, int a2);

// A recorded battle's move choice for one battler: the slot is read back from
// the recording, and a slot that is empty or holds no known move ends the
// playback. Retail's bound was its last move, 467; hg-engine lifts it.
void ov12_0225E4EC(SysTask *task, void *_data) {
    RecordedMoveInput *data = _data;
    u8 input;

    if (ov12_0223BE0C(data->battleSystem, data->battlerId, &input) == TRUE) {
        ov12_02261ED4(data->battleSystem);
    }
    if (input == 0 || input > MAX_MON_MOVES) {
        ov12_02261EB8(data->battleSystem);
    } else {
        u16 move = GetBattlerVar(BattleSystem_GetBattleContext(data->battleSystem), data->battlerId, BMON_DATA_MOVE1 + input - 1, NULL);
        if (move == MOVE_NONE || move > NUM_MOVES_TOTAL) {
            ov12_02261EB8(data->battleSystem);
        }
    }
    ov12_02262FE0(data->battleSystem, data->battlerId, input);
    ov12_0226430C(data->battleSystem, data->battlerId, data->unk_1C);
    Heap_Free(data);
    SysTask_Destroy(task);
}
