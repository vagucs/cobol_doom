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
*> Monstros do episodio 1 e do Doom 2. Acordam, andam e atacam.
IDENTIFICATION DIVISION.
PROGRAM-ID. enemy-tic.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 dirs-on BINARY-LONG VALUE 0.
01 xs BINARY-LONG OCCURS 8 TIMES.
01 ys BINARY-LONG OCCURS 8 TIMES.
01 rnd-i BINARY-LONG VALUE 0.
01 rnd-n BINARY-LONG.
01 rnd-a BINARY-LONG.
01 rnd-lo PIC X(128) VALUE
    X"00086ddcdef1956b4bf8fe8c10424a15d32f50f29a1bcd80a1594d245f6e5530d48cd3f9164fc8321cbc348cca7844913e46b8be5bc598e0956819b2fcb6cab68dc50451b5f2912a27e39cc6e1c1db5d7aaff900af8f46ef2ef6a335a36da88702eb195c14918a4d45a64eb0add4a6715ea12932ef316fa4463c0225ab4b889c".
01 rnd-hi PIC X(128) VALUE
    X"0b382a928ae549924d3d62c4876a3fc5c35660cb7165aaf7b57150fa6c07ffed81e24f6b70a667f118dfef78c63a3c528003b8428fe091e051cea32d3f5aa8723b219f5f1c8b7b627dc40f46c2fd360e6de24711a15dba57f48a14347bfb1a24112e34e7e84c1fdd5425d8a5d46ac5f2622b27affe91be5476debb8878a3ecf9".
01 hear-id BINARY-LONG VALUE 0.
01 snd-name PIC X(6).
01 sec-mark BINARY-LONG OCCURS 512 TIMES.
01 n-q BINARY-LONG.
01 q-at BINARY-LONG.
01 q-sec BINARY-LONG OCCURS 64 TIMES.
01 q-blk BINARY-LONG OCCURS 64 TIMES.
01 mo-i BINARY-LONG.
01 foe-j BINARY-LONG.
01 who-i BINARY-LONG.
01 cls-n BINARY-LONG.
01 spd-u BINARY-LONG.
01 ball-spd BINARY-LONG.
01 ball-mul BINARY-LONG.
01 shot-k BINARY-LONG.
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
01 left-v BINARY-LONG.
01 right-v BINARY-LONG.
01 sh1 BINARY-LONG.
01 sh2 BINARY-LONG.
01 m1 BINARY-LONG.
01 m2 BINARY-LONG.
01 den BINARY-LONG.
01 numv BINARY-LONG.
01 frac BINARY-LONG.
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
COPY "mapstate.cpy".
COPY "playstate.cpy".
COPY "sprstate.cpy".

LINKAGE SECTION.
01 moved-out BINARY-LONG.

PROCEDURE DIVISION USING moved-out.
main-enemy.
    IF dirs-on = 0
        PERFORM fill-dirs
        MOVE 1 TO dirs-on
    END-IF
    MOVE 0 TO moved-out
    MOVE ply-x TO walk-x
    MOVE ply-y TO walk-y
    PERFORM locate-sec
    MOVE sec-slot TO ply-sec
    PERFORM hear-shot
    PERFORM VARYING mo-i FROM 1 BY 1 UNTIL mo-i > n-mobj
        MOVE mo-i TO who-i
        IF mo-kind(who-i) = 4
            PERFORM fly-ball
        ELSE
            CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 4
                RETURNING bit-n
            IF bit-n NOT = 0
                PERFORM think-one
            END-IF
        END-IF
    END-PERFORM
    GOBACK.

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
    MOVE 47000 TO ys(8)
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
        MOVE 20 TO spd-u
    END-IF
    IF cls-n = 0
        EXIT PARAGRAPH
    END-IF
    IF cls-n = 5
        PERFORM skul-one
        EXIT PARAGRAPH
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
    MOVE mo-x(who-i) TO walk-x
    MOVE mo-y(who-i) TO walk-y
    PERFORM locate-sec
    MOVE sec-slot TO mon-sec
    IF hear-id > 0 AND mon-sec >= 1 AND mon-sec <= 512
        IF sec-mark(mon-sec) = hear-id
            CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 32
                RETURNING bit-n
            IF bit-n = 0
                PERFORM go-chase
                EXIT PARAGRAPH
            END-IF
        END-IF
    END-IF
    IF mo-wait(who-i) > 0
        SUBTRACT 1 FROM mo-wait(who-i)
        EXIT PARAGRAPH
    END-IF
    MOVE 8 TO mo-wait(who-i)
    IF mo-frame(who-i) = 0
        MOVE 1 TO mo-frame(who-i)
    ELSE
        MOVE 0 TO mo-frame(who-i)
    END-IF
    MOVE 1 TO moved-out
    MOVE 1 TO need-face
    PERFORM can-see
    IF see-ok = 1
        PERFORM go-chase
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
    IF mo-name(who-i) = "POSS" OR mo-name(who-i) = "SPOS"
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
    IF mo-name(who-i) = "CPOS"
        MOVE "posit2" TO snd-name
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
    IF mo-ai(who-i) = 0
        PERFORM cry-see
    END-IF
    MOVE 2 TO mo-ai(who-i)
    MOVE 0 TO mo-wait(who-i)
    MOVE 0 TO mo-step(who-i)
    MOVE 8 TO mo-dir(who-i)
    MOVE 0 TO mo-count(who-i)
    MOVE 1 TO moved-out
    .

chase-one.
    IF ply-hp <= 0
        EXIT PARAGRAPH
    END-IF
    IF mo-wait(who-i) > 0
        SUBTRACT 1 FROM mo-wait(who-i)
        EXIT PARAGRAPH
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
    IF mo-name(who-i) = "HEAD" OR mo-name(who-i) = "PAIN"
        PERFORM float-z
    END-IF
    IF cls-n = 2 OR cls-n = 4
        MOVE 2 TO mo-wait(who-i)
    ELSE
        MOVE 3 TO mo-wait(who-i)
    END-IF
    MOVE 1 TO moved-out
    PERFORM one-chase
    .

one-chase.
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
    IF cls-n = 2 OR cls-n = 3 OR cls-n = 4
        IF mo-name(who-i) NOT = "BSPI"
            AND mo-name(who-i) NOT = "CYBR"
            AND mo-name(who-i) NOT = "FATT"
            AND mo-name(who-i) NOT = "PAIN"
            AND mo-name(who-i) NOT = "VILE"
            IF dist-n < 3932160
                MOVE 0 TO need-face
                PERFORM can-see
                IF see-ok = 1
                    PERFORM go-attack
                    EXIT PARAGRAPH
                END-IF
            END-IF
        END-IF
    END-IF
    SUBTRACT 1 FROM mo-count(who-i)
    IF mo-count(who-i) < 0
        IF cls-n = 1 OR cls-n = 2 OR cls-n = 4
            PERFORM consider-shot
            IF mo-ai(who-i) = 3
                EXIT PARAGRAPH
            END-IF
        END-IF
        PERFORM new-dir
    ELSE
        PERFORM try-step
        IF step-ok = 0
            PERFORM new-dir
        END-IF
    END-IF
    .

consider-shot.
    MOVE 1 TO need-face
    PERFORM can-see
    IF see-ok = 0
        EXIT PARAGRAPH
    END-IF
    CALL "shar32" USING BY VALUE dist-n BY VALUE 16 RETURNING units
    SUBTRACT 64 FROM units
    IF cls-n = 1
        SUBTRACT 128 FROM units
    END-IF
    IF units < 0
        MOVE 0 TO units
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
    MOVE 3 TO mo-ai(who-i)
    MOVE 0 TO mo-step(who-i)
    MOVE 0 TO mo-wait(who-i)
    MOVE 1 TO moved-out
    .

attack-one.
    IF ply-hp <= 0
        PERFORM go-chase
        EXIT PARAGRAPH
    END-IF
    CALL "point_to_angle" USING
        BY VALUE mo-x(who-i) BY VALUE mo-y(who-i)
        BY VALUE ply-x BY VALUE ply-y
        RETURNING mo-ang(who-i)
    MOVE 1 TO moved-out
    IF mo-wait(who-i) > 0
        SUBTRACT 1 FROM mo-wait(who-i)
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO mo-step(who-i)
    IF cls-n = 1
        PERFORM zom-frame
    ELSE
        PERFORM imp-frame
    END-IF
    .

zom-frame.
    IF mo-step(who-i) = 1
        MOVE 4 TO mo-frame(who-i)
        MOVE 9 TO mo-wait(who-i)
    END-IF
    IF mo-step(who-i) = 2
        MOVE 5 TO mo-frame(who-i)
        MOVE 7 TO mo-wait(who-i)
        PERFORM zom-shot
    END-IF
    IF mo-step(who-i) = 3
        MOVE 4 TO mo-frame(who-i)
        MOVE 7 TO mo-wait(who-i)
    END-IF
    IF mo-step(who-i) >= 4
        PERFORM go-chase
    END-IF
    .

imp-frame.
    IF mo-step(who-i) = 1
        MOVE 4 TO mo-frame(who-i)
        MOVE 7 TO mo-wait(who-i)
    END-IF
    IF mo-step(who-i) = 2
        MOVE 5 TO mo-frame(who-i)
        MOVE 7 TO mo-wait(who-i)
    END-IF
    IF mo-step(who-i) = 3
        MOVE 6 TO mo-frame(who-i)
        MOVE 5 TO mo-wait(who-i)
        PERFORM imp-fire
    END-IF
    IF mo-step(who-i) >= 4
        PERFORM go-chase
    END-IF
    .

zom-shot.
    MOVE 1 TO shot-k
    IF mo-name(who-i) = "SPID"
        MOVE 3 TO shot-k
    END-IF
    PERFORM shot-k TIMES
        PERFORM zom-once
    END-PERFORM
    .

zom-once.
    IF mo-name(who-i) = "CPOS" OR mo-name(who-i) = "SPID"
        MOVE "shotgn" TO snd-name
    ELSE
        MOVE "pistol" TO snd-name
    END-IF
    CALL "sfx-play" USING snd-name
    MOVE mo-ang(who-i) TO tmp
    PERFORM take-rnd
    MOVE rnd-n TO rnd-a
    PERFORM take-rnd
    SUBTRACT rnd-n FROM rnd-a
    CALL "shl_i" USING BY VALUE rnd-a BY VALUE 20 RETURNING dx
    CALL "add_i32" USING BY VALUE tmp BY VALUE dx RETURNING tmp
    MOVE tmp TO shot-keep
    PERFORM ray-player
    .

imp-fire.
    MOVE 655360 TO ball-spd
    MOVE 3 TO ball-mul
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
    IF mo-name(who-i) = "SKEL" AND dist-n < 4194304
        MOVE "skeswg" TO snd-name
        CALL "sfx-play" USING snd-name
        PERFORM take-rnd
        DIVIDE rnd-n BY 8 GIVING q-n REMAINDER rem-n
        ADD 1 TO rem-n
        MULTIPLY rem-n BY 6 GIVING dmg
        PERFORM hurt-player
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
    IF cls-n = 3 OR dist-n < 4194304
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
        PERFORM hurt-player
    ELSE
        MOVE "BAL1" TO ball-name
        IF cls-n = 4
            MOVE "BAL7" TO ball-name
        END-IF
        IF mo-name(who-i) = "HEAD"
            MOVE "BAL2" TO ball-name
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

hurt-player.
    IF ply-god = 1 OR ply-inv > 0
        EXIT PARAGRAPH
    END-IF
    IF ply-invis > 0
        PERFORM take-rnd
        IF rnd-n < 128
            EXIT PARAGRAPH
        END-IF
    END-IF
    SUBTRACT dmg FROM ply-hp
    IF ply-hp < 0
        MOVE 0 TO ply-hp
    END-IF
    ADD dmg TO ply-pain
    IF ply-pain > 100
        MOVE 100 TO ply-pain
    END-IF
    MOVE 0 TO atk-on
    IF who-i >= 1 AND who-i <= n-mobj
        MOVE 1 TO atk-on
        MOVE mo-x(who-i) TO atk-x
        MOVE mo-y(who-i) TO atk-y
    END-IF
    CALL "face-hit" USING dmg atk-on atk-x atk-y
    CALL "ply-ouch"
    IF atk-on = 1
        CALL "push-ply" USING dmg atk-x atk-y
    END-IF
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
    IF n-mobj >= 768
        EXIT PARAGRAPH
    END-IF
    CALL "fine_cos_ang" USING BY VALUE mo-ang(who-i) RETURNING cs
    CALL "fine_sin_ang" USING BY VALUE mo-ang(who-i) RETURNING sn
    CALL "fixed_mul" USING BY VALUE cs BY VALUE 2097152 RETURNING dx
    CALL "fixed_mul" USING BY VALUE sn BY VALUE 2097152 RETURNING dy
    ADD 1 TO n-mobj
    CALL "add_i32" USING BY VALUE mo-x(who-i) BY VALUE dx
        RETURNING mo-x(n-mobj)
    CALL "add_i32" USING BY VALUE mo-y(who-i) BY VALUE dy
        RETURNING mo-y(n-mobj)
    CALL "add_i32" USING BY VALUE mo-z(who-i) BY VALUE 2097152
        RETURNING mo-z(n-mobj)
    MOVE ball-name TO mo-name(n-mobj)
    MOVE 32768 TO mo-frame(n-mobj)
    MOVE 0 TO mo-flags(n-mobj)
    MOVE 4 TO mo-kind(n-mobj)
    MOVE 0 TO mo-ai(n-mobj)
    MOVE 0 TO mo-step(n-mobj)
    MOVE mo-ang(who-i) TO mo-ang(n-mobj)
    MOVE 1048576 TO mo-h(n-mobj)
    MOVE 393216 TO mo-rad(n-mobj)
    CALL "fixed_mul" USING BY VALUE ball-spd BY VALUE cs
        RETURNING mo-mx(n-mobj)
    CALL "fixed_mul" USING BY VALUE ball-spd BY VALUE sn
        RETURNING mo-my(n-mobj)
    PERFORM measure
    CALL "shar32" USING BY VALUE dist-n BY VALUE 16 RETURNING units
    IF units < 1
        MOVE 1 TO units
    END-IF
    CALL "add_i32" USING BY VALUE ply-z BY VALUE 2097152 RETURNING tmp
    CALL "sub_i32" USING BY VALUE tmp BY VALUE mo-z(n-mobj)
        RETURNING tmp
    DIVIDE tmp BY units GIVING dx
    CALL "mul_i32" USING BY VALUE dx BY VALUE 10 RETURNING mo-mz(n-mobj)
    PERFORM take-rnd
    DIVIDE rnd-n BY 8 GIVING q-n REMAINDER rem-n
    ADD 1 TO rem-n
    MULTIPLY rem-n BY ball-mul GIVING mo-hp(n-mobj)
    MOVE 1 TO moved-out
    .

spawn-soul.
    IF n-mobj >= 768
        EXIT PARAGRAPH
    END-IF
    CALL "fine_cos_ang" USING BY VALUE mo-ang(who-i) RETURNING cs
    CALL "fine_sin_ang" USING BY VALUE mo-ang(who-i) RETURNING sn
    CALL "fixed_mul" USING BY VALUE cs BY VALUE 2097152 RETURNING dx
    CALL "fixed_mul" USING BY VALUE sn BY VALUE 2097152 RETURNING dy
    ADD 1 TO n-mobj
    CALL "add_i32" USING BY VALUE mo-x(who-i) BY VALUE dx
        RETURNING mo-x(n-mobj)
    CALL "add_i32" USING BY VALUE mo-y(who-i) BY VALUE dy
        RETURNING mo-y(n-mobj)
    MOVE mo-z(who-i) TO mo-z(n-mobj)
    MOVE "SKUL" TO mo-name(n-mobj)
    MOVE 0 TO mo-frame(n-mobj)
    MOVE 4194310 TO mo-flags(n-mobj)
    MOVE 0 TO mo-kind(n-mobj)
    MOVE 4 TO mo-ai(n-mobj)
    MOVE 0 TO mo-step(n-mobj)
    MOVE 0 TO mo-seq(n-mobj)
    MOVE 0 TO mo-tic(n-mobj)
    MOVE 0 TO mo-count(n-mobj)
    MOVE 8 TO mo-dir(n-mobj)
    MOVE 0 TO mo-wait(n-mobj)
    MOVE mo-ang(who-i) TO mo-ang(n-mobj)
    MOVE 3670016 TO mo-h(n-mobj)
    MOVE 1048576 TO mo-rad(n-mobj)
    MOVE 100 TO mo-hp(n-mobj)
    MOVE 100 TO mo-max(n-mobj)
    MOVE 0 TO mo-mx(n-mobj)
    MOVE 0 TO mo-my(n-mobj)
    MOVE 0 TO mo-mz(n-mobj)
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
    IF mo-ai(who-i) = 0
        MOVE 1 TO need-face
        PERFORM can-see
        IF see-ok = 1
            MOVE "sklatk" TO snd-name
            CALL "sfx-play" USING snd-name
            MOVE 4 TO mo-ai(who-i)
        END-IF
        EXIT PARAGRAPH
    END-IF
    CALL "point_to_angle" USING
        BY VALUE mo-x(who-i) BY VALUE mo-y(who-i)
        BY VALUE ply-x BY VALUE ply-y
        RETURNING mo-ang(who-i)
    CALL "fine_cos_ang" USING BY VALUE mo-ang(who-i) RETURNING cs
    CALL "fine_sin_ang" USING BY VALUE mo-ang(who-i) RETURNING sn
    CALL "fixed_mul" USING BY VALUE 1310720 BY VALUE cs RETURNING tdx
    CALL "fixed_mul" USING BY VALUE 1310720 BY VALUE sn RETURNING tdy
    CALL "add_i32" USING BY VALUE mo-x(who-i) BY VALUE tdx RETURNING nx
    CALL "add_i32" USING BY VALUE mo-y(who-i) BY VALUE tdy RETURNING ny
    PERFORM spot-free
    IF step-ok = 1
        MOVE nx TO mo-x(who-i)
        MOVE ny TO mo-y(who-i)
        MOVE 1 TO moved-out
    ELSE
        PERFORM measure
        IF dist-n < 4194304
            PERFORM take-rnd
            DIVIDE rnd-n BY 8 GIVING q-n REMAINDER rem-n
            ADD 1 TO rem-n
            MULTIPLY rem-n BY 3 GIVING dmg
            PERFORM hurt-player
        END-IF
        MOVE 0 TO mo-ai(who-i)
    END-IF
    PERFORM float-z
    .

float-z.
    CALL "add_i32" USING BY VALUE ply-z BY VALUE 2097152 RETURNING tmp
    CALL "sub_i32" USING BY VALUE tmp BY VALUE mo-z(who-i) RETURNING dx
    IF dx > 262144
        CALL "add_i32" USING BY VALUE mo-z(who-i) BY VALUE 262144
            RETURNING mo-z(who-i)
    ELSE
        IF dx < -262144
            CALL "sub_i32" USING BY VALUE mo-z(who-i) BY VALUE 262144
                RETURNING mo-z(who-i)
        END-IF
    END-IF
    MOVE 1 TO moved-out
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
                MOVE 8 TO mo-dir(foe-j)
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
    CALL "add_i32" USING BY VALUE mo-x(who-i) BY VALUE mo-mx(who-i)
        RETURNING nx
    CALL "add_i32" USING BY VALUE mo-y(who-i) BY VALUE mo-my(who-i)
        RETURNING ny
    CALL "add_i32" USING BY VALUE mo-z(who-i) BY VALUE mo-mz(who-i)
        RETURNING nz
    MOVE 0 TO hurt-pl
    MOVE 0 TO blocked
    PERFORM ball-hit
    IF blocked = 1
        IF hurt-pl = 1
            MOVE mo-hp(who-i) TO dmg
            PERFORM hurt-player
        END-IF
        MOVE 9 TO mo-ai(who-i)
        MOVE 32770 TO mo-frame(who-i)
        MOVE 6 TO mo-wait(who-i)
        MOVE 0 TO mo-mx(who-i)
        MOVE 0 TO mo-my(who-i)
        MOVE 0 TO mo-mz(who-i)
        MOVE 1 TO moved-out
    ELSE
        MOVE nx TO mo-x(who-i)
        MOVE ny TO mo-y(who-i)
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
    IF sec-slot >= 1 AND sec-slot <= n-sector
        IF nz <= sec-floor-h(sec-slot)
            OR nz >= sec-ceil-h(sec-slot)
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
    MOVE mo-x(who-i) TO ox
    MOVE mo-y(who-i) TO oy
    CALL "sub_i32" USING BY VALUE nx BY VALUE ox RETURNING tdx
    CALL "sub_i32" USING BY VALUE ny BY VALUE oy RETURNING tdy
    PERFORM VARYING li FROM 1 BY 1 UNTIL li > n-line OR blocked = 1
        PERFORM cross-one
        IF did-cross = 0
            PERFORM ball-near
        END-IF
        IF did-cross = 1
            PERFORM open-of
            IF two-side = 0 OR op-bot >= op-top
                MOVE 1 TO blocked
            ELSE
                CALL "add_i32" USING BY VALUE nz BY VALUE mo-h(who-i)
                    RETURNING tmp
                IF tmp >= op-top OR nz <= op-bot
                    MOVE 1 TO blocked
                END-IF
            END-IF
        END-IF
    END-PERFORM
    .

ray-player.
    MOVE mo-x(who-i) TO ox
    MOVE mo-y(who-i) TO oy
    CALL "fine_cos_ang" USING BY VALUE shot-keep RETURNING cs
    CALL "fine_sin_ang" USING BY VALUE shot-keep RETURNING sn
    CALL "mul_i32" USING BY VALUE cs BY VALUE 2048 RETURNING tdx
    CALL "mul_i32" USING BY VALUE sn BY VALUE 2048 RETURNING tdy
    MOVE 999999 TO wall-fr
    PERFORM VARYING li FROM 1 BY 1 UNTIL li > n-line
        PERFORM cross-one
        IF did-cross = 1 AND frac > 0 AND frac < wall-fr
            PERFORM open-of
            IF two-side = 0 OR op-bot >= op-top
                MOVE frac TO wall-fr
            END-IF
        END-IF
    END-PERFORM
    MOVE 0 TO ply-fr
    CALL "sub_i32" USING BY VALUE ply-x BY VALUE ox RETURNING wx
    CALL "sub_i32" USING BY VALUE ply-y BY VALUE oy RETURNING wy
    CALL "fixed_mul" USING BY VALUE wx BY VALUE cs RETURNING along
    CALL "fixed_mul" USING BY VALUE wy BY VALUE sn RETURNING tmp
    CALL "add_i32" USING BY VALUE along BY VALUE tmp RETURNING along
    IF along > 0
        CALL "fixed_mul" USING BY VALUE wx BY VALUE sn RETURNING dx
        CALL "fixed_mul" USING BY VALUE wy BY VALUE cs RETURNING dy
        CALL "sub_i32" USING BY VALUE dx BY VALUE dy RETURNING dx
        CALL "abs_fixed_i" USING BY VALUE dx RETURNING dx
        CALL "add_i32" USING BY VALUE ply-rad BY VALUE 262144
            RETURNING reach
        IF dx < reach
            DIVIDE along BY 2048 GIVING ply-fr
        END-IF
    END-IF
    IF ply-fr > 0 AND ply-fr < wall-fr
        PERFORM take-rnd
        DIVIDE rnd-n BY 5 GIVING q-n REMAINDER rem-n
        ADD 1 TO rem-n
        MULTIPLY rem-n BY 3 GIVING dmg
        PERFORM hurt-player
    ELSE
        IF wall-fr < 65536
            PERFORM puff-at
        END-IF
    END-IF
    .

puff-at.
    IF n-mobj >= 768
        EXIT PARAGRAPH
    END-IF
    CALL "fixed_mul" USING BY VALUE tdx BY VALUE wall-fr RETURNING nx
    CALL "add_i32" USING BY VALUE ox BY VALUE nx RETURNING nx
    CALL "fixed_mul" USING BY VALUE tdy BY VALUE wall-fr RETURNING ny
    CALL "add_i32" USING BY VALUE oy BY VALUE ny RETURNING ny
    ADD 1 TO n-mobj
    MOVE nx TO mo-x(n-mobj)
    MOVE ny TO mo-y(n-mobj)
    CALL "add_i32" USING BY VALUE mo-z(who-i) BY VALUE 2097152
        RETURNING mo-z(n-mobj)
    MOVE "PUFF" TO mo-name(n-mobj)
    MOVE 32768 TO mo-frame(n-mobj)
    MOVE 0 TO mo-flags(n-mobj)
    MOVE 1 TO mo-kind(n-mobj)
    MOVE 4 TO mo-tic(n-mobj)
    MOVE 0 TO mo-ai(n-mobj)
    MOVE 0 TO mo-step(n-mobj)
    MOVE 1 TO moved-out
    .

new-dir.
    MOVE mo-dir(who-i) TO old-d
    MOVE 8 TO turn-d
    IF old-d >= 0 AND old-d <= 7
        COMPUTE turn-d = old-d + 4
        IF turn-d > 7
            SUBTRACT 8 FROM turn-d
        END-IF
    END-IF
    CALL "sub_i32" USING BY VALUE ply-x BY VALUE mo-x(who-i)
        RETURNING dx
    CALL "sub_i32" USING BY VALUE ply-y BY VALUE mo-y(who-i)
        RETURNING dy
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
    CALL "abs_fixed_i" USING BY VALUE dx RETURNING m1
    CALL "abs_fixed_i" USING BY VALUE dy RETURNING m2
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
    PERFORM take-rnd
    CALL "bit_and" USING BY VALUE rnd-n BY VALUE 1 RETURNING scan-i
    IF scan-i = 0
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
    ELSE
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
    END-IF
    IF turn-d >= 0 AND turn-d <= 7
        MOVE turn-d TO pick
        PERFORM try-pick
        IF step-ok = 1
            PERFORM hold-dir
            EXIT PARAGRAPH
        END-IF
    END-IF
    MOVE 8 TO mo-dir(who-i)
    PERFORM hold-dir
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
    IF step-ok = 0
        EXIT PARAGRAPH
    END-IF
    MOVE nx TO mo-x(who-i)
    MOVE ny TO mo-y(who-i)
    MOVE nx TO walk-x
    MOVE ny TO walk-y
    PERFORM locate-sec
    IF sec-slot >= 1 AND sec-slot <= n-sector
        MOVE sec-floor-h(sec-slot) TO mo-z(who-i)
    END-IF
    MOVE 1 TO step-ok
    MOVE 1 TO moved-out
    .

spot-free.
    MOVE 1 TO step-ok
    CALL "sub_i32" USING BY VALUE nx BY VALUE ply-x RETURNING dx
    CALL "abs_fixed_i" USING BY VALUE dx RETURNING dx
    CALL "sub_i32" USING BY VALUE ny BY VALUE ply-y RETURNING dy
    CALL "abs_fixed_i" USING BY VALUE dy RETURNING dy
    CALL "add_i32" USING BY VALUE mo-rad(who-i) BY VALUE ply-rad
        RETURNING reach
    IF dx < reach AND dy < reach AND ply-hp > 0
        MOVE 0 TO step-ok
        EXIT PARAGRAPH
    END-IF
    PERFORM VARYING li FROM 1 BY 1 UNTIL li > n-mobj OR step-ok = 0
        IF li NOT = who-i
            CALL "bit_and" USING BY VALUE mo-flags(li) BY VALUE 2
                RETURNING bit-n
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
                END-IF
            END-IF
        END-IF
    END-PERFORM
    IF step-ok = 0
        EXIT PARAGRAPH
    END-IF
    MOVE mo-x(who-i) TO ox
    MOVE mo-y(who-i) TO oy
    PERFORM VARYING li FROM 1 BY 1 UNTIL li > n-line OR step-ok = 0
        PERFORM cross-one
        IF did-cross = 1 AND frac > 0 AND frac < 65536
            PERFORM open-of
            IF two-side = 0
                MOVE 0 TO step-ok
            ELSE
                CALL "bit_and" USING BY VALUE ln-flags(li) BY VALUE 3
                    RETURNING bit-n
                IF bit-n NOT = 0 OR op-bot >= op-top
                    MOVE 0 TO step-ok
                ELSE
                    IF fs >= 1 AND fs <= n-sector
                        AND bs >= 1 AND bs <= n-sector
                        MOVE sec-floor-h(fs) TO m1
                        IF sec-floor-h(bs) < m1
                            MOVE sec-floor-h(bs) TO m1
                        END-IF
                        CALL "sub_i32" USING BY VALUE mo-z(who-i)
                            BY VALUE m1 RETURNING tmp
                        IF tmp >= 1572864
                            MOVE 0 TO step-ok
                        END-IF
                    END-IF
                    IF step-ok = 1
                        CALL "add_i32" USING BY VALUE mo-z(who-i)
                            BY VALUE mo-h(who-i) RETURNING tmp
                        IF tmp > op-top
                            MOVE 0 TO step-ok
                        ELSE
                            CALL "sub_i32" USING BY VALUE op-bot
                                BY VALUE mo-z(who-i) RETURNING tmp
                            IF tmp > 1572864
                                MOVE 0 TO step-ok
                            END-IF
                        END-IF
                    END-IF
                END-IF
            END-IF
        END-IF
    END-PERFORM
    IF step-ok = 0
        EXIT PARAGRAPH
    END-IF
    MOVE mo-x(who-i) TO walk-x
    MOVE mo-y(who-i) TO walk-y
    PERFORM locate-sec
    MOVE sec-slot TO mon-sec
    MOVE nx TO walk-x
    MOVE ny TO walk-y
    PERFORM locate-sec
    IF mon-sec >= 1 AND mon-sec <= n-sector
        AND sec-slot >= 1 AND sec-slot <= n-sector
        CALL "sub_i32" USING BY VALUE sec-floor-h(sec-slot)
            BY VALUE sec-floor-h(mon-sec) RETURNING tmp
        IF tmp < 0
            CALL "abs_fixed_i" USING BY VALUE tmp RETURNING tmp
            IF tmp >= 1572864
                MOVE 0 TO step-ok
            END-IF
        ELSE
            IF tmp > 1572864
                MOVE 0 TO step-ok
            END-IF
        END-IF
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

can-see.
    MOVE 0 TO see-ok
    IF ply-hp <= 0
        EXIT PARAGRAPH
    END-IF
    PERFORM measure
    IF dist-n > 98304000
        EXIT PARAGRAPH
    END-IF
    IF need-face = 1
        CALL "fine_cos_ang" USING BY VALUE mo-ang(who-i) RETURNING cs
        CALL "fine_sin_ang" USING BY VALUE mo-ang(who-i) RETURNING sn
        CALL "sub_i32" USING BY VALUE ply-x BY VALUE mo-x(who-i)
            RETURNING wx
        CALL "sub_i32" USING BY VALUE ply-y BY VALUE mo-y(who-i)
            RETURNING wy
        CALL "fixed_mul" USING BY VALUE wx BY VALUE cs RETURNING along
        CALL "fixed_mul" USING BY VALUE wy BY VALUE sn RETURNING tmp
        CALL "add_i32" USING BY VALUE along BY VALUE tmp RETURNING along
        IF along <= 0 AND dist-n > 4194304
            EXIT PARAGRAPH
        END-IF
    END-IF
    MOVE mo-x(who-i) TO walk-x
    MOVE mo-y(who-i) TO walk-y
    PERFORM locate-sec
    MOVE sec-slot TO mon-sec
    IF mon-sec < 1 OR ply-sec < 1
        EXIT PARAGRAPH
    END-IF
    IF mon-sec = ply-sec
        MOVE 1 TO see-ok
        EXIT PARAGRAPH
    END-IF
    COMPUTE pnum = (mon-sec - 1) * n-sector + (ply-sec - 1)
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
    CALL "sub_i32" USING BY VALUE ply-x BY VALUE ox RETURNING tdx
    CALL "sub_i32" USING BY VALUE ply-y BY VALUE oy RETURNING tdy
    MOVE 1 TO see-ok
    PERFORM VARYING li FROM 1 BY 1 UNTIL li > n-line OR see-ok = 0
        PERFORM cross-one
        IF did-cross = 1 AND frac > 0 AND frac < 65536
            PERFORM open-of
            IF two-side = 0 OR op-bot >= op-top
                MOVE 0 TO see-ok
            END-IF
        END-IF
    END-PERFORM
    .

measure.
    CALL "sub_i32" USING BY VALUE ply-x BY VALUE mo-x(who-i)
        RETURNING dx
    CALL "sub_i32" USING BY VALUE ply-y BY VALUE mo-y(who-i)
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
    IF ply-shot NOT = 1
        EXIT PARAGRAPH
    END-IF
    MOVE 0 TO ply-shot
    ADD 1 TO hear-id
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
        IF fs >= 1 AND fs <= 512
            IF sec-mark(fs) NOT = hear-id
                MOVE hear-id TO sec-mark(fs)
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
        IF other-sec >= 1 AND other-sec <= 512 AND n-q < 64
            CALL "bit_and" USING BY VALUE ln-flags(li) BY VALUE 4
                RETURNING bit-n
            IF bit-n NOT = 0
                PERFORM open-of
                IF op-top > op-bot
                    MOVE q-blk(q-at) TO new-blk
                    CALL "bit_and" USING BY VALUE ln-flags(li) BY VALUE 64
                        RETURNING bit-n
                    IF bit-n = 0 OR new-blk = 0
                        IF bit-n NOT = 0
                            MOVE 1 TO new-blk
                        END-IF
                        ADD 1 TO n-q
                        MOVE other-sec TO q-sec(n-q)
                        MOVE new-blk TO q-blk(n-q)
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
    CALL "point_side" USING
        BY VALUE vtx-x(ln-v1(li)) BY VALUE vtx-y(ln-v1(li))
        BY VALUE sh1 BY VALUE sh2
        BY VALUE box-l BY VALUE box-b
        RETURNING side-a
    MOVE 0 TO corner-n
    CALL "point_side" USING
        BY VALUE vtx-x(ln-v1(li)) BY VALUE vtx-y(ln-v1(li))
        BY VALUE sh1 BY VALUE sh2
        BY VALUE box-l BY VALUE box-t
        RETURNING side-bit
    IF side-bit NOT = side-a
        MOVE 1 TO corner-n
    END-IF
    CALL "point_side" USING
        BY VALUE vtx-x(ln-v1(li)) BY VALUE vtx-y(ln-v1(li))
        BY VALUE sh1 BY VALUE sh2
        BY VALUE box-r BY VALUE box-b
        RETURNING side-bit
    IF side-bit NOT = side-a
        MOVE 1 TO corner-n
    END-IF
    CALL "point_side" USING
        BY VALUE vtx-x(ln-v1(li)) BY VALUE vtx-y(ln-v1(li))
        BY VALUE sh1 BY VALUE sh2
        BY VALUE box-r BY VALUE box-t
        RETURNING side-bit
    IF side-bit NOT = side-a
        MOVE 1 TO corner-n
    END-IF
    IF corner-n = 1
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

take-rnd.
    ADD 1 TO rnd-i
    CALL "bit_and" USING BY VALUE rnd-i BY VALUE 255 RETURNING rnd-i
    IF rnd-i < 128
        CALL "byte_at" USING BY REFERENCE rnd-lo BY VALUE rnd-i
            RETURNING rnd-n
    ELSE
        COMPUTE tmp = rnd-i - 128
        CALL "byte_at" USING BY REFERENCE rnd-hi BY VALUE tmp
            RETURNING rnd-n
    END-IF
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
