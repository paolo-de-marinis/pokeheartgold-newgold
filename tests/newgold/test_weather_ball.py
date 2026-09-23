#!/usr/bin/env python3
"""Weather Ball's type, run on the host at every place it is worked out.

GetDynamicMoveType (what Lightning Rod and Storm Drain are asked about) and
the trainer AI's two copies of it take test_fairy_type's stubbed battle, whose
weather is the field's; the stack is dirtied first, so that a type left unset
reads as rubbish rather than as the zero a fresh stack happens to hold.
"""

import os
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_fairy_type import AI, ARCEUS
from test_level_cap import ROOT
from test_repels import function

OVERLAY = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
TRAINER_AI = (ROOT / "src/battle/trainer_ai_0221F084.c").read_text()
OPPONENT = (ROOT / "src/battle/overlay_12_02258800.c").read_text()

# Each weather and the type it makes the ball, for all three functions.
CHECKS = r"""
static int poison(void) {
    volatile int junk[256];
    for (int i = 0; i < 256; i++) {
        junk[i] = TYPE_DRAGON;
    }
    return junk[0];
}

int main(void) {
    static BattleContext ctx;
    static const struct { u32 weather; int type; } cases[] = {
        { 0, TYPE_NORMAL },
        { FIELD_CONDITION_FOG, TYPE_NORMAL },
        { FIELD_CONDITION_STRONG_WINDS, TYPE_NORMAL },
        { FIELD_CONDITION_RAIN, TYPE_WATER },
        { FIELD_CONDITION_SUN, TYPE_FIRE },
        { FIELD_CONDITION_SANDSTORM, TYPE_ROCK },
        { FIELD_CONDITION_HAIL, TYPE_ICE },
@SNOW@
    };
    for (unsigned i = 0; i < sizeof(cases) / sizeof(cases[0]); i++) {
        int type;
        ctx.fieldCondition = cases[i].weather;
        poison();
        type = @CALL@;
        if (type != cases[i].type) {
            fprintf(stderr, "weather %#x: type %d, expected %d\n", (unsigned)cases[i].weather, type, cases[i].type);
            return 1;
        }
    }
    return 0;
}
"""


def run(test, prelude, functions, call, snow):
    program = (prelude[:prelude.index("int main(void)")].replace("@FUNCTIONS@", functions)
               + CHECKS.replace("@CALL@", call).replace("@SNOW@", snow))
    with tempfile.TemporaryDirectory(prefix="newgold-weather-ball-") as directory:
        path = Path(directory)
        (path / "test.c").write_text(program)
        result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c99", "-O0", "-Wall", "-Werror", "-Wno-unused-function", "-Wno-unused-const-variable", "-Wno-unused-variable",
            "-Wno-maybe-uninitialized", "-Wno-uninitialized",
            "-iquote", str(ROOT / "include"), str(path / "test.c"), "-o", str(path / "test")],
            capture_output=True, text=True)
        test.assertEqual(result.returncode, 0, result.stderr)
        result = subprocess.run([str(path / "test")], capture_output=True, text=True)
    test.assertEqual(result.returncode, 0, result.stderr)


SITES = (
    ("battle", ARCEUS, lambda: function(OVERLAY, "GetDynamicMoveType"), "GetDynamicMoveType(0, &ctx, 0, MOVE_WEATHER_BALL)"),
    ("battler, for the AI", AI, lambda: function(TRAINER_AI, "ov10_0221F47C"), "ov10_0221F47C(0, &ctx, 0, MOVE_WEATHER_BALL)"),
    ("party, for the AI", AI, lambda: function(OPPONENT, "ov12_02258BB4"), "ov12_02258BB4(0, &ctx, 0, MOVE_WEATHER_BALL)"),
)


class WeatherBallTypeTests(unittest.TestCase):
    def test_no_weather_that_changes_it_leaves_it_normal(self):
        """Clear skies, fog and the strong winds leave Weather Ball Normal
        (Pokemon Central, Palla Clima); retail returned whatever the stack
        held, which Lightning Rod's redirection then read."""
        for name, prelude, functions, call in SITES:
            with self.subTest(name):
                run(self, prelude, functions(), call, "")


if __name__ == "__main__":
    unittest.main()
