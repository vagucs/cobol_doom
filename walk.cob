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
01 xmove-n BINARY-LONG.
01 ymove-n BINARY-LONG.
01 hit-line BINARY-LONG.
01 best-frac BINARY-LONG.
01 frac-n BINARY-LONG.
01 best-line BINARY-LONG.
01 lead-x BINARY-LONG.
01 lead-y BINARY-LONG.
01 trail-x BINARY-LONG.
01 trail-y BINARY-LONG.
01 tr-x1 BINARY-LONG.
01 tr-y1 BINARY-LONG.
01 tr-x2 BINARY-LONG.
01 tr-y2 BINARY-LONG.
01 slide-mx BINARY-LONG.
01 slide-my BINARY-LONG.
01 line-ang BINARY-LONG.
01 move-ang BINARY-LONG.
01 delta-ang BINARY-LONG.
01 aim-ang BINARY-LONG.
01 ang5-n BINARY-LONG VALUE 59652323.
01 new-len BINARY-LONG.
01 slide-ok BINARY-LONG.
01 slide-n BINARY-LONG.
01 cross-mode BINARY-LONG.
01 cross-busy BINARY-LONG.
01 cross-moved BINARY-LONG.
01 rem-n BINARY-LONG.
01 dda-n BINARY-LONG.
01 dda-i BINARY-LONG.
01 dda-xy BINARY-LONG OCCURS 128 TIMES.
01 tr-dx BINARY-LONG.
01 tr-dy BINARY-LONG.
01 trace-mode BINARY-LONG.
01 did-move BINARY-LONG.

LINKAGE SECTION.
01 k-up BINARY-LONG.
01 k-down BINARY-LONG.
01 k-left BINARY-LONG.
01 k-right BINARY-LONG.
01 k-shift BINARY-LONG.
01 k-alt BINARY-LONG.
01 k-comma BINARY-LONG.
01 k-dot BINARY-LONG.
*> 1=thrust only (playerThink), 2=XY+items (mobj thinker), 0=both.
01 walk-phase BINARY-LONG.

PROCEDURE DIVISION USING k-up k-down k-left k-right
    k-shift k-alt k-comma k-dot walk-phase.
    IF ply-on = 0
        GOBACK
    END-IF
    *> Phase 2 is the same tic as phase 1. Keep the move command so a
    *> slow step still frictions instead of stopping (P_XYMovement).
    IF walk-phase NOT = 2
        MOVE 0 TO fwd-n
        MOVE 0 TO side-n
        MOVE 0 TO turn-n
    END-IF
    *> DeathThink: no thrust/angleturn from cmd — only residual mom XY.
    IF ply-hp > 0 AND (walk-phase = 0 OR walk-phase = 1)
    *> Demo: ticcmd forwardmove/sidemove/angleturn (python player_think).
    IF demo-on = 1
        *> Post-teleport reactiontime: no angleturn and no thrust.
        IF ply-rtel > 0
            SUBTRACT 1 FROM ply-rtel
        ELSE
        MOVE cmd-fwd TO fwd-n
        MOVE cmd-side TO side-n
        MOVE cmd-turn TO turn-n
        IF turn-n NOT = 0
            CALL "shl_i" USING BY VALUE turn-n BY VALUE 16 RETURNING tmp
            CALL "add_i32" USING BY VALUE ply-ang BY VALUE tmp
                RETURNING ply-ang
        END-IF
        IF ply-z <= ply-floor
            IF fwd-n NOT = 0
                COMPUTE move-n = fwd-n * 2048
                CALL "fine_cos_ang" USING BY VALUE ply-ang RETURNING cs
                CALL "fine_sin_ang" USING BY VALUE ply-ang RETURNING sn
                CALL "fixed_mul" USING BY VALUE move-n BY VALUE cs
                    RETURNING tmp
                CALL "add_i32" USING BY VALUE ply-momx BY VALUE tmp
                    RETURNING ply-momx
                CALL "fixed_mul" USING BY VALUE move-n BY VALUE sn
                    RETURNING tmp
                CALL "add_i32" USING BY VALUE ply-momy BY VALUE tmp
                    RETURNING ply-momy
            END-IF
            IF side-n NOT = 0
                COMPUTE move-n = side-n * 2048
                CALL "sub_i32" USING BY VALUE ply-ang
                    BY VALUE 1073741824 RETURNING tmp
                CALL "fine_cos_ang" USING BY VALUE tmp RETURNING cs
                CALL "fine_sin_ang" USING BY VALUE tmp RETURNING sn
                CALL "fixed_mul" USING BY VALUE move-n BY VALUE cs
                    RETURNING tmp
                CALL "add_i32" USING BY VALUE ply-momx BY VALUE tmp
                    RETURNING ply-momx
                CALL "fixed_mul" USING BY VALUE move-n BY VALUE sn
                    RETURNING tmp
                CALL "add_i32" USING BY VALUE ply-momy BY VALUE tmp
                    RETURNING ply-momy
            END-IF
        END-IF
        END-IF
    ELSE
        IF ply-rtel > 0
            SUBTRACT 1 FROM ply-rtel
        ELSE
    MOVE 0 TO speed-n
    IF k-shift NOT = 0
        MOVE 1 TO speed-n
    END-IF
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
    END-IF
    END-IF
    END-IF
    *> Dead: no thrust. P_XYMovement still sees the ticcmd, so a held
    *> key keeps friction going under STOPSPEED instead of a hard stop.
    IF ply-hp <= 0 AND demo-on = 1
        AND (walk-phase = 0 OR walk-phase = 1)
        MOVE cmd-fwd TO fwd-n
        MOVE cmd-side TO side-n
    END-IF
    *> P_DeathThink yaws once per tic, inside playerThink, before movers.
    IF ply-hp <= 0 AND walk-phase NOT = 2
        PERFORM death-yaw
    END-IF
    *> Phase 1 = playerThink thrust only; XY runs after MovePsprites.
    IF walk-phase = 1
        GOBACK
    END-IF
    MOVE 0 TO did-move
    IF ply-momx NOT = 0 OR ply-momy NOT = 0
        MOVE 1 TO did-move
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
        *> Harbour P_XYMovement trunc2 half-step (#18).
        MOVE ply-momx TO xmove-n
        MOVE ply-momy TO ymove-n
        PERFORM UNTIL xmove-n = 0 AND ymove-n = 0
            *> Harbour/Python: if xmove > MAXMOVE/2 OR ymove > MAXMOVE/2
            *> (signed >; not abs).
            IF xmove-n > 983040 OR ymove-n > 983040
                CALL "trunc2_i32" USING BY VALUE xmove-n RETURNING tmp
                CALL "add_i32" USING BY VALUE ply-x BY VALUE tmp
                    RETURNING try-x
                CALL "trunc2_i32" USING BY VALUE ymove-n RETURNING tmp
                CALL "add_i32" USING BY VALUE ply-y BY VALUE tmp
                    RETURNING try-y
                CALL "trunc2_i32" USING BY VALUE xmove-n
                    RETURNING xmove-n
                CALL "trunc2_i32" USING BY VALUE ymove-n
                    RETURNING ymove-n
            ELSE
                CALL "add_i32" USING BY VALUE ply-x BY VALUE xmove-n
                    RETURNING try-x
                CALL "add_i32" USING BY VALUE ply-y BY VALUE ymove-n
                    RETURNING try-y
                MOVE 0 TO xmove-n
                MOVE 0 TO ymove-n
            END-IF
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
                    *> P_XYMovement keeps the halved remainder after a slide.
                    *> Zeroing it drops the second stairstep along the wall.
                    PERFORM player-slide
                END-IF
            END-IF
        END-PERFORM
    END-IF
    *> Friction only on ground (Harbour P_XYMovement).
    IF ply-z <= ply-floor
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
    END-IF
    *> P_TouchSpecialThing runs inside P_TryMove, before P_ZMovement.
    *> After the fall, a rocket more than 8 units below the old z looks close enough.
    IF ply-hp > 0 AND did-move = 1
        CALL "item-tic"
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
    *> Remember the step so a slide dogleg can cross a walk trigger.
    IF ply-clip = 0
        MOVE 6 TO cross-mode
        CALL "door-act" USING cross-mode cross-busy cross-moved
    END-IF
    .

player-slide.
    *> P_SlideMove. Two traces. The third pass stairsteps and keeps mom.
    MOVE 0 TO slide-ok
    *> slide-n, not step-n: sector-at and the blockmap reuse step-n.
    PERFORM VARYING slide-n FROM 1 BY 1 UNTIL slide-n > 2 OR slide-ok = 1
        PERFORM slide-one-hit
    END-PERFORM
    IF slide-ok = 0
        PERFORM stair-step
    END-IF
    .

slide-one-hit.
    IF ply-momx > 0
        CALL "add_i32" USING BY VALUE ply-x BY VALUE ply-rad RETURNING lead-x
        CALL "sub_i32" USING BY VALUE ply-x BY VALUE ply-rad RETURNING trail-x
    ELSE
        CALL "sub_i32" USING BY VALUE ply-x BY VALUE ply-rad RETURNING lead-x
        CALL "add_i32" USING BY VALUE ply-x BY VALUE ply-rad RETURNING trail-x
    END-IF
    IF ply-momy > 0
        CALL "add_i32" USING BY VALUE ply-y BY VALUE ply-rad RETURNING lead-y
        CALL "sub_i32" USING BY VALUE ply-y BY VALUE ply-rad RETURNING trail-y
    ELSE
        CALL "sub_i32" USING BY VALUE ply-y BY VALUE ply-rad RETURNING lead-y
        CALL "add_i32" USING BY VALUE ply-y BY VALUE ply-rad RETURNING trail-y
    END-IF
    COMPUTE best-frac = 65536 + 1
    MOVE 0 TO best-line
    MOVE 0 TO trace-mode
    PERFORM slide-corners
    *> A step under 16 units that starts on the wall is invisible to the
    *> divline test (den 0 is a miss). The blockmap trace returns frac 0
    *> for that touch. It also has to run when the wide scan already
    *> picked a farther wall: at the acid door the body is on the
    *> horizontal line, and a diagonal past the corner would otherwise
    *> win and leave a momentum the reference kills.
    IF slide-n < 3
        CALL "abs_fixed_i" USING BY VALUE ply-momx RETURNING ax
        CALL "abs_fixed_i" USING BY VALUE ply-momy RETURNING ay
        IF ax <= 1048576 AND ay <= 1048576
            MOVE 1 TO trace-mode
            PERFORM slide-corners
        END-IF
    END-IF
    IF best-line < 1
        PERFORM stair-step
        MOVE 1 TO slide-ok
        EXIT PARAGRAPH
    END-IF
    SUBTRACT 2048 FROM best-frac
    IF best-frac > 0
        CALL "fixed_mul" USING BY VALUE ply-momx BY VALUE best-frac
            RETURNING slide-mx
        CALL "fixed_mul" USING BY VALUE ply-momy BY VALUE best-frac
            RETURNING slide-my
        CALL "add_i32" USING BY VALUE ply-x BY VALUE slide-mx RETURNING try-x
        CALL "add_i32" USING BY VALUE ply-y BY VALUE slide-my RETURNING try-y
        PERFORM try-spot
        IF hit-n NOT = 0
            PERFORM stair-step
            MOVE 1 TO slide-ok
            EXIT PARAGRAPH
        END-IF
        PERFORM accept-spot
    END-IF
    COMPUTE best-frac = 65536 - (best-frac + 2048)
    IF best-frac > 65536
        MOVE 65536 TO best-frac
    END-IF
    IF best-frac <= 0
        MOVE 1 TO slide-ok
        EXIT PARAGRAPH
    END-IF
    CALL "fixed_mul" USING BY VALUE ply-momx BY VALUE best-frac
        RETURNING slide-mx
    CALL "fixed_mul" USING BY VALUE ply-momy BY VALUE best-frac
        RETURNING slide-my
    MOVE best-line TO hit-line
    PERFORM hit-slide-line
    MOVE slide-mx TO ply-momx
    MOVE slide-my TO ply-momy
    CALL "add_i32" USING BY VALUE ply-x BY VALUE ply-momx RETURNING try-x
    CALL "add_i32" USING BY VALUE ply-y BY VALUE ply-momy RETURNING try-y
    PERFORM try-spot
    IF hit-n = 0
        PERFORM accept-spot
        MOVE 1 TO slide-ok
    END-IF
    .

slide-corners.
    MOVE lead-x TO tr-x1
    MOVE lead-y TO tr-y1
    PERFORM slide-trace
    MOVE trail-x TO tr-x1
    MOVE lead-y TO tr-y1
    PERFORM slide-trace
    MOVE lead-x TO tr-x1
    MOVE trail-y TO tr-y1
    PERFORM slide-trace
    .

slide-trace.
    IF trace-mode = 1
        PERFORM slide-trace-touch
        EXIT PARAGRAPH
    END-IF
    PERFORM VARYING line-slot FROM 1 BY 1 UNTIL line-slot > n-line
        MOVE ln-v1(line-slot) TO v1-slot
        MOVE ln-v2(line-slot) TO v2-slot
        *> Linedef 0 is the leading 0 of every blockmap list. A step under
        *> 16 units uses P_PointOnLineSide, so that wall can win the slide.
        IF line-slot = 1
            CALL "slide_frac" USING
                BY VALUE tr-x1 BY VALUE tr-y1
                BY VALUE ply-momx BY VALUE ply-momy
                BY VALUE vtx-x(v1-slot) BY VALUE vtx-y(v1-slot)
                BY VALUE vtx-x(v2-slot) BY VALUE vtx-y(v2-slot)
                RETURNING tmp
        ELSE
            CALL "trace_frac" USING
                BY VALUE tr-x1 BY VALUE tr-y1
                BY VALUE ply-momx BY VALUE ply-momy
                BY VALUE vtx-x(v1-slot) BY VALUE vtx-y(v1-slot)
                BY VALUE vtx-x(v2-slot) BY VALUE vtx-y(v2-slot)
                RETURNING tmp
        END-IF
        *> Frac 0 here is the >>8 cross product collapsing a corner that
        *> only grazes the line. Vanilla's blockmap trace nudges that
        *> start off the boundary and keeps the real intercept. A stored
        *> 0 would slide the whole momentum.
        IF tmp > 0 AND tmp <= 65536 AND tmp < best-frac
            MOVE tmp TO frac-n
            PERFORM slide-blocking
            IF bit-n = 1
                MOVE frac-n TO best-frac
                MOVE line-slot TO best-line
            END-IF
        END-IF
    END-PERFORM
    .

slide-trace-touch.
    *> P_PathTraverse: only the blocks the corner crosses. slide_frac
    *> uses P_PointOnLineSide when the step is under 16 units, so a
    *> trace that starts on the wall (frac 0) still counts.
    CALL "add_i32" USING BY VALUE tr-x1 BY VALUE ply-momx RETURNING tr-x2
    CALL "add_i32" USING BY VALUE tr-y1 BY VALUE ply-momy RETURNING tr-y2
    CALL "slide_dda" USING
        BY VALUE tr-x1 BY VALUE tr-y1
        BY VALUE tr-x2 BY VALUE tr-y2
        BY VALUE blk-org-x BY VALUE blk-org-y
        BY REFERENCE dda-n
        BY REFERENCE dda-xy(1)
        BY REFERENCE tr-x1 BY REFERENCE tr-y1
        BY REFERENCE tr-dx BY REFERENCE tr-dy
    IF dda-n < 1
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO seen-gen
    PERFORM VARYING dda-i FROM 0 BY 1 UNTIL dda-i >= dda-n
        COMPUTE p1 = dda-i * 2 + 1
        MOVE dda-xy(p1) TO bx
        ADD 1 TO p1
        MOVE dda-xy(p1) TO by-n
        PERFORM slide-block
    END-PERFORM
    .

slide-block.
    IF bx < 0 OR by-n < 0 OR bx >= blk-w OR by-n >= blk-h
        EXIT PARAGRAPH
    END-IF
    COMPUTE off-n = 4 + by-n * blk-w + bx
    IF off-n < 0 OR off-n >= n-block
        EXIT PARAGRAPH
    END-IF
    COMPUTE step-n = off-n + 1
    MOVE blk-raw(step-n) TO off-n
    PERFORM UNTIL off-n < 0 OR off-n >= n-block
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
                PERFORM slide-consider
            END-IF
        END-IF
    END-PERFORM
    .

slide-consider.
    MOVE ln-v1(line-slot) TO v1-slot
    MOVE ln-v2(line-slot) TO v2-slot
    CALL "slide_frac" USING
        BY VALUE tr-x1 BY VALUE tr-y1
        BY VALUE tr-dx BY VALUE tr-dy
        BY VALUE vtx-x(v1-slot) BY VALUE vtx-y(v1-slot)
        BY VALUE vtx-x(v2-slot) BY VALUE vtx-y(v2-slot)
        RETURNING tmp
    IF tmp >= 0 AND tmp <= 65536 AND tmp < best-frac
        *> slide-blocking reuses tmp for opening height. Keep the frac.
        MOVE tmp TO frac-n
        PERFORM slide-blocking
        IF bit-n = 1
            MOVE frac-n TO best-frac
            MOVE line-slot TO best-line
        END-IF
    END-IF
    .

slide-blocking.
    *> PTR_SlideTraverse: one-sided or too-tight opening.
    MOVE 0 TO bit-n
    IF ln-back(line-slot) < 0
        CALL "delta_shr16" USING BY VALUE vtx-x(v2-slot)
            BY VALUE vtx-x(v1-slot) RETURNING ldx
        CALL "delta_shr16" USING BY VALUE vtx-y(v2-slot)
            BY VALUE vtx-y(v1-slot) RETURNING ldy
        MOVE ply-x TO dx
        MOVE ply-y TO dy
        PERFORM point-side
        IF side-bit = 0
            MOVE 1 TO bit-n
        END-IF
        EXIT PARAGRAPH
    END-IF
    COMPUTE sec-slot = ln-front(line-slot) + 1
    COMPUTE rem-n = ln-back(line-slot) + 1
    IF sec-slot < 1 OR rem-n < 1
        OR sec-slot > n-sector OR rem-n > n-sector
        MOVE 1 TO bit-n
        EXIT PARAGRAPH
    END-IF
    IF sec-ceil-h(sec-slot) < sec-ceil-h(rem-n)
        MOVE sec-ceil-h(sec-slot) TO open-top
    ELSE
        MOVE sec-ceil-h(rem-n) TO open-top
    END-IF
    IF sec-floor-h(sec-slot) > sec-floor-h(rem-n)
        MOVE sec-floor-h(sec-slot) TO open-bot
    ELSE
        MOVE sec-floor-h(rem-n) TO open-bot
    END-IF
    CALL "sub_i32" USING BY VALUE open-top BY VALUE open-bot RETURNING tmp
    IF tmp < ply-h
        MOVE 1 TO bit-n
        EXIT PARAGRAPH
    END-IF
    CALL "sub_i32" USING BY VALUE open-top BY VALUE ply-z RETURNING tmp
    IF tmp < ply-h
        MOVE 1 TO bit-n
        EXIT PARAGRAPH
    END-IF
    CALL "sub_i32" USING BY VALUE open-bot BY VALUE ply-z RETURNING tmp
    IF tmp > 1572864
        MOVE 1 TO bit-n
    END-IF
    .

hit-slide-line.
    MOVE hit-line TO line-slot
    MOVE ln-v1(line-slot) TO v1-slot
    MOVE ln-v2(line-slot) TO v2-slot
    CALL "sub_i32" USING BY VALUE vtx-x(v2-slot)
        BY VALUE vtx-x(v1-slot) RETURNING ldx
    CALL "sub_i32" USING BY VALUE vtx-y(v2-slot)
        BY VALUE vtx-y(v1-slot) RETURNING ldy
    CALL "hit_slide_line" USING
        BY VALUE ply-x BY VALUE ply-y
        BY VALUE vtx-x(v1-slot) BY VALUE vtx-y(v1-slot)
        BY VALUE ldx BY VALUE ldy
        BY VALUE slide-mx BY VALUE slide-my
        BY REFERENCE slide-mx BY REFERENCE slide-my
    .

stair-step.
    *> Harbour P_SlideMove: try Y, then X, and leave mom alone if both miss.
    MOVE ply-x TO try-x
    CALL "add_i32" USING BY VALUE ply-y BY VALUE ply-momy
        RETURNING try-y
    PERFORM try-spot
    IF hit-n = 0
        PERFORM accept-spot
        EXIT PARAGRAPH
    END-IF
    CALL "add_i32" USING BY VALUE ply-x BY VALUE ply-momx
        RETURNING try-x
    MOVE ply-y TO try-y
    PERFORM try-spot
    IF hit-n = 0
        PERFORM accept-spot
    END-IF
    .

try-spot.
    MOVE 0 TO hit-n
    MOVE 0 TO hit-line
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
                *> PIT_CheckThing: a solid blocks the player in XY.
                *> Height is not tested, so a body on the ledge above still stops the step.
                MOVE 1 TO hit-n
                EXIT PERFORM
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
        MOVE line-slot TO hit-line
        EXIT PARAGRAPH
    END-IF
    CALL "bit_and" USING BY VALUE ln-flags(line-slot) BY VALUE 1
        RETURNING bit-n
    IF bit-n NOT = 0
        MOVE 1 TO hit-n
        MOVE line-slot TO hit-line
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
    *> P_BoxOnLineSide (#4): C boolean true⇒1; vertical xor when dy < 0.
    IF ldx = 0
        IF box-r < vtx-x(v1-slot)
            MOVE 1 TO p1
        ELSE
            MOVE 0 TO p1
        END-IF
        IF box-l < vtx-x(v1-slot)
            MOVE 1 TO p2
        ELSE
            MOVE 0 TO p2
        END-IF
        IF ldy < 0
            CALL "bit_xor" USING BY VALUE p1 BY VALUE 1 RETURNING p1
            CALL "bit_xor" USING BY VALUE p2 BY VALUE 1 RETURNING p2
        END-IF
    ELSE
        IF ldy = 0
            IF box-t > vtx-y(v1-slot)
                MOVE 1 TO p1
            ELSE
                MOVE 0 TO p1
            END-IF
            IF box-b > vtx-y(v1-slot)
                MOVE 1 TO p2
            ELSE
                MOVE 0 TO p2
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

death-yaw.
    IF ply-atk < 1 OR ply-atk > n-mobj
        EXIT PARAGRAPH
    END-IF
    IF mo-name(ply-atk) = SPACES
        EXIT PARAGRAPH
    END-IF
    CALL "point_to_angle" USING
        BY VALUE ply-x BY VALUE ply-y
        BY VALUE mo-x(ply-atk) BY VALUE mo-y(ply-atk)
        RETURNING aim-ang
    CALL "sub_i32" USING BY VALUE aim-ang BY VALUE ply-ang
        RETURNING delta-ang
    *> ANG5 = ANG90/18. Snap only while the gap is strictly inside it.
    *> ANG90/18 is 59652323.555. The snap test uses that float, so a gap
    *> of exactly 59652323 still faces the attacker.
    CALL "sub_i32" USING BY VALUE 0 BY VALUE ang5-n RETURNING tmp
    IF delta-ang > tmp AND delta-ang <= ang5-n
        MOVE aim-ang TO ply-ang
    ELSE
        IF delta-ang > 0
            CALL "add_i32" USING BY VALUE ply-ang BY VALUE ang5-n
                RETURNING ply-ang
        ELSE
            *> int(angle - ANG90/18) truncates toward zero, so the turn
            *> is 59652324 while the unsigned angle is at least that.
            IF ply-ang >= 0 AND ply-ang < 59652324
                CALL "sub_i32" USING BY VALUE ply-ang BY VALUE ang5-n
                    RETURNING ply-ang
            ELSE
                CALL "sub_i32" USING BY VALUE ply-ang BY VALUE 59652324
                    RETURNING ply-ang
            END-IF
        END-IF
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
01 rnd-n BINARY-LONG.
01 skip-dmg BINARY-LONG.

LINKAGE SECTION.
01 hurt-out BINARY-LONG.

PROCEDURE DIVISION USING hurt-out.
main-floor.
    MOVE 0 TO hurt-out
    IF ply-on = 0
        GOBACK
    END-IF
    *> Harbour P_PlayerInSpecialSector: z==floor; 4/16 rolls P_Random
    *> every tic while suited (before leveltime&0x1f); then damage.
    IF ply-room >= 1 AND ply-room <= n-sector
        AND ply-z = sec-floor-h(ply-room)
        MOVE sec-special(ply-room) TO spec-n
        IF spec-n = 9
            ADD 1 TO ply-secs
            MOVE 0 TO sec-special(ply-room)
        END-IF
        IF spec-n = 11
            MOVE 0 TO ply-god
            DIVIDE ply-time BY 32 GIVING q-n REMAINDER rem-n
            IF rem-n = 0 AND ply-hp > 0 AND ply-god = 0
                AND ply-inv = 0
                MOVE 20 TO dmg-n
                PERFORM apply-floor-dmg
            END-IF
            IF ply-hp <= 10 AND ply-exit = 0
                MOVE 1 TO ply-exit
            END-IF
        END-IF
        IF spec-n = 5 OR spec-n = 7 OR spec-n = 4 OR spec-n = 16
            MOVE 0 TO skip-dmg
            IF spec-n = 4 OR spec-n = 16
                IF ply-suit > 0
                    CALL "p-random" USING rnd-n
                    IF rnd-n >= 5
                        MOVE 1 TO skip-dmg
                    END-IF
                END-IF
            ELSE
                IF ply-suit > 0
                    MOVE 1 TO skip-dmg
                END-IF
            END-IF
            IF skip-dmg = 0
                DIVIDE ply-time BY 32 GIVING q-n REMAINDER rem-n
                IF rem-n = 0 AND ply-hp > 0 AND ply-god = 0
                    AND ply-inv = 0
                    MOVE 0 TO dmg-n
                    IF spec-n = 5
                        MOVE 10 TO dmg-n
                    END-IF
                    IF spec-n = 7
                        MOVE 5 TO dmg-n
                    END-IF
                    IF spec-n = 4 OR spec-n = 16
                        MOVE 20 TO dmg-n
                    END-IF
                    IF dmg-n > 0
                        PERFORM apply-floor-dmg
                    END-IF
                END-IF
            END-IF
        END-IF
    END-IF
    *> leveltime++ at end of tic (main), like Harbour/Python.
    GOBACK.

apply-floor-dmg.
    *> Sector damage has no source, so it clears the attacker.
    MOVE 0 TO ply-atk
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
        MOVE 1 TO hurt-out
        *> P_DamageMobj draws the pain chance after the hit lands.
        *> The player painchance is 255, so the draw is what keeps the
        *> random table aligned. A killing blow does not draw it.
        IF ply-hp > 0
            CALL "p-random" USING rnd-n
        END-IF
    END-IF
    .

END PROGRAM floor-tic.
