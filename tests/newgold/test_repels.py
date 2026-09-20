#!/usr/bin/env python3
"""Check actual native repel C and VM wiring; optionally compare pinned NewGold C.

Run with --reference PATH or HG_ENGINE_NEWGOLD_REFERENCE to select the reference
checkout. A sibling hg-engine-newgold-reference checkout is used when present.
These host checks do not substitute for DS rendering/input/audio checks.
"""

import argparse
import csv
import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[2]
BASELINE = "e97c7fc975a7447f288c42acc2e155f5a673e30f"
REFERENCE_COMMIT = "41a28e2255b2805378163c7f4d6c1d87541174d1"
REFERENCE = os.environ.get("HG_ENGINE_NEWGOLD_REFERENCE")
if REFERENCE is None and (ROOT.parent / "hg-engine-newgold-reference/.git").exists():
    REFERENCE = ROOT.parent / "hg-engine-newgold-reference"


def read(path):
    return (ROOT / path).read_text()


def revision(root, commit, path):
    return subprocess.check_output(["git", "show", f"{commit}:{path}"], cwd=root, text=True)


def function(source, name):
    match = re.search(r"^(?:static )?\w+ " + name + r"\([^;]*?\) \{", source, re.M)
    if match is None:
        raise ValueError(f"Function definition not found: {name}")
    depth, end = 1, match.end()
    while depth:
        depth += (source[end] == "{") - (source[end] == "}")
        end += 1
    return source[match.start():end]


def without_includes(source):
    return "\n".join(line for line in source.splitlines() if not line.startswith("#include"))


FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "constants/items.h"
#include "constants/heap.h"
#include "constants/std_script.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
typedef int bool32;
#define TRUE 1
#define FALSE 0
@MENU_CONSTANTS@
enum { SCRIPTENV_LIST_MENU_2D };

typedef struct { u16 items[ITEM_REPEL + 1]; } Bag;
typedef struct { u8 repelSteps; } RoamerSaveData;
typedef struct { RoamerSaveData roamer; Bag bag; } SaveData;
struct ListMenu2D { int selection; };
typedef struct { SaveData *saveData; int script; struct ListMenu2D *menu; u16 result; } FieldSystem;
typedef struct { FieldSystem *fieldSystem; u16 result; int varReads; u32 data[4]; } ScriptContext;
struct BagApp { RoamerSaveData *roamer; };
RoamerSaveData *BagApp_GetSaveRoamers(struct BagApp *app) { return app->roamer; }
static RoamerSaveData *Save_Roamers_Get(SaveData *save) { return &save->roamer; }
static u8 *RoamerSave_GetRepelAddr(RoamerSaveData *roamer) { return &roamer->repelSteps; }
static Bag *Save_Bag_Get(SaveData *save) { return &save->bag; }
static BOOL Bag_HasItem(Bag *bag, u16 item, u16 qty, u32 heap) {
    assert(item <= ITEM_REPEL && (heap == HEAP_ID_3 || heap == HEAP_ID_FIELD2));
    return bag->items[item] >= qty;
}
static BOOL Bag_TakeItem(Bag *bag, u16 item, u16 qty, u32 heap) {
    if (!Bag_HasItem(bag, item, qty, heap)) return FALSE;
    bag->items[item] -= qty;
    return TRUE;
}
static int GetItemAttr(u16 item, u16 attr, u32 heap) {
    assert(attr == ITEMATTR_HOLD_EFFECT_PARAM && heap == HEAP_ID_3);
    switch (item) { @DURATIONS@ }
    assert(0 && "Unexpected item");
    return 0;
}
static void StartMapSceneScript(FieldSystem *fs, int script, void *object) {
    assert(object == NULL);
    fs->script = script;
}
static u16 *ScriptGetVarPointer(ScriptContext *ctx) { ctx->varReads++; return &ctx->result; }
static void *FieldSysGetAttrAddr(FieldSystem *fs, int attr) {
    assert(attr == SCRIPTENV_LIST_MENU_2D);
    return &fs->menu;
}
static u16 *GetVarPointer(FieldSystem *fs, u32 var) { (void)var; return &fs->result; }
static int Handle2dMenuInput_DeleteOnFinish(struct ListMenu2D *menu, int heap) {
    assert(heap == HEAP_ID_FIELD1);
    return menu->selection;
}
@REFERENCE@
@NATIVE@
@COMMAND@
@SETTER@
@YESNO@

int main(void) {
    unsigned counterCases = 0, reuseCases = 0;
    for (int steps = 0; steps < 256; ++steps) {
        RoamerSaveData roamer = {0};
        struct BagApp app = { &roamer };
        BagApp_GetRepelStepCountAddr(&app, steps);
        assert(roamer.repelSteps == steps);
    }
    const int selections[] = {0, 1, LIST_CANCEL, LIST_NOTHING_CHOSEN};
    for (unsigned i = 0; i < sizeof(selections) / sizeof(selections[0]); ++i) {
        struct ListMenu2D menu = {selections[i]};
        FieldSystem fs = {.menu = &menu, .result = 65535};
        ScriptContext ctx = {.fieldSystem = &fs};
        assert(sub_020416E4(&ctx) == (selections[i] != LIST_NOTHING_CHOSEN));
        assert(fs.result == (selections[i] == LIST_NOTHING_CHOSEN ? 65535 : selections[i] != 0));
    }
    for (int normal = 0; normal < 3; ++normal) {
        for (int super = 0; super < 3; ++super) {
            for (int max = 0; max < 3; ++max) {
                SaveData base = {0};
                base.bag.items[ITEM_REPEL] = normal;
                base.bag.items[ITEM_SUPER_REPEL] = super;
                base.bag.items[ITEM_MAX_REPEL] = max;
                u16 preferred = max ? ITEM_MAX_REPEL : super ? ITEM_SUPER_REPEL : ITEM_REPEL;
                for (int steps = 0; steps < 256; ++steps) {
                    base.roamer.repelSteps = steps;
                    SaveData native = base;
                    FieldSystem fs = {.saveData = &native};
                    BOOL result = PlayerStepEvent_RepelCounterDecrement(&native, &fs);
                    assert(result == (steps == 1));
                    assert(native.roamer.repelSteps == (steps == 0 ? 0 : steps - 1));
                    assert(fs.script == (steps == 1 ? (normal || super || max ? std_reuse_repel : std_repel_wore_off) : 0));
                    assert(memcmp(&native.bag, &base.bag, sizeof(Bag)) == 0);
#ifdef HAVE_REFERENCE
                    SaveData reference = base;
                    FieldSystem referenceFs = {.saveData = &reference};
                    referenceSave = &reference;
                    CurrentRepelType = 65535; /* The remembered value must not affect selection. */
                    assert(result == Reference_Decrement(&reference, &referenceFs));
                    assert(fs.script == referenceFs.script);
                    assert(native.roamer.repelSteps == reference.roamer.repelSteps);
                    assert(memcmp(&native.bag, &reference.bag, sizeof(Bag)) == 0);
#endif
                    counterCases++;
                }
                const int oldSteps[] = {0, 23, 255};
                for (unsigned old = 0; old < sizeof(oldSteps) / sizeof(oldSteps[0]); ++old) {
                    base.roamer.repelSteps = oldSteps[old];
                    SaveData native = base;
                    FieldSystem fs = {.saveData = &native};
                    ScriptContext ctx = {.fieldSystem = &fs, .result = 65535};
                    assert(ScrCmd_UseNextRepel(&ctx) == FALSE);
                    assert(ctx.result == preferred && ctx.varReads == 1);
                    Bag expected = base.bag;
                    int duration = oldSteps[old];
                    if (expected.items[preferred]) {
                        expected.items[preferred]--;
                        duration = GetItemAttr(preferred, ITEMATTR_HOLD_EFFECT_PARAM, HEAP_ID_3);
                    }
                    assert(native.roamer.repelSteps == duration);
                    assert(memcmp(&native.bag, &expected, sizeof(Bag)) == 0);
#ifdef HAVE_REFERENCE
                    SaveData reference = base;
                    referenceSave = &reference;
                    assert(ctx.result == Reference_GetMostRecent());
                    Reference_Use(65535, HEAP_ID_3); /* Source ignores the supplied item. */
                    assert(native.roamer.repelSteps == reference.roamer.repelSteps);
                    assert(memcmp(&native.bag, &reference.bag, sizeof(Bag)) == 0);
#endif
                    reuseCases++;
                }
            }
        }
    }
    printf("PASS: %u counter cases, %u use-command cases, 256 setters, Yes/No/B/wait.\n", counterCases, reuseCases);
    return 0;
}
"""


def reference_source():
    if REFERENCE is None:
        return ""
    source = revision(REFERENCE, REFERENCE_COMMIT, "src/repel.c")
    aliases = {
        "PlayerStepEvent_RepelCounterDecrement": "Reference_Decrement",
        "Repel_SetCurrentType": "Reference_SetCurrentType",
        "Repel_GetMostRecent": "Reference_GetMostRecent",
        "Repel_Use": "Reference_Use",
        "Repel_GetSteps": "Reference_GetSteps",
    }
    prelude = """
#define HAVE_REFERENCE
#define ALIGN4
#define IMPLEMENT_REUSABLE_REPELS
#define HEAPID_MAIN_HEAP HEAP_ID_3
#define HEAPID_WORLD HEAP_ID_FIELD2
#define ITEM_PARAM_HOLD_EFFECT_PARAM ITEMATTR_HOLD_EFFECT_PARAM
typedef Bag BAG_DATA;
static SaveData *referenceSave;
static SaveData *SaveBlock2_get(void) { return referenceSave; }
#define EncDataSave_GetSaveDataPtr Save_Roamers_Get
#define SaveData_GetRepelPtr RoamerSave_GetRepelAddr
#define Sav2_Bag_get Save_Bag_Get
#define GetItemData GetItemAttr
#define EventSet_Script StartMapSceneScript
"""
    return (prelude + "\n".join(f"#define {name} {alias}" for name, alias in aliases.items())
            + "\nu16 Repel_GetMostRecent(void);\nBOOL Repel_Use(u16 item, u32 heap);\nu8 Repel_GetSteps(u16 item, u32 heap);\n"
            + without_includes(source) + "\n"
            + "\n".join(f"#undef {name}" for name in aliases))


class RepelRegression(unittest.TestCase):
    def test_actual_c_counter_consumption_command_and_cancel(self):
        with (ROOT / "files/itemtool/itemdata/item_data.csv").open() as stream:
            durations = {row["item"]: int(row["holdEffectParam"]) for row in csv.DictReader(stream)
                         if row["item"] in {"ITEM_REPEL", "ITEM_SUPER_REPEL", "ITEM_MAX_REPEL"}}
        self.assertEqual(durations, {"ITEM_REPEL": 100, "ITEM_SUPER_REPEL": 200, "ITEM_MAX_REPEL": 250})
        replacements = {
            "@MENU_CONSTANTS@": "\n".join(line for line in read("include/list_menu_items.h").splitlines()
                                            if re.match(r"#define LIST_(CANCEL|NOTHING_CHOSEN)\s", line)),
            "@DURATIONS@": " ".join(f"case {item}: return {steps};" for item, steps in durations.items()),
            "@REFERENCE@": reference_source(),
            "@NATIVE@": without_includes(read("src/field/repel.c")),
            "@COMMAND@": function(read("src/scrcmd_items.c"), "ScrCmd_UseNextRepel"),
            "@SETTER@": without_includes(read("src/bag_app.c")),
            "@YESNO@": function(read("src/scrcmd_c.c"), "sub_020416E4"),
        }
        source = FIXTURE
        for token, replacement in replacements.items():
            source = source.replace(token, replacement)
        with tempfile.TemporaryDirectory(prefix="newgold-repels-") as directory:
            path = Path(directory)
            (path / "check.c").write_text(source)
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Wextra", "-Werror", "-O2", "-iquote", str(ROOT / "include"),
                str(path / "check.c"), "-o", str(path / "check"),
            ], check=True)
            subprocess.run([str(path / "check")], cwd=directory, check=True)

    def test_appended_opcode_and_script_preserve_existing_entries(self):
        table = "src/data/fieldmap/script_cmd_table.h"
        entries = lambda source: re.findall(r"^    (\w+),$", source, re.M)
        old = entries(revision(ROOT, BASELINE, table))
        new = entries(read(table))
        self.assertEqual(new[:len(old)], old)
        self.assertEqual(new.index("ScrCmd_UseNextRepel"), 853)
        macros = read("asm/macros/script.inc")
        self.assertRegex(macros, r"\.macro UseNextRepel item\s+\.short 853\s+\.short \\item\s+\.endm")
        for name, opcode in [("PlaySE", 73), ("WaitButton", 50)]:
            self.assertRegex(macros, rf"\.macro {name}[^\n]*\n\s*\.short {opcode}\b")
        source = read("files/fielddata/script/scr_seq/scr_seq_0003.s")
        scripts = re.findall(r"^\s+ScrDef (\w+)$", source, re.M)
        self.assertEqual(scripts[72], "scr_seq_0003_072")
        body = source.split("scr_seq_0003_072:\n", 1)[1].split("\t.balign", 1)[0]
        commands = [line.strip() for line in body.splitlines() if line.strip()]
        self.assertEqual(commands, [
            "PlaySE SEQ_SE_DP_SELECT", "LockAll", "NPCMsg msg_0040_00117",
            "YesNo VAR_SPECIAL_RESULT", "Compare VAR_SPECIAL_RESULT, 1", "GoToIfEq _ReuseRepelEnd",
            "UseNextRepel VAR_SPECIAL_RESULT", "PlaySE SEQ_SE_DP_CARD2", "BufferPlayersName 0",
            "BufferItemName 1, VAR_SPECIAL_RESULT", "NPCMsg msg_0040_00118", "WaitButton",
            "_ReuseRepelEnd:", "CloseMsg", "ReleaseAll", "End",
        ])
        self.assertRegex(read("include/constants/std_script.h"), r"#define std_reuse_repel\s+2072\b")
        self.assertRegex(read("files/fielddata/script/scr_seq/event_0003.h"), r"#define _EV_scr_seq_0003_072 72\b")

    def test_messages_preserve_original_rows_and_reference_text(self):
        path = "files/msgdata/msg/msg_0040.gmm"
        messages = lambda source: {row.attrib["id"]: (row.attrib["index"], row.find("language").text)
                                   for row in ET.fromstring(source).findall("row")}
        old, new = messages(revision(ROOT, BASELINE, path)), messages(read(path))
        self.assertEqual({key: new[key] for key in old}, old)
        expected = ["The repellent’s effect wore off!\\nWould you like to use another one?",
                    "You used the {STRVAR_1 8, 1, 0}."]
        self.assertEqual([new[f"msg_0040_{i:05d}"][1] for i in (117, 118)], expected)
        if REFERENCE is not None:
            source = revision(REFERENCE, REFERENCE_COMMIT, "data/text/040.txt").splitlines()
            self.assertEqual(source[118:120], expected)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument("--reference", type=Path)
    options, remaining = parser.parse_known_args()
    if options.reference is not None:
        REFERENCE = options.reference
    print(f"Pinned NewGold comparison: {REFERENCE if REFERENCE is not None else 'unavailable; native expectations only'}")
    unittest.main(argv=[__file__, *remaining])
