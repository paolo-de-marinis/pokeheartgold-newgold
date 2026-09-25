# Da chiedere a konefr

Portando New Gold su pokeheartgold abbiamo letto tutto il lavoro di konefr, commit per commit,
e ogni tanto abbiamo trovato cose che sembrano sviste, pezzi lasciati a metà, avanzi di prove o
scelte che non abbiamo capito. Le raccogliamo qui per chiederle a lui. Non è un bug report e non
è un giudizio: molte potrebbero essere volute, e in quel caso basta saperlo.

Dal 25 settembre vale la regola di Paolo: «se una cosa di konefr è palesemente errata correggila e
comunque mettila nella nota». Palesemente errata vuol dire che nel suo gioco non fa quello che lui
voleva, e che c'è una sola correzione, presa dai suoi dati o da una regola del gioco. Quelle le
correggiamo nel port, e la voce resta qui con la sua domanda, perché lui lo sappia. Il resto resta
com'è. Ogni voce l'hanno giudicata tre giudici, ognuno per conto suo. Quando il loro motivo aiuta a
fare la domanda, lo riportiamo in una riga.

Come leggere le voci:

- **Domanda** è quella da fargli.
- **Cosa** dice che cosa abbiamo trovato.
- **Dove** dà i commit del suo range (`d0380a487..8cbe6ab86`, sopra hg-engine) e i file. Le righe
  sono ancora quelle di `1fa3c9366`. La sua punta, `8cbe6ab86`, cambia solo la squadra di Nob
  (Allenatori 4), e le righe di Nob sono date alla punta. Dopo Nob, alla punta le righe di
  `data/Trainers.c` sono due più avanti.
- **Nel port** dice che cosa abbiamo fatto nel frattempo: tenuto com'è (è suo), corretto (e perché)
  o deciso da Paolo.

Le cose che sono di hg-engine e non sue sono in fondo, a parte.

---

## Allenatori

### 1. Il primo scontro con Silver
**Domanda:** volevi rinforzare il Silver di Cherrygrove?

**Cosa:** in 5cfd84cc7 hai portato gli allenatori 2, 3 e 265 (Silver con Cyndaquil, Totodile e
Chikorita) a L7, IV 40 e una Pozione. Lo scontro di Cherrygrove però usa TRAINER_PASSERBY_BOY
495/496/497, che sono ancora retail: L5 e IV 0. Il 3 e il 265 non sono usati da nessuno script.
Anche il tuo `hg_trainer_log_generator.py` (sezione 1) indica 2/3/265 come primo Silver.

**Dove:** `data/Trainers.c:75`, `:95`, `:11970` (modificati) e `:21864`, `:21898`, `:21932`
(quelli usati). Lo script di Cherrygrove è `scr_seq_0850_T21.s:551-561` nella decomp.

**Nel port:** corretto (7359221d1). I tuoi L7, IV 40 e Pozione sono passati sui 495-497, specie per
specie: 265 → 495 Chikorita, 2 → 496 Cyndaquil, 3 → 497 Totodile. Il ragazzo tiene classe, nome e
frasi, e 2, 3 e 265 restano come li hai lasciati. Far combattere allo script i 2/3/265 avrebbe
mostrato il nome del rivale troppo presto e tolto le frasi. In gioco non l'abbiamo ancora visto:
serve un salvataggio a Cherrygrove prima dello scontro.

### 2. Il grunt del Teatro di Danza di Ecruteak
**Domanda:** il Mickey #63 era pensato per il Teatro?

**Cosa:** 4f0287043 ha ribilanciato il #63 Mickey (Koffing 30, Haunter 31, Weezing 31), ma nessuno
script e nessuna mappa lo usa. Il grunt del Teatro è il #601, che eb4e20f17 ha cambiato a parte in
un solo Weezing L35. Il tuo generatore di log etichetta il #63 come grunt del Teatro.

**Dove:** `data/Trainers.c:3055` (#63) e `:26081` (#601). Nella decomp il Teatro è
`scr_seq_0928_T27R0501.s:226`.

**Nel port:** tenuto com'è.

### 3. Huey nel Faro di Olivine
**Domanda:** volevi ribilanciare l'Huey del Faro?

**Cosa:** 62e0c76de ha ribilanciato il #440 (L35-37), che però è la prima rivincita di Huey al
telefono. L'Huey che sta nel Faro (D27R0102) è il #211, ed è ancora retail: Poliwag 18 e Poliwhirl 20.
Sullo stesso piano c'è Alfred a L36, e tutti gli altri allenatori del Faro sono a L35-42.

**Dove:** `data/Trainers.c:9306` (#211) e `:19563` (#440).

**Nel port:** tenuto com'è. I giudici: correggerlo vuol dire scegliere per te, fra spostare la
squadra del #440 sul #211 e dare al #211 una squadra nuova.

### 4. Nob della palestra di Cianwood e Kiyo
**Domanda:** in "Rebalance Chuck gym trainers" volevi toccare Nob invece di Kiyo? E ora che Nob ha
la sua squadra, Kiyo a L40-43 lo vuoi così?

**Cosa:** ccf2c9f5e ribilancia i Black Belt 156-159 (Yoshi, Lao, Kiyo, Lung). Kiyo (158) però è il
Karate King di Mt. Mortar B1F, non uno della palestra. Il quarto della palestra è Nob (251), che a
`1fa3c9366` aveva ancora il Machop e il Machoke retail a L25, contro gli altri a L40-45. Sembra che
la palestra sia stata presa come 156-159.

Il 24 settembre hai risposto per Nob con 8924ebe2d ("Nob chuck gym") e 8cbe6ab86 ("Update Nob Chuck
Gym"): Hariyama L43 con la Sitrus Berry e Machoke L45 con la Black Belt. Kiyo non l'hai toccato.

**Dove:** ccf2c9f5e, `data/Trainers.c:7311` (Kiyo) e `:11102` (Nob, uguale alla punta). Quel commit
tocca solo i trainer 34, 90-99 e 156-159.

**Nel port:** decisione di Paolo (23 settembre): resta come l'ha lasciato konefr. La nuova squadra
di Nob è portata in 5858ab446, e i suoi strumenti in ba314aa29 (voce 6). Kiyo resta una domanda.
I giudici: quando sei tornato alla palestra non l'hai toccato, né per rimetterlo retail né per
cambiarlo, quindi non si sa se l'hai dimenticato o se lo vuoi così.

### 5. Pokémon senza mosse, che usano solo Scontro
**Domanda:** a questi Pokémon mancano le mosse per svista?

**Cosa:** questi allenatori hanno `TRAINER_DATA_TYPE_MOVES`, ma alcuni loro Pokémon non hanno
`.moves`. La build scrive 0 in tutti e quattro gli slot, per cui in lotta non hanno mosse e usano
solo Scontro (Struggle). In certi casi il Pokémon retail al loro posto le mosse le aveva.

- Carrie #22, palestra di Goldenrod: Skitty L20 e Herdier L30 (eb4e20f17).
- Rod #29, palestra di Violet: Noibat e Delibird (5cfd84cc7, 05a81a4d4).
- Derek #44: Illumise e Volbeat (77469fbd4).
- Ruth #45: Bouffalant (77469fbd4).
- Ian #64: tutti e quattro (e0bf78b7a). I suoi Pokémon retail le mosse le avevano.
- Brooke #76: tutti e tre (e0bf78b7a).
- Kent #213: tutti e tre (62e0c76de). I suoi Krabby retail le mosse le avevano.
- Issac #391: Lickitung (e0bf78b7a). eb4e20f17 ha dato le mosse agli altri tre e ha saltato questo.
- Harry #410: Clamperl e Tentacool (77469fbd4).

**Dove:** `data/Trainers.c` a quei numeri.

**Nel port:** corretto (16a3cf45b). Ognuno dei 20 Pokémon ha le mosse con cui il gioco crea un
Pokémon a quel livello (`InitBoxMonMoveset`): le ultime quattro che impara salendo di livello, come
per un allenatore senza il flag. Clamperl ne ha tre, perché il suo learnset arriva a tre. I giudici:
dove volevi un Pokémon senza mosse hai tolto tu il flag (Mark #395 in a6bf7e9d3), e agli altri tre
di Issac le mosse le hai date. I test: `tests/newgold/test_gyms.py` (`MOVELESS`) ora chiede che
nessun Pokémon delle palestre sia senza mosse, e 0aba1ddfe confronta tutti e 20 con i learnset.
L'importer ora va lanciato in un albero già compilato, e se non lo è lo dice (89e4ce2f1, test in
dd62c2dff). Visto in gioco: lo Skitty e l'Herdier di Carrie usano le loro mosse.

### 6. Strumenti che nessuno tiene
**Domanda:** i Saggi della Sprout Tower dovevano avere la Bacca Oran? E Nob doveva tenere i suoi
due strumenti?

**Cosa:** 5cfd84cc7 dà la Bacca Oran ai Bellsprout di Chow #43 ed Edmond #52. I due però sono
`TRAINER_DATA_TYPE_NOTHING`, senza il flag ITEMS, quindi le bacche non vengono lette. Lo stesso in
8cbe6ab86, il tuo ultimo commit: Nob #251 dà la Sitrus Berry all'Hariyama (quello con Belly Drum) e
la Black Belt al Machoke, ma resta `TRAINER_DATA_TYPE_MOVES`. Archer #485 invece non c'entra: i
cinque strumenti che una ricerca gli aveva dato sono di Proton #486, che il flag ce l'ha.

**Dove:** `data/Trainers.c:2152` e `:2561`. Nob a `:11102`, gli strumenti a `:11116` e `:11125`
(righe della punta).

**Nel port:** corretto (ba314aa29). Se un Pokémon della squadra ha uno strumento, l'allenatore prende
il flag ITEMS, e ognuno tiene quello che hai scritto: Chow Oran, niente, Oran; Edmond una Oran su
tutti e quattro; Nob la Sitrus Berry all'Hariyama e la Black Belt al Machoke. Mosse e livelli non
cambiano. I giudici: ogni altra volta che dai strumenti metti il flag nello stesso commit (Jin #53,
Neal #55 e Li #290 in 5cfd84cc7, Albert in 02c811f26). Visto in gioco: i due Pokémon di Nob tengono
i loro strumenti.

### 7. Nelson (Route 39) e Mark (Route 36), lotte in doppio
**Domanda:** Nelson doveva essere `NO_PARTNER_DOUBLE_BATTLE` come Mark?

**Cosa:** Nelson #389 è `DOUBLE_BATTLE`, ma è da solo e ha solo i testi da lotta singola. Mark #395,
sulla Route 36, era nato `DOUBLE_BATTLE` (a6bf7e9d3) ed è passato a `NO_PARTNER_DOUBLE_BATTLE` in
62e0c76de. Lo stesso commit ha toccato anche Nelson (livelli degli Slowbro) e lo ha lasciato
`DOUBLE_BATTLE`. Poi, secondo la documentazione di hg-engine, un doppio senza partner vuole il testo
di sconfitta in lotta come `TEXT_DOUBLE_DEFEATED_IN_BATTLE_1`, e Mark ha solo `TRMSG_LOSE`.

Nel tuo gioco, quando Nelson vede un giocatore con due Pokémon, il gioco cerca un compagno che sulla
mappa non c'è: un assert, poi un oggetto nullo letto. Se gli parli, i box vengono vuoti. Mark e
Nelson in lotta non dicono mai la loro frase di sconfitta ("I was wrong.", "Ooh, your Pokémon have
potential."): al loro posto escono box vuoti.

**Dove:** `data/Trainers.c:17341` (Nelson) e `:17653` (Mark). La nota è in
`documentation/wiki/Trainer-Pokémon-Structure-Documentation.md:44`.

**Nel port:** corretto.
- Nelson è `NO_PARTNER_DOUBLE_BATTLE` come Mark, e la frase di sconfitta di tutti e due passa nel
  posto che un doppio legge, `TRMSG_DBL_LOSE_1` (247823e32). Tutte e due le frasi ora si vedono.
- Il motore del port chiedeva "è un doppio?" invece di "arriva un compagno?", quindi anche Mark
  cercava un compagno. Ora chiede la seconda: 18dab19df decompila la routine, 0b3eaef4c la cambia.
- Un giocatore con un solo Pokémon in grado di lottare: Mark e Nelson non lo vedono, e se gli parli
  dicono solo la frase d'apertura (8d0f059b4 decompila la routine, 16430cd42 aggiunge il controllo).
  Qui il port si allontana da hg-engine: nel tuo gioco quel giocatore viene sfidato sia a vista sia
  parlandogli, e il doppio parte con un Pokémon solo. Nel port quel doppio non può partire (la build
  diagnostica si resetta, le altre leggono oltre la squadra), quindi vale la regola retail di ogni
  doppio.
- Visti in gioco sulla build diagnostica: Mark e Nelson fino alla fine, in tutti e due gli ordini di
  KO, senza assert. Serviva anche 757cb7ff3, sul posto vuoto di un doppio. Lo scenario
  `tests/newgold/scenarios/mark_double_to_the_end.json` (2a4adf251) rigioca quello di Mark.

### 8. Silver alla Torre Bruciata
**Domanda:** il Silver della Torre Bruciata è rimasto indietro?

**Cosa:** le tre versioni (#263, #267, #270) sono ancora retail, L18-22. Quando lo affronti però il
cap è 34 e batterlo lo porta a 36. Il Silver di Azalea ora è a L22 e i selvatici della Torre sono
L23-31.

**Dove:** `data/Trainers.c:11828`, `:12058` e `:12268`. Il cap è in `src/pokemon.c`, flag 454.

**Nel port:** tenuto com'è. I giudici: l'unica correzione è una squadra nuova, e i tuoi dati non la
danno.

### 9. Le tre versioni del Silver di Azalea
**Domanda:** le differenze fra le tre squadre sono volute?

**Cosa:** in e0bf78b7a la versione Bayleef (#1) ha 4 Pokémon senza Teddiursa, mentre quelle Quilava
(#266) e Croconaw (#269) ne hanno 5. Tutte e tre hanno un Larvitar L10 con IV 0 in una squadra a L22
con IV 100, e ogni volta in uno slot diverso.

**Dove:** `data/Trainers.c:16`, `:11990` e `:12200`.

**Nel port:** tenuto com'è.

### 10. I nuotatori della Route 40
**Domanda:** la Route 40 era in programma?

**Cosa:** Elaine #9, Paula #85, Randall #86 e Simon #16 sono ancora retail, L18-21. I dieci nuotatori
della Route 41 invece sono stati portati a L27-40, dentro ccf2c9f5e ("Rebalance Chuck gym trainers").

**Dove:** `data/Trainers.c:374`, `:4129`, `:4170` e `:709`.

**Nel port:** tenuto com'è.

### 11. Avanzi nella palestra di Goldenrod
**Domanda:** il Jigglypuff di Cathy e lo Skitty di Carrie sono rimasti per sbaglio?

**Cosa:** in eb4e20f17 Cathy #71 ha Delcatty e Miltank a L27, più un Jigglypuff L15 con IV 10 rimasto
dalla squadra retail. Carrie #22 ha uno Skitty L20 accanto a due L30, ed era anche senza mosse (voce
5, corretta nel port).

**Dove:** `data/Trainers.c:3461` e `:1072`.

**Nel port:** tenuto com'è.

### 12. Evoluti sotto il loro livello di evoluzione
**Domanda:** questi livelli sono voluti?

**Cosa:** capita anche nei giochi ufficiali, ma qui sono parecchi:
- l'Ambipom di Whitney è L28, e Aipom impara Double Hit al 32;
- l'Ampharos di Dana #400 è L34, e tu hai spostato Flaaffy → Ampharos a 35;
- il Magcargo di Ned #282 è L31 (Slugma evolve al 38);
- il Cofagrigus di Markus #539 è L20 (34);
- il Persian di Samantha #70 è L25 (28), e le sue frasi sono nella voce 13;
- il Palpitoad di Henry #60 è L14 (Tympole evolve al 25), accanto a un Poliwag L14 (78e568051);
- lo Slowbro di Nelson #389 è L36 (37). Questo sembra voluto: in 77469fbd4 era L37, e in 62e0c76de
  l'hai abbassato a 36 con tutta la squadra.

Poi Irwin: la sua rivincita #454 apre con un Voltorb L22, più basso del primo scontro (#7, L23-26).
Le specie sono cambiate ma i livelli sono rimasti retail. Wade #4 ha un Wurmple L2 con IV 0 in una
squadra L6-7.

**Dove:** `data/Trainers.c` a quei numeri (Henry `:2907`, lo Slowbro di Nelson `:17363`). Flaaffy è in
`data/Evolutions.c`.

**Nel port:** tenuto com'è.

### 13. Le frasi di Samantha
**Domanda:** le frasi di Samantha dovevano dire PERSIAN?

**Cosa:** in eb4e20f17 il primo Meowth di Beauty Samantha #70 (palestra di Goldenrod) diventa un
Persian L25, nello stesso slot e con le stesse mosse retail (Scratch, Growl, Bite, Pay Day). Il
secondo diventa un Wigglytuff. Le sue frasi retail però dicono ancora "No! Oh, MEOWTH, I’m so
sorry!" e "I taught MEOWTH moves for taking on any type...". Quindi si scusa con un Pokémon che non
ha più. In tutto il tuo range è l'unica le cui frasi nominano una specie che hai tolto dalla squadra.

**Dove:** `data/Trainers.c:3418` (il Persian a `:3432`).

**Nel port:** corretto (5a6655bbc): MEOWTH → PERSIAN nelle due frasi, nient'altro. Le righe stanno
ancora nel box. Visto in gioco: "No! Oh, PERSIAN, I'm so sorry!".

### 14. Il Gorebyss di George
**Domanda:** il Gorebyss di George doveva avere mosse sue?

**Cosa:** in ccf2c9f5e (i nuotatori della Route 41) lo Swimmer George #96 ha un Gorebyss L33 con le
stesse mosse dei suoi Tentacool e del Tentacruel: Supersonic, Bubble Beam, Wrap e Toxic. Nel retail
quello slot era un terzo Tentacool. Nel tuo `learnsets.json` Gorebyss non impara né Wrap né Bubble
Beam, in nessun modo. Sembra un cambio di specie con le mosse vecchie rimaste.

**Dove:** `data/Trainers.c:4653` (il Gorebyss a `:4685`, le mosse a `:4687`).

**Nel port:** tenuto com'è. I giudici: in lotta funziona, con quattro mosse vere, e nessuno controlla
che siano legali. Correggerlo vuol dire scegliere due mosse al posto tuo.

### 15. Rivincite al telefono più deboli del primo scontro
**Domanda:** le rivincite di Derek, Chad e Dana sono ancora da fare?

**Cosa:** in 77469fbd4 e 84efd24c6 hai alzato tre primi scontri delle Route 38 e 39, ma le loro
rivincite sono ancora retail:
- il Pokéfan Derek #44 è L38 (Pikachu, Illumise, Volbeat); DEREK_2 #438 è L24/30 e DEREK_3 #439
  L13-37;
- lo School Kid Chad #397 è L37; CHAD_2 #434 è L29/30;
- la Lass Dana #400 è L33-34; DANA_2 #464 è L31/32.

Quindi la prima rivincita è più debole del primo scontro, come per Irwin (voce 12). Per Huey (voce 3)
è il contrario. I giudici: la rivincita _2 si sblocca solo dopo la Torre Radio, e prima il telefono
ripete il primo scontro. Il calo si vede solo oltre il punto dove sei arrivato.

**Dove:** `data/Trainers.c:2202` (#44), `:19483` (#438), `:19516` (#439), `:17759` (#397), `:19365`
(#434), `:17912` (#400) e `:20446` (#464).

**Nel port:** tenuto com'è.

---

## Incontri e gara pigliamosche

### 1. Kleavor sta in una tabella che la gara non legge
**Domanda:** Kleavor deve potersi prendere? E la Black Augurite dovrebbe stare da qualche parte?

**Cosa:** Kleavor compare, all'1%, solo in `ENCDATA_D22R0102_NATIONAL_PARK_BUG_CATCHING_CONTEST`
(e9950130e). La gara però non legge quella tabella: legge `mushi_encount`, e il tuo
`scripts/patch_bug_contest.py` (ff4c57ff5, lanciato dal Makefile da 150349a62) la riscrive senza
Kleavor. Anche Scyther → Kleavor non si può fare, perché la Black Augurite non sta da nessuna parte:
né script, né market, né premi. I premi della gara (1b872926e) danno il Peat Block, che è l'oggetto
accanto (1692), ma non la Black Augurite (1691). La tabella morta ha anche Metapod, Kakuna e Vespiquen
a L24-28, che la tabella vera (L20-30) non ha.

**Dove:** `data/Encounters.c:2411`, `scripts/patch_bug_contest.py:35-47`,
`armips/scr_seq/scr_seq_00151_bug_contest_rewards.s` e `data/Evolutions.c:1739`.

**Nel port:** decisione di Paolo: il suo script per la gara scavalca la tabella, quindi è una sua
scelta e resta così. La gara legge la sua tabella patchata (`files/data/mushi/mushi_encount.csv`,
`tests/newgold/test_bug_contest.py`), e Kleavor per ora non si può ottenere, come nel suo gioco.

### 2. Route 30 di giorno: 11 specie per 12 slot
**Domanda:** manca una specie nella lista diurna della Route 30?

**Cosa:** `speciesDay` elenca 11 specie. Il compilatore riempie il dodicesimo slot (quello dell'1%)
con la specie 0, che il gioco tira lo stesso. Succede da f61b40c9a ed è l'unica lista corta del file.

**Dove:** `data/Encounters.c:334-346`.

**Nel port:** corretto, perché uno slot vivo con la specie 0 è un difetto e non una scelta.
L'importer ripete l'ultima specie che hai scritto, Mankey (902ff2bbf,
`tools/newgold/import/import_encounters.py:124-131`).

### 3. Slot selvatici a livello 1
**Domanda:** gli 1 sono refusi?

**Cosa:** in f61b40c9a la Route 31 ha lo slot 10 a L1 (Hoppip, Metapod o Hoothoot) in una tabella
L4-7. Dark Cave (ingresso della Route 31) ha lo slot 5 a L1 e gli slot 8-9 a L2-3, mentre gli altri
sono L5-7. Di notte lo slot 8 è un Onix L2. Nella stessa grotta, poi, Rock Smash ora dà Shuckle e
Krabby, cioè la coppia di Cianwood: copiata apposta?

**Dove:** `data/Encounters.c:417` (Route 31) e `:6923` (Dark Cave).

**Nel port:** tenuto com'è.

### 4. Whirl Islands a metà
**Domanda:** i piani sotto l'1F dovevano salire di livello, e il surf del B3F dovrebbe funzionare?

**Cosa:** in 53b62ef8f l'1F è salito a L32-36, mentre B1F, B2F e B3F hanno specie nuove ma i livelli
retail L22-25. Nel B3F (cornice sopra la stanza di Lugia) hai aggiunto slot surf a L32-37, però il
`rateSurf` della tabella è 0, quindi non escono mai.

**Dove:** `data/Encounters.c:4311`, `:4411` e `:4611` (surf a `:4673-4678`).

**Nel port:** tenuto com'è.

### 5. Route 42 e Mt. Mortar a metà
**Domanda:** Route 42 e Mt. Mortar sono ancora da finire?

**Cosa:** in 68cf12b72 e seguenti le specie sono cambiate ma i livelli sono rimasti retail: Route 42
L13-17 (al mattino anche Primeape L13-15), stanza centrale di Mt. Mortar L13-15, B1F L15-17. La
stanza della cascata invece è salita a L23-26. Anche gli allenatori sono divisi: Tully, Shane,
Benjamin e Harrison sono retail a L15-19, Markus è a L19-20 (col Cofagrigus nuovo), mentre Hugh è a
L39-40 e Kiyo a L40-43. Poi: la Route 38 (L26-29) è più alta della 39 (L25-27), anche se viene prima.

**Dove:** `data/Encounters.c:5214`, `:5314`, `:5414`, `:5614`, `:3811` e `:3911`.

**Nel port:** tenuto com'è.

### 6. Alberi da Headbutt: specie nuove, livelli vecchi
**Domanda:** i livelli degli alberi sono da rivedere?

**Cosa:** 48950dcd4 cambia le specie di 11 tabelle, ma in 10 lascia i livelli retail: per esempio
Route 37/38 a L12-17, dove i selvatici a piedi sono L25-29. L'unica tabella a cui cambiano i livelli
è la Route 39, e scendono di 1 (da 14-15 a 13-14).

**Dove:** `data/Headbutt.c:5334`, `:5380` e `:5427`.

**Nel port:** tenuto com'è.

---

## Specie e set di mosse

### 1. Annihilape nel suo gioco non si ottiene
**Domanda:** Annihilape doveva essere ottenibile? E sapevi che Rage Fist è bloccata?

**Cosa:** Rage Fist in hg-engine è `FLAG_UNUSABLE_UNIMPLEMENTED`, e con
`BLOCK_LEARNING_UNIMPLEMENTED_MOVES` acceso (`include/config.h:217`) il level-up la salta
(`src/pokemon.c:2064`). Primeape quindi non la impara al 35, e la tua riga `EVO_HAS_MOVE, MOVE_RAGE_FIST`
non scatta mai. Annihilape non è in nessuna tabella selvatica. Per lo stesso motivo l'Annihilape di
Morty entra con uno slot vuoto al posto di Rage Fist, e il Whismur di Issac #391 perde Echoed Voice.

**Dove:** `data/Evolutions.c:815`, `data/Trainers.c` #31 e #391.

**Nel port:** corretto nel layer del motore: implementate Rage Fist (f284695b0), Echoed Voice
(947a540cb) ed `EVO_FORM_ARGUMENT` (de0a85007). Qui Primeape si evolve, e Morty e Issac hanno le loro
mosse.

### 2. Gli starter
**Domanda:** Quilava e Feraligatr sono stati lasciati così apposta?

**Cosa:** Bayleef e Croconaw hanno statistiche nuove, Quilava no. Meganium è diventato Erba/Folletto
e Typhlosion Fuoco/Terra, mentre Feraligatr resta solo Acqua (con statistiche nuove).

**Dove:** `data/Species.c` (f61b40c9a).

**Nel port:** tenuto com'è.

### 3. Le tre abilità che assorbono l'Acqua non controllano le stesse cose
**Domanda:** Irrigation ed Evaporate dovevano avere gli stessi controlli di Water Absorb?

**Cosa:** in 82b788666 Water Absorb ha avuto due condizioni nuove: la mossa deve fare danno (la regola
della 5a gen) e chi la usa non può attivare la propria abilità. Irrigation, aggiunta nello stesso
commit, non ha il controllo sul danno, quindi una mossa Acqua di stato come Soak la fa scattare.
Evaporate non ha il controllo su chi la usa.

**Dove:** `src/battle/ability.c:66-82` e `:184-190`.

**Nel port:** tenuto com'è.

### 4. Solar Seeds
**Domanda:** Solar Seeds va messa fra le mosse a colpi multipli?

**Cosa:** la mossa è a colpi multipli, ma non è in `MultiHitMovesList`, quindi con Parental Bond
colpirebbe solo due volte. In pratica non succede, perché Parental Bond ce l'ha solo Mega Kangaskhan
e le Mega sono spente. La sua animazione (`move_anim/923.s`) è quella di Bullet Seed (331) col numero
cambiato: va bene così?

**Dove:** 05a81a4d4 e `src/battle/other_battle_calculators.c:185`.

**Nel port:** corretto già prima della regola: aggiunta nel layer New Gold (b7c31a7d7). L'animazione
è tenuta com'è (c7f39fca8).

---

## Strumenti e MT

### 1. Le mele di Applin
**Domanda:** dove si trovano Tart Apple, Sweet Apple e Syrupy Apple?

**Cosa:** Applin compare al mattino nell'Ilex Forest, negli slot speciali degli alberi della Route 38
e nella squadra di Gina #65. Le tre mele però non sono da nessuna parte, quindi Applin non si evolve.

**Dove:** `data/Encounters.c:2029` e `:2031`, `data/Headbutt.c:5404-5406`, `data/Evolutions.c:12477`.

**Nel port:** tenuto com'è.

### 2. La MT46 di Mt. Mortar
**Domanda:** volevi mettere una MT46 a Mt. Mortar 1F?

**Cosa:** in 41a28e225 hai definito `FLAG_HIDE_ITEMBALL_D38R0101_TM46 equ 1361`, ma niente la usa: né
uno script né una ball. Poi 1361 è `TRAINER_FLAG_BASE` (1360) + 1, cioè il flag "sconfitto" del
trainer #1, il Silver di Azalea versione Bayleef. Se la colleghi a una ball così com'è, battere quel
Silver nasconde la MT46, e raccogliere la MT46 segna quel Silver come battuto.

**Dove:** `armips/include/flags.s:1207` (e `:1397` per la base).

**Nel port:** non c'è niente da portare, quindi il flag non è stato portato.

### 3. Le 33 Bacche Hyper
**Domanda:** le Bacche Hyper devono potersi trovare nel tuo gioco?

**Cosa:** le 33 Bacche Hyper, da `ITEM_HYPER_CHERI_BERRY` a `ITEM_HYPER_ROSELI_BERRY` (2651-2683),
hanno il loro record nella tasca delle Bacche, ma niente le dà: né allenatori, né market, né
strumenti a terra, né regali. Non le hai aggiunte tu: vengono da hg-engine (3aa4f8563, "plza
items"), prima di `d0380a487`, e il tuo range non le tocca. La domanda è tua perché è il tuo gioco a
decidere se usarle.

**Dove:** `include/constants/item.h:2657-2689` e `data/itemdata/itemdata.c:172329` (la prima).

**Nel port:** tenuto com'è: ci sono i record e niente le dà. La tasca delle Bacche ha 64 posti, e oggi
si possono avere solo le 64 retail (AUDIT, riga aperta).

---

## Script e flag

### 1. Il cap di livello dopo Morty
**Domanda:** il cap dopo Morty lo vuoi continuare? E `LEVEL_CAP_VARIABLE` serve ancora?

**Cosa:** `GetLevelCap` scrive la scala a mano: 10 → 13 → 19 → 22 → 30 → 34 → 36, e 100 dalla Fog
Badge ("Morty defeated: temporary removal of cap"). Tutto quello che hai ribilanciato dopo è senza
cap: il Faro L35-42, Jasmine e Chuck L43-48, Kiyo, i nuotatori della Route 41. La variabile 0x416F è
ancora definita, ma da 8165905f1 non la legge nessuno. I commenti di `config.h:84-86` e del doc di
`GetLevelCap` descrivono ancora il cap a variabile. Il commento a `:1836` dice "Whitney defeated:
temporary removal of level cap", ma il codice restituisce 34. Con `UNCAP_CANDIES_FROM_LEVEL_CAP` e
`ALLOW_LEVEL_CAP_EVOLVE` accesi (6b5570e02) e il venditore della voce 3, le Caramelle Rare scavalcano
il cap.

**Dove:** `src/pokemon.c:1810-1866`, `include/config.h:84-92`.

**Nel port:** riprodotta la sua scala (LEDGER, "Story level cap"). Leggere la variabile è il passo 2
rimandato della separazione dei layer.

### 2. Abilità nascoste che arrivano solo agli allenatori
**Domanda:** le abilità nascoste nuove (anche quelle degli starter) dovevano arrivare al giocatore?

**Cosa:** hai cambiato `HiddenAbilityTable.c` per 15 specie, fra cui gli starter: Mega Sol, Drought
e Dragonize. Il giocatore però riceve un'abilità nascosta solo se uno script accende il flag 2600
(selvatici, regali, uova) o il 2601 (starter), e nessuno li accende, né da te né in hg-engine. Quindi
le vedono solo gli 11 Pokémon di allenatori che le chiedono. Anche la Ability Patch non è da
nessuna parte.

**Dove:** `data/HiddenAbilityTable.c` e `include/config.h:39-41`.

**Nel port:** il meccanismo è portato (e1ceb7fc2), ma come da lui nessun contenuto lo usa (AUDIT:489).

### 3. Il venditore di debug a Cherrygrove
**Domanda:** il menu sviluppatore resta nel gioco che distribuisci?

**Cosa:** `scr_seq_00850_newgold_vendor.s` (b23dc7360, 564419b1a, 725944f6d) si prende lo script 8
della signora di Cherrygrove. Dietro la password 0-2-5-1 vende Caramelle Rare a 1$ l'una e imposta
gli EV del primo Pokémon con dei `give_egg` di specie finte 2000-2011. Il messaggio 51 di
`data/text/550.txt` ha tre righe in un box da due.

**Dove:** `armips/scr_seq/scr_seq_00850_newgold_vendor.s` e `src/field/script_commands.c`.

**Nel port:** fuori scope (SCOPE.md:186-193). Le sue 41 righe di testo sono nel banco 550, ma non le
legge niente.

---

## Testi

### 1. I nomi delle forme di Galar
**Domanda:** i nomi in maiuscolo e lo Slowpoke di Galar senza nome sono voluti?

**Cosa:** in 77469fbd4 hai chiamato tre forme "SLOWBRO", "FARFETCHD" (senza apostrofo) e "SLOWKING",
mentre il resto dei nomi è in maiuscolo e minuscolo ("Farfetch’d"). Slowpoke di Galar è rimasto
"-----", e lo usi: ce l'ha Larry #23 a L12. Delle tre, in gioco c'è solo Slowbro (lo usa Nelson).

**Dove:** `data/Species.c:66067`, `:66124`, `:66181` e `:66523`.

**Nel port:** corretto (147c9e1b8). "SLOWBRO", "FARFETCHD" e "SLOWKING" sono gli identificatori
`SPECIES_` delle basi, non nomi. Una forma che hai chiamato così prende il nome della sua base:
Slowbro, Farfetch’d e Slowking. Nelson ora manda in campo "Slowbro" e non "SLOWBRO". La regola vale
anche per la forma di una forma (590be859f). Lo Slowpoke di Galar mostra "Slowpoke", perché nel port
una forma col nome segnaposto prende il testo della sua base.

### 2. Le battute nuove di Proton non si vedono
**Domanda:** sapevi che le battute nuove di Proton non compaiono?

**Cosa:** hai riscritto l'intro e la frase dopo la lotta di Proton (#486). Allo Slowpoke Well però lo
scontro parte da script, che stampa i testi della mappa, quindi quelle due non si vedono mai. Hai
anche tolto le sue frasi durante la lotta (LAST_POKE e LAST_POKE_HALF).

**Dove:** `data/Trainers.c` #486. Lo script è `scr_seq_0060_D26R0102.s:46` nella decomp.

**Nel port:** tenuto com'è (56b3cfacf).

### 3. Pippo Franco e Pietro Pacciani
**Domanda:** questi testi devono restare nel gioco che distribuisci?

**Cosa:** il Youngster #47 ("Pippo Franco", era Mikey) e il Bird Keeper #383 ("Pietro Pacciani",
era Peter) parlano in italiano in un gioco inglese. Il primo ha righe su no-vax e green pass. Il
secondo ha una poesia, una battuta con "viva il Duce" e una citazione dal processo, mentre la sua
frase dopo la lotta è ancora quella retail inglese. I nomi entrano nelle 12 unità che hg-engine
copia, quindi nel suo gioco si vedono (lo sforamento in memoria è di hg-engine, vedi sotto).

**Dove:** f6d878a53, 5cfd84cc7 e 8bfbf98b8. `data/Trainers.c:2329` e `:17080`.

**Nel port:** tenuto com'è (56b3cfacf, 80fc2f0a1).

---

## Altro

### 1. Avanzi di prove
**Domanda:** si possono togliere?

**Cosa:** `subscript_0031_PARALYZE.s:11` tiene una riga commentata da 77c4ed4bf ("Temporarily disable
Leaf Guard paralysis check for diagnosis"). Dopo c5a5e7a19 → 77c4ed4bf → 16b17a89a lo script è
uguale a quello di hg-engine a parte quel commento, e la correzione vera sta in
`BattleController_BeforeMove.c`. Poi f61b40c9a cambia `’` in `'` in due test di battaglia di
hg-engine (`future_sight/endure_and_protect.c` e `smack_down/ground_target.c`), senza un motivo
apparente.

**Nel port:** niente da portare.

### 2. File generati nella radice del repo
**Domanda:** `trainer_baseline_start_to_morty.md`, `trainer_worklog_start_to_morty.md` e
`hg_trainer_log_generator.py` devono stare nel repo?

**Cosa:** sono circa 5.000 righe ciascuno. La baseline è generata a f6d878a53 con l'albero sporco, e
il worklog è fermo a 59e933896. Il generatore sbaglia gli ID nelle voci Allenatori 1 e 2 (primo
Silver e grunt del Teatro).

**Nel port:** non portati.

### 3. Commit che fanno più cose del titolo
**Domanda:** ti va di tenere un commit per cosa? Il port ricostruisce da dove viene ogni modifica
leggendo i tuoi commit.

**Cosa:**
- 05a81a4d4 "Add Solar Seeds and update Sunflora" fa anche Sudowoodo Roccia/Coleottero, ribilancia
  Donphan, sposta Marill → Azumarill al 22 e cambia la squadra di Rod.
- ccf2c9f5e (Chuck) ribilancia anche i dieci nuotatori della Route 41.
- 41a28e225 aggiunge il flag della MT46 e le statistiche di Sudowoodo.
- 22ae906bf "fix water absorb" tocca solo incontri e allenatori (Bugsy compreso).
- 77469fbd4 da solo non compila (`DOUBLE_BATTLE_BATTLE` e graffe rotte in Derek); lo sistema
  84efd24c6.

**Nel port:** nessuna azione.

### 4. Il branch `ability-testing`
**Domanda:** gli incontri temporanei di `ability-testing` sono solo prove, o qualcosa deve finire
in `heartgold-modern`?

**Cosa:** l'ha segnalato Paolo. Il clone locale ha solo `heartgold-modern`, quindi qui non l'abbiamo
verificato.

**Nel port:** si segue solo `heartgold-modern`.

### 5. Scelte di Paolo nel layer New Gold, da raccontargli
**Domanda:** ti vanno bene? Se preferisci altro, le cambiamo.

**Cosa:** in hg-engine Kingambit e Gholdengo usano `EVO_FORM_ARGUMENT`, che non ha un case, e
Alcremie usa `EVO_SPIN`, che non viene mai controllato. Il port ha dato loro metodi suoi:
- Bisharp si evolve salendo di livello conoscendo Swords Dance (8421a5de5);
- Gimmighoul impara Pay Day al 55 e si evolve conoscendolo (fe832350f, ba7300604);
- Milcery si evolve nella Ice Path tenendo una di sette Bacche (c12e110f2).

Pawniard, Bisharp, Gimmighoul e Milcery non sono ancora in nessuna tabella né squadra.

---

## Proposte da fargli

### 1. Un'intelligenza artificiale più furba e momenti a copione in battaglia
**Domanda:** ti interessa, per New Gold, un avversario che ragiona meglio e la possibilità di
scrivere momenti a copione nelle lotte?

**Cosa:** oggi (come in HeartGold e in hg-engine) ogni allenatore ha gli interruttori
dell'intelligenza artificiale, fino a quattro strumenti usati con le regole originali e le frasi
nei momenti fissi. L'idea è: (1) un'intelligenza artificiale che calcola davvero il danno con
abilità, strumenti, meteo e terreni, cambia Pokémon quando è in svantaggio, usa gli strumenti al
momento giusto e coordina le lotte doppie, magari con una difficoltà a scelta; (2) eventi a
copione per allenatore, del tipo «quando il suo asso scende sotto metà PS, usa il Ricarica
Totale, dice questa frase e cambia il meteo».

**Perché chiederglielo:** ha bilanciato allenatori e livelli sull'intelligenza artificiale di
adesso; una più forte rende il gioco più difficile.

**Nel port:** non fatto; è nel piano, dopo la fine del porting (`DEVKIT-PLAN.md`, «After the
port: game features to build»).

---

## Cose di hg-engine (non sue)

Difetti del motore (`d0380a487`), non di konefr. Possono interessargli, visto che il suo gioco li ha.
L'elenco completo è in AUDIT-2026-09-23.md ("Differences from konefr's reference") e in
`git log --grep='reference defect'`.

- Cattura critica: il tiro non riesce mai per un int × u32 che si avvolge (82eef4cd7). La formula
  conta anche le medaglie come bitmask e fa avvolgere il -20 della Heavy Ball (540cd1805).
- Friend Ball: la config dice 150 di amicizia, il codice scrive 200 (5916a9f43).
- Tinted Lens dà ×1.25 invece di raddoppiare (8a5135105).
- Ice Scales in doppio si accumula fino a 1/16 (96aecbd40).
- Tablets e Vessel of Ruin colpiscono anche chi le porta (2ea835b90), e Fairy Aura non potenzia come
  dovrebbe (6e32d1091).
- Queenly Majesty, Armor Tail e simili leggono la priorità senza segno (e96373647).
- Neutralizing Gas, Quick Draw, Supersweet Syrup e Cud Chew non fanno niente (5cc4657ac e seguenti).
- Power Spot conta anche un alleato esausto (8350fb4be). Victory Star non aiuta le mosse di chi ce l'ha
  (7492cfb69). Stakeout raddoppia la potenza, con una condizione diversa da quella canonica (aab5023d6).
- `EVO_FORM_ARGUMENT` ha righe ma nessun case (de0a85007). `EVO_SPIN` non viene mai controllato, e le
  righe di Alcremie puntano alle forme 7 (Gigamax) e 8 (che non esiste) (c12e110f2).
- Wormadam Trash Cloak non ha learnset, le forme 496-498 neanche, e Wormadam Plant ha le mosse della
  Trash (6260e4960, b0a93967b, 0c7b98f0a, f291e3f65).
- Il Reveal Glass lascia fuori Enamorus (6aaa274f0). Il Rotom Catalog accetta un uovo e perde le sue
  String (359d9af83).
- MART_EXPANSION scambia i commessi di Goldenrod 2F e mette Heart Mail e Air Mail fuori posto. Nel port
  è tenuto il retail (AUDIT:442).
- Il nome allenatore a 12 unità sborda nel messaggio di vittoria della Frontier (80fc2f0a1).
- Lo slot dell'abilità nascosta (0x02) fa anche da override FEMALE e si trascina sul resto della
  squadra: per questo la squadra di Falkner è femmina. Nel port è tenuto fedele (8143a8117, AUDIT:505).
- `EXPAND_TRAINER_GENDER_TABLE` dà Koga e Bruno come femmine e aggiunge una riga per l'ultima classe
  (commento in `src/trainer_data.c`).
- 79 mosse bloccate come non implementate. Il port ha implementato quelle raggiungibili (f37822a03,
  5f8ccce35).
- Pika Papow e Veevee Volley colpiscono con potenza 0 (98f07b4ab).
- Defog toglie Toxic Spikes, Stealth Rock e Sticky Web del bersaglio dalla coda di chi la usa
  (2c4affe08).
- Tidy Up controlla gli id dei lottatori al posto delle condizioni di campo, quindi non toglie mai
  Stealth Rock e Sticky Web (087370d84).
- Un portatore di Red Card che usa U-turn esce comunque (9c5c98f1e).
- Lo script di Matcha Gotcha tira la bruciatura due volte (40485e35d).
- La riga di Flower Veil nel subscript del veleno stampa il messaggio sbagliato (ec42c85dc).
- RKS System di Silvally legge le Piastre invece delle Memorie (356311335).
- Tre difetti nei meteo primordiali (e8ceb35eb).
- Due plurali di strumenti sono più lunghi del loro buffer (c99abb1e3).
- Tutte le specie dopo Arceus hanno body style 0 (8ae70cd5b). 87 cartelle di sprite usano l'immagine
  di Bulbasaur (tenute).
- Refuso "ELECRIC" nel nome di un effetto degli strumenti (`hold_item_effects.h`).
- Queste cose sono di hg-engine e non sue, anche se i nostri record a volte gliele attribuiscono: i
  prezzi degli strumenti e le potenze di Natural Gift, `ALLOW_SAVE_CHANGES`, gli sprite segnaposto,
  le voci del Pokédex e le 33 Bacche Hyper (Strumenti 3).
