'BLOCK 5 versione 1.0 1990 by Marco da Venezia
'Richiede VGA, mouse ozionale
'Senza VGA o superiore, restituisce il controllo al DOS
'Se mouse non istallato, usa i tasti direzionali ed Enter
'Barra spazio per demo on/off, punto per colori pedine
'Caricamento: QB/LQB

DEFINT A-Z
DECLARE FUNCTION Analisi4 (t)
DECLARE FUNCTION Analisi5 (t)
DECLARE FUNCTION AnalisiC ()
DECLARE FUNCTION AnalisiM (t)
DECLARE FUNCTION AnalisiValida (i, j, t)
DECLARE SUB Colora5 (t)
DECLARE SUB DisegnaCursore (i, j, t)
DECLARE SUB DisegnaFinestre ()
DECLARE SUB DisegnaPedina (i, j, t)
DECLARE SUB Editor (Edit$)
DECLARE SUB FineGioco (a$)
DECLARE SUB Messaggio (a$, s)
DECLARE SUB MostraControlli ()
DECLARE SUB MostraRecord ()
DECLARE SUB Pulizia ()
DECLARE SUB Punteggi ()
DECLARE SUB Resoconto ()
DECLARE SUB TestPC ()
DECLARE SUB TurnoComputer (Rig, Col)
DECLARE SUB TurnoGiocatore (Rig, Col)
DECLARE SUB PD ()
DECLARE SUB Z.Marco ()

    CLEAR , , 5000

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
        Demo   AS INTEGER
    END TYPE
   
    DIM SHARED InReg%(10), OutReg%(10)
    DIM SHARED GS AS GiocoStato
    DIM SHARED GG(30, 30), GV(30, 30)
    DIM SHARED p$(7)
    DIM SHARED pc386

    CONST Vero = -1
    CONST Falso = 0
    CONST Computer = 1
    CONST Giocatore = 4

    TestPC

    FOR i = 1 TO 19
      FOR j = 1 TO 19
        GG(i, j) = 2
      NEXT j
    NEXT i

    GS.Turno = Giocatore
    GS.CurRig = 10
    GS.CurCol = 10

    DisegnaFinestre

    DO
      IF GS.Turno = Giocatore THEN TurnoGiocatore Rig, Col
      IF GS.Turno = Computer THEN TurnoComputer Rig, Col
      IF GS.Turno = Falso THEN RUN
    LOOP

END

FUNCTION Analisi4 (t)
 
  Analisi4 = Falso  'mosse attacco e difesa da 4

  FOR i = 1 TO 19
    FOR j = 1 TO 19
     
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
 
  FOR i = 1 TO 19
    FOR j = 1 TO 19
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
      FOR Rig = 1 TO 19
        FOR Col = 1 TO 19
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

  FOR i = 1 TO 19
    FOR j = 1 TO 19
     
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
    FOR i = 1 TO 19
      FOR j = 1 TO 19
        IF GV(i, j) > Mig THEN
          Mig = GV(i, j)
          r = i: c = j
          REM COLOR 15: LOCATE 5 + i, 2 * j: PRINT GV(i, j): SLEEP ' per collaudo
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
 
  FOR x = 1 TO 19
    FOR y = 1 TO 19
      IF GG(x, y) = 2 THEN
        Continua = Vero
        EXIT FUNCTION
      END IF
    NEXT
  NEXT
   
  IF NOT Continua THEN GS.Turno = Falso: FineGioco "   PARI   "

END FUNCTION

SUB Colora5 (t)

  DisegnaCursore GS.CurRig, GS.CurCol, GG(GS.CurRig, GS.CurCol)

  FOR x = 285 TO 580 STEP 16
    FOR y = 85 TO 380 STEP 16
      k1 = 0: k2 = 0: k3 = 0: k4 = 0
      FOR p = 0 TO 64 STEP 16
        IF POINT(x + p, y) = t THEN k1 = k1 + 1
        IF POINT(x, y + p) = t THEN k2 = k2 + 1
        IF POINT(x + p, y + p) = t THEN k3 = k3 + 1
        IF POINT(16 + x - p, y + p) = t THEN k4 = k4 + 1
      NEXT
      FOR p = 0 TO 64 STEP 16
        IF k1 = 5 THEN PAINT (x + p, y), t + 8, 0
        IF k2 = 5 THEN PAINT (x, y + p), t + 8, 0
        IF k3 = 5 THEN PAINT (x + p, y + p), t + 8, 0
        IF k4 = 5 THEN PAINT (16 + x - p, y + p), t + 8, 0
      NEXT
    NEXT
  NEXT

END SUB

SUB DisegnaCursore (i, j, t)
 
  InReg%(1) = 2: CALL INT86OLD(&H33, InReg%(), OutReg%())
 
  PSET (j * 16 + 280 - 10, i * 16 + 80 - 10), t
  DRAW "BU4 D8 BH4 R8"

  InReg%(1) = 1: CALL INT86OLD(&H33, InReg%(), OutReg%())

END SUB

SUB DisegnaFinestre

  InReg%(1) = 0: CALL INT86OLD(&H33, InReg%(), OutReg%())

  SCREEN 12: CLS

  LINE (0, 0)-(639, 479), 15, B
  PAINT (1, 1), 8, 15

  LINE (249, 20)-(410, 50), 0, BF
  LINE (239, 10)-(400, 40), 15, B
  PAINT (240, 11), 7, 15
  COLOR 15: LOCATE 2, 34: PRINT " B L O C K  5 "

  LINE (49, 80)-(241, 230), 0, BF
  LINE (39, 70)-(231, 220), 15, B
  PAINT (40, 71), 3, 15
  MostraControlli

  LINE (49, 270)-(241, 400), 0, BF
  LINE (39, 260)-(231, 390), 15, B
  PAINT (40, 261), 3, 15

  LINE (279, 79)-(601, 401), 0, BF
  LINE (269, 69)-(591, 391), 7, B
  PAINT (270, 70), 2, 7
  LINE (270, 70)-(590, 390), 8, B
 
  FOR i = 0 TO 19
    LINE (278, 78 + i * 16)-(582, 78 + i * 16), 8
    LINE (278 + i * 16, 78)-(278 + i * 16, 382), 8
  NEXT i

  COLOR 15
  LOCATE 17, 11: PRINT "    STATO    "
  LOCATE 19, 7: PRINT " PEZZI GIOCATORE:"; GS.PezziG; " "
  LOCATE 21, 7: PRINT " PEZZI  COMPUTER:"; GS.PezziC; " "
  LOCATE 23, 7: PRINT " TURNO:              "

  InReg%(1) = 1: CALL INT86OLD(&H33, InReg%(), OutReg%())

END SUB

SUB DisegnaPedina (i, j, t)
    
  InReg%(1) = 2: CALL INT86OLD(&H33, InReg%(), OutReg%())
 
  SOUND 5000, .1
 
  CIRCLE (j * 16 + 280 - 10, i * 16 + 80 - 10), 6, 0
  PAINT (j * 16 + 280 - 9, i * 16 + 80 - 9), t, 0
 
  IF GS.Demo AND pc386 THEN SLEEP (pc386) ' Pausa sec. TestPC

  InReg%(1) = 1: CALL INT86OLD(&H33, InReg%(), OutReg%())

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
            LOCATE 23, 12: PRINT "BLOCK 5";
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
 
  IF NOT GS.Demo THEN
    IF a$ = " VINCI " THEN
      Punteggi
    ELSE
      MostraRecord
      COLOR 14: LOCATE 23, 7: PRINT " ????"; a$; "???? "
    END IF
  END IF

  Messaggio "  PREMI UN TASTO  ", 0

  DO
    a$ = INKEY$
    InReg%(1) = 3: CALL INT86OLD(&H33, InReg%(), OutReg%())
    Bot = OutReg%(2)
    IF Bot THEN s# = TIMER: WHILE TIMER - s# < .3: WEND: a = a + 1
    IF a$ <> "" THEN a = a + 1
    IF a = 1 THEN a = 2: Resoconto
    IF a > 2 THEN GS.Turno = Falso: EXIT DO
  LOOP

END SUB

DEFINT A-Z
SUB Messaggio (a$, s)
 
  InReg%(1) = 2: CALL INT86OLD(&H33, InReg%(), OutReg%())
  
  LINE (210, 436)-(449, 464), 0, BF
  LINE (199, 425)-(440, 455), 15, B
  LINE (200, 426)-(439, 454), 7, BF
 
  COLOR 15: LOCATE 28, 41 - LEN(a$) / 2: PRINT a$
  IF s THEN SLEEP (s): LINE (199, 425)-(449, 464), 8, BF

  InReg%(1) = 1: CALL INT86OLD(&H33, InReg%(), OutReg%())

END SUB

DEFSNG A-Z
SUB MostraControlli
 
  InReg%(1) = 2: CALL INT86OLD(&H33, InReg%(), OutReg%())
 
  LINE (47, 95)-(223, 205), 0, BF
  LINE (47, 95)-(223, 205), 15, B

  COLOR 15
  LOCATE 5, 10: PRINT "   CONTROLLI   "
  LOCATE 8, 7: PRINT " N = NUOVA PARTITA   "
  LOCATE 9, 7: PRINT " P = PASSA TURNO     "
  LOCATE 10, 7: PRINT " R = RECORD          "
  LOCATE 12, 7: PRINT " F = FINE            "

  InReg%(1) = 1: CALL INT86OLD(&H33, InReg%(), OutReg%())

END SUB

DEFINT A-Z
SUB MostraRecord

  InReg%(1) = 2: CALL INT86OLD(&H33, InReg%(), OutReg%())

  GS.Rec = Vero
  
  LINE (47, 95)-(223, 205), 0, BF
  LINE (47, 95)-(223, 205), 15, B
 
  COLOR 15
  LOCATE 5, 11: PRINT "    RECORD    "
  LOCATE 8
 
  OPEN "SCORES.B5" FOR APPEND AS #1: CLOSE
  OPEN "SCORES.B5" FOR INPUT AS #1
    WHILE NOT EOF(1)
      p = p + 1
      INPUT #1, p$
      p$(p) = p$
      LOCATE , 8: PRINT p$
    WEND
  CLOSE

  InReg%(1) = 1: CALL INT86OLD(&H33, InReg%(), OutReg%())

END SUB

SUB PD

  InReg%(1) = 0: CALL INT86OLD(&H33, InReg%(), OutReg%())

  COLOR 3
  LINE (48, 278)-(222, 375), 0, BF
  LOCATE 19, 9: PRINT "BLOCK 5  Ver. 1.00"
  LOCATE 21, 9: PRINT "  Freeware 1990   "
  LOCATE 22, 9: PRINT "    PD 1994 by    "
  LOCATE 23, 9: PRINT " Marco da Venezia "
  Messaggio " GAME OVER ", 3
  Pulizia
  END

END SUB

SUB Pulizia
 
  FOR i = 0 TO 320
    LINE (i, 3 / 4 * i)-(640 - i, 480 - 3 / 4 * i), 0, B
    IF pc386 THEN SOUND 0, pc386 / 33
  NEXT

END SUB

SUB Punteggi

  MostraRecord

  p# = 50 * (180 - ABS(45 - GS.PezziG)) - 10 * GS.Pena - GS.AttacC + GS.Pas
 
  IF p# <= VAL(p$(5)) THEN
    COLOR 10: LOCATE 23, 7: PRINT USING " VINCI PUNTI: ######"; p#
    EXIT SUB
  END IF
     
  Messaggio " VINCI PUNTI:" + STR$(p#) + " ", 0
 
  COLOR 10
  LOCATE 19, 7: PRINT "    NUOVO RECORD!    "
  LOCATE 21, 7: PRINT " SCRIVI IL TUO NOME: "
  LOCATE 23, 7: PRINT "     ..........      "
  LOCATE 23, 12
 
  Editor Edit$

  p$(6) = STR$(p#) + CHR$(255) + Edit$
 
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
 
  InReg%(1) = 2: CALL INT86OLD(&H33, InReg%(), OutReg%())
 
  LINE (299, 130)-(582, 351), 0, BF
  LINE (289, 120)-(571, 341), 15, B
  LINE (290, 121)-(570, 340), 7, BF
  LINE (305, 150)-(555, 320), 0, BF
  LINE (305, 150)-(555, 320), 15, B
          
  COLOR 11
  LOCATE 8, 46: PRINT "    RESOCONTO    "
  LOCATE 11, 50: PRINT "GIOCATORE  COMPUTER"
  LOCATE 13, 41: PRINT "PEZZI"; TAB(53); GS.PezziG; TAB(63); GS.PezziC
  LOCATE 15, 41: PRINT "ATTACCHI"; TAB(53); GS.AttacG; TAB(63); GS.AttacC
  LOCATE 17, 41: PRINT "STRATEGIE"; TAB(53); GS.StrG; TAB(63); GS.StrC
  LOCATE 19, 41: PRINT "ERRORI"; TAB(53); GS.Pena
 
  InReg%(1) = 1: CALL INT86OLD(&H33, InReg%(), OutReg%())

END SUB

SUB TestPC
    t! = TIMER
    WHILE TIMER - t! < 1
        n! = n! + 1
    WEND
    IF n! > 20480 THEN pc386 = 1 ' Per ritardo in Demo
END SUB

SUB TurnoComputer (Rig, Col)
   
  REM Z.Marco ' Scommentare per collaudo

  GS.Turno = Computer

  COLOR 9: LOCATE 23, 18: PRINT " COMPUTER"
    
  ERASE GV

  DO
    IF GS.PezziC THEN
      IF Analisi4(1) THEN EXIT DO
      IF Analisi4(4) THEN EXIT DO
      IF AnalisiM(1) THEN EXIT DO
      IF AnalisiM(4) THEN EXIT DO
      IF AnalisiC THEN EXIT DO
    ELSE
      IF AnalisiValida(10, 10, 1) THEN EXIT DO
      IF AnalisiC THEN EXIT DO
    END IF
  LOOP

  GS.PezziC = GS.PezziC + 1
  LOCATE 21, 24: COLOR 15: PRINT GS.PezziC
            
  IF Analisi5(1) THEN
    FineGioco " HAI PERSO "
  ELSE
    IF GS.Turno <> Falso THEN GS.Turno = Giocatore
  END IF

END SUB

SUB TurnoGiocatore (Rig, Col)

  REM Z.Marco ' Scommentare per collaudo

  IF GS.Turno = Falso THEN EXIT SUB

  GS.Turno = Giocatore

  LOCATE 23, 18: COLOR 12: PRINT "GIOCATORE"
   
  DisegnaCursore GS.CurRig, GS.CurCol, 0

  DO
   
    IF GS.Demo THEN EXIT DO
 
    a$ = INKEY$
  
    InReg%(1) = 3: CALL INT86OLD(&H33, InReg%(), OutReg%())
   
    Rig = (OutReg%(4) - 80 + 10) / 16
    Col = (OutReg%(3) - 280 + 10) / 16
    r = 1 + OutReg%(4) / 16
    c = 1 + OutReg%(3) / 8
    Bot = OutReg%(2)
   
    IF Bot THEN s# = TIMER: WHILE TIMER - s# < .3: WEND
    IF Bot = 2 THEN a$ = " ;"
    IF Bot = 1 THEN
      IF c > 6 AND c < 27 THEN
        IF r = 8 THEN a$ = "n"
        IF r = 9 THEN a$ = "p"
        IF r = 10 THEN a$ = "r"
        IF r = 12 THEN a$ = "f"
      END IF
      IF (Rig > 0 AND Rig < 20) AND (Col > 0 AND Col < 20) THEN
        DisegnaCursore GS.CurRig, GS.CurCol, GG(GS.CurRig, GS.CurCol)
        GS.CurRig = Rig
        GS.CurCol = Col
        a$ = CHR$(13)
      END IF
    END IF

    IF a$ <> "" THEN
   
      IF GS.Rec THEN GS.Rec = Falso: MostraControlli

      IF LCASE$(a$) = "n" OR a$ = CHR$(8) THEN GS.Turno = Falso: EXIT SUB
      IF LCASE$(a$) = "p" THEN
        IF GS.PezziC = 0 THEN
          GS.Pas = 1000
          GS.Turno = Computer
          Messaggio "   PASSA   ", 1
          EXIT SUB
        ELSE
          GS.Pena = GS.Pena + 1
          Messaggio "   NON PASSA   ", 1
        END IF
      END IF
      IF LCASE$(a$) = "r" THEN MostraRecord
      IF LCASE$(a$) = "f" OR a$ = CHR$(27) THEN PD
      IF a$ = "." THEN ' Cambia colore pedine
        IF GS.Pal THEN
          GS.Pal = Falso
          PALETTE
        ELSE
          GS.Pal = Vero
          PALETTE 1, 65536 * 16 + 256 * 16 + 16
          PALETTE 4, 65536 * 48 + 256 * 48 + 48
        END IF
      END IF
      IF a$ = CHR$(13) THEN
        DisegnaCursore GS.CurRig, GS.CurCol, 0
        IF AnalisiValida(GS.CurRig, GS.CurCol, 4) THEN
          EXIT DO
        ELSE
          GS.Pena = GS.Pena + 1
          Messaggio " MOSSA NON VALIDA ", 1
        END IF
      END IF
      IF a$ = " " THEN
        Messaggio "  D E M O  ", 0
        GS.Demo = Vero
        EXIT DO
      END IF
   
      Cursore = ASC(RIGHT$(a$, 1))

      SELECT CASE Cursore
        CASE 71 TO 81:
        DisegnaCursore GS.CurRig, GS.CurCol, GG(GS.CurRig, GS.CurCol)
        IF Cursore < 74 THEN
          IF GS.CurRig = 1 THEN
            GS.CurRig = 19
          ELSE
            GS.CurRig = GS.CurRig - 1
          END IF
        ELSEIF Cursore > 78 THEN
          IF GS.CurRig = 19 THEN
            GS.CurRig = 1
          ELSE
            GS.CurRig = GS.CurRig + 1
          END IF
        END IF
        IF Cursore = 71 OR Cursore = 75 OR Cursore = 79 THEN
          IF GS.CurCol = 1 THEN
            GS.CurCol = 19
          ELSE
            GS.CurCol = GS.CurCol - 1
          END IF
        ELSEIF Cursore = 73 OR Cursore = 77 OR Cursore = 81 THEN
          IF GS.CurCol = 19 THEN
            GS.CurCol = 1
          ELSE
            GS.CurCol = GS.CurCol + 1
          END IF
        END IF
        DisegnaCursore GS.CurRig, GS.CurCol, 0
      END SELECT
   
    END IF
 
  LOOP

  IF GS.Demo THEN
    DO
      IF INKEY$ = " " THEN GS.Turno = Falso: EXIT SUB
      IF Analisi4(1) THEN EXIT DO
      IF Analisi4(4) THEN EXIT DO
      IF AnalisiM(1) THEN EXIT DO
      IF AnalisiM(4) THEN EXIT DO
      IF AnalisiC THEN EXIT DO
    LOOP
  END IF

  GS.PezziG = GS.PezziG + 1
  LOCATE 19, 24: COLOR 15: PRINT GS.PezziG

  IF Analisi5(4) THEN
    FineGioco " VINCI "
  ELSE
    IF GS.Turno <> Falso THEN GS.Turno = Computer
  END IF

END SUB

SUB Z.Marco
  ' Griglietta per collaudo
  FOR i = 1 TO 19
    FOR j = 1 TO 19
      LOCATE i, j: COLOR GG(i, j): PRINT LTRIM$(STR$(GG(i, j)))
    NEXT j
  NEXT i
END SUB

