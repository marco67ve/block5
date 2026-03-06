# BLOCK 5 — Storia, versioni e restauri (1987–1990)

BLOCK 5 è un gioco da tavolo digitale ispirato al concetto di "Five in a Row" (conosciuto anche come Gomoku o Connect 5).
L'obiettivo è essere il primo giocatore (o il Computer) a posizionare cinque delle proprie pedine in linea, in orizzontale, verticale o diagonale, su una griglia quadrata.

Nato tra il 1987 e il 1990, scritto in QuickBASIC per i PC IBM dell’epoca, è un progetto che attraversa tre anni di evoluzione tecnica e personale: dalla prima versione in modalità testo del 1987, pensata per girare in modo fluido su un PC/XT, alla versione VGA del 1990, più ricca e scenografica, progettata per i nuovi AT e 386, questo progetto è stato il mio primo tentativo di simulare un'Intelligenza Artificiale (IA) in un ambiente di programmazione che, all'epoca, era all'avanguardia per gli hobbisti.

Questo repository raccoglie, restaura e documenta le versioni del gioco, con l’obiettivo di preservare non solo il codice, ma anche le scelte tecniche, le limitazioni hardware e la filosofia di programmazione dell’epoca.

---

## Origine del progetto

BLOCK 5 nasce nel 1987 dopo l’incontro con un piccolo programma anonimo chiamato `B5.COM`. Quel software, probabilmente scritto in Assembly, presentava una versione essenziale del gioco “Five in a Row” (all’epoca noto in Occidente come *Block Five*). Era un eseguibile molto compatto, privo di grafica, con una griglia fissa 11×11 e una rappresentazione minimale delle pedine.

Quell’esperienza fu lo spunto per creare una versione più ampia e leggibile, sfruttando le possibilità offerte dal QuickBASIC: colori, bordi, griglie variabili e un’interfaccia più chiara. BLOCK 5 non nasce quindi come una critica al programma originale, ma come una reinterpretazione personale, più orientata alla giocabilità e alla presentazione grafica, pur mantenendo la leggerezza e la compatibilità con i PC dell’epoca.

---

## Perché si chiama “BLOCK 5” e non “Gomoku”

Quando il gioco fu scritto nel 1987, il nome “Gomoku” non era conosciuto in Italia né in gran parte dell’Europa occidentale. Il gioco circolava sotto nomi occidentali come “Five in a Row”, “Gobang” o “Block Five”, spesso in piccoli programmi anonimi trovati su floppy.

La versione che ispirò BLOCK 5 era un file chiamato `B5.COM`, che all’avvio mostrava “Block Five”. Non esisteva Internet, non c’erano fonti centralizzate, e quel nome era semplicemente il nome con cui il gioco era conosciuto qui.

BLOCK 5 conserva quindi il nome storico con cui nacque il progetto, mentre “Gomoku” è il nome internazionale del gioco tradizionale.

---

## Le due versioni principali

### Versione 0.9 (1987)
La 0.9 è la versione originale, scritta per funzionare in modalità testo (SCREEN 0) e ottimizzata per i PC IBM XT con CPU 8088 a 4.77 MHz.  
È sorprendentemente reattiva ancora oggi: anche la griglia massima (17×17) risponde in circa 1–2 secondi su un XT emulato, e in modo istantaneo su un 286 o 386.

Caratteristiche principali:
- grafica in modalità testo, semplice e leggibile;
- IA lineare e molto ottimizzata;
- griglie da 10×10 a 17×17;
- nessuna demo automatica;
- nessuna grafica VGA.

È la versione più “giocabile” per chi vuole una partita rapida e leggibile: le griglie più piccole rendono il gioco più tattico e meno dispersivo.

### Versione 1.0 (1990)
La 1.0 introduce la grafica VGA (SCREEN 12), una presentazione più curata e una demo automatica.  
È pensata per i PC AT e 386, e include un test CPU per adattare la velocità della demo alle prestazioni della macchina.

Caratteristiche principali:
- grafica VGA 640×480;
- griglia unica 19×19;
- demo automatica con pausa regolata in base alla CPU;
- IA identica alla 0.9 ma applicata a un campo molto più grande.

È la versione più spettacolare, ma anche la più impegnativa: la 19×19 è un campo enorme e richiede più attenzione strategica.

---

## Note tecniche originali (1987)

Alcune scelte presenti nel codice possono sembrare insolite a chi programma oggi, ma erano perfettamente logiche nel contesto dei PC IBM XT/AT e del QuickBASIC dell’epoca.

### Dimensione degli array (30×30)
Gli array `GG(30,30)` e `GV(30,30)` sono volutamente sovradimensionati rispetto alla griglia massima (17×17).  
Nel 1987 questa era una pratica comune per tre motivi:

- programmazione difensiva per evitare errori “out of bounds”;
- memoria abbondante rispetto alle esigenze (900 interi erano trascurabili);
- flessibilità per eventuali versioni future.

### Limite di 100 tentativi nella mossa casuale
La funzione che genera una mossa casuale usa un ciclo FOR k = 1 TO 100

Questa scelta aveva una motivazione precisa:

- **Evitare loop infiniti** quando la zona attorno all’ultima mossa era piena.
- **Garantire una buona distribuzione casuale** senza rallentare il gioco su un 8088.
- **Fornire un fallback sicuro**: dopo 100 tentativi, il programma passa alla scansione completa della griglia.

Era un equilibrio ideale tra sicurezza, velocità e semplicità, tipico dei giochi DOS dell’epoca.

### Filosofia prestazionale
La versione 0.9 è stata progettata per funzionare in modo fluido su macchine molto diverse tra loro:

- **8088 / 4.77 MHz**
- **80286 / 6–25 MHz**
- **80386 / 16–33 MHz**

Per questo motivo:

- gli algoritmi sono lineari e prevedibili,
- la grafica è in modalità testo (SCREEN 0),
- la logica evita ricorsione e strutture complesse,
- ogni operazione è pensata per essere eseguita rapidamente anche su un XT.

Queste scelte rendono la 0.9 sorprendentemente reattiva ancora oggi, anche in emulazione.


