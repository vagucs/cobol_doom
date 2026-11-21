>>SOURCE FORMAT FREE
*> DOOM generic portado do python_doom para COBOL com SDL3.
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
01 rnd-n BINARY-LONG.
01 spawn-tics BINARY-LONG.
01 q-n BINARY-LONG.
01 rem-n BINARY-LONG.
01 spec-n BINARY-LONG.
01 light-min BINARY-LONG.
01 fs BINARY-LONG.
01 bs BINARY-LONG.
01 li BINARY-LONG.

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
    MOVE 0 TO n-light
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > n-sector
        IF sec-special(i) = 9
            ADD 1 TO map-secs
        END-IF
    END-PERFORM
    *> Harbour/Python: walk things in order; type 1 consumes lastlook RNG.
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > n-thing
        MOVE th-kind(i) TO kind-n
        MOVE th-opt(i) TO opt-n
        IF kind-n = 11 OR kind-n = 2 OR kind-n = 3 OR kind-n = 4
            EXIT PERFORM CYCLE
        END-IF
        IF kind-n = 1
            CALL "p-random" USING rnd-n
            EXIT PERFORM CYCLE
        END-IF
        MOVE 2 TO tmp
        IF ply-skill <= 1
            MOVE 1 TO tmp
        END-IF
        IF ply-skill >= 3
            MOVE 4 TO tmp
        END-IF
        CALL "bit_and" USING BY VALUE opt-n BY VALUE tmp
            RETURNING bit-n
        IF bit-n = 0
            EXIT PERFORM CYCLE
        END-IF
        CALL "bit_and" USING BY VALUE opt-n BY VALUE 16
            RETURNING bit-n
        IF bit-n NOT = 0
            EXIT PERFORM CYCLE
        END-IF
        PERFORM place-one
    END-PERFORM
    *> P_SpawnSpecials light RNG (after map things).
    PERFORM spawn-light-rng
    MOVE 1 TO spr-once
    GOBACK.

spawn-light-rng.
    *> P_SpawnSpecials after map things (Harbour p_spec / Python specials).
    *> Flash(1) and unsynced strobe(2/3/4) each consume one P_Random.
    *> Synced strobe(12/13) does not. Special 4 keeps damage after strobe.
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > n-sector
        MOVE sec-special(i) TO spec-n
        EVALUATE TRUE
            WHEN spec-n = 1
                PERFORM spawn-flash
            WHEN spec-n = 2
                MOVE 15 TO rem-n
                PERFORM spawn-strobe
            WHEN spec-n = 3
                MOVE 35 TO rem-n
                PERFORM spawn-strobe
            WHEN spec-n = 4
                MOVE 15 TO rem-n
                PERFORM spawn-strobe
                MOVE 4 TO sec-special(i)
            WHEN spec-n = 8
                MOVE 0 TO sec-special(i)
            WHEN spec-n = 17
                PERFORM spawn-fire
            WHEN spec-n = 12
                MOVE 35 TO rem-n
                MOVE 1 TO q-n
                PERFORM spawn-strobe-sync
            WHEN spec-n = 13
                MOVE 15 TO rem-n
                MOVE 1 TO q-n
                PERFORM spawn-strobe-sync
        END-EVALUATE
    END-PERFORM
    .

spawn-flash.
    *> P_SpawnLightFlash: count = (P_Random & 64) + 1.
    IF n-light >= 64
        CALL "p-random" USING rnd-n
        MOVE 0 TO sec-special(i)
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO n-light
    MOVE i TO lt-sec(n-light)
    MOVE 1 TO lt-kind(n-light)
    MOVE sec-flight(i) TO lt-max(n-light)
    MOVE i TO sec-slot
    MOVE sec-flight(i) TO light-min
    PERFORM min-surround-light
    MOVE light-min TO lt-min(n-light)
    MOVE 64 TO lt-maxt(n-light)
    MOVE 7 TO lt-mint(n-light)
    CALL "p-random" USING rnd-n
    CALL "bit_and" USING BY VALUE rnd-n BY VALUE 64 RETURNING rem-n
    COMPUTE lt-count(n-light) = rem-n + 1
    MOVE 0 TO sec-special(i)
    .

spawn-strobe.
    *> Unsynced strobe: count = (P_Random & 7) + 1. rem-n = darktime.
    MOVE 0 TO q-n
    PERFORM spawn-strobe-body
    .

spawn-strobe-sync.
    *> Synced strobe: count = 1, no P_Random. rem-n = darktime.
    PERFORM spawn-strobe-body
    .

spawn-strobe-body.
    *> rem-n holds darktime (FASTDARK=15 / SLOWDARK=35) on entry.
    MOVE rem-n TO spawn-tics
    IF n-light >= 64
        IF q-n = 0
            CALL "p-random" USING rnd-n
        END-IF
        IF spec-n NOT = 4
            MOVE 0 TO sec-special(i)
        END-IF
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO n-light
    MOVE i TO lt-sec(n-light)
    MOVE 2 TO lt-kind(n-light)
    MOVE sec-flight(i) TO lt-max(n-light)
    MOVE i TO sec-slot
    MOVE sec-flight(i) TO light-min
    PERFORM min-surround-light
    IF light-min = sec-flight(i)
        MOVE 0 TO light-min
    END-IF
    MOVE light-min TO lt-min(n-light)
    MOVE spawn-tics TO lt-dark(n-light)
    MOVE 5 TO lt-brit(n-light)
    IF q-n = 0
        CALL "p-random" USING rnd-n
        CALL "bit_and" USING BY VALUE rnd-n BY VALUE 7 RETURNING rem-n
        COMPUTE lt-count(n-light) = rem-n + 1
    ELSE
        MOVE 1 TO lt-count(n-light)
    END-IF
    IF spec-n NOT = 4
        MOVE 0 TO sec-special(i)
    END-IF
    .

spawn-fire.
    *> P_SpawnFireFlicker: count 4, minlight = surrounding + 16. No spawn RNG.
    IF n-light >= 64
        MOVE 0 TO sec-special(i)
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO n-light
    MOVE i TO lt-sec(n-light)
    MOVE 3 TO lt-kind(n-light)
    MOVE sec-flight(i) TO lt-max(n-light)
    MOVE i TO sec-slot
    MOVE sec-flight(i) TO light-min
    PERFORM min-surround-light
    ADD 16 TO light-min
    MOVE light-min TO lt-min(n-light)
    MOVE 4 TO lt-count(n-light)
    MOVE 0 TO sec-special(i)
    .

min-surround-light.
    *> P_FindMinSurroundingLight for flash/strobe spawn.
    PERFORM VARYING j FROM 1 BY 1 UNTIL j > n-line
        CALL "bit_and" USING BY VALUE ln-flags(j) BY VALUE 4
            RETURNING bit-n
        IF bit-n NOT = 0
            COMPUTE fs = ln-front(j) + 1
            IF fs = sec-slot AND ln-back(j) >= 0
                COMPUTE bs = ln-back(j) + 1
                IF bs >= 1 AND bs <= n-sector
                    IF sec-flight(bs) < light-min
                        MOVE sec-flight(bs) TO light-min
                    END-IF
                END-IF
            END-IF
            COMPUTE bs = ln-back(j) + 1
            IF ln-back(j) >= 0 AND bs = sec-slot
                COMPUTE fs = ln-front(j) + 1
                IF fs >= 1 AND fs <= n-sector
                    IF sec-flight(fs) < light-min
                        MOVE sec-flight(fs) TO light-min
                    END-IF
                END-IF
            END-IF
        END-IF
    END-PERFORM
    .

place-one.
    IF n-mobj >= 768
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
    *> spawnMobj lastlook + spawnMapThings tics jitter (P_Random stream).
    CALL "p-random" USING rnd-n
    CALL "bit_and" USING BY VALUE rnd-n BY VALUE 3 RETURNING rem-n
    MOVE rem-n TO mo-look(n-mobj)
    PERFORM spawn-tics-of
    IF spawn-tics > 0
        CALL "p-random" USING rnd-n
        DIVIDE rnd-n BY spawn-tics GIVING q-n REMAINDER rem-n
        COMPUTE mo-tic(n-mobj) = rem-n + 1
    END-IF
    .

spawn-tics-of.
    *> Spawn-state tics from info (only >0 consume a P_Random).
    *> E1M5 gap vs Python was ARM1/ARM2/BKEY/YKEY (6 rolls; ply-rnd wraps 256).
    MOVE 0 TO spawn-tics
    CALL "bit_and" USING BY VALUE flags-n BY VALUE 4194304
        RETURNING bit-n
    IF bit-n NOT = 0
        MOVE 10 TO spawn-tics
    END-IF
    *> S_FATT_STND is 15 tics. Every other monster stand state is 10.
    IF mo-name(n-mobj) = "FATT"
        MOVE 15 TO spawn-tics
    END-IF
    IF mo-name(n-mobj) = "SKUL"
        MOVE 10 TO spawn-tics
    END-IF
    IF mo-name(n-mobj) = "BAR1" OR mo-name(n-mobj) = "POL6"
        MOVE 6 TO spawn-tics
    END-IF
    *> Powerups/armor with spawnstate tics>0. SUIT and PSTR are -1.
    IF mo-name(n-mobj) = "BON1" OR mo-name(n-mobj) = "BON2"
        OR mo-name(n-mobj) = "SOUL" OR mo-name(n-mobj) = "MEGA"
        OR mo-name(n-mobj) = "PINV"
        OR mo-name(n-mobj) = "PINS"
        OR mo-name(n-mobj) = "PMAP" OR mo-name(n-mobj) = "PVIS"
        OR mo-name(n-mobj) = "ARM1" OR mo-name(n-mobj) = "ARM2"
        MOVE 6 TO spawn-tics
    END-IF
    *> Keys: spawnstate tics=10.
    IF mo-name(n-mobj) = "BKEY" OR mo-name(n-mobj) = "RKEY"
        OR mo-name(n-mobj) = "YKEY" OR mo-name(n-mobj) = "BSKU"
        OR mo-name(n-mobj) = "RSKU" OR mo-name(n-mobj) = "YSKU"
        MOVE 10 TO spawn-tics
    END-IF
    *> SMIT/TRE1/TRE2 spawnstate tics is -1. Short lamps are 4.
    IF mo-name(n-mobj) = "SMIT" OR mo-name(n-mobj) = "TRE1"
        OR mo-name(n-mobj) = "TRE2"
        MOVE 0 TO spawn-tics
    END-IF
    *> COLU (2028) spawnstate tics is -1: no jitter. E1M3 has six of
    *> them; rolling anyway shifted P_Random before the first tic.
    *> Short torches and the blue/green/red tech lamps are 4.
    IF mo-name(n-mobj) = "FCAN" OR mo-name(n-mobj) = "FSKU"
        OR mo-name(n-mobj) = "TLMP" OR mo-name(n-mobj) = "TLP2"
        OR mo-name(n-mobj) = "TBLU" OR mo-name(n-mobj) = "TGRN"
        OR mo-name(n-mobj) = "TRED" OR mo-name(n-mobj) = "SMBT"
        OR mo-name(n-mobj) = "SMGT" OR mo-name(n-mobj) = "SMRT"
        MOVE 4 TO spawn-tics
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
    MOVE 0 TO mo-wait(n-mobj)
    *> Harbour: movedir spawn default 0 (DI_NODIR=8 only after AI fails).
    MOVE 0 TO mo-dir(n-mobj)
    MOVE 0 TO mo-count(n-mobj)
    *> info.reactiontime (sk_nightmare clears this in spawnMobj).
    MOVE 8 TO mo-react(n-mobj)
    IF ply-skill = 4
        MOVE 0 TO mo-react(n-mobj)
    END-IF
    MOVE 0 TO mo-look(n-mobj)
    MOVE 0 TO mo-tgt(n-mobj)
    MOVE 0 TO mo-thrs(n-mobj)
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
        MOVE 1048576 TO mo-rad(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "BAR1"
        MOVE 20 TO mo-hp(n-mobj)
        MOVE 655360 TO mo-rad(n-mobj)
    END-IF
    *> Columns, lamps and the short tree are 16 units. The tall tree is 32.
    *> Pickups stay at the 20 set in place-one. E1M3's ELEC was blocking
    *> the player four units early.
    IF mo-name(n-mobj) = "ELEC" OR mo-name(n-mobj) = "COLU"
        OR mo-name(n-mobj) = "COL1" OR mo-name(n-mobj) = "COL2"
        OR mo-name(n-mobj) = "COL3" OR mo-name(n-mobj) = "COL4"
        OR mo-name(n-mobj) = "TLMP" OR mo-name(n-mobj) = "TLP2"
        OR mo-name(n-mobj) = "CEYE" OR mo-name(n-mobj) = "FSKU"
        OR mo-name(n-mobj) = "TRE1" OR mo-name(n-mobj) = "SMIT"
        OR mo-name(n-mobj) = "CAND" OR mo-name(n-mobj) = "CBRA"
        OR mo-name(n-mobj) = "TBLU" OR mo-name(n-mobj) = "TGRN"
        OR mo-name(n-mobj) = "TRED"
        OR mo-name(n-mobj) = "SMBT" OR mo-name(n-mobj) = "SMGT"
        OR mo-name(n-mobj) = "SMRT"
        OR mo-name(n-mobj) = "POL1" OR mo-name(n-mobj) = "POL2"
        OR mo-name(n-mobj) = "POL4" OR mo-name(n-mobj) = "POL5"
        OR mo-name(n-mobj) = "POL6"
        OR mo-name(n-mobj) = "GOR1" OR mo-name(n-mobj) = "GOR2"
        OR mo-name(n-mobj) = "GOR3" OR mo-name(n-mobj) = "GOR4"
        OR mo-name(n-mobj) = "GOR5"
        MOVE 1048576 TO mo-rad(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "TRE2"
        MOVE 2097152 TO mo-rad(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "BSPI"
        MOVE 500 TO mo-hp(n-mobj)
        MOVE 4194304 TO mo-rad(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "CYBR"
        MOVE 4000 TO mo-hp(n-mobj)
        MOVE 2621440 TO mo-rad(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "SPID"
        MOVE 3000 TO mo-hp(n-mobj)
        MOVE 8388608 TO mo-rad(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "VILE"
        MOVE 700 TO mo-hp(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "SKEL"
        MOVE 500 TO mo-hp(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "FATT"
        MOVE 600 TO mo-hp(n-mobj)
        MOVE 3145728 TO mo-rad(n-mobj)
    END-IF
    IF mo-name(n-mobj) = "PAIN"
        MOVE 400 TO mo-hp(n-mobj)
        MOVE 2031616 TO mo-rad(n-mobj)
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
    PERFORM VARYING step-n FROM 1 BY 1 UNTIL step-n > 1024
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
PROGRAM-ID. light-tic.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "mapstate.cpy".
COPY "playstate.cpy".
01 li BINARY-LONG.
01 sec-i BINARY-LONG.
01 rnd-n BINARY-LONG.
01 rem-n BINARY-LONG.

PROCEDURE DIVISION.
    PERFORM VARYING li FROM 1 BY 1 UNTIL li > n-light
        SUBTRACT 1 FROM lt-count(li)
        IF lt-count(li) = 0
            MOVE lt-sec(li) TO sec-i
            IF lt-kind(li) = 1
                *> T_LightFlash — each phase re-rolls with P_Random.
                IF sec-flight(sec-i) = lt-max(li)
                    MOVE lt-min(li) TO sec-flight(sec-i)
                    CALL "p-random" USING rnd-n
                    CALL "bit_and" USING BY VALUE rnd-n
                        BY VALUE lt-mint(li) RETURNING rem-n
                    COMPUTE lt-count(li) = rem-n + 1
                ELSE
                    MOVE lt-max(li) TO sec-flight(sec-i)
                    CALL "p-random" USING rnd-n
                    CALL "bit_and" USING BY VALUE rnd-n
                        BY VALUE lt-maxt(li) RETURNING rem-n
                    COMPUTE lt-count(li) = rem-n + 1
                END-IF
            END-IF
            IF lt-kind(li) = 2
                *> T_StrobeFlash — fixed bright/dark times, no RNG.
                IF sec-flight(sec-i) = lt-min(li)
                    MOVE lt-max(li) TO sec-flight(sec-i)
                    MOVE lt-brit(li) TO lt-count(li)
                ELSE
                    MOVE lt-min(li) TO sec-flight(sec-i)
                    MOVE lt-dark(li) TO lt-count(li)
                END-IF
            END-IF
            IF lt-kind(li) = 3
                *> T_FireFlicker: (P_Random & 3) * 16, then count = 4.
                CALL "p-random" USING rnd-n
                CALL "bit_and" USING BY VALUE rnd-n BY VALUE 3
                    RETURNING rem-n
                MULTIPLY rem-n BY 16 GIVING rem-n
                COMPUTE rnd-n = sec-flight(sec-i) - rem-n
                IF rnd-n < lt-min(li)
                    MOVE lt-min(li) TO sec-flight(sec-i)
                ELSE
                    COMPUTE sec-flight(sec-i) = lt-max(li) - rem-n
                END-IF
                MOVE 4 TO lt-count(li)
            END-IF
        END-IF
    END-PERFORM
    GOBACK.

END PROGRAM light-tic.

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
