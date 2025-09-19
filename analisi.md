Analisi del Codice "BLOCK 5" (1990) di Marco

1. Setup Iniziale e Dichiarazioni

    'BLOCK 5 versione 1.0 1990 by Marco da Venezia: Un'ottima intestazione che identifica l'autore e la versione!

    'Richiede VGA, mouse opzionale: Specifiche importanti per l'ambiente di esecuzione dell'epoca.

    'Compilare in fase di test con codice debug: Un'indicazione utile per lo sviluppatore.

    DEFINT A-Z: Dichiarazione implicita di tutte le variabili come Integer, una pratica comune in BASIC per ottimizzare la memoria e la velocità.

    DECLARE FUNCTION/SUB: Dichiarazioni necessarie per le sub-routine e le funzioni, che rendono il codice più modulare e leggibile. Segno di una buona organizzazione per l'epoca!

    CLEAR , , 5000: Probabilmente per impostare la dimensione dello stack o della memoria, tipico dei programmi BASIC.

    OPTION BASE 1: Essenziale per avere array indicizzati da 1 anziché da 0, rendendo la logica delle griglie più intuitiva.

    TYPE GiocoStato: L'uso di un tipo definito dall'utente (struct) è un segno di programmazione avanzata per il BASIC! Permette di raggruppare lo stato del gioco (CurRig, CurCol, PezziG, PezziC, AttacG, AttacC, StrG, StrC, Turno, Pena, Rec, Pas, Pal, Demo). Ottima scelta per mantenere i dati correlati insieme.

    DIM SHARED: Le variabili InReg%, OutReg%, GS, GG, GV, p$ sono dichiarate condivise, il che significa che sono accessibili da tutte le SUB e FUNCTION senza dover essere passate come parametri. Questo semplifica la gestione dello stato globale del gioco.

    CONST Vero = -1, Falso = 0, Computer = 1, Giocatore = 4: L'uso di costanti per i valori logici e per identificare i giocatori è eccellente per la leggibilità del codice. Vero = -1 è standard per il BASIC.

    Inizializzazione di GG(i, j) = 2: La griglia di gioco è inizializzata con 2, che presumo rappresenti una cella vuota. GS.Turno = Giocatore, GS.CurRig = 10, GS.CurCol = 10 impostano lo stato iniziale del gioco.

    Ciclo principale DO...LOOP: La classica struttura per il loop del gioco, che alterna i turni del Giocatore e del Computer. IF GS.Turno = Falso THEN RUN sembra un modo per riavviare il gioco o uscire.

2. Funzioni di Analisi del Gioco (Intelligenza Artificiale)

Qui entriamo nel cuore dell'IA! Si basano sull'analisi della matrice GG (lo stato del tabellone) e GV (i valori assegnati alle mosse).

    FUNCTION Analisi4 (t):

        Scopo: Trovare posizioni dove è possibile creare una sequenza di 4 pedine (attacco) o bloccare una sequenza di 4 pedine avversarie (difesa).

        Logica: Cicla su tutte le celle e poi su 4 direzioni (Linea = 1 TO 4) per controllare sequenze di 5 celle che contengono 4 pedine del tipo t (Giocatore o Computer) e una cella vuota.

        v1, v2, v3: Questi parametri cambiano in base alla Linea e definiscono la direzione di scansione (orizzontale, verticale, diagonale). Non sono immediatamente intuitivi senza commenti, ma con un po' di reverse engineering si capisce che stanno manipolando gli indici i e j per muoversi sulla griglia. Ad esempio:

            Linea = 1: v1=0, v2=1, v3=1 -> GG(i+p, j+p) (diagonale principale)

            Linea = 2: v1=4, v2=-1, v3=1 -> GG(4+i-p, j+p) (diagonale secondaria, notare 4+i-p per invertire la direzione)

            Linea = 3: v1=0, v2=1, v3=0 -> GG(i+p, j) (verticale)

            Linea = 4: v1=0, v2=0, v3=1 -> GG(i, j+p) (orizzontale)

        Incrementa k se trova una pedina di tipo t. Se k=4 (quattro in fila) e c'è una posizione valida adiacente, incrementa GS.AttacC o GS.AttacG e ritorna Vero.

        Questa è una logica fondamentale per un gioco come il Gomoku e ben implementata per un'IA di base.

    FUNCTION Analisi5 (t):

        Scopo: Verificare se un giocatore (di tipo t) ha vinto mettendo 5 pedine in fila.

        Logica: Simile a Analisi4, ma cerca esattamente 5 pedine consecutive in orizzontale, verticale o diagonale.

        k1, k2, k3, k4 contano le pedine per le 4 direzioni. Se una di queste arriva a 5, il gioco è vinto.

        Essenziale per la condizione di vittoria/sconfitta.

    FUNCTION AnalisiC (Mosse Casuali):

        Scopo: Trovare una mossa valida casuale.

        Logica: Genera coordinate (Rig, Col) casuali nell'intorno della posizione corrente (GS.CurRig, GS.CurCol) per le prime 100 iterazioni. Se non trova una mossa valida in quell'area, scansiona l'intera griglia.

        RANDOMIZE TIMER per inizializzare il generatore di numeri casuali, una buona pratica.

        Serve come fallback se l'IA non trova mosse "migliori" o "di attacco/difesa".

    FUNCTION AnalisiM (t) (Mosse Migliori - Euristica di Valutazione!):

        Scopo: Assegnare un punteggio (GV(r, c)) alle mosse potenziali, per poi scegliere la migliore. Questa è la parte più interessante per l'IA!

        Logica: Cicla su tutte le possibili sequenze di 5 celle e valuta le posizioni vuote (GG(r, c) = 2) all'interno o ai bordi di queste sequenze.

        Assegna punteggi diversi (+1000, +100, +10, +5, +2, +1) in base a quanti pezzi del giocatore t (Computer o Giocatore) sono già presenti nella sequenza di 5.

            k=2 (2 pezzi del giocatore t e 3 vuoti, o meglio 2 pezzi del giocatore t e 2 vuoti e 1 blocco): assegna un punteggio alto (+1000 per il Computer, +100 per il Giocatore) per suggerire una mossa che porti a 3 in fila e quindi 4 potenziale. GS.StrC e GS.StrG incrementano, probabilmente per contare le "strategie" trovate.

            k=0 (0 pezzi del giocatore t e 4 vuoti): assegna un punteggio medio (+10 per il Computer, +5 per il Giocatore).

            k=-2 (2 pezzi dell'avversario e 2 vuoti, o 2 pezzi avversari e 1 vuoto e 1 blocco): assegna un punteggio basso (+1 o +2), per "sporcare" la riga o non dare priorità.

            k=1 (1 pezzo del giocatore t e 3 vuoti): punteggio medio (+10 / +5).

            k=-1 (1 pezzo dell'avversario e 3 vuoti): punteggio basso (+2 / +1).

            k=-3 (3 pezzi dell'avversario e 1 vuoto): punteggio molto basso, quasi irrilevante per attaccare, ma potrebbe essere per difesa.

        Mig tiene traccia del punteggio massimo trovato e r, c delle coordinate della mossa corrispondente.

        Questo approccio è una forma di valutazione euristica. L'IA non "capisce" la partita, ma assegna valori numerici a diverse configurazioni del tabellone per stimare la "bontà" di una mossa. È la base di molti giochi AI classici e rappresenta una forma primitiva ma efficace di "pensiero" per la macchina.

    FUNCTION AnalisiValida (i, j, t):

        Scopo: Verificare se una cella (i, j) è vuota (GG(i, j) = 2) e, in tal caso, piazzare la pedina del giocatore t.

        Aggiorna la griglia (GG(i, j) = t) e chiama DisegnaPedina.

        Contiene anche una logica per verificare se la griglia è piena (Continua = Vero se trova almeno una cella vuota). Se non ci sono più mosse possibili, chiama FineGioco " PARI ".

3. Routine di Disegno e Interfaccia Utente

    SUB DisegnaFinestre:

        Responsabile del disegno dell'intera interfaccia grafica: bordi, riempimenti (PAINT), testo (LOCATE, PRINT).

        Usa SCREEN 12 (VGA 640x480, 16 colori).

        Le chiamate LINE, PAINT, COLOR sono standard QBasic per la grafica.

        Interessante la griglia disegnata con LINE per creare le celle del tabellone.

        Aggiorna le etichette per il turno, i pezzi del giocatore e del computer.

    SUB DisegnaCursore (i, j, t) / SUB DisegnaPedina (i, j, t):

        Disegnano visivamente il cursore o la pedina sulla griglia.

        Utilizzano CALL INT86OLD(&H33, InReg%(), OutReg%()) per disabilitare/abilitare il cursore del mouse (Servizio BIOS INT 33h). Questo mostra una conoscenza approfondita dell'interazione hardware/software dell'epoca! 🤩

        SOUND 5000, .1: Un suono quando viene piazzata una pedina! Un bel tocco per l'esperienza utente.

        CIRCLE e PAINT per disegnare le pedine.

    SUB Colora5 (t):

        Scopo: Evidenziare la sequenza di 5 pedine che ha portato alla vittoria.

        Logica: Simile a Analisi5, ma invece di solo verificare, colora le pedine vincenti con un colore diverso (t + 8) usando PAINT. Questo aggiunge un feedback visivo immediato al giocatore.

    SUB Messaggio (a$, s):

        Visualizza un messaggio centrato in una finestra apposita.

        SLEEP (s) per far rimanere il messaggio a schermo per un certo tempo.

        Usata per feedback rapidi.

    SUB MostraControlli / SUB MostraRecord:

        Gestiscono la visualizzazione del pannello di controllo (tasti rapidi) e la tabella dei record.

        MostraRecord gestisce anche la lettura/scrittura su file (SCORES.B5). Un sistema di persistenza dei dati semplice ma efficace.

    SUB Editor (Edit$):

        Una routine di input personalizzata! Permette di scrivere il nome per il record.

        Gestisce input da tastiera (INKEY$), backspace, e limitazioni sui caratteri. Molto impressionante per un gioco in BASIC!

4. Logica di Gioco e Stati

    SUB FineGioco (a$):

        Gestisce la fine della partita (vittoria, sconfitta, pareggio).

        PLAY "MF T222 O4 L18 EFEFEFEFEF": Musica di fine gioco! 🎶 Un'altra chicca per l'esperienza utente.

        Chiama Colora5 per evidenziare la riga vincente.

        Chiama Punteggi o MostraRecord a seconda dell'esito.

        Attende l'input dell'utente.

        Resoconto: Mostra le statistiche dettagliate della partita (pezzi, attacchi, strategie, errori). Ottima per dare un'idea di come è andata la partita.

    SUB Punteggi:

        Calcola il punteggio del giocatore (p# = 50 * (180 - ABS(45 - GS.PezziG)) - 10 * GS.Pena - GS.AttacC + GS.Pas). Una formula euristica interessante che considera:

            GS.PezziG: Numero di pezzi piazzati dal giocatore (più pedine piazzate, più punti).

            GS.Pena: Penalità per mosse non valide.

            GS.AttacC: Attacchi del computer (penalizza se il computer ha fatto molti attacchi).

            GS.Pas: Bonus per il passaggio del turno (se il giocatore passa quando il computer non ha ancora pedine).

        Confronta il punteggio con i record esistenti, gestisce l'inserimento del nuovo nome e riordina i record (SWAP p$(j), p$(j + 1)).

        Scrive i nuovi record sul file SCORES.B5.

    SUB TurnoComputer (Rig, Col):

        Il cervello del Computer.

        Priorità delle mosse:

            Analisi4(1): Cerca di vincere (4 pezzi del Computer).

            Analisi4(4): Cerca di bloccare il Giocatore (4 pezzi del Giocatore).

            AnalisiM(1): Cerca la mossa migliore per sé (Computer).

            AnalisiM(4): Cerca la mossa migliore per bloccare il Giocatore.

            AnalisiC: Mossa casuale come fallback.

        Questa sequenza di priorità è una strategia IA comune: vincere > bloccare > migliorare la propria posizione > attaccare l'avversario > mossa random. Molto ben pensata per un'IA basilare.

        ERASE GV: Pulisce i valori di valutazione prima di ogni turno del computer, assicurando che la valutazione sia basata sullo stato attuale del gioco.

        Aggiorna il contatore dei pezzi del computer.

        Verifica la vittoria del computer (Analisi5(1)) o passa il turno al giocatore.

    SUB TurnoGiocatore (Rig, Col):

        Gestisce l'input del giocatore.

        Comprende:

            Movimento del cursore tramite mouse (coordinate OutReg%(3) e OutReg%(4) dal CALL INT86OLD(&H33...)).

            Movimento del cursore tramite tasti direzionali (Cursore usando ASCII dei tasti).

            Click del mouse per piazzare la pedina (Bot = 1) o per attivare i controlli (r = 8...12).

            Gestione dei comandi da tastiera (N = Nuova Partita, P = Passa Turno, R = Record, F = Fine, Esc = Fine, Spazio = Demo Mode).

            La gestione del "Passa Turno" con GS.Pena è una buona meccanica di gioco.

            PALETTE: Il tasto . cambia i colori delle pedine.

    SUB Z.Marco:

        Una sub di debug/test che stampa lo stato numerico della griglia (GG(i, j)) direttamente a schermo. Utile per visualizzare la logica interna.
