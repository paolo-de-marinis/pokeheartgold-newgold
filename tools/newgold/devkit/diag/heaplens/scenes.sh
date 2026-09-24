#!/bin/bash
# scenes.sh SAVES OUT [RUN...]: the scene catalogue the boot heaps were
# measured with in round 7 -- each RUN is drive.py on one of saves.py's saves
# (SAVES/violet_pc.sav, violet_pc_down.sav, daycare.sav, azalea_twins.sav),
# output in OUT/RUN/ (lens.json, log.txt, shots). Every application's scene
# ends while it is still open, and the way back to the field is a scene of
# its own. All runs by default, JOBS=3 at a time, each under capped (4G).
# SNAP=snapshot (snap.sh) reads that build instead of this tree's.
[ $# -ge 2 ] || { sed -n '2,9s/^# //p' "$0"; exit 2; }
HERE=$(dirname "$(readlink -f "$0")")
S=$1; O=$2; shift 2
mkdir -p "$O"
export TMPDIR=${TMPDIR:-$O}
BACK="B/250 B/250 B/250 B/100"
d() {
    local name=$1 save=$2; shift 2
    rm -rf "${O:?}/$name"
    timeout 2400 "$HERE/../../capped" -m 4G python3 "$HERE/drive.py" "$S/$save.sav" "$O/$name" "$@" > "$O/$name.out" 2>&1
    echo "$name: exit $?"
}
menus() { d menus violet_pc_down continue B/60 \
  "scene:Pokedex (inside: opening, list scrolled, entry pages, search)" menu:dex RIGHT/100 LEFT/100 A/250 'DOWN*60/6' w:60 A/250 RIGHT/150 RIGHT/150 RIGHT/150 B/200 Y/250 t:128,176/300 w:200 shot:dex \
  "scene:Pokedex closed, back to the field" $BACK B/250 \
  "scene:party and summary (inside)" menu:mon A/80 A/300 'RIGHT*5/100' shot:summary \
  "scene:party closed, back to the field" $BACK \
  "scene:bag (inside, every pocket)" menu:bag t:15,16/60 t:47,16/60 t:79,16/60 t:111,16/60 t:143,16/60 t:175,16/60 t:207,16/60 t:239,16/60 shot:bag \
  "scene:bag closed, back to the field" $BACK \
  "scene:Pokegear (inside)" menu:gear w:200 t:30,176/250 t:90,176/250 t:160,176/250 shot:gear \
  "scene:Pokegear closed, back to the field" $BACK \
  "scene:trainer card (inside)" menu:card A/100 t:128,100/100 shot:card \
  "scene:trainer card closed" $BACK \
  "scene:options (inside)" menu:options shot:options \
  "scene:options closed" $BACK \
  "scene:save the game" menu:save A/200 w:900 shot:saved B/100 B/100 B/100 \
  "scene:Rare Candy through the bag and party, to the level up" menu:bag t:47,16/60 t:192,48/60 A/60 A/200 shot:candy \
  "scene:evolution app (Rare Candy)" B/100 B/100 w:600 B/100 w:1500 shot:evo \
  "scene:evolution done, back to the field" B/200 B/200 B/250 B/250 B/250 end; }
walk() { d walk violet_pc_down continue B/60 pos \
  "scene:overworld: walk down the Pokemon Center" hold:DOWN:100 pos shot:w1 \
  "scene:overworld: out of the door (map change to Violet City)" hold:LEFT:55 pos hold:DOWN:40 w:400 pos shot:w2 \
  "scene:overworld: Violet City, walk" hold:DOWN:40 hold:LEFT:60 hold:RIGHT:60 hold:UP:40 pos shot:w3 \
  "scene:overworld: back into the Pokemon Center (map change)" hold:UP:40 w:400 pos shot:w4 \
  "scene:overworld: up the stairs to B1F (map change)" hold:RIGHT:100 hold:UP:40 w:400 pos shot:w5 end; }
pc() { d pc violet_pc continue \
  "scene:PC: boot, storage system in Deposit then Move mode" openpc shot:pc \
  "scene:PC: held items (the bag over the PC)" A/60 DOWN/20 DOWN/20 A/300 shot:pcbag t:47,16/60 t:64,48/60 \
  "scene:PC: bag closed, back to the boxes" B/200 B/250 B/250 \
  "scene:PC: page through the 30 boxes, pick up and put down" 'R*29/50' A/60 A/60 DOWN/30 RIGHT/30 A/60 B/60 \
  "scene:PC: summary from the box" A/60 DOWN/20 A/400 shot:pcsummary 'RIGHT*4/80' \
  "scene:PC: close, back to the field" B/300 'B/150' 'B/150' 'B/150' 'B/150' 'B/150' 'B/150' end; }
run() { d run violet_pc_down continue B/60 \
  "scene:wild battle, run away" battle:161 runaway w:400 end; }
catch() { d catch violet_pc_down continue B/60 \
  "scene:wild battle, catch without a nickname (bag, ball, dex page, to the PC)" battle:161 w:120 t:40,170/200 t:192,72/150 t:64,24/150 t:52,172/150 w:1500 text t:128,138/200 w:600 'B/100' 'B/100' 'B/100' w:600 shot:caught text end; }
naming() { d naming violet_pc_down continue B/60 \
  "scene:wild battle, catch with the nickname screen" battle:161 w:120 t:40,170/200 t:192,72/150 t:64,24/150 t:52,172/150 w:1500 A/150 A/150 w:300 shot:naming START/100 A/200 w:900 shot:after end; }
evolve() { d evolve violet_pc_down continue B/60 \
  "scene:wild battle, win" battle:19 fight:2 \
  "scene:evolution after the battle" state:EXIT:9000 \
  "scene:back to the field" w:300 'B/100' 'B/100' w:600 end; }
twins() { d twins azalea_twins continue pos \
  "scene:double trainer battle (Twins Amy & Mimi)" A/60 A/60 A/60 A/60 w:600 fight state:EXIT:9000 text 'A/100' 'A/100' 'A/100' 'A/100' w:300 end; }
daycare() { d daycare daycare continue B/60 \
  "scene:Day-Care: the lady, the party menu (inside)" A/100 A/100 A/100 A/100 A/300 shot:dc1 \
  "scene:Day-Care: Pokemon left, back to the field" A/100 A/300 'A/100' 'A/100' 'A/100' 'A/100' 'B/100' shot:dc2 end; }
commerr_battle() { d commerr_battle violet_pc_down continue B/60 \
  "scene:wild battle" battle:161 \
  "scene:communication error raised in a battle" commerr w:600 shot:err1 w:600 end; }
commerr_field() { d commerr_field violet_pc_down continue B/60 \
  "scene:communication error raised in the field" commerr w:600 shot:err1 w:600 end; }

RUNS="menus walk pc run catch naming evolve twins daycare commerr_battle commerr_field"
for r in ${*:-$RUNS}; do
    case " $RUNS " in *" $r "*) ;; *) echo "no run $r (runs: $RUNS)"; exit 2 ;; esac
    while [ "$(jobs -r | wc -l)" -ge "${JOBS:-3}" ]; do wait -n; done
    $r &
done
wait
