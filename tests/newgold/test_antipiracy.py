#!/usr/bin/env python3
"""Run the native flashcart checks with host sanitizers, on a pretend flashcart.

ov01_021E662C is extracted from src/field/fieldmap.c, and DSProt's queue
runner with its two ROM-read checks from lib/dsprot/src/dsprot_main.c. On
the DS the queue holds obfuscated addresses of encrypted functions; here the
obfuscation macro enrolls each function in a table and the runner calls
through that table instead, which is the one change made to the extracted
code. The card status and the checks themselves are stand-ins that answer
the way a flashcart does, so this checks what the game concludes from them,
not the checks.
"""

import os
from pathlib import Path
import shlex
import subprocess
import tempfile
import unittest

from test_level_cap import ROOT, function

PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
typedef uint32_t u32; typedef int32_t s32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define FUNC_QUEUE_END 0
#define DSP_OBFS_OFFSET 0x320
#define ENC_VAL_1 0x1300
typedef u32 (*TaskFunc)(void);
typedef void (*CallbackFunc)(void);
typedef enum ExpectedResult { EXPECT_FALSE, EXPECT_TRUE } ExpectedResult;

static TaskFunc enrolled[8];
static u32 enrolledCount;
static u32 enroll(TaskFunc f) { enrolled[enrolledCount] = f; return enrolledCount++; }
#define ADDR_PLUS_ADDEND(ref, addend) (enroll(ref) + (addend))
#define CALL_QUEUED(entry) (enrolled[(entry) - ENC_VAL_1 - DSP_OBFS_OFFSET]())

// A flashcart: the ROM reads come out wrong, the check code is intact.
static unsigned checksRun;
static u32 RunEncrypted_ROMTest_IsBad(void) { checksRun++; return TRUE; }
static u32 RunEncrypted_ROMTest_IsGood(void) { checksRun++; return FALSE; }
static u32 RunEncrypted_Integrity_ROMTest_IsBad(void) { checksRun++; return FALSE; }
static u32 RunEncrypted_Integrity_ROMTest_IsGood(void) { checksRun++; return TRUE; }
static u32 CARD_SpiWaitGetStatus(void) { return 0; }  // a genuine card answers 170

static unsigned callbacks;
static void callback(void) { callbacks++; }
@NATIVE@
'''

MAIN = r'''
int main(void) {
    // The field's own card check passes, so no lag tasks start.
    assert(ov01_021E662C() == TRUE);

    // The flashcart is never detected and always passes as a genuine card,
    // which is what FieldSystem_Init, the field map, the Pokedex and the
    // save screen ask before they punish.
    assert(DSProtInternal_DetectFlashcart(callback) == FALSE);
    assert(callbacks == 0);
    assert(DSProtInternal_DetectNotFlashcart(callback) == TRUE);
    assert(callbacks == 1);
    // Nothing was read from the ROM to get there.
    assert(checksRun == 0);

    puts("PASS: on a flashcart the card check passes and DSProt sees a genuine card.");
}
'''


class AntipiracyTests(unittest.TestCase):
    def test_native_flashcart_passes(self):
        field = function((ROOT / "src/field/fieldmap.c").read_text(), "ov01_021E662C")
        dsprot = (ROOT / "lib/dsprot/src/dsprot_main.c").read_text()
        dsprot = dsprot[dsprot.index("static inline u32 dsprotMain"):dsprot.index("u32 DSProtInternal_DetectEmulator")]
        call = "((TaskFunc)(funcQueue[i] - ENC_VAL_1 - DSP_OBFS_OFFSET))()"
        self.assertEqual(dsprot.count(call), 1)
        program = PREFIX.replace("@NATIVE@", field + "\n" + dsprot.replace(call, "CALL_QUEUED(funcQueue[i])")) + MAIN
        with tempfile.TemporaryDirectory(prefix="newgold-antipiracy-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(program)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
            print(result.stdout.strip())


if __name__ == "__main__":
    unittest.main()
