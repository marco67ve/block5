'BLOCK 5 versione 0.9 1987 by Marco da Venezia

DEFINT A-Z
DECLARE FUNCTION Analisi4 (t)
DECLARE FUNCTION Analisi5 (t)
DECLARE FUNCTION AnalisiC ()
DECLARE FUNCTION AnalisiM (t)
DECLARE FUNCTION AnalisiValida (i, j, t)
DECLARE SUB Colora5 (t)
DECLARE SUB DisegnaGriglia ()
DECLARE SUB Cornice (r1, r2, c1, c2, testo, sfondo, car, titolo$)
DECLARE SUB DisegnaPedina (i, j, t)
DECLARE SUB Editor (Edit$)
DECLARE SUB FineGioco (a$)
DECLARE SUB Messaggio (a$, c, s)
DECLARE SUB MostraControlli ()
DECLARE SUB MostraRecord ()
DECLARE SUB Punteggi ()
DECLARE SUB Resoconto ()
DECLARE SUB TurnoComputer (Rig, Col)
DECLARE SUB TurnoGiocatore (Rig, Col)
DECLARE SUB PD ()

    CLEAR , , 3000

    OPTION BASE 1

    TYPE GiocoStato
        CurRig AS INTEGER
        CurCol AS INTEGER
        PezziG AS INTEGER
        PezziC AS INTEGER
        AttacG AS INTEGER
        AttacC AS INTEGER
        StrG   AS INTEGER
        StrC   AS INTEGER
        Turno  AS INTEGER
        Pena   AS INTEGER
        Rec    AS INTEGER
        Pas    AS INTEGER
        Pal    AS INTEGER
    END TYPE
   
    DIM SHARED GS AS GiocoStato
    DIM SHARED GG(30, 30), GV(30, 30)
    DIM SHARED p$(7)
    DIM SHARED Lato, cGriglia, cPan, usoTasti$

    CONST Vero = -1
    CONST Falso = 0
    CONST Computer = 1
    CONST Giocatore = 4

    cGriglia = 40  ' colonna griglia
    cPan = 6       ' colonna pannelli
    usoTasti$ = "Usa le frecce per muovere e Enter per posare"

    Lato = VAL(COMMAND$)      ' lato griglia
    IF Lato < 10 OR Lato > 17 THEN Lato = 15
    FOR i = 1 TO Lato
      FOR j = 1 TO Lato
        GG(i, j) = 2
      NEXT j
    NEXT i

    GS.Turno = Giocatore
    GS.CurRig = 1 + Lato \ 2
    GS.CurCol = 1 + Lato \ 2

    DisegnaGriglia

    DO
      IF GS.Turno = Giocatore THEN TurnoGiocatore Rig, Col
      IF GS.Turno = Computer THEN TurnoComputer Rig, Col
      IF GS.Turno = Falso THEN RUN
    LOOP

END

FUNCTION Analisi4 (t)
 
  Analisi4 = Falso  'mosse attacco e difesa da 4

  FOR i = 1 TO Lato
    FOR j = 1 TO Lato
     
      FOR Linea = 1 TO 4
       
        IF Linea = 1 THEN v1 = 0: v2 = 1: v3 = 1
        IF Linea = 2 THEN v1 = 4: v2 = -1: v3 = 1
        IF Linea = 3 THEN v1 = 0: v2 = 1: v3 = 0
        IF Linea = 4 THEN v1 = 0: v2 = 0: v3 = 1
       
        k = 0
        FOR p = 0 TO 4
          IF GG(v1 + i + v2 * p, j + v3 * p) = t THEN k = k + 1
          IF k = 4 THEN
            FOR p1 = 0 TO 4
              IF AnalisiValida(v1 + i + v2 * p1, j + v3 * p1, GS.Turno) THEN
                IF t = 1 THEN GS.AttacC = GS.AttacC + 1
                IF t = 4 THEN GS.AttacG = GS.AttacG + 1
                Analisi4 = Vero
                EXIT FUNCTION
              END IF
            NEXT
          END IF
        NEXT

      NEXT
    NEXT
  NEXT

END FUNCTION

FUNCTION Analisi5 (t)

  Analisi5 = Falso  'verifica 5
 
  FOR i = 1 TO Lato
    FOR j = 1 TO Lato
      k1 = 0: k2 = 0: k3 = 0: k4 = 0
      FOR p = 0 TO 4
        IF GG(i + p, j) = t THEN k1 = k1 + 1
        IF GG(i, j + p) = t THEN k2 = k2 + 1
        IF GG(i + p, j + p) = t THEN k3 = k3 + 1
        IF GG(4 + i - p, j + p) = t THEN k4 = k4 + 1
      NEXT
      IF k1 = 5 OR k2 = 5 OR k3 = 5 OR k4 = 5 THEN
        Analisi5 = Vero
        EXIT FUNCTION
      END IF
    NEXT
  NEXT

END FUNCTION

FUNCTION AnalisiC
 
  AnalisiC = Falso  'mosse Casuali
   
  RANDOMIZE TIMER

  FOR k = 1 TO 100
    IF k < 100 THEN
      x = INT(3 * RND) - 1
      y = INT(3 * RND) - 1
      Rig = GS.CurRig + x
      Col = GS.CurCol + y
      IF Rig > 0 AND Col > 0 THEN
        IF AnalisiValida(Rig, Col, GS.Turno) THEN
          AnalisiC = Vero
          EXIT FUNCTION
        END IF
      END IF
    ELSE
      FOR Rig = 1 TO Lato
        FOR Col = 1 TO Lato
          IF AnalisiValida(Rig, Col, GS.Turno) THEN
            AnalisiC = Vero
            EXIT FUNCTION
          END IF
        NEXT
      NEXT
    END IF
  NEXT

END FUNCTION

FUNCTION AnalisiM (t)

  AnalisiM = Falso  'mosse Migliori

  FOR i = 1 TO Lato
    FOR j = 1 TO Lato
     
      FOR Linea = 1 TO 4
       
        IF Linea = 1 THEN
          p1 = GG(i, j): p2 = GG(i + 5, j + 5)
          v1 = 0: v2 = 1: v3 = 1
        END IF
        IF Linea = 2 THEN
          p1 = GG(5 + i, j): p2 = GG(i, j + 5)
          v1 = 5: v2 = -1: v3 = 1
        END IF
        IF Linea = 3 THEN
          p1 = GG(i, j): p2 = GG(i + 5, j)
          v1 = 0: v2 = 1: v3 = 0
        END IF
        IF Linea = 4 THEN
          p1 = GG(i, j): p2 = GG(i, j + 5)
          v1 = 0: v2 = 0: v3 = 1
        END IF
       
        k = 0
        IF p1 = 2 AND p2 = 2 THEN
          FOR p = 1 TO 4
            p3 = GG(v1 + i + v2 * p, j + v3 * p)
            IF p3 = t THEN k = k + 1
            IF p3 = 2 THEN k = k - 1
            IF p3 <> t AND p3 <> 2 THEN k = 99
          NEXT
          IF k = 2 THEN
            Mig = 1
            FOR p = 1 TO 4
              r = v1 + i + v2 * p: c = j + v3 * p
              IF GG(r, c) = 2 THEN
                IF t = 1 THEN
                  GV(r, c) = GV(r, c) + 1000
                  GS.StrC = GS.StrC + 1
                END IF
                IF t = 4 THEN
                  GV(r, c) = GV(r, c) + 100
                  GS.StrG = GS.StrG + 1
                END IF
              ELSE
                GV(r, c) = 0
              END IF
            NEXT
          END IF
          IF k = 0 THEN
            Mig = 1
            FOR p = 1 TO 4
              r = v1 + i + v2 * p: c = j + v3 * p
              IF GG(r, c) = 2 THEN
                IF t = 1 THEN GV(r, c) = GV(r, c) + 10
                IF t = 4 THEN GV(r, c) = GV(r, c) + 5
              ELSE
                GV(r, c) = 0
              END IF
            NEXT
          END IF
          IF k = -2 THEN
            Mig = 1
            FOR p = 1 TO 4
              r = v1 + i + v2 * p: c = j + v3 * p
              IF GG(r, c) = 2 THEN
                IF t = 1 THEN GV(r, c) = GV(r, c) + 1
                IF t = 4 THEN GV(r, c) = GV(r, c) + 1
              ELSE
                GV(r, c) = 0
              END IF
            NEXT
          END IF
        END IF
       
        FOR p = 0 TO 4
          p3 = GG(v1 + i + v2 * p, j + v3 * p)
          IF p3 = t THEN k = k + 1
          IF p3 = 2 THEN k = k - 1
          IF p3 <> t AND p3 <> 2 THEN k = 99
        NEXT
        IF k = 1 THEN
          Mig = 1
            FOR p = 0 TO 4
              r = v1 + i + v2 * p: c = j + v3 * p
              IF GG(r, c) = 2 THEN
                IF t = 1 THEN GV(r, c) = GV(r, c) + 10
                IF t = 4 THEN GV(r, c) = GV(r, c) + 5
              ELSE
                GV(r, c) = 0
              END IF
            NEXT
        END IF
        IF k = -1 THEN
          Mig = 1
            FOR p = 0 TO 4
              r = v1 + i + v2 * p: c = j + v3 * p
              IF GG(r, c) = 2 THEN
                IF t = 1 THEN GV(r, c) = GV(r, c) + 2
                IF t = 4 THEN GV(r, c) = GV(r, c) + 1
              ELSE
                GV(r, c) = 0
              END IF
            NEXT
        END IF
        IF k = -3 THEN
          Mig = 1
            FOR p = 0 TO 4
              r = v1 + i + v2 * p: c = j + v3 * p
              IF GG(r, c) = 2 THEN
                IF t = 1 THEN GV(r, c) = GV(r, c) + 1
                IF t = 4 THEN GV(r, c) = GV(r, c) + 1
              ELSE
                GV(r, c) = 0
              END IF
            NEXT
        END IF
    
     NEXT

    NEXT
   NEXT

  IF Mig THEN
    FOR i = 1 TO Lato
      FOR j = 1 TO Lato
        IF GV(i, j) > Mig THEN
          Mig = GV(i, j)
          r = i: c = j
        END IF
      NEXT
    NEXT
    IF t = 4 THEN
      IF AnalisiValida(r, c, GS.Turno) THEN
        AnalisiM = Vero
        EXIT FUNCTION
      END IF
    END IF
  END IF

END FUNCTION

FUNCTION AnalisiValida (i, j, t)

  AnalisiValida = Falso

  IF GG(i, j) = 2 THEN
    GG(i, j) = t
    AnalisiValida = Vero
    DisegnaPedina i, j, t
  END IF
 
  FOR x = 1 TO Lato
    FOR y = 1 TO Lato
      IF GG(x, y) = 2 THEN
        Continua = Vero
        EXIT FUNCTION
      END IF
    NEXT
  NEXT
   
  IF NOT Continua THEN GS.Turno = Falso: FineGioco "   PARI   "

END FUNCTION

SUB Colora5 (t)

  FOR i = 1 TO Lato
    FOR j = 1 TO Lato
      k1 = 0: k2 = 0: k3 = 0: k4 = 0
      FOR p = 0 TO 4
        IF GG(i + p, j) = t THEN k1 = k1 + 1
        IF GG(i, j + p) = t THEN k2 = k2 + 1
        IF GG(i + p, j + p) = t THEN k3 = k3 + 1
        IF 4 + i - p > 0 AND 4 + i - p <= Lato THEN
          IF GG(4 + i - p, j + p) = t THEN k4 = k4 + 1
        END IF
      NEXT
      'Lampeggia la fila vincente
      IF k1 = 5 OR k2 = 5 OR k3 = 5 OR k4 = 5 THEN
        COLOR t + 16, 7
        FOR p = 0 TO 4
          IF k1 = 5 THEN LOCATE (i + p) + 3, cGriglia + (j - 1) * 2: PRINT "O"
          IF k2 = 5 THEN LOCATE i + 3, cGriglia + (j + p - 1) * 2: PRINT "X"
          IF k3 = 5 THEN LOCATE (i + p) + 3, cGriglia + (j + p - 1) * 2: PRINT "O"
          IF k4 = 5 THEN LOCATE (4 + i - p) + 3, cGriglia + (j + p - 1) * 2: PRINT "X"
        NEXT
        EXIT SUB
      END IF
    NEXT
  NEXT

END SUB

SUB Cornice (r1, r2, c1, c2, testo, sfondo, car, titolo$)
    COLOR testo, sfondo
    FOR i = r1 TO r2
        car$ = CHR$(car): vs$ = CHR$(186): vd$ = vs$
        SELECT CASE i
            CASE r1
                car$ = CHR$(205): vs$ = CHR$(201): vd$ = CHR$(187)
            CASE r2
                car$ = CHR$(205): vs$ = CHR$(200): vd$ = CHR$(188)
        END SELECT
        LOCATE i, c1, 0: PRINT vs$ + STRING$(c2 - c1, car$) + vd$;
    NEXT
   
    LOCATE r1, 1 + c1 + (c2 - c1 - LEN(titolo$)) \ 2: PRINT titolo$
   
    IF r2 < 25 AND c2 < 80 THEN ' ombra
        FOR i = r1 + 1 TO r2 + 1
            LOCATE i, c2 + 2: PRINT CHR$(219);
        NEXT
        FOR j = c2 + 2 TO c1 + 1 STEP -1
            LOCATE r2 + 1, j: PRINT CHR$(219);
        NEXT
    END IF
END SUB

SUB DisegnaGriglia
 
  Cornice 1, 25, 1, 79, 15, 1, 32, " BLOCK FIVE "
 
  Cornice 3, Lato + 4, cGriglia - 2, cGriglia + 2 * Lato - 1, 0, 7, 32, ""
  FOR i = 1 TO Lato
    FOR j = 1 TO Lato
      LOCATE i + 3, cGriglia - 2 + 2 * j
      PRINT CHR$(254);
    NEXT
  NEXT
  
  Cornice 14, 21, cPan, cPan + 23, 0, 3, 32, " STATO "
  c = cPan + 3
  LOCATE 16, c: PRINT "PEZZI GIOCATORE:"; GS.PezziG;
  LOCATE 18, c: PRINT "PEZZI  COMPUTER:"; GS.PezziC;
  LOCATE 20, c: PRINT "TURNO:"
  
  MostraControlli
  Messaggio usoTasti$, 14, 0

END SUB

SUB DisegnaPedina (i, j, t)
    
  SOUND 5000, .1
 
  LOCATE i + 3, cGriglia + (j - 1) * 2
  IF t = 1 THEN
    COLOR t, 7: PRINT "X";
  ELSEIF t = 4 THEN
    COLOR t, 7: PRINT "O";
  END IF

END SUB

SUB Editor (Edit$)
 
  DIM Edit$(0 TO 15)

  r = CSRLIN: c = POS(1): Limit = 0
 
  DO
    a$ = INKEY$
      IF LEN(a$) = 1 THEN
        c1 = POS(1): c2 = 1 + c1 - c
        IF a$ = CHR$(13) THEN
          FOR i = 1 TO c2 - 1: Edit$ = Edit$ + Edit$(i): NEXT
          IF Edit$ = "" THEN
            Edit$ = "BLOCK 5"
            LOCATE 20, 12: PRINT "BLOCK 5";
          END IF
          EXIT DO
        END IF
        IF a$ = CHR$(8) THEN
          IF c1 < c + 1 THEN c1 = c + 1
          LOCATE r, c1 - 1: PRINT "."; : LOCATE r, c1 - 1
          Edit$(c2 - 1) = ""
        END IF
        no = ASC(UCASE$(a$))
        IF (no > 64 AND no < 91) OR (no > 47 AND no < 58) OR no = 32 THEN
          IF c1 > c + 9 + Limit THEN
              c1 = c + 9 + Limit
              c2 = 9 + Limit + 1
          END IF
          Edit$(c2) = UCASE$(a$)
          LOCATE r, c1: PRINT CHR$(no);
        ELSE
          a$ = ""
        END IF
        Edit$(c2) = UCASE$(a$)
      END IF
  LOOP

END SUB

DEFSNG A-Z
SUB FineGioco (a$)
 
  PLAY "MF T222 O4 L18 EFEFEFEFEF"
 
  IF a$ = " VINCI " THEN Colora5 4
  IF a$ = " HAI PERSO " THEN Colora5 1
 
  IF a$ = " VINCI " THEN
    Punteggi
  ELSE
    MostraRecord
    COLOR 14: LOCATE 20, cPan + 2: PRINT " 様様"; a$; "様様 ";
  END IF

  Messaggio "  PREMI UN TASTO  ", 30, 0

  DO
    a$ = INKEY$
    IF a$ <> "" THEN a = a + 1
    IF a = 1 THEN a = 2: Resoconto
    IF a > 2 THEN GS.Turno = Falso: EXIT DO
  LOOP

END SUB

DEFINT A-Z
SUB Messaggio (a$, c, s)
  
  COLOR c, 1
  LOCATE 24, 2: PRINT SPACE$(78);
  LOCATE 24, 41 - LEN(a$) \ 2: PRINT a$;
  IF s THEN
    SLEEP s
    COLOR 14, 1
    LOCATE 24, 41 - LEN(usoTasti$) \ 2: PRINT usoTasti$;
  END IF

END SUB

SUB MostraControlli
 
  Cornice 3, 11, cPan, cPan + 23, 0, 3, 32, " CONTROLLI "
  LOCATE 5, cPan + 3: PRINT "N = NUOVA PARTITA"
  LOCATE 6, cPan + 3: PRINT "P = PASSA TURNO"
  LOCATE 7, cPan + 3: PRINT "R = RECORD"
  LOCATE 9, cPan + 3: PRINT "F = FINE"

END SUB

SUB MostraRecord

  GS.Rec = Vero
  
  Cornice 3, 11, cPan, cPan + 23, 0, 3, 32, " TOP FIVE "
 
  OPEN "SCORES.B5" FOR APPEND AS #1: CLOSE
  OPEN "SCORES.B5" FOR INPUT AS #1
  LOCATE 5
    WHILE NOT EOF(1)
      p = p + 1
      INPUT #1, p$
      p$(p) = p$
      LOCATE , cPan + 3: PRINT p$
    WEND
  CLOSE

END SUB

SUB PD

  COLOR 0, 3
  LOCATE 16, cPan + 3: PRINT " BLOCK 5  Ver. 0.9 "
  LOCATE 18, cPan + 3: PRINT "   Freeware 1987   "
  LOCATE 19, cPan + 3: PRINT "     PD 1994 by    "
  LOCATE 20, cPan + 3: PRINT "  Marco da Venezia "
  Messaggio " GAME OVER ", 14, 3
  COLOR 7, 0
  CLS
  END

END SUB

SUB Punteggi

  MostraRecord

  p = 50 * (135 - ABS(30 - GS.PezziG)) - 10 * GS.Pena - GS.AttacC + GS.Pas
 
  IF p <= VAL(p$(5)) THEN
    COLOR 10: LOCATE 20, 7: PRINT USING " VINCI PUNTI: ######"; p
    EXIT SUB
  END IF
     
  Messaggio " VINCI PUNTI:" + STR$(p), 10, 0
 
  COLOR 14, 3
  LOCATE 16, 7: PRINT "    NUOVO RECORD    "
  LOCATE 18, 7: PRINT " SCRIVI IL TUO NOME "
  LOCATE 20, 7: PRINT "     ..........     "
  LOCATE 20, 12, 1
 
  Editor Edit$

  p$(6) = STR$(p) + " - " + Edit$
 
  FOR i = 1 TO 6
    FOR j = 1 TO 6
      IF VAL(p$(j)) < VAL(p$(j + 1)) THEN SWAP p$(j), p$(j + 1)
    NEXT
  NEXT

  OPEN "SCORES.B5" FOR OUTPUT AS #1
    FOR i = 1 TO 5
      PRINT #1, p$(i)
    NEXT
  CLOSE
 
  MostraRecord
  
END SUB

SUB Resoconto
 
  Cornice 14, 21, cPan, cPan + 23, 0, 3, 32, " RESOCONTO "
  c = cPan + 2
  LOCATE 16, c: PRINT "           TU     PC"
  LOCATE 17, c: PRINT "PEZZI"; TAB(17); GS.PezziG; TAB(24); GS.PezziC
  LOCATE 18, c: PRINT "ATTACCHI"; TAB(17); GS.AttacG; TAB(24); GS.AttacC
  LOCATE 19, c: PRINT "STRATEGIE"; TAB(17); GS.StrG; TAB(24); GS.StrC
  LOCATE 20, c: PRINT "ERRORI"; TAB(17); GS.Pena

END SUB

SUB TurnoComputer (Rig, Col)
   
  GS.Turno = Computer

  COLOR 1, 3: LOCATE 20, cPan + 13: PRINT " COMPUTER"
    
  ERASE GV

  DO
    IF GS.PezziC THEN
      IF Analisi4(1) THEN EXIT DO
      IF Analisi4(4) THEN EXIT DO
      IF AnalisiM(1) THEN EXIT DO
      IF AnalisiM(4) THEN EXIT DO
      IF AnalisiC THEN EXIT DO
    ELSE
      IF AnalisiValida(1 + Lato \ 2, 1 + Lato \ 2, 1) THEN EXIT DO
      IF AnalisiC THEN EXIT DO
    END IF
  LOOP

  GS.PezziC = GS.PezziC + 1
  LOCATE 18, cPan + 19: COLOR 15, 3: PRINT GS.PezziC
            
  IF Analisi5(1) THEN
    FineGioco " HAI PERSO "
  ELSE
    IF GS.Turno <> Falso THEN GS.Turno = Giocatore
  END IF

END SUB

SUB TurnoGiocatore (Rig, Col)

  IF GS.Turno = Falso THEN EXIT SUB

  GS.Turno = Giocatore

  LOCATE 20, cPan + 13: COLOR 4, 3: PRINT "GIOCATORE"
 
  'Mostra cursore sulla posizione corrente
  LOCATE GS.CurRig + 3, cGriglia + (GS.CurCol - 1) * 2
  
  IF GG(GS.CurRig, GS.CurCol) = 2 THEN
    COLOR 24, 0: PRINT CHR$(254);
  ELSEIF GG(GS.CurRig, GS.CurCol) = 1 THEN
    COLOR 17, 0: PRINT "X";
  ELSEIF GG(GS.CurRig, GS.CurCol) = 4 THEN
    COLOR 20, 0: PRINT "O";
  END IF
 
  DO
 
    a$ = INKEY$

    IF a$ <> "" THEN
   
      IF GS.Rec THEN GS.Rec = Falso: MostraControlli

      'Ripristina cella prima di muoversi
      LOCATE GS.CurRig + 3, cGriglia + (GS.CurCol - 1) * 2
      IF GG(GS.CurRig, GS.CurCol) = 2 THEN
        COLOR 0, 7: PRINT CHR$(254);
      ELSEIF GG(GS.CurRig, GS.CurCol) = 1 THEN
        COLOR 1, 7: PRINT "X"; : COLOR 7
      ELSEIF GG(GS.CurRig, GS.CurCol) = 4 THEN
        COLOR 4, 7: PRINT "O";
      END IF
      
      IF LCASE$(a$) = "n" THEN GS.Turno = Falso: EXIT SUB
      IF LCASE$(a$) = "p" THEN
        IF GS.PezziC = 0 THEN
          GS.Pas = 1000
          GS.Turno = Computer
          Messaggio "   PASSA   ", 14, 1
          EXIT SUB
        ELSE
          GS.Pena = GS.Pena + 1
          Messaggio "   NON PASSA   ", 14, 1
        END IF
      END IF
      IF LCASE$(a$) = "r" THEN MostraRecord
      IF LCASE$(a$) = "f" OR a$ = CHR$(27) THEN PD
      IF a$ = CHR$(32) THEN
         IF p = Falso THEN
            PALETTE 1, 9
            PALETTE 4, 12
            PALETTE 7, 2
            p = Vero
         ELSE
            PALETTE
            p = Falso
         END IF
      END IF
      IF a$ = CHR$(13) THEN
        IF AnalisiValida(GS.CurRig, GS.CurCol, 4) THEN
          EXIT DO
        ELSE
          GS.Pena = GS.Pena + 1
          Messaggio " MOSSA NON VALIDA ", 14, 1
        END IF
      END IF
   
      Cursore = ASC(RIGHT$(a$, 1))

      SELECT CASE Cursore
        CASE 71 TO 81
        IF Cursore < 74 THEN
          IF GS.CurRig = 1 THEN
            GS.CurRig = Lato
          ELSE
            GS.CurRig = GS.CurRig - 1
          END IF
        ELSEIF Cursore > 78 THEN
          IF GS.CurRig = Lato THEN
            GS.CurRig = 1
          ELSE
            GS.CurRig = GS.CurRig + 1
          END IF
        END IF
        IF Cursore = 71 OR Cursore = 75 OR Cursore = 79 THEN
          IF GS.CurCol = 1 THEN
            GS.CurCol = Lato
          ELSE
            GS.CurCol = GS.CurCol - 1
          END IF
        ELSEIF Cursore = 73 OR Cursore = 77 OR Cursore = 81 THEN
          IF GS.CurCol = Lato THEN
            GS.CurCol = 1
          ELSE
            GS.CurCol = GS.CurCol + 1
          END IF
        END IF
      END SELECT
      
      ' Mostra nuovo cursore
      LOCATE GS.CurRig + 3, cGriglia + (GS.CurCol - 1) * 2
      
      IF GG(GS.CurRig, GS.CurCol) = 2 THEN
        COLOR 24, 0: PRINT CHR$(254);
      ELSEIF GG(GS.CurRig, GS.CurCol) = 1 THEN
        COLOR 17, 0: PRINT "X";
      ELSEIF GG(GS.CurRig, GS.CurCol) = 4 THEN
        COLOR 20, 0: PRINT "O";
      END IF
     
    END IF
 
  LOOP

  GS.PezziG = GS.PezziG + 1
  LOCATE 16, cPan + 19: COLOR 15, 3: PRINT GS.PezziG
 
  IF Analisi5(4) THEN
    FineGioco " VINCI "
  ELSE
    IF GS.Turno <> Falso THEN GS.Turno = Computer
  END IF

END SUB

