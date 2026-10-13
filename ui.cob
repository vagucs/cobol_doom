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
01 pw-n BINARY-LONG.
01 ph-n BINARY-LONG.
01 ox-n BINARY-LONG.
01 oy-n BINARY-LONG.
01 fit-n BINARY-LONG.
01 node-i BINARY-LONG.
01 last-n BINARY-LONG.
01 next-n BINARY-LONG.
01 at-n BINARY-LONG.
01 left-n BINARY-LONG.
01 bot-n BINARY-LONG.
01 dig-c PIC X.
01 slot-i BINARY-LONG.
01 peek-cmd BINARY-LONG VALUE 3.
01 peek-rc BINARY-LONG.
01 dummy-map PIC X(8).
01 desc-txt PIC X(24).
01 txt-n BINARY-LONG.
01 ch-i BINARY-LONG.
01 ch-c PIC X.
01 code-n BINARY-LONG.
01 code-pic PIC 999.
01 hold-x BINARY-LONG.
01 border-i BINARY-LONG.
01 xs PIC X(81) VALUE
    "185148069209116166071135071254097188128214133208148235156048174265130279198140281".
01 ys PIC X(81) VALUE
    "164143122102089055056029024025050064078092130136140158168154095075048023048025136".

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
        IF mode-n = 7
            PERFORM draw-episode
        END-IF
        IF mode-n = 8
            PERFORM draw-skill
        END-IF
        IF mode-n = 9
            PERFORM draw-load
        END-IF
        IF mode-n = 10
            PERFORM draw-save
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
    MOVE "M_LOADG" TO lname
    MOVE 96 TO pen-y
    PERFORM draw-named
    MOVE "M_SAVEG" TO lname
    MOVE 112 TO pen-y
    PERFORM draw-named
    MOVE "M_QUITG" TO lname
    MOVE 128 TO pen-y
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

draw-episode.
    MOVE "M_EPISOD" TO lname
    MOVE 54 TO pen-x
    MOVE 38 TO pen-y
    PERFORM draw-named
    MOVE "M_EPI1" TO lname
    MOVE 48 TO pen-x
    MOVE 63 TO pen-y
    PERFORM draw-named
    MOVE "M_EPI2" TO lname
    MOVE 79 TO pen-y
    PERFORM draw-named
    MOVE "M_EPI3" TO lname
    MOVE 95 TO pen-y
    PERFORM draw-named
    MOVE "M_EPI4" TO lname
    MOVE 111 TO pen-y
    PERFORM draw-named
    PERFORM menu-skull
    MOVE 20 TO pen-x
    COMPUTE pen-y = 58 + pick-n * 16
    PERFORM draw-named
    .

draw-skill.
    MOVE "M_NEWG" TO lname
    MOVE 96 TO pen-x
    MOVE 14 TO pen-y
    PERFORM draw-named
    MOVE "M_SKILL" TO lname
    MOVE 54 TO pen-x
    MOVE 38 TO pen-y
    PERFORM draw-named
    MOVE "M_JKILL" TO lname
    MOVE 48 TO pen-x
    MOVE 63 TO pen-y
    PERFORM draw-named
    MOVE "M_ROUGH" TO lname
    MOVE 79 TO pen-y
    PERFORM draw-named
    MOVE "M_HURT" TO lname
    MOVE 95 TO pen-y
    PERFORM draw-named
    MOVE "M_ULTRA" TO lname
    MOVE 111 TO pen-y
    PERFORM draw-named
    MOVE "M_NMARE" TO lname
    MOVE 127 TO pen-y
    PERFORM draw-named
    PERFORM menu-skull
    MOVE 20 TO pen-x
    COMPUTE pen-y = 58 + pick-n * 16
    PERFORM draw-named
    .

draw-load.
    MOVE "M_LOADG" TO lname
    MOVE 72 TO pen-x
    MOVE 28 TO pen-y
    PERFORM draw-named
    PERFORM draw-slots
    .

draw-save.
    MOVE "M_SAVEG" TO lname
    MOVE 72 TO pen-x
    MOVE 28 TO pen-y
    PERFORM draw-named
    PERFORM draw-slots
    .

draw-slots.
    PERFORM VARYING slot-i FROM 0 BY 1 UNTIL slot-i > 5
        CALL "slot-act" USING peek-cmd slot-i peek-rc
            dummy-map desc-txt
        IF peek-rc NOT = 0
            MOVE "empty slot" TO desc-txt
        END-IF
        COMPUTE pen-y = 54 + slot-i * 16
        MOVE 80 TO pen-x
        PERFORM draw-border
        MOVE 80 TO pen-x
        PERFORM draw-text
    END-PERFORM
    PERFORM menu-skull
    MOVE 48 TO pen-x
    COMPUTE pen-y = 49 + pick-n * 16
    PERFORM draw-named
    .

draw-border.
    MOVE pen-x TO hold-x
    MOVE "M_LSLEFT" TO lname
    SUBTRACT 8 FROM pen-x
    ADD 7 TO pen-y
    PERFORM draw-named
    ADD 8 TO pen-x
    PERFORM 24 TIMES
        MOVE "M_LSCNTR" TO lname
        PERFORM draw-named
        ADD 8 TO pen-x
    END-PERFORM
    MOVE "M_LSRGHT" TO lname
    PERFORM draw-named
    MOVE hold-x TO pen-x
    SUBTRACT 7 FROM pen-y
    .

draw-text.
    MOVE FUNCTION LENGTH(FUNCTION TRIM(desc-txt)) TO txt-n
    IF txt-n < 1
        EXIT PARAGRAPH
    END-IF
    IF txt-n > 24
        MOVE 24 TO txt-n
    END-IF
    PERFORM VARYING ch-i FROM 1 BY 1 UNTIL ch-i > txt-n
        MOVE desc-txt(ch-i:1) TO ch-c
        IF ch-c = " "
            ADD 4 TO pen-x
        ELSE
            COMPUTE code-n = FUNCTION ORD(ch-c) - 1
            MOVE "STCFN000" TO lname
            MOVE code-n TO code-pic
            MOVE code-pic TO lname(6:3)
            PERFORM draw-named
            ADD 8 TO pen-x
        END-IF
    END-PERFORM
    .

menu-skull.
    IF skull-n = 0
        MOVE "M_SKULL1" TO lname
    ELSE
        MOVE "M_SKULL2" TO lname
    END-IF
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
    IF ply-loc = 1
        PERFORM draw-loc
    ELSE
        PERFORM draw-stats
    END-IF
    .

draw-stats.
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

draw-loc.
    PERFORM read-spot
    PERFORM pick-bg
    MOVE 0 TO pen-x
    MOVE 0 TO pen-y
    PERFORM draw-named
    IF map-name(1:3) NOT = "MAP" AND ep-n < 3
        PERFORM draw-nodes
    END-IF
    MOVE "WIENTER" TO lname
    MOVE 2 TO pen-y
    PERFORM center-name
    MULTIPLY ph-n BY 5 GIVING row-y
    DIVIDE row-y BY 4 GIVING row-y
    ADD row-y TO pen-y
    PERFORM next-lump
    PERFORM center-name
    .

read-spot.
    MOVE 0 TO ep-n
    MOVE 0 TO mp-n
    MOVE 1 TO next-n
    IF map-name(1:3) = "MAP"
        PERFORM read-pack
        EXIT PARAGRAPH
    END-IF
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
    IF ply-secret = 1
        MOVE 8 TO next-n
    ELSE
        IF mp-n = 8
            MOVE 3 TO next-n
        ELSE
            IF mp-n = 7
                MOVE 0 TO next-n
            ELSE
                ADD 1 TO mp-n GIVING next-n
            END-IF
        END-IF
    END-IF
    .

read-pack.
    MOVE 0 TO ep-n
    MOVE 0 TO next-n
    EVALUATE map-name(4:1)
        WHEN "1" MOVE 10 TO mp-n
        WHEN "2" MOVE 20 TO mp-n
        WHEN "3" MOVE 30 TO mp-n
        WHEN OTHER MOVE 0 TO mp-n
    END-EVALUATE
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
    MOVE mp-n TO next-n
    IF ply-secret = 1 AND mp-n = 15
        MOVE 31 TO next-n
    ELSE
        IF ply-secret = 1 AND mp-n = 31
            MOVE 32 TO next-n
        ELSE
            IF ply-secret = 0 AND mp-n = 31
                MOVE 16 TO next-n
            ELSE
                ADD 1 TO next-n
                IF next-n > 32
                    MOVE 1 TO next-n
                END-IF
            END-IF
        END-IF
    END-IF
    .

pick-bg.
    IF map-name(1:3) = "MAP" OR ep-n >= 3
        MOVE "INTERPIC" TO lname
        CALL "wad-find" USING lname lump-id
        IF lump-id < 0
            MOVE "WIMAP0" TO lname
        END-IF
    ELSE
        MOVE "WIMAP0" TO lname
        MOVE ep-n TO dig-n
        PERFORM one-dig
        MOVE dig-c TO lname(6:1)
    END-IF
    .

draw-nodes.
    IF mp-n = 8
        SUBTRACT 1 FROM next-n GIVING last-n
    ELSE
        MOVE mp-n TO last-n
    END-IF
    PERFORM VARYING node-i FROM 0 BY 1 UNTIL node-i > last-n
        MOVE "WISPLAT" TO lname
        PERFORM node-xy
        PERFORM mark-one
    END-PERFORM
    IF ply-secret = 1 OR mp-n = 8
        MOVE 8 TO node-i
        MOVE "WISPLAT" TO lname
        PERFORM node-xy
        PERFORM mark-one
    END-IF
    IF skull-n = 0
        MOVE next-n TO node-i
        MOVE "WIURH0" TO lname
        PERFORM node-xy
        PERFORM mark-one
        IF fit-n = 0
            MOVE "WIURH1" TO lname
            PERFORM node-xy
            PERFORM mark-one
        END-IF
    END-IF
    .

node-xy.
    COMPUTE at-n = (ep-n * 9 + node-i) * 3 + 1
    MOVE FUNCTION NUMVAL(xs(at-n:3)) TO pen-x
    MOVE FUNCTION NUMVAL(ys(at-n:3)) TO pen-y
    .

mark-one.
    MOVE 0 TO fit-n
    CALL "wad-find" USING lname lump-id
    IF lump-id < 0
        EXIT PARAGRAPH
    END-IF
    CALL "wad-read-num" USING lump-id patch cap-n nread
    IF nread < 8
        EXIT PARAGRAPH
    END-IF
    CALL "i16_le" USING BY REFERENCE patch BY VALUE 0 RETURNING pw-n
    CALL "i16_le" USING BY REFERENCE patch BY VALUE 2 RETURNING ph-n
    CALL "i16_le" USING BY REFERENCE patch BY VALUE 4 RETURNING ox-n
    CALL "i16_le" USING BY REFERENCE patch BY VALUE 6 RETURNING oy-n
    SUBTRACT ox-n FROM pen-x GIVING left-n
    SUBTRACT oy-n FROM pen-y GIVING row-y
    ADD left-n TO pw-n GIVING bot-n
    IF left-n < 0 OR bot-n >= 320
        EXIT PARAGRAPH
    END-IF
    ADD row-y TO ph-n GIVING bot-n
    IF row-y < 0 OR bot-n >= 200
        EXIT PARAGRAPH
    END-IF
    CALL "v-draw-patch" USING fb patch nread ink-n pen-x pen-y
    MOVE 1 TO fit-n
    .

next-lump.
    IF map-name(1:3) = "MAP"
        MOVE "CWILV00" TO lname
        SUBTRACT 1 FROM next-n GIVING mp-n
        DIVIDE mp-n BY 10 GIVING ep-n REMAINDER dig-n
        MOVE dig-n TO at-n
        MOVE ep-n TO dig-n
        PERFORM one-dig
        MOVE dig-c TO lname(6:1)
        MOVE at-n TO dig-n
        PERFORM one-dig
        MOVE dig-c TO lname(7:1)
    ELSE
        MOVE "WILV00" TO lname
        MOVE ep-n TO dig-n
        PERFORM one-dig
        MOVE dig-c TO lname(5:1)
        MOVE next-n TO dig-n
        PERFORM one-dig
        MOVE dig-c TO lname(6:1)
    END-IF
    .

one-dig.
    EVALUATE dig-n
        WHEN 1 MOVE "1" TO dig-c
        WHEN 2 MOVE "2" TO dig-c
        WHEN 3 MOVE "3" TO dig-c
        WHEN 4 MOVE "4" TO dig-c
        WHEN 5 MOVE "5" TO dig-c
        WHEN 6 MOVE "6" TO dig-c
        WHEN 7 MOVE "7" TO dig-c
        WHEN 8 MOVE "8" TO dig-c
        WHEN 9 MOVE "9" TO dig-c
        WHEN OTHER MOVE "0" TO dig-c
    END-EVALUATE
    .

center-name.
    CALL "wad-find" USING lname lump-id
    IF lump-id < 0
        MOVE 0 TO ph-n
        EXIT PARAGRAPH
    END-IF
    CALL "wad-read-num" USING lump-id patch cap-n nread
    IF nread < 8
        MOVE 0 TO ph-n
        EXIT PARAGRAPH
    END-IF
    CALL "i16_le" USING BY REFERENCE patch BY VALUE 0 RETURNING pw-n
    CALL "i16_le" USING BY REFERENCE patch BY VALUE 2 RETURNING ph-n
    SUBTRACT pw-n FROM 320 GIVING pen-x
    DIVIDE pen-x BY 2 GIVING pen-x
    CALL "v-draw-patch" USING fb patch nread ink-n pen-x pen-y
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

IDENTIFICATION DIVISION.
PROGRAM-ID. fps-stamp.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 lname PIC X(8).
01 lump-id BINARY-LONG.
01 patch PIC X(8192).
01 cap-n BINARY-LONG VALUE 8192.
01 nread BINARY-LONG.
01 ink-n BINARY-LONG.
01 msg PIC X(12).
01 msg-n BINARY-LONG.
01 num-v BINARY-LONG.
01 div-n BINARY-LONG.
01 dig-n BINARY-LONG.
01 digs BINARY-LONG OCCURS 4 TIMES.
01 nd BINARY-LONG.
01 ch-i BINARY-LONG.
01 code-n BINARY-LONG.
01 wide-n BINARY-LONG.
01 pen-x BINARY-LONG.
01 pen-y BINARY-LONG VALUE 4.
01 glyph-w BINARY-LONG.
01 tens-n BINARY-LONG.
01 ones-n BINARY-LONG.

LINKAGE SECTION.
01 fb PIC X(64000).
01 fps-v BINARY-LONG.

PROCEDURE DIVISION USING fb fps-v.
    MOVE SPACES TO msg
    MOVE 0 TO msg-n
    IF fps-v < 0
        MOVE 0 TO num-v
    ELSE
        MOVE fps-v TO num-v
    END-IF
    IF num-v > 9999
        MOVE 9999 TO num-v
    END-IF
    MOVE 0 TO nd
    PERFORM UNTIL num-v < 10
        DIVIDE num-v BY 10 GIVING div-n REMAINDER dig-n
        ADD 1 TO nd
        MOVE dig-n TO digs(nd)
        MOVE div-n TO num-v
    END-PERFORM
    ADD 1 TO nd
    MOVE num-v TO digs(nd)
    PERFORM VARYING ch-i FROM nd BY -1 UNTIL ch-i < 1
        ADD 1 TO msg-n
        MOVE digs(ch-i) TO dig-n
        ADD 48 TO dig-n
        MOVE dig-n TO code-n
        PERFORM put-code
    END-PERFORM
    ADD 1 TO msg-n
    MOVE " " TO msg(msg-n:1)
    MOVE "FPS" TO msg(msg-n + 1:3)
    ADD 3 TO msg-n
    MOVE 0 TO wide-n
    PERFORM VARYING ch-i FROM 1 BY 1 UNTIL ch-i > msg-n
        PERFORM glyph-width
        ADD glyph-w TO wide-n
    END-PERFORM
    SUBTRACT wide-n FROM 314 GIVING pen-x
    IF pen-x < 0
        MOVE 0 TO pen-x
    END-IF
    PERFORM VARYING ch-i FROM 1 BY 1 UNTIL ch-i > msg-n
        PERFORM glyph-draw
        ADD glyph-w TO pen-x
    END-PERFORM
    GOBACK.

put-code.
    EVALUATE code-n
        WHEN 49 MOVE "1" TO msg(msg-n:1)
        WHEN 50 MOVE "2" TO msg(msg-n:1)
        WHEN 51 MOVE "3" TO msg(msg-n:1)
        WHEN 52 MOVE "4" TO msg(msg-n:1)
        WHEN 53 MOVE "5" TO msg(msg-n:1)
        WHEN 54 MOVE "6" TO msg(msg-n:1)
        WHEN 55 MOVE "7" TO msg(msg-n:1)
        WHEN 56 MOVE "8" TO msg(msg-n:1)
        WHEN 57 MOVE "9" TO msg(msg-n:1)
        WHEN OTHER MOVE "0" TO msg(msg-n:1)
    END-EVALUATE
    .

glyph-width.
    PERFORM load-glyph
    .

glyph-draw.
    PERFORM load-glyph
    IF nread >= 8 AND lump-id >= 0
        CALL "v-draw-patch" USING fb patch nread ink-n pen-x pen-y
    END-IF
    .

load-glyph.
    MOVE 4 TO glyph-w
    MOVE -1 TO lump-id
    MOVE 0 TO nread
    IF msg(ch-i:1) = " "
        EXIT PARAGRAPH
    END-IF
    EVALUATE msg(ch-i:1)
        WHEN "1" MOVE 49 TO code-n
        WHEN "2" MOVE 50 TO code-n
        WHEN "3" MOVE 51 TO code-n
        WHEN "4" MOVE 52 TO code-n
        WHEN "5" MOVE 53 TO code-n
        WHEN "6" MOVE 54 TO code-n
        WHEN "7" MOVE 55 TO code-n
        WHEN "8" MOVE 56 TO code-n
        WHEN "9" MOVE 57 TO code-n
        WHEN "F" MOVE 70 TO code-n
        WHEN "P" MOVE 80 TO code-n
        WHEN "S" MOVE 83 TO code-n
        WHEN OTHER MOVE 48 TO code-n
    END-EVALUATE
    MOVE "STCFN000" TO lname
    DIVIDE code-n BY 100 GIVING tens-n REMAINDER ones-n
    EVALUATE tens-n
        WHEN 1 MOVE "1" TO lname(6:1)
        WHEN OTHER MOVE "0" TO lname(6:1)
    END-EVALUATE
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
    CALL "wad-read-num" USING lump-id patch cap-n nread
    IF nread < 8
        EXIT PARAGRAPH
    END-IF
    CALL "i16_le" USING BY REFERENCE patch BY VALUE 0 RETURNING glyph-w
    IF glyph-w < 1
        MOVE 4 TO glyph-w
    END-IF
    .

END PROGRAM fps-stamp.
