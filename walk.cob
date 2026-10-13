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
*> Um tic de andar: giro, impulso, paredes e atrito. Sem rato.
*> O lodo tira vida a cada 32 tics, com o pe no chao.
IDENTIFICATION DIVISION.
PROGRAM-ID. walk-tic.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "mapstate.cpy".
COPY "sprstate.cpy".
COPY "playstate.cpy".
01 speed-n BINARY-LONG.
01 turn-n BINARY-LONG.
01 fwd-n BINARY-LONG.
01 side-n BINARY-LONG.
01 move-n BINARY-LONG.
01 want-x BINARY-LONG.
01 want-y BINARY-LONG.
01 try-x BINARY-LONG.
01 try-y BINARY-LONG.
01 hit-n BINARY-LONG.
01 floor-z BINARY-LONG.
01 ceil-z BINARY-LONG.
01 drop-z BINARY-LONG.
01 open-top BINARY-LONG.
01 open-bot BINARY-LONG.
01 low-z BINARY-LONG.
01 box-l BINARY-LONG.
01 box-r BINARY-LONG.
01 box-b BINARY-LONG.
01 box-t BINARY-LONG.
01 seen-gen BINARY-LONG VALUE 0.
01 seen-ln BINARY-LONG OCCURS 3200 TIMES.
01 bsp BINARY-LONG.
01 node-slot BINARY-LONG.
01 sub-slot BINARY-LONG.
01 sub-n BINARY-LONG.
01 sec-slot BINARY-LONG.
01 spot-sec BINARY-LONG.
01 step-n BINARY-LONG.
01 bit-n BINARY-LONG.
01 side-bit BINARY-LONG.
01 p1 BINARY-LONG.
01 p2 BINARY-LONG.
01 bx BINARY-LONG.
01 by-n BINARY-LONG.
01 xl BINARY-LONG.
01 xh BINARY-LONG.
01 yl BINARY-LONG.
01 yh BINARY-LONG.
01 off-n BINARY-LONG.
01 line-n BINARY-LONG.
01 line-slot BINARY-LONG.
01 v1-slot BINARY-LONG.
01 v2-slot BINARY-LONG.
01 ldx BINARY-LONG.
01 ldy BINARY-LONG.
01 dx BINARY-LONG.
01 dy BINARY-LONG.
01 left-v BINARY-LONG.
01 right-v BINARY-LONG.
01 tmp BINARY-LONG.
01 sn BINARY-LONG.
01 cs BINARY-LONG.
01 ax BINARY-LONG.
01 ay BINARY-LONG.
01 half-b BINARY-LONG.
01 mo-i BINARY-LONG.
01 dist-n BINARY-LONG.
01 top-z BINARY-LONG.

LINKAGE SECTION.
01 k-up BINARY-LONG.
01 k-down BINARY-LONG.
01 k-left BINARY-LONG.
01 k-right BINARY-LONG.
01 k-shift BINARY-LONG.
01 k-alt BINARY-LONG.
01 k-comma BINARY-LONG.
01 k-dot BINARY-LONG.

PROCEDURE DIVISION USING k-up k-down k-left k-right
    k-shift k-alt k-comma k-dot.
    IF ply-on = 0
        GOBACK
    END-IF
    MOVE 0 TO speed-n
    IF k-shift NOT = 0
        MOVE 1 TO speed-n
    END-IF
    MOVE 0 TO fwd-n
    MOVE 0 TO side-n
    MOVE 0 TO turn-n
    IF k-left NOT = 0 OR k-right NOT = 0
        ADD 1 TO ply-turn
    ELSE
        MOVE 0 TO ply-turn
    END-IF
    IF ply-turn > 0 AND ply-turn < 6
        MOVE 320 TO turn-n
    ELSE
        IF speed-n = 0
            MOVE 640 TO turn-n
        ELSE
            MOVE 1280 TO turn-n
        END-IF
    END-IF
    IF k-alt NOT = 0
        IF k-right NOT = 0
            IF speed-n = 0
                ADD 24 TO side-n
            ELSE
                ADD 40 TO side-n
            END-IF
        END-IF
        IF k-left NOT = 0
            IF speed-n = 0
                SUBTRACT 24 FROM side-n
            ELSE
                SUBTRACT 40 FROM side-n
            END-IF
        END-IF
        MOVE 0 TO turn-n
    ELSE
        IF k-left = 0 AND k-right = 0
            MOVE 0 TO turn-n
        ELSE
            IF k-left = 0
                CALL "sub_i32" USING BY VALUE 0 BY VALUE turn-n
                    RETURNING turn-n
            END-IF
            IF k-right NOT = 0 AND k-left NOT = 0
                MOVE 0 TO turn-n
            END-IF
        END-IF
    END-IF
    IF k-comma NOT = 0
        IF speed-n = 0
            SUBTRACT 24 FROM side-n
        ELSE
            SUBTRACT 40 FROM side-n
        END-IF
    END-IF
    IF k-dot NOT = 0
        IF speed-n = 0
            ADD 24 TO side-n
        ELSE
            ADD 40 TO side-n
        END-IF
    END-IF
    IF k-up NOT = 0
        IF speed-n = 0
            ADD 25 TO fwd-n
        ELSE
            ADD 50 TO fwd-n
        END-IF
    END-IF
    IF k-down NOT = 0
        IF speed-n = 0
            SUBTRACT 25 FROM fwd-n
        ELSE
            SUBTRACT 50 FROM fwd-n
        END-IF
    END-IF
    IF turn-n NOT = 0
        CALL "shl_i" USING BY VALUE turn-n BY VALUE 16 RETURNING tmp
        CALL "add_i32" USING BY VALUE ply-ang BY VALUE tmp RETURNING ply-ang
    END-IF
    IF fwd-n NOT = 0
        COMPUTE move-n = fwd-n * 2048
        CALL "fine_cos_ang" USING BY VALUE ply-ang RETURNING cs
        CALL "fine_sin_ang" USING BY VALUE ply-ang RETURNING sn
        CALL "fixed_mul" USING BY VALUE move-n BY VALUE cs RETURNING tmp
        CALL "add_i32" USING BY VALUE ply-momx BY VALUE tmp RETURNING ply-momx
        CALL "fixed_mul" USING BY VALUE move-n BY VALUE sn RETURNING tmp
        CALL "add_i32" USING BY VALUE ply-momy BY VALUE tmp RETURNING ply-momy
    END-IF
    IF side-n NOT = 0
        COMPUTE move-n = side-n * 2048
        CALL "sub_i32" USING BY VALUE ply-ang BY VALUE 1073741824
            RETURNING tmp
        CALL "fine_cos_ang" USING BY VALUE tmp RETURNING cs
        CALL "fine_sin_ang" USING BY VALUE tmp RETURNING sn
        CALL "fixed_mul" USING BY VALUE move-n BY VALUE cs RETURNING tmp
        CALL "add_i32" USING BY VALUE ply-momx BY VALUE tmp RETURNING ply-momx
        CALL "fixed_mul" USING BY VALUE move-n BY VALUE sn RETURNING tmp
        CALL "add_i32" USING BY VALUE ply-momy BY VALUE tmp RETURNING ply-momy
    END-IF
    IF ply-momx NOT = 0 OR ply-momy NOT = 0
        IF ply-momx > 1966080
            MOVE 1966080 TO ply-momx
        END-IF
        IF ply-momx < -1966080
            MOVE -1966080 TO ply-momx
        END-IF
        IF ply-momy > 1966080
            MOVE 1966080 TO ply-momy
        END-IF
        IF ply-momy < -1966080
            MOVE -1966080 TO ply-momy
        END-IF
        CALL "add_i32" USING BY VALUE ply-x BY VALUE ply-momx RETURNING want-x
        CALL "add_i32" USING BY VALUE ply-y BY VALUE ply-momy RETURNING want-y
        MOVE want-x TO try-x
        MOVE want-y TO try-y
        IF ply-clip = 1
            PERFORM sector-at
            MOVE sec-slot TO spot-sec
            MOVE sec-floor-h(sec-slot) TO floor-z
            MOVE sec-ceil-h(sec-slot) TO ceil-z
            PERFORM accept-spot
        ELSE
            PERFORM try-spot
            IF hit-n = 0
                PERFORM accept-spot
            ELSE
                MOVE ply-x TO try-x
                MOVE want-y TO try-y
                PERFORM try-spot
                IF hit-n = 0
                    PERFORM accept-spot
                ELSE
                    MOVE want-x TO try-x
                    MOVE ply-y TO try-y
                    PERFORM try-spot
                    IF hit-n = 0
                        PERFORM accept-spot
                    END-IF
                END-IF
            END-IF
        END-IF
    END-IF
    IF fwd-n = 0 AND side-n = 0
        CALL "abs_fixed_i" USING BY VALUE ply-momx RETURNING ax
        CALL "abs_fixed_i" USING BY VALUE ply-momy RETURNING ay
        IF ax < 4096 AND ay < 4096
            MOVE 0 TO ply-momx
            MOVE 0 TO ply-momy
        ELSE
            PERFORM apply-friction
        END-IF
    ELSE
        PERFORM apply-friction
    END-IF
    PERFORM apply-z
    IF ply-z <= ply-floor
        PERFORM ease-view
    END-IF
    CALL "fixed_mul" USING BY VALUE ply-momx BY VALUE ply-momx RETURNING ax
    CALL "fixed_mul" USING BY VALUE ply-momy BY VALUE ply-momy RETURNING ay
    CALL "add_i32" USING BY VALUE ax BY VALUE ay RETURNING tmp
    DIVIDE tmp BY 4 GIVING ply-bob
    IF ply-bob > 1048576
        MOVE 1048576 TO ply-bob
    END-IF
    IF ply-bob < 0
        MOVE 0 TO ply-bob
    END-IF
    DIVIDE ply-bob BY 2 GIVING half-b
    MOVE 0 TO ply-vbob
    IF half-b NOT = 0
        COMPUTE tmp = ply-tic * 409
        CALL "bit_and" USING BY VALUE tmp BY VALUE 8191 RETURNING tmp
        CALL "shl_i" USING BY VALUE tmp BY VALUE 19 RETURNING tmp
        CALL "fine_sin_ang" USING BY VALUE tmp RETURNING sn
        CALL "fixed_mul" USING BY VALUE half-b BY VALUE sn RETURNING ply-vbob
    END-IF
    ADD 1 TO ply-tic
    IF ply-hp > 0
        CALL "item-tic"
    END-IF
    GOBACK.

apply-friction.
    CALL "fixed_mul" USING BY VALUE ply-momx BY VALUE 59392
        RETURNING ply-momx
    CALL "fixed_mul" USING BY VALUE ply-momy BY VALUE 59392
        RETURNING ply-momy
    .

apply-z.
    IF ply-z < ply-floor
        CALL "sub_i32" USING BY VALUE ply-floor BY VALUE ply-z RETURNING tmp
        CALL "sub_i32" USING BY VALUE ply-vh BY VALUE tmp RETURNING ply-vh
        CALL "sub_i32" USING BY VALUE 2686976 BY VALUE ply-vh RETURNING tmp
        CALL "shar32" USING BY VALUE tmp BY VALUE 3 RETURNING ply-dvh
    END-IF
    CALL "add_i32" USING BY VALUE ply-z BY VALUE ply-momz RETURNING ply-z
    IF ply-z <= ply-floor
        IF ply-momz < -524288
            CALL "shar32" USING BY VALUE ply-momz BY VALUE 3 RETURNING ply-dvh
        END-IF
        IF ply-momz < 0
            MOVE 0 TO ply-momz
        END-IF
        MOVE ply-floor TO ply-z
    ELSE
        IF ply-momz = 0
            MOVE -131072 TO ply-momz
        ELSE
            CALL "sub_i32" USING BY VALUE ply-momz BY VALUE 65536
                RETURNING ply-momz
        END-IF
    END-IF
    CALL "add_i32" USING BY VALUE ply-z BY VALUE ply-h RETURNING tmp
    IF tmp > ply-ceil
        IF ply-momz > 0
            MOVE 0 TO ply-momz
        END-IF
        CALL "sub_i32" USING BY VALUE ply-ceil BY VALUE ply-h RETURNING ply-z
    END-IF
    .

ease-view.
    IF ply-hp <= 0
        EXIT PARAGRAPH
    END-IF
    CALL "add_i32" USING BY VALUE ply-vh BY VALUE ply-dvh RETURNING ply-vh
    IF ply-vh > 2686976
        MOVE 2686976 TO ply-vh
        MOVE 0 TO ply-dvh
    END-IF
    IF ply-vh < 1343488
        MOVE 1343488 TO ply-vh
        IF ply-dvh <= 0
            MOVE 1 TO ply-dvh
        END-IF
    END-IF
    IF ply-dvh NOT = 0
        CALL "add_i32" USING BY VALUE ply-dvh BY VALUE 16384 RETURNING ply-dvh
        IF ply-dvh = 0
            MOVE 1 TO ply-dvh
        END-IF
    END-IF
    .

accept-spot.
    MOVE try-x TO ply-x
    MOVE try-y TO ply-y
    MOVE floor-z TO ply-floor
    MOVE ceil-z TO ply-ceil
    MOVE spot-sec TO ply-room
    .

try-spot.
    MOVE 0 TO hit-n
    CALL "sub_i32" USING BY VALUE try-x BY VALUE ply-rad RETURNING box-l
    CALL "add_i32" USING BY VALUE try-x BY VALUE ply-rad RETURNING box-r
    CALL "sub_i32" USING BY VALUE try-y BY VALUE ply-rad RETURNING box-b
    CALL "add_i32" USING BY VALUE try-y BY VALUE ply-rad RETURNING box-t
    PERFORM sector-at
    MOVE sec-slot TO spot-sec
    MOVE sec-floor-h(sec-slot) TO floor-z
    MOVE sec-ceil-h(sec-slot) TO ceil-z
    MOVE floor-z TO drop-z
    PERFORM pit-things
    IF hit-n = 1
        EXIT PARAGRAPH
    END-IF
    PERFORM pit-lines
    IF hit-n = 1
        EXIT PARAGRAPH
    END-IF
    CALL "sub_i32" USING BY VALUE ceil-z BY VALUE floor-z RETURNING tmp
    IF tmp < ply-h
        MOVE 1 TO hit-n
        EXIT PARAGRAPH
    END-IF
    CALL "sub_i32" USING BY VALUE ceil-z BY VALUE ply-z RETURNING tmp
    IF tmp < ply-h
        MOVE 1 TO hit-n
        EXIT PARAGRAPH
    END-IF
    CALL "sub_i32" USING BY VALUE floor-z BY VALUE ply-z RETURNING tmp
    IF tmp > 1572864
        MOVE 1 TO hit-n
        EXIT PARAGRAPH
    END-IF
    MOVE 0 TO hit-n
    .

pit-things.
    PERFORM VARYING mo-i FROM 1 BY 1 UNTIL mo-i > n-mobj
        CALL "bit_and" USING BY VALUE mo-flags(mo-i) BY VALUE 2
            RETURNING bit-n
        IF bit-n NOT = 0
            CALL "add_i32" USING BY VALUE mo-rad(mo-i) BY VALUE ply-rad
                RETURNING dist-n
            CALL "sub_i32" USING BY VALUE mo-x(mo-i) BY VALUE try-x
                RETURNING dx
            CALL "abs_fixed_i" USING BY VALUE dx RETURNING dx
            CALL "sub_i32" USING BY VALUE mo-y(mo-i) BY VALUE try-y
                RETURNING dy
            CALL "abs_fixed_i" USING BY VALUE dy RETURNING dy
            IF dx < dist-n AND dy < dist-n
                CALL "add_i32" USING BY VALUE mo-z(mo-i) BY VALUE mo-h(mo-i)
                    RETURNING top-z
                CALL "add_i32" USING BY VALUE ply-z BY VALUE ply-h
                    RETURNING tmp
                IF ply-z >= top-z OR mo-z(mo-i) >= tmp
                    CONTINUE
                ELSE
                    MOVE 1 TO hit-n
                    EXIT PERFORM
                END-IF
            END-IF
        END-IF
    END-PERFORM
    .

pit-lines.
    IF blk-w < 1 OR blk-h < 1
        EXIT PARAGRAPH
    END-IF
    CALL "sub_i32" USING BY VALUE box-l BY VALUE blk-org-x RETURNING tmp
    CALL "shar32" USING BY VALUE tmp BY VALUE 23 RETURNING xl
    CALL "sub_i32" USING BY VALUE box-r BY VALUE blk-org-x RETURNING tmp
    CALL "shar32" USING BY VALUE tmp BY VALUE 23 RETURNING xh
    CALL "sub_i32" USING BY VALUE box-b BY VALUE blk-org-y RETURNING tmp
    CALL "shar32" USING BY VALUE tmp BY VALUE 23 RETURNING yl
    CALL "sub_i32" USING BY VALUE box-t BY VALUE blk-org-y RETURNING tmp
    CALL "shar32" USING BY VALUE tmp BY VALUE 23 RETURNING yh
    ADD 1 TO seen-gen
    PERFORM VARYING bx FROM xl BY 1 UNTIL bx > xh OR hit-n = 1
        PERFORM VARYING by-n FROM yl BY 1 UNTIL by-n > yh OR hit-n = 1
            IF bx >= 0 AND by-n >= 0 AND bx < blk-w AND by-n < blk-h
                PERFORM read-block
            END-IF
        END-PERFORM
    END-PERFORM
    .

read-block.
    COMPUTE off-n = 4 + by-n * blk-w + bx
    IF off-n < 0 OR off-n >= n-block
        EXIT PARAGRAPH
    END-IF
    COMPUTE step-n = off-n + 1
    MOVE blk-raw(step-n) TO off-n
    PERFORM UNTIL off-n < 0 OR off-n >= n-block OR hit-n = 1
        COMPUTE step-n = off-n + 1
        MOVE blk-raw(step-n) TO line-n
        ADD 1 TO off-n
        IF line-n = 65535
            EXIT PERFORM
        END-IF
        COMPUTE line-slot = line-n + 1
        IF line-slot >= 1 AND line-slot <= n-line
            IF seen-ln(line-slot) NOT = seen-gen
                MOVE seen-gen TO seen-ln(line-slot)
                PERFORM one-line
            END-IF
        END-IF
    END-PERFORM
    .

one-line.
    IF box-r <= ln-bl(line-slot) OR box-l >= ln-br(line-slot)
        OR box-t <= ln-bb(line-slot) OR box-b >= ln-bt(line-slot)
        EXIT PARAGRAPH
    END-IF
    PERFORM box-side
    IF side-bit NOT = -1
        EXIT PARAGRAPH
    END-IF
    IF ln-back(line-slot) < 0
        MOVE 1 TO hit-n
        EXIT PARAGRAPH
    END-IF
    CALL "bit_and" USING BY VALUE ln-flags(line-slot) BY VALUE 1
        RETURNING bit-n
    IF bit-n NOT = 0
        MOVE 1 TO hit-n
        EXIT PARAGRAPH
    END-IF
    COMPUTE sec-slot = ln-front(line-slot) + 1
    COMPUTE step-n = ln-back(line-slot) + 1
    IF sec-slot < 1 OR step-n < 1
        OR sec-slot > n-sector OR step-n > n-sector
        MOVE 1 TO hit-n
        EXIT PARAGRAPH
    END-IF
    IF sec-ceil-h(sec-slot) < sec-ceil-h(step-n)
        MOVE sec-ceil-h(sec-slot) TO open-top
    ELSE
        MOVE sec-ceil-h(step-n) TO open-top
    END-IF
    IF sec-floor-h(sec-slot) > sec-floor-h(step-n)
        MOVE sec-floor-h(sec-slot) TO open-bot
        MOVE sec-floor-h(step-n) TO low-z
    ELSE
        MOVE sec-floor-h(step-n) TO open-bot
        MOVE sec-floor-h(sec-slot) TO low-z
    END-IF
    IF open-top < ceil-z
        MOVE open-top TO ceil-z
    END-IF
    IF open-bot > floor-z
        MOVE open-bot TO floor-z
    END-IF
    IF low-z < drop-z
        MOVE low-z TO drop-z
    END-IF
    .

box-side.
    MOVE ln-v1(line-slot) TO v1-slot
    MOVE ln-v2(line-slot) TO v2-slot
    CALL "delta_shr16" USING BY VALUE vtx-x(v2-slot)
        BY VALUE vtx-x(v1-slot) RETURNING ldx
    CALL "delta_shr16" USING BY VALUE vtx-y(v2-slot)
        BY VALUE vtx-y(v1-slot) RETURNING ldy
    IF ldx = 0
        IF box-r < vtx-x(v1-slot)
            MOVE 0 TO p1
        ELSE
            MOVE 1 TO p1
        END-IF
        IF box-l < vtx-x(v1-slot)
            MOVE 0 TO p2
        ELSE
            MOVE 1 TO p2
        END-IF
        IF ldy > 0
            CALL "bit_xor" USING BY VALUE p1 BY VALUE 1 RETURNING p1
            CALL "bit_xor" USING BY VALUE p2 BY VALUE 1 RETURNING p2
        END-IF
    ELSE
        IF ldy = 0
            IF box-t > vtx-y(v1-slot)
                MOVE 0 TO p1
            ELSE
                MOVE 1 TO p1
            END-IF
            IF box-b > vtx-y(v1-slot)
                MOVE 0 TO p2
            ELSE
                MOVE 1 TO p2
            END-IF
            IF ldx < 0
                CALL "bit_xor" USING BY VALUE p1 BY VALUE 1 RETURNING p1
                CALL "bit_xor" USING BY VALUE p2 BY VALUE 1 RETURNING p2
            END-IF
        ELSE
            IF (ldy > 0 AND ldx > 0) OR (ldy < 0 AND ldx < 0)
                MOVE box-l TO dx
                MOVE box-t TO dy
                PERFORM point-side
                MOVE side-bit TO p1
                MOVE box-r TO dx
                MOVE box-b TO dy
                PERFORM point-side
                MOVE side-bit TO p2
            ELSE
                MOVE box-r TO dx
                MOVE box-t TO dy
                PERFORM point-side
                MOVE side-bit TO p1
                MOVE box-l TO dx
                MOVE box-b TO dy
                PERFORM point-side
                MOVE side-bit TO p2
            END-IF
        END-IF
    END-IF
    IF p1 = p2
        MOVE p1 TO side-bit
    ELSE
        MOVE -1 TO side-bit
    END-IF
    .

point-side.
    IF ldx = 0
        IF dx <= vtx-x(v1-slot)
            IF ldy > 0
                MOVE 1 TO side-bit
            ELSE
                MOVE 0 TO side-bit
            END-IF
        ELSE
            IF ldy < 0
                MOVE 1 TO side-bit
            ELSE
                MOVE 0 TO side-bit
            END-IF
        END-IF
        EXIT PARAGRAPH
    END-IF
    IF ldy = 0
        IF dy <= vtx-y(v1-slot)
            IF ldx < 0
                MOVE 1 TO side-bit
            ELSE
                MOVE 0 TO side-bit
            END-IF
        ELSE
            IF ldx > 0
                MOVE 1 TO side-bit
            ELSE
                MOVE 0 TO side-bit
            END-IF
        END-IF
        EXIT PARAGRAPH
    END-IF
    CALL "sub_i32" USING BY VALUE dx BY VALUE vtx-x(v1-slot) RETURNING dx
    CALL "sub_i32" USING BY VALUE dy BY VALUE vtx-y(v1-slot) RETURNING dy
    CALL "fixed_mul" USING BY VALUE ldy BY VALUE dx RETURNING left-v
    CALL "fixed_mul" USING BY VALUE dy BY VALUE ldx RETURNING right-v
    IF right-v < left-v
        MOVE 0 TO side-bit
    ELSE
        MOVE 1 TO side-bit
    END-IF
    .

sector-at.
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
            BY VALUE try-x BY VALUE try-y
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

END PROGRAM walk-tic.

IDENTIFICATION DIVISION.
PROGRAM-ID. floor-tic.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "mapstate.cpy".
COPY "playstate.cpy".
01 q-n BINARY-LONG.
01 rem-n BINARY-LONG.
01 spec-n BINARY-LONG.
01 dmg-n BINARY-LONG.
01 atk-on BINARY-LONG.
01 atk-x BINARY-LONG.
01 atk-y BINARY-LONG.
01 saved-n BINARY-LONG.

LINKAGE SECTION.
01 hurt-out BINARY-LONG.

PROCEDURE DIVISION USING hurt-out.
main-floor.
    MOVE 0 TO hurt-out
    IF ply-on = 0
        GOBACK
    END-IF
    IF ply-room >= 1 AND ply-room <= n-sector
        IF sec-special(ply-room) = 9
            ADD 1 TO ply-secs
            MOVE 0 TO sec-special(ply-room)
        END-IF
    END-IF
    DIVIDE ply-time BY 32 GIVING q-n REMAINDER rem-n
    ADD 1 TO ply-time
    IF rem-n NOT = 0
        GOBACK
    END-IF
    IF ply-hp <= 0
        GOBACK
    END-IF
    IF ply-room < 1 OR ply-room > n-sector
        GOBACK
    END-IF
    IF ply-z NOT = sec-floor-h(ply-room)
        GOBACK
    END-IF
    MOVE sec-special(ply-room) TO spec-n
    MOVE 0 TO dmg-n
    IF spec-n = 5
        MOVE 10 TO dmg-n
    END-IF
    IF spec-n = 7
        MOVE 5 TO dmg-n
    END-IF
    IF spec-n = 4 OR spec-n = 16 OR spec-n = 11
        MOVE 20 TO dmg-n
    END-IF
    IF dmg-n = 0 OR ply-god = 1 OR ply-inv > 0
        GOBACK
    END-IF
    IF ply-suit > 0
        IF spec-n = 5 OR spec-n = 7
            GOBACK
        END-IF
    END-IF
    IF ply-atype > 0 AND ply-armor > 0
        IF ply-atype = 1
            DIVIDE dmg-n BY 3 GIVING saved-n
        ELSE
            DIVIDE dmg-n BY 2 GIVING saved-n
        END-IF
        IF saved-n > ply-armor
            MOVE ply-armor TO saved-n
            MOVE 0 TO ply-atype
        ELSE
            IF saved-n = ply-armor
                MOVE 0 TO ply-atype
            END-IF
        END-IF
        SUBTRACT saved-n FROM ply-armor
        SUBTRACT saved-n FROM dmg-n
    END-IF
    IF ply-skill = 0
        DIVIDE dmg-n BY 2 GIVING dmg-n
    END-IF
    IF dmg-n > 0
        SUBTRACT dmg-n FROM ply-hp
        IF ply-hp < 0
            MOVE 0 TO ply-hp
        END-IF
        ADD dmg-n TO ply-pain
        IF ply-pain > 100
            MOVE 100 TO ply-pain
        END-IF
        MOVE 0 TO atk-on
        CALL "face-hit" USING dmg-n atk-on atk-x atk-y
        CALL "ply-ouch"
    END-IF
    MOVE 1 TO hurt-out
    IF spec-n = 11 AND ply-hp <= 10 AND ply-exit = 0
        MOVE 1 TO ply-exit
    END-IF
    GOBACK.

END PROGRAM floor-tic.
