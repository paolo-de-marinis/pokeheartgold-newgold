# The New Gold devkit — a plan

A plan, not work in progress: nothing here is built yet beyond what the first
section lists. Written with Paolo on 2026-09-24; every part starts only when he
says so, and each starts with the small proof named for it.

**Deferred until the port is finished** (Paolo, 2026-09-24). Until then the
primary plan is the port itself and, of the devkit, only the save editor (and
the diagnostics tools the port's own work needs) is kept and extended.

The devkit is for developing the game with agents as much as by hand. Everything
in it follows the rules the port already keeps:

- **The tree is the source of truth.** Every tool reads the game from the files
  the build compiles, as they are at that moment, and follows them when they
  change (the save editor already does: `hgss-save-editor-reads-the-tree`).
- **Sources in open formats, compiled by the build.** As the decompilation
  already does for graphics (PNG), text (gmm), scripts (.s) and data (JSON), the
  devkit keeps every asset it edits in a format people and agents can read and
  diff, and the build turns it into the DS's formats. Extracting an original
  asset and compiling it back must give the same bytes: that is how we know a
  converter is right, and it keeps the original ROM buildable.
- **Three doors to one library.** Each tool is a Python library, a command line
  that answers in JSON, and a page in the devkit app. Agents use the first two,
  Paolo the third, and there is one set of rules behind all three.
- **The guardrails are in the tools**, not only in notes: the memory cap
  (`.rounds/tools/capped`), scratch on disk, the byte-identical check for a
  decompilation, the two layers (engine, then New Gold) for every change, the
  tests before a commit.

## The product: one program, and Paolo's door to everything

The end is **one program**, the New Gold editor, and it is Paolo's only door:
every change planned below -- saves, maps, 3D, sprites and animations,
trainers, Pokemon, moves, events, text, battles, builds -- is made from it,
either by Paolo with its own tools or by asking an agent in its **chat panel**,
on the same thing, in the same window. No outside program is needed to work.

- **The chat is part of the editor.** It knows what is open and selected (this
  map, this sprite's third frame, this trainer) and can do anything the editor
  can: "make the cap red", "add a trainer on Route 30 with a level-12
  Pidgeotto", "raise that ledge". What it changes shows up in the editor at
  once, and Paolo can take over by hand, or tell it what to change next, as many
  times as he likes.
- **The engines work underneath.** Blender (3D), the pixel pipeline (Python,
  Aseprite where layers and animation help), the build, the emulators and the
  harness run behind the editor; the agent drives them, the editor shows their
  result -- a 3D view of the map in the page, the sprite on a pixel canvas, the
  scene in the game itself. Paolo may still open a file in Blender or Aseprite
  if he wants, but never has to.
- **Every change can be seen and taken back.** An agent's change is shown
  before it is kept (a preview, the difference, the game running it), kept as
  its own step with a one-click undo, checked by the tests that cover it, and
  recorded in git like everything else in the port.
- **The agent behind the chat** is Claude Code run headless on Paolo's own
  account, locally, with the devkit's own tools (the MCP interface of section
  1), so it works within his plan's usage limits. **Pay-per-use API keys are
  forbidden** (Paolo, 2026-09-24): no part of the devkit may call the Anthropic
  API with a key, and a tool that would needs to go through Claude Code
  instead.
- **Built in pieces, joined at the end.** The parts below can be built and used
  separately first -- each already has its own page and its own tools -- and
  come together as sections of the one program, with the chat across all of
  them, once they work.

## What exists today

| Tool | Where |
| --- | --- |
| Save editor: library, CLI, page (party, boxes, bag, Pokedex, position, flags; legal moves and abilities; story steps, machines and the minimap) | `tools/newgold/devkit/savedit.py`, `saveui.py`, `saveui.html`, `Editor salvataggi.desktop` |
| Diagnostics build and harness: markers, headless core, forced encounters, gym replays, species walks, melonDS driving | `NEWGOLD_DIAG=1`, `src/newgold/diag`, `tools/newgold/devkit/diag`, `tools/newgold/devkit/harness` |
| Importers from the reference (species, moves, trainers, encounters, text, sprites, followers...) | `tools/newgold/import` |
| The ledger and the audit | `tools/newgold/ledger.py`, `docs/newgold/LEDGER.md`, `docs/newgold/AUDIT-*.md` |

## 1. The devkit app and its agent interface

One app with sections — Salvataggi, Mondo, Contenuti, Grafica, Testi, Lotte,
Diagnostica, Compila e gioca — one launcher, and the chat panel beside every
section. Under it, one library that
reads the tree (maps, events, scripts, text, graphics, data) and a command line
over it. The same commands are served as an **MCP server**, so an agent calls
"place this NPC", "render this map", "build", "walk the player there and take a
picture" instead of rediscovering how each time.

*First proof:* the save editor's library and page moved under the app, and its
commands served over MCP.

## 2. World: maps in open formats, Blender and the agent loop

Today the tree keeps the maps as binaries taken from the original ROM (the land
data archive: each map's 3D model, heights and movement permissions; the
building models in `files/fielddata/build_model`). The devkit extracts them once
into open sources and the build compiles them back:

| Part of a map | Source format |
| --- | --- |
| Layout, movement permissions, grass/water/ledges, heights | JSON grids (32x32), with PNG layers where a picture is clearer |
| 3D models (terrain, buildings) | glTF 2.0 — opened and edited in **Blender** |
| Textures | indexed PNG within the DS's limits |
| Events, NPCs, warps, triggers, scripts, encounters | already text in the tree (`zone_event` JSON, `scr_seq` scripts, encounter JSON) |

- **Blender** is the 3D engine underneath: the editor and the agent drive it
  headless through its Python API (`blender --background --python`), with a
  devkit add-on that imports and exports the source format and checks the DS's
  limits (polygon and vertex budgets, texture sizes and colours, video memory).
  Paolo can still open a map in Blender itself. Blender has to be installed on
  Paolo's machine.
- **The compiler** turns the sources into the game's formats (NSBMD, NSBTX, the
  heights and the permissions) and refuses what the DS cannot draw. It is the
  technical core and is written once.
- **Seeing the result:** a renderer that draws a map from above, in perspective
  and with its permissions coloured over it, and the headless harness, which
  draws the field (it cannot draw battles): an agent builds, walks the player
  onto the map, takes a picture and checks that the collisions are right.
- **New maps** also need the world around them: the region's map matrix, the
  zone header (music, weather, name, kind of place), warps, events, encounters,
  the Pokedex area data, the town map position and the fly point. The devkit
  does these together, so a new map is one operation.
- **Paolo's side, in the editor:** the layout painted on a grid, the events
  placed on it, the minimap of the regions, and a 3D view of the map drawn in
  the page from the same glTF (so he sees and turns what Blender builds without
  opening Blender); the chat asks the agent for what the page's tools do not do
  ("add a pond here", "make this house bigger"), and the agent does it in
  Blender underneath.

*First proof:* extract New Bark Town into the sources, render it, compile it
back byte-identical, and walk it in the harness. If this fails, we know early
and cheaply.

## 3. Content: trainers, Pokemon, moves, items, events, the story

Editors over the data the tree already keeps as JSON — trainers and their
parties, species, learnsets, evolutions, moves' data, items, encounter tables —
each checked against the game's rules as the save editor checks moves and
abilities. A new move that copies an existing effect is data; one with a new
effect is battle code, and the editor says so and hands it to an agent.

- **Scripts and events:** a script editor with the command reference read from
  the tree, compiled and checked; NPCs, signs and triggers placed on the map.
- **The story graph:** which flag or variable unlocks what, who sets it and who
  tests it, read from the scripts — for Paolo's story steps and so agents do not
  break the plot.

*First proof:* the trainer editor (the data is `trainers.json`), with a party
checked by the legality rules the save editor already has.

## 4. Graphics and animation

A pipeline where Paolo, an agent or another tool provides the pictures and the
devkit makes them the games' own:

- **Sources:** a PNG sheet with every frame, and a JSON beside it with the
  directions, the frame order, the animation timings and the palette.
- **Kinds:** overworld NPCs and the player (the frame sets and directions the
  original ones have), following Pokemon (the 8-frame follower sheets
  `import_followers.py` already builds), battle front/back sprites, party icons,
  item icons.
- **Checks:** the DS's limits (16 colours, sizes, frame counts), the palette
  shared as the game shares it.
- **Previews:** an animated preview in the page, and the sprite in the game
  itself through the harness (the field and the menus; battle sprites through
  melonDS).
- **Aseprite, the 2D Blender.** The sources can be `.aseprite` files: indexed
  colour with a fixed palette (the DS's 16 colours), layers, frames and tags per
  animation ("walk up", "walk down"...), and Aseprite exports the PNG sheet and
  its JSON of frames and timings itself. Paolo edits them by hand; an agent
  drives the same program headless through its Lua scripting API
  (`aseprite -b --script`) -- drawing, recolouring, moving frames, exporting --
  and looks at its work through exported previews (a zoomed PNG, a GIF), as with
  Blender and the maps. Aseprite costs about 20 euros, or is built from its
  public source for personal use; LibreSprite (free, JavaScript scripting) is
  the fallback. Plain PNG edits in Python need neither.
- **Drawn by the agent, in code.** A DS sprite is small (32x32 for a
  character, 80x80 in battle, 16 colours): the agent writes it pixel by pixel as
  an indexed PNG in Python and looks at an enlarged render of its work, with no
  program in between -- the least friction there is. Aseprite is used where
  layers and animation tags help.
- **Paolo's side, in the editor:** a pixel canvas with the sprite's palette, its
  frames and its animation playing, and the chat beside it: he retouches by
  hand, or tells the agent what to change ("bigger eyes", "the walk is too
  fast") and sees the new version at once, and in the game. The art is judged
  by his eye; the pipeline makes it reliable.

*First proof:* one overworld NPC sheet in, converted, shown walking in the game.

## 5. The battle lab

A battle described as data — both parties, single or double, weather, terrain,
items, levels, the AI — run headless for the battle's own lines and state (the
harness's markers), or opened in melonDS with one click to watch it. A
reproduced bug becomes a test. It grows out of `battle.py`, `gym.py` and the gym
saves.

## 6. Diagnostics and scenarios

The diagnostics build stays a compile-time switch (`NEWGOLD_DIAG=1`). What it
gains: **scenarios** — a save, the inputs, and the markers expected at the end —
kept in the tree and run as tests, so "seen running" grows from what is checked
once into what is checked every time. The crash readers (the frozen melonDS
savestate, the assert markers) stay part of it.

## 7. Languages

The text banks (`files/msgdata/msg/*.gmm`) hold every row with a `<language>`
element per language; today they carry English only, and the build accepts only
`GAME_LANGUAGE=ENGLISH` (`config.mk`). The plan:

- **A reference language per project** (English or Italian). Changing a row in
  the devkit marks the row's other languages "to update" and queues a small
  translation job; its drafts stay "to review" until Paolo approves them.
- **Official text first.** HeartGold's own lines have an official Italian
  translation: it comes from an Italian ROM Paolo owns, extracted the way the
  English base is, never machine-translated. Drafts are for the text hg-engine,
  konefr and Paolo add or change, with the official Italian names (Pokemon
  Central) as the glossary.
- **Checks:** a line fits its window (the font measurement the Dex rewrap
  already uses), placeholders like the player's name stay, the glossary holds.
- **The translation job** runs through the same Claude Code on Paolo's account
  as the chat (never a pay-per-use API key): at once when the editor is open,
  or as a queue an agent works through when it next runs.
- **A localized build:** `GAME_LANGUAGE=ITALIAN` has to become possible — the
  ROM's game code (IPKI), the characters and fonts, the pictures with text
  drawn in them, the languages' alphabetical orders, and the places the code
  already branches on the language. The Italian base assets come from the same
  Italian ROM.

*First proof:* one text bank carrying Italian for its rows, a change to an
English row queuing its Italian draft, and a build with the Italian bank.

## 8. Build and play, and patches

- **Build and play:** one button that builds the ROM, puts the chosen save
  beside it and opens melonDS.
- **Patches:** a ROM cannot be shared; a patch against the original can. The
  devkit makes one for each release, so others can play New Gold.

## Order

1. The app and its MCP interface (1).
2. The world's events, NPCs, trainers, encounters and scripts, and the story
   graph (2 without geometry, 3).
3. The battle lab and the scenarios (5, 6).
4. Languages (7).
5. Graphics (4).
6. Map geometry in open formats with Blender, and new maps (2).
7. Patches (8).

8. The one program: every section joined in the New Gold editor, with the chat
   and its agent across all of them (the product).

Each step starts with its first proof, and nothing starts until Paolo says so.
Steps 1-7 are each usable on their own as they land; step 8 is where they
become one.
