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
*> Tela inicial, menu, contagem da fase.
IDENTIFICATION DIVISION.
PROGRAM-ID. ui-draw.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "playstate.cpy".
COPY "mapstate.cpy".
01 lname PIC X(8).
01 lump-id BINARY-LONG.
01 patch PIC X(262144).
01 cap-n BINARY-LONG VALUE 262144.
01 nread BINARY-LONG.
01 ink-n BINARY-LONG.
01 pen-x BINARY-LONG.
01 pen-y BINARY-LONG.
01 num-v BINARY-LONG.
01 dig-n BINARY-LONG.
01 div-n BINARY-LONG.
01 row-y BINARY-LONG.
01 dot-n BINARY-LONG.
01 wide-n BINARY-LONG.
01 ep-n BINARY-LONG.
01 mp-n BINARY-LONG.
01 par-n BINARY-LONG.
01 glyph PIC X(8).

LINKAGE SECTION.
01 fb PIC X(64000).
01 mode-n BINARY-LONG.
01 pick-n BINARY-LONG.
01 skull-n BINARY-LONG.
01 show-k BINARY-LONG.
01 show-i BINARY-LONG.
01 show-s BINARY-LONG.
01 show-t BINARY-LONG.

PROCEDURE DIVISION USING fb mode-n pick-n skull-n
    show-k show-i show-s show-t.
    IF mode-n = 4
        PERFORM draw-tally
    ELSE
        PERFORM draw-title
        IF mode-n = 1
            PERFORM draw-menu
        END-IF
        IF mode-n = 2
            PERFORM draw-options
        END-IF
    END-IF
    GOBACK.

draw-title.
    MOVE ALL X"00" TO fb
    MOVE "TITLEPIC" TO lname
    MOVE 0 TO pen-x
    MOVE 0 TO pen-y
    PERFORM draw-named
    .

draw-menu.
    MOVE "M_DOOM" TO lname
    MOVE 94 TO pen-x
    MOVE 2 TO pen-y
    PERFORM draw-named
    MOVE "M_NGAME" TO lname
    MOVE 97 TO pen-x
    MOVE 64 TO pen-y
    PERFORM draw-named
    MOVE "M_OPTION" TO lname
    MOVE 80 TO pen-y
    PERFORM draw-named
    MOVE "M_QUITG" TO lname
    MOVE 96 TO pen-y
    PERFORM draw-named
    IF skull-n = 0
        MOVE "M_SKULL1" TO lname
    ELSE
        MOVE "M_SKULL2" TO lname
    END-IF
    MOVE 65 TO pen-x
    COMPUTE pen-y = 59 + pick-n * 16
    PERFORM draw-named
    .

draw-options.
    MOVE "M_OPTTTL" TO lname
    MOVE 108 TO pen-x
    MOVE 15 TO pen-y
    PERFORM draw-named
    MOVE "M_ENDGAM" TO lname
    MOVE 60 TO pen-x
    MOVE 37 TO pen-y
    PERFORM draw-named
    MOVE "M_SCRNSZ" TO lname
    MOVE 69 TO pen-y
    PERFORM draw-named
    MOVE 9 TO wide-n
    COMPUTE dot-n = ply-blocks - 3
    MOVE 60 TO pen-x
    MOVE 85 TO pen-y
    PERFORM draw-thermo
    MOVE 60 TO pen-x
    MOVE 117 TO pen-y
    PERFORM draw-resol
    MOVE 4 TO wide-n
    COMPUTE dot-n = ply-scale - 1
    MOVE 60 TO pen-x
    MOVE 133 TO pen-y
    PERFORM draw-thermo
    IF skull-n = 0
        MOVE "M_SKULL1" TO lname
    ELSE
        MOVE "M_SKULL2" TO lname
    END-IF
    MOVE 28 TO pen-x
    IF pick-n = 0
        MOVE 32 TO pen-y
    END-IF
    IF pick-n = 1
        MOVE 64 TO pen-y
    END-IF
    IF pick-n = 2
        MOVE 112 TO pen-y
    END-IF
    PERFORM draw-named
    .

draw-resol.
    MOVE "STCFN082" TO lname
    PERFORM draw-named
    ADD 8 TO pen-x
    MOVE "STCFN069" TO lname
    PERFORM draw-named
    ADD 8 TO pen-x
    MOVE "STCFN083" TO lname
    PERFORM draw-named
    ADD 8 TO pen-x
    MOVE "STCFN079" TO lname
    PERFORM draw-named
    ADD 8 TO pen-x
    MOVE "STCFN076" TO lname
    PERFORM draw-named
    ADD 8 TO pen-x
    MOVE "STCFN085" TO lname
    PERFORM draw-named
    ADD 8 TO pen-x
    MOVE "STCFN067" TO lname
    PERFORM draw-named
    ADD 8 TO pen-x
    MOVE "STCFN065" TO lname
    PERFORM draw-named
    ADD 8 TO pen-x
    MOVE "STCFN079" TO lname
    PERFORM draw-named
    .

draw-thermo.
    MOVE pen-x TO row-y
    MOVE "M_THERML" TO lname
    PERFORM draw-named
    ADD 8 TO pen-x
    PERFORM wide-n TIMES
        MOVE "M_THERMM" TO lname
        PERFORM draw-named
        ADD 8 TO pen-x
    END-PERFORM
    MOVE "M_THERMR" TO lname
    PERFORM draw-named
    IF dot-n < 0
        MOVE 0 TO dot-n
    END-IF
    COMPUTE dig-n = wide-n - 1
    IF dot-n > dig-n
        MOVE dig-n TO dot-n
    END-IF
    COMPUTE pen-x = row-y + 8 + dot-n * 8
    MOVE "M_THERMO" TO lname
    PERFORM draw-named
    .

draw-tally.
    MOVE ALL X"00" TO fb
    MOVE "INTERPIC" TO lname
    CALL "wad-find" USING lname lump-id
    IF lump-id < 0
        MOVE "WIMAP0" TO lname
    END-IF
    MOVE 0 TO pen-x
    MOVE 0 TO pen-y
    PERFORM draw-named
    PERFORM level-lump
    MOVE 104 TO pen-x
    MOVE 2 TO pen-y
    PERFORM draw-named
    MOVE "WIF" TO lname
    MOVE 108 TO pen-x
    MOVE 24 TO pen-y
    PERFORM draw-named
    MOVE "WIOSTK" TO lname
    MOVE 50 TO pen-x
    MOVE 50 TO pen-y
    PERFORM draw-named
    MOVE show-k TO num-v
    MOVE 250 TO pen-x
    MOVE 50 TO pen-y
    PERFORM draw-pct
    MOVE "WIOSTI" TO lname
    MOVE 50 TO pen-x
    MOVE 74 TO pen-y
    PERFORM draw-named
    MOVE show-i TO num-v
    MOVE 250 TO pen-x
    MOVE 74 TO pen-y
    PERFORM draw-pct
    MOVE "WIOSTS" TO lname
    MOVE 50 TO pen-x
    MOVE 98 TO pen-y
    PERFORM draw-named
    MOVE show-s TO num-v
    MOVE 250 TO pen-x
    MOVE 98 TO pen-y
    PERFORM draw-pct
    MOVE "WITIME" TO lname
    MOVE 16 TO pen-x
    MOVE 168 TO pen-y
    PERFORM draw-named
    MOVE show-t TO num-v
    MOVE 144 TO pen-x
    MOVE 168 TO pen-y
    PERFORM draw-clock
    MOVE "WIPAR" TO lname
    MOVE 176 TO pen-x
    MOVE 168 TO pen-y
    PERFORM draw-named
    PERFORM par-time
    MOVE par-n TO num-v
    MOVE 304 TO pen-x
    MOVE 168 TO pen-y
    PERFORM draw-clock
    .

level-lump.
    MOVE 0 TO ep-n
    MOVE 1 TO mp-n
    IF map-name(1:3) = "MAP"
        IF map-name(4:1) = "1"
            MOVE 10 TO mp-n
        END-IF
        IF map-name(4:1) = "2"
            MOVE 20 TO mp-n
        END-IF
        IF map-name(4:1) = "3"
            MOVE 30 TO mp-n
        END-IF
        EVALUATE map-name(5:1)
            WHEN "1" ADD 1 TO mp-n
            WHEN "2" ADD 2 TO mp-n
            WHEN "3" ADD 3 TO mp-n
            WHEN "4" ADD 4 TO mp-n
            WHEN "5" ADD 5 TO mp-n
            WHEN "6" ADD 6 TO mp-n
            WHEN "7" ADD 7 TO mp-n
            WHEN "8" ADD 8 TO mp-n
            WHEN "9" ADD 9 TO mp-n
        END-EVALUATE
        SUBTRACT 1 FROM mp-n
        MOVE "CWILV00" TO lname
    ELSE
        IF map-name(2:1) = "2"
            MOVE 1 TO ep-n
        END-IF
        IF map-name(2:1) = "3"
            MOVE 2 TO ep-n
        END-IF
        IF map-name(2:1) = "4"
            MOVE 3 TO ep-n
        END-IF
        EVALUATE map-name(4:1)
            WHEN "1" MOVE 0 TO mp-n
            WHEN "2" MOVE 1 TO mp-n
            WHEN "3" MOVE 2 TO mp-n
            WHEN "4" MOVE 3 TO mp-n
            WHEN "5" MOVE 4 TO mp-n
            WHEN "6" MOVE 5 TO mp-n
            WHEN "7" MOVE 6 TO mp-n
            WHEN "8" MOVE 7 TO mp-n
            WHEN "9" MOVE 8 TO mp-n
            WHEN OTHER MOVE 0 TO mp-n
        END-EVALUATE
        COMPUTE dig-n = ep-n * 10 + mp-n
        MOVE "WILV00" TO lname
        MOVE dig-n TO mp-n
    END-IF
    DIVIDE mp-n BY 10 GIVING ep-n REMAINDER dig-n
    EVALUATE ep-n
        WHEN 1 MOVE "1" TO lname(6:1)
        WHEN 2 MOVE "2" TO lname(6:1)
        WHEN 3 MOVE "3" TO lname(6:1)
        WHEN OTHER MOVE "0" TO lname(6:1)
    END-EVALUATE
    EVALUATE dig-n
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
    .

par-time.
    MOVE 30 TO par-n
    IF map-name(1:1) = "E"
        EVALUATE map-name(4:1)
            WHEN "1" MOVE 30 TO par-n
            WHEN "2" MOVE 75 TO par-n
            WHEN "3" MOVE 120 TO par-n
            WHEN "4" MOVE 90 TO par-n
            WHEN "5" MOVE 165 TO par-n
            WHEN "6" MOVE 180 TO par-n
            WHEN "7" MOVE 180 TO par-n
            WHEN "8" MOVE 30 TO par-n
            WHEN "9" MOVE 165 TO par-n
        END-EVALUATE
    END-IF
    .

draw-pct.
    MOVE "WIPCNT" TO lname
    PERFORM draw-named
    SUBTRACT 4 FROM pen-x
    PERFORM draw-num
    .

draw-clock.
    DIVIDE num-v BY 60 GIVING ep-n REMAINDER dig-n
    IF dig-n < 10
        PERFORM stamp-dig
        SUBTRACT 12 FROM pen-x
        MOVE 0 TO dig-n
        PERFORM stamp-dig
        SUBTRACT 12 FROM pen-x
    ELSE
        MOVE dig-n TO num-v
        PERFORM draw-num
    END-IF
    SUBTRACT 4 FROM pen-x
    MOVE "WICOLON" TO lname
    PERFORM draw-named
    SUBTRACT 8 FROM pen-x
    MOVE ep-n TO num-v
    PERFORM draw-num
    .

draw-num.
    IF num-v < 0
        MOVE 0 TO num-v
    END-IF
    PERFORM UNTIL num-v < 10
        DIVIDE num-v BY 10 GIVING div-n REMAINDER dig-n
        MOVE div-n TO num-v
        PERFORM stamp-dig
        SUBTRACT 12 FROM pen-x
    END-PERFORM
    MOVE num-v TO dig-n
    PERFORM stamp-dig
    SUBTRACT 12 FROM pen-x
    .

stamp-dig.
    MOVE "WINUM0" TO lname
    EVALUATE dig-n
        WHEN 1 MOVE "1" TO lname(6:1)
        WHEN 2 MOVE "2" TO lname(6:1)
        WHEN 3 MOVE "3" TO lname(6:1)
        WHEN 4 MOVE "4" TO lname(6:1)
        WHEN 5 MOVE "5" TO lname(6:1)
        WHEN 6 MOVE "6" TO lname(6:1)
        WHEN 7 MOVE "7" TO lname(6:1)
        WHEN 8 MOVE "8" TO lname(6:1)
        WHEN 9 MOVE "9" TO lname(6:1)
        WHEN OTHER MOVE "0" TO lname(6:1)
    END-EVALUATE
    PERFORM draw-named
    .

draw-named.
    CALL "wad-find" USING lname lump-id
    IF lump-id < 0
        EXIT PARAGRAPH
    END-IF
    CALL "wad-read-num" USING lump-id patch cap-n nread
    IF nread < 8
        EXIT PARAGRAPH
    END-IF
    CALL "v-draw-patch" USING fb patch nread ink-n pen-x pen-y
    .

END PROGRAM ui-draw.

IDENTIFICATION DIVISION.
PROGRAM-ID. ui-wipe.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 fb-old PIC X(64000).
01 fb-new PIC X(64000).
01 wy BINARY-LONG OCCURS 160 TIMES.
01 rnd-n BINARY-LONG VALUE 1.
01 col-i BINARY-LONG.
01 x0 BINARY-LONG.
01 yi BINARY-LONG.
01 dy-n BINARY-LONG.
01 row-i BINARY-LONG.
01 src-y BINARY-LONG.
01 at-a BINARY-LONG.
01 at-b BINARY-LONG.
01 pix-n BINARY-LONG.
01 prev-y BINARY-LONG.
01 wob-n BINARY-LONG.
01 still-n BINARY-LONG.
01 reveal-n BINARY-LONG.

LINKAGE SECTION.
01 fb PIC X(64000).
01 cmd-n BINARY-LONG.
01 done-out BINARY-LONG.

PROCEDURE DIVISION USING fb cmd-n done-out.
    MOVE 0 TO done-out
    IF cmd-n = 1
        MOVE fb TO fb-old
        GOBACK
    END-IF
    IF cmd-n = 2
        MOVE fb TO fb-new
        MOVE fb-old TO fb
        PERFORM init-cols
        GOBACK
    END-IF
    PERFORM melt-once
    IF still-n = 0
        MOVE fb-new TO fb
        MOVE 1 TO done-out
    END-IF
    GOBACK.

init-cols.
    MOVE 1 TO rnd-n
    PERFORM VARYING col-i FROM 1 BY 1 UNTIL col-i > 160
        COMPUTE rnd-n = FUNCTION MOD(rnd-n * 75 + 74, 65536)
        IF col-i = 1
            COMPUTE wy(col-i) = - FUNCTION MOD(rnd-n, 16)
        ELSE
            COMPUTE prev-y = col-i - 1
            COMPUTE wob-n = FUNCTION MOD(rnd-n, 3) - 1
            COMPUTE wy(col-i) = wy(prev-y) + wob-n
            IF wy(col-i) > 0
                MOVE 0 TO wy(col-i)
            END-IF
            IF wy(col-i) < -15
                MOVE -15 TO wy(col-i)
            END-IF
        END-IF
    END-PERFORM
    .

melt-once.
    MOVE 0 TO still-n
    PERFORM VARYING col-i FROM 1 BY 1 UNTIL col-i > 160
        COMPUTE x0 = (col-i - 1) * 2
        MOVE wy(col-i) TO yi
        IF yi < 0
            ADD 1 TO wy(col-i)
            MOVE 0 TO reveal-n
            MOVE 1 TO still-n
        ELSE
            IF yi < 200
                IF yi < 16
                    COMPUTE dy-n = yi + 1
                ELSE
                    MOVE 8 TO dy-n
                END-IF
                IF yi + dy-n > 200
                    COMPUTE dy-n = 200 - yi
                END-IF
                ADD dy-n TO yi
                MOVE yi TO wy(col-i)
                MOVE yi TO reveal-n
                MOVE 1 TO still-n
            ELSE
                MOVE 200 TO reveal-n
            END-IF
        END-IF
        PERFORM paint-col
    END-PERFORM
    .

paint-col.
    PERFORM VARYING row-i FROM 0 BY 1 UNTIL row-i >= 200
        COMPUTE at-b = row-i * 320 + x0
        IF row-i < reveal-n
            MOVE row-i TO src-y
            PERFORM copy-new
        ELSE
            COMPUTE src-y = row-i - reveal-n
            PERFORM copy-old
        END-IF
    END-PERFORM
    .

copy-new.
    COMPUTE at-a = src-y * 320 + x0
    CALL "byte_at" USING BY REFERENCE fb-new BY VALUE at-a
        RETURNING pix-n
    CALL "poke_byte" USING BY REFERENCE fb BY VALUE at-b
        BY VALUE pix-n
    ADD 1 TO at-a
    ADD 1 TO at-b
    CALL "byte_at" USING BY REFERENCE fb-new BY VALUE at-a
        RETURNING pix-n
    CALL "poke_byte" USING BY REFERENCE fb BY VALUE at-b
        BY VALUE pix-n
    .

copy-old.
    COMPUTE at-a = src-y * 320 + x0
    CALL "byte_at" USING BY REFERENCE fb-old BY VALUE at-a
        RETURNING pix-n
    CALL "poke_byte" USING BY REFERENCE fb BY VALUE at-b
        BY VALUE pix-n
    ADD 1 TO at-a
    ADD 1 TO at-b
    CALL "byte_at" USING BY REFERENCE fb-old BY VALUE at-a
        RETURNING pix-n
    CALL "poke_byte" USING BY REFERENCE fb BY VALUE at-b
        BY VALUE pix-n
    .

END PROGRAM ui-wipe.
