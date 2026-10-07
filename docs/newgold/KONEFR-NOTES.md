# Da chiedere a konefr

Portando New Gold su pokeheartgold abbiamo letto tutto il lavoro di konefr, commit per commit,
e ogni tanto abbiamo trovato cose che sembrano sviste, pezzi lasciati a metà, avanzi di prove o
scelte che non abbiamo capito. Le raccogliamo qui per chiederle a lui. Non è un bug report e non
è un giudizio: molte potrebbero essere volute, e in quel caso basta saperlo.

Dal 25 settembre vale la regola di Paolo: «se una cosa di konefr è palesemente errata correggila e
comunque mettila nella nota». Palesemente errata vuol dire che nel suo gioco non fa quello che lui
voleva, e che c'è una sola correzione, presa dai suoi dati o da una regola del gioco. Quelle le
correggiamo nel port, e la voce resta qui con la sua domanda, perché lui lo sappia. Il resto resta
com'è. Le voci che potevano essere errori (Allenatori, Incontri 3-6, Specie 2-4, Strumenti 1,
Script e flag 1-2, Testi 1-2 e quelle nuove trovate cercando) le hanno giudicate tre giudici,
ognuno per conto suo. Quando il loro motivo aiuta a fare la domanda, lo riportiamo in una riga.

Come leggere le voci:

- **Domanda** è quella da fargli.
- **Cosa** dice che cosa abbiamo trovato.
- **Dove** dà i commit del suo range (`d0380a487..8fe483d5a`, sopra hg-engine) e i file. Le righe
  sono ancora quelle di `1fa3c9366`. `8cbe6ab86` cambia solo la squadra di Nob (Allenatori 4), e le
  righe di Nob sono date a quel commit; dopo Nob, lì le righe di `data/Trainers.c` sono due più
  avanti.
- La sua punta ora è `8fe483d5a` ("Add shiny Rocket HQ experiment Pokemon", 28 settembre), con
  `0f085efad` ("Rebalance Team Rocket HQ trainers") prima, portate in a2b6dc074: venti allenatori
  del Lago d'Ira, del Covo Rocket e Garett della Torre Radio, cinque con un Pokémon cromatico
  (Allenatori 20). Toccano solo `data/Trainers.c`, mette lui i flag delle mosse e degli strumenti e
  non hanno sviste da correggere. Prima c'era `a477c662f` ("Rebalance Route 42 and Route 43", 27
  settembre), portata in 466dfaa08: nove allenatori delle Route 42 e 43 e della strada per il Mt.
  Mortar e l'erba della Route 43 (Incontri 5, Allenatori 15). A `a477c662f` le righe di
  `data/Trainers.c` dopo il #122 sono ancora più avanti (Nob a `:11215`), e a `8fe483d5a` quelle
  dopo il #109 ancora di più.
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

**Nel port:** corretto (817c7ee13). Paolo l'ha notato anche giocando (5 ottobre), e il 7 ottobre
ha deciso che sono due sviste da correggere: «per la squadra di Silver, se è palesemente una
svista, aggiustala». Il Larvitar prende livello e IV del resto della squadra, L22 e 100, in tutte e
tre le versioni. La versione Bayleef (#1) diventa quella Croconaw (#269) con il suo starter:
Misdreavus, Zubat, Larvitar, Teddiursa e Bayleef, tutti L22. Le due versioni cominciano già allo
stesso modo, e così lo starter resta l'ultimo, come nella versione Quilava e in ogni Silver
retail. La correzione sta nell'importer (`import_trainers.AZALEA_SILVER`): vale finché i tuoi dati
hanno queste sviste, e se le cambi ce lo dice. Visto in gioco: lo scenario
`rival_azalea_bayleef_team.json` (ecf5de327) fa uscire i cinque della versione Bayleef, tutti L22,
e la tappa 08b del playthrough batte quella Croconaw al secondo tentativo, come prima. Se volevi
squadre diverse, dicci quali.

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
**Domanda:** le rivincite di Derek, Chad e Dana sono ancora da fare? E quelle di Tully, Brent e
Tiffany, ora che i loro primi scontri sono a L44-48?

**Cosa:** in 77469fbd4 e 84efd24c6 hai alzato tre primi scontri delle Route 38 e 39, ma le loro
rivincite sono ancora retail:
- il Pokéfan Derek #44 è L38 (Pikachu, Illumise, Volbeat); DEREK_2 #438 è L24/30 e DEREK_3 #439
  L13-37;
- lo School Kid Chad #397 è L37; CHAD_2 #434 è L29/30;
- la Lass Dana #400 è L33-34; DANA_2 #464 è L31/32.

Quindi la prima rivincita è più debole del primo scontro, come per Irwin (voce 12). Per Huey (voce 3)
è il contrario. I giudici: la rivincita _2 si sblocca solo dopo la Torre Radio, e prima il telefono
ripete il primo scontro. Il calo si vede solo oltre il punto dove sei arrivato.

Lo stesso ora per tre allenatori di `a477c662f` (27 settembre), che alza i primi scontri e lascia le
rivincite retail:
- il Fisherman Tully #123 è L44-46; TULLY_2 #323 è L33, TULLY_3 #324 L30-38, TULLY_4 #517 L41-53;
- il Poké Maniac Brent #131 è L45-47; BRENT_2 #172 è L32-34, BRENT_3 #173 L38-43, BRENT_4 #530
  L40-58;
- la Picnicker Tiffany #402 è L46-48; TIFFANY_2 #466 è L34, TIFFANY_3 #467 L41, TIFFANY_4 #522 L61.

**Dove:** `data/Trainers.c:2202` (#44), `:19483` (#438), `:19516` (#439), `:17759` (#397), `:19365`
(#434), `:17912` (#400) e `:20446` (#464). Per i tre di `a477c662f`, righe a quella punta: `:5850`
(#123), `:14824` (#323), `:14850` (#324), `:22834` (#517); `:6264` (#131), `:7863` (#172), `:7903`
(#173), `:23342` (#530); `:18127` (#402), `:20665` (#466), `:20692` (#467), `:23031` (#522).

**Nel port:** tenuto com'è.

### 16. Il Caterpie e il Weedle di Al a L22
**Domanda:** il Caterpie e il Weedle di Al devono restare non evoluti a L22?

**Cosa:** in 782a0aeb4 il Bug Catcher Al #68 della palestra di Azalea passa da L12 a L22 e prende un
Joltik, ma il Caterpie e il Weedle restano com'erano, e tutti e due evolvono al 7. È il contrario
della voce 12: qui sono quindici livelli sopra la loro evoluzione.

**Dove:** `data/Trainers.c:3322`, righe a `a477c662f`.

**Nel port:** tenuto com'è. Il playthrough del port lo batte nella sua tappa 08.

### 17. Li e Falkner, molto sopra il retail
**Domanda:** Li e Falkner devono essere così duri per la prima palestra?

**Cosa:** in 5cfd84cc7 (dopo f6d878a53) Li #290, in cima alla Sprout Tower, passa da due Bellsprout
L7 e un Hoothoot L10 a quattro Pokémon a L10 con mosse e strumenti: due Bellsprout con la Salac e la
Micle Berry, un Hoothoot con Hypnosis e Reflect, un Meditite con Pure Power, Fake Out, Confusion,
Force Palm e Detect, e in borsa una Potion e una Super Potion. Falkner #20 passa da un Pidgey L9 e un
Pidgeotto L13 a cinque Pokémon a L12-13: un Hoothoot con la Wide Lens, un Doduo con la Scope Lens, un
Farfetch'd col Leek, un Delibird con la Focus Sash, un Murkrow con l'Eviolite che usa Roost, e due
Super Potion. Il playthrough del port gioca da una partita nuova con la squadra che cattura: al cap
(10) il Meditite di Li ha battuto sei volte di fila Hoothoot, Cyndaquil e Geodude, e passa solo un
Pokémon Spettro, che Fake Out e Force Palm non toccano; Falkner ha battuto nove volte di fila la
squadra ai suoi livelli (10-12), e il Delibird con la Focus Sash decide quasi tutte le lotte.

**Dove:** `data/Trainers.c:13463` (#290) e `:884` (#20), righe a `a477c662f`.

**Nel port:** tenuto com'è. Il playthrough batte Li con il Misdreavus contro il Meditite, al secondo
tentativo. Falkner lo batteva al quarto, dopo aver portato a 13 con savedit tre dei suoi Pokémon; dal
quattordicesimo giro nessuna modifica: la squadra si allena sull'erba della Route 32 e prende un Mareep
(9af39f13f), e lo batte al primo tentativo (al quinto dove la tappa fu scritta).

### 18. Bugsy, Whitney e la strada per Goldenrod
**Domanda:** Bugsy, Whitney e gli allenatori della Route 35 devono essere così forti?

**Cosa:** seguono la tua scala del cap (22 dopo Proton, 30 dopo Bugsy) ma sono molto sopra il retail:
- Bugsy #21 (782a0aeb4) passa da Scyther L17, Kakuna e Metapod L15 a cinque Pokémon a L20-22 con
  strumento e quattro mosse: un Ledian con Light Clay, Reflect e Light Screen, uno Shuckle con la
  Bacca Oran, Stealth Rock e Rock Tomb, un Ariados con Sticky Web e Sucker Punch, uno Scizor con
  Bullet Punch e un Heracross con Guts e la Flame Orb;
- Whitney #30 (621a22d3c) passa da Clefairy L17 e Miltank L19 a cinque a L28-30: Furret, Ambipom,
  Wigglytuff, un Farigiraf con Nasty Plot, Psychic e Thunderbolt, un Miltank con Milk Drink e
  Bulldoze, e due Super Potion;
- la Lass Carrie #22 della sua palestra ha Granbull e Herdier a L30, il livello più alto di Whitney
  (lo Skitty L20 è la voce 11);
- sulla Route 35, prima della terza medaglia, gli otto allenatori sono a L22-26 (in retail L2-16).

Il playthrough del port, con la squadra che il bot cattura e allena, ha perso con Bugsy dieci volte in
due ordini, mai oltre Ledian, Shuckle o Scizor, e arriva a lui solo dopo una modifica col savedit;
una squadra a L23-27 ha perso con Whitney nove volte di fila e con Carrie sei. Il bot però sceglie le
mosse solo per potenza e tipo e non usa mosse di stato né Pozioni, quindi un giocatore vero fa meglio.

**Dove:** `data/Trainers.c:956` (#21), `:1444` (#30), `:1072` (#22); la Route 35 `:277` (#7),
`:3509` (#72), `:3612` (#74), `:3667` (#75), `:3715` (#76), `:3763` (#77), `:3911` (#80), `:17397`
(#388); righe a `a477c662f`.

**Nel port:** tenuto com'è.

### 19. Pryce, Clair e la Lega
**Domanda:** nessuna, è solo per saperlo.

**Cosa:** dopo i tuoi Chuck e Jasmine a L43-48, Pryce, Clair e la Lega sono ancora ai livelli
retail. Sappiamo che stai ancora finendo gli allenatori, e Paolo (4 ottobre) ha deciso che non è
una domanda da farti.

**Dove:** `data/Trainers.c` alla tua punta `8fe483d5a`.

**Nel port:** tenuti come sono. Li finiranno a mano Paolo e Claude, con il toolkit, dopo il port.

### 20. Il Lago d'Ira e il Covo Rocket
**Domanda:** il Grunt #216 deve avere due Obstagoon? E Garett #471, che si combatte nella Torre
Radio, era fra quelli da ribilanciare col Covo?

**Cosa:** in `0f085efad` hai portato a L46-58, con quattro mosse e uno strumento a testa, venti
allenatori: al Lago d'Ira Alton #109, Lois #116, Andre #126 e Raymond #127; nel Covo Rocket i Grunt
#216, #218-220, #222-224, #404 e #499, gli scienziati Ross #468, Mitch #469 e Gregg #470, Ariana #479,
Petrel #488 e Lance #675, il compagno della lotta in multi del B2F; e lo scienziato Garett #471. In
`8fe483d5a` cinque di loro hanno un Pokémon cromatico (lo shiny lock di hg-engine): il Linoone di
Lois, il Magikarp di Raymond, l'Obstagoon del Grunt #216, il Venomoth del Grunt #220 e il Crobat di
Petrel. Due cose ci sono sembrate strane:
- nel #216 lo stesso commit cambia il Linoone in un Obstagoon cromatico L48, e il Grunt ha già un
  Obstagoon L50 come ultimo Pokémon: due Obstagoon nella stessa squadra. Il Linoone con le stesse
  mosse (Extreme Speed, Shadow Claw, Seed Bomb, Belly Drum) ora è quello cromatico di Lois;
- Garett #471 non sta nel Covo: lo combatte la Torre Radio, al 3F (`MAP_GOLDENROD_RADIO_TOWER_3F`,
  durante l'occupazione dei Rocket), dove gli altri allenatori sono ancora ai livelli retail, e lui
  ora è a L52-54 (Electrode, Togedemaru, Magnezone).

**Dove:** `0f085efad` e `8fe483d5a`, `data/Trainers.c:9744` (#216) e `:21047` (#471), righe a
`8fe483d5a`.

**Nel port:** tenuto com'è, tutti e venti, cromatici compresi (a2b6dc074). Lo shiny lock non
c'era: ora una voce della squadra può essere cromatica (3cfe091dd), e come nel tuo gioco lo diventa
per l'ID dell'allenatore, con la natura e il resto della personalità che restano quelli della voce.
Il Venomoth del Grunt #220 l'abbiamo visto cromatico in lotta (620a38587), blu.

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

Il 27 settembre `a477c662f` ha portato a L44-49, con mosse e strumenti, Marvin, Tully, Shane,
Beckett, Brent, Ron, Benjamin, Tiffany e Spencer (#122, 123, 129-132, 134, 402, 403), e ha cambiato
tre specie per fascia oraria dell'erba della Route 43, ai livelli di prima. I selvatici della Route
42 e del Mt. Mortar, Harrison #537 (L17) e Markus #539 (L19-20) sono rimasti come sopra: sulla Route
42 ora gli allenatori sono a L44-49 e i selvatici a L13-17.

**Dove:** `data/Encounters.c:5214`, `:5314`, `:5414`, `:5614`, `:3811` e `:3911`.

**Nel port:** tenuto com'è.

### 6. Alberi da Headbutt: specie nuove, livelli vecchi
**Domanda:** i livelli degli alberi sono da rivedere?

**Cosa:** 48950dcd4 cambia le specie di 11 tabelle, ma in 10 lascia i livelli retail: per esempio
Route 37/38 a L12-17, dove i selvatici a piedi sono L25-29. L'unica tabella a cui cambiano i livelli
è la Route 39, e scendono di 1 (da 14-15 a 13-14).

**Dove:** `data/Headbutt.c:5334`, `:5380` e `:5427`.

**Nel port:** tenuto com'è.

### 7. Le forme regionali non si trovano in natura
**Domanda:** vuoi che qualche forma regionale si possa catturare, e dove? Per esempio lo Slowpoke di
Galar in un posto diverso da quello dello Slowpoke normale.

**Cosa:** nessuna forma regionale (Alola, Galar, Hisui, Paldea) compare in una tabella di incontri:
non nell'erba, nell'acqua, nelle rocce, negli alberi da Headbutt né nella gara pigliamosche. Le uniche
due nel gioco le hanno degli allenatori: lo Slowpoke di Galar di Larry #23 e lo Slowbro di Galar di
Nelson #389. Quindi oggi nessuna si può catturare.

**Dove:** `data/Encounters.c` e `data/Headbutt.c` alla tua punta `8fe483d5a`: nessuna `SPECIES_*_GALARIAN`,
`_ALOLAN`, `_HISUIAN` o `_PALDEAN`.

**Nel port:** tenuto com'è. Paolo ha deciso (3 ottobre) che il Pokédex le traccia comunque una per una
(viste, catturate, la loro pagina e la loro mappa), e dal quattordicesimo giro lo fa: il salvataggio
tiene quali forme hai visto e catturato (4ff1cd928), la pagina FORMS le elenca col nome della regione e
i tipi (0c57ffe2e, d8c4a38f5), e la pagina AREA mostra dove vive la forma scelta (a301b164b); lo
Slowpoke di Galar di Larry ci si vede. Se le metti nelle tue tabelle, l'importer le porta e il Pokédex
le segue da solo.

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
**Domanda:** Irrigation ed Evaporate dovevano avere gli stessi controlli di Water Absorb? E ora che
Water Absorb e Irrigation prendono anche Soak, Evaporate deve fermare anche le mosse Acqua di stato? E
deve parlare dopo la protezione, come Soundproof (vedi sotto)?

**Cosa:** in 82b788666 Water Absorb ha avuto due condizioni nuove: la mossa deve fare danno (un
controllo che hg-engine aveva tolto «as of Gen5») e chi la usa non può attivare la propria abilità. Irrigation, aggiunta nello stesso
commit, non ha il controllo sul danno, quindi una mossa Acqua di stato come Soak la fa scattare.
Evaporate non ha il controllo su chi la usa.

**Dove:** `src/battle/ability.c:66-82` e `:184-190`.

**Nel port:** Water Absorb è corretto nel dodicesimo giro (3112cb441, layer New Gold): il controllo
sul danno faceva passare Soak, che diventava di tipo Acqua, mentre dalla 4a gen Assorbacqua prende
anche le mosse Acqua di stato (Pokémon Central; Showdown fa lo stesso). Il controllo su chi la usa
resta. Così Water Absorb e Irrigation ora prendono tutte e due Soak; Evaporate è tenuta com'è: ferma
solo le mosse Acqua che fanno danno e non ha il controllo su chi la usa, e quale regola volesse è la
domanda. L'intelligenza artificiale degli allenatori, che nell'undicesimo giro non sapeva che
Irrigation ed Evaporate assorbono l'Acqua (né nel suo gioco, quella di hg-engine, né nel port), lo sa
dal dodicesimo, nel layer New Gold (ca0182d8c, e 45f67b02e per Soak contro Irrigation).

Dal quattordicesimo giro (f48dc4533, layer del motore) i rifiuti delle abilità parlano dove li mette
la nona generazione, e Evaporate, che usa lo script di Soundproof (3e122ad8a), segue il suo posto: una
mossa Acqua contro chi ha Evaporate e si protegge mostra la riga della protezione, e contro chi è
sottoterra o in volo un mancato, non più la riga di Evaporate; parla ancora sopra un tiro di
precisione mancato, perché agisce prima della precisione. Il suo codice non è toccato.

### 4. Solar Seeds
**Domanda:** Solar Seeds va messa fra le mosse a colpi multipli?

**Cosa:** la mossa è a colpi multipli, ma non è in `MultiHitMovesList`, quindi con Parental Bond
colpirebbe solo due volte. In pratica non succede, perché Parental Bond ce l'ha solo Mega Kangaskhan
e le Mega sono spente. La sua animazione (`move_anim/923.s`) è quella di Bullet Seed (331) col numero
cambiato: va bene così?

**Dove:** 05a81a4d4 e `src/battle/other_battle_calculators.c:185`.

**Nel port:** corretto già prima della regola: aggiunta nel layer New Gold (b7c31a7d7). L'animazione
è tenuta com'è (c7f39fca8).

### 5. I tuoi cinque cambi di tipo nella Sala Lotta
**Domanda:** ti va che i tuoi Pokémon ritipizzati arrivino nella Sala Lotta coi tipi nuovi?

**Cosa:** nel quattordicesimo giro la Sala Lotta della Frontiera ha preso il rango Folletto (Paolo,
2 ottobre), e per scegliere l'avversario ora legge i tipi di ogni set dai dati delle specie, non più
dalla tabella della quarta generazione. Così i tuoi cinque cambi di tipo (f61b40c9a, e0bf78b7a,
e9950130e, 05a81a4d4) arrivano anche lì: Meganium (Erba/Folletto) e Mismagius (Spettro/Folletto)
sono offerti sotto Folletto, Typhlosion sotto Fuoco e Terra, Sudowoodo sotto Roccia e Coleottero,
Sunflora sotto Erba e Fuoco. Il rango Folletto ha undici set nel primo tratto e sette nell'ultimo,
due di questi tuoi.

**Dove:** `data/Species.c` alla tua punta `8fe483d5a`; nel port 912d5cd58 e 24ef4532a.

**Nel port:** tenuto così, con i tuoi tipi. Dal quindicesimo giro la Sala ha anche 45 set dei
Folletto delle generazioni dopo la quarta (Sylveon, Florges, Tinkaton, i quattro Tapu e altri,
c2cdf2706): Meganium e Mismagius dividono l'ultimo tratto Folletto con 17 di questi.

### 6. Trubbish e gli sprite delle specie nuove
**Domanda:** il Trubbish affondato l'hai visto in una build del port di prima del 25 settembre?

**Cosa:** è la tua nota della chiamata del 4 ottobre, «trubbish offset sprite (forse tutti
nuovi?)». Nel tuo gioco Trubbish è giusto: il fronte sta 3 righe sopra la linea del terreno, in
mezzo alla sua ombra piccola, come Pikachu, Poliwag e Metapod nel retail. Nel port stava 20 righe
sotto solo prima di 6c562886d (25 settembre). Controllando tutte le specie e le forme aggiunte
abbiamo trovato però 158 record di hg-engine messi male, che nel tuo gioco si vedono: i 120
Pokémon e forme che usano il segnaposto (il fronte di Bulbasaur: Naclstack, Bramblin, gli Iron, i
Pikachu col cappello, i Gigamax, le nuove mega) volano 21-22 righe sopra il terreno, perché il
loro record è quello di Bulbasaur o zero su un'altezza 0; Tirtouga (18 righe), Iron Treads (14),
Steenee e Revavroom (11), Clawitzer (9), Orthworm (8), Terapagos Teracristal (8), Arctovish (6),
Eiscue (5) ed Enamorus Totem (4) stanno in aria; Tauros Combattivo sta 11 righe sopra Tauros, e
le forme di Castform 8-9 righe sotto Castform.

**Dove:** `data/SpriteOffsets.c` di hg-engine (`d0380a487`), non il tuo range.

**Nel port:** corretto nell'importer (3b50ddc9e): un'immagine che un'altra specie disegna già sta
come quella specie, i dieci da terra prendono la mediana dei fronti retail con la stessa ombra, e
una forma sta come la sua base. Forse stanno a terra anche Elgyem, Beheeyem, Tympole, Cofagrigus,
Pumpkaboo, Milcery, Varoom e Miraidon: sono da controllare sui giochi recenti.

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

**Nel port:** tenuto com'è: ci sono i record e niente le dà. Dall'undicesimo giro la tasca delle Bacche
ha 100 posti, uno per ogni Bacca, Hyper comprese (7e3eb8e35, un nuovo formato del salvataggio che il
gioco converte da solo); oggi si possono avere solo le 64 retail.

### 4. Le MT dopo la 92
**Domanda:** ti va la numerazione che ha scelto Paolo, diversa da quella della chiamata?

**Cosa:** nel tuo gioco le macchine sono le 340 di hg-engine (le MT01-MN08 di HeartGold, una
seconda MN07, MT00, le MT093-MT100, le MT100-MT229 di Scarlatto/Violetto e le DT00-DT99), ma si
possono avere solo le 100 di HeartGold, e la tasca MT ne tiene 101. Nella chiamata del 4 ottobre
avevi proposto la base della settima generazione con le mosse dopo in coda. Paolo poi ha deciso
(4 ottobre): le MT01-MT92 e MN01-MN08 di HeartGold restano coi loro numeri, mosse e regali, così i
salvataggi non hanno problemi; poi MT93-MT148: le MT della settima generazione che HeartGold non
ha, con Wild Charge, Snarl, Nature Power, Dazzling Gleam e Confide sui loro numeri e Work Up,
Psyshock e Venoshock nei buchi 94, 97 e 98, le altre in ordine; poi le 29 mosse dopo la settima
generazione che sono MT in Scarlatto/Violetto, nel loro ordine. Niente DT e niente Tera Blast; Fly,
Surf e Waterfall solo MN. Chi impara cosa segue la regola di oggi: le MachineMoves o le LevelMoves
del tuo `8fe483d5a`.

**Dove:** nel port 5059800bf (la lista), 4e65dc1ef (la tasca a 156 posti e la conversione dei
salvataggi), 1f5b24ccb (il negozio).

**Nel port:** fatto così. Le MT93-MT148 si comprano al 5° piano del Centro Commerciale di
Goldenrod, sette in più ogni due medaglie, da 1500 a 10000; una MT si compra una volta sola («You
already have this!»), e tutti i prezzi sono tornati quelli di HeartGold (71e467d2f; i tuoi sono
quelli di Scarlatto/Violetto di hg-engine, vedi sotto). Le altre 184 macchine di hg-engine sono
strumenti senza uso. Lo script che trova gli strumenti conosce le MT nuove (587ce1843), e 11 set
della Sala Lotta hanno cambiato una mossa che solo le macchine di hg-engine insegnavano
(c85f33c05).

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

**Nel port:** fuori scope fino al 4 ottobre (SCOPE.md). Poi Paolo l'ha riportato per i giocatori,
con un'interfaccia vera (844b55090, 69260918c, b308e4e1e): una signora nuova nel Centro Pokémon di
Cherrygrove (la tua signora fuori tiene la sua frase retail) apre l'allenatore EV/IV, dove gli EV
si mettono a mano o con i tuoi dodici preset coi tuoi nomi (banco 550, righe 52-65), 500$ per ogni
decina iniziata che una statistica guadagna, e si fa l'Allenamento Pro con i Tappi di Bottiglia,
che vende lei. La password e le Caramelle Rare a 1$ ci sono solo nella build di diagnostica, con
le tue righe 25-48 del banco 550.

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

Dal 4 ottobre anche: le MT dopo la 92, il negozio di Goldenrod e i prezzi di HeartGold (Strumenti
e MT 4), e l'allenatore EV/IV al posto del tuo venditore (Script e flag 3).

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

### 2. L'esperienza intera a chi ha lottato
**Domanda:** vuoi che ogni Pokémon che ha lottato prenda l'esperienza intera, come dalla sesta
generazione? Se sì, i cap o i livelli degli allenatori andrebbero rivisti?

**Cosa:** oggi l'esperienza di una lotta si divide fra i Pokémon che hanno lottato, come in HeartGold
e in hg-engine (la regola della quinta generazione, anche con `EXPERIENCE_FORMULA_GEN` a
`GEN_LATEST`); dalla sesta ognuno di loro prende l'intera (Pokémon Central, Esperienza). Il tuo range
non la tocca, e hai bilanciato New Gold su questa. Nel quattordicesimo giro un ramo ha provato la
regola moderna: allenare cambiando Pokémon diventa molto più veloce (il Geodude del playthrough da
L5 a L8 in 15.007 frame invece di 41.649).

**Nel port:** Paolo (4 ottobre) la tiene divisa, com'è in HGSS e in hg-engine, finché non lo decidi
tu; il cambio non è stato portato.

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
- Pika Papow e Veevee Volley colpiscono con potenza 0 (370835844).
- Defog toglie Toxic Spikes, Stealth Rock e Sticky Web del bersaglio dalla coda di chi la usa
  (2c4affe08).
- Tidy Up controlla gli id dei lottatori al posto delle condizioni di campo, quindi non toglie mai
  Stealth Rock e Sticky Web (087370d84).
- Un portatore di Red Card che usa U-turn esce comunque (9c5c98f1e).
- Lo script di Matcha Gotcha tira la bruciatura due volte (80128eaed).
- La riga di Flower Veil nel subscript del veleno stampa il messaggio sbagliato (ec42c85dc).
- RKS System di Silvally legge le Piastre invece delle Memorie (356311335).
- Tre difetti nei meteo primordiali (e8ceb35eb).
- Due plurali di strumenti sono più lunghi del loro buffer (c99abb1e3).
- Tutte le specie dopo Arceus hanno body style 0 (8ae70cd5b). 87 cartelle di sprite usano l'immagine
  di Bulbasaur (tenute).
- Refuso "ELECRIC" nel nome di un effetto degli strumenti (`hold_item_effects.h`).
- `RESTORE_ITEMS_AT_BATTLE_END` conta la squadra a fine lotta, dopo la cattura: il Pokémon appena
  catturato perde lo strumento che teneva, che va nella borsa (1cf303d3b).
- `FormReversionMapping` rimanda il Mega Tatsugiri Stretchy alla forma Droopy e il Gigamax Urshifu
  Pluricolpo alla forma Singolcolpo (0f72c35cb).
- Elettroraggio caricato col sereno e liberato con la pioggia rialza l'Attacco Speciale (lo script
  325, 90adab2cb).
- Dry Skin ed Earth Eater chiedono che la mossa faccia danno, quindi Soak e Sand Attack arrivano a chi
  le ha (a96fb2180).
- Il cambio di forma di Cherrim non chiede Flower Gift: anche senza l'abilità prende la forma Sole
  (`BattleFormChangeCheck.c:96`); e Castform con la neve resta com'è, il motore legge solo la
  grandine (d59d0c871, 845f0630d).
- Take Heart ha come bersaglio l'alleato (RANGE_ALLY) e il flag di Protect, anche se alza le
  statistiche di chi la usa: in doppio la ferma il Protect del compagno (corretto nel port, 862bbf415).
- Molte mosse aggiunte che mirano a chi le usa, al suo lato o al campo (Victory Dance, Shore Up, i
  terreni, Aurora Veil e altre) hanno i flag di Protect, Magic Coat e Mirror Move, e tredici non
  hanno quello di Snatch: un Pokémon con Magic Bounce si rimandava la sua Victory Dance all'infinito e
  la lotta si bloccava, e Mirror Move copiava la mossa di chi la usava (corretti nel port, c83450ada,
  b30969756, 27d5a5632, 3d3cdaa93).
- Lo sfondo dei terreni: l'inizio è un'animazione, che l'opzione della scena di lotta spegne, la fine
  no; il comando disegna solo sulla console che fa girare la lotta, quindi in una lotta in link
  l'altro giocatore tiene lo sfondo del terreno; e LoadDifferentBattleBackground legge la sua tabella
  oltre la fine (d27f4aff6). Dopo la riga di una mossa terreno si vedeva l'animazione di un'altra
  mossa (il «TODO: something weird» del motore, `subscript_0354_CREATE_TERRAIN_OVERLAY.s:55`); nel port
  ogni terreno ha ora un'animazione d'inizio sua, che il motore non ha (50d5ad0fa, 22a9c1a48, 3b6951d5a).
- I fronti di 158 specie e forme aggiunte stanno nel posto sbagliato in battaglia: il segnaposto
  (Bulbasaur) vola 21-22 righe, dieci specie da terra stanno in aria, alcune forme non stanno come
  la loro base (`data/SpriteOffsets.c`; corretto nell'importer, 3b50ddc9e; Specie 6).
- I prezzi degli strumenti sono quelli di Scarlatto/Violetto, e quelli delle MT seguono la MT con lo
  stesso numero, non la mossa: Hyper Beam (MT15) 1600, Captivate (MT78) 32000. Nel port sono tornati
  tutti quelli di HeartGold (71e467d2f, Paolo, 4 ottobre).
- Queste cose sono di hg-engine e non sue, anche se i nostri record a volte gliele attribuiscono: i
  prezzi degli strumenti e le potenze di Natural Gift, `ALLOW_SAVE_CHANGES`, gli sprite segnaposto,
  le voci del Pokédex e le 33 Bacche Hyper (Strumenti 3).
