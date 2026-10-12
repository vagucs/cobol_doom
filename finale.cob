>>SOURCE FORMAT FREE
*> DOOM generic portado do python_doom para COBOL com SDL2.
*>
*> Por Wagner Nunes da Silva
*>
*> vagucs@bol.com.br
*> vagucs@vagucs.com.br
*> vagucs@gmail.com
*>
*> www.vagucs.com.br
*>
*> Texto final do episodio. O piso e a letra ficam aqui. Sem rato.
IDENTIFICATION DIVISION.
PROGRAM-ID. fin-act.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 fin-stage BINARY-LONG VALUE 0.
01 fin-count BINARY-LONG VALUE 0.
01 fin-len BINARY-LONG VALUE 0.
01 fin-at BINARY-LONG VALUE 1.
01 fin-ep BINARY-LONG VALUE 1.
01 fin-x BINARY-LONG VALUE 10.
01 fin-y BINARY-LONG VALUE 10.
01 show-n BINARY-LONG.
01 scan-i BINARY-LONG.
01 ch-c PIC X.
01 code-n BINARY-LONG.
01 alpha PIC X(26) VALUE "ABCDEFGHIJKLMNOPQRSTUVWXYZ".
01 lname PIC X(8).
01 lump-id BINARY-LONG.
01 flat-buf PIC X(4096).
01 art-buf PIC X(262144).
01 cap-flat BINARY-LONG VALUE 4096.
01 cap-art BINARY-LONG VALUE 262144.
01 nread BINARY-LONG.
01 ink-n BINARY-LONG.
01 row-y BINARY-LONG.
01 col-x BINARY-LONG.
01 src-at BINARY-LONG.
01 dst-at BINARY-LONG.
01 glyph-w BINARY-LONG.
01 patch PIC X(8192).
01 cap-glyph BINARY-LONG VALUE 8192.
01 tens-n BINARY-LONG.
01 ones-n BINARY-LONG.
01 snd-name PIC X(6).
01 mus-loop BINARY-LONG.
01 txt PIC X(800).
01 e1-txt PIC X(500) VALUE
    "ONCE YOU BEAT THE BIG BADASSES AND|" &
    "CLEAN OUT THE MOON BASE YOU'RE SUPPOSED|" &
    "TO WIN, AREN'T YOU? AREN'T YOU? WHERE'S|" &
    "YOUR FAT REWARD AND TICKET HOME? WHAT|" &
    "THE HELL IS THIS? IT'S NOT SUPPOSED TO|" &
    "END THIS WAY!||" &
    "IT STINKS LIKE ROTTEN MEAT, BUT LOOKS|" &
    "LIKE THE LOST DEIMOS BASE.  LOOKS LIKE|" &
    "YOU'RE STUCK ON THE SHORES OF HELL.|" &
    "THE ONLY WAY OUT IS THROUGH.||" &
    "TO CONTINUE THE DOOM EXPERIENCE, PLAY|" &
    "THE SHORES OF HELL AND ITS AMAZING|" &
    "SEQUEL, INFERNO!|~".
01 e2-txt PIC X(500) VALUE
    "YOU'VE DONE IT! THE HIDEOUS CYBER-|" &
    "DEMON LORD THAT RULED THE LOST DEIMOS|" &
    "MOON BASE HAS BEEN SLAIN AND YOU|" &
    "ARE TRIUMPHANT! BUT ... WHERE ARE|" &
    "YOU? YOU CLAMBER TO THE EDGE OF THE|" &
    "MOON AND LOOK DOWN TO SEE THE AWFUL|" &
    "TRUTH.||" &
    "DEIMOS FLOATS ABOVE HELL ITSELF!|" &
    "YOU'VE NEVER HEARD OF ANYONE ESCAPING|" &
    "FROM HELL, BUT YOU'LL MAKE THE BASTARDS|" &
    "SORRY THEY EVER HEARD OF YOU! QUICKLY,|" &
    "YOU RAPPEL DOWN TO THE SURFACE OF|" &
    "HELL.||" &
    "NOW, IT'S ON TO THE FINAL CHAPTER OF|" &
    "DOOM! -- INFERNO.|~".
01 e3-txt PIC X(600) VALUE
    "THE LOATHSOME SPIDERDEMON THAT|" &
    "MASTERMINDED THE INVASION OF THE MOON|" &
    "BASES AND CAUSED SO MUCH DEATH HAS HAD|" &
    "ITS ASS KICKED FOR ALL TIME.||" &
    "A HIDDEN DOORWAY OPENS AND YOU ENTER.|" &
    "YOU'VE PROVEN TOO TOUGH FOR HELL TO|" &
    "CONTAIN, AND NOW HELL AT LAST PLAYS|" &
    "FAIR -- FOR YOU EMERGE FROM THE DOOR|" &
    "TO SEE THE GREEN FIELDS OF EARTH!|" &
    "HOME AT LAST.||" &
    "YOU WONDER WHAT'S BEEN HAPPENING ON|" &
    "EARTH WHILE YOU WERE BATTLING EVIL|" &
    "UNLEASHED. IT'S GOOD THAT NO HELL-|" &
    "SPAWN COULD HAVE COME THROUGH THAT|" &
    "DOOR WITH YOU ...|~".
01 e4-txt PIC X(700) VALUE
    "THE SPIDER MASTERMIND MUST HAVE SENT FORTH|" &
    "ITS LEGIONS OF HELLSPAWN BEFORE YOUR|" &
    "FINAL CONFRONTATION WITH THAT TERRIBLE|" &
    "BEAST FROM HELL. BUT YOU STEPPED FORWARD|" &
    "AND BROUGHT FORTH ETERNAL DAMNATION AND|" &
    "SUFFERING UPON THE HORDE AS A TRUE HERO|" &
    "WOULD IN THE FACE OF SOMETHING SO EVIL.||" &
    "BESIDES, SOMEONE WAS GONNA PAY FOR WHAT|" &
    "HAPPENED TO DAISY, YOUR PET RABBIT.||" &
    "BUT NOW, YOU SEE SPREAD BEFORE YOU MORE|" &
    "POTENTIAL PAIN AND GIBBITUDE AS A NATION|" &
    "OF DEMONS RUN AMOK AMONG OUR CITIES.||" &
    "NEXT STOP, HELL ON EARTH!|~".

LINKAGE SECTION.
01 fb PIC X(64000).
01 cmd BINARY-LONG.
01 map-name PIC X(8).
01 stage-out BINARY-LONG.

PROCEDURE DIVISION USING fb cmd map-name stage-out.
    IF cmd = 1
        PERFORM boot-fin
    ELSE
        IF cmd = 3
            PERFORM key-fin
        ELSE
            PERFORM tick-fin
        END-IF
    END-IF
    MOVE fin-stage TO stage-out
    GOBACK.

boot-fin.
    MOVE 0 TO fin-stage
    MOVE 0 TO fin-count
    MOVE 1 TO fin-at
    MOVE 10 TO fin-x
    MOVE 10 TO fin-y
    MOVE 1 TO fin-ep
    IF map-name(2:1) = "2"
        MOVE 2 TO fin-ep
    END-IF
    IF map-name(2:1) = "3"
        MOVE 3 TO fin-ep
    END-IF
    IF map-name(2:1) = "4"
        MOVE 4 TO fin-ep
    END-IF
    IF fin-ep = 2
        MOVE e2-txt TO txt
    ELSE
        IF fin-ep = 3
            MOVE e3-txt TO txt
        ELSE
            IF fin-ep = 4
                MOVE e4-txt TO txt
            ELSE
                MOVE e1-txt TO txt
            END-IF
        END-IF
    END-IF
    MOVE 0 TO fin-len
    PERFORM VARYING scan-i FROM 1 BY 1 UNTIL scan-i > 800
        IF txt(scan-i:1) = "~"
            SUBTRACT 1 FROM scan-i GIVING fin-len
            EXIT PERFORM
        END-IF
    END-PERFORM
    PERFORM paint-flat
    .

paint-flat.
    IF fin-ep = 2
        MOVE "SFLR6_1" TO lname
    ELSE
        IF fin-ep = 3
            MOVE "MFLR8_4" TO lname
        ELSE
            IF fin-ep = 4
                MOVE "MFLR8_3" TO lname
            ELSE
                MOVE "FLOOR4_8" TO lname
            END-IF
        END-IF
    END-IF
    MOVE ALL X"00" TO flat-buf
    CALL "wad-find" USING lname lump-id
    IF lump-id >= 0
        CALL "wad-read-num" USING lump-id flat-buf cap-flat nread
    END-IF
    PERFORM VARYING row-y FROM 0 BY 1 UNTIL row-y >= 200
        COMPUTE src-at = FUNCTION MOD(row-y, 64) * 64 + 1
        PERFORM VARYING col-x FROM 0 BY 64 UNTIL col-x >= 320
            COMPUTE dst-at = row-y * 320 + col-x + 1
            CALL "mem_copy" USING fb(dst-at:64) flat-buf(src-at:64)
                BY VALUE 64
        END-PERFORM
    END-PERFORM
    .

tick-fin.
    IF fin-stage NOT = 0
        ADD 1 TO fin-count
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO fin-count
    DIVIDE fin-count BY 3 GIVING show-n
    PERFORM UNTIL fin-at > fin-len OR fin-at > show-n
        PERFORM one-ch
        ADD 1 TO fin-at
    END-PERFORM
    COMPUTE scan-i = fin-len * 3 + 250
    IF fin-count > scan-i
        PERFORM show-art
    END-IF
    .

key-fin.
    IF fin-stage = 0
        PERFORM show-art
        EXIT PARAGRAPH
    END-IF
    IF fin-stage = 1 AND fin-count > 10
        MOVE 9 TO fin-stage
    END-IF
    .

one-ch.
    MOVE txt(fin-at:1) TO ch-c
    IF ch-c = "|"
        MOVE 10 TO fin-x
        ADD 11 TO fin-y
        EXIT PARAGRAPH
    END-IF
    IF ch-c = " "
        ADD 4 TO fin-x
        EXIT PARAGRAPH
    END-IF
    PERFORM code-of
    IF code-n = 0
        ADD 4 TO fin-x
        EXIT PARAGRAPH
    END-IF
    PERFORM load-glyph
    IF nread < 8
        ADD 4 TO fin-x
        EXIT PARAGRAPH
    END-IF
    ADD fin-x TO glyph-w GIVING col-x
    IF col-x > 320 OR fin-y > 190
        ADD glyph-w TO fin-x
        EXIT PARAGRAPH
    END-IF
    CALL "v-draw-patch" USING fb patch nread ink-n fin-x fin-y
    ADD glyph-w TO fin-x
    .

code-of.
    MOVE 0 TO code-n
    PERFORM VARYING scan-i FROM 1 BY 1 UNTIL scan-i > 26
        IF ch-c = alpha(scan-i:1)
            ADD 64 TO scan-i GIVING code-n
            EXIT PERFORM
        END-IF
    END-PERFORM
    IF ch-c = "!"
        MOVE 33 TO code-n
    END-IF
    IF ch-c = "'"
        MOVE 39 TO code-n
    END-IF
    IF ch-c = ","
        MOVE 44 TO code-n
    END-IF
    IF ch-c = "-"
        MOVE 45 TO code-n
    END-IF
    IF ch-c = "."
        MOVE 46 TO code-n
    END-IF
    IF ch-c = "?"
        MOVE 63 TO code-n
    END-IF
    .

load-glyph.
    MOVE 0 TO nread
    MOVE "STCFN000" TO lname
    DIVIDE code-n BY 100 GIVING tens-n REMAINDER ones-n
    IF tens-n = 1
        MOVE "1" TO lname(6:1)
    END-IF
    DIVIDE ones-n BY 10 GIVING tens-n REMAINDER ones-n
    EVALUATE tens-n
        WHEN 1 MOVE "1" TO lname(7:1)
        WHEN 2 MOVE "2" TO lname(7:1)
        WHEN 3 MOVE "3" TO lname(7:1)
        WHEN 4 MOVE "4" TO lname(7:1)
        WHEN 5 MOVE "5" TO lname(7:1)
        WHEN 6 MOVE "6" TO lname(7:1)
        WHEN 7 MOVE "7" TO lname(7:1)
        WHEN 8 MOVE "8" TO lname(7:1)
        WHEN 9 MOVE "9" TO lname(7:1)
        WHEN OTHER MOVE "0" TO lname(7:1)
    END-EVALUATE
    EVALUATE ones-n
        WHEN 1 MOVE "1" TO lname(8:1)
        WHEN 2 MOVE "2" TO lname(8:1)
        WHEN 3 MOVE "3" TO lname(8:1)
        WHEN 4 MOVE "4" TO lname(8:1)
        WHEN 5 MOVE "5" TO lname(8:1)
        WHEN 6 MOVE "6" TO lname(8:1)
        WHEN 7 MOVE "7" TO lname(8:1)
        WHEN 8 MOVE "8" TO lname(8:1)
        WHEN 9 MOVE "9" TO lname(8:1)
        WHEN OTHER MOVE "0" TO lname(8:1)
    END-EVALUATE
    CALL "wad-find" USING lname lump-id
    IF lump-id < 0
        EXIT PARAGRAPH
    END-IF
    CALL "wad-read-num" USING lump-id patch cap-glyph nread
    IF nread < 8
        EXIT PARAGRAPH
    END-IF
    CALL "i16_le" USING BY REFERENCE patch BY VALUE 0 RETURNING glyph-w
    IF glyph-w < 1
        MOVE 4 TO glyph-w
    END-IF
    .

show-art.
    MOVE 1 TO fin-stage
    MOVE 0 TO fin-count
    MOVE ALL X"00" TO fb
    IF fin-ep = 2
        MOVE "VICTORY2" TO lname
    ELSE
        IF fin-ep = 4
            MOVE "ENDPIC" TO lname
        ELSE
            IF fin-ep = 3
                MOVE "PFUB2" TO lname
            ELSE
                MOVE "HELP2" TO lname
            END-IF
        END-IF
    END-IF
    CALL "wad-find" USING lname lump-id
    IF lump-id < 0
        MOVE "HELP2" TO lname
        CALL "wad-find" USING lname lump-id
    END-IF
    IF lump-id < 0
        MOVE "HELP1" TO lname
        CALL "wad-find" USING lname lump-id
    END-IF
    IF lump-id >= 0
        CALL "wad-read-num" USING lump-id art-buf cap-art nread
        IF nread >= 8
            MOVE 0 TO fin-x
            MOVE 0 TO fin-y
            CALL "v-draw-patch" USING fb art-buf nread ink-n fin-x fin-y
        END-IF
    END-IF
    IF fin-ep = 3
        MOVE "bunny" TO snd-name
        MOVE 1 TO mus-loop
        CALL "mus-play" USING snd-name mus-loop
    END-IF
    .

END PROGRAM fin-act.
