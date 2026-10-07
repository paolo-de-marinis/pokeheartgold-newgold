# Pictures for the game: prompts and rules

How a new picture gets into New Gold, as Paolo and Claude did it for
Bramblin (2026-10-07): Paolo has the picture drawn by ChatGPT (his own
subscription, by hand: no pay-per-use API, decided 2026-09-24), Claude converts
it to the DS's formats, puts it in a test build and shows it in the game
through the harness, and Paolo judges it, on his phone if he likes. The devkit's
sprite and item editors will host the same flow: drop the pictures in, the
conversion and the in-game preview follow (DEVKIT-PLAN.md, section 4).

**Bramblin is in the game** (2026-10-08): its battle front and back, their
shiny colours, the party icon and the follower are Paolo's, where the
reference had Bulbasaur's battle pictures. A species whose pictures are
Paolo's is listed in `tools/newgold/import/own_art.py`, which every importer
that writes those files reads, so a re-import keeps his pictures instead of
the reference's; the next species (Baby Lugia) is one line there, then one
run of the converter.

The prompts are in English, which ChatGPT follows best. Replace `<NAME>` with
the Pokemon's or the item's English name.

## Rules every prompt keeps

- **Pixel art**, hard edges, no anti-aliasing, no blur.
- **A flat pure magenta (#FF00FF) background**, and no magenta on the subject:
  the conversion makes magenta transparent. Black is no good -- outlines are
  dark.
- **Few colours**: the DS gives a picture 16, one of them transparent.
- **The exact size, or an exact multiple** (each pixel a clean block); the
  conversion copes with less, but scaling a painted picture down blurs it.

## Battle pictures: front and back

```text
Pixel art sprite of the Pokémon <NAME>, in the exact style of Nintendo DS Pokémon games (Pokémon HeartGold/SoulSilver and Black/White battle sprites).

Make TWO separate images, same size and same colour palette:
1. FRONT sprite: <NAME> seen from the front, three-quarter view, facing toward the LEFT side of the image, as an opponent Pokémon appears in battle.
2. BACK sprite: <NAME> seen from behind, three-quarter back view, as the player's own Pokémon appears in battle.

Rules for both images:
- Canvas exactly 80x80 pixels (or exactly 320x320 if you must go bigger, with every pixel drawn as a clean 4x4 block, no in-between pixels).
- True pixel art: hard edges, no anti-aliasing, no blur, no gradients, no shading softer than pixel dithering.
- At most 15 colours in total, the SAME 15 colours in both images, including a dark 1-pixel outline around the Pokémon.
- Plain flat background in pure magenta (#FF00FF) everywhere outside the Pokémon; do not use magenta anywhere on the Pokémon.
- The Pokémon centred horizontally, its lowest point touching about the bottom 10 pixels of the canvas, filling most of the canvas without touching the edges.
- Faithful to <NAME>'s official design (colours, shape, face).
```

**The shiny colours**, added to the same request:

```text
Also make the SAME front and back images again, pixel for pixel identical in shape, using <NAME>'s official SHINY colours.
```

## Party icon

```text
Pixel art party-menu icon of the Pokémon <NAME>, in the exact style of the Nintendo DS Pokémon HeartGold/SoulSilver party icons.
Two frames side by side, each exactly 32x32 pixels (or each 128x128 with every pixel a clean 4x4 block): frame 1 the idle pose, frame 2 the same pose bounced up by 1-2 pixels or with a small change (as the menu animates it).
Small, chunky, cute proportions, dark 1-pixel outline, at most 12 colours, no anti-aliasing, flat pure magenta (#FF00FF) background, the Pokémon facing the viewer slightly to the left, feet near the bottom of each frame. Faithful to <NAME>'s official design.
```

The game has no shiny icons: one picture serves both.

## Following Pokemon (overworld)

```text
Pixel art overworld walking sprite sheet of the Pokémon <NAME>, in the exact style of the Pokémon HeartGold/SoulSilver walking Pokémon that follow the player.
A grid of 6 frames, each exactly 32x32 pixels (or 128x128 with clean 4x4 pixel blocks): row 1 facing DOWN (toward the viewer) step A and step B, row 2 facing UP (back to the viewer) step A and step B, row 3 facing LEFT, seen exactly from the side, step A and step B.
Top-down three-quarter view as in the DS overworld, dark 1-pixel outline, at most 15 colours shared by all frames, no anti-aliasing, flat pure magenta (#FF00FF) background, the body centred in each frame with its feet on the bottom rows. Faithful to <NAME>'s official design.
```

And the same sheet again in the official shiny colours, shape for shape.

No right-facing row: HeartGold draws a follower's right-facing frames as the exact mirror of
its left-facing ones (checked on Pikachu's), so the conversion mirrors row 3. ChatGPT's own
right-facing rows came out turned wrong (Lugia, 2026-10-08), and a mirror is always right.

## Item icon

```text
Pixel art bag icons for the Pokémon items <NAME 1>, <NAME 2>, ... in the exact style of the Nintendo DS Pokémon HeartGold/SoulSilver bag item icons.
One image with the icons in a single row, in that order, each icon on its own 32x32 pixel square (or 128x128 with every pixel a clean 4x4 block), the item drawn about 24x24 pixels in the middle of its square.
Each icon: dark 1-pixel outline, at most 15 colours, simple shading as the DS icons have, no anti-aliasing, flat pure magenta (#FF00FF) background, nothing touching the square's edges. Faithful to each item's official artwork from the Pokémon games.
```

The first use, Paolo, 2026-10-08: the seven Mochi of Scarlet/Violet (Health,
Muscle, Resist, Genius, Clever, Swift and Fresh-Start Mochi), which the
reference has no icons for (they show the "?" icon in the EV/IV trainer's shop
and in the bag).

## What the conversion does, and the traps found

- **Transparent background:** magenta out, and the letters' holes with it.
- **Scaling:** the picture is reduced by area average from the subject's own
  pixels, so its edges take no magenta.
- **Colours:** 15 at most, chosen together for all the frames that share a
  palette, in 15-bit colour; index 0 is the transparent one.
- **The PNG's palette must have exactly 16 entries.** A 256-entry palette made
  the battle load 256 colours over every other sprite's: the whole battle was
  garbled (found with Bramblin).
- **Battle:** `files/poketool/pokegra/pokegra/<species>/{male,female}/`
  `front.png` and `back.png`, 160x80 (two 80x80 frames); the front's palette is
  the normal one, the **back's PNG carries the shiny palette** (the same
  indices); the female pictures are separate files and must be replaced too
  (a female Bramblin first showed the old placeholder). `heights.py write`
  follows the pictures, and `import_sprite_offsets.py` stands the front as it
  is drawn in its frame, over a shadow its size. The size of a new species'
  battle picture follows the community sprites of the same Pokemon (Bramblin
  42 wide).
- **Party icon:** `poke_icon_<n>.png`, 32x64, in one of the three palettes all
  icons share (`poke_icon_00000000.pal`); the species' palette number is in
  `sPokemonPalNoBySpeciesAndForm` (src/pokemon_icon_idx.c): the conversion
  picks the palette closest to the picture's colours and sets the number.
- **Following Pokemon:** `overworld.png` 32x256, eight 32x32 frames in the
  game's order **up, up, down, down, left, left, right, right** (right = left mirrored), two 16-colour
  palettes (normal, shiny), built into the species' mmodel texture
  (`import_followers.nsbtx`). **Size, HeartGold's rule measured on its own
  followers:** the drawn height is the median of retail's 32x32 followers whose
  Dex height is within 1 dm of the species' (0.6 m gives 17 pixels), measured
  on the first down frame, and the down frame is scaled to it, the feet
  on row 29, centred at x 16, one scale for all eight frames so it does not
  change size while walking; the largest Pokemon use 64x64 frames.
- **Item icon:** 32x32, 4bpp, its own 16-colour palette, as the items
  `item_data.mk` builds from PNGs.
- **Checked in the game,** not on the PNG: the field, the party menu and a
  battle, normal and shiny (the harness: `scene.py` with
  `gDiagForceBattleSpecies` on a route, the species both as the foe and as the
  player's Pokemon -- the 256-colour trap showed only with the back loaded).
  `front1.lift` finds the foe's front on the screen in its PNG's colours, a
  shiny one in its back's: Bramblin's scenarios are `bramblin_pictures.json`
  and `bramblin_pictures_shiny.json`.

The converter is `tools/newgold/devkit/sprites/convert_chatgpt.py`: it takes
the species, each picture and the follower sheet's rows (`--rows`, top to
bottom; a right row is not used), writes into the tree and runs what follows
the pictures; its docstring has Bramblin's command. It refuses a species not
in `own_art.py`. The sprite editor will host it.
