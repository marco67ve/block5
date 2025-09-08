BLOCK 5: Un'Intelligenza Artificiale in BASIC del 1990

Ciao a tutti, sono Marco da Venezia, e questo repository contiene un piccolo pezzo della mia storia di programmatore: "BLOCK 5", un gioco sviluppato in QuickBasic nel lontano 1990.

Questo progetto è stato il mio primo tentativo di simulare un'Intelligenza Artificiale (IA) in un ambiente di programmazione che, all'epoca, era all'avanguardia per gli hobbisti.

Cos'è BLOCK 5?
--------------
BLOCK 5 è un gioco da tavolo digitale ispirato al concetto di "Five in a Row" (conosciuto anche come Gomoku o Connect 5).  
L'obiettivo è essere il primo giocatore (o il Computer) a posizionare cinque delle proprie pedine in linea, in orizzontale, verticale o diagonale, su una griglia 19x19.

Caratteristiche principali:
---------------------------
- Grafica VGA a 16 colori (640x480 pixel)
- Supporto per il mouse, tramite chiamate dirette al BIOS MS-DOS (`INT 33h`)
- IA avversaria basata su un sistema euristico scritto in BASIC
- Sistema di punteggi con salvataggio record
- Semplici effetti sonori DOS

Il cuore di BLOCK 5 è la sua intelligenza artificiale. All'epoca, senza librerie complesse o framework di machine learning, l'approccio era basato su logiche euristiche.

Le principali funzioni IA sono:
-------------------------------
- Analisi4 e Analisi5: cercano sequenze di 4 o 5 pedine allineate per anticipare vittorie o bloccare l'avversario.
- AnalisiM (Mosse Migliori): analizza ogni posizione della griglia e assegna punteggi alle caselle, favorendo quelle più strategiche.
- AnalisiC (Mosse Casuali): mossa di fallback, per giocare anche in assenza di pattern riconoscibili.
- Strategia a Priorità:
    1. Vincere subito, se possibile.
    2. Bloccare una vittoria imminente dell'avversario.
    3. Cercare mosse con valore strategico (attacco).
    4. Cercare mosse con valore difensivo (blocco).
    5. In ultima istanza, una mossa casuale.

Questo sistema consente al computer di sembrare “intenzionale”, pur senza una vera logica predittiva o apprendimento.

Come Eseguirlo?
---------------
Nessun problema su sistemi Windows a 32 bit sia sotto cmd che sotto command.
Per far girare BLOCK 5 su sistemi moderni a 64 bit, avrai bisogno di un emulatore DOS come DOSBox (https://www.dosbox.com/) o DOSBox-X (https://www.dosbox-x.com).

Poiché BLOCK 5 utilizza chiamate a basso livello (CALL INT86OLD) per interagire con mouse e VGA, serve un compilatore Microsoft BASIC come: QuickBASIC 4.5, QBX 7.1, VBDOS 1.0 (Visual Basic for DOS) che puoi cercare online con parole chiave come “QuickBASIC download” e installarlo in una cartella accessibile.

Clona o Scarica questo Repository. Ottieni il file BLOCK5.BAS da questo progetto e compilalo in eseguibile standalone (.EXE) per ottenere il corretto funzionamento del programma.

1. Avvia DOSBox.
2. Monta la cartella contenente QB.EXE e BLOCK5.BAS:
   
   Su Windows:
      mount c c:\qb45
      c:

      (Sostituisci “c:\qb45” con il percorso effettivo dove si
       trovano QB.EXE e BLOCK5.BAS)

   Su Mac/Linux:
      mount c /Users/tuonome/Percorso/qb45
      c:


3. Avvia QuickBASIC

   qb


All’interno dell’ambiente QuickBASIC:

- Apri BLOCK5.BAS (menu `File -> Open`)
- Per eseguirlo: usa `Run -> Start`
- Per creare un file `.EXE`: usa `Run -> Make EXE File...`

Assicurati di attivare l’opzione "Produce Stand-Alone EXE File".

4. Esecuzione

Una volta compilato, potrai eseguire il gioco semplicemente digitando: BLOCK5


Questo è un piccolo progetto personale nato dalla mia passione per la programmazione negli anni '80 e '90.
Condividerlo oggi significa riportare in vita un po’ di quella creatività vintage che ha formato un'intera generazione.
Questo software è stato distribuito originariamente come Freeware nel 1990 e dichiarato Public Domain (PD) nel 1994. Chiunque è libero di usare il codice, copiarlo, modificarlo e redistribuirlo liberamente. È comunque gradita una menzione della fonte se usato in altri progetti. Se ti piace questo progetto, sei libero di lasciarmi un saluto tramite il mio profilo GitHub! 
