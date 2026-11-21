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
*> Monstros do episodio 1 e do Doom 2. Acordam, andam e atacam.
IDENTIFICATION DIVISION.
PROGRAM-ID. enemy-tic.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 dirs-on BINARY-LONG VALUE 0.
01 xs BINARY-LONG OCCURS 8 TIMES.
01 ys BINARY-LONG OCCURS 8 TIMES.
01 rnd-n BINARY-LONG.
01 rnd-a BINARY-LONG.
01 hear-id BINARY-LONG VALUE 0.
01 snd-name PIC X(6).
*> P_NoiseAlert: validcount (sec-mark) + soundtraversed (sec-trav) per flood;
*> sec-alert stays set like vanilla soundtarget (not cleared by later floods).
01 sec-mark BINARY-LONG OCCURS 512 TIMES.
01 sec-trav BINARY-LONG OCCURS 512 TIMES.
01 sec-alert BINARY-LONG OCCURS 512 TIMES.
01 n-q BINARY-LONG.
01 q-at BINARY-LONG.
01 q-sec BINARY-LONG OCCURS 512 TIMES.
01 q-blk BINARY-LONG OCCURS 512 TIMES.
01 hear-blk BINARY-LONG.
01 mo-i BINARY-LONG.
01 foe-j BINARY-LONG.
01 own-n BINARY-LONG.
01 aim-x BINARY-LONG.
01 aim-y BINARY-LONG.
01 aim-z BINARY-LONG.
01 aim-h BINARY-LONG.
01 aim-sec BINARY-LONG.
01 aim-rad BINARY-LONG.
01 aim-shadow BINARY-LONG.
01 hit-fr BINARY-LONG.
01 hit-mo BINARY-LONG.
01 who-i BINARY-LONG.
01 born-i BINARY-LONG.
01 bexp-a BINARY-LONG.
01 bexp-b BINARY-LONG.
01 bexp-c BINARY-LONG.
01 cls-n BINARY-LONG.
01 melee-go BINARY-LONG VALUE 0.
*> Lost-soul slam sets the spawn state during movement, so A_Look
*> runs this tic and the thinker then decrements that new tic.
01 slam-look BINARY-LONG VALUE 0.
*> Who blocked a lost-soul charge: -1 player, >0 monster slot, 0 a wall.
01 pit-hit BINARY-LONG VALUE 0.
01 spd-u BINARY-LONG.
01 ball-spd BINARY-LONG.
01 ball-mul BINARY-LONG.
01 shot-k BINARY-LONG.
01 ray-nopuff BINARY-LONG.
01 save-ang BINARY-LONG.
01 raised-n BINARY-LONG.
01 soul-n BINARY-LONG.
01 ball-name PIC X(4).
01 li BINARY-LONG.
01 bit-n BINARY-LONG.
01 tmp BINARY-LONG.
01 dx BINARY-LONG.
01 dy BINARY-LONG.
01 wx BINARY-LONG.
01 wy BINARY-LONG.
01 cs BINARY-LONG.
01 sn BINARY-LONG.
01 along BINARY-LONG.
01 dist-n BINARY-LONG.
01 see-ok BINARY-LONG.
01 face-ok BINARY-LONG.
01 need-face BINARY-LONG.
01 step-ok BINARY-LONG.
01 float-ok BINARY-LONG.
01 pick BINARY-LONG.
01 d2 BINARY-LONG.
01 d3 BINARY-LONG.
01 turn-d BINARY-LONG.
01 old-d BINARY-LONG.
01 scan-i BINARY-LONG.
01 nx BINARY-LONG.
01 ny BINARY-LONG.
01 nz BINARY-LONG.
01 ox BINARY-LONG.
01 oy BINARY-LONG.
01 tdx BINARY-LONG.
01 tdy BINARY-LONG.
01 side-bit BINARY-LONG.
01 side-a BINARY-LONG.
01 door-mode BINARY-LONG.
01 door-busy BINARY-LONG.
01 door-moved BINARY-LONG.
01 left-v BINARY-LONG.
01 right-v BINARY-LONG.
01 sh1 BINARY-LONG.
01 sh2 BINARY-LONG.
01 m1 BINARY-LONG.
01 m2 BINARY-LONG.
01 den BINARY-LONG.
01 numv BINARY-LONG.
01 frac BINARY-LONG.
01 eye-z BINARY-LONG.
01 slope-t BINARY-LONG.
01 slope-b BINARY-LONG.
01 did-cross BINARY-LONG.
01 blocked BINARY-LONG.
01 box-l BINARY-LONG.
01 box-r BINARY-LONG.
01 box-b BINARY-LONG.
01 box-t BINARY-LONG.
01 corner-n BINARY-LONG.
01 fs BINARY-LONG.
01 bs BINARY-LONG.
01 op-top BINARY-LONG.
01 op-bot BINARY-LONG.
01 clip-fl BINARY-LONG.
01 clip-cl BINARY-LONG.
01 save-fl BINARY-LONG.
01 save-cl BINARY-LONG.
01 seg-hit BINARY-LONG.
01 box-hit BINARY-LONG.
01 two-side BINARY-LONG.
01 mon-sec BINARY-LONG.
01 ply-sec BINARY-LONG.
01 walk-x BINARY-LONG.
01 walk-y BINARY-LONG.
01 sec-slot BINARY-LONG.
01 sub-slot BINARY-LONG.
01 sub-n BINARY-LONG.
01 bsp BINARY-LONG.
01 node-slot BINARY-LONG.
01 step-n BINARY-LONG.
01 reach BINARY-LONG.
01 slot BINARY-LONG.
01 units BINARY-LONG.
01 q-n BINARY-LONG.
01 rem-n BINARY-LONG.
01 dmg BINARY-LONG.
01 atk-on BINARY-LONG.
01 atk-x BINARY-LONG.
01 atk-y BINARY-LONG.
01 hurt-pl BINARY-LONG.
01 wall-fr BINARY-LONG.
01 ply-fr BINARY-LONG.
01 mask-n BINARY-LONG.
01 byte-i BINARY-LONG.
01 pnum BINARY-LONG.
01 other-sec BINARY-LONG.
01 new-blk BINARY-LONG.
01 keep-sec BINARY-LONG.
01 shot-keep BINARY-LONG.
*> P_CheckPosition / P_TryMove (same shape as walk-tic try-spot).
01 floor-z BINARY-LONG.
01 ceil-z BINARY-LONG.
01 drop-z BINARY-LONG.
01 open-top BINARY-LONG.
01 open-bot BINARY-LONG.
01 low-z BINARY-LONG.
01 seen-gen BINARY-LONG VALUE 0.
01 seen-ln BINARY-LONG OCCURS 3200 TIMES.
*> One generation per P_CheckSight, so a linedef is tested once.
01 sight-gen BINARY-LONG VALUE 0.
01 sight-seen BINARY-LONG OCCURS 3200 TIMES.
01 stk-n BINARY-LONG.
01 stk-bsp BINARY-LONG OCCURS 128 TIMES.
01 stk-ph BINARY-LONG OCCURS 128 TIMES.
01 stk-sd BINARY-LONG OCCURS 128 TIMES.
01 sg-slot BINARY-LONG.
01 sg-left BINARY-LONG.
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
*> P_Move lastspechit (special lines touched by failed TryMove).
01 n-spechit BINARY-LONG VALUE 0.
01 spechit-ln BINARY-LONG OCCURS 64 TIMES.
01 spechit-i BINARY-LONG.
01 opened-n BINARY-LONG.
01 use-ok BINARY-LONG.
01 dtype BINARY-LONG.
01 di BINARY-LONG.
01 nb BINARY-LONG.
01 low-h BINARY-LONG.
01 sec-index BINARY-LONG.
*> P_XYMovement for living monsters (mom from DamageMobj thrust).
01 xmove-n BINARY-LONG.
01 ymove-n BINARY-LONG.
COPY "mapstate.cpy".
COPY "movstate.cpy".
COPY "playstate.cpy".
COPY "sprstate.cpy".

LINKAGE SECTION.
01 moved-out BINARY-LONG.
01 pass-n BINARY-LONG.

PROCEDURE DIVISION USING moved-out pass-n.
main-enemy.
    *> 1 = missile pass, after light thinkers. Damage RNG must follow them.
    IF pass-n = 1
        PERFORM VARYING mo-i FROM 1 BY 1 UNTIL mo-i > n-mobj
            IF mo-kind(mo-i) = 4
                MOVE mo-i TO who-i
                PERFORM fly-ball
            END-IF
        END-PERFORM
        GOBACK
    END-IF
    IF dirs-on = 0
        PERFORM fill-dirs
        MOVE 1 TO dirs-on
    END-IF
    *> New level: drop stale soundtargets from the previous map.
    IF ply-time = 0 AND hear-id NOT = 0
        MOVE 0 TO hear-id
        PERFORM VARYING li FROM 1 BY 1 UNTIL li > 512
            MOVE 0 TO sec-alert(li)
            MOVE 0 TO sec-mark(li)
            MOVE 0 TO sec-trav(li)
        END-PERFORM
    END-IF
    MOVE 0 TO moved-out
    PERFORM hear-shot
    *> Sight / REJECT use the post-move player sector (XY already applied).
    MOVE ply-x TO walk-x
    MOVE ply-y TO walk-y
    PERFORM locate-sec
    MOVE sec-slot TO ply-sec
    PERFORM VARYING mo-i FROM 1 BY 1 UNTIL mo-i > n-mobj
        MOVE mo-i TO who-i
        *> A_Scream was noted in tick-fx. Run it here, in list order.
        IF mo-react(who-i) = 98
            MOVE 0 TO mo-react(who-i)
            MOVE who-i TO scream-slot
            CALL "gun-tic" USING bexp-a bexp-b bexp-c
        END-IF
        *> A_Fall was noted in gun tick-fx, before the player walk. Apply it now.
        IF mo-react(who-i) = 99
            CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE -3
                RETURNING mo-flags(who-i)
            MOVE 0 TO mo-react(who-i)
        END-IF
        *> Kind 4 flies in the later pass, after T_LightFlash.
        IF mo-kind(who-i) = 4
            CONTINUE
        ELSE
            *> Player rockets are kind 5 and already move in fly-bolts.
            *> They are not shootable, so the corpse slide below would
            *> run P_XYMovement and pin z to the floor. The next tic
            *> then dips under the floor and the blast hits the player.
            IF mo-kind(who-i) = 5
                EXIT PERFORM CYCLE
            END-IF
            CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 4
                RETURNING bit-n
            IF bit-n NOT = 0
                PERFORM think-one
            ELSE
                *> Corpses and the barrel fuse still slide (P_XYMovement).
                *> State (BEXP fuse) runs after the slide, in list order.
                IF mo-mx(who-i) NOT = 0 OR mo-my(who-i) NOT = 0
                    PERFORM mon-xy-move
                END-IF
                PERFORM body-fall
                IF mo-name(who-i) = "BEXP"
                    MOVE who-i TO bexp-slot
                    CALL "gun-tic" USING bexp-a bexp-b bexp-c
                END-IF
                PERFORM rise-dead
            END-IF
        END-IF
    END-PERFORM
    GOBACK.

rise-dead.
    IF ply-skill NOT = 4
        EXIT PARAGRAPH
    END-IF
    IF mo-hp(who-i) > 0 OR mo-kind(who-i) NOT = 3
        EXIT PARAGRAPH
    END-IF
    IF mo-name(who-i) = SPACES OR mo-name(who-i) = "BEXP"
        OR mo-name(who-i) = "BAR1" OR mo-max(who-i) < 1
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO mo-count(who-i)
    IF mo-count(who-i) < 420
        EXIT PARAGRAPH
    END-IF
    MOVE mo-max(who-i) TO mo-hp(who-i)
    MOVE 0 TO mo-frame(who-i)
    MOVE 0 TO mo-ai(who-i)
    MOVE 0 TO mo-kind(who-i)
    MOVE 0 TO mo-seq(who-i)
    MOVE 0 TO mo-step(who-i)
    MOVE 0 TO mo-count(who-i)
    MOVE 8 TO mo-wait(who-i)
    MOVE 0 TO mo-dir(who-i)
    MOVE 0 TO mo-mx(who-i)
    MOVE 0 TO mo-my(who-i)
    MOVE 4194310 TO mo-flags(who-i)
    CALL "mul_i32" USING BY VALUE mo-h(who-i) BY VALUE 4
        RETURNING mo-h(who-i)
    MOVE 1 TO moved-out
    .

fill-dirs.
    MOVE 65536 TO xs(1)
    MOVE 47000 TO xs(2)
    MOVE 0 TO xs(3)
    MOVE -47000 TO xs(4)
    MOVE -65536 TO xs(5)
    MOVE -47000 TO xs(6)
    MOVE 0 TO xs(7)
    MOVE 47000 TO xs(8)
    MOVE 0 TO ys(1)
    MOVE 47000 TO ys(2)
    MOVE 65536 TO ys(3)
    MOVE 47000 TO ys(4)
    MOVE 0 TO ys(5)
    MOVE -47000 TO ys(6)
    MOVE -65536 TO ys(7)
    *> dir 7 = SE: yspeed must be -47000 (was +47000 → same as NE).
    MOVE -47000 TO ys(8)
    .

think-one.
    MOVE 0 TO cls-n
    IF mo-name(who-i) = "POSS" OR mo-name(who-i) = "SPOS"
        OR mo-name(who-i) = "CPOS" OR mo-name(who-i) = "SSWV"
        OR mo-name(who-i) = "SPID"
        MOVE 1 TO cls-n
        MOVE 8 TO spd-u
    END-IF
    IF mo-name(who-i) = "SPID"
        MOVE 12 TO spd-u
    END-IF
    IF mo-name(who-i) = "TROO" OR mo-name(who-i) = "HEAD"
        OR mo-name(who-i) = "BSPI" OR mo-name(who-i) = "SKEL"
        OR mo-name(who-i) = "VILE" OR mo-name(who-i) = "PAIN"
        MOVE 2 TO cls-n
        MOVE 8 TO spd-u
    END-IF
    IF mo-name(who-i) = "BSPI" OR mo-name(who-i) = "SKEL"
        MOVE 10 TO spd-u
    END-IF
    IF mo-name(who-i) = "BSPI"
        MOVE 12 TO spd-u
    END-IF
    IF mo-name(who-i) = "VILE"
        MOVE 15 TO spd-u
    END-IF
    IF mo-name(who-i) = "SARG"
        MOVE 3 TO cls-n
        MOVE 10 TO spd-u
    END-IF
    IF mo-name(who-i) = "BOSS" OR mo-name(who-i) = "BOS2"
        OR mo-name(who-i) = "CYBR" OR mo-name(who-i) = "FATT"
        MOVE 4 TO cls-n
        MOVE 8 TO spd-u
    END-IF
    IF mo-name(who-i) = "CYBR"
        MOVE 16 TO spd-u
    END-IF
    IF mo-name(who-i) = "SKUL"
        MOVE 5 TO cls-n
        *> Chase speed is 8. SKULLSPEED 20 is only the charge mom.
        MOVE 8 TO spd-u
        *> Mom already cleared last tic: the charge slammed into a wall.
        CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 16777216
            RETURNING bit-n
        IF bit-n NOT = 0
            AND mo-mx(who-i) = 0 AND mo-my(who-i) = 0
            PERFORM skull-stop
        END-IF
    END-IF
    *> P_MobjThinker: P_XYMovement before state, including barrels (cls 0).
    IF mo-mx(who-i) NOT = 0 OR mo-my(who-i) NOT = 0
        PERFORM mon-xy-move
    END-IF
    PERFORM body-fall
    IF cls-n = 0
        EXIT PARAGRAPH
    END-IF
    *> P_ZMovement floats toward the target every tic, after XY.
    *> Idle monsters have no target yet, so they stay on the floor.
    IF mo-ai(who-i) NOT = 0
        CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 16384
            RETURNING bit-n
        IF bit-n NOT = 0
            PERFORM float-if-air
        END-IF
    END-IF
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 16777216
        RETURNING bit-n
    IF bit-n NOT = 0
        PERFORM skull-z
    END-IF
    *> P_ZMovement clamps every body, including floaters body-fall skips.
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 16384
        RETURNING bit-n
    IF bit-n NOT = 0
        PERFORM clamp-float
    END-IF
    if ply-skill = 4 AND spd-u > 0
        COMPUTE spd-u = spd-u * 2
    END-IF
    IF mo-ai(who-i) = 0
        PERFORM idle-one
    ELSE
        IF mo-ai(who-i) = 5
            PERFORM pain-one
        ELSE
            IF mo-ai(who-i) = 3
                PERFORM attack-one
            ELSE
                PERFORM chase-one
            END-IF
        END-IF
    END-IF
    .

idle-one.
    *> P_MobjThinker stand: tics-- then A_Look when tics hits 0 (same tic).
    MOVE mo-x(who-i) TO walk-x
    MOVE mo-y(who-i) TO walk-y
    PERFORM locate-sec
    MOVE sec-slot TO mon-sec
    *> A_Look: no wake on a dead player (MF_SHOOTABLE / health).
    IF ply-hp <= 0
        IF slam-look = 1
            MOVE 0 TO slam-look
            MOVE 9 TO mo-tic(who-i)
            MOVE 0 TO mo-thrs(who-i)
        ELSE
            IF mo-tic(who-i) > 0
                SUBTRACT 1 FROM mo-tic(who-i)
            END-IF
        END-IF
        EXIT PARAGRAPH
    END-IF
    IF mo-tic(who-i) > 0
        SUBTRACT 1 FROM mo-tic(who-i)
    END-IF
    IF mo-tic(who-i) > 0
        EXIT PARAGRAPH
    END-IF
    *> State loop S_*_STND, then A_Look (soundtarget first).
    *> FATT stand is 15 tics. Every other monster stand state is 10.
    IF mo-name(who-i) = "FATT"
        MOVE 15 TO mo-tic(who-i)
    ELSE
        MOVE 10 TO mo-tic(who-i)
    END-IF
    IF mo-frame(who-i) = 0
        MOVE 1 TO mo-frame(who-i)
    ELSE
        MOVE 0 TO mo-frame(who-i)
    END-IF
    MOVE 1 TO moved-out
    MOVE 0 TO see-ok
    *> Vanilla A_Look: any later shot may retarget. Threshold starts clear.
    MOVE 0 TO mo-thrs(who-i)
    *> Harbour A_Look: sector->soundtarget persists until a later flood overwrites
    *> that sector (do not require sec-mark = current hear-id).
    IF mon-sec >= 1 AND mon-sec <= 512
        IF sec-alert(mon-sec) = 1
            CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 32
                RETURNING bit-n
            IF bit-n = 0
                MOVE 1 TO see-ok
            ELSE
                *> MF_AMBUSH: gunshot only wakes with sight.
                MOVE 0 TO need-face
                PERFORM can-see
            END-IF
        END-IF
    END-IF
    IF see-ok = 0
        PERFORM look-for-player
    END-IF
    IF see-ok = 1
        PERFORM go-chase
    END-IF
    *> Spawn state was entered from P_XYMovement, before the thinker
    *> decrements tics. A failed look ends the fresh stand at 9.
    *> A wake leaves the chase wait one tic shorter for the same reason.
    IF slam-look = 1
        MOVE 0 TO slam-look
        IF mo-ai(who-i) = 0 AND mo-tic(who-i) > 0
            SUBTRACT 1 FROM mo-tic(who-i)
        END-IF
        IF mo-ai(who-i) = 2 AND mo-wait(who-i) > 0
            SUBTRACT 1 FROM mo-wait(who-i)
        END-IF
    END-IF
    .

pain-one.
    IF mo-wait(who-i) > 0
        SUBTRACT 1 FROM mo-wait(who-i)
        EXIT PARAGRAPH
    END-IF
    PERFORM go-chase
    .

cry-see.
    MOVE SPACES TO snd-name
    *> posit1/2/3 all roll P_Random%3, including the chaingunner's posit2.
    IF mo-name(who-i) = "POSS" OR mo-name(who-i) = "SPOS"
        OR mo-name(who-i) = "CPOS"
        PERFORM take-rnd
        DIVIDE rnd-n BY 3 GIVING q-n REMAINDER rem-n
        IF rem-n = 0
            MOVE "posit1" TO snd-name
        END-IF
        IF rem-n = 1
            MOVE "posit2" TO snd-name
        END-IF
        IF rem-n = 2
            MOVE "posit3" TO snd-name
        END-IF
    END-IF
    IF mo-name(who-i) = "TROO"
        PERFORM take-rnd
        CALL "bit_and" USING BY VALUE rnd-n BY VALUE 1 RETURNING bit-n
        IF bit-n = 0
            MOVE "bgsit1" TO snd-name
        ELSE
            MOVE "bgsit2" TO snd-name
        END-IF
    END-IF
    IF mo-name(who-i) = "SARG"
        MOVE "sgtsit" TO snd-name
    END-IF
    IF mo-name(who-i) = "BOSS"
        MOVE "brssit" TO snd-name
    END-IF
    IF mo-name(who-i) = "BOS2"
        MOVE "kntsit" TO snd-name
    END-IF
    IF mo-name(who-i) = "SSWV"
        MOVE "posit2" TO snd-name
    END-IF
    IF mo-name(who-i) = "HEAD"
        MOVE "cacsit" TO snd-name
    END-IF
    IF mo-name(who-i) = "SPID"
        MOVE "spisit" TO snd-name
    END-IF
    IF mo-name(who-i) = "BSPI"
        MOVE "bspsit" TO snd-name
    END-IF
    IF mo-name(who-i) = "CYBR"
        MOVE "cybsit" TO snd-name
    END-IF
    IF mo-name(who-i) = "VILE"
        MOVE "vilsit" TO snd-name
    END-IF
    IF mo-name(who-i) = "SKEL"
        MOVE "skesit" TO snd-name
    END-IF
    IF mo-name(who-i) = "FATT"
        MOVE "mansit" TO snd-name
    END-IF
    IF mo-name(who-i) = "PAIN"
        MOVE "pesit" TO snd-name
    END-IF
    IF snd-name NOT = SPACES
        CALL "sfx-play" USING snd-name
    END-IF
    .

go-chase.
    *> Harbour A_Look: does NOT clear movedir/movecount (#2).
    *> setMobjState(seestate) runs A_Chase in the same call.
    IF mo-ai(who-i) = 0
        *> Partial skull slam calls go-chase in place of A_Look.
        *> The sector soundtarget is the player; drop the body just hit.
        IF slam-look = 1
            *> A_Look clears threshold before it adopts the soundtarget.
            MOVE 0 TO mo-thrs(who-i)
            MOVE mo-x(who-i) TO walk-x
            MOVE mo-y(who-i) TO walk-y
            PERFORM locate-sec
            IF sec-slot >= 1 AND sec-slot <= 512
                IF sec-alert(sec-slot) = 1
                    MOVE 0 TO mo-tgt(who-i)
                END-IF
            END-IF
        END-IF
        PERFORM cry-see
    END-IF
    MOVE 2 TO mo-ai(who-i)
    MOVE 0 TO mo-wait(who-i)
    MOVE 0 TO mo-step(who-i)
    MOVE 1 TO moved-out
    PERFORM chase-one
    .

chase-one.
    IF ply-hp <= 0
        EXIT PARAGRAPH
    END-IF
    IF mo-wait(who-i) > 0
        SUBTRACT 1 FROM mo-wait(who-i)
        EXIT PARAGRAPH
    END-IF
    *> Harbour A_Chase: one reactiontime tick per A_Chase (not per gametic).
    IF mo-react(who-i) > 0
        SUBTRACT 1 FROM mo-react(who-i)
    END-IF
    ADD 1 TO mo-step(who-i)
    IF mo-step(who-i) > 8
        MOVE 1 TO mo-step(who-i)
    END-IF
    IF mo-step(who-i) <= 2
        MOVE 0 TO mo-frame(who-i)
    ELSE
        IF mo-step(who-i) <= 4
            MOVE 1 TO mo-frame(who-i)
        ELSE
    IF mo-step(who-i) <= 6
            MOVE 2 TO mo-frame(who-i)
        ELSE
            MOVE 3 TO mo-frame(who-i)
        END-IF
    END-IF
    END-IF
    *> See-state tics (info.c): POSS/FATT=4, SARG/SKEL/VILE=2, else 3.
    *> wait = tics-1 so the next A_Chase lines up with setMobjState.
    MOVE 2 TO mo-wait(who-i)
    IF mo-name(who-i) = "POSS" OR mo-name(who-i) = "FATT"
        MOVE 3 TO mo-wait(who-i)
    END-IF
    IF mo-name(who-i) = "SARG" OR mo-name(who-i) = "SKEL"
        OR mo-name(who-i) = "VILE"
        MOVE 1 TO mo-wait(who-i)
    END-IF
    *> S_SKULL_RUN is 6 tics, two frames.
    IF mo-name(who-i) = "SKUL"
        MOVE 5 TO mo-wait(who-i)
        DIVIDE mo-step(who-i) BY 2 GIVING q-n REMAINDER rem-n
        IF rem-n = 1
            MOVE 0 TO mo-frame(who-i)
        ELSE
            MOVE 1 TO mo-frame(who-i)
        END-IF
    END-IF
    MOVE 1 TO moved-out
    PERFORM one-chase
    .

one-chase.
    *> Dead or unshootable target: A_Chase looks, else spawnstate runs A_Look.
    IF mo-tgt(who-i) > 0
        MOVE mo-tgt(who-i) TO own-n
        MOVE 0 TO step-ok
        IF own-n > n-mobj
            MOVE 1 TO step-ok
        ELSE
            CALL "bit_and" USING BY VALUE mo-flags(own-n) BY VALUE 4
                RETURNING bit-n
            IF mo-hp(own-n) <= 0 OR bit-n = 0
                MOVE 1 TO step-ok
            END-IF
        END-IF
        IF step-ok = 1
            MOVE 0 TO mo-tgt(who-i)
            MOVE 0 TO mo-thrs(who-i)
            MOVE 0 TO need-face
            PERFORM can-see
            IF see-ok = 1
                EXIT PARAGRAPH
            END-IF
            PERFORM notice-player
            IF see-ok = 1
                PERFORM cry-see
            ELSE
                MOVE 0 TO mo-ai(who-i)
                MOVE 0 TO mo-frame(who-i)
                IF mo-name(who-i) = "FATT"
                    MOVE 15 TO mo-tic(who-i)
                ELSE
                    MOVE 10 TO mo-tic(who-i)
                END-IF
                EXIT PARAGRAPH
            END-IF
        END-IF
    END-IF
    *> A_Chase threshold: stick with the current target for BASETHRESHOLD calls.
    IF mo-thrs(who-i) > 0
        IF mo-tgt(who-i) > 0
            MOVE mo-tgt(who-i) TO own-n
            IF own-n > n-mobj OR mo-hp(own-n) <= 0
                MOVE 0 TO mo-thrs(who-i)
                MOVE 0 TO mo-tgt(who-i)
            ELSE
                SUBTRACT 1 FROM mo-thrs(who-i)
            END-IF
        ELSE
            SUBTRACT 1 FROM mo-thrs(who-i)
        END-IF
    END-IF
    *> MF_JUSTATTACKED: first A_Chase after missile only newChaseDir (no move/sound).
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 128
        RETURNING bit-n
    IF bit-n NOT = 0
        CALL "bit_xor" USING BY VALUE mo-flags(who-i) BY VALUE 128
            RETURNING mo-flags(who-i)
        PERFORM new-dir
        EXIT PARAGRAPH
    END-IF
    IF mo-name(who-i) = "VILE"
        PERFORM vile-raise
        IF raised-n = 1
            EXIT PARAGRAPH
        END-IF
    END-IF
    IF mo-dir(who-i) >= 0 AND mo-dir(who-i) < 8
        PERFORM face-dir
    END-IF
    PERFORM measure
    *> MELEERANGE - 20*FRAC + target radius. Player radius keeps the old 60*FRAC.
    COMPUTE reach = 2883584 + aim-rad
    IF cls-n = 2 OR cls-n = 3 OR cls-n = 4
        IF mo-name(who-i) NOT = "BSPI"
            AND mo-name(who-i) NOT = "CYBR"
            AND mo-name(who-i) NOT = "FATT"
            AND mo-name(who-i) NOT = "PAIN"
            AND mo-name(who-i) NOT = "VILE"
            IF dist-n < reach
                MOVE 0 TO need-face
                PERFORM can-see
                IF see-ok = 1
                    MOVE 1 TO melee-go
                    PERFORM go-attack
                    EXIT PARAGRAPH
                END-IF
            END-IF
        END-IF
    END-IF
    *> Harbour A_Chase: missile check while movecount==0, then --movecount/move.
    IF mo-count(who-i) = 0
        IF cls-n = 1 OR cls-n = 2 OR cls-n = 4
            OR mo-name(who-i) = "SKUL"
            PERFORM consider-shot
            IF mo-ai(who-i) = 3
                EXIT PARAGRAPH
            END-IF
        END-IF
    END-IF
    SUBTRACT 1 FROM mo-count(who-i)
    IF mo-count(who-i) < 0
        PERFORM new-dir
    ELSE
        PERFORM try-step
        IF step-ok = 0
            PERFORM new-dir
        END-IF
    END-IF
    *> A_Chase: always draw P_Random when MI_ACTIVESOUND is set.
    IF mo-name(who-i) = "POSS" OR mo-name(who-i) = "SPOS"
        OR mo-name(who-i) = "TROO" OR mo-name(who-i) = "SARG"
        OR mo-name(who-i) = "HEAD" OR mo-name(who-i) = "BOSS"
        OR mo-name(who-i) = "CPOS" OR mo-name(who-i) = "SSWV"
        OR mo-name(who-i) = "BOS2" OR mo-name(who-i) = "SPID"
        OR mo-name(who-i) = "BSPI" OR mo-name(who-i) = "CYBR"
        OR mo-name(who-i) = "SKEL" OR mo-name(who-i) = "FATT"
        OR mo-name(who-i) = "PAIN"         OR mo-name(who-i) = "VILE"
        OR mo-name(who-i) = "SKUL"
        PERFORM take-rnd
        IF rnd-n < 3
            PERFORM active-snd
        END-IF
    END-IF
    .

consider-shot.
    *> P_CheckMissileRange: sight only. FOV is A_Look, not this check.
    MOVE 0 TO need-face
    PERFORM can-see
    IF see-ok = 0
        EXIT PARAGRAPH
    END-IF
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 64
        RETURNING bit-n
    IF bit-n NOT = 0
        CALL "bit_xor" USING BY VALUE mo-flags(who-i) BY VALUE 64
            RETURNING mo-flags(who-i)
        PERFORM go-attack
        EXIT PARAGRAPH
    END-IF
    IF mo-react(who-i) > 0
        EXIT PARAGRAPH
    END-IF
    CALL "shar32" USING BY VALUE dist-n BY VALUE 16 RETURNING units
    SUBTRACT 64 FROM units
    *> No meleestate: P_CheckMissileRange subtracts another 128 units.
    IF mo-name(who-i) = "POSS" OR mo-name(who-i) = "SPOS"
        OR mo-name(who-i) = "CPOS" OR mo-name(who-i) = "SSWV"
        OR mo-name(who-i) = "SPID" OR mo-name(who-i) = "HEAD"
        OR mo-name(who-i) = "PAIN" OR mo-name(who-i) = "BSPI"
        OR mo-name(who-i) = "CYBR" OR mo-name(who-i) = "FATT"
        OR mo-name(who-i) = "VILE" OR mo-name(who-i) = "SKUL"
        SUBTRACT 128 FROM units
    END-IF
    IF units < 0
        MOVE 0 TO units
    END-IF
    *> MT_SKULL halves the distance before the 200 cap.
    IF mo-name(who-i) = "SKUL"
        DIVIDE units BY 2 GIVING units
    END-IF
    IF units > 200
        MOVE 200 TO units
    END-IF
    PERFORM take-rnd
    IF rnd-n < units
        EXIT PARAGRAPH
    END-IF
    PERFORM go-attack
    .

go-attack.
    *> setMobjState(missilestate): enter ATK1 same tic (sprite + FaceTarget).
    *> wait = tics-1 — attack-one always exits after decrement; advance next tic.
    MOVE 3 TO mo-ai(who-i)
    MOVE 1 TO mo-step(who-i)
    MOVE 4 TO mo-frame(who-i)
    MOVE 9 TO mo-wait(who-i)
    IF mo-name(who-i) = "TROO" OR mo-name(who-i) = "SARG"
        OR mo-name(who-i) = "BOSS" OR mo-name(who-i) = "BOS2"
        MOVE 7 TO mo-wait(who-i)
    END-IF
    *> HEAD and PAIN ATK1 are 5 tics, not the imp's 8.
    IF mo-name(who-i) = "HEAD" OR mo-name(who-i) = "PAIN"
        MOVE 4 TO mo-wait(who-i)
    END-IF
    *> S_FATT_ATK1 is 20 tics, frame 6. FatRaise runs on entry.
    IF mo-name(who-i) = "FATT"
        MOVE 6 TO mo-frame(who-i)
        MOVE 19 TO mo-wait(who-i)
    END-IF
    *> Missile only. Melee (demon/spectre) must not set MF_JUSTATTACKED
    *> or the next A_Chase skips the move and the spectre drifts.
    IF melee-go = 0
        CALL "bit_or" USING BY VALUE mo-flags(who-i) BY VALUE 128
            RETURNING mo-flags(who-i)
    END-IF
    IF melee-go = 1 AND mo-name(who-i) = "SARG"
        MOVE "sgtatk" TO snd-name
        CALL "sfx-play" USING snd-name
    END-IF
    MOVE 0 TO melee-go
    IF mo-name(who-i) = "SKUL"
        MOVE 2 TO mo-frame(who-i)
    END-IF
    PERFORM face-player
    IF mo-name(who-i) = "FATT"
        MOVE "manatk" TO snd-name
        CALL "sfx-play" USING snd-name
    END-IF
    MOVE 1 TO moved-out
    .

face-player.
    *> A_FaceTarget: player, or the monster this one is fighting.
    PERFORM load-aim
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 32
        RETURNING bit-n
    IF bit-n NOT = 0
        CALL "bit_xor" USING BY VALUE mo-flags(who-i) BY VALUE 32
            RETURNING mo-flags(who-i)
    END-IF
    CALL "point_to_angle" USING
        BY VALUE mo-x(who-i) BY VALUE mo-y(who-i)
        BY VALUE aim-x BY VALUE aim-y
        RETURNING mo-ang(who-i)
    PERFORM face-shadow
    .

face-shadow.
    *> Target MF_SHADOW (player invis or spectre): (P_Random-P_Random)*<<21.
    IF aim-shadow = 0
        EXIT PARAGRAPH
    END-IF
    PERFORM take-rnd
    MOVE rnd-n TO rnd-a
    PERFORM take-rnd
    SUBTRACT rnd-n FROM rnd-a
    CALL "mul_i32" USING BY VALUE rnd-a BY VALUE 2097152
        RETURNING tmp
    CALL "add_i32" USING BY VALUE mo-ang(who-i) BY VALUE tmp
        RETURNING mo-ang(who-i)
    .

attack-one.
    *> wait = tics-1; decrement always exits; wait already 0 → next ATK state.
    *> A shot already started still fires after the player dies (A_SPosAttack).
    IF mo-wait(who-i) > 0
        SUBTRACT 1 FROM mo-wait(who-i)
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO mo-step(who-i)
    IF cls-n = 1
        PERFORM zom-enter
    ELSE
        PERFORM imp-enter
    END-IF
    .

zom-enter.
    *> Chaingunner is not the zombie pattern: two 4-tic shots, then refire.
    IF mo-name(who-i) = "CPOS"
        PERFORM cpos-atk
        EXIT PARAGRAPH
    END-IF
    *> ATK2 PosAttack (POSS wait 7 / SPOS 9); ATK3 recovery; then seestate.
    IF mo-step(who-i) = 2
        MOVE 5 TO mo-frame(who-i)
        MOVE 7 TO mo-wait(who-i)
        IF mo-name(who-i) = "SPOS"
            OR mo-name(who-i) = "SSWV" OR mo-name(who-i) = "SPID"
            MOVE 9 TO mo-wait(who-i)
        END-IF
        PERFORM face-player
        MOVE 1 TO moved-out
        PERFORM zom-shot
        EXIT PARAGRAPH
    END-IF
    IF mo-step(who-i) = 3
        MOVE 4 TO mo-frame(who-i)
        MOVE 7 TO mo-wait(who-i)
        IF mo-name(who-i) = "SPOS"
            OR mo-name(who-i) = "SSWV"
            MOVE 9 TO mo-wait(who-i)
        END-IF
        EXIT PARAGRAPH
    END-IF
    PERFORM go-chase
    .

cpos-atk.
    *> ATK2 and ATK3: A_CPosAttack, 4 tics each.
    IF mo-step(who-i) = 2 OR mo-step(who-i) = 3
        MOVE 5 TO mo-frame(who-i)
        MOVE 3 TO mo-wait(who-i)
        PERFORM face-player
        MOVE 1 TO moved-out
        PERFORM zom-shot
        EXIT PARAGRAPH
    END-IF
    *> ATK4: 1 tic. A_CPosRefire usually returns to ATK2.
    IF mo-step(who-i) = 4
        PERFORM face-player
        PERFORM take-rnd
        IF rnd-n >= 40
            IF mo-tgt(who-i) = 0
                IF ply-hp <= 0
                    PERFORM go-chase
                    EXIT PARAGRAPH
                END-IF
            ELSE
                MOVE mo-tgt(who-i) TO own-n
                IF own-n < 1 OR own-n > n-mobj
                    OR mo-hp(own-n) <= 0
                    PERFORM go-chase
                    EXIT PARAGRAPH
                END-IF
            END-IF
            MOVE 0 TO need-face
            PERFORM can-see
            IF see-ok = 0
                PERFORM go-chase
                EXIT PARAGRAPH
            END-IF
        END-IF
        *> Next attack tic enters ATK2 and fires.
        MOVE 1 TO mo-step(who-i)
        MOVE 0 TO mo-wait(who-i)
        MOVE 1 TO moved-out
        EXIT PARAGRAPH
    END-IF
    PERFORM go-chase
    .

imp-enter.
    *> Mancubus: FatRaise, then three 2-shot attacks with face frames between.
    IF mo-name(who-i) = "FATT"
        PERFORM fatt-enter
        EXIT PARAGRAPH
    END-IF
    *> Lost soul: one A_SkullAttack, then the ATK3/ATK4 loop until the slam.
    IF mo-name(who-i) = "SKUL"
        IF mo-step(who-i) = 2
            PERFORM skull-charge
            MOVE 3 TO mo-frame(who-i)
            MOVE 3 TO mo-wait(who-i)
            MOVE 1 TO moved-out
            EXIT PARAGRAPH
        END-IF
        MOVE 3 TO mo-wait(who-i)
        DIVIDE mo-step(who-i) BY 2 GIVING q-n REMAINDER rem-n
        IF rem-n = 1
            MOVE 2 TO mo-frame(who-i)
        ELSE
            MOVE 3 TO mo-frame(who-i)
        END-IF
        MOVE 1 TO moved-out
        EXIT PARAGRAPH
    END-IF
    *> ATK2 FaceTarget. Imp/baron are 8 tics; cacodemon and pain elemental are 5.
    IF mo-step(who-i) = 2
        MOVE 5 TO mo-frame(who-i)
        MOVE 7 TO mo-wait(who-i)
        IF mo-name(who-i) = "HEAD" OR mo-name(who-i) = "PAIN"
            MOVE 4 TO mo-wait(who-i)
        END-IF
        PERFORM face-player
        MOVE 1 TO moved-out
        EXIT PARAGRAPH
    END-IF
    IF mo-step(who-i) = 3
        *> Pain elemental's third frame is still FaceTarget. The shot is a
        *> 0-tic state on the way back to chase.
        IF mo-name(who-i) = "PAIN"
            MOVE 6 TO mo-frame(who-i)
            MOVE 4 TO mo-wait(who-i)
            PERFORM face-player
            MOVE 1 TO moved-out
            EXIT PARAGRAPH
        END-IF
        MOVE 6 TO mo-frame(who-i)
        *> TROO ATK3 tics=6 → wait 5; SARG ATK3 tics=8 → wait 7.
        *> HEAD ATK3 is 5 tics and fires on entry (A_HeadAttack).
        MOVE 5 TO mo-wait(who-i)
        IF mo-name(who-i) = "SARG"
            MOVE 7 TO mo-wait(who-i)
        END-IF
        IF mo-name(who-i) = "HEAD"
            MOVE 4 TO mo-wait(who-i)
        END-IF
        PERFORM face-player
        MOVE 1 TO moved-out
        PERFORM imp-fire
        EXIT PARAGRAPH
    END-IF
    IF mo-name(who-i) = "PAIN"
        PERFORM face-player
        PERFORM imp-fire
    END-IF
    PERFORM go-chase
    .

zom-shot.
    *> A_SPosAttack / A_SpidRefire: 3 pellets; A_PosAttack / A_CPosAttack: 1.
    MOVE 1 TO shot-k
    IF mo-name(who-i) = "SPOS" OR mo-name(who-i) = "SPID"
        MOVE 3 TO shot-k
    END-IF
    *> Sound once before the volley (Harbour/Node).
    IF mo-name(who-i) = "CPOS" OR mo-name(who-i) = "SPID"
        OR mo-name(who-i) = "SPOS"
        MOVE "shotgn" TO snd-name
    ELSE
        MOVE "pistol" TO snd-name
    END-IF
    CALL "sfx-play" USING snd-name
    *> One aim slope at the faced angle; every pellet keeps it.
    MOVE who-i TO ray-slot
    MOVE mo-ang(who-i) TO ray-ang
    MOVE 1 TO ray-mode
    CALL "gun-tic" USING bexp-a bexp-b bexp-c
    MOVE 0 TO ray-nopuff
    PERFORM shot-k TIMES
        PERFORM zom-once
    END-PERFORM
    .

zom-once.
    *> Spread then damage RNG always (even on miss) — matches LineAttack args.
    MOVE mo-ang(who-i) TO tmp
    PERFORM take-rnd
    MOVE rnd-n TO rnd-a
    PERFORM take-rnd
    SUBTRACT rnd-n FROM rnd-a
    CALL "shl_i" USING BY VALUE rnd-a BY VALUE 20 RETURNING dx
    CALL "add_i32" USING BY VALUE tmp BY VALUE dx RETURNING tmp
    MOVE tmp TO shot-keep
    PERFORM take-rnd
    DIVIDE rnd-n BY 5 GIVING q-n REMAINDER rem-n
    ADD 1 TO rem-n
    MULTIPLY rem-n BY 3 GIVING dmg
    PERFORM ray-player
    .

imp-fire.
    MOVE 655360 TO ball-spd
    MOVE 3 TO ball-mul
    IF mo-name(who-i) = "SARG"
        *> A_SargAttack: ((P_Random%10)+1)*4, only while still in melee range.
        *> Out of range draws no RNG (demon/spectre has no missile).
        PERFORM measure
        *> P_CheckMeleeRange: 64-20 units plus the target radius.
        *> A demon is wider than the player, so the bite reaches farther.
        COMPUTE reach = 2883584 + aim-rad
        IF dist-n < reach
            MOVE 0 TO need-face
            PERFORM can-see
            IF see-ok = 1
                PERFORM take-rnd
                DIVIDE rnd-n BY 10 GIVING q-n REMAINDER rem-n
                ADD 1 TO rem-n
                MULTIPLY rem-n BY 4 GIVING dmg
                PERFORM aim-hurt
            END-IF
        END-IF
        EXIT PARAGRAPH
    END-IF
    IF mo-name(who-i) = "CYBR"
        PERFORM cyber-fire
        EXIT PARAGRAPH
    END-IF
    IF mo-name(who-i) = "FATT"
        PERFORM fat-fire
        EXIT PARAGRAPH
    END-IF
    IF mo-name(who-i) = "BSPI"
        PERFORM plasma-fire
        EXIT PARAGRAPH
    END-IF
    IF mo-name(who-i) = "PAIN"
        PERFORM pain-fire
        EXIT PARAGRAPH
    END-IF
    IF mo-name(who-i) = "VILE"
        PERFORM vile-fire
        EXIT PARAGRAPH
    END-IF
    PERFORM measure
    *> P_CheckMeleeRange: MELEERANGE - 20*FRACUNIT + target radius.
    *> Player radius is 16, so the bite reaches 60 units.
    COMPUTE reach = 2883584 + aim-rad
    IF mo-name(who-i) = "SKEL" AND dist-n < reach
        MOVE "skeswg" TO snd-name
        CALL "sfx-play" USING snd-name
        PERFORM take-rnd
        DIVIDE rnd-n BY 8 GIVING q-n REMAINDER rem-n
        ADD 1 TO rem-n
        MULTIPLY rem-n BY 6 GIVING dmg
        PERFORM aim-hurt
        EXIT PARAGRAPH
    END-IF
    IF mo-name(who-i) = "SKEL"
        MOVE "skeatk" TO snd-name
        CALL "sfx-play" USING snd-name
        MOVE "FATB" TO ball-name
        MOVE 10 TO ball-mul
        PERFORM spawn-ball
        IF n-mobj >= 1
            MOVE 10 TO mo-hp(n-mobj)
        END-IF
        EXIT PARAGRAPH
    END-IF
    IF dist-n < reach
        IF cls-n = 3
            MOVE "sgtatk" TO snd-name
        ELSE
            MOVE "claw" TO snd-name
        END-IF
        CALL "sfx-play" USING snd-name
        PERFORM take-rnd
        DIVIDE rnd-n BY 8 GIVING q-n REMAINDER rem-n
        ADD 1 TO rem-n
        IF cls-n = 4
            MULTIPLY rem-n BY 10 GIVING dmg
        ELSE
            MULTIPLY rem-n BY 3 GIVING dmg
        END-IF
        PERFORM aim-hurt
    ELSE
        MOVE "BAL1" TO ball-name
        IF cls-n = 4
            MOVE "BAL7" TO ball-name
            *> MT_BRUISERSHOT damage is 8, not the imp's 3.
            MOVE 8 TO ball-mul
        END-IF
        IF mo-name(who-i) = "HEAD"
            MOVE "BAL2" TO ball-name
            *> MT_HEADSHOT damage is 5.
            MOVE 5 TO ball-mul
        END-IF
        IF cls-n = 4
            MOVE "bospit" TO snd-name
        ELSE
            MOVE "firsht" TO snd-name
        END-IF
        CALL "sfx-play" USING snd-name
        PERFORM spawn-ball
    END-IF
    .

aim-hurt.
    *> Melee lands on the chase target. 0 is the player.
    IF mo-tgt(who-i) > 0 AND mo-tgt(who-i) <= n-mobj
        MOVE dmg TO hit-dmg
        MOVE who-i TO hit-who
        MOVE mo-tgt(who-i) TO hit-slot
        MOVE 0 TO hit-from
        CALL "gun-tic" USING bexp-a bexp-b bexp-c
    ELSE
        PERFORM hurt-player
    END-IF
    .

hurt-player.
    *> P_DamageMobj (player): thrust on full dmg, then armor, then hp.
    IF ply-god = 1 OR ply-inv > 0
        EXIT PARAGRAPH
    END-IF
    *> Already dead: vanilla returns before touching attacker.
    IF ply-hp > 0
        *> Source, not the missile. A fireball's shooter is mo-count.
        MOVE 0 TO ply-atk
        IF who-i >= 1 AND who-i <= n-mobj
            IF mo-kind(who-i) = 4
                MOVE mo-count(who-i) TO ply-atk
            ELSE
                IF mo-kind(who-i) NOT = 5
                    MOVE who-i TO ply-atk
                END-IF
            END-IF
        END-IF
        IF ply-atk < 1 OR ply-atk > n-mobj
            MOVE 0 TO ply-atk
        END-IF
    END-IF
    MOVE dmg TO shot-keep
    IF ply-skill = 0
        DIVIDE dmg BY 2 GIVING dmg
        MOVE dmg TO shot-keep
    END-IF
    MOVE 0 TO atk-on
    IF who-i >= 1 AND who-i <= n-mobj
        MOVE 1 TO atk-on
        MOVE mo-x(who-i) TO atk-x
        MOVE mo-y(who-i) TO atk-y
        CALL "push-ply" USING shot-keep atk-x atk-y
    END-IF
    IF ply-atype > 0 AND ply-armor > 0
        IF ply-atype = 1
            DIVIDE dmg BY 3 GIVING m1
        ELSE
            DIVIDE dmg BY 2 GIVING m1
        END-IF
        IF m1 > ply-armor
            MOVE ply-armor TO m1
            MOVE 0 TO ply-atype
        ELSE
            IF m1 = ply-armor
                MOVE 0 TO ply-atype
            END-IF
        END-IF
        SUBTRACT m1 FROM ply-armor
        SUBTRACT m1 FROM dmg
    END-IF
    IF dmg > 0
        SUBTRACT dmg FROM ply-hp
        IF ply-hp < 0
            MOVE 0 TO ply-hp
        END-IF
        ADD dmg TO ply-pain
        IF ply-pain > 100
            MOVE 100 TO ply-pain
        END-IF
    END-IF
    CALL "face-hit" USING dmg atk-on atk-x atk-y
    CALL "ply-ouch"
    *> painOrWake: always consume P_Random (player painchance).
    PERFORM take-rnd
    MOVE 1 TO moved-out
    .

cyber-fire.
    MOVE "rlaunc" TO snd-name
    CALL "sfx-play" USING snd-name
    MOVE "MISL" TO ball-name
    MOVE 1310720 TO ball-spd
    MOVE 3 TO ball-mul
    PERFORM spawn-ball
    IF n-mobj >= 1
        MOVE 20 TO mo-hp(n-mobj)
    END-IF
    .

fatt-enter.
    *> Steps are S_FATT_ATK2 .. ATK10. ATK1 was the go-attack entry.
    IF mo-step(who-i) = 2 OR mo-step(who-i) = 5 OR mo-step(who-i) = 8
        MOVE 32775 TO mo-frame(who-i)
        MOVE 9 TO mo-wait(who-i)
    ELSE
        IF mo-step(who-i) = 3 OR mo-step(who-i) = 6 OR mo-step(who-i) = 9
            MOVE 8 TO mo-frame(who-i)
            MOVE 4 TO mo-wait(who-i)
        ELSE
            IF mo-step(who-i) = 4 OR mo-step(who-i) = 7
                OR mo-step(who-i) = 10
                MOVE 6 TO mo-frame(who-i)
                MOVE 4 TO mo-wait(who-i)
            ELSE
                PERFORM go-chase
                EXIT PARAGRAPH
            END-IF
        END-IF
    END-IF
    IF mo-step(who-i) = 2
        PERFORM fatt-atk1
    END-IF
    IF mo-step(who-i) = 5
        PERFORM fatt-atk2
    END-IF
    IF mo-step(who-i) = 8
        PERFORM fatt-atk3
    END-IF
    IF mo-step(who-i) = 3 OR mo-step(who-i) = 4
        OR mo-step(who-i) = 6 OR mo-step(who-i) = 7
        OR mo-step(who-i) = 9 OR mo-step(who-i) = 10
        PERFORM face-player
    END-IF
    MOVE 1 TO moved-out
    .

fatt-arm.
    MOVE "MANF" TO ball-name
    MOVE 1310720 TO ball-spd
    MOVE 8 TO ball-mul
    .

fatt-aim.
    *> P_SpawnMissile aims with R_PointToAngle2, not the actor angle.
    PERFORM load-aim
    CALL "point_to_angle" USING
        BY VALUE mo-x(who-i) BY VALUE mo-y(who-i)
        BY VALUE aim-x BY VALUE aim-y
        RETURNING shot-keep
    IF aim-shadow = 1
        PERFORM take-rnd
        MOVE rnd-n TO rnd-a
        PERFORM take-rnd
        SUBTRACT rnd-n FROM rnd-a
        CALL "mul_i32" USING BY VALUE rnd-a BY VALUE 1048576
            RETURNING tmp
        CALL "add_i32" USING BY VALUE shot-keep BY VALUE tmp
            RETURNING shot-keep
    END-IF
    .

fatt-spawn.
    MOVE mo-ang(who-i) TO save-ang
    MOVE shot-keep TO mo-ang(who-i)
    PERFORM spawn-ball
    MOVE save-ang TO mo-ang(who-i)
    .

fatt-mom.
    IF born-i < 1 OR born-i > n-mobj
        EXIT PARAGRAPH
    END-IF
    CALL "fine_cos_ang" USING BY VALUE mo-ang(born-i) RETURNING cs
    CALL "fine_sin_ang" USING BY VALUE mo-ang(born-i) RETURNING sn
    CALL "fixed_mul" USING BY VALUE ball-spd BY VALUE cs
        RETURNING mo-mx(born-i)
    CALL "fixed_mul" USING BY VALUE ball-spd BY VALUE sn
        RETURNING mo-my(born-i)
    .

fatt-atk1.
    *> A_FatAttack1: face, actor += FATSPREAD, two shots. Only the
    *> second missile's angle (and mom) gains another FATSPREAD.
    PERFORM face-player
    CALL "add_i32" USING BY VALUE mo-ang(who-i) BY VALUE 134217728
        RETURNING mo-ang(who-i)
    PERFORM fatt-arm
    PERFORM fatt-aim
    PERFORM fatt-spawn
    PERFORM fatt-aim
    PERFORM fatt-spawn
    IF born-i >= 1 AND born-i <= n-mobj
        CALL "add_i32" USING BY VALUE mo-ang(born-i) BY VALUE 134217728
            RETURNING mo-ang(born-i)
        PERFORM fatt-mom
    END-IF
    .

fatt-atk2.
    *> A_FatAttack2: actor -= FATSPREAD. Second missile -= 2*FATSPREAD.
    PERFORM face-player
    CALL "sub_i32" USING BY VALUE mo-ang(who-i) BY VALUE 134217728
        RETURNING mo-ang(who-i)
    PERFORM fatt-arm
    PERFORM fatt-aim
    PERFORM fatt-spawn
    PERFORM fatt-aim
    PERFORM fatt-spawn
    IF born-i >= 1 AND born-i <= n-mobj
        CALL "sub_i32" USING BY VALUE mo-ang(born-i) BY VALUE 268435456
            RETURNING mo-ang(born-i)
        PERFORM fatt-mom
    END-IF
    .

fatt-atk3.
    *> A_FatAttack3: both missiles spawn on target, then their angles
    *> become the faced actor angle +/- FATSPREAD/2.
    PERFORM face-player
    PERFORM fatt-arm
    PERFORM fatt-aim
    PERFORM fatt-spawn
    IF born-i >= 1 AND born-i <= n-mobj
        CALL "sub_i32" USING BY VALUE mo-ang(who-i) BY VALUE 67108864
            RETURNING mo-ang(born-i)
        PERFORM fatt-mom
    END-IF
    PERFORM fatt-aim
    PERFORM fatt-spawn
    IF born-i >= 1 AND born-i <= n-mobj
        CALL "add_i32" USING BY VALUE mo-ang(who-i) BY VALUE 67108864
            RETURNING mo-ang(born-i)
        PERFORM fatt-mom
    END-IF
    .

fat-fire.
    MOVE "firsht" TO snd-name
    CALL "sfx-play" USING snd-name
    MOVE "MANF" TO ball-name
    MOVE 1310720 TO ball-spd
    MOVE 3 TO ball-mul
    MOVE mo-ang(who-i) TO save-ang
    CALL "sub_i32" USING BY VALUE save-ang BY VALUE 134217728
        RETURNING mo-ang(who-i)
    PERFORM spawn-ball
    IF n-mobj >= 1
        MOVE 8 TO mo-hp(n-mobj)
    END-IF
    MOVE save-ang TO mo-ang(who-i)
    PERFORM spawn-ball
    IF n-mobj >= 1
        MOVE 8 TO mo-hp(n-mobj)
    END-IF
    CALL "add_i32" USING BY VALUE save-ang BY VALUE 134217728
        RETURNING mo-ang(who-i)
    PERFORM spawn-ball
    IF n-mobj >= 1
        MOVE 8 TO mo-hp(n-mobj)
    END-IF
    MOVE save-ang TO mo-ang(who-i)
    .

plasma-fire.
    MOVE "plasma" TO snd-name
    CALL "sfx-play" USING snd-name
    MOVE "APLS" TO ball-name
    MOVE 1638400 TO ball-spd
    MOVE 3 TO ball-mul
    PERFORM spawn-ball
    IF n-mobj >= 1
        MOVE 5 TO mo-hp(n-mobj)
    END-IF
    .

pain-fire.
    MOVE 0 TO soul-n
    PERFORM VARYING foe-j FROM 1 BY 1 UNTIL foe-j > n-mobj
        IF mo-name(foe-j) = "SKUL" AND mo-hp(foe-j) > 0
            ADD 1 TO soul-n
        END-IF
    END-PERFORM
    IF soul-n >= 20
        EXIT PARAGRAPH
    END-IF
    MOVE "sklatk" TO snd-name
    CALL "sfx-play" USING snd-name
    PERFORM spawn-soul
    .

vile-fire.
    MOVE "vilatk" TO snd-name
    CALL "sfx-play" USING snd-name
    MOVE 20 TO dmg
    PERFORM hurt-player
    .

spawn-ball.
    CALL "fine_cos_ang" USING BY VALUE mo-ang(who-i) RETURNING cs
    CALL "fine_sin_ang" USING BY VALUE mo-ang(who-i) RETURNING sn
    CALL "alloc-mobj" USING born-i
    IF born-i = 0
        PERFORM take-rnd
        PERFORM take-rnd
        EXIT PARAGRAPH
    END-IF
    *> P_SpawnMissile: at the shooter, z+32. Not 32 units along the aim.
    MOVE mo-x(who-i) TO mo-x(born-i)
    MOVE mo-y(who-i) TO mo-y(born-i)
    CALL "add_i32" USING BY VALUE mo-z(who-i) BY VALUE 2097152
        RETURNING mo-z(born-i)
    MOVE ball-name TO mo-name(born-i)
    MOVE 32768 TO mo-frame(born-i)
    MOVE 0 TO mo-flags(born-i)
    MOVE 4 TO mo-kind(born-i)
    MOVE 0 TO mo-ai(born-i)
    MOVE 0 TO mo-step(born-i)
    MOVE mo-ang(who-i) TO mo-ang(born-i)
    MOVE 524288 TO mo-h(born-i)
    MOVE 393216 TO mo-rad(born-i)
    CALL "fixed_mul" USING BY VALUE ball-spd BY VALUE cs
        RETURNING mo-mx(born-i)
    CALL "fixed_mul" USING BY VALUE ball-spd BY VALUE sn
        RETURNING mo-my(born-i)
    PERFORM measure
    IF ball-spd = 0
        MOVE 1 TO units
    ELSE
        DIVIDE dist-n BY ball-spd GIVING units
    END-IF
    IF units < 1
        MOVE 1 TO units
    END-IF
    *> momz = (target.z - source.z) / steps. Damage die is info.damage, rolled on impact.
    CALL "sub_i32" USING BY VALUE aim-z BY VALUE mo-z(who-i)
        RETURNING tmp
    DIVIDE tmp BY units GIVING mo-mz(born-i)
    MOVE ball-mul TO mo-hp(born-i)
    *> PIT_CheckThing skips the shooter (tmthing->target).
    MOVE who-i TO mo-count(born-i)
    *> spawnMobj lastlook, then P_CheckMissileSpawn (tics jitter + half-mom nudge).
    PERFORM take-rnd
    CALL "bit_and" USING BY VALUE rnd-n BY VALUE 3
        RETURNING mo-look(born-i)
    PERFORM take-rnd
    CALL "shar32" USING BY VALUE mo-mx(born-i) BY VALUE 1 RETURNING dx
    CALL "add_i32" USING BY VALUE mo-x(born-i) BY VALUE dx
        RETURNING mo-x(born-i)
    CALL "shar32" USING BY VALUE mo-my(born-i) BY VALUE 1 RETURNING dy
    CALL "add_i32" USING BY VALUE mo-y(born-i) BY VALUE dy
        RETURNING mo-y(born-i)
    CALL "shar32" USING BY VALUE mo-mz(born-i) BY VALUE 1 RETURNING tmp
    CALL "add_i32" USING BY VALUE mo-z(born-i) BY VALUE tmp
        RETURNING mo-z(born-i)
    MOVE 1 TO moved-out
    .

spawn-soul.
    CALL "fine_cos_ang" USING BY VALUE mo-ang(who-i) RETURNING cs
    CALL "fine_sin_ang" USING BY VALUE mo-ang(who-i) RETURNING sn
    CALL "fixed_mul" USING BY VALUE cs BY VALUE 2097152 RETURNING dx
    CALL "fixed_mul" USING BY VALUE sn BY VALUE 2097152 RETURNING dy
    CALL "alloc-mobj" USING born-i
    IF born-i = 0
        EXIT PARAGRAPH
    END-IF
    CALL "add_i32" USING BY VALUE mo-x(who-i) BY VALUE dx
        RETURNING mo-x(born-i)
    CALL "add_i32" USING BY VALUE mo-y(who-i) BY VALUE dy
        RETURNING mo-y(born-i)
    MOVE mo-z(who-i) TO mo-z(born-i)
    MOVE "SKUL" TO mo-name(born-i)
    MOVE 0 TO mo-frame(born-i)
    *> SOLID|SHOOTABLE|COUNTKILL plus FLOAT|NOGRAVITY (not snapped to the floor).
    MOVE 4212742 TO mo-flags(born-i)
    MOVE 0 TO mo-kind(born-i)
    MOVE 4 TO mo-ai(born-i)
    MOVE 0 TO mo-step(born-i)
    MOVE 0 TO mo-seq(born-i)
    MOVE 0 TO mo-tic(born-i)
    MOVE 0 TO mo-count(born-i)
    MOVE 0 TO mo-dir(born-i)
    MOVE 0 TO mo-wait(born-i)
    MOVE mo-ang(who-i) TO mo-ang(born-i)
    MOVE 3670016 TO mo-h(born-i)
    MOVE 1048576 TO mo-rad(born-i)
    MOVE 100 TO mo-hp(born-i)
    MOVE 100 TO mo-max(born-i)
    MOVE 0 TO mo-mx(born-i)
    MOVE 0 TO mo-my(born-i)
    MOVE 0 TO mo-mz(born-i)
    MOVE 1 TO moved-out
    .

skul-one.
    IF ply-hp <= 0
        EXIT PARAGRAPH
    END-IF
    IF mo-frame(who-i) = 0
        MOVE 1 TO mo-frame(who-i)
    ELSE
        MOVE 0 TO mo-frame(who-i)
    END-IF
    MOVE 1 TO moved-out
    IF mo-ai(who-i) = 0
        IF mo-wait(who-i) > 0
            SUBTRACT 1 FROM mo-wait(who-i)
            EXIT PARAGRAPH
        END-IF
        MOVE 1 TO need-face
        PERFORM can-see
        IF see-ok = 1
            MOVE "sklatk" TO snd-name
            CALL "sfx-play" USING snd-name
            MOVE 4 TO mo-ai(who-i)
            PERFORM skull-charge
        END-IF
        EXIT PARAGRAPH
    END-IF
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 16777216
        RETURNING bit-n
    IF bit-n = 0
        PERFORM skull-charge
        EXIT PARAGRAPH
    END-IF
    PERFORM skull-z
    *> P_XYMovement: mom already cleared means the charge slammed into something.
    IF mo-mx(who-i) = 0 AND mo-my(who-i) = 0
        PERFORM skull-stop
        EXIT PARAGRAPH
    END-IF
    *> S_SKULL_ATK is 22 tics. Resetting mom every tic would erase knockback.
    IF mo-wait(who-i) > 0
        SUBTRACT 1 FROM mo-wait(who-i)
        EXIT PARAGRAPH
    END-IF
    PERFORM skull-charge
    .

skull-charge.
    *> A_SkullAttack: MF_SKULLFLY and SKULLSPEED toward the target.
    CALL "bit_or" USING BY VALUE mo-flags(who-i) BY VALUE 16777216
        RETURNING mo-flags(who-i)
    PERFORM face-player
    CALL "fine_cos_ang" USING BY VALUE mo-ang(who-i) RETURNING cs
    CALL "fine_sin_ang" USING BY VALUE mo-ang(who-i) RETURNING sn
    CALL "fixed_mul" USING BY VALUE 1310720 BY VALUE cs
        RETURNING mo-mx(who-i)
    CALL "fixed_mul" USING BY VALUE 1310720 BY VALUE sn
        RETURNING mo-my(who-i)
    PERFORM measure
    DIVIDE dist-n BY 1310720 GIVING units
    IF units < 1
        MOVE 1 TO units
    END-IF
    DIVIDE aim-h BY 2 GIVING tmp
    CALL "add_i32" USING BY VALUE aim-z BY VALUE tmp RETURNING tmp
    CALL "sub_i32" USING BY VALUE tmp BY VALUE mo-z(who-i) RETURNING tmp
    DIVIDE tmp BY units GIVING mo-mz(who-i) REMAINDER rem-n
    *> Python // floors. DIVIDE truncates toward zero.
    IF tmp < 0 AND rem-n NOT = 0
        SUBTRACT 1 FROM mo-mz(who-i)
    END-IF
    .

skull-z.
    MOVE mo-x(who-i) TO walk-x
    MOVE mo-y(who-i) TO walk-y
    PERFORM locate-sec
    IF sec-slot < 1 OR sec-slot > n-sector
        EXIT PARAGRAPH
    END-IF
    CALL "add_i32" USING BY VALUE mo-z(who-i) BY VALUE mo-mz(who-i)
        RETURNING mo-z(who-i)
    IF mo-z(who-i) <= sec-floor-h(sec-slot)
        MOVE sec-floor-h(sec-slot) TO mo-z(who-i)
        MOVE 0 TO mo-mz(who-i)
    END-IF
    CALL "add_i32" USING BY VALUE mo-z(who-i) BY VALUE mo-h(who-i)
        RETURNING tmp
    IF tmp > sec-ceil-h(sec-slot)
        CALL "sub_i32" USING BY VALUE sec-ceil-h(sec-slot)
            BY VALUE mo-h(who-i) RETURNING mo-z(who-i)
        MOVE 0 TO mo-mz(who-i)
    END-IF
    .

skull-hit.
    *> PIT_CheckThing: (P_Random%8+1)*damage, then the charge ends now.
    PERFORM take-rnd
    DIVIDE rnd-n BY 8 GIVING q-n REMAINDER rem-n
    ADD 1 TO rem-n
    MULTIPLY rem-n BY 3 GIVING dmg
    IF pit-hit = -1
        PERFORM hurt-player
    ELSE
        IF pit-hit > 0 AND pit-hit <= n-mobj
            CALL "bit_and" USING BY VALUE mo-flags(pit-hit) BY VALUE 4
                RETURNING bit-n
            IF bit-n NOT = 0
                MOVE dmg TO hit-dmg
                MOVE who-i TO hit-who
                MOVE pit-hit TO hit-slot
                MOVE 0 TO hit-from
                CALL "gun-tic" USING bexp-a bexp-b bexp-c
            END-IF
        END-IF
    END-IF
    PERFORM skull-stop
    .

skull-stop.
    CALL "bit_xor" USING BY VALUE mo-flags(who-i) BY VALUE 16777216
        RETURNING mo-flags(who-i)
    MOVE 0 TO mo-mx(who-i)
    MOVE 0 TO mo-my(who-i)
    MOVE 0 TO mo-mz(who-i)
    MOVE 0 TO mo-ai(who-i)
    MOVE 10 TO mo-wait(who-i)
    *> tic 0: idle-one runs A_Look now, then drops the fresh 10 to 9.
    MOVE 0 TO mo-tic(who-i)
    MOVE 1 TO slam-look
    .

float-z.
    *> P_ZMovement: no bob while charging (MF_SKULLFLY) or climbing a step
    *> (MF_INFLOAT). Rise only when close relative to the height gap.
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 16777216
        RETURNING bit-n
    IF bit-n NOT = 0
        EXIT PARAGRAPH
    END-IF
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 2097152
        RETURNING bit-n
    IF bit-n NOT = 0
        EXIT PARAGRAPH
    END-IF
    PERFORM measure
    CALL "shar32" USING BY VALUE mo-h(who-i) BY VALUE 1 RETURNING tmp
    CALL "add_i32" USING BY VALUE aim-z BY VALUE tmp RETURNING tmp
    CALL "sub_i32" USING BY VALUE tmp BY VALUE mo-z(who-i) RETURNING dx
    IF dx = 0
        EXIT PARAGRAPH
    END-IF
    CALL "mul_i32" USING BY VALUE dx BY VALUE 3 RETURNING dy
    IF dx < 0
        CALL "sub_i32" USING BY VALUE 0 BY VALUE dy RETURNING dy
    END-IF
    IF dist-n < dy
        IF dx > 0
            CALL "add_i32" USING BY VALUE mo-z(who-i) BY VALUE 262144
                RETURNING mo-z(who-i)
        ELSE
            CALL "sub_i32" USING BY VALUE mo-z(who-i) BY VALUE 262144
                RETURNING mo-z(who-i)
        END-IF
        MOVE 1 TO moved-out
    END-IF
    .

float-if-air.
    *> P_MobjThinker runs P_ZMovement only when z != floorz or momz != 0.
    *> A caco resting on its floor must not rise toward the target.
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 16777216
        RETURNING bit-n
    IF bit-n NOT = 0
        EXIT PARAGRAPH
    END-IF
    IF mo-mz(who-i) = 0
        MOVE mo-x(who-i) TO nx
        MOVE mo-y(who-i) TO ny
        PERFORM spot-free
        IF sec-slot >= 1 AND sec-slot <= n-sector
            IF mo-z(who-i) <= floor-z
                IF mo-z(who-i) < floor-z
                    MOVE floor-z TO mo-z(who-i)
                END-IF
                EXIT PARAGRAPH
            END-IF
        END-IF
    END-IF
    PERFORM float-z
    .

clamp-float.
    *> Vanilla ceilingz/floorz come from the last position check, including
    *> a lower ceiling the body already overlaps. Sector height alone left
    *> a lost soul one step too high, so the next chase became a turn.
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 16777216
        RETURNING bit-n
    IF bit-n = 0
        MOVE mo-x(who-i) TO nx
        MOVE mo-y(who-i) TO ny
        PERFORM spot-free
    END-IF
    IF sec-slot < 1 OR sec-slot > n-sector
        MOVE mo-x(who-i) TO walk-x
        MOVE mo-y(who-i) TO walk-y
        PERFORM locate-sec
    END-IF
    IF sec-slot < 1 OR sec-slot > n-sector
        EXIT PARAGRAPH
    END-IF
    IF bit-n NOT = 0 OR step-ok = 0
        MOVE sec-floor-h(sec-slot) TO floor-z
        MOVE sec-ceil-h(sec-slot) TO ceil-z
    END-IF
    IF mo-z(who-i) < floor-z
        MOVE floor-z TO mo-z(who-i)
    END-IF
    CALL "add_i32" USING BY VALUE mo-z(who-i) BY VALUE mo-h(who-i)
        RETURNING tmp
    IF tmp > ceil-z
        CALL "sub_i32" USING BY VALUE ceil-z BY VALUE mo-h(who-i)
            RETURNING mo-z(who-i)
    END-IF
    .

home-ball.
    CALL "point_to_angle" USING
        BY VALUE mo-x(who-i) BY VALUE mo-y(who-i)
        BY VALUE ply-x BY VALUE ply-y
        RETURNING tmp
    CALL "fine_cos_ang" USING BY VALUE tmp RETURNING cs
    CALL "fine_sin_ang" USING BY VALUE tmp RETURNING sn
    CALL "fixed_mul" USING BY VALUE 655360 BY VALUE cs
        RETURNING mo-mx(who-i)
    CALL "fixed_mul" USING BY VALUE 655360 BY VALUE sn
        RETURNING mo-my(who-i)
    CALL "add_i32" USING BY VALUE ply-z BY VALUE 2097152 RETURNING tmp
    CALL "sub_i32" USING BY VALUE tmp BY VALUE mo-z(who-i) RETURNING tmp
    CALL "shar32" USING BY VALUE tmp BY VALUE 3 RETURNING mo-mz(who-i)
    .

vile-raise.
    MOVE 0 TO raised-n
    PERFORM VARYING foe-j FROM 1 BY 1
        UNTIL foe-j > n-mobj OR raised-n = 1
        IF foe-j NOT = who-i AND mo-kind(foe-j) = 3
            AND mo-hp(foe-j) <= 0
            AND mo-name(foe-j) NOT = SPACES
            AND mo-name(foe-j) NOT = "BAR1"
            AND mo-name(foe-j) NOT = "BEXP"
            CALL "sub_i32" USING BY VALUE mo-x(foe-j) BY VALUE mo-x(who-i)
                RETURNING dx
            CALL "abs_fixed_i" USING BY VALUE dx RETURNING dx
            CALL "sub_i32" USING BY VALUE mo-y(foe-j) BY VALUE mo-y(who-i)
                RETURNING dy
            CALL "abs_fixed_i" USING BY VALUE dy RETURNING dy
            IF dx < 13107200 AND dy < 13107200
                MOVE mo-max(foe-j) TO mo-hp(foe-j)
                IF mo-hp(foe-j) < 1
                    MOVE 20 TO mo-hp(foe-j)
                END-IF
                MOVE 4194310 TO mo-flags(foe-j)
                MOVE 0 TO mo-kind(foe-j)
                MOVE 0 TO mo-ai(foe-j)
                MOVE 0 TO mo-frame(foe-j)
                MOVE 0 TO mo-seq(foe-j)
                MOVE 0 TO mo-tic(foe-j)
                MOVE 0 TO mo-step(foe-j)
                MOVE 8 TO mo-wait(foe-j)
                MOVE 0 TO mo-dir(foe-j)
                CALL "mul_i32" USING BY VALUE mo-h(foe-j) BY VALUE 4
                    RETURNING mo-h(foe-j)
                MOVE "slop" TO snd-name
                CALL "sfx-play" USING snd-name
                MOVE 1 TO raised-n
                MOVE 1 TO moved-out
            END-IF
        END-IF
    END-PERFORM
    .

fly-ball.
    IF mo-name(who-i) = SPACES
        EXIT PARAGRAPH
    END-IF
    IF mo-ai(who-i) = 9
        PERFORM boom-tic
        EXIT PARAGRAPH
    END-IF
    IF mo-name(who-i) = "FATB" AND ply-hp > 0
        PERFORM home-ball
    END-IF
    IF mo-mx(who-i) > 1966080
        MOVE 1966080 TO mo-mx(who-i)
    END-IF
    IF mo-mx(who-i) < -1966080
        MOVE -1966080 TO mo-mx(who-i)
    END-IF
    IF mo-my(who-i) > 1966080
        MOVE 1966080 TO mo-my(who-i)
    END-IF
    IF mo-my(who-i) < -1966080
        MOVE -1966080 TO mo-my(who-i)
    END-IF
    *> P_XYMovement halves a step above MAXMOVE/2 before P_TryMove.
    *> One full step jumps a fatshot over the lost soul.
    MOVE mo-mx(who-i) TO xmove-n
    MOVE mo-my(who-i) TO ymove-n
    CALL "add_i32" USING BY VALUE mo-z(who-i) BY VALUE mo-mz(who-i)
        RETURNING nz
    MOVE 0 TO hurt-pl
    MOVE 0 TO blocked
    IF xmove-n = 0 AND ymove-n = 0
        MOVE mo-x(who-i) TO nx
        MOVE mo-y(who-i) TO ny
        PERFORM ball-hit
    END-IF
    PERFORM UNTIL (xmove-n = 0 AND ymove-n = 0) OR blocked = 1
        IF xmove-n > 983040 OR ymove-n > 983040
            CALL "trunc2_i32" USING BY VALUE xmove-n RETURNING tmp
            CALL "add_i32" USING BY VALUE mo-x(who-i) BY VALUE tmp
                RETURNING nx
            CALL "trunc2_i32" USING BY VALUE ymove-n RETURNING tmp
            CALL "add_i32" USING BY VALUE mo-y(who-i) BY VALUE tmp
                RETURNING ny
            CALL "trunc2_i32" USING BY VALUE xmove-n RETURNING xmove-n
            CALL "trunc2_i32" USING BY VALUE ymove-n RETURNING ymove-n
        ELSE
            CALL "add_i32" USING BY VALUE mo-x(who-i) BY VALUE xmove-n
                RETURNING nx
            CALL "add_i32" USING BY VALUE mo-y(who-i) BY VALUE ymove-n
                RETURNING ny
            MOVE 0 TO xmove-n
            MOVE 0 TO ymove-n
        END-IF
        PERFORM ball-hit
        IF blocked = 0
            MOVE nx TO mo-x(who-i)
            MOVE ny TO mo-y(who-i)
        END-IF
    END-PERFORM
    IF blocked = 1
        IF hurt-pl = 1
            PERFORM take-rnd
            DIVIDE rnd-n BY 8 GIVING q-n REMAINDER rem-n
            ADD 1 TO rem-n
            MULTIPLY rem-n BY mo-hp(who-i) GIVING dmg
            PERFORM hurt-player
        END-IF
        MOVE 9 TO mo-ai(who-i)
        MOVE 32770 TO mo-frame(who-i)
        *> P_ExplodeMissile: death tics -= P_Random&3, then this thinker
        *> decrements once. boom-tic advances the tic after wait hits 0,
        *> so wait = (6 - jitter) - 2.
        PERFORM take-rnd
        CALL "bit_and" USING BY VALUE rnd-n BY VALUE 3 RETURNING rem-n
        COMPUTE mo-wait(who-i) = 4 - rem-n
        MOVE 0 TO mo-mx(who-i)
        MOVE 0 TO mo-my(who-i)
        MOVE 0 TO mo-mz(who-i)
        MOVE 1 TO moved-out
    ELSE
        MOVE nz TO mo-z(who-i)
        ADD 1 TO mo-step(who-i)
        IF mo-step(who-i) >= 4
            MOVE 0 TO mo-step(who-i)
            IF mo-frame(who-i) = 32768
                MOVE 32769 TO mo-frame(who-i)
            ELSE
                MOVE 32768 TO mo-frame(who-i)
            END-IF
        END-IF
        MOVE 1 TO moved-out
    END-IF
    .

boom-tic.
    IF mo-wait(who-i) > 0
        SUBTRACT 1 FROM mo-wait(who-i)
        EXIT PARAGRAPH
    END-IF
    IF mo-frame(who-i) = 32770
        MOVE 32771 TO mo-frame(who-i)
        MOVE 6 TO mo-wait(who-i)
    ELSE
        IF mo-frame(who-i) = 32771
            MOVE 32772 TO mo-frame(who-i)
            MOVE 6 TO mo-wait(who-i)
        ELSE
            MOVE SPACES TO mo-name(who-i)
            MOVE 0 TO mo-kind(who-i)
            MOVE 0 TO mo-ai(who-i)
        END-IF
    END-IF
    MOVE 1 TO moved-out
    .

ball-hit.
    MOVE nx TO walk-x
    MOVE ny TO walk-y
    PERFORM locate-sec
    MOVE -2147483647 TO clip-fl
    MOVE 2147483647 TO clip-cl
    IF sec-slot >= 1 AND sec-slot <= n-sector
        MOVE sec-floor-h(sec-slot) TO clip-fl
        MOVE sec-ceil-h(sec-slot) TO clip-cl
        IF nz <= clip-fl OR nz >= clip-cl
            MOVE 1 TO blocked
        END-IF
    END-IF
    IF blocked = 1
        EXIT PARAGRAPH
    END-IF
    CALL "sub_i32" USING BY VALUE nx BY VALUE ply-x RETURNING dx
    CALL "abs_fixed_i" USING BY VALUE dx RETURNING dx
    CALL "sub_i32" USING BY VALUE ny BY VALUE ply-y RETURNING dy
    CALL "abs_fixed_i" USING BY VALUE dy RETURNING dy
    CALL "add_i32" USING BY VALUE ply-rad BY VALUE mo-rad(who-i)
        RETURNING reach
    IF dx < reach AND dy < reach AND ply-hp > 0
        CALL "add_i32" USING BY VALUE ply-z BY VALUE ply-h RETURNING tmp
        IF nz < tmp
            CALL "add_i32" USING BY VALUE mo-z(who-i) BY VALUE mo-h(who-i)
                RETURNING dx
            IF dx > ply-z
                MOVE 1 TO blocked
                MOVE 1 TO hurt-pl
                EXIT PARAGRAPH
            END-IF
        END-IF
    END-IF
    PERFORM ball-things
    IF blocked = 1
        EXIT PARAGRAPH
    END-IF
    MOVE mo-x(who-i) TO ox
    MOVE mo-y(who-i) TO oy
    CALL "sub_i32" USING BY VALUE nx BY VALUE ox RETURNING tdx
    CALL "sub_i32" USING BY VALUE ny BY VALUE oy RETURNING tdy
    MOVE clip-fl TO save-fl
    MOVE clip-cl TO save-cl
    PERFORM VARYING li FROM 1 BY 1 UNTIL li > n-line OR blocked = 1
        PERFORM cross-one
        MOVE did-cross TO seg-hit
        MOVE 0 TO did-cross
        PERFORM ball-near
        MOVE did-cross TO box-hit
        IF seg-hit = 1
            MOVE 1 TO did-cross
        END-IF
        IF did-cross = 1 OR box-hit = 1
            PERFORM open-of
            IF two-side = 0 OR op-bot >= op-top
                MOVE 1 TO blocked
            ELSE
                *> Fit the opening against z before momz. A box that
                *> still straddles the line keeps that floor for the fall.
                CALL "add_i32" USING BY VALUE mo-z(who-i)
                    BY VALUE mo-h(who-i) RETURNING tmp
                *> P_TryMove: a lip of MAXSTEP (24 units) is still open.
                *> Feet exactly on the opening ceiling still fit.
                CALL "sub_i32" USING BY VALUE op-bot BY VALUE mo-z(who-i)
                    RETURNING dx
                IF tmp > op-top OR dx > 1572864
                    MOVE 1 TO blocked
                ELSE
                    IF box-hit = 1
                        IF op-bot > clip-fl
                            MOVE op-bot TO clip-fl
                        END-IF
                        IF op-top < clip-cl
                            MOVE op-top TO clip-cl
                        END-IF
                    END-IF
                END-IF
            END-IF
        END-IF
    END-PERFORM
    IF blocked = 0
        AND (clip-fl > save-fl OR clip-cl < save-cl)
        CALL "add_i32" USING BY VALUE nz BY VALUE mo-h(who-i)
            RETURNING tmp
        IF nz <= clip-fl OR tmp > clip-cl
            MOVE 1 TO blocked
        END-IF
    END-IF
    .

ball-things.
    *> P_BlockThingsIterator: only a center inside the dest box
    *> extended by MAXRADIUS can be hit. A full scan damages a lost
    *> soul the blockmap never links into this move.
    IF blk-w >= 1 AND blk-h >= 1
        CALL "sub_i32" USING BY VALUE nx BY VALUE mo-rad(who-i)
            RETURNING box-l
        CALL "add_i32" USING BY VALUE nx BY VALUE mo-rad(who-i)
            RETURNING box-r
        CALL "sub_i32" USING BY VALUE ny BY VALUE mo-rad(who-i)
            RETURNING box-b
        CALL "add_i32" USING BY VALUE ny BY VALUE mo-rad(who-i)
            RETURNING box-t
        CALL "sub_i32" USING BY VALUE box-l BY VALUE blk-org-x
            RETURNING tmp
        SUBTRACT 2097152 FROM tmp
        CALL "shar32" USING BY VALUE tmp BY VALUE 23 RETURNING xl
        CALL "sub_i32" USING BY VALUE box-r BY VALUE blk-org-x
            RETURNING tmp
        ADD 2097152 TO tmp
        CALL "shar32" USING BY VALUE tmp BY VALUE 23 RETURNING xh
        CALL "sub_i32" USING BY VALUE box-b BY VALUE blk-org-y
            RETURNING tmp
        SUBTRACT 2097152 FROM tmp
        CALL "shar32" USING BY VALUE tmp BY VALUE 23 RETURNING yl
        CALL "sub_i32" USING BY VALUE box-t BY VALUE blk-org-y
            RETURNING tmp
        ADD 2097152 TO tmp
        CALL "shar32" USING BY VALUE tmp BY VALUE 23 RETURNING yh
    END-IF
    PERFORM VARYING foe-j FROM 1 BY 1
        UNTIL foe-j > n-mobj OR blocked = 1
        IF foe-j NOT = who-i AND foe-j NOT = mo-count(who-i)
            MOVE 1 TO use-ok
            IF blk-w >= 1 AND blk-h >= 1
                CALL "bit_and" USING BY VALUE mo-flags(foe-j) BY VALUE 16
                    RETURNING bit-n
                IF bit-n NOT = 0
                    MOVE 0 TO use-ok
                ELSE
                    CALL "sub_i32" USING BY VALUE mo-x(foe-j)
                        BY VALUE blk-org-x RETURNING tmp
                    CALL "shar32" USING BY VALUE tmp BY VALUE 23
                        RETURNING bx
                    CALL "sub_i32" USING BY VALUE mo-y(foe-j)
                        BY VALUE blk-org-y RETURNING tmp
                    CALL "shar32" USING BY VALUE tmp BY VALUE 23
                        RETURNING by-n
                    IF bx < 0 OR by-n < 0 OR bx >= blk-w OR by-n >= blk-h
                        OR bx < xl OR bx > xh OR by-n < yl OR by-n > yh
                        MOVE 0 TO use-ok
                    END-IF
                END-IF
            END-IF
            IF use-ok = 1
                CALL "bit_and" USING BY VALUE mo-flags(foe-j) BY VALUE 7
                    RETURNING bit-n
                IF bit-n NOT = 0
                    PERFORM ball-one
                END-IF
            END-IF
        END-IF
    END-PERFORM
    .

ball-one.
    CALL "sub_i32" USING BY VALUE nx BY VALUE mo-x(foe-j) RETURNING dx
    CALL "abs_fixed_i" USING BY VALUE dx RETURNING dx
    CALL "sub_i32" USING BY VALUE ny BY VALUE mo-y(foe-j) RETURNING dy
    CALL "abs_fixed_i" USING BY VALUE dy RETURNING dy
    CALL "add_i32" USING BY VALUE mo-rad(foe-j) BY VALUE mo-rad(who-i)
        RETURNING reach
    IF dx >= reach OR dy >= reach
        EXIT PARAGRAPH
    END-IF
    *> Current z (momz is applied only after a clear move).
    CALL "add_i32" USING BY VALUE mo-z(foe-j) BY VALUE mo-h(foe-j)
        RETURNING tmp
    IF mo-z(who-i) > tmp
        EXIT PARAGRAPH
    END-IF
    CALL "add_i32" USING BY VALUE mo-z(who-i) BY VALUE mo-h(who-i)
        RETURNING tmp
    IF tmp < mo-z(foe-j)
        EXIT PARAGRAPH
    END-IF
    IF mo-count(who-i) > 0
        MOVE mo-count(who-i) TO own-n
        IF mo-name(own-n) = mo-name(foe-j)
            OR (mo-name(own-n) = "BOSS" AND mo-name(foe-j) = "BOS2")
            OR (mo-name(own-n) = "BOS2" AND mo-name(foe-j) = "BOSS")
            MOVE 1 TO blocked
            EXIT PARAGRAPH
        END-IF
    END-IF
    CALL "bit_and" USING BY VALUE mo-flags(foe-j) BY VALUE 4
        RETURNING bit-n
    IF bit-n = 0
        CALL "bit_and" USING BY VALUE mo-flags(foe-j) BY VALUE 2
            RETURNING bit-n
        IF bit-n NOT = 0
            MOVE 1 TO blocked
        END-IF
        EXIT PARAGRAPH
    END-IF
    MOVE foe-j TO hit-slot
    MOVE who-i TO hit-from
    CALL "gun-tic" USING bexp-a bexp-b bexp-c
    MOVE 1 TO blocked
    .

ray-player.
    *> Same diagonal + slope as P_LineAttack. gun-tic only reports the hit.
    MOVE who-i TO ray-slot
    MOVE shot-keep TO ray-ang
    MOVE 2 TO ray-mode
    CALL "gun-tic" USING bexp-a bexp-b bexp-c
    IF ray-hit = 1
        *> Blood randoms before P_DamageMobj (pain / kill).
        PERFORM take-rnd
        PERFORM take-rnd
        PERFORM take-rnd
        PERFORM take-rnd
        MOVE dmg TO hit-dmg
        MOVE who-i TO hit-who
        MOVE ray-mo TO hit-slot
        MOVE 0 TO hit-from
        CALL "gun-tic" USING bexp-a bexp-b bexp-c
        EXIT PARAGRAPH
    END-IF
    IF ray-hit = 2
        PERFORM hurt-player
        *> P_SpawnBlood: (R-R)*1024, spawnMobj lastlook, tics-=R&3.
        PERFORM take-rnd
        PERFORM take-rnd
        PERFORM take-rnd
        PERFORM take-rnd
        EXIT PARAGRAPH
    END-IF
    IF ray-hit = 3
        PERFORM puff-at
        *> P_SpawnPuff: (R-R)*1024, spawnMobj lastlook, tics-=R&3.
        PERFORM take-rnd
        PERFORM take-rnd
        PERFORM take-rnd
        PERFORM take-rnd
    ELSE
        ADD 1 TO ray-nopuff
    END-IF
    .

puff-at.
    CALL "fixed_mul" USING BY VALUE tdx BY VALUE wall-fr RETURNING nx
    CALL "add_i32" USING BY VALUE ox BY VALUE nx RETURNING nx
    CALL "fixed_mul" USING BY VALUE tdy BY VALUE wall-fr RETURNING ny
    CALL "add_i32" USING BY VALUE oy BY VALUE ny RETURNING ny
    CALL "alloc-mobj" USING born-i
    IF born-i = 0
        EXIT PARAGRAPH
    END-IF
    MOVE nx TO mo-x(born-i)
    MOVE ny TO mo-y(born-i)
    CALL "add_i32" USING BY VALUE mo-z(who-i) BY VALUE 2097152
        RETURNING mo-z(born-i)
    MOVE "PUFF" TO mo-name(born-i)
    MOVE 32768 TO mo-frame(born-i)
    MOVE 0 TO mo-flags(born-i)
    MOVE 1 TO mo-kind(born-i)
    MOVE 4 TO mo-tic(born-i)
    MOVE 0 TO mo-ai(born-i)
    MOVE 0 TO mo-step(born-i)
    MOVE 1 TO moved-out
    .

new-dir.
    PERFORM load-aim
    MOVE mo-dir(who-i) TO old-d
    MOVE 8 TO turn-d
    IF old-d >= 0 AND old-d <= 7
        COMPUTE turn-d = old-d + 4
        IF turn-d > 7
            SUBTRACT 8 FROM turn-d
        END-IF
    END-IF
    CALL "sub_i32" USING BY VALUE aim-x BY VALUE mo-x(who-i)
        RETURNING dx
    CALL "sub_i32" USING BY VALUE aim-y BY VALUE mo-y(who-i)
        RETURNING dy
    *> try-step reuses dx/dy. Keep the target deltas for the axis swap.
    CALL "abs_fixed_i" USING BY VALUE dx RETURNING m1
    CALL "abs_fixed_i" USING BY VALUE dy RETURNING m2
    MOVE 8 TO d2
    MOVE 8 TO d3
    IF dx > 655360
        MOVE 0 TO d2
    END-IF
    IF dx < -655360
        MOVE 4 TO d2
    END-IF
    IF dy > 655360
        MOVE 2 TO d3
    END-IF
    IF dy < -655360
        MOVE 6 TO d3
    END-IF
    IF d2 NOT = 8 AND d3 NOT = 8
        IF dy < 0
            IF dx > 0
                MOVE 7 TO pick
            ELSE
                MOVE 5 TO pick
            END-IF
        ELSE
            IF dx > 0
                MOVE 1 TO pick
            ELSE
                MOVE 3 TO pick
            END-IF
        END-IF
        IF pick NOT = turn-d
            PERFORM try-pick
            IF step-ok = 1
                PERFORM hold-dir
                EXIT PARAGRAPH
            END-IF
        END-IF
    END-IF
    PERFORM take-rnd
    IF rnd-n > 200 OR m2 > m1
        MOVE d2 TO tmp
        MOVE d3 TO d2
        MOVE tmp TO d3
    END-IF
    IF d2 = turn-d
        MOVE 8 TO d2
    END-IF
    IF d3 = turn-d
        MOVE 8 TO d3
    END-IF
    IF d2 NOT = 8
        MOVE d2 TO pick
        PERFORM try-pick
        IF step-ok = 1
            PERFORM hold-dir
            EXIT PARAGRAPH
        END-IF
    END-IF
    IF d3 NOT = 8
        MOVE d3 TO pick
        PERFORM try-pick
        IF step-ok = 1
            PERFORM hold-dir
            EXIT PARAGRAPH
        END-IF
    END-IF
    IF old-d >= 0 AND old-d <= 7
        MOVE old-d TO pick
        PERFORM try-pick
        IF step-ok = 1
            PERFORM hold-dir
            EXIT PARAGRAPH
        END-IF
    END-IF
    *> Vanilla/Node: (P_Random & 1) != 0 → east..SE; else SE..east.
    PERFORM take-rnd
    CALL "bit_and" USING BY VALUE rnd-n BY VALUE 1 RETURNING scan-i
    IF scan-i = 0
        PERFORM VARYING scan-i FROM 7 BY -1 UNTIL scan-i < 0
            IF scan-i NOT = turn-d
                MOVE scan-i TO pick
                PERFORM try-pick
                IF step-ok = 1
                    PERFORM hold-dir
                    EXIT PARAGRAPH
                END-IF
            END-IF
        END-PERFORM
    ELSE
        PERFORM VARYING scan-i FROM 0 BY 1 UNTIL scan-i > 7
            IF scan-i NOT = turn-d
                MOVE scan-i TO pick
                PERFORM try-pick
                IF step-ok = 1
                    PERFORM hold-dir
                    EXIT PARAGRAPH
                END-IF
            END-IF
        END-PERFORM
    END-IF
    IF turn-d >= 0 AND turn-d <= 7
        MOVE turn-d TO pick
        PERFORM try-pick
        IF step-ok = 1
            PERFORM hold-dir
            EXIT PARAGRAPH
        END-IF
    END-IF
    *> Vanilla P_NewChaseDir: stuck — DI_NODIR, leave movecount alone (no RNG).
    MOVE 8 TO mo-dir(who-i)
    .

hold-dir.
    PERFORM take-rnd
    CALL "bit_and" USING BY VALUE rnd-n BY VALUE 15
        RETURNING mo-count(who-i)
    .

try-pick.
    MOVE pick TO mo-dir(who-i)
    PERFORM try-step
    .

try-step.
    *> P_Move (Python _move): TryMove; else float step; else spechit useSpecial.
    MOVE 0 TO step-ok
    IF mo-dir(who-i) < 0 OR mo-dir(who-i) > 7
        EXIT PARAGRAPH
    END-IF
    COMPUTE slot = mo-dir(who-i) + 1
    CALL "mul_i32" USING BY VALUE xs(slot) BY VALUE spd-u RETURNING tdx
    CALL "mul_i32" USING BY VALUE ys(slot) BY VALUE spd-u RETURNING tdy
    CALL "add_i32" USING BY VALUE mo-x(who-i) BY VALUE tdx RETURNING nx
    CALL "add_i32" USING BY VALUE mo-y(who-i) BY VALUE tdy RETURNING ny
    PERFORM spot-free
    IF step-ok = 1
        MOVE mo-x(who-i) TO ox
        MOVE mo-y(who-i) TO oy
        MOVE nx TO mo-x(who-i)
        MOVE ny TO mo-y(who-i)
        *> Clear MF_INFLOAT (0x200000) on successful TryMove.
        CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 2097152
            RETURNING bit-n
        IF bit-n NOT = 0
            CALL "bit_xor" USING BY VALUE mo-flags(who-i) BY VALUE 2097152
                RETURNING mo-flags(who-i)
        END-IF
        *> MF_FLOAT keeps z, but P_ZMovement still lifts a body that
        *> stepped onto a higher floor (z <= floorz).
        CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 16384
            RETURNING bit-n
        IF bit-n = 0 OR mo-z(who-i) < floor-z
            MOVE floor-z TO mo-z(who-i)
        END-IF
        PERFORM mon-cross-ok
        MOVE 1 TO moved-out
        EXIT PARAGRAPH
    END-IF
    *> Float only when the opening fits but the body does not (floatok).
    *> A solid thing or a wall leaves floatok clear, so the chase turns.
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 16384
        RETURNING bit-n
    IF bit-n NOT = 0 AND float-ok = 1
        CALL "sub_i32" USING BY VALUE ceil-z BY VALUE floor-z
            RETURNING tmp
        IF tmp >= mo-h(who-i)
            IF mo-z(who-i) < floor-z
                ADD 262144 TO mo-z(who-i)
            ELSE
                SUBTRACT 262144 FROM mo-z(who-i)
            END-IF
            CALL "bit_or" USING BY VALUE mo-flags(who-i) BY VALUE 2097152
                RETURNING mo-flags(who-i)
            MOVE 1 TO step-ok
            MOVE 1 TO moved-out
            EXIT PARAGRAPH
        END-IF
    END-IF
    *> Spechit: Harbour only sets DI_NODIR when lastSpechit is non-empty.
    *> Empty spechit must keep movedir so P_NewChaseDir opposite/turn is right.
    IF n-spechit < 1
        EXIT PARAGRAPH
    END-IF
    MOVE 8 TO mo-dir(who-i)
    PERFORM mon-open-spechit
    IF opened-n = 1
        MOVE 1 TO step-ok
        MOVE 1 TO moved-out
    END-IF
    .

body-fall.
    *> P_ZMovement for a body that is not a floater, skull, or missile.
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 512
        RETURNING bit-n
    IF bit-n NOT = 0
        EXIT PARAGRAPH
    END-IF
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 16384
        RETURNING bit-n
    IF bit-n NOT = 0
        EXIT PARAGRAPH
    END-IF
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 16777216
        RETURNING bit-n
    IF bit-n NOT = 0
        EXIT PARAGRAPH
    END-IF
    IF mo-kind(who-i) = 4 OR mo-kind(who-i) = 5
        EXIT PARAGRAPH
    END-IF
    MOVE mo-x(who-i) TO walk-x
    MOVE mo-y(who-i) TO walk-y
    PERFORM locate-sec
    IF sec-slot < 1 OR sec-slot > n-sector
        EXIT PARAGRAPH
    END-IF
    IF mo-mz(who-i) = 0
        AND mo-z(who-i) = sec-floor-h(sec-slot)
        EXIT PARAGRAPH
    END-IF
    MOVE mo-x(who-i) TO nx
    MOVE mo-y(who-i) TO ny
    PERFORM spot-free
    IF step-ok = 0
        MOVE sec-floor-h(sec-slot) TO floor-z
        MOVE sec-ceil-h(sec-slot) TO ceil-z
    END-IF
    CALL "add_i32" USING BY VALUE mo-z(who-i) BY VALUE mo-mz(who-i)
        RETURNING mo-z(who-i)
    IF mo-z(who-i) <= floor-z
        IF mo-mz(who-i) < 0
            MOVE 0 TO mo-mz(who-i)
        END-IF
        MOVE floor-z TO mo-z(who-i)
    ELSE
        IF mo-mz(who-i) = 0
            MOVE -131072 TO mo-mz(who-i)
        ELSE
            SUBTRACT 65536 FROM mo-mz(who-i)
        END-IF
    END-IF
    CALL "add_i32" USING BY VALUE mo-z(who-i) BY VALUE mo-h(who-i)
        RETURNING tmp
    IF tmp > ceil-z
        IF mo-mz(who-i) > 0
            MOVE 0 TO mo-mz(who-i)
        END-IF
        CALL "sub_i32" USING BY VALUE ceil-z BY VALUE mo-h(who-i)
            RETURNING mo-z(who-i)
    END-IF
    .

mon-xy-move.
    *> P_XYMovement for non-player (no slide; zero mom on block).
    IF mo-mx(who-i) > 1966080
        MOVE 1966080 TO mo-mx(who-i)
    END-IF
    IF mo-mx(who-i) < -1966080
        MOVE -1966080 TO mo-mx(who-i)
    END-IF
    IF mo-my(who-i) > 1966080
        MOVE 1966080 TO mo-my(who-i)
    END-IF
    IF mo-my(who-i) < -1966080
        MOVE -1966080 TO mo-my(who-i)
    END-IF
    MOVE mo-mx(who-i) TO xmove-n
    MOVE mo-my(who-i) TO ymove-n
    PERFORM UNTIL xmove-n = 0 AND ymove-n = 0
        IF xmove-n > 983040 OR ymove-n > 983040
            CALL "trunc2_i32" USING BY VALUE xmove-n RETURNING tmp
            CALL "add_i32" USING BY VALUE mo-x(who-i) BY VALUE tmp
                RETURNING nx
            CALL "trunc2_i32" USING BY VALUE ymove-n RETURNING tmp
            CALL "add_i32" USING BY VALUE mo-y(who-i) BY VALUE tmp
                RETURNING ny
            CALL "trunc2_i32" USING BY VALUE xmove-n RETURNING xmove-n
            CALL "trunc2_i32" USING BY VALUE ymove-n RETURNING ymove-n
        ELSE
            CALL "add_i32" USING BY VALUE mo-x(who-i) BY VALUE xmove-n
                RETURNING nx
            CALL "add_i32" USING BY VALUE mo-y(who-i) BY VALUE ymove-n
                RETURNING ny
            MOVE 0 TO xmove-n
            MOVE 0 TO ymove-n
        END-IF
        PERFORM spot-free
        IF step-ok = 1
            MOVE mo-x(who-i) TO ox
            MOVE mo-y(who-i) TO oy
            MOVE nx TO mo-x(who-i)
            MOVE ny TO mo-y(who-i)
            *> MF_FLOAT keeps z. A higher floor still lifts the body.
            *> Do not drop z here: friction must see the old height
            *> above a lower floor. P_ZMovement falls afterwards.
            IF mo-z(who-i) < floor-z
                MOVE floor-z TO mo-z(who-i)
            END-IF
            PERFORM mon-cross-ok
            MOVE 1 TO moved-out
        ELSE
            MOVE 0 TO mo-mx(who-i)
            MOVE 0 TO mo-my(who-i)
            CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 16777216
                RETURNING bit-n
            IF bit-n NOT = 0 AND pit-hit NOT = 0
                AND (xmove-n NOT = 0 OR ymove-n NOT = 0)
                *> Partial step: Look/Chase runs inside the failed try,
                *> then the leftover half is applied from the new spot.
                PERFORM skull-hit
                PERFORM go-chase
                MOVE 0 TO slam-look
            ELSE
                IF bit-n NOT = 0 AND pit-hit NOT = 0
                    PERFORM skull-hit
                END-IF
                MOVE 0 TO xmove-n
                MOVE 0 TO ymove-n
            END-IF
        END-IF
    END-PERFORM
    *> No friction while MF_SKULLFLY. A hit must replace the charge mom.
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 16777216
        RETURNING bit-n
    IF bit-n NOT = 0
        EXIT PARAGRAPH
    END-IF
    *> Friction on the floor (STOPSPEED 4096, FRICTION 0xe800).
    *> Vanilla tests z against the thing's floorz (highest floor under the
    *> body). The sector under the center is lower while the body is still
    *> on the lip, and that made a sliding demon skip friction.
    IF mo-hp(who-i) > 0
        IF mo-z(who-i) > floor-z
            EXIT PARAGRAPH
        END-IF
    ELSE
        MOVE mo-x(who-i) TO walk-x
        MOVE mo-y(who-i) TO walk-y
        PERFORM locate-sec
        IF sec-slot >= 1 AND sec-slot <= n-sector
            IF mo-z(who-i) > sec-floor-h(sec-slot)
                EXIT PARAGRAPH
            END-IF
        END-IF
    END-IF
    CALL "abs_fixed_i" USING BY VALUE mo-mx(who-i) RETURNING m1
    CALL "abs_fixed_i" USING BY VALUE mo-my(who-i) RETURNING m2
    IF m1 < 4096 AND m2 < 4096
        MOVE 0 TO mo-mx(who-i)
        MOVE 0 TO mo-my(who-i)
    ELSE
        CALL "fixed_mul" USING BY VALUE mo-mx(who-i) BY VALUE 59392
            RETURNING mo-mx(who-i)
        CALL "fixed_mul" USING BY VALUE mo-my(who-i) BY VALUE 59392
            RETURNING mo-my(who-i)
    END-IF
    .

spot-free.
    *> P_CheckPosition + P_TryMove gates (Python collision.try_move).
    *> Same bbox / P_BoxOnLineSide path as walk-tic try-spot (not ray-cross).
    MOVE 0 TO step-ok
    MOVE 0 TO float-ok
    MOVE 0 TO n-spechit
    CALL "sub_i32" USING BY VALUE nx BY VALUE mo-rad(who-i)
        RETURNING box-l
    CALL "add_i32" USING BY VALUE nx BY VALUE mo-rad(who-i)
        RETURNING box-r
    CALL "sub_i32" USING BY VALUE ny BY VALUE mo-rad(who-i)
        RETURNING box-b
    CALL "add_i32" USING BY VALUE ny BY VALUE mo-rad(who-i)
        RETURNING box-t
    MOVE nx TO walk-x
    MOVE ny TO walk-y
    PERFORM locate-sec
    IF sec-slot < 1 OR sec-slot > n-sector
        EXIT PARAGRAPH
    END-IF
    MOVE sec-floor-h(sec-slot) TO floor-z
    MOVE floor-z TO drop-z
    MOVE sec-ceil-h(sec-slot) TO ceil-z
    PERFORM mon-pit-things
    IF step-ok = 0
        EXIT PARAGRAPH
    END-IF
    MOVE 1 TO step-ok
    PERFORM mon-pit-lines
    IF step-ok = 0
        EXIT PARAGRAPH
    END-IF
    CALL "sub_i32" USING BY VALUE ceil-z BY VALUE floor-z RETURNING tmp
    IF tmp < mo-h(who-i)
        MOVE 0 TO step-ok
        EXIT PARAGRAPH
    END-IF
    *> Opening fits, so a z miss still counts as floatok.
    MOVE 1 TO float-ok
    CALL "sub_i32" USING BY VALUE ceil-z BY VALUE mo-z(who-i)
        RETURNING tmp
    IF tmp < mo-h(who-i)
        MOVE 0 TO step-ok
        EXIT PARAGRAPH
    END-IF
    CALL "sub_i32" USING BY VALUE floor-z BY VALUE mo-z(who-i)
        RETURNING tmp
    IF tmp > 1572864
        MOVE 0 TO step-ok
        EXIT PARAGRAPH
    END-IF
    MOVE 0 TO float-ok
    *> dropoff unless MF_DROPOFF (0x400) | MF_FLOAT (0x4000).
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 17408
        RETURNING bit-n
    IF bit-n = 0
        CALL "sub_i32" USING BY VALUE floor-z BY VALUE drop-z
            RETURNING tmp
        IF tmp > 1572864
            MOVE 0 TO step-ok
            EXIT PARAGRAPH
        END-IF
    END-IF
    MOVE 1 TO step-ok
    .

mon-pit-things.
    *> P_BlockThingsIterator. A thing counts only when its center block
    *> sits inside the move box extended by MAXRADIUS (32*FU). A mancubus
    *> whose center is one block further away does not stop the step.
    MOVE 1 TO step-ok
    MOVE 0 TO pit-hit
    IF blk-w >= 1 AND blk-h >= 1
        CALL "sub_i32" USING BY VALUE box-l BY VALUE blk-org-x
            RETURNING tmp
        SUBTRACT 2097152 FROM tmp
        CALL "shar32" USING BY VALUE tmp BY VALUE 23 RETURNING xl
        CALL "sub_i32" USING BY VALUE box-r BY VALUE blk-org-x
            RETURNING tmp
        ADD 2097152 TO tmp
        CALL "shar32" USING BY VALUE tmp BY VALUE 23 RETURNING xh
        CALL "sub_i32" USING BY VALUE box-b BY VALUE blk-org-y
            RETURNING tmp
        SUBTRACT 2097152 FROM tmp
        CALL "shar32" USING BY VALUE tmp BY VALUE 23 RETURNING yl
        CALL "sub_i32" USING BY VALUE box-t BY VALUE blk-org-y
            RETURNING tmp
        ADD 2097152 TO tmp
        CALL "shar32" USING BY VALUE tmp BY VALUE 23 RETURNING yh
    END-IF
    IF ply-hp > 0
        MOVE 1 TO use-ok
        IF blk-w >= 1 AND blk-h >= 1
            CALL "sub_i32" USING BY VALUE ply-x BY VALUE blk-org-x
                RETURNING tmp
            CALL "shar32" USING BY VALUE tmp BY VALUE 23 RETURNING bx
            CALL "sub_i32" USING BY VALUE ply-y BY VALUE blk-org-y
                RETURNING tmp
            CALL "shar32" USING BY VALUE tmp BY VALUE 23 RETURNING by-n
            IF bx < 0 OR by-n < 0 OR bx >= blk-w OR by-n >= blk-h
                OR bx < xl OR bx > xh OR by-n < yl OR by-n > yh
                MOVE 0 TO use-ok
            END-IF
        END-IF
        IF use-ok = 1
            CALL "sub_i32" USING BY VALUE nx BY VALUE ply-x RETURNING dx
            CALL "abs_fixed_i" USING BY VALUE dx RETURNING dx
            CALL "sub_i32" USING BY VALUE ny BY VALUE ply-y RETURNING dy
            CALL "abs_fixed_i" USING BY VALUE dy RETURNING dy
            CALL "add_i32" USING BY VALUE mo-rad(who-i) BY VALUE ply-rad
                RETURNING reach
            IF dx < reach AND dy < reach
                MOVE 0 TO step-ok
                MOVE -1 TO pit-hit
                EXIT PARAGRAPH
            END-IF
        END-IF
    END-IF
    PERFORM VARYING li FROM 1 BY 1 UNTIL li > n-mobj OR step-ok = 0
        IF li NOT = who-i
            MOVE 1 TO use-ok
            IF blk-w >= 1 AND blk-h >= 1
                CALL "bit_and" USING BY VALUE mo-flags(li) BY VALUE 16
                    RETURNING bit-n
                IF bit-n NOT = 0
                    MOVE 0 TO use-ok
                ELSE
                    CALL "sub_i32" USING BY VALUE mo-x(li) BY VALUE blk-org-x
                        RETURNING tmp
                    CALL "shar32" USING BY VALUE tmp BY VALUE 23 RETURNING bx
                    CALL "sub_i32" USING BY VALUE mo-y(li) BY VALUE blk-org-y
                        RETURNING tmp
                    CALL "shar32" USING BY VALUE tmp BY VALUE 23 RETURNING by-n
                    IF bx < 0 OR by-n < 0 OR bx >= blk-w OR by-n >= blk-h
                        OR bx < xl OR bx > xh OR by-n < yl OR by-n > yh
                        MOVE 0 TO use-ok
                    END-IF
                END-IF
            END-IF
            IF use-ok = 1
                CALL "bit_and" USING BY VALUE mo-flags(li) BY VALUE 2
                    RETURNING bit-n
                IF bit-n = 0
                    CALL "bit_and" USING BY VALUE mo-flags(who-i)
                        BY VALUE 16777216 RETURNING bit-n
                    IF bit-n NOT = 0
                        CALL "bit_and" USING BY VALUE mo-flags(li) BY VALUE 5
                            RETURNING bit-n
                    END-IF
                END-IF
                IF bit-n NOT = 0
                    CALL "sub_i32" USING BY VALUE nx BY VALUE mo-x(li)
                        RETURNING dx
                    CALL "abs_fixed_i" USING BY VALUE dx RETURNING dx
                    CALL "sub_i32" USING BY VALUE ny BY VALUE mo-y(li)
                        RETURNING dy
                    CALL "abs_fixed_i" USING BY VALUE dy RETURNING dy
                    CALL "add_i32" USING BY VALUE mo-rad(who-i)
                        BY VALUE mo-rad(li) RETURNING reach
                    IF dx < reach AND dy < reach
                        MOVE 0 TO step-ok
                        MOVE li TO pit-hit
                    END-IF
                END-IF
            END-IF
        END-IF
    END-PERFORM
    .

mon-pit-lines.
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
    PERFORM VARYING bx FROM xl BY 1 UNTIL bx > xh OR step-ok = 0
        PERFORM VARYING by-n FROM yl BY 1 UNTIL by-n > yh OR step-ok = 0
            IF bx >= 0 AND by-n >= 0 AND bx < blk-w AND by-n < blk-h
                PERFORM mon-read-block
            END-IF
        END-PERFORM
    END-PERFORM
    .

mon-read-block.
    COMPUTE off-n = 4 + by-n * blk-w + bx
    IF off-n < 0 OR off-n >= n-block
        EXIT PARAGRAPH
    END-IF
    COMPUTE step-n = off-n + 1
    MOVE blk-raw(step-n) TO off-n
    PERFORM UNTIL off-n < 0 OR off-n >= n-block OR step-ok = 0
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
                PERFORM mon-one-line
            END-IF
        END-IF
    END-PERFORM
    .

mon-one-line.
    *> PIT_CheckLine: box vs line, then openings → floorz/ceilz/dropoffz.
    IF box-r <= ln-bl(line-slot) OR box-l >= ln-br(line-slot)
        OR box-t <= ln-bb(line-slot) OR box-b >= ln-bt(line-slot)
        EXIT PARAGRAPH
    END-IF
    PERFORM mon-box-side
    IF side-bit NOT = -1
        EXIT PARAGRAPH
    END-IF
    IF ln-back(line-slot) < 0
        MOVE 0 TO step-ok
        EXIT PARAGRAPH
    END-IF
    CALL "bit_and" USING BY VALUE ln-flags(line-slot) BY VALUE 1
        RETURNING bit-n
    IF bit-n NOT = 0
        MOVE 0 TO step-ok
        EXIT PARAGRAPH
    END-IF
    *> ML_BLOCKMONSTERS — monsters only (player try-spot skips this).
    CALL "bit_and" USING BY VALUE ln-flags(line-slot) BY VALUE 2
        RETURNING bit-n
    IF bit-n NOT = 0
        MOVE 0 TO step-ok
        EXIT PARAGRAPH
    END-IF
    COMPUTE fs = ln-front(line-slot) + 1
    COMPUTE bs = ln-back(line-slot) + 1
    IF fs < 1 OR bs < 1 OR fs > n-sector OR bs > n-sector
        MOVE 0 TO step-ok
        EXIT PARAGRAPH
    END-IF
    IF sec-ceil-h(fs) < sec-ceil-h(bs)
        MOVE sec-ceil-h(fs) TO open-top
    ELSE
        MOVE sec-ceil-h(bs) TO open-top
    END-IF
    IF sec-floor-h(fs) > sec-floor-h(bs)
        MOVE sec-floor-h(fs) TO open-bot
        MOVE sec-floor-h(bs) TO low-z
    ELSE
        MOVE sec-floor-h(bs) TO open-bot
        MOVE sec-floor-h(fs) TO low-z
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
    *> PIT_CheckLine: collect specials after non-blocking two-sided pass.
    IF ln-spec(line-slot) NOT = 0 AND n-spechit < 64
        ADD 1 TO n-spechit
        MOVE line-slot TO spechit-ln(n-spechit)
    END-IF
    .

mon-open-spechit.
    *> P_Move: reversed spechit → P_UseSpecialLine; any true ⇒ move "ok".
    MOVE 0 TO opened-n
    IF n-spechit < 1
        EXIT PARAGRAPH
    END-IF
    PERFORM VARYING spechit-i FROM n-spechit BY -1 UNTIL spechit-i < 1
        MOVE spechit-ln(spechit-i) TO line-slot
        PERFORM mon-use-line
        IF use-ok = 1
            MOVE 1 TO opened-n
        END-IF
    END-PERFORM
    .

mon-cross-ok.
    *> P_TryMove success: cross when the center changes side.
    *> Monsters only open 4/10/39/88/97/125/126 (vanilla P_CrossSpecialLine).
    IF n-spechit < 1
        EXIT PARAGRAPH
    END-IF
    PERFORM VARYING spechit-i FROM n-spechit BY -1 UNTIL spechit-i < 1
        MOVE spechit-ln(spechit-i) TO line-slot
        IF ln-spec(line-slot) = 4 OR ln-spec(line-slot) = 10
            OR ln-spec(line-slot) = 39 OR ln-spec(line-slot) = 88
            OR ln-spec(line-slot) = 97 OR ln-spec(line-slot) = 125
            OR ln-spec(line-slot) = 126
            CALL "line_side" USING
                BY VALUE mo-x(who-i) BY VALUE mo-y(who-i)
                BY VALUE vtx-x(ln-v1(line-slot))
                BY VALUE vtx-y(ln-v1(line-slot))
                BY VALUE ln-dx(line-slot) BY VALUE ln-dy(line-slot)
                RETURNING side-bit
            CALL "line_side" USING
                BY VALUE ox BY VALUE oy
                BY VALUE vtx-x(ln-v1(line-slot))
                BY VALUE vtx-y(ln-v1(line-slot))
                BY VALUE ln-dx(line-slot) BY VALUE ln-dy(line-slot)
                RETURNING side-a
            IF side-bit NOT = side-a
                MOVE line-slot TO cross-ln
                MOVE who-i TO cross-who
                MOVE side-a TO cross-side
                MOVE 4 TO door-mode
                CALL "door-act" USING door-mode door-busy door-moved
            END-IF
        END-IF
    END-PERFORM
    .

mon-use-line.
    *> P_UseSpecialLine for non-player: only 1/32/33/34, never ML_SECRET.
    MOVE 0 TO use-ok
    CALL "bit_and" USING BY VALUE ln-flags(line-slot) BY VALUE 32
        RETURNING bit-n
    IF bit-n NOT = 0
        EXIT PARAGRAPH
    END-IF
    MOVE ln-spec(line-slot) TO rem-n
    IF rem-n NOT = 1 AND rem-n NOT = 32
        AND rem-n NOT = 33 AND rem-n NOT = 34
        EXIT PARAGRAPH
    END-IF
    *> useSpecial returns true even when verticalDoor no-ops (32/33/34).
    MOVE 1 TO use-ok
    *> Monsters only actually open special 1 (Harbour verticalDoor).
    IF rem-n NOT = 1
        EXIT PARAGRAPH
    END-IF
    IF ln-back(line-slot) < 0
        EXIT PARAGRAPH
    END-IF
    COMPUTE sec-slot = ln-back(line-slot) + 1
    MOVE 0 TO dtype
    PERFORM mon-spawn-door
    .

mon-spawn-door.
    *> EV_VerticalDoor spawn for monster (#3: never reverse open→close).
    IF sec-slot < 1 OR sec-slot > 512
        EXIT PARAGRAPH
    END-IF
    IF sec-door(sec-slot) NOT = 0
        MOVE sec-door(sec-slot) TO di
        IF di >= 1 AND di <= 32 AND dr-on(di) = 1
            IF dtype = 0 OR dtype = 5
                IF dr-dir(di) = -1
                    MOVE 1 TO dr-dir(di)
                    MOVE "doropn" TO snd-name
                    CALL "sfx-play" USING snd-name
                END-IF
            END-IF
        END-IF
        EXIT PARAGRAPH
    END-IF
    MOVE 0 TO di
    PERFORM VARYING scan-i FROM 1 BY 1 UNTIL scan-i > 32
        IF dr-on(scan-i) = 0
            MOVE scan-i TO di
            EXIT PERFORM
        END-IF
    END-PERFORM
    IF di = 0
        EXIT PARAGRAPH
    END-IF
    COMPUTE sec-index = sec-slot - 1
    MOVE 2147483647 TO low-h
    PERFORM VARYING scan-i FROM 1 BY 1 UNTIL scan-i > n-line
        IF ln-front(scan-i) = sec-index AND ln-back(scan-i) >= 0
            AND ln-back(scan-i) NOT = sec-index
            COMPUTE nb = ln-back(scan-i) + 1
            IF sec-ceil-h(nb) < low-h
                MOVE sec-ceil-h(nb) TO low-h
            END-IF
        END-IF
        IF ln-back(scan-i) = sec-index AND ln-front(scan-i) >= 0
            AND ln-front(scan-i) NOT = sec-index
            COMPUTE nb = ln-front(scan-i) + 1
            IF sec-ceil-h(nb) < low-h
                MOVE sec-ceil-h(nb) TO low-h
            END-IF
        END-IF
    END-PERFORM
    IF low-h = 2147483647
        MOVE sec-ceil-h(sec-slot) TO low-h
    END-IF
    CALL "sub_i32" USING BY VALUE low-h BY VALUE 262144
        RETURNING dr-top(di)
    MOVE sec-slot TO dr-sec(di)
    MOVE dtype TO dr-type(di)
    MOVE 1 TO dr-dir(di)
    IF dtype >= 5
        MOVE 524288 TO dr-spd(di)
    ELSE
        MOVE 131072 TO dr-spd(di)
    END-IF
    MOVE 150 TO dr-wait(di)
    MOVE 1 TO dr-on(di)
    MOVE di TO sec-door(sec-slot)
    MOVE "doropn" TO snd-name
    CALL "sfx-play" USING snd-name
    .

mon-box-side.
    *> P_BoxOnLineSide (#4): true⇒1; vertical xor when dy < 0.
    MOVE ln-v1(line-slot) TO v1-slot
    MOVE ln-v2(line-slot) TO v2-slot
    CALL "delta_shr16" USING BY VALUE vtx-x(v2-slot)
        BY VALUE vtx-x(v1-slot) RETURNING ldx
    CALL "delta_shr16" USING BY VALUE vtx-y(v2-slot)
        BY VALUE vtx-y(v1-slot) RETURNING ldy
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
                PERFORM mon-point-side
                MOVE side-bit TO p1
                MOVE box-r TO dx
                MOVE box-b TO dy
                PERFORM mon-point-side
                MOVE side-bit TO p2
            ELSE
                MOVE box-r TO dx
                MOVE box-t TO dy
                PERFORM mon-point-side
                MOVE side-bit TO p1
                MOVE box-l TO dx
                MOVE box-b TO dy
                PERFORM mon-point-side
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

mon-point-side.
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
    CALL "sub_i32" USING BY VALUE dx BY VALUE vtx-x(v1-slot)
        RETURNING dx
    CALL "sub_i32" USING BY VALUE dy BY VALUE vtx-y(v1-slot)
        RETURNING dy
    CALL "fixed_mul" USING BY VALUE ldy BY VALUE dx RETURNING left-v
    CALL "fixed_mul" USING BY VALUE dy BY VALUE ldx RETURNING right-v
    IF right-v < left-v
        MOVE 0 TO side-bit
    ELSE
        MOVE 1 TO side-bit
    END-IF
    .

face-dir.
    CALL "bit_and" USING BY VALUE mo-ang(who-i) BY VALUE 3758096384
        RETURNING mo-ang(who-i)
    COMPUTE tmp = mo-dir(who-i) * 536870912
    CALL "sub_i32" USING BY VALUE mo-ang(who-i) BY VALUE tmp
        RETURNING tmp
    IF tmp > 0
        CALL "sub_i32" USING BY VALUE mo-ang(who-i) BY VALUE 536870912
            RETURNING mo-ang(who-i)
    ELSE
        IF tmp < 0
            CALL "add_i32" USING BY VALUE mo-ang(who-i) BY VALUE 536870912
                RETURNING mo-ang(who-i)
        END-IF
    END-IF
    .

notice-player.
    *> A_Look after a lost target: gunshot in the sector, else a forward sight.
    MOVE mo-x(who-i) TO walk-x
    MOVE mo-y(who-i) TO walk-y
    PERFORM locate-sec
    MOVE sec-slot TO mon-sec
    MOVE 0 TO see-ok
    IF mon-sec >= 1 AND mon-sec <= 512
        IF sec-alert(mon-sec) = 1
            CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 32
                RETURNING bit-n
            IF bit-n = 0
                MOVE 1 TO see-ok
            ELSE
                MOVE 0 TO need-face
                PERFORM can-see
            END-IF
        END-IF
    END-IF
    IF see-ok = 0
        PERFORM look-for-player
    END-IF
    .

look-for-player.
    *> P_LookForPlayers allaround=false; single-player only slot 0.
    MOVE 0 TO see-ok
    IF ply-hp <= 0
        EXIT PARAGRAPH
    END-IF
    MOVE 0 TO shot-k
    COMPUTE soul-n = mo-look(who-i) - 1
    CALL "bit_and" USING BY VALUE soul-n BY VALUE 3 RETURNING soul-n
    PERFORM UNTIL see-ok = 1
        IF mo-look(who-i) NOT = 0
            ADD 1 TO mo-look(who-i)
            CALL "bit_and" USING BY VALUE mo-look(who-i) BY VALUE 3
                RETURNING mo-look(who-i)
        ELSE
            IF shot-k = 2 OR mo-look(who-i) = soul-n
                EXIT PERFORM
            END-IF
            ADD 1 TO shot-k
            MOVE 1 TO need-face
            PERFORM can-see
            IF see-ok = 0
                ADD 1 TO mo-look(who-i)
                CALL "bit_and" USING BY VALUE mo-look(who-i) BY VALUE 3
                    RETURNING mo-look(who-i)
            END-IF
        END-IF
    END-PERFORM
    .

can-see.
    MOVE 0 TO see-ok
    PERFORM measure
    IF mo-tgt(who-i) = 0 AND ply-hp <= 0
        EXIT PARAGRAPH
    END-IF
    *> P_CheckSight has no distance cap. The imp above the first E1M7
    *> elevator is about 2367 units away; a 1500 cutoff kept him asleep
    *> so the fireball never came. Missile odds are applied in consider-shot.
    *> Harbour/Node: checkSight first, then FOV when need-face.
    MOVE mo-x(who-i) TO walk-x
    MOVE mo-y(who-i) TO walk-y
    PERFORM locate-sec
    MOVE sec-slot TO mon-sec
    IF mon-sec < 1 OR aim-sec < 1
        EXIT PARAGRAPH
    END-IF
    *> P_CheckSight: REJECT first (even same sector — no short-circuit).
    COMPUTE pnum = (mon-sec - 1) * n-sector + (aim-sec - 1)
    DIVIDE pnum BY 8 GIVING byte-i REMAINDER rem-n
    IF byte-i >= 0 AND byte-i < reject-n
        CALL "byte_at" USING BY REFERENCE reject-buf BY VALUE byte-i
            RETURNING bit-n
        MOVE 1 TO mask-n
        PERFORM rem-n TIMES
            MULTIPLY 2 BY mask-n
        END-PERFORM
        CALL "bit_and" USING BY VALUE bit-n BY VALUE mask-n
            RETURNING tmp
        IF tmp NOT = 0
            EXIT PARAGRAPH
        END-IF
    END-IF
    MOVE mo-x(who-i) TO ox
    MOVE mo-y(who-i) TO oy
    CALL "sub_i32" USING BY VALUE aim-x BY VALUE ox RETURNING tdx
    CALL "sub_i32" USING BY VALUE aim-y BY VALUE oy RETURNING tdy
    *> P_CheckSight slopes: eye = z + height - height/4.
    CALL "shar32" USING BY VALUE mo-h(who-i) BY VALUE 2 RETURNING tmp
    CALL "sub_i32" USING BY VALUE mo-h(who-i) BY VALUE tmp RETURNING tmp
    CALL "add_i32" USING BY VALUE mo-z(who-i) BY VALUE tmp RETURNING eye-z
    CALL "add_i32" USING BY VALUE aim-z BY VALUE aim-h RETURNING slope-t
    CALL "sub_i32" USING BY VALUE slope-t BY VALUE eye-z RETURNING slope-t
    CALL "sub_i32" USING BY VALUE aim-z BY VALUE eye-z RETURNING slope-b
    MOVE 1 TO see-ok
    ADD 1 TO sight-gen
    IF sight-gen = 0
        MOVE 1 TO sight-gen
    END-IF
    PERFORM sight-walk
    IF see-ok = 0
        EXIT PARAGRAPH
    END-IF
    IF need-face = 1
        *> (angleTo - mo.angle) as u32; behind if ANG90 < ang < ANG270.
        CALL "point_to_angle" USING
            BY VALUE mo-x(who-i) BY VALUE mo-y(who-i)
            BY VALUE aim-x BY VALUE aim-y
            RETURNING along
        CALL "sub_i32" USING BY VALUE along BY VALUE mo-ang(who-i)
            RETURNING along
        CALL "ugt_u32" USING BY VALUE along BY VALUE 1073741824
            RETURNING bit-n
        CALL "ugt_u32" USING BY VALUE -1073741824 BY VALUE along
            RETURNING tmp
        IF bit-n = 1 AND tmp = 1
            IF dist-n > 4194304
                MOVE 0 TO see-ok
                EXIT PARAGRAPH
            END-IF
        END-IF
    END-IF
    MOVE 1 TO see-ok
    .

sight-walk.
    *> P_CrossBSPNode. The side child is finished before the far child.
    IF n-node < 1
        MOVE 0 TO sub-n
        PERFORM sight-sub
        EXIT PARAGRAPH
    END-IF
    MOVE 1 TO stk-n
    COMPUTE stk-bsp(1) = n-node - 1
    MOVE 0 TO stk-ph(1)
    PERFORM UNTIL stk-n < 1 OR see-ok = 0
        MOVE stk-bsp(stk-n) TO bsp
        MOVE stk-ph(stk-n) TO step-n
        IF step-n = 0
            PERFORM sight-enter
        ELSE
            PERFORM sight-other
        END-IF
    END-PERFORM
    .

sight-enter.
    CALL "bit_and" USING BY VALUE bsp BY VALUE 32768 RETURNING bit-n
    IF bit-n NOT = 0 OR bsp < 0
        SUBTRACT 1 FROM stk-n
        IF bsp = 65535
            MOVE 0 TO sub-n
        ELSE
            CALL "bit_and" USING BY VALUE bsp BY VALUE 32767
                RETURNING sub-n
        END-IF
        PERFORM sight-sub
        EXIT PARAGRAPH
    END-IF
    COMPUTE node-slot = bsp + 1
    IF node-slot < 1 OR node-slot > n-node
        SUBTRACT 1 FROM stk-n
        EXIT PARAGRAPH
    END-IF
    CALL "sight_side" USING
        BY VALUE ox BY VALUE oy
        BY VALUE nd-x(node-slot) BY VALUE nd-y(node-slot)
        BY VALUE nd-dx(node-slot) BY VALUE nd-dy(node-slot)
        RETURNING side-bit
    IF side-bit = 2
        MOVE 0 TO side-bit
    END-IF
    MOVE side-bit TO stk-sd(stk-n)
    MOVE 1 TO stk-ph(stk-n)
    IF side-bit = 0
        MOVE nd-c0(node-slot) TO p1
    ELSE
        MOVE nd-c1(node-slot) TO p1
    END-IF
    IF stk-n >= 128
        MOVE 0 TO see-ok
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO stk-n
    MOVE p1 TO stk-bsp(stk-n)
    MOVE 0 TO stk-ph(stk-n)
    .

sight-other.
    *> First child stayed open. Visit the far side only when the target is there.
    MOVE stk-sd(stk-n) TO side-bit
    SUBTRACT 1 FROM stk-n
    COMPUTE node-slot = bsp + 1
    IF node-slot < 1 OR node-slot > n-node
        EXIT PARAGRAPH
    END-IF
    CALL "sight_side" USING
        BY VALUE aim-x BY VALUE aim-y
        BY VALUE nd-x(node-slot) BY VALUE nd-y(node-slot)
        BY VALUE nd-dx(node-slot) BY VALUE nd-dy(node-slot)
        RETURNING side-a
    IF side-bit = side-a
        EXIT PARAGRAPH
    END-IF
    IF side-bit = 0
        MOVE nd-c1(node-slot) TO p1
    ELSE
        MOVE nd-c0(node-slot) TO p1
    END-IF
    IF stk-n >= 128
        MOVE 0 TO see-ok
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO stk-n
    MOVE p1 TO stk-bsp(stk-n)
    MOVE 0 TO stk-ph(stk-n)
    .

sight-sub.
    IF sub-n < 0 OR sub-n >= n-ssector
        MOVE 0 TO sub-n
    END-IF
    COMPUTE sub-slot = sub-n + 1
    MOVE ss-n(sub-slot) TO sg-left
    COMPUTE sg-slot = ss-begin(sub-slot) + 1
    PERFORM sg-left TIMES
        IF see-ok = 1
            AND sg-slot >= 1 AND sg-slot <= n-seg
            MOVE sg-line(sg-slot) TO li
            IF li >= 1 AND li <= n-line
                AND sight-seen(li) NOT = sight-gen
                MOVE sight-gen TO sight-seen(li)
                PERFORM sight-one
            END-IF
        END-IF
        ADD 1 TO sg-slot
    END-PERFORM
    .

sight-one.
    CALL "sight_trace_side" USING
        BY VALUE vtx-x(ln-v1(li)) BY VALUE vtx-y(ln-v1(li))
        BY VALUE ox BY VALUE oy
        BY VALUE aim-x BY VALUE aim-y
        RETURNING side-bit
    CALL "sight_trace_side" USING
        BY VALUE vtx-x(ln-v2(li)) BY VALUE vtx-y(ln-v2(li))
        BY VALUE ox BY VALUE oy
        BY VALUE aim-x BY VALUE aim-y
        RETURNING side-a
    IF side-bit = side-a
        EXIT PARAGRAPH
    END-IF
    CALL "sub_i32" USING
        BY VALUE vtx-x(ln-v2(li)) BY VALUE vtx-x(ln-v1(li))
        RETURNING ldx
    CALL "sub_i32" USING
        BY VALUE vtx-y(ln-v2(li)) BY VALUE vtx-y(ln-v1(li))
        RETURNING ldy
    CALL "sight_side" USING
        BY VALUE ox BY VALUE oy
        BY VALUE vtx-x(ln-v1(li)) BY VALUE vtx-y(ln-v1(li))
        BY VALUE ldx BY VALUE ldy
        RETURNING side-bit
    CALL "sight_side" USING
        BY VALUE aim-x BY VALUE aim-y
        BY VALUE vtx-x(ln-v1(li)) BY VALUE vtx-y(ln-v1(li))
        BY VALUE ldx BY VALUE ldy
        RETURNING side-a
    IF side-bit = side-a
        EXIT PARAGRAPH
    END-IF
    PERFORM open-of
    IF two-side = 0 OR fs < 1 OR bs < 1
        MOVE 0 TO see-ok
        EXIT PARAGRAPH
    END-IF
    IF sec-floor-h(fs) = sec-floor-h(bs)
        AND sec-ceil-h(fs) = sec-ceil-h(bs)
        EXIT PARAGRAPH
    END-IF
    IF op-bot >= op-top
        MOVE 0 TO see-ok
        EXIT PARAGRAPH
    END-IF
    CALL "sight_frac" USING
        BY VALUE ox BY VALUE oy
        BY VALUE aim-x BY VALUE aim-y
        BY VALUE vtx-x(ln-v1(li)) BY VALUE vtx-y(ln-v1(li))
        BY VALUE vtx-x(ln-v2(li)) BY VALUE vtx-y(ln-v2(li))
        RETURNING frac
    IF frac > 0 AND frac < 65536
        PERFORM sight-clip
    END-IF
    .

sight-clip.
    *> P_CrossSubsector: tighten topslope/bottomslope; closed window blocks.
    IF fs < 1 OR bs < 1 OR fs > n-sector OR bs > n-sector
        EXIT PARAGRAPH
    END-IF
    IF sec-floor-h(fs) = sec-floor-h(bs)
        AND sec-ceil-h(fs) = sec-ceil-h(bs)
        EXIT PARAGRAPH
    END-IF
    IF sec-floor-h(fs) NOT = sec-floor-h(bs)
        CALL "sub_i32" USING BY VALUE op-bot BY VALUE eye-z RETURNING tmp
        CALL "fixed_div" USING BY VALUE tmp BY VALUE frac RETURNING numv
        IF numv > slope-b
            MOVE numv TO slope-b
        END-IF
    END-IF
    IF sec-ceil-h(fs) NOT = sec-ceil-h(bs)
        CALL "sub_i32" USING BY VALUE op-top BY VALUE eye-z RETURNING tmp
        CALL "fixed_div" USING BY VALUE tmp BY VALUE frac RETURNING numv
        IF numv < slope-t
            MOVE numv TO slope-t
        END-IF
    END-IF
    IF slope-t <= slope-b
        MOVE 0 TO see-ok
    END-IF
    .

measure.
    PERFORM load-aim
    CALL "sub_i32" USING BY VALUE aim-x BY VALUE mo-x(who-i)
        RETURNING dx
    CALL "sub_i32" USING BY VALUE aim-y BY VALUE mo-y(who-i)
        RETURNING dy
    CALL "abs_fixed_i" USING BY VALUE dx RETURNING dx
    CALL "abs_fixed_i" USING BY VALUE dy RETURNING dy
    IF dx < dy
        MOVE dx TO tmp
        MOVE dy TO dx
        MOVE tmp TO dy
    END-IF
    DIVIDE dy BY 2 GIVING tmp
    CALL "add_i32" USING BY VALUE dx BY VALUE tmp RETURNING dist-n
    .

hear-shot.
    *> P_NoiseAlert / P_RecursiveSound (Harbour/vanilla).
    *> Flood from fire-time XY (gun runs before walk XY that tic).
    IF ply-shot NOT = 1
        EXIT PARAGRAPH
    END-IF
    MOVE 0 TO ply-shot
    ADD 1 TO hear-id
    MOVE ply-shot-x TO walk-x
    MOVE ply-shot-y TO walk-y
    PERFORM locate-sec
    MOVE sec-slot TO ply-sec
    IF ply-sec < 1 OR ply-sec > 512
        EXIT PARAGRAPH
    END-IF
    MOVE 1 TO n-q
    MOVE 0 TO q-at
    MOVE ply-sec TO q-sec(1)
    MOVE 0 TO q-blk(1)
    PERFORM UNTIL q-at >= n-q
        ADD 1 TO q-at
        MOVE q-sec(q-at) TO fs
        MOVE q-blk(q-at) TO hear-blk
        IF fs >= 1 AND fs <= 512
            *> Skip only if already visited this flood with equal/better path.
            IF sec-mark(fs) NOT = hear-id
                OR sec-trav(fs) > hear-blk + 1
                MOVE hear-id TO sec-mark(fs)
                COMPUTE sec-trav(fs) = hear-blk + 1
                MOVE 1 TO sec-alert(fs)
                PERFORM hear-lines
            END-IF
        END-IF
    END-PERFORM
    .

hear-lines.
    MOVE fs TO keep-sec
    PERFORM VARYING li FROM 1 BY 1 UNTIL li > n-line
        MOVE 0 TO other-sec
        IF ln-front(li) + 1 = keep-sec AND ln-back(li) >= 0
            COMPUTE other-sec = ln-back(li) + 1
        END-IF
        IF ln-back(li) + 1 = keep-sec AND ln-front(li) >= 0
            COMPUTE other-sec = ln-front(li) + 1
        END-IF
        IF other-sec >= 1 AND other-sec <= 512 AND n-q < 512
            CALL "bit_and" USING BY VALUE ln-flags(li) BY VALUE 4
                RETURNING bit-n
            IF bit-n NOT = 0
                PERFORM open-of
                IF op-top > op-bot
                    MOVE hear-blk TO new-blk
                    CALL "bit_and" USING BY VALUE ln-flags(li) BY VALUE 64
                        RETURNING bit-n
                    IF bit-n = 0
                        ADD 1 TO n-q
                        MOVE other-sec TO q-sec(n-q)
                        MOVE new-blk TO q-blk(n-q)
                    ELSE
                        IF new-blk = 0
                            ADD 1 TO n-q
                            MOVE other-sec TO q-sec(n-q)
                            MOVE 1 TO q-blk(n-q)
                        END-IF
                    END-IF
                END-IF
            END-IF
        END-IF
    END-PERFORM
    .

ball-near.
    CALL "sub_i32" USING BY VALUE nx BY VALUE mo-rad(who-i)
        RETURNING box-l
    CALL "add_i32" USING BY VALUE nx BY VALUE mo-rad(who-i)
        RETURNING box-r
    CALL "sub_i32" USING BY VALUE ny BY VALUE mo-rad(who-i)
        RETURNING box-b
    CALL "add_i32" USING BY VALUE ny BY VALUE mo-rad(who-i)
        RETURNING box-t
    IF box-r <= ln-bl(li) OR box-l >= ln-br(li)
        OR box-t <= ln-bb(li) OR box-b >= ln-bt(li)
        EXIT PARAGRAPH
    END-IF
    CALL "sub_i32" USING BY VALUE vtx-x(ln-v2(li))
        BY VALUE vtx-x(ln-v1(li)) RETURNING sh1
    CALL "sub_i32" USING BY VALUE vtx-y(ln-v2(li))
        BY VALUE vtx-y(ln-v1(li)) RETURNING sh2
    *> P_BoxOnLineSide: two corners, not all four. The extra corners
    *> mark a line the shot never crosses.
    IF sh1 = 0
        IF box-r < vtx-x(ln-v1(li))
            MOVE 1 TO side-a
        ELSE
            MOVE 0 TO side-a
        END-IF
        IF box-l < vtx-x(ln-v1(li))
            MOVE 1 TO side-bit
        ELSE
            MOVE 0 TO side-bit
        END-IF
        IF sh2 < 0
            SUBTRACT side-a FROM 1 GIVING side-a
            SUBTRACT side-bit FROM 1 GIVING side-bit
        END-IF
    ELSE
        IF sh2 = 0
            IF box-t > vtx-y(ln-v1(li))
                MOVE 1 TO side-a
            ELSE
                MOVE 0 TO side-a
            END-IF
            IF box-b > vtx-y(ln-v1(li))
                MOVE 1 TO side-bit
            ELSE
                MOVE 0 TO side-bit
            END-IF
            IF sh1 < 0
                SUBTRACT side-a FROM 1 GIVING side-a
                SUBTRACT side-bit FROM 1 GIVING side-bit
            END-IF
        ELSE
            IF (sh1 > 0 AND sh2 > 0) OR (sh1 < 0 AND sh2 < 0)
                CALL "point_side" USING
                    BY VALUE vtx-x(ln-v1(li)) BY VALUE vtx-y(ln-v1(li))
                    BY VALUE sh1 BY VALUE sh2
                    BY VALUE box-l BY VALUE box-t
                    RETURNING side-a
                CALL "point_side" USING
                    BY VALUE vtx-x(ln-v1(li)) BY VALUE vtx-y(ln-v1(li))
                    BY VALUE sh1 BY VALUE sh2
                    BY VALUE box-r BY VALUE box-b
                    RETURNING side-bit
            ELSE
                CALL "point_side" USING
                    BY VALUE vtx-x(ln-v1(li)) BY VALUE vtx-y(ln-v1(li))
                    BY VALUE sh1 BY VALUE sh2
                    BY VALUE box-r BY VALUE box-t
                    RETURNING side-a
                CALL "point_side" USING
                    BY VALUE vtx-x(ln-v1(li)) BY VALUE vtx-y(ln-v1(li))
                    BY VALUE sh1 BY VALUE sh2
                    BY VALUE box-l BY VALUE box-b
                    RETURNING side-bit
            END-IF
        END-IF
    END-IF
    IF side-a NOT = side-bit
        MOVE 1 TO did-cross
    END-IF
    .

open-of.
    MOVE 0 TO two-side
    CALL "bit_and" USING BY VALUE ln-flags(li) BY VALUE 4
        RETURNING bit-n
    IF bit-n NOT = 0
        MOVE 1 TO two-side
    END-IF
    COMPUTE fs = ln-front(li) + 1
    IF ln-back(li) < 0
        MOVE 0 TO bs
    ELSE
        COMPUTE bs = ln-back(li) + 1
    END-IF
    MOVE 0 TO op-top
    MOVE 0 TO op-bot
    IF fs >= 1 AND fs <= n-sector
        MOVE sec-floor-h(fs) TO op-bot
        MOVE sec-ceil-h(fs) TO op-top
    END-IF
    IF bs >= 1 AND bs <= n-sector
        IF sec-floor-h(bs) > op-bot
            MOVE sec-floor-h(bs) TO op-bot
        END-IF
        IF sec-ceil-h(bs) < op-top
            MOVE sec-ceil-h(bs) TO op-top
        END-IF
    END-IF
    .

cross-one.
    MOVE 0 TO did-cross
    CALL "trace_frac" USING
        BY VALUE ox BY VALUE oy BY VALUE tdx BY VALUE tdy
        BY VALUE vtx-x(ln-v1(li)) BY VALUE vtx-y(ln-v1(li))
        BY VALUE vtx-x(ln-v2(li)) BY VALUE vtx-y(ln-v2(li))
        RETURNING frac
    IF frac < 0
        EXIT PARAGRAPH
    END-IF
    MOVE 1 TO did-cross
    .

ray-side.
    IF tdx = 0
        IF dx <= ox
            IF tdy > 0
                MOVE 1 TO side-bit
            ELSE
                MOVE 0 TO side-bit
            END-IF
        ELSE
            IF tdy < 0
                MOVE 1 TO side-bit
            ELSE
                MOVE 0 TO side-bit
            END-IF
        END-IF
        EXIT PARAGRAPH
    END-IF
    IF tdy = 0
        IF dy <= oy
            IF tdx < 0
                MOVE 1 TO side-bit
            ELSE
                MOVE 0 TO side-bit
            END-IF
        ELSE
            IF tdx > 0
                MOVE 1 TO side-bit
            ELSE
                MOVE 0 TO side-bit
            END-IF
        END-IF
        EXIT PARAGRAPH
    END-IF
    CALL "sub_i32" USING BY VALUE dx BY VALUE ox RETURNING dx
    CALL "sub_i32" USING BY VALUE dy BY VALUE oy RETURNING dy
    CALL "fixed_mul" USING BY VALUE tdy BY VALUE dx RETURNING left-v
    CALL "fixed_mul" USING BY VALUE dy BY VALUE tdx RETURNING right-v
    IF right-v < left-v
        MOVE 0 TO side-bit
    ELSE
        MOVE 1 TO side-bit
    END-IF
    .

load-aim.
    *> 0 keeps the player. A corpse stays the target until A_Chase
    *> notices it; clearing it here makes the next chase step early.
    MOVE 0 TO aim-shadow
    IF mo-tgt(who-i) > 0
        MOVE mo-tgt(who-i) TO own-n
        IF own-n > n-mobj OR mo-name(own-n) = SPACES
            MOVE 0 TO mo-tgt(who-i)
            MOVE 0 TO mo-thrs(who-i)
        END-IF
    END-IF
    IF mo-tgt(who-i) = 0
        MOVE ply-x TO aim-x
        MOVE ply-y TO aim-y
        MOVE ply-z TO aim-z
        MOVE ply-h TO aim-h
        MOVE ply-sec TO aim-sec
        MOVE ply-rad TO aim-rad
        IF ply-invis > 0
            MOVE 1 TO aim-shadow
        END-IF
    ELSE
        MOVE mo-x(own-n) TO aim-x
        MOVE mo-y(own-n) TO aim-y
        MOVE mo-z(own-n) TO aim-z
        MOVE mo-h(own-n) TO aim-h
        MOVE mo-rad(own-n) TO aim-rad
        MOVE mo-x(own-n) TO walk-x
        MOVE mo-y(own-n) TO walk-y
        PERFORM locate-sec
        MOVE sec-slot TO aim-sec
        CALL "bit_and" USING BY VALUE mo-flags(own-n) BY VALUE 262144
            RETURNING bit-n
        IF bit-n NOT = 0
            MOVE 1 TO aim-shadow
        END-IF
    END-IF
    .

ray-mon.
    CALL "sub_i32" USING BY VALUE mo-x(foe-j) BY VALUE ox RETURNING wx
    CALL "sub_i32" USING BY VALUE mo-y(foe-j) BY VALUE oy RETURNING wy
    CALL "fixed_mul" USING BY VALUE wx BY VALUE cs RETURNING along
    CALL "fixed_mul" USING BY VALUE wy BY VALUE sn RETURNING tmp
    CALL "add_i32" USING BY VALUE along BY VALUE tmp RETURNING along
    IF along <= 0
        EXIT PARAGRAPH
    END-IF
    CALL "fixed_mul" USING BY VALUE wx BY VALUE sn RETURNING dx
    CALL "fixed_mul" USING BY VALUE wy BY VALUE cs RETURNING dy
    CALL "sub_i32" USING BY VALUE dx BY VALUE dy RETURNING dx
    CALL "abs_fixed_i" USING BY VALUE dx RETURNING dx
    IF dx >= mo-rad(foe-j)
        EXIT PARAGRAPH
    END-IF
    DIVIDE along BY 2048 GIVING along
    IF hit-fr = 0 OR along < hit-fr
        MOVE along TO hit-fr
        MOVE foe-j TO hit-mo
    END-IF
    .

locate-sec.
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

active-snd.
    *> A_Chase activesound, only when the draw is under 3.
    MOVE SPACES TO snd-name
    IF mo-name(who-i) = "TROO"
        MOVE "bgact" TO snd-name
    END-IF
    IF mo-name(who-i) = "VILE"
        MOVE "vilact" TO snd-name
    END-IF
    IF mo-name(who-i) = "SKEL"
        MOVE "skeact" TO snd-name
    END-IF
    IF mo-name(who-i) = "BSPI"
        MOVE "bspact" TO snd-name
    END-IF
    IF mo-name(who-i) = "SARG" OR mo-name(who-i) = "HEAD"
        OR mo-name(who-i) = "BOSS" OR mo-name(who-i) = "BOS2"
        OR mo-name(who-i) = "SPID" OR mo-name(who-i) = "CYBR"
        OR mo-name(who-i) = "PAIN" OR mo-name(who-i) = "SKUL"
        MOVE "dmact" TO snd-name
    END-IF
    IF mo-name(who-i) = "POSS" OR mo-name(who-i) = "SPOS"
        OR mo-name(who-i) = "CPOS" OR mo-name(who-i) = "SSWV"
        OR mo-name(who-i) = "FATT"
        MOVE "posact" TO snd-name
    END-IF
    IF snd-name NOT = SPACES
        CALL "sfx-play" USING snd-name
    END-IF
    .

take-rnd.
    CALL "p-random" USING rnd-n
    .

END PROGRAM enemy-tic.

IDENTIFICATION DIVISION.
PROGRAM-ID. push-ply.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "playstate.cpy".
01 push-n BINARY-LONG.
01 aim-ang BINARY-LONG.
01 cs BINARY-LONG.
01 sn BINARY-LONG.
01 dx BINARY-LONG.
01 dy BINARY-LONG.

LINKAGE SECTION.
01 hit-n BINARY-LONG.
01 src-x BINARY-LONG.
01 src-y BINARY-LONG.

PROCEDURE DIVISION USING hit-n src-x src-y.
    IF hit-n <= 0
        GOBACK
    END-IF
    MULTIPLY hit-n BY 8192 GIVING push-n
    CALL "point_to_angle" USING
        BY VALUE src-x BY VALUE src-y
        BY VALUE ply-x BY VALUE ply-y
        RETURNING aim-ang
    CALL "fine_cos_ang" USING BY VALUE aim-ang RETURNING cs
    CALL "fine_sin_ang" USING BY VALUE aim-ang RETURNING sn
    CALL "fixed_mul" USING BY VALUE push-n BY VALUE cs RETURNING dx
    CALL "fixed_mul" USING BY VALUE push-n BY VALUE sn RETURNING dy
    CALL "add_i32" USING BY VALUE ply-momx BY VALUE dx RETURNING ply-momx
    CALL "add_i32" USING BY VALUE ply-momy BY VALUE dy RETURNING ply-momy
    GOBACK.

END PROGRAM push-ply.
