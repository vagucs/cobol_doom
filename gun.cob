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
*> Armas na ordem do Doom: 1 soco, 2 pistola, 3 espingarda,
*> 4 metralhadora, 5 missil, 6 plasma, 7 BFG. Sem rato.
IDENTIFICATION DIVISION.
PROGRAM-ID. gun-tic.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 die-on BINARY-LONG VALUE 0.
01 snd-name PIC X(6).
01 die-len BINARY-LONG OCCURS 5 TIMES.
01 die-fr BINARY-LONG OCCURS 40 TIMES.
01 die-tic BINARY-LONG OCCURS 40 TIMES.
01 gun-step BINARY-LONG VALUE 0.
01 gun-tics BINARY-LONG VALUE 0.
01 gun-flash-n BINARY-LONG VALUE 0.
01 gun-down BINARY-LONG VALUE 0.
01 gun-refire BINARY-LONG VALUE 0.
01 rnd-i BINARY-LONG VALUE 0.
01 rnd-n BINARY-LONG.
01 rnd-a BINARY-LONG.
01 rnd-lo PIC X(128) VALUE
    X"00086ddcdef1956b4bf8fe8c10424a15d32f50f29a1bcd80a1594d245f6e5530d48cd3f9164fc8321cbc348cca7844913e46b8be5bc598e0956819b2fcb6cab68dc50451b5f2912a27e39cc6e1c1db5d7aaff900af8f46ef2ef6a335a36da88702eb195c14918a4d45a64eb0add4a6715ea12932ef316fa4463c0225ab4b889c".
01 rnd-hi PIC X(128) VALUE
    X"0b382a928ae549924d3d62c4876a3fc5c35660cb7165aaf7b57150fa6c07ffed81e24f6b70a667f118dfef78c63a3c528003b8428fe091e051cea32d3f5aa8723b219f5f1c8b7b627dc40f46c2fd360e6de24711a15dba57f48a14347bfb1a24112e34e7e84c1fdd5425d8a5d46ac5f2622b27affe91be5476debb8878a3ecf9".
01 n-hit BINARY-LONG.
01 hit-kind BINARY-LONG OCCURS 128 TIMES.
01 hit-ln BINARY-LONG OCCURS 128 TIMES.
01 hit-fr BINARY-LONG OCCURS 128 TIMES.
01 hit-mo BINARY-LONG OCCURS 128 TIMES.
01 ox BINARY-LONG.
01 oy BINARY-LONG.
01 tdx BINARY-LONG.
01 tdy BINARY-LONG.
01 cs BINARY-LONG.
01 sn BINARY-LONG.
01 li BINARY-LONG.
01 hi BINARY-LONG.
01 hj BINARY-LONG.
01 best BINARY-LONG.
01 mo-i BINARY-LONG.
01 who-i BINARY-LONG.
01 dx BINARY-LONG.
01 dy BINARY-LONG.
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
01 wx BINARY-LONG.
01 wy BINARY-LONG.
01 along BINARY-LONG.
01 perp BINARY-LONG.
01 reach BINARY-LONG.
01 tmp BINARY-LONG.
01 bit-n BINARY-LONG.
01 range-u BINARY-LONG.
01 range-fu BINARY-LONG.
01 trace-mode BINARY-LONG.
01 try-ang BINARY-LONG.
01 shot-ang BINARY-LONG.
01 shoot-z BINARY-LONG.
01 half-h BINARY-LONG.
01 aim-sl BINARY-LONG.
01 aim-mo BINARY-LONG.
01 aim-span BINARY-LONG VALUE 40960.
01 win-top BINARY-LONG.
01 win-bot BINARY-LONG.
01 hold-top BINARY-LONG.
01 hold-bot BINARY-LONG.
01 stop-scan BINARY-LONG.
01 dist-n BINARY-LONG.
01 sl-v BINARY-LONG.
01 thing-top BINARY-LONG.
01 thing-bot BINARY-LONG.
01 two-side BINARY-LONG.
01 fs BINARY-LONG.
01 bs BINARY-LONG.
01 op-top BINARY-LONG.
01 op-bot BINARY-LONG.
01 fl-diff BINARY-LONG.
01 cl-diff BINARY-LONG.
01 did-hit BINARY-LONG.
01 back-n BINARY-LONG.
01 frac-v BINARY-LONG.
01 zx BINARY-LONG.
01 zy BINARY-LONG.
01 zz BINARY-LONG.
01 dmg BINARY-LONG.
01 atk-on BINARY-LONG.
01 atk-x BINARY-LONG.
01 atk-y BINARY-LONG.
01 rem-n BINARY-LONG.
01 q-n BINARY-LONG.
01 key-n BINARY-LONG.
01 can-n BINARY-LONG.
01 melee-n BINARY-LONG VALUE 0.
01 pellet-n BINARY-LONG.
01 saw-tic BINARY-LONG VALUE 0.
01 go-n BINARY-LONG.
01 bolt-i BINARY-LONG.
01 victim-i BINARY-LONG.
01 sec-at BINARY-LONG.
01 bsp-n BINARY-LONG.
01 node-at BINARY-LONG.
01 sub-at BINARY-LONG.
01 sub-n BINARY-LONG.
01 hop-n BINARY-LONG.
01 walk-x BINARY-LONG.
01 walk-y BINARY-LONG.
01 did-cross BINARY-LONG.
01 boom-n BINARY-LONG.
01 spd-n BINARY-LONG.
01 rad-n BINARY-LONG.
01 base-d BINARY-LONG.
01 mo-hold BINARY-LONG.
01 bolt-name PIC X(4).
01 units-n BINARY-LONG.
01 ang-n BINARY-LONG.
01 delta-n BINARY-LONG.
01 spot-x BINARY-LONG.
01 spot-y BINARY-LONG.
01 spot-z BINARY-LONG.
01 nx BINARY-LONG.
01 ny BINARY-LONG.
01 nz BINARY-LONG.
01 blob-name PIC X(4).
01 blob-fr BINARY-LONG.
01 blob-tic BINARY-LONG.
01 blob-kind BINARY-LONG.
01 slot BINARY-LONG.
COPY "mapstate.cpy".
COPY "playstate.cpy".
COPY "sprstate.cpy".
COPY "rdata.cpy".

LINKAGE SECTION.
01 fire-held BINARY-LONG.
01 busy-out BINARY-LONG.
01 moved-out BINARY-LONG.

PROCEDURE DIVISION USING fire-held busy-out moved-out.
main-gun.
    IF die-on = 0
        PERFORM fill-die
        MOVE 1 TO die-on
    END-IF
    MOVE 0 TO moved-out
    PERFORM tick-fx
    PERFORM tick-flash
    PERFORM tick-gun
    PERFORM fly-bolts
    MOVE 0 TO busy-out
    IF gun-mode NOT = 0 OR gun-flash-n > 0
        MOVE 1 TO busy-out
    END-IF
    PERFORM VARYING mo-i FROM 1 BY 1 UNTIL mo-i > n-mobj
        IF mo-tic(mo-i) > 0
            MOVE 1 TO busy-out
        END-IF
    END-PERFORM
    GOBACK.

fill-die.
    MOVE 5 TO die-len(1)
    MOVE 7 TO die-fr(1)
    MOVE 8 TO die-fr(2)
    MOVE 9 TO die-fr(3)
    MOVE 10 TO die-fr(4)
    MOVE 11 TO die-fr(5)
    MOVE 5 TO die-tic(1)
    MOVE 5 TO die-tic(2)
    MOVE 5 TO die-tic(3)
    MOVE 5 TO die-tic(4)
    MOVE -1 TO die-tic(5)
    MOVE 5 TO die-len(2)
    MOVE 8 TO die-fr(9)
    MOVE 9 TO die-fr(10)
    MOVE 10 TO die-fr(11)
    MOVE 11 TO die-fr(12)
    MOVE 12 TO die-fr(13)
    MOVE 8 TO die-tic(9)
    MOVE 8 TO die-tic(10)
    MOVE 6 TO die-tic(11)
    MOVE 6 TO die-tic(12)
    MOVE -1 TO die-tic(13)
    MOVE 6 TO die-len(3)
    MOVE 8 TO die-fr(17)
    MOVE 9 TO die-fr(18)
    MOVE 10 TO die-fr(19)
    MOVE 11 TO die-fr(20)
    MOVE 12 TO die-fr(21)
    MOVE 13 TO die-fr(22)
    MOVE 8 TO die-tic(17)
    MOVE 8 TO die-tic(18)
    MOVE 4 TO die-tic(19)
    MOVE 4 TO die-tic(20)
    MOVE 4 TO die-tic(21)
    MOVE -1 TO die-tic(22)
    MOVE 7 TO die-len(4)
    MOVE 7 TO die-fr(25)
    MOVE 8 TO die-fr(26)
    MOVE 9 TO die-fr(27)
    MOVE 10 TO die-fr(28)
    MOVE 11 TO die-fr(29)
    MOVE 12 TO die-fr(30)
    MOVE 13 TO die-fr(31)
    MOVE 5 TO die-tic(25)
    MOVE 5 TO die-tic(26)
    MOVE 5 TO die-tic(27)
    MOVE 5 TO die-tic(28)
    MOVE 5 TO die-tic(29)
    MOVE 5 TO die-tic(30)
    MOVE -1 TO die-tic(31)
    MOVE 6 TO die-len(5)
    MOVE 6 TO die-fr(33)
    MOVE 7 TO die-fr(34)
    MOVE 8 TO die-fr(35)
    MOVE 9 TO die-fr(36)
    MOVE 10 TO die-fr(37)
    MOVE 11 TO die-fr(38)
    MOVE 8 TO die-tic(33)
    MOVE 8 TO die-tic(34)
    MOVE 8 TO die-tic(35)
    MOVE 8 TO die-tic(36)
    MOVE 8 TO die-tic(37)
    MOVE -1 TO die-tic(38)
    .

tick-flash.
    IF gun-flash-n > 0
        SUBTRACT 1 FROM gun-flash-n
        IF gun-flash-n <= 0
            MOVE 0 TO gun-flash-n
            MOVE SPACES TO gun-flash
            MOVE 1 TO moved-out
        END-IF
    END-IF
    .

tick-gun.
    IF ply-hp <= 0
        EXIT PARAGRAPH
    END-IF
    PERFORM read-choice
    IF gun-mode = 2
        PERFORM lower-gun
        EXIT PARAGRAPH
    END-IF
    IF gun-mode = 3
        PERFORM raise-gun
        EXIT PARAGRAPH
    END-IF
    IF gun-mode = 1
        IF fire-held = 1
            MOVE 1 TO gun-down
        END-IF
        IF gun-tics > 0
            SUBTRACT 1 FROM gun-tics
        END-IF
        IF gun-tics > 0
            EXIT PARAGRAPH
        END-IF
        ADD 1 TO gun-step
        PERFORM enter-step
        IF gun-mode = 0 AND fire-held = 1 AND ply-on = 1
            AND ply-weap NOT = 5 AND ply-weap NOT = 7
            PERFORM can-fire
            IF can-n = 1
                MOVE 1 TO gun-mode
                MOVE 0 TO gun-step
                MOVE 1 TO gun-down
                PERFORM enter-step
            END-IF
        END-IF
        EXIT PARAGRAPH
    END-IF
    PERFORM saw-idle
    IF ply-pend NOT = 0 AND ply-pend NOT = ply-weap
        MOVE 2 TO gun-mode
        PERFORM lower-gun
        EXIT PARAGRAPH
    END-IF
    PERFORM can-fire
    IF fire-held = 1 AND can-n = 1 AND ply-on = 1
        MOVE 1 TO go-n
        IF gun-down = 1 AND (ply-weap = 5 OR ply-weap = 7)
            MOVE 0 TO go-n
        END-IF
        IF go-n = 1
            MOVE 1 TO gun-mode
            MOVE 0 TO gun-step
            MOVE 1 TO gun-down
            PERFORM enter-step
            EXIT PARAGRAPH
        END-IF
    END-IF
    IF fire-held = 1 AND can-n = 0 AND ply-ammo >= 1
        IF ply-weap = 3 OR ply-weap = 4 OR ply-weap = 5
            OR ply-weap = 6 OR ply-weap = 7
            MOVE 2 TO ply-pend
        END-IF
    END-IF
    IF fire-held = 0
        MOVE 0 TO gun-down
        MOVE 0 TO gun-refire
    END-IF
    .

read-choice.
    CALL "video_key" USING BY VALUE 49 RETURNING key-n
    IF key-n = 1
        IF ply-saw = 1 AND ply-weap NOT = 8
            MOVE 8 TO ply-pend
        ELSE
            MOVE 1 TO ply-pend
        END-IF
    END-IF
    CALL "video_key" USING BY VALUE 50 RETURNING key-n
    IF key-n = 1
        MOVE 2 TO ply-pend
    END-IF
    CALL "video_key" USING BY VALUE 51 RETURNING key-n
    IF key-n = 1 AND ply-sg = 1
        MOVE 3 TO ply-pend
    END-IF
    CALL "video_key" USING BY VALUE 52 RETURNING key-n
    IF key-n = 1 AND ply-cg = 1
        MOVE 4 TO ply-pend
    END-IF
    CALL "video_key" USING BY VALUE 53 RETURNING key-n
    IF key-n = 1 AND ply-rl = 1
        MOVE 5 TO ply-pend
    END-IF
    CALL "video_key" USING BY VALUE 54 RETURNING key-n
    IF key-n = 1 AND ply-pg = 1
        MOVE 6 TO ply-pend
    END-IF
    CALL "video_key" USING BY VALUE 55 RETURNING key-n
    IF key-n = 1 AND ply-bf = 1
        MOVE 7 TO ply-pend
    END-IF
    .

can-fire.
    MOVE 0 TO can-n
    IF ply-weap = 1 OR ply-weap = 8
        MOVE 1 TO can-n
    END-IF
    IF ply-weap = 2 OR ply-weap = 4
        IF ply-ammo >= 1
            MOVE 1 TO can-n
        END-IF
    END-IF
    IF ply-weap = 3
        IF ply-shell >= 1
            MOVE 1 TO can-n
        END-IF
    END-IF
    IF ply-weap = 5
        IF ply-misl >= 1
            MOVE 1 TO can-n
        END-IF
    END-IF
    IF ply-weap = 6
        IF ply-cell >= 1
            MOVE 1 TO can-n
        END-IF
    END-IF
    IF ply-weap = 7
        IF ply-cell >= 40
            MOVE 1 TO can-n
        END-IF
    END-IF
    .

lower-gun.
    ADD 393216 TO gun-lift
    IF gun-lift > 6291456
        MOVE 6291456 TO gun-lift
    END-IF
    MOVE 1 TO moved-out
    IF gun-lift < 6291456
        EXIT PARAGRAPH
    END-IF
    IF ply-pend NOT = 0
        MOVE ply-pend TO ply-weap
        MOVE 0 TO ply-pend
    END-IF
    MOVE 0 TO gun-refire
    MOVE 0 TO gun-step
    PERFORM set-body
    MOVE 3 TO gun-mode
    .

raise-gun.
    SUBTRACT 393216 FROM gun-lift
    IF gun-lift < 0
        MOVE 0 TO gun-lift
    END-IF
    MOVE 1 TO moved-out
    IF gun-lift > 0
        EXIT PARAGRAPH
    END-IF
    MOVE 0 TO gun-mode
    PERFORM set-body
    .

set-body.
    IF ply-weap = 1
        MOVE "PUNGA0" TO gun-body
    END-IF
    IF ply-weap = 2 OR ply-weap = 0
        MOVE "PISGA0" TO gun-body
    END-IF
    IF ply-weap = 3
        MOVE "SHTGA0" TO gun-body
    END-IF
    IF ply-weap = 4
        MOVE "CHGGA0" TO gun-body
    END-IF
    IF ply-weap = 5
        MOVE "MISGA0" TO gun-body
    END-IF
    IF ply-weap = 6
        MOVE "PLSGA0" TO gun-body
    END-IF
    IF ply-weap = 7
        MOVE "BFGGA0" TO gun-body
    END-IF
    IF ply-weap = 8
        MOVE "SAWGC0" TO gun-body
    END-IF
    MOVE SPACES TO gun-flash
    .

saw-idle.
    IF gun-mode NOT = 0 OR ply-weap NOT = 8 OR fire-held = 1
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO saw-tic
    IF saw-tic < 4
        EXIT PARAGRAPH
    END-IF
    MOVE 0 TO saw-tic
    IF gun-body = "SAWGC0"
        MOVE "SAWGD0" TO gun-body
    ELSE
        MOVE "SAWGC0" TO gun-body
    END-IF
    MOVE 1 TO moved-out
    .

enter-step.
    IF ply-weap = 1
        PERFORM step-fist
        EXIT PARAGRAPH
    END-IF
    IF ply-weap = 3
        PERFORM step-shot
        EXIT PARAGRAPH
    END-IF
    IF ply-weap = 4
        PERFORM step-chain
        EXIT PARAGRAPH
    END-IF
    IF ply-weap = 8
        PERFORM step-saw
        EXIT PARAGRAPH
    END-IF
    IF ply-weap = 5
        PERFORM step-rocket
        EXIT PARAGRAPH
    END-IF
    IF ply-weap = 6
        PERFORM step-plasma
        EXIT PARAGRAPH
    END-IF
    IF ply-weap = 7
        PERFORM step-bfg
        EXIT PARAGRAPH
    END-IF
    IF gun-step >= 4
        IF fire-held = 1 AND ply-ammo >= 1
            MOVE 0 TO gun-step
        ELSE
            PERFORM go-ready
            EXIT PARAGRAPH
        END-IF
    END-IF
    IF gun-step = 0
        MOVE "PISGA0" TO gun-body
        MOVE 4 TO gun-tics
    END-IF
    IF gun-step = 1
        MOVE "PISGB0" TO gun-body
        MOVE 6 TO gun-tics
        MOVE "PISFA0" TO gun-flash
        MOVE 7 TO gun-flash-n
        PERFORM do-shot
    END-IF
    IF gun-step = 2
        MOVE "PISGC0" TO gun-body
        MOVE 4 TO gun-tics
    END-IF
    IF gun-step = 3
        MOVE "PISGB0" TO gun-body
        MOVE 5 TO gun-tics
    END-IF
    MOVE 1 TO moved-out
    .

go-ready.
    MOVE 0 TO gun-mode
    PERFORM set-body
    MOVE 0 TO gun-tics
    IF fire-held = 0
        MOVE 0 TO gun-down
        MOVE 0 TO gun-refire
    END-IF
    MOVE 1 TO moved-out
    .

do-shot.
    IF ply-on = 0 OR ply-ammo < 1
        EXIT PARAGRAPH
    END-IF
    SUBTRACT 1 FROM ply-ammo
    MOVE "pistol" TO snd-name
    CALL "sfx-play" USING snd-name
    MOVE 1 TO ply-shot
    DIVIDE ply-h BY 2 GIVING half-h
    CALL "add_i32" USING BY VALUE half-h BY VALUE 524288 RETURNING tmp
    CALL "add_i32" USING BY VALUE ply-z BY VALUE tmp RETURNING shoot-z
    PERFORM bullet-slope
    MOVE ply-ang TO shot-ang
    IF gun-refire NOT = 0
        PERFORM take-rnd
        MOVE rnd-n TO rnd-a
        PERFORM take-rnd
        SUBTRACT rnd-n FROM rnd-a
        CALL "mul_i32" USING BY VALUE rnd-a BY VALUE 262144 RETURNING tmp
        CALL "add_i32" USING BY VALUE shot-ang BY VALUE tmp RETURNING shot-ang
    END-IF
    ADD 1 TO gun-refire
    PERFORM take-rnd
    DIVIDE rnd-n BY 3 GIVING q-n REMAINDER rem-n
    ADD 1 TO rem-n
    MULTIPLY rem-n BY 5 GIVING dmg
    PERFORM fire-ray
    .

bullet-slope.
    MOVE ply-ang TO try-ang
    PERFORM aim-at
    IF aim-mo NOT = 0
        EXIT PARAGRAPH
    END-IF
    CALL "add_i32" USING BY VALUE ply-ang BY VALUE 67108864
        RETURNING try-ang
    PERFORM aim-at
    IF aim-mo NOT = 0
        EXIT PARAGRAPH
    END-IF
    CALL "sub_i32" USING BY VALUE try-ang BY VALUE 134217728
        RETURNING try-ang
    PERFORM aim-at
    .

aim-at.
    CALL "fine_cos_ang" USING BY VALUE try-ang RETURNING cs
    CALL "fine_sin_ang" USING BY VALUE try-ang RETURNING sn
    MOVE 1024 TO range-u
    MOVE 67108864 TO range-fu
    PERFORM build-hits
    MOVE 1 TO trace-mode
    PERFORM walk-hits
    .

step-shot.
    IF gun-step >= 9
        IF fire-held = 1 AND ply-shell >= 1
            MOVE 0 TO gun-step
        ELSE
            PERFORM go-ready
            EXIT PARAGRAPH
        END-IF
    END-IF
    IF gun-step = 0
        MOVE "SHTGA0" TO gun-body
        MOVE 3 TO gun-tics
    END-IF
    IF gun-step = 1
        MOVE "SHTGA0" TO gun-body
        MOVE 7 TO gun-tics
        MOVE "SHTFA0" TO gun-flash
        MOVE 7 TO gun-flash-n
        PERFORM shot-gun
    END-IF
    IF gun-step = 2
        MOVE "SHTGB0" TO gun-body
        MOVE 5 TO gun-tics
    END-IF
    IF gun-step = 3
        MOVE "SHTGC0" TO gun-body
        MOVE 5 TO gun-tics
    END-IF
    IF gun-step = 4
        MOVE "SHTGD0" TO gun-body
        MOVE 4 TO gun-tics
    END-IF
    IF gun-step = 5
        MOVE "SHTGC0" TO gun-body
        MOVE 5 TO gun-tics
    END-IF
    IF gun-step = 6
        MOVE "SHTGB0" TO gun-body
        MOVE 5 TO gun-tics
    END-IF
    IF gun-step = 7
        MOVE "SHTGA0" TO gun-body
        MOVE 3 TO gun-tics
    END-IF
    IF gun-step = 8
        MOVE "SHTGA0" TO gun-body
        MOVE 7 TO gun-tics
    END-IF
    MOVE 1 TO moved-out
    .

step-chain.
    IF gun-step >= 2
        IF fire-held = 1 AND ply-ammo >= 1
            MOVE 0 TO gun-step
        ELSE
            PERFORM go-ready
            EXIT PARAGRAPH
        END-IF
    END-IF
    IF gun-step = 0
        MOVE "CHGGA0" TO gun-body
        MOVE 4 TO gun-tics
        MOVE "CHGFA0" TO gun-flash
        MOVE 5 TO gun-flash-n
        PERFORM do-shot
    END-IF
    IF gun-step = 1
        MOVE "CHGGB0" TO gun-body
        MOVE 4 TO gun-tics
        MOVE "CHGFB0" TO gun-flash
        MOVE 5 TO gun-flash-n
        PERFORM do-shot
    END-IF
    MOVE 1 TO moved-out
    .

step-fist.
    IF gun-step >= 5
        IF fire-held = 1
            MOVE 0 TO gun-step
        ELSE
            PERFORM go-ready
            EXIT PARAGRAPH
        END-IF
    END-IF
    IF gun-step = 0
        MOVE "PUNGB0" TO gun-body
        MOVE 4 TO gun-tics
    END-IF
    IF gun-step = 1
        MOVE "PUNGC0" TO gun-body
        MOVE 4 TO gun-tics
        PERFORM saw-cut
    END-IF
    IF gun-step = 2
        MOVE "PUNGD0" TO gun-body
        MOVE 5 TO gun-tics
    END-IF
    IF gun-step = 3
        MOVE "PUNGC0" TO gun-body
        MOVE 4 TO gun-tics
    END-IF
    IF gun-step = 4
        MOVE "PUNGB0" TO gun-body
        MOVE 5 TO gun-tics
    END-IF
    MOVE 1 TO moved-out
    .

step-saw.
    IF gun-step >= 2
        IF fire-held = 1
            MOVE 0 TO gun-step
        ELSE
            PERFORM go-ready
            EXIT PARAGRAPH
        END-IF
    END-IF
    IF gun-step = 0
        MOVE "SAWGA0" TO gun-body
        MOVE 4 TO gun-tics
        PERFORM saw-cut
    END-IF
    IF gun-step = 1
        MOVE "SAWGB0" TO gun-body
        MOVE 4 TO gun-tics
        PERFORM saw-cut
    END-IF
    MOVE 1 TO moved-out
    .

step-rocket.
    IF gun-step >= 2
        PERFORM go-ready
        EXIT PARAGRAPH
    END-IF
    IF gun-step = 0
        MOVE "MISGB0" TO gun-body
        MOVE 8 TO gun-tics
        MOVE "MISFA0" TO gun-flash
        MOVE 15 TO gun-flash-n
    END-IF
    IF gun-step = 1
        MOVE "MISGB0" TO gun-body
        MOVE 12 TO gun-tics
        PERFORM launch-rocket
    END-IF
    MOVE 1 TO moved-out
    .

step-plasma.
    IF gun-step >= 2
        IF fire-held = 1 AND ply-cell >= 1
            MOVE 0 TO gun-step
        ELSE
            PERFORM go-ready
            EXIT PARAGRAPH
        END-IF
    END-IF
    IF gun-step = 1 AND fire-held = 1 AND ply-cell >= 1
        MOVE 0 TO gun-step
    END-IF
    IF gun-step = 0
        MOVE "PLSGA0" TO gun-body
        MOVE 3 TO gun-tics
        PERFORM take-rnd
        CALL "bit_and" USING BY VALUE rnd-n BY VALUE 1 RETURNING bit-n
        IF bit-n = 0
            MOVE "PLSFA0" TO gun-flash
        ELSE
            MOVE "PLSFB0" TO gun-flash
        END-IF
        MOVE 4 TO gun-flash-n
        PERFORM launch-plasma
    END-IF
    IF gun-step = 1
        MOVE "PLSGB0" TO gun-body
        MOVE 20 TO gun-tics
    END-IF
    MOVE 1 TO moved-out
    .

step-bfg.
    IF gun-step >= 4
        PERFORM go-ready
        EXIT PARAGRAPH
    END-IF
    IF gun-step = 0
        MOVE "BFGGA0" TO gun-body
        MOVE 20 TO gun-tics
    END-IF
    IF gun-step = 1
        MOVE "BFGGB0" TO gun-body
        MOVE 10 TO gun-tics
        MOVE "BFGFA0" TO gun-flash
        MOVE 17 TO gun-flash-n
    END-IF
    IF gun-step = 2
        MOVE "BFGGB0" TO gun-body
        MOVE 10 TO gun-tics
        PERFORM launch-bfg
    END-IF
    IF gun-step = 3
        MOVE "BFGGB0" TO gun-body
        MOVE 20 TO gun-tics
    END-IF
    MOVE 1 TO moved-out
    .

launch-rocket.
    IF ply-misl < 1
        EXIT PARAGRAPH
    END-IF
    SUBTRACT 1 FROM ply-misl
    MOVE "rlaunc" TO snd-name
    CALL "sfx-play" USING snd-name
    MOVE 1 TO mo-hold
    MOVE "MISL" TO bolt-name
    MOVE 1310720 TO spd-n
    MOVE 20 TO base-d
    MOVE 720896 TO rad-n
    PERFORM spawn-bolt
    .

launch-plasma.
    IF ply-cell < 1
        EXIT PARAGRAPH
    END-IF
    SUBTRACT 1 FROM ply-cell
    MOVE "plasma" TO snd-name
    CALL "sfx-play" USING snd-name
    MOVE 2 TO mo-hold
    MOVE "PLSS" TO bolt-name
    MOVE 1638400 TO spd-n
    MOVE 5 TO base-d
    MOVE 851968 TO rad-n
    PERFORM spawn-bolt
    .

launch-bfg.
    IF ply-cell < 40
        EXIT PARAGRAPH
    END-IF
    SUBTRACT 40 FROM ply-cell
    MOVE "bfg" TO snd-name
    CALL "sfx-play" USING snd-name
    MOVE 3 TO mo-hold
    MOVE "BFS1" TO bolt-name
    MOVE 1638400 TO spd-n
    MOVE 100 TO base-d
    MOVE 851968 TO rad-n
    PERFORM spawn-bolt
    .

spawn-bolt.
    IF n-mobj >= 384 OR ply-on = 0
        EXIT PARAGRAPH
    END-IF
    DIVIDE ply-h BY 2 GIVING half-h
    CALL "add_i32" USING BY VALUE half-h BY VALUE 524288 RETURNING tmp
    CALL "add_i32" USING BY VALUE ply-z BY VALUE tmp RETURNING shoot-z
    MOVE 262144 TO aim-span
    PERFORM bullet-slope
    MOVE 40960 TO aim-span
    IF aim-mo = 0
        MOVE ply-ang TO try-ang
        MOVE 0 TO aim-sl
    END-IF
    CALL "fine_cos_ang" USING BY VALUE try-ang RETURNING cs
    CALL "fine_sin_ang" USING BY VALUE try-ang RETURNING sn
    CALL "fixed_mul" USING BY VALUE cs BY VALUE 2097152 RETURNING dx
    CALL "fixed_mul" USING BY VALUE sn BY VALUE 2097152 RETURNING dy
    ADD 1 TO n-mobj
    CALL "add_i32" USING BY VALUE ply-x BY VALUE dx RETURNING mo-x(n-mobj)
    CALL "add_i32" USING BY VALUE ply-y BY VALUE dy RETURNING mo-y(n-mobj)
    CALL "add_i32" USING BY VALUE ply-z BY VALUE 2097152
        RETURNING mo-z(n-mobj)
    MOVE bolt-name TO mo-name(n-mobj)
    MOVE 32768 TO mo-frame(n-mobj)
    MOVE 0 TO mo-flags(n-mobj)
    MOVE 5 TO mo-kind(n-mobj)
    MOVE 0 TO mo-ai(n-mobj)
    MOVE 0 TO mo-tic(n-mobj)
    MOVE 0 TO mo-wait(n-mobj)
    MOVE mo-hold TO mo-seq(n-mobj)
    MOVE try-ang TO mo-ang(n-mobj)
    MOVE -1 TO mo-step(n-mobj)
    MOVE 524288 TO mo-h(n-mobj)
    MOVE rad-n TO mo-rad(n-mobj)
    MOVE base-d TO mo-hp(n-mobj)
    CALL "fixed_mul" USING BY VALUE spd-n BY VALUE cs
        RETURNING mo-mx(n-mobj)
    CALL "fixed_mul" USING BY VALUE spd-n BY VALUE sn
        RETURNING mo-my(n-mobj)
    IF aim-sl > 65536
        MOVE 65536 TO aim-sl
    END-IF
    IF aim-sl < -65536
        MOVE -65536 TO aim-sl
    END-IF
    CALL "fixed_mul" USING BY VALUE spd-n BY VALUE aim-sl
        RETURNING mo-mz(n-mobj)
    MOVE 1 TO ply-shot
    MOVE 1 TO moved-out
    .

shot-gun.
    IF ply-on = 0 OR ply-shell < 1
        EXIT PARAGRAPH
    END-IF
    SUBTRACT 1 FROM ply-shell
    MOVE "shotgn" TO snd-name
    CALL "sfx-play" USING snd-name
    MOVE 1 TO ply-shot
    DIVIDE ply-h BY 2 GIVING half-h
    CALL "add_i32" USING BY VALUE half-h BY VALUE 524288 RETURNING tmp
    CALL "add_i32" USING BY VALUE ply-z BY VALUE tmp RETURNING shoot-z
    PERFORM bullet-slope
    PERFORM VARYING pellet-n FROM 1 BY 1 UNTIL pellet-n > 7
        MOVE ply-ang TO shot-ang
        PERFORM take-rnd
        MOVE rnd-n TO rnd-a
        PERFORM take-rnd
        SUBTRACT rnd-n FROM rnd-a
        CALL "mul_i32" USING BY VALUE rnd-a BY VALUE 262144 RETURNING tmp
        CALL "add_i32" USING BY VALUE shot-ang BY VALUE tmp
            RETURNING shot-ang
        PERFORM take-rnd
        DIVIDE rnd-n BY 3 GIVING q-n REMAINDER rem-n
        ADD 1 TO rem-n
        MULTIPLY rem-n BY 5 GIVING dmg
        PERFORM fire-ray
    END-PERFORM
    .

saw-cut.
    IF ply-on = 0
        EXIT PARAGRAPH
    END-IF
    IF ply-weap = 8
        MOVE "sawhit" TO snd-name
    ELSE
        MOVE "punch" TO snd-name
    END-IF
    CALL "sfx-play" USING snd-name
    MOVE 1 TO ply-shot
    DIVIDE ply-h BY 2 GIVING half-h
    CALL "add_i32" USING BY VALUE half-h BY VALUE 524288 RETURNING tmp
    CALL "add_i32" USING BY VALUE ply-z BY VALUE tmp RETURNING shoot-z
    MOVE ply-ang TO shot-ang
    PERFORM take-rnd
    MOVE rnd-n TO rnd-a
    PERFORM take-rnd
    SUBTRACT rnd-n FROM rnd-a
    CALL "mul_i32" USING BY VALUE rnd-a BY VALUE 262144 RETURNING tmp
    CALL "add_i32" USING BY VALUE shot-ang BY VALUE tmp RETURNING shot-ang
    PERFORM bullet-slope
    PERFORM take-rnd
    DIVIDE rnd-n BY 10 GIVING q-n REMAINDER rem-n
    ADD 1 TO rem-n
    MULTIPLY rem-n BY 2 GIVING dmg
    MOVE 1 TO melee-n
    PERFORM fire-ray
    .

fire-ray.
    CALL "fine_cos_ang" USING BY VALUE shot-ang RETURNING cs
    CALL "fine_sin_ang" USING BY VALUE shot-ang RETURNING sn
    IF melee-n = 1
        MOVE 64 TO range-u
        MOVE 4194304 TO range-fu
        MOVE 0 TO melee-n
    ELSE
        MOVE 2048 TO range-u
        MOVE 134217728 TO range-fu
    END-IF
    PERFORM build-hits
    MOVE 2 TO trace-mode
    PERFORM walk-hits
    .

build-hits.
    MOVE ply-x TO ox
    MOVE ply-y TO oy
    CALL "mul_i32" USING BY VALUE cs BY VALUE range-u RETURNING tdx
    CALL "mul_i32" USING BY VALUE sn BY VALUE range-u RETURNING tdy
    MOVE 0 TO n-hit
    PERFORM VARYING li FROM 1 BY 1 UNTIL li > n-line
        PERFORM add-line
    END-PERFORM
    PERFORM VARYING mo-i FROM 1 BY 1 UNTIL mo-i > n-mobj
        PERFORM add-thing
    END-PERFORM
    IF n-hit < 2
        EXIT PARAGRAPH
    END-IF
    PERFORM VARYING hi FROM 1 BY 1 UNTIL hi >= n-hit
        MOVE hi TO best
        ADD 1 TO hi GIVING hj
        PERFORM UNTIL hj > n-hit
            IF hit-fr(hj) < hit-fr(best)
                MOVE hj TO best
            END-IF
            ADD 1 TO hj
        END-PERFORM
        IF best NOT = hi
            MOVE hit-fr(hi) TO tmp
            MOVE hit-fr(best) TO hit-fr(hi)
            MOVE tmp TO hit-fr(best)
            MOVE hit-ln(hi) TO tmp
            MOVE hit-ln(best) TO hit-ln(hi)
            MOVE tmp TO hit-ln(best)
            MOVE hit-mo(hi) TO tmp
            MOVE hit-mo(best) TO hit-mo(hi)
            MOVE tmp TO hit-mo(best)
            MOVE hit-kind(hi) TO tmp
            MOVE hit-kind(best) TO hit-kind(hi)
            MOVE tmp TO hit-kind(best)
        END-IF
    END-PERFORM
    .

add-line.
    IF n-hit >= 128
        EXIT PARAGRAPH
    END-IF
    CALL "trace_frac" USING
        BY VALUE ox BY VALUE oy BY VALUE tdx BY VALUE tdy
        BY VALUE vtx-x(ln-v1(li)) BY VALUE vtx-y(ln-v1(li))
        BY VALUE vtx-x(ln-v2(li)) BY VALUE vtx-y(ln-v2(li))
        RETURNING frac
    IF frac < 0
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO n-hit
    MOVE 1 TO hit-kind(n-hit)
    MOVE li TO hit-ln(n-hit)
    MOVE frac TO hit-fr(n-hit)
    MOVE 0 TO hit-mo(n-hit)
    .

add-thing.
    IF n-hit >= 128
        EXIT PARAGRAPH
    END-IF
    CALL "bit_and" USING BY VALUE mo-flags(mo-i) BY VALUE 4
        RETURNING bit-n
    IF bit-n = 0
        EXIT PARAGRAPH
    END-IF
    CALL "sub_i32" USING BY VALUE mo-x(mo-i) BY VALUE ox RETURNING wx
    CALL "sub_i32" USING BY VALUE mo-y(mo-i) BY VALUE oy RETURNING wy
    CALL "fixed_mul" USING BY VALUE wx BY VALUE cs RETURNING along
    CALL "fixed_mul" USING BY VALUE wy BY VALUE sn RETURNING tmp
    CALL "add_i32" USING BY VALUE along BY VALUE tmp RETURNING along
    IF along <= 0
        EXIT PARAGRAPH
    END-IF
    CALL "ugt_u32" USING BY VALUE along BY VALUE range-fu RETURNING bit-n
    IF bit-n NOT = 0
        EXIT PARAGRAPH
    END-IF
    CALL "fixed_mul" USING BY VALUE wx BY VALUE sn RETURNING perp
    CALL "fixed_mul" USING BY VALUE wy BY VALUE cs RETURNING tmp
    CALL "sub_i32" USING BY VALUE perp BY VALUE tmp RETURNING perp
    CALL "abs_fixed_i" USING BY VALUE perp RETURNING perp
    CALL "add_i32" USING BY VALUE mo-rad(mo-i) BY VALUE 262144
        RETURNING reach
    IF perp > reach
        EXIT PARAGRAPH
    END-IF
    DIVIDE along BY range-u GIVING frac
    IF frac <= 0 OR frac > 65536
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO n-hit
    MOVE 2 TO hit-kind(n-hit)
    MOVE 0 TO hit-ln(n-hit)
    MOVE frac TO hit-fr(n-hit)
    MOVE mo-i TO hit-mo(n-hit)
    .

walk-hits.
    IF trace-mode = 1
        IF aim-span < 40960
            MOVE 40960 TO aim-span
        END-IF
        MOVE aim-span TO win-top
        COMPUTE win-bot = 0 - aim-span
        MOVE 0 TO aim-mo
        MOVE 0 TO aim-sl
    END-IF
    MOVE 0 TO stop-scan
    PERFORM VARYING hi FROM 1 BY 1 UNTIL hi > n-hit OR stop-scan = 1
        IF hit-kind(hi) = 1
            MOVE hit-ln(hi) TO li
            IF trace-mode = 1
                PERFORM line-aim
            ELSE
                PERFORM line-shot
            END-IF
        ELSE
            IF trace-mode = 1
                PERFORM thing-aim
            ELSE
                PERFORM thing-shot
            END-IF
        END-IF
    END-PERFORM
    .

measure-open.
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
    MOVE 1 TO fl-diff
    MOVE 1 TO cl-diff
    IF fs < 1 OR fs > 256
        EXIT PARAGRAPH
    END-IF
    MOVE sec-floor-h(fs) TO op-bot
    MOVE sec-ceil-h(fs) TO op-top
    IF bs >= 1 AND bs <= 256
        IF sec-floor-h(bs) = sec-floor-h(fs)
            MOVE 0 TO fl-diff
        END-IF
        IF sec-ceil-h(bs) = sec-ceil-h(fs)
            MOVE 0 TO cl-diff
        END-IF
        IF sec-floor-h(bs) > op-bot
            MOVE sec-floor-h(bs) TO op-bot
        END-IF
        IF sec-ceil-h(bs) < op-top
            MOVE sec-ceil-h(bs) TO op-top
        END-IF
    END-IF
    .

hit-dist.
    CALL "fixed_mul" USING BY VALUE range-fu BY VALUE hit-fr(hi)
        RETURNING dist-n
    .

line-aim.
    MOVE win-top TO hold-top
    MOVE win-bot TO hold-bot
    PERFORM measure-open
    IF two-side = 0
        MOVE 1 TO stop-scan
        EXIT PARAGRAPH
    END-IF
    IF op-bot >= op-top
        MOVE 1 TO stop-scan
        EXIT PARAGRAPH
    END-IF
    PERFORM hit-dist
    IF dist-n = 0
        MOVE 1 TO stop-scan
        EXIT PARAGRAPH
    END-IF
    IF fl-diff = 1
        CALL "sub_i32" USING BY VALUE op-bot BY VALUE shoot-z
            RETURNING tmp
        CALL "fixed_div" USING BY VALUE tmp BY VALUE dist-n
            RETURNING sl-v
        IF sl-v > win-bot
            MOVE sl-v TO win-bot
        END-IF
    END-IF
    IF cl-diff = 1
        CALL "sub_i32" USING BY VALUE op-top BY VALUE shoot-z
            RETURNING tmp
        CALL "fixed_div" USING BY VALUE tmp BY VALUE dist-n
            RETURNING sl-v
        IF sl-v < win-top
            MOVE sl-v TO win-top
        END-IF
    END-IF
    IF win-top <= win-bot
        IF aim-span > 40960
            MOVE hold-top TO win-top
            MOVE hold-bot TO win-bot
        ELSE
            MOVE 1 TO stop-scan
        END-IF
    END-IF
    .

line-shot.
    PERFORM measure-open
    PERFORM hit-dist
    MOVE 0 TO did-hit
    IF dist-n = 0
        MOVE 1 TO did-hit
    ELSE
        IF two-side = 0
            MOVE 1 TO did-hit
        ELSE
            IF bs = 0
                CALL "sub_i32" USING BY VALUE op-bot BY VALUE shoot-z
                    RETURNING tmp
                CALL "fixed_div" USING BY VALUE tmp BY VALUE dist-n
                    RETURNING sl-v
                IF sl-v > aim-sl
                    MOVE 1 TO did-hit
                ELSE
                    CALL "sub_i32" USING BY VALUE op-top BY VALUE shoot-z
                        RETURNING tmp
                    CALL "fixed_div" USING BY VALUE tmp BY VALUE dist-n
                        RETURNING sl-v
                    IF sl-v < aim-sl
                        MOVE 1 TO did-hit
                    END-IF
                END-IF
            ELSE
                IF fl-diff = 1
                    CALL "sub_i32" USING BY VALUE op-bot BY VALUE shoot-z
                        RETURNING tmp
                    CALL "fixed_div" USING BY VALUE tmp BY VALUE dist-n
                        RETURNING sl-v
                    IF sl-v > aim-sl
                        MOVE 1 TO did-hit
                    END-IF
                END-IF
                IF did-hit = 0 AND cl-diff = 1
                    CALL "sub_i32" USING BY VALUE op-top BY VALUE shoot-z
                        RETURNING tmp
                    CALL "fixed_div" USING BY VALUE tmp BY VALUE dist-n
                        RETURNING sl-v
                    IF sl-v < aim-sl
                        MOVE 1 TO did-hit
                    END-IF
                END-IF
            END-IF
        END-IF
    END-IF
    IF did-hit = 0
        EXIT PARAGRAPH
    END-IF
    MOVE 1 TO stop-scan
    MOVE 128 TO back-n
    PERFORM mark-spot
    IF fs >= 1 AND fs <= 256
        IF sec-ceil-pic(fs) = sky-flat AND zz > sec-ceil-h(fs)
            EXIT PARAGRAPH
        END-IF
        IF sec-ceil-pic(fs) = sky-flat
            AND bs >= 1 AND bs <= 256
            AND sec-ceil-pic(bs) = sky-flat
            EXIT PARAGRAPH
        END-IF
    END-IF
    PERFORM puff-spawn
    .

thing-aim.
    MOVE hit-mo(hi) TO who-i
    PERFORM hit-dist
    IF dist-n = 0
        EXIT PARAGRAPH
    END-IF
    CALL "add_i32" USING BY VALUE mo-z(who-i) BY VALUE mo-h(who-i)
        RETURNING tmp
    CALL "sub_i32" USING BY VALUE tmp BY VALUE shoot-z RETURNING tmp
    CALL "fixed_div" USING BY VALUE tmp BY VALUE dist-n
        RETURNING thing-top
    IF thing-top < win-bot
        EXIT PARAGRAPH
    END-IF
    CALL "sub_i32" USING BY VALUE mo-z(who-i) BY VALUE shoot-z
        RETURNING tmp
    CALL "fixed_div" USING BY VALUE tmp BY VALUE dist-n
        RETURNING thing-bot
    IF thing-bot > win-top
        EXIT PARAGRAPH
    END-IF
    IF thing-top > win-top
        MOVE win-top TO thing-top
    END-IF
    IF thing-bot < win-bot
        MOVE win-bot TO thing-bot
    END-IF
    CALL "add_i32" USING BY VALUE thing-top BY VALUE thing-bot
        RETURNING aim-sl
    CALL "shar32" USING BY VALUE aim-sl BY VALUE 1 RETURNING aim-sl
    MOVE who-i TO aim-mo
    MOVE 1 TO stop-scan
    .

thing-shot.
    MOVE hit-mo(hi) TO who-i
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 4
        RETURNING bit-n
    IF bit-n = 0
        EXIT PARAGRAPH
    END-IF
    PERFORM hit-dist
    IF dist-n = 0
        EXIT PARAGRAPH
    END-IF
    CALL "add_i32" USING BY VALUE mo-z(who-i) BY VALUE mo-h(who-i)
        RETURNING tmp
    CALL "sub_i32" USING BY VALUE tmp BY VALUE shoot-z RETURNING tmp
    CALL "fixed_div" USING BY VALUE tmp BY VALUE dist-n
        RETURNING thing-top
    IF thing-top < aim-sl
        EXIT PARAGRAPH
    END-IF
    CALL "sub_i32" USING BY VALUE mo-z(who-i) BY VALUE shoot-z
        RETURNING tmp
    CALL "fixed_div" USING BY VALUE tmp BY VALUE dist-n
        RETURNING thing-bot
    IF thing-bot > aim-sl
        EXIT PARAGRAPH
    END-IF
    MOVE 1 TO stop-scan
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 524288
        RETURNING bit-n
    IF bit-n NOT = 0
        MOVE 128 TO back-n
        PERFORM mark-spot
        PERFORM puff-spawn
    ELSE
        MOVE 320 TO back-n
        PERFORM mark-spot
        IF dmg > 12
            MOVE 2 TO blob-fr
        ELSE
            IF dmg >= 9
                MOVE 1 TO blob-fr
            ELSE
                MOVE 0 TO blob-fr
            END-IF
        END-IF
        MOVE "BLUD" TO blob-name
        MOVE 8 TO blob-tic
        MOVE 2 TO blob-kind
        PERFORM spawn-blob
    END-IF
    PERFORM hurt-thing
    .

mark-spot.
    MOVE hit-fr(hi) TO frac-v
    IF back-n > 0
        SUBTRACT back-n FROM frac-v
    END-IF
    IF frac-v < 0
        MOVE 0 TO frac-v
    END-IF
    CALL "fixed_mul" USING BY VALUE tdx BY VALUE frac-v RETURNING zx
    CALL "add_i32" USING BY VALUE ox BY VALUE zx RETURNING zx
    CALL "fixed_mul" USING BY VALUE tdy BY VALUE frac-v RETURNING zy
    CALL "add_i32" USING BY VALUE oy BY VALUE zy RETURNING zy
    CALL "fixed_mul" USING BY VALUE frac-v BY VALUE range-fu
        RETURNING dist-n
    CALL "fixed_mul" USING BY VALUE aim-sl BY VALUE dist-n RETURNING zz
    CALL "add_i32" USING BY VALUE shoot-z BY VALUE zz RETURNING zz
    PERFORM take-rnd
    MOVE rnd-n TO rnd-a
    PERFORM take-rnd
    SUBTRACT rnd-n FROM rnd-a
    CALL "mul_i32" USING BY VALUE rnd-a BY VALUE 1024 RETURNING tmp
    CALL "add_i32" USING BY VALUE zz BY VALUE tmp RETURNING zz
    .

puff-spawn.
    MOVE "PUFF" TO blob-name
    MOVE 32768 TO blob-fr
    MOVE 4 TO blob-tic
    MOVE 1 TO blob-kind
    PERFORM spawn-blob
    .

spawn-blob.
    IF n-mobj >= 384
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO n-mobj
    MOVE zx TO mo-x(n-mobj)
    MOVE zy TO mo-y(n-mobj)
    MOVE zz TO mo-z(n-mobj)
    MOVE blob-name TO mo-name(n-mobj)
    MOVE blob-fr TO mo-frame(n-mobj)
    MOVE 0 TO mo-flags(n-mobj)
    MOVE 0 TO mo-hp(n-mobj)
    MOVE 0 TO mo-max(n-mobj)
    MOVE 0 TO mo-seq(n-mobj)
    MOVE 0 TO mo-step(n-mobj)
    MOVE 0 TO mo-ang(n-mobj)
    MOVE 0 TO mo-rad(n-mobj)
    MOVE 1048576 TO mo-h(n-mobj)
    MOVE blob-tic TO mo-tic(n-mobj)
    MOVE blob-kind TO mo-kind(n-mobj)
    MOVE 1 TO moved-out
    .

hurt-thing.
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 4
        RETURNING bit-n
    IF bit-n = 0
        EXIT PARAGRAPH
    END-IF
    SUBTRACT dmg FROM mo-hp(who-i)
    IF mo-hp(who-i) > 0
        PERFORM flinch
        EXIT PARAGRAPH
    END-IF
    PERFORM start-death
    .

flinch.
    IF mo-name(who-i) NOT = "POSS" AND mo-name(who-i) NOT = "SPOS"
        AND mo-name(who-i) NOT = "CPOS" AND mo-name(who-i) NOT = "TROO"
        AND mo-name(who-i) NOT = "SARG"
        AND mo-name(who-i) NOT = "BOSS"
        AND mo-name(who-i) NOT = "BOS2"
        EXIT PARAGRAPH
    END-IF
    PERFORM take-rnd
    IF rnd-n >= 200
        EXIT PARAGRAPH
    END-IF
    IF mo-name(who-i) = "SARG" OR mo-name(who-i) = "BOSS"
        OR mo-name(who-i) = "BOS2"
        MOVE "dmpain" TO snd-name
    ELSE
        MOVE "popain" TO snd-name
    END-IF
    CALL "sfx-play" USING snd-name
    IF mo-name(who-i) = "BOSS" OR mo-name(who-i) = "BOS2"
        EXIT PARAGRAPH
    END-IF
    MOVE 5 TO mo-ai(who-i)
    MOVE 6 TO mo-wait(who-i)
    IF mo-name(who-i) = "TROO"
        MOVE 7 TO mo-frame(who-i)
    ELSE
        MOVE 6 TO mo-frame(who-i)
    END-IF
    .

foe-die.
    MOVE SPACES TO snd-name
    IF mo-name(who-i) = "BAR1"
        MOVE "barexp" TO snd-name
    END-IF
    IF mo-name(who-i) = "SPOS" OR mo-name(who-i) = "CPOS"
        MOVE "podth2" TO snd-name
    END-IF
    IF mo-seq(who-i) = 1 AND mo-name(who-i) = "POSS"
        PERFORM take-rnd
        DIVIDE rnd-n BY 3 GIVING q-n REMAINDER rem-n
        IF rem-n = 0
            MOVE "podth1" TO snd-name
        END-IF
        IF rem-n = 1
            MOVE "podth2" TO snd-name
        END-IF
        IF rem-n = 2
            MOVE "podth3" TO snd-name
        END-IF
    END-IF
    IF mo-seq(who-i) = 2
        PERFORM take-rnd
        CALL "bit_and" USING BY VALUE rnd-n BY VALUE 1 RETURNING bit-n
        IF bit-n = 0
            MOVE "bgdth1" TO snd-name
        ELSE
            MOVE "bgdth2" TO snd-name
        END-IF
    END-IF
    IF mo-seq(who-i) = 3
        MOVE "sgtdth" TO snd-name
    END-IF
    IF mo-name(who-i) = "BOSS"
        MOVE "brsdth" TO snd-name
    END-IF
    IF mo-name(who-i) = "BOS2"
        MOVE "kntdth" TO snd-name
    END-IF
    IF snd-name NOT = SPACES
        CALL "sfx-play" USING snd-name
    END-IF
    .

start-death.
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE -7
        RETURNING tmp
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 4194304
        RETURNING bit-n
    IF bit-n NOT = 0
        ADD 1 TO ply-kills
    END-IF
    MOVE tmp TO mo-flags(who-i)
    DIVIDE mo-h(who-i) BY 4 GIVING mo-h(who-i)
    MOVE 0 TO mo-seq(who-i)
    IF mo-name(who-i) = "POSS" OR mo-name(who-i) = "SPOS"
        MOVE 1 TO mo-seq(who-i)
    END-IF
    IF mo-name(who-i) = "TROO"
        MOVE 2 TO mo-seq(who-i)
    END-IF
    IF mo-name(who-i) = "SARG"
        MOVE 3 TO mo-seq(who-i)
    END-IF
    IF mo-name(who-i) = "CPOS"
        MOVE 4 TO mo-seq(who-i)
    END-IF
    IF mo-name(who-i) = "HEAD"
        MOVE 5 TO mo-seq(who-i)
    END-IF
    PERFORM foe-die
    MOVE 3 TO mo-kind(who-i)
    IF mo-seq(who-i) = 0
        MOVE -1 TO mo-tic(who-i)
        MOVE 1 TO moved-out
        EXIT PARAGRAPH
    END-IF
    MOVE 1 TO mo-step(who-i)
    COMPUTE slot = (mo-seq(who-i) - 1) * 8 + 1
    MOVE die-fr(slot) TO mo-frame(who-i)
    MOVE die-tic(slot) TO mo-tic(who-i)
    MOVE 1 TO moved-out
    .

fly-bolts.
    PERFORM VARYING mo-i FROM 1 BY 1 UNTIL mo-i > n-mobj
        IF mo-kind(mo-i) = 5 AND mo-name(mo-i) NOT = SPACES
            MOVE mo-i TO bolt-i
            PERFORM fly-one
        END-IF
    END-PERFORM
    .

fly-one.
    IF mo-ai(bolt-i) = 9
        PERFORM boom-bolt
        EXIT PARAGRAPH
    END-IF
    IF mo-step(bolt-i) < 0
        MOVE 0 TO mo-step(bolt-i)
        EXIT PARAGRAPH
    END-IF
    CALL "add_i32" USING BY VALUE mo-x(bolt-i) BY VALUE mo-mx(bolt-i)
        RETURNING nx
    CALL "add_i32" USING BY VALUE mo-y(bolt-i) BY VALUE mo-my(bolt-i)
        RETURNING ny
    CALL "add_i32" USING BY VALUE mo-z(bolt-i) BY VALUE mo-mz(bolt-i)
        RETURNING nz
    MOVE 0 TO boom-n
    MOVE 0 TO victim-i
    MOVE mo-x(bolt-i) TO ox
    MOVE mo-y(bolt-i) TO oy
    CALL "sub_i32" USING BY VALUE nx BY VALUE ox RETURNING tdx
    CALL "sub_i32" USING BY VALUE ny BY VALUE oy RETURNING tdy
    PERFORM VARYING li FROM 1 BY 1 UNTIL li > n-line OR boom-n = 1
        PERFORM bolt-cross
        IF did-cross = 1
            PERFORM bolt-gap
            IF two-side = 0 OR op-bot >= op-top
                MOVE 1 TO boom-n
            ELSE
                CALL "add_i32" USING BY VALUE nz BY VALUE mo-h(bolt-i)
                    RETURNING tmp
                IF tmp >= op-top
                    MOVE 1 TO boom-n
                ELSE
                    IF nz <= op-bot
                        IF mo-kind(bolt-i) NOT = 5
                            OR mo-mz(bolt-i) <= 0
                            MOVE 1 TO boom-n
                        END-IF
                    END-IF
                END-IF
            END-IF
        END-IF
    END-PERFORM
    IF boom-n = 0
        PERFORM bolt-body
    END-IF
    IF boom-n = 0
        MOVE nx TO walk-x
        MOVE ny TO walk-y
        PERFORM locate-bolt
        IF sec-at >= 1 AND sec-at <= n-sector
            CALL "add_i32" USING BY VALUE nz BY VALUE mo-h(bolt-i)
                RETURNING tmp
            IF tmp >= sec-ceil-h(sec-at)
                MOVE 1 TO boom-n
            ELSE
                IF nz <= sec-floor-h(sec-at)
                    IF mo-kind(bolt-i) NOT = 5
                        OR mo-mz(bolt-i) <= 0
                        MOVE 1 TO boom-n
                    END-IF
                END-IF
            END-IF
        END-IF
    END-IF
    IF boom-n = 1
        PERFORM start-boom
    ELSE
        MOVE nx TO mo-x(bolt-i)
        MOVE ny TO mo-y(bolt-i)
        MOVE nz TO mo-z(bolt-i)
        IF mo-seq(bolt-i) = 2
            ADD 1 TO mo-step(bolt-i)
            IF mo-step(bolt-i) >= 2
                MOVE 0 TO mo-step(bolt-i)
                IF mo-frame(bolt-i) = 32768
                    MOVE 32769 TO mo-frame(bolt-i)
                ELSE
                    MOVE 32768 TO mo-frame(bolt-i)
                END-IF
            END-IF
        END-IF
    END-IF
    MOVE 1 TO moved-out
    .

bolt-body.
    PERFORM VARYING victim-i FROM 1 BY 1
        UNTIL victim-i > n-mobj OR boom-n = 1
        IF victim-i NOT = bolt-i
            CALL "bit_and" USING BY VALUE mo-flags(victim-i) BY VALUE 4
                RETURNING bit-n
            IF bit-n NOT = 0 AND mo-hp(victim-i) > 0
                CALL "add_i32" USING BY VALUE mo-rad(victim-i)
                    BY VALUE mo-rad(bolt-i) RETURNING reach
                CALL "sub_i32" USING BY VALUE mo-x(victim-i) BY VALUE nx
                    RETURNING dx
                CALL "abs_fixed_i" USING BY VALUE dx RETURNING dx
                CALL "sub_i32" USING BY VALUE mo-y(victim-i) BY VALUE ny
                    RETURNING dy
                CALL "abs_fixed_i" USING BY VALUE dy RETURNING dy
                IF dx < reach AND dy < reach
                    CALL "add_i32" USING BY VALUE mo-z(victim-i)
                        BY VALUE mo-h(victim-i) RETURNING tmp
                    CALL "add_i32" USING BY VALUE nz BY VALUE mo-h(bolt-i)
                        RETURNING dist-n
                    IF nz < tmp AND dist-n > mo-z(victim-i)
                        PERFORM take-rnd
                        DIVIDE rnd-n BY 8 GIVING q-n REMAINDER rem-n
                        ADD 1 TO rem-n
                        MULTIPLY rem-n BY mo-hp(bolt-i) GIVING dmg
                        MOVE victim-i TO who-i
                        PERFORM hurt-thing
                        MOVE 1 TO boom-n
                    END-IF
                END-IF
            END-IF
        END-IF
    END-PERFORM
    .

start-boom.
    MOVE nx TO spot-x
    MOVE ny TO spot-y
    MOVE nz TO spot-z
    MOVE nx TO mo-x(bolt-i)
    MOVE ny TO mo-y(bolt-i)
    MOVE nz TO mo-z(bolt-i)
    MOVE 9 TO mo-ai(bolt-i)
    MOVE 0 TO mo-mx(bolt-i)
    MOVE 0 TO mo-my(bolt-i)
    MOVE 0 TO mo-mz(bolt-i)
    MOVE 0 TO mo-step(bolt-i)
    MOVE 4 TO mo-wait(bolt-i)
    MOVE 0 TO mo-frame(bolt-i)
    IF mo-seq(bolt-i) = 1
        MOVE "MISL" TO mo-name(bolt-i)
        MOVE 32769 TO mo-frame(bolt-i)
        MOVE 8 TO mo-wait(bolt-i)
        MOVE "barexp" TO snd-name
        CALL "sfx-play" USING snd-name
        PERFORM rocket-splash
    END-IF
    IF mo-kind(bolt-i) = 4
        MOVE "firxpl" TO snd-name
        CALL "sfx-play" USING snd-name
    END-IF
    IF mo-seq(bolt-i) = 2
        MOVE "PLSE" TO mo-name(bolt-i)
    END-IF
    IF mo-seq(bolt-i) = 3
        MOVE "BFE1" TO mo-name(bolt-i)
        PERFORM bfg-spray
    END-IF
    MOVE 1 TO moved-out
    .

rocket-splash.
    PERFORM VARYING victim-i FROM 1 BY 1 UNTIL victim-i > n-mobj
        IF victim-i NOT = bolt-i
            AND mo-name(victim-i) NOT = "SPID"
            AND mo-name(victim-i) NOT = "CYBR"
            CALL "bit_and" USING BY VALUE mo-flags(victim-i) BY VALUE 4
                RETURNING bit-n
            IF bit-n NOT = 0
                PERFORM splash-one
            END-IF
        END-IF
    END-PERFORM
    CALL "sub_i32" USING BY VALUE ply-x BY VALUE spot-x RETURNING dx
    CALL "abs_fixed_i" USING BY VALUE dx RETURNING dx
    CALL "sub_i32" USING BY VALUE ply-y BY VALUE spot-y RETURNING dy
    CALL "abs_fixed_i" USING BY VALUE dy RETURNING dy
    IF dx < dy
        MOVE dy TO dx
    END-IF
    CALL "sub_i32" USING BY VALUE dx BY VALUE ply-rad RETURNING dx
    IF dx < 0
        MOVE 0 TO dx
    END-IF
    CALL "shar32" USING BY VALUE dx BY VALUE 16 RETURNING units-n
    IF units-n < 128 AND ply-hp > 0 AND ply-god = 0
        SUBTRACT units-n FROM 128 GIVING dmg
        SUBTRACT dmg FROM ply-hp
        IF ply-hp < 0
            MOVE 0 TO ply-hp
        END-IF
        ADD dmg TO ply-pain
        IF ply-pain > 100
            MOVE 100 TO ply-pain
        END-IF
        MOVE 1 TO atk-on
        MOVE spot-x TO atk-x
        MOVE spot-y TO atk-y
        CALL "face-hit" USING dmg atk-on atk-x atk-y
        CALL "push-ply" USING dmg atk-x atk-y
        CALL "ply-ouch"
    END-IF
    .

splash-one.
    CALL "sub_i32" USING BY VALUE mo-x(victim-i) BY VALUE spot-x
        RETURNING dx
    CALL "abs_fixed_i" USING BY VALUE dx RETURNING dx
    CALL "sub_i32" USING BY VALUE mo-y(victim-i) BY VALUE spot-y
        RETURNING dy
    CALL "abs_fixed_i" USING BY VALUE dy RETURNING dy
    IF dx < dy
        MOVE dy TO dx
    END-IF
    CALL "sub_i32" USING BY VALUE dx BY VALUE mo-rad(victim-i)
        RETURNING dx
    IF dx < 0
        MOVE 0 TO dx
    END-IF
    CALL "shar32" USING BY VALUE dx BY VALUE 16 RETURNING units-n
    IF units-n < 128
        SUBTRACT units-n FROM 128 GIVING dmg
        MOVE victim-i TO who-i
        PERFORM hurt-thing
    END-IF
    .

bfg-spray.
    PERFORM VARYING victim-i FROM 1 BY 1 UNTIL victim-i > n-mobj
        CALL "bit_and" USING BY VALUE mo-flags(victim-i) BY VALUE 4
            RETURNING bit-n
        IF bit-n NOT = 0 AND mo-hp(victim-i) > 0
            CALL "sub_i32" USING BY VALUE mo-x(victim-i) BY VALUE ply-x
                RETURNING dx
            CALL "abs_fixed_i" USING BY VALUE dx RETURNING dx
            CALL "sub_i32" USING BY VALUE mo-y(victim-i) BY VALUE ply-y
                RETURNING dy
            CALL "abs_fixed_i" USING BY VALUE dy RETURNING dy
            IF dx < dy
                MOVE dy TO dist-n
            ELSE
                MOVE dx TO dist-n
            END-IF
            CALL "ugt_u32" USING BY VALUE dist-n BY VALUE 67108864
                RETURNING bit-n
            IF bit-n = 0
                CALL "point_to_angle" USING
                    BY VALUE ply-x BY VALUE ply-y
                    BY VALUE mo-x(victim-i) BY VALUE mo-y(victim-i)
                    RETURNING ang-n
                CALL "sub_i32" USING BY VALUE ang-n BY VALUE ply-ang
                    RETURNING delta-n
                CALL "abs_fixed_i" USING BY VALUE delta-n RETURNING delta-n
                IF delta-n < 536870912
                    MOVE 0 TO dmg
                    PERFORM 15 TIMES
                        PERFORM take-rnd
                        CALL "bit_and" USING BY VALUE rnd-n BY VALUE 7
                            RETURNING rem-n
                        ADD 1 TO rem-n
                        ADD rem-n TO dmg
                    END-PERFORM
                    MOVE victim-i TO who-i
                    PERFORM hurt-thing
                END-IF
            END-IF
        END-IF
    END-PERFORM
    .

boom-bolt.
    IF mo-wait(bolt-i) > 0
        SUBTRACT 1 FROM mo-wait(bolt-i)
        MOVE 1 TO moved-out
        IF mo-wait(bolt-i) > 0
            EXIT PARAGRAPH
        END-IF
    END-IF
    ADD 1 TO mo-step(bolt-i)
    IF mo-seq(bolt-i) = 3
        IF mo-step(bolt-i) = 1
            MOVE "BFE2" TO mo-name(bolt-i)
            MOVE 0 TO mo-frame(bolt-i)
            MOVE 6 TO mo-wait(bolt-i)
        ELSE
            MOVE SPACES TO mo-name(bolt-i)
            MOVE 0 TO mo-kind(bolt-i)
            MOVE 0 TO mo-ai(bolt-i)
        END-IF
    ELSE
        IF mo-seq(bolt-i) = 1
            IF mo-step(bolt-i) >= 3
                MOVE SPACES TO mo-name(bolt-i)
                MOVE 0 TO mo-kind(bolt-i)
                MOVE 0 TO mo-ai(bolt-i)
            ELSE
                COMPUTE mo-frame(bolt-i) = 32769 + mo-step(bolt-i)
                IF mo-step(bolt-i) = 1
                    MOVE 6 TO mo-wait(bolt-i)
                ELSE
                    MOVE 4 TO mo-wait(bolt-i)
                END-IF
            END-IF
        ELSE
            IF mo-step(bolt-i) >= 4
                MOVE SPACES TO mo-name(bolt-i)
                MOVE 0 TO mo-kind(bolt-i)
                MOVE 0 TO mo-ai(bolt-i)
            ELSE
                MOVE mo-step(bolt-i) TO mo-frame(bolt-i)
                MOVE 4 TO mo-wait(bolt-i)
            END-IF
        END-IF
    END-IF
    MOVE 1 TO moved-out
    .

bolt-cross.
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

bolt-gap.
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

locate-bolt.
    MOVE 1 TO sub-at
    MOVE 1 TO sec-at
    IF n-node < 1
        IF n-ssector >= 1 AND ss-sec(1) >= 0
            COMPUTE sec-at = ss-sec(1) + 1
        END-IF
        EXIT PARAGRAPH
    END-IF
    COMPUTE bsp-n = n-node - 1
    PERFORM VARYING hop-n FROM 1 BY 1 UNTIL hop-n > 256
        IF bsp-n < 0
            EXIT PERFORM
        END-IF
        CALL "bit_and" USING BY VALUE bsp-n BY VALUE 32768
            RETURNING bit-n
        IF bit-n NOT = 0
            CALL "bit_and" USING BY VALUE bsp-n BY VALUE 32767
                RETURNING sub-n
            COMPUTE sub-at = sub-n + 1
            EXIT PERFORM
        END-IF
        COMPUTE node-at = bsp-n + 1
        IF node-at < 1 OR node-at > n-node
            EXIT PERFORM
        END-IF
        CALL "point_side" USING
            BY VALUE nd-x(node-at) BY VALUE nd-y(node-at)
            BY VALUE nd-dx(node-at) BY VALUE nd-dy(node-at)
            BY VALUE walk-x BY VALUE walk-y
            RETURNING side-bit
        IF side-bit = 0
            MOVE nd-c0(node-at) TO bsp-n
        ELSE
            MOVE nd-c1(node-at) TO bsp-n
        END-IF
    END-PERFORM
    IF sub-at >= 1 AND sub-at <= n-ssector AND ss-sec(sub-at) >= 0
        COMPUTE sec-at = ss-sec(sub-at) + 1
    END-IF
    .

tick-fx.
    PERFORM VARYING mo-i FROM 1 BY 1 UNTIL mo-i > n-mobj
        IF mo-tic(mo-i) > 0
            SUBTRACT 1 FROM mo-tic(mo-i)
            IF mo-tic(mo-i) = 0
                MOVE mo-i TO who-i
                IF mo-kind(who-i) = 1
                    PERFORM puff-next
                END-IF
                IF mo-kind(who-i) = 2
                    PERFORM blood-next
                END-IF
                IF mo-kind(who-i) = 3
                    PERFORM corpse-next
                END-IF
            END-IF
        END-IF
    END-PERFORM
    .

puff-next.
    ADD 1 TO mo-step(who-i)
    IF mo-step(who-i) = 1
        MOVE 1 TO mo-frame(who-i)
        MOVE 4 TO mo-tic(who-i)
    END-IF
    IF mo-step(who-i) = 2
        MOVE 2 TO mo-frame(who-i)
        MOVE 4 TO mo-tic(who-i)
    END-IF
    IF mo-step(who-i) = 3
        MOVE 3 TO mo-frame(who-i)
        MOVE 4 TO mo-tic(who-i)
    END-IF
    IF mo-step(who-i) >= 4
        MOVE SPACES TO mo-name(who-i)
        MOVE 0 TO mo-tic(who-i)
        MOVE 0 TO mo-kind(who-i)
    END-IF
    MOVE 1 TO moved-out
    .

blood-next.
    IF mo-frame(who-i) = 0
        MOVE SPACES TO mo-name(who-i)
        MOVE 0 TO mo-tic(who-i)
        MOVE 0 TO mo-kind(who-i)
    ELSE
        SUBTRACT 1 FROM mo-frame(who-i)
        MOVE 8 TO mo-tic(who-i)
    END-IF
    MOVE 1 TO moved-out
    .

corpse-next.
    ADD 1 TO mo-step(who-i)
    COMPUTE slot = (mo-seq(who-i) - 1) * 8 + mo-step(who-i)
    IF mo-seq(who-i) < 1 OR mo-step(who-i) > die-len(mo-seq(who-i))
        OR slot < 1 OR slot > 40
        MOVE -1 TO mo-tic(who-i)
    ELSE
        MOVE die-fr(slot) TO mo-frame(who-i)
        MOVE die-tic(slot) TO mo-tic(who-i)
    END-IF
    MOVE 1 TO moved-out
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

END PROGRAM gun-tic.
