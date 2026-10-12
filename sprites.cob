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
*> Quadros dos sprites (S_START) e objetos do mapa no quadro inicial.
IDENTIFICATION DIVISION.
PROGRAM-ID. spr-init.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "wadstate.cpy".
COPY "sprstate.cpy".
01 lname PIC X(8).
01 start-id BINARY-LONG.
01 end-id BINARY-LONG.
01 first-id BINARY-LONG.
01 last-id BINARY-LONG.
01 lump-i BINARY-LONG.
01 slot BINARY-LONG.
01 spr-i BINARY-LONG.
01 found-s BINARY-LONG.
01 fr-i BINARY-LONG.
01 rot-i BINARY-LONG.
01 byte-a BINARY-LONG.
01 byte-b BINARY-LONG.
01 prefix PIC X(4).
01 in-spr BINARY-LONG.
01 in-lump BINARY-LONG.
01 in-frame BINARY-LONG.
01 in-rot BINARY-LONG.
01 in-flip BINARY-LONG.
01 in-ok BINARY-LONG.
01 base-f BINARY-LONG.
01 at-f BINARY-LONG.
01 at-l BINARY-LONG.

PROCEDURE DIVISION.
    IF spr-ready = 1
        GOBACK
    END-IF
    PERFORM fill-spawn
    MOVE 0 TO n-spr
    MOVE "S_START" TO lname
    CALL "wad-find" USING lname start-id
    MOVE "S_END" TO lname
    CALL "wad-find" USING lname end-id
    IF start-id < 0
        MOVE "SS_START" TO lname
        CALL "wad-find" USING lname start-id
    END-IF
    IF end-id < 0
        MOVE "SS_END" TO lname
        CALL "wad-find" USING lname end-id
    END-IF
    IF start-id >= 0 AND end-id > start-id
        COMPUTE first-id = start-id + 1
        COMPUTE last-id = end-id - 1
    ELSE
        MOVE 0 TO first-id
        COMPUTE last-id = lump-n - 1
    END-IF
    PERFORM VARYING lump-i FROM first-id BY 1 UNTIL lump-i > last-id
        COMPUTE slot = lump-i + 1
        IF slot >= 1 AND slot <= lump-n
            CALL "byte_at" USING BY REFERENCE lump-name(slot)
                BY VALUE 4 RETURNING byte-a
            CALL "byte_at" USING BY REFERENCE lump-name(slot)
                BY VALUE 5 RETURNING byte-b
            IF byte-a NOT = 0 AND byte-a NOT = 32
                AND byte-b NOT = 0 AND byte-b NOT = 32
                MOVE lump-name(slot)(1:4) TO prefix
                PERFORM find-sprite
                IF found-s = 0 AND n-spr < 128
                    ADD 1 TO n-spr
                    MOVE prefix TO spr-name(n-spr)
                    MOVE 0 TO spr-nf(n-spr)
                    MOVE n-spr TO in-spr
                    PERFORM init-frames
                    MOVE n-spr TO found-s
                END-IF
                IF found-s > 0
                    COMPUTE in-frame = byte-a - 65
                    COMPUTE in-rot = byte-b - 48
                    MOVE found-s TO in-spr
                    MOVE lump-i TO in-lump
                    MOVE 0 TO in-flip
                    PERFORM install-lump
                    IF in-ok = 1
                        COMPUTE slot = in-frame + 1
                        IF slot > spr-nf(found-s)
                            MOVE slot TO spr-nf(found-s)
                        END-IF
                    END-IF
                    CALL "byte_at" USING BY REFERENCE lump-name(lump-i + 1)
                        BY VALUE 6 RETURNING byte-a
                    IF byte-a >= 65 AND byte-a <= 93
                        CALL "byte_at" USING
                            BY REFERENCE lump-name(lump-i + 1)
                            BY VALUE 7 RETURNING byte-b
                        COMPUTE in-frame = byte-a - 65
                        COMPUTE in-rot = byte-b - 48
                        MOVE 1 TO in-flip
                        MOVE found-s TO in-spr
                        MOVE lump-i TO in-lump
                        PERFORM install-lump
                        IF in-ok = 1
                            COMPUTE slot = in-frame + 1
                            IF slot > spr-nf(found-s)
                                MOVE slot TO spr-nf(found-s)
                            END-IF
                        END-IF
                    END-IF
                END-IF
            END-IF
        END-IF
    END-PERFORM
    PERFORM VARYING spr-i FROM 1 BY 1 UNTIL spr-i > n-spr
        PERFORM VARYING fr-i FROM 0 BY 1 UNTIL fr-i >= spr-nf(spr-i)
            COMPUTE at-f = (spr-i - 1) * 29 + fr-i + 1
            IF sf-rot(at-f) = -1
                MOVE 0 TO sf-rot(at-f)
            END-IF
        END-PERFORM
    END-PERFORM
    MOVE 1 TO spr-ready
    GOBACK.

fill-spawn.
    COPY "sprdata.cpy".
    MOVE 118 TO n-spawn
    .

find-sprite.
    MOVE 0 TO found-s
    PERFORM VARYING spr-i FROM 1 BY 1 UNTIL spr-i > n-spr OR found-s > 0
        IF spr-name(spr-i) = prefix
            MOVE spr-i TO found-s
        END-IF
    END-PERFORM
    .

init-frames.
    PERFORM VARYING fr-i FROM 0 BY 1 UNTIL fr-i >= 29
        COMPUTE at-f = (in-spr - 1) * 29 + fr-i + 1
        MOVE -1 TO sf-rot(at-f)
        PERFORM VARYING rot-i FROM 0 BY 1 UNTIL rot-i >= 8
            COMPUTE at-l = ((in-spr - 1) * 29 + fr-i) * 8 + rot-i + 1
            MOVE -1 TO sf-lump(at-l)
            MOVE 0 TO sf-flip(at-l)
        END-PERFORM
    END-PERFORM
    .

install-lump.
    MOVE 0 TO in-ok
    IF in-frame < 0 OR in-frame >= 29
        OR in-rot < 0 OR in-rot > 8
        EXIT PARAGRAPH
    END-IF
    COMPUTE at-f = (in-spr - 1) * 29 + in-frame + 1
    IF in-rot = 0
        IF sf-rot(at-f) = 1
            MOVE 1 TO in-ok
            EXIT PARAGRAPH
        END-IF
        MOVE 0 TO sf-rot(at-f)
        PERFORM VARYING rot-i FROM 0 BY 1 UNTIL rot-i >= 8
            COMPUTE at-l = ((in-spr - 1) * 29 + in-frame) * 8 + rot-i + 1
            MOVE in-lump TO sf-lump(at-l)
            MOVE in-flip TO sf-flip(at-l)
        END-PERFORM
        MOVE 1 TO in-ok
        EXIT PARAGRAPH
    END-IF
    IF sf-rot(at-f) = 0
        MOVE 1 TO in-ok
        EXIT PARAGRAPH
    END-IF
    MOVE 1 TO sf-rot(at-f)
    COMPUTE rot-i = in-rot - 1
    COMPUTE at-l = ((in-spr - 1) * 29 + in-frame) * 8 + rot-i + 1
    IF sf-lump(at-l) < 0
        MOVE in-lump TO sf-lump(at-l)
        MOVE in-flip TO sf-flip(at-l)
    END-IF
    MOVE 1 TO in-ok
    .

END PROGRAM spr-init.

IDENTIFICATION DIVISION.
PROGRAM-ID. spr-spawn.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "mapstate.cpy".
COPY "sprstate.cpy".
COPY "playstate.cpy".
01 i BINARY-LONG.
01 j BINARY-LONG.
01 bit-n BINARY-LONG.
01 kind-n BINARY-LONG.
01 opt-n BINARY-LONG.
01 row-i BINARY-LONG.
01 flags-n BINARY-LONG.
01 walk-x BINARY-LONG.
01 walk-y BINARY-LONG.
01 bsp BINARY-LONG.
01 node-slot BINARY-LONG.
01 side-bit BINARY-LONG.
01 sub-slot BINARY-LONG.
01 sub-n BINARY-LONG.
01 sec-slot BINARY-LONG.
01 step-n BINARY-LONG.
01 tmp BINARY-LONG.

PROCEDURE DIVISION.
    IF spr-once = 1
        GOBACK
    END-IF
    MOVE 0 TO n-mobj
    MOVE 0 TO map-kills
    MOVE 0 TO map-items
    MOVE 0 TO map-secs
    MOVE 0 TO ply-kills
    MOVE 0 TO ply-items
    MOVE 0 TO ply-secs
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > n-sector
        IF sec-special(i) = 9
            ADD 1 TO map-secs
        END-IF
    END-PERFORM
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > n-thing
        MOVE th-kind(i) TO kind-n
        MOVE th-opt(i) TO opt-n
        IF kind-n = 11 OR kind-n = 1 OR kind-n = 2
            OR kind-n = 3 OR kind-n = 4
            CONTINUE
        ELSE
            CALL "bit_and" USING BY VALUE opt-n BY VALUE 2
                RETURNING bit-n
            IF bit-n = 0
                CONTINUE
            ELSE
                CALL "bit_and" USING BY VALUE opt-n BY VALUE 16
                    RETURNING bit-n
                IF bit-n NOT = 0
                    CONTINUE
                ELSE
                    PERFORM place-one
                END-IF
            END-IF
        END-IF
    END-PERFORM
    MOVE 1 TO spr-once
    GOBACK.

place-one.
    IF n-mobj >= 512
        EXIT PARAGRAPH
    END-IF
    MOVE 0 TO row-i
    PERFORM VARYING j FROM 1 BY 1 UNTIL j > n-spawn OR row-i > 0
        IF sp-doom(j) = kind-n
            MOVE j TO row-i
        END-IF
    END-PERFORM
    IF row-i = 0
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO n-mobj
    CALL "fixed_from_i16" USING BY VALUE th-x(i) RETURNING mo-x(n-mobj)
    CALL "fixed_from_i16" USING BY VALUE th-y(i) RETURNING mo-y(n-mobj)
    CALL "angle_from_deg" USING BY VALUE th-ang(i)
        RETURNING mo-ang(n-mobj)
    MOVE sp-frame(row-i) TO mo-frame(n-mobj)
    MOVE sp-flags(row-i) TO flags-n
    CALL "bit_and" USING BY VALUE opt-n BY VALUE 8 RETURNING bit-n
    IF bit-n NOT = 0
        CALL "bit_or" USING BY VALUE flags-n BY VALUE 32
            RETURNING flags-n
    END-IF
    MOVE flags-n TO mo-flags(n-mobj)
    CALL "bit_and" USING BY VALUE flags-n BY VALUE 4194304
        RETURNING bit-n
    IF bit-n NOT = 0
        ADD 1 TO map-kills
    END-IF
    CALL "bit_and" USING BY VALUE flags-n BY VALUE 1
        RETURNING bit-n
    IF bit-n NOT = 0
        ADD 1 TO map-items
    END-IF
    MOVE sp-name(row-i) TO mo-name(n-mobj)
    MOVE sp-height(row-i) TO mo-h(n-mobj)
    MOVE 1310720 TO mo-rad(n-mobj)
    PERFORM set-hp
    MOVE mo-x(n-mobj) TO walk-x
    MOVE mo-y(n-mobj) TO walk-y
    PERFORM locate-floor
    CALL "bit_and" USING BY VALUE flags-n BY VALUE 256 RETURNING bit-n
    IF bit-n NOT = 0
        CALL "sub_i32" USING BY VALUE sec-ceil-h(sec-slot)
            BY VALUE sp-height(row-i) RETURNING mo-z(n-mobj)
    ELSE
        MOVE sec-floor-h(sec-slot) TO mo-z(n-mobj)
    END-IF
    .

set-hp.
    MOVE 0 TO mo-hp(n-mobj)
    MOVE 0 TO mo-max(n-mobj)
    MOVE 0 TO mo-tic(n-mobj)
    MOVE 0 TO mo-kind(n-mobj)
    MOVE 0 TO mo-seq(n-mobj)
    MOVE 0 TO mo-step(n-mobj)
    MOVE 0 TO mo-ai(n-mobj)
    MOVE 8 TO mo-wait(n-mobj)
    MOVE 8 TO mo-dir(n-mobj)
    MOVE 0 TO mo-count(n-mobj)
    MOVE 0 TO mo-mx(n-mobj)
    MOVE 0 TO mo-my(n-mobj)
    MOVE 0 TO mo-mz(n-mobj)
    IF mo-name(n-mobj) = "POSS"
        MOVE 20 TO mo-hp(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "SPOS"
        MOVE 30 TO mo-hp(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "TROO"
        MOVE 60 TO mo-hp(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "SARG"
        MOVE 150 TO mo-hp(n-mobj)
        MOVE 1966080 TO mo-rad(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "CPOS"
        MOVE 70 TO mo-hp(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "HEAD"
        MOVE 400 TO mo-hp(n-mobj)
        MOVE 2031616 TO mo-rad(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "BOSS"
        MOVE 1000 TO mo-hp(n-mobj)
        MOVE 1572864 TO mo-rad(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "BOS2"
        MOVE 500 TO mo-hp(n-mobj)
        MOVE 1572864 TO mo-rad(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "SKUL"
        MOVE 100 TO mo-hp(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "BAR1"
        MOVE 20 TO mo-hp(n-mobj)
        MOVE 655360 TO mo-rad(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "CYBR"
        MOVE 4000 TO mo-hp(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "SPID"
        MOVE 3000 TO mo-hp(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "BSPI"
        MOVE 500 TO mo-hp(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "VILE"
        MOVE 700 TO mo-hp(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "SKEL"
        MOVE 500 TO mo-hp(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "FATT"
        MOVE 600 TO mo-hp(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "PAIN"
        MOVE 400 TO mo-hp(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "SSWV"
        MOVE 50 TO mo-hp(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "KEEN"
        MOVE 100 TO mo-hp(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "BBRN"
        MOVE 250 TO mo-hp(n-mobj)
    END-IF
    CALL "bit_and" USING BY VALUE mo-flags(n-mobj) BY VALUE 4
        RETURNING bit-n
    IF bit-n NOT = 0 AND mo-hp(n-mobj) = 0
        MOVE 20 TO mo-hp(n-mobj)
    END-IF
    MOVE mo-hp(n-mobj) TO mo-max(n-mobj)
    .

locate-floor.
    MOVE 1 TO sub-slot
    MOVE 1 TO sec-slot
    IF n-node < 1
        IF n-ssector >= 1 AND ss-sec(1) >= 0
            COMPUTE sec-slot = ss-sec(1) + 1
        END-IF
        EXIT PARAGRAPH
    END-IF
    COMPUTE bsp = n-node - 1
    PERFORM VARYING step-n FROM 1 BY 1 UNTIL step-n > 256
        IF bsp < 0
            EXIT PERFORM
        END-IF
        CALL "bit_and" USING BY VALUE bsp BY VALUE 32768 RETURNING bit-n
        IF bit-n NOT = 0
            CALL "bit_and" USING BY VALUE bsp BY VALUE 32767
                RETURNING sub-n
            COMPUTE sub-slot = sub-n + 1
            EXIT PERFORM
        END-IF
        COMPUTE node-slot = bsp + 1
        IF node-slot < 1 OR node-slot > n-node
            EXIT PERFORM
        END-IF
        CALL "point_side" USING
            BY VALUE nd-x(node-slot) BY VALUE nd-y(node-slot)
            BY VALUE nd-dx(node-slot) BY VALUE nd-dy(node-slot)
            BY VALUE walk-x BY VALUE walk-y
            RETURNING side-bit
        IF side-bit = 0
            MOVE nd-c0(node-slot) TO bsp
        ELSE
            MOVE nd-c1(node-slot) TO bsp
        END-IF
    END-PERFORM
    IF sub-slot >= 1 AND sub-slot <= n-ssector
        AND ss-sec(sub-slot) >= 0
        COMPUTE sec-slot = ss-sec(sub-slot) + 1
    END-IF
    .

END PROGRAM spr-spawn.

IDENTIFICATION DIVISION.
PROGRAM-ID. spr-lookup.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "sprstate.cpy".
01 spr-i BINARY-LONG.
01 found-s BINARY-LONG.
01 fi BINARY-LONG.
01 rot-v BINARY-LONG.
01 at-f BINARY-LONG.
01 at-l BINARY-LONG.
01 tmp BINARY-LONG.
01 idx BINARY-LONG.

LINKAGE SECTION.
01 l-name PIC X(4).
01 l-frame BINARY-LONG.
01 l-ang BINARY-LONG.
01 l-moang BINARY-LONG.
01 l-lump BINARY-LONG.
01 l-flip BINARY-LONG.
01 l-rc BINARY-LONG.

PROCEDURE DIVISION USING l-name l-frame l-ang l-moang
    l-lump l-flip l-rc.
    MOVE 1 TO l-rc
    MOVE -1 TO l-lump
    MOVE 0 TO l-flip
    MOVE 0 TO found-s
    PERFORM VARYING spr-i FROM 1 BY 1 UNTIL spr-i > n-spr OR found-s > 0
        IF spr-name(spr-i) = l-name
            MOVE spr-i TO found-s
        END-IF
    END-PERFORM
    IF found-s = 0
        GOBACK
    END-IF
    CALL "bit_and" USING BY VALUE l-frame BY VALUE 32767 RETURNING fi
    IF fi < 0 OR fi >= spr-nf(found-s)
        GOBACK
    END-IF
    COMPUTE at-f = (found-s - 1) * 29 + fi + 1
    MOVE sf-rot(at-f) TO rot-v
    IF rot-v = 0
        MOVE 0 TO idx
    ELSE
        CALL "sub_i32" USING BY VALUE l-ang BY VALUE l-moang
            RETURNING tmp
        CALL "add_i32" USING BY VALUE tmp BY VALUE -1879048192
            RETURNING tmp
        CALL "ushr_i" USING BY VALUE tmp BY VALUE 29 RETURNING idx
        CALL "bit_and" USING BY VALUE idx BY VALUE 7 RETURNING idx
    END-IF
    COMPUTE at-l = ((found-s - 1) * 29 + fi) * 8 + idx + 1
    IF sf-lump(at-l) < 0
        GOBACK
    END-IF
    MOVE sf-lump(at-l) TO l-lump
    MOVE sf-flip(at-l) TO l-flip
    MOVE 0 TO l-rc
    GOBACK.

END PROGRAM spr-lookup.
