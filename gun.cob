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
*> Armas na ordem do Doom: 1 soco, 2 pistola, 3 espingarda,
*> 4 metralhadora, 5 missil, 6 plasma, 7 BFG. Sem rato.
IDENTIFICATION DIVISION.
PROGRAM-ID. gun-tic.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 die-on BINARY-LONG VALUE 0.
01 late-kill BINARY-LONG VALUE 0.
01 snd-name PIC X(6).
01 die-len BINARY-LONG OCCURS 5 TIMES.
01 die-fr BINARY-LONG OCCURS 40 TIMES.
01 die-tic BINARY-LONG OCCURS 40 TIMES.
01 gun-step BINARY-LONG VALUE 0.
01 gun-tics BINARY-LONG VALUE 0.
01 gun-flash-n BINARY-LONG VALUE 0.
01 gun-down BINARY-LONG VALUE 0.
01 gun-refire BINARY-LONG VALUE 0.
01 refire-go BINARY-LONG VALUE 0.
01 rnd-n BINARY-LONG.
01 rnd-a BINARY-LONG.
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
01 born-i BINARY-LONG.
01 burst-k BINARY-LONG.
01 burst-ang BINARY-LONG.
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
01 orig-x BINARY-LONG.
01 orig-y BINARY-LONG.
01 shot-src BINARY-LONG VALUE 0.
01 quiet-n BINARY-LONG VALUE 0.
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
01 drop-name PIC X(4).
01 bexp-i BINARY-LONG.
01 spot-z BINARY-LONG.
01 splash-see BINARY-LONG.
01 spl-x0 BINARY-LONG.
01 spl-x1 BINARY-LONG.
01 spl-y0 BINARY-LONG.
01 spl-y1 BINARY-LONG.
01 spl-bx BINARY-LONG.
01 spl-by BINARY-LONG.
01 spl-tx BINARY-LONG.
01 spl-ty BINARY-LONG.
01 spot-sec BINARY-LONG.
01 vict-sec BINARY-LONG.
01 pnum BINARY-LONG.
01 byte-i BINARY-LONG.
01 mask-n BINARY-LONG.
*> DamageMobj thrust origin (inflictor/source XY/Z).
01 thrust-ox BINARY-LONG VALUE 0.
01 thrust-oy BINARY-LONG VALUE 0.
01 thrust-oz BINARY-LONG VALUE 0.
01 thrust-n BINARY-LONG.
01 mass-n BINARY-LONG.
01 aim-ang BINARY-LONG.
01 nx BINARY-LONG.
01 ny BINARY-LONG.
01 nz BINARY-LONG.
01 box-l BINARY-LONG.
01 box-r BINARY-LONG.
01 box-b BINARY-LONG.
01 box-t BINARY-LONG.
01 corner-n BINARY-LONG.
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
    *> A_Scream (podth/bgdth P_Random) at this corpse's slot.
    IF scream-slot > 0
        MOVE scream-slot TO who-i
        MOVE 0 TO scream-slot
        PERFORM a-scream
        GOBACK
    END-IF
    *> Called from the enemy loop so the fuse runs in mobj-list order.
    IF bexp-slot > 0
        MOVE bexp-slot TO who-i
        MOVE 0 TO bexp-slot
        IF mo-name(who-i) = "BEXP" AND mo-tic(who-i) > 0
            SUBTRACT 1 FROM mo-tic(who-i)
            IF mo-tic(who-i) = 0
                PERFORM bexp-next
            END-IF
        END-IF
        GOBACK
    END-IF
    *> PIT_CheckThing missile damage, before P_ExplodeMissile's tics roll.
    IF hit-slot > 0
        MOVE hit-from TO slot
        MOVE hit-slot TO who-i
        MOVE 0 TO hit-slot
        MOVE 0 TO hit-from
        IF hit-dmg > 0
            *> Victim already had its thinker when it is earlier in the list.
            MOVE 0 TO late-kill
            IF hit-who > who-i
                MOVE 1 TO late-kill
            END-IF
            IF hit-who > 0 AND hit-who <= n-mobj
                MOVE mo-x(hit-who) TO thrust-ox
                MOVE mo-y(hit-who) TO thrust-oy
                MOVE mo-z(hit-who) TO thrust-oz
            END-IF
            MOVE hit-dmg TO dmg
            MOVE 0 TO hit-dmg
        ELSE
            MOVE 1 TO late-kill
            IF slot > 0 AND slot <= n-mobj
                MOVE mo-x(slot) TO thrust-ox
                MOVE mo-y(slot) TO thrust-oy
                MOVE mo-z(slot) TO thrust-oz
                MOVE mo-count(slot) TO hit-who
            END-IF
            PERFORM take-rnd
            DIVIDE rnd-n BY 8 GIVING q-n REMAINDER rem-n
            ADD 1 TO rem-n
            MULTIPLY rem-n BY mo-hp(slot) GIVING dmg
        END-IF
        PERFORM hurt-thing
        MOVE 0 TO late-kill
        MOVE 0 TO hit-who
        GOBACK
    END-IF
    *> Monster P_LineAttack. Mode 1 stores the aim slope; mode 2 reports the hit.
    IF ray-slot > 0
        PERFORM mon-ray
        GOBACK
    END-IF
    IF die-on = 0
        PERFORM fill-die
        MOVE 1 TO die-on
    END-IF
    MOVE 0 TO moved-out
    IF fire-held = -1
        PERFORM fly-bolts
        GOBACK
    END-IF
    PERFORM tick-fx
    PERFORM tick-flash
    PERFORM tick-gun
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
    *> DeathThink: A_Lower until WEAPONBOTTOM, never BringUp.
    IF ply-hp <= 0
        MOVE 2 TO gun-mode
        PERFORM lower-gun
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
        *> Harbour A_WeaponReady: pending before refire (Python tick_psprites).
        IF gun-mode = 0 AND ply-pend NOT = 0
            AND ply-pend NOT = ply-weap
            MOVE 2 TO gun-mode
            PERFORM lower-gun
            EXIT PARAGRAPH
        END-IF
        IF gun-mode = 0 AND fire-held = 1 AND ply-on = 1
            AND ply-weap NOT = 7
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
        PERFORM capture-bob
        MOVE 2 TO gun-mode
        PERFORM lower-gun
        EXIT PARAGRAPH
    END-IF
    PERFORM can-fire
    IF fire-held = 1 AND can-n = 1 AND ply-on = 1
        MOVE 1 TO go-n
        IF gun-down = 1 AND ply-weap = 7
            MOVE 0 TO go-n
        END-IF
        IF go-n = 1
            PERFORM capture-bob
            MOVE 1 TO gun-mode
            MOVE 0 TO gun-step
            MOVE 1 TO gun-down
            PERFORM enter-step
            EXIT PARAGRAPH
        END-IF
    END-IF
    IF fire-held = 1 AND can-n = 0 AND ply-on = 1
        PERFORM capture-bob
        PERFORM pick-fallback
        IF ply-pend NOT = ply-weap
            MOVE 2 TO gun-mode
            PERFORM lower-gun
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
    *> Demo ticcmd BT_CHANGE. Live play leaves cmd-btns at 0.
    CALL "bit_and" USING BY VALUE cmd-btns BY VALUE 128
        RETURNING bit-n
    IF bit-n NOT = 0
        EXIT PARAGRAPH
    END-IF
    CALL "bit_and" USING BY VALUE cmd-btns BY VALUE 4
        RETURNING bit-n
    IF bit-n = 0
        EXIT PARAGRAPH
    END-IF
    CALL "bit_and" USING BY VALUE cmd-btns BY VALUE 56
        RETURNING bit-n
    DIVIDE bit-n BY 8 GIVING key-n
    ADD 1 TO key-n
    *> Fist key brings up the chainsaw unless berserk is holding the fist.
    IF key-n = 1 AND ply-saw = 1
        IF ply-weap NOT = 8 OR ply-str = 0
            MOVE 8 TO key-n
        END-IF
    END-IF
    IF key-n < 1 OR key-n > 8 OR key-n = ply-weap
        EXIT PARAGRAPH
    END-IF
    IF key-n = 3 AND ply-sg = 0
        EXIT PARAGRAPH
    END-IF
    IF key-n = 4 AND ply-cg = 0
        EXIT PARAGRAPH
    END-IF
    IF key-n = 5 AND ply-rl = 0
        EXIT PARAGRAPH
    END-IF
    IF key-n = 6 AND ply-pg = 0
        EXIT PARAGRAPH
    END-IF
    IF key-n = 7 AND ply-bf = 0
        EXIT PARAGRAPH
    END-IF
    IF key-n = 8 AND ply-saw = 0
        EXIT PARAGRAPH
    END-IF
    MOVE key-n TO ply-pend
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
    *> Dead: stay at bottom (Harbour A_Lower when PST_DEAD).
    IF ply-hp <= 0
        EXIT PARAGRAPH
    END-IF
    IF ply-pend NOT = 0
        MOVE ply-pend TO ply-weap
        MOVE 0 TO ply-pend
    END-IF
    *> Vanilla A_Lower does not clear refire; the next shot stays inaccurate.
    MOVE 0 TO gun-step
    PERFORM set-body
    MOVE 3 TO gun-mode
    *> Harbour A_Lower → P_BringUpWeapon → A_Raise same tic.
    PERFORM raise-gun
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
    *> Harbour A_Raise → ready → may FireWeapon same tic.
    IF ply-pend NOT = 0 AND ply-pend NOT = ply-weap
        MOVE 2 TO gun-mode
        PERFORM lower-gun
        EXIT PARAGRAPH
    END-IF
    MOVE 0 TO gun-mode
    PERFORM set-body
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
        END-IF
    END-IF
    IF fire-held = 0
        MOVE 0 TO gun-down
        MOVE 0 TO gun-refire
    END-IF
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
        PERFORM atk-cycle-end
        IF gun-mode NOT = 1
            EXIT PARAGRAPH
        END-IF
    END-IF
    *> S_PISTOL4 A_ReFire: restart before waiting the 5 tics.
    IF gun-step = 3
        PERFORM try-refire
        IF gun-mode = 2
            EXIT PARAGRAPH
        END-IF
    END-IF
    IF gun-step = 0
        MOVE "PISGA0" TO gun-body
        MOVE 4 TO gun-tics
        PERFORM mark-noise
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

atk-cycle-end.
    *> Harbour: pending → A_Lower immediately (not ready then next tic).
    IF ply-pend NOT = 0 AND ply-pend NOT = ply-weap
        MOVE 2 TO gun-mode
        PERFORM lower-gun
        EXIT PARAGRAPH
    END-IF
    IF fire-held = 1
        IF ply-weap = 2 OR ply-weap = 4
            IF ply-ammo >= 1
                MOVE 0 TO gun-step
                EXIT PARAGRAPH
            END-IF
        END-IF
        IF ply-weap = 3
            IF ply-shell >= 1
                MOVE 0 TO gun-step
                EXIT PARAGRAPH
            END-IF
        END-IF
        IF ply-weap = 5
            IF ply-misl >= 1
                MOVE 0 TO gun-step
                EXIT PARAGRAPH
            END-IF
        END-IF
        IF ply-weap = 6
            IF ply-cell >= 1
                MOVE 0 TO gun-step
                EXIT PARAGRAPH
            END-IF
        END-IF
        IF ply-weap = 1 OR ply-weap = 8
            MOVE 0 TO gun-step
            EXIT PARAGRAPH
        END-IF
    END-IF
    PERFORM go-ready
    .

*> A_ReFire: held fire + no pending restarts step 0 same tic (skips frame wait).
try-refire.
    *> A_ReFire: empty gun lowers on this tic (the frame tics are not waited).
    MOVE 0 TO refire-go
    IF fire-held = 1 AND ply-hp > 0
        AND (ply-pend = 0 OR ply-pend = ply-weap)
        ADD 1 TO gun-refire
        PERFORM can-fire
        IF can-n = 1
            MOVE 0 TO gun-step
            MOVE 1 TO refire-go
            EXIT PARAGRAPH
        END-IF
        PERFORM pick-fallback
        MOVE 2 TO gun-mode
        PERFORM lower-gun
        MOVE 1 TO refire-go
        EXIT PARAGRAPH
    END-IF
    MOVE 0 TO gun-refire
    PERFORM can-fire
    IF can-n = 0
        PERFORM pick-fallback
        MOVE 2 TO gun-mode
        PERFORM lower-gun
        MOVE 1 TO refire-go
    END-IF
    .

capture-bob.
    *> A_WeaponReady left psp->sy at WEAPONTOP+bob. A_Lower continues from there.
    IF ply-bob = 0 OR ply-tic < 1
        EXIT PARAGRAPH
    END-IF
    COMPUTE tmp = (ply-tic - 1) * 128
    CALL "bit_and" USING BY VALUE tmp BY VALUE 4095 RETURNING tmp
    CALL "shl_i" USING BY VALUE tmp BY VALUE 19 RETURNING tmp
    CALL "fine_sin_ang" USING BY VALUE tmp RETURNING sn
    CALL "fixed_mul" USING BY VALUE ply-bob BY VALUE sn RETURNING gun-lift
    IF gun-lift < 0
        MOVE 0 TO gun-lift
    END-IF
    .

pick-fallback.
    *> P_CheckAmmo preference: plasma, chaingun, shotgun, pistol, saw, rocket, bfg, fist.
    IF ply-pg = 1 AND ply-cell >= 1
        MOVE 6 TO ply-pend
        EXIT PARAGRAPH
    END-IF
    IF ply-cg = 1 AND ply-ammo >= 1
        MOVE 4 TO ply-pend
        EXIT PARAGRAPH
    END-IF
    IF ply-sg = 1 AND ply-shell >= 1
        MOVE 3 TO ply-pend
        EXIT PARAGRAPH
    END-IF
    IF ply-ammo >= 1
        MOVE 2 TO ply-pend
        EXIT PARAGRAPH
    END-IF
    IF ply-saw = 1
        MOVE 8 TO ply-pend
        EXIT PARAGRAPH
    END-IF
    IF ply-rl = 1 AND ply-misl >= 1
        MOVE 5 TO ply-pend
        EXIT PARAGRAPH
    END-IF
    IF ply-bf = 1 AND ply-cell >= 40
        MOVE 7 TO ply-pend
        EXIT PARAGRAPH
    END-IF
    MOVE 1 TO ply-pend
    .

go-ready.
    MOVE 0 TO gun-mode
    MOVE 0 TO gun-lift
    PERFORM set-body
    MOVE 0 TO gun-tics
    IF fire-held = 0
        MOVE 0 TO gun-down
        MOVE 0 TO gun-refire
    END-IF
    MOVE 1 TO moved-out
    .

*> P_FireWeapon: noise as soon as attack step 0 starts (before hitscan).
mark-noise.
    MOVE 1 TO ply-shot
    MOVE ply-x TO ply-shot-x
    MOVE ply-y TO ply-shot-y
    .

do-shot.
    IF ply-on = 0 OR ply-ammo < 1
        EXIT PARAGRAPH
    END-IF
    SUBTRACT 1 FROM ply-ammo
    MOVE "pistol" TO snd-name
    CALL "sfx-play" USING snd-name
    DIVIDE ply-h BY 2 GIVING half-h
    CALL "add_i32" USING BY VALUE half-h BY VALUE 524288 RETURNING tmp
    CALL "add_i32" USING BY VALUE ply-z BY VALUE tmp RETURNING shoot-z
    PERFORM bullet-slope
    *> P_GunShot: damage RNG first, then angle spread if !accurate.
    PERFORM take-rnd
    DIVIDE rnd-n BY 3 GIVING q-n REMAINDER rem-n
    ADD 1 TO rem-n
    MULTIPLY rem-n BY 5 GIVING dmg
    MOVE ply-ang TO shot-ang
    IF gun-refire NOT = 0
        PERFORM take-rnd
        MOVE rnd-n TO rnd-a
        PERFORM take-rnd
        SUBTRACT rnd-n FROM rnd-a
        CALL "mul_i32" USING BY VALUE rnd-a BY VALUE 262144 RETURNING tmp
        CALL "add_i32" USING BY VALUE shot-ang BY VALUE tmp RETURNING shot-ang
    END-IF
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
        PERFORM atk-cycle-end
        IF gun-mode NOT = 1
            EXIT PARAGRAPH
        END-IF
    END-IF
    *> S_SGUN9 A_ReFire: restart before waiting the 7 tics.
    IF gun-step = 8
        PERFORM try-refire
        IF gun-mode = 2
            EXIT PARAGRAPH
        END-IF
    END-IF
    IF gun-step = 0
        MOVE "SHTGA0" TO gun-body
        MOVE 3 TO gun-tics
        PERFORM mark-noise
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
    IF gun-step >= 3
        PERFORM atk-cycle-end
        IF gun-mode NOT = 1
            EXIT PARAGRAPH
        END-IF
    END-IF
    *> S_CHAIN3 A_ReFire (tics 0): restart or settle same tic.
    IF gun-step = 2
        PERFORM try-refire
        IF refire-go = 0
            IF ply-pend NOT = 0 AND ply-pend NOT = ply-weap
                MOVE 2 TO gun-mode
                PERFORM lower-gun
                EXIT PARAGRAPH
            END-IF
            PERFORM go-ready
            EXIT PARAGRAPH
        END-IF
    END-IF
    IF gun-step = 0
        MOVE "CHGGA0" TO gun-body
        MOVE 4 TO gun-tics
        MOVE "CHGFA0" TO gun-flash
        MOVE 5 TO gun-flash-n
        PERFORM mark-noise
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
        PERFORM atk-cycle-end
        IF gun-mode NOT = 1
            EXIT PARAGRAPH
        END-IF
    END-IF
    IF gun-step = 0
        MOVE "PUNGB0" TO gun-body
        MOVE 4 TO gun-tics
        PERFORM mark-noise
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
        PERFORM atk-cycle-end
        IF gun-mode NOT = 1
            EXIT PARAGRAPH
        END-IF
    END-IF
    IF gun-step = 0
        MOVE "SAWGA0" TO gun-body
        MOVE 4 TO gun-tics
        PERFORM mark-noise
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
    IF gun-step >= 3
        PERFORM atk-cycle-end
        IF gun-mode NOT = 1
            EXIT PARAGRAPH
        END-IF
    END-IF
    *> S_MISSILE3 A_ReFire (tics 0).
    IF gun-step = 2
        PERFORM try-refire
        IF refire-go = 0
            IF ply-pend NOT = 0 AND ply-pend NOT = ply-weap
                MOVE 2 TO gun-mode
                PERFORM lower-gun
                EXIT PARAGRAPH
            END-IF
            PERFORM go-ready
            EXIT PARAGRAPH
        END-IF
    END-IF
    IF gun-step = 0
        MOVE "MISGB0" TO gun-body
        MOVE 8 TO gun-tics
        MOVE "MISFA0" TO gun-flash
        MOVE 15 TO gun-flash-n
        PERFORM mark-noise
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
        PERFORM atk-cycle-end
        IF gun-mode NOT = 1
            EXIT PARAGRAPH
        END-IF
    END-IF
    *> S_PLASMA2 A_ReFire.
    IF gun-step = 1
        PERFORM try-refire
        IF gun-mode = 2
            EXIT PARAGRAPH
        END-IF
    END-IF
    IF gun-step = 0
        MOVE "PLSGA0" TO gun-body
        MOVE 3 TO gun-tics
        PERFORM mark-noise
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
        PERFORM mark-noise
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
    IF ply-on = 0
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
    CALL "alloc-mobj" USING born-i
    IF born-i = 0
        PERFORM take-rnd
        PERFORM take-rnd
        EXIT PARAGRAPH
    END-IF
    *> P_SpawnPlayerMissile: at the player, not a radius step ahead.
    *> The half-momentum nudge is what carries it out of the body.
    MOVE ply-x TO mo-x(born-i)
    MOVE ply-y TO mo-y(born-i)
    CALL "add_i32" USING BY VALUE ply-z BY VALUE 2097152
        RETURNING mo-z(born-i)
    MOVE bolt-name TO mo-name(born-i)
    MOVE 32768 TO mo-frame(born-i)
    MOVE 0 TO mo-flags(born-i)
    MOVE 5 TO mo-kind(born-i)
    MOVE 0 TO mo-ai(born-i)
    MOVE 0 TO mo-tic(born-i)
    MOVE 0 TO mo-wait(born-i)
    MOVE mo-hold TO mo-seq(born-i)
    MOVE try-ang TO mo-ang(born-i)
    MOVE 0 TO mo-step(born-i)
    MOVE 524288 TO mo-h(born-i)
    MOVE rad-n TO mo-rad(born-i)
    MOVE base-d TO mo-hp(born-i)
    CALL "fixed_mul" USING BY VALUE spd-n BY VALUE cs
        RETURNING mo-mx(born-i)
    CALL "fixed_mul" USING BY VALUE spd-n BY VALUE sn
        RETURNING mo-my(born-i)
    IF aim-sl > 65536
        MOVE 65536 TO aim-sl
    END-IF
    IF aim-sl < -65536
        MOVE -65536 TO aim-sl
    END-IF
    CALL "fixed_mul" USING BY VALUE spd-n BY VALUE aim-sl
        RETURNING mo-mz(born-i)
    *> spawnMobj lastlook (P_Random % 4), then P_CheckMissileSpawn's tic roll.
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

shot-gun.
    IF ply-on = 0 OR ply-shell < 1
        EXIT PARAGRAPH
    END-IF
    SUBTRACT 1 FROM ply-shell
    MOVE "shotgn" TO snd-name
    CALL "sfx-play" USING snd-name
    DIVIDE ply-h BY 2 GIVING half-h
    CALL "add_i32" USING BY VALUE half-h BY VALUE 524288 RETURNING tmp
    CALL "add_i32" USING BY VALUE ply-z BY VALUE tmp RETURNING shoot-z
    PERFORM bullet-slope
    *> 7× P_GunShot: damage RNG, then (R-R)*262144 spread (always !accurate).
    PERFORM VARYING pellet-n FROM 1 BY 1 UNTIL pellet-n > 7
        PERFORM take-rnd
        DIVIDE rnd-n BY 3 GIVING q-n REMAINDER rem-n
        ADD 1 TO rem-n
        MULTIPLY rem-n BY 5 GIVING dmg
        MOVE ply-ang TO shot-ang
        PERFORM take-rnd
        MOVE rnd-n TO rnd-a
        PERFORM take-rnd
        SUBTRACT rnd-n FROM rnd-a
        CALL "mul_i32" USING BY VALUE rnd-a BY VALUE 262144 RETURNING tmp
        CALL "add_i32" USING BY VALUE shot-ang BY VALUE tmp
            RETURNING shot-ang
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
    DIVIDE ply-h BY 2 GIVING half-h
    CALL "add_i32" USING BY VALUE half-h BY VALUE 524288 RETURNING tmp
    CALL "add_i32" USING BY VALUE ply-z BY VALUE tmp RETURNING shoot-z
    *> Fist/saw: damage RNG first, then angle spread; aim along shot angle.
    PERFORM take-rnd
    DIVIDE rnd-n BY 10 GIVING q-n REMAINDER rem-n
    ADD 1 TO rem-n
    MULTIPLY rem-n BY 2 GIVING dmg
    IF ply-weap = 1 AND ply-str > 0
        MULTIPLY dmg BY 10 GIVING dmg
    END-IF
    MOVE ply-ang TO shot-ang
    PERFORM take-rnd
    MOVE rnd-n TO rnd-a
    PERFORM take-rnd
    SUBTRACT rnd-n FROM rnd-a
    CALL "mul_i32" USING BY VALUE rnd-a BY VALUE 262144 RETURNING tmp
    CALL "add_i32" USING BY VALUE shot-ang BY VALUE tmp RETURNING shot-ang
    MOVE shot-ang TO try-ang
    PERFORM aim-at
    IF aim-mo = 0
        MOVE 0 TO aim-sl
    END-IF
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
    PERFORM collect-hits
    .

mon-ray.
    MOVE ray-slot TO shot-src
    MOVE ray-ang TO shot-ang
    MOVE ray-mode TO quiet-n
    MOVE 0 TO ray-slot
    IF shot-src < 1 OR shot-src > n-mobj
        MOVE 0 TO shot-src
        MOVE 0 TO quiet-n
        EXIT PARAGRAPH
    END-IF
    DIVIDE mo-h(shot-src) BY 2 GIVING half-h
    CALL "add_i32" USING BY VALUE half-h BY VALUE 524288 RETURNING half-h
    CALL "add_i32" USING BY VALUE mo-z(shot-src) BY VALUE half-h
        RETURNING shoot-z
    CALL "fine_cos_ang" USING BY VALUE shot-ang RETURNING cs
    CALL "fine_sin_ang" USING BY VALUE shot-ang RETURNING sn
    MOVE 2048 TO range-u
    MOVE 134217728 TO range-fu
    MOVE mo-x(shot-src) TO ox
    MOVE mo-y(shot-src) TO oy
    IF quiet-n = 1
        MOVE 0 TO aim-sl
        MOVE 1 TO trace-mode
        MOVE 0 TO quiet-n
        PERFORM collect-hits
        PERFORM walk-hits
        MOVE aim-sl TO ray-sl
    ELSE
        MOVE ray-sl TO aim-sl
        MOVE 2 TO trace-mode
        MOVE 0 TO ray-hit
        MOVE 0 TO ray-mo
        MOVE 1 TO quiet-n
        PERFORM collect-hits
        PERFORM walk-hits
        MOVE 0 TO quiet-n
    END-IF
    MOVE 0 TO shot-src
    .

collect-hits.
    *> Vanilla P_PathTraverse: if origin sits on a block edge, nudge +1 so
    *> DDA/intercepts match (changes dx/dy vs un-nudged end point).
    MOVE ox TO orig-x
    MOVE oy TO orig-y
    CALL "sub_i32" USING BY VALUE ox BY VALUE blk-org-x RETURNING tmp
    CALL "bit_and" USING BY VALUE tmp BY VALUE 8388607 RETURNING bit-n
    IF bit-n = 0
        CALL "add_i32" USING BY VALUE ox BY VALUE 65536 RETURNING ox
    END-IF
    CALL "sub_i32" USING BY VALUE oy BY VALUE blk-org-y RETURNING tmp
    CALL "bit_and" USING BY VALUE tmp BY VALUE 8388607 RETURNING bit-n
    IF bit-n = 0
        CALL "add_i32" USING BY VALUE oy BY VALUE 65536 RETURNING oy
    END-IF
    CALL "mul_i32" USING BY VALUE cs BY VALUE range-u RETURNING tdx
    CALL "mul_i32" USING BY VALUE sn BY VALUE range-u RETURNING tdy
    *> End point from the pre-nudge origin; dx/dy from the nudged one.
    CALL "add_i32" USING BY VALUE orig-x BY VALUE tdx RETURNING along
    CALL "add_i32" USING BY VALUE orig-y BY VALUE tdy RETURNING perp
    CALL "sub_i32" USING BY VALUE along BY VALUE ox RETURNING tdx
    CALL "sub_i32" USING BY VALUE perp BY VALUE oy RETURNING tdy
    MOVE 0 TO n-hit
    PERFORM VARYING li FROM 1 BY 1 UNTIL li > n-line
        PERFORM add-line
    END-PERFORM
    PERFORM VARYING mo-i FROM 1 BY 1 UNTIL mo-i > n-mobj
        PERFORM add-thing
    END-PERFORM
    IF shot-src > 0
        PERFORM add-player
    END-IF
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
    *> Vanilla PIT_AddThingIntercepts via corner diagonal; then require the
    *> thing's blockmap footprint to lie on the pathTraverse DDA (Node links
    *> things only in touched blocks — global mobj scan otherwise false-hits).
    IF n-hit >= 128
        EXIT PARAGRAPH
    END-IF
    IF shot-src > 0 AND mo-i = shot-src
        EXIT PARAGRAPH
    END-IF
    CALL "bit_and" USING BY VALUE mo-flags(mo-i) BY VALUE 4
        RETURNING bit-n
    IF bit-n = 0
        EXIT PARAGRAPH
    END-IF
    *> Gate first: if DDA would never visit this thing's blocks, skip.
    CALL "thing_on_trace" USING
        BY VALUE ox BY VALUE oy BY VALUE tdx BY VALUE tdy
        BY VALUE blk-org-x BY VALUE blk-org-y
        BY VALUE blk-w BY VALUE blk-h
        BY VALUE mo-x(mo-i) BY VALUE mo-y(mo-i)
        BY VALUE mo-rad(mo-i)
        RETURNING bit-n
    IF bit-n = 0
        EXIT PARAGRAPH
    END-IF
    CALL "bit_xor" USING BY VALUE tdx BY VALUE tdy RETURNING tmp
    CALL "sub_i32" USING BY VALUE mo-x(mo-i) BY VALUE mo-rad(mo-i)
        RETURNING wx
    CALL "add_i32" USING BY VALUE mo-x(mo-i) BY VALUE mo-rad(mo-i)
        RETURNING along
    IF tmp > 0
        CALL "add_i32" USING BY VALUE mo-y(mo-i) BY VALUE mo-rad(mo-i)
            RETURNING wy
        CALL "sub_i32" USING BY VALUE mo-y(mo-i) BY VALUE mo-rad(mo-i)
            RETURNING perp
    ELSE
        CALL "sub_i32" USING BY VALUE mo-y(mo-i) BY VALUE mo-rad(mo-i)
            RETURNING wy
        CALL "add_i32" USING BY VALUE mo-y(mo-i) BY VALUE mo-rad(mo-i)
            RETURNING perp
    END-IF
    CALL "trace_frac" USING
        BY VALUE ox BY VALUE oy BY VALUE tdx BY VALUE tdy
        BY VALUE wx BY VALUE wy BY VALUE along BY VALUE perp
        RETURNING frac
    IF frac < 0 OR frac > 65536
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO n-hit
    MOVE 2 TO hit-kind(n-hit)
    MOVE 0 TO hit-ln(n-hit)
    MOVE frac TO hit-fr(n-hit)
    MOVE mo-i TO hit-mo(n-hit)
    .

add-player.
    IF ply-hp <= 0 OR n-hit >= 128
        EXIT PARAGRAPH
    END-IF
    CALL "thing_on_trace" USING
        BY VALUE ox BY VALUE oy BY VALUE tdx BY VALUE tdy
        BY VALUE blk-org-x BY VALUE blk-org-y
        BY VALUE blk-w BY VALUE blk-h
        BY VALUE ply-x BY VALUE ply-y
        BY VALUE ply-rad
        RETURNING bit-n
    IF bit-n = 0
        EXIT PARAGRAPH
    END-IF
    CALL "bit_xor" USING BY VALUE tdx BY VALUE tdy RETURNING tmp
    CALL "sub_i32" USING BY VALUE ply-x BY VALUE ply-rad RETURNING wx
    CALL "add_i32" USING BY VALUE ply-x BY VALUE ply-rad RETURNING along
    IF tmp > 0
        CALL "add_i32" USING BY VALUE ply-y BY VALUE ply-rad RETURNING wy
        CALL "sub_i32" USING BY VALUE ply-y BY VALUE ply-rad RETURNING perp
    ELSE
        CALL "sub_i32" USING BY VALUE ply-y BY VALUE ply-rad RETURNING wy
        CALL "add_i32" USING BY VALUE ply-y BY VALUE ply-rad RETURNING perp
    END-IF
    CALL "trace_frac" USING
        BY VALUE ox BY VALUE oy BY VALUE tdx BY VALUE tdy
        BY VALUE wx BY VALUE wy BY VALUE along BY VALUE perp
        RETURNING frac
    IF frac < 0 OR frac > 65536
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO n-hit
    MOVE 3 TO hit-kind(n-hit)
    MOVE 0 TO hit-ln(n-hit)
    MOVE frac TO hit-fr(n-hit)
    MOVE 0 TO hit-mo(n-hit)
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
            IF hit-kind(hi) = 3
                IF trace-mode = 1
                    PERFORM player-aim
                ELSE
                    PERFORM player-shot
                END-IF
            ELSE
                IF trace-mode = 1
                    PERFORM thing-aim
                ELSE
                    PERFORM thing-shot
                END-IF
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
    IF fs < 1 OR fs > 512
        EXIT PARAGRAPH
    END-IF
    MOVE sec-floor-h(fs) TO op-bot
    MOVE sec-ceil-h(fs) TO op-top
    IF bs >= 1 AND bs <= 512
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
    *> PTR_ShootTraverse: a sky hit returns before P_SpawnPuff, so the
    *> puff z-jitter is not rolled. Monster shots must not report a puff.
    IF fs >= 1 AND fs <= 512
        IF sec-ceil-pic(fs) = sky-flat AND zz > sec-ceil-h(fs)
            EXIT PARAGRAPH
        END-IF
        IF sec-ceil-pic(fs) = sky-flat
            AND bs >= 1 AND bs <= 512
            AND sec-ceil-pic(bs) = sky-flat
            EXIT PARAGRAPH
        END-IF
    END-IF
    IF quiet-n = 1
        MOVE 3 TO ray-hit
        EXIT PARAGRAPH
    END-IF
    PERFORM mark-jitter
    PERFORM puff-spawn
    .

player-aim.
    PERFORM player-slope
    IF did-hit = 0
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
    MOVE 0 TO aim-mo
    MOVE 1 TO stop-scan
    .

player-shot.
    PERFORM player-slope
    IF did-hit = 0
        EXIT PARAGRAPH
    END-IF
    MOVE 1 TO stop-scan
    IF quiet-n = 1
        MOVE 2 TO ray-hit
        EXIT PARAGRAPH
    END-IF
    .

player-slope.
    MOVE 0 TO did-hit
    PERFORM hit-dist
    IF dist-n = 0
        EXIT PARAGRAPH
    END-IF
    CALL "add_i32" USING BY VALUE ply-z BY VALUE ply-h RETURNING tmp
    CALL "sub_i32" USING BY VALUE tmp BY VALUE shoot-z RETURNING tmp
    CALL "fixed_div" USING BY VALUE tmp BY VALUE dist-n RETURNING thing-top
    IF trace-mode = 1
        IF thing-top < win-bot
            EXIT PARAGRAPH
        END-IF
    ELSE
        IF thing-top < aim-sl
            EXIT PARAGRAPH
        END-IF
    END-IF
    CALL "sub_i32" USING BY VALUE ply-z BY VALUE shoot-z RETURNING tmp
    CALL "fixed_div" USING BY VALUE tmp BY VALUE dist-n RETURNING thing-bot
    IF trace-mode = 1
        IF thing-bot > win-top
            EXIT PARAGRAPH
        END-IF
    ELSE
        IF thing-bot > aim-sl
            EXIT PARAGRAPH
        END-IF
    END-IF
    MOVE 1 TO did-hit
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
    IF quiet-n = 1
        MOVE 1 TO ray-hit
        MOVE who-i TO ray-mo
        EXIT PARAGRAPH
    END-IF
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 524288
        RETURNING bit-n
    IF bit-n NOT = 0
        MOVE 128 TO back-n
        PERFORM mark-spot
        PERFORM mark-jitter
        PERFORM puff-spawn
    ELSE
        MOVE 320 TO back-n
        PERFORM mark-spot
        PERFORM mark-jitter
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
    .

mark-jitter.
    *> P_SpawnPuff/Blood z += (P_Random()-P_Random())<<10. Not on sky hits.
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
    *> P_SpawnPuff/Blood via spawnMobj: lastlook = P_Random&3, then tics -= P_Random&3.
    CALL "alloc-mobj" USING born-i
    IF born-i = 0
        PERFORM take-rnd
        PERFORM take-rnd
        EXIT PARAGRAPH
    END-IF
    MOVE zx TO mo-x(born-i)
    MOVE zy TO mo-y(born-i)
    MOVE zz TO mo-z(born-i)
    MOVE blob-name TO mo-name(born-i)
    MOVE blob-fr TO mo-frame(born-i)
    MOVE 0 TO mo-flags(born-i)
    MOVE 0 TO mo-hp(born-i)
    MOVE 0 TO mo-max(born-i)
    MOVE 0 TO mo-seq(born-i)
    MOVE 0 TO mo-step(born-i)
    MOVE 0 TO mo-ang(born-i)
    MOVE 0 TO mo-rad(born-i)
    MOVE 1048576 TO mo-h(born-i)
    MOVE blob-tic TO mo-tic(born-i)
    MOVE blob-kind TO mo-kind(born-i)
    PERFORM take-rnd
    CALL "bit_and" USING BY VALUE rnd-n BY VALUE 3 RETURNING mo-look(born-i)
    PERFORM take-rnd
    CALL "bit_and" USING BY VALUE rnd-n BY VALUE 3 RETURNING rem-n
    SUBTRACT rem-n FROM mo-tic(born-i)
    IF mo-tic(born-i) < 1
        MOVE 1 TO mo-tic(born-i)
    END-IF
    MOVE 1 TO moved-out
    .

hurt-thing.
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 4
        RETURNING bit-n
    IF bit-n = 0
        EXIT PARAGRAPH
    END-IF
    IF mo-hp(who-i) <= 0
        EXIT PARAGRAPH
    END-IF
    *> P_DamageMobj thrust before health change (#21 skull clear + knockback).
    PERFORM thrust-thing
    SUBTRACT dmg FROM mo-hp(who-i)
    IF mo-hp(who-i) > 0
        PERFORM flinch
        EXIT PARAGRAPH
    END-IF
    PERFORM start-death
    .

thrust-thing.
    *> Harbour: clear MF_SKULLFLY (0x1000000) mom, then knockback.
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 16777216
        RETURNING bit-n
    IF bit-n NOT = 0
        MOVE 0 TO mo-mx(who-i)
        MOVE 0 TO mo-my(who-i)
        MOVE 0 TO mo-mz(who-i)
    END-IF
    *> MF_NOCLIP = 0x1000 — no thrust.
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 4096
        RETURNING bit-n
    IF bit-n NOT = 0
        EXIT PARAGRAPH
    END-IF
    *> Default origin = player (hitscan/BFG); splash sets thrust-o* first.
    IF thrust-ox = 0 AND thrust-oy = 0 AND thrust-oz = 0
        MOVE ply-x TO thrust-ox
        MOVE ply-y TO thrust-oy
        MOVE ply-z TO thrust-oz
    END-IF
    CALL "point_to_angle" USING
        BY VALUE thrust-ox BY VALUE thrust-oy
        BY VALUE mo-x(who-i) BY VALUE mo-y(who-i)
        RETURNING aim-ang
    MOVE 100 TO mass-n
    IF mo-name(who-i) = "SARG" OR mo-name(who-i) = "HEAD"
        OR mo-name(who-i) = "PAIN" OR mo-name(who-i) = "SKUL"
        MOVE 400 TO mass-n
    END-IF
    IF mo-name(who-i) = "BOSS" OR mo-name(who-i) = "BOS2"
        OR mo-name(who-i) = "SPID" OR mo-name(who-i) = "CYBR"
        OR mo-name(who-i) = "VILE" OR mo-name(who-i) = "FATT"
        MOVE 1000 TO mass-n
    END-IF
    *> thrust = damage * (FRACUNIT/8) * 100 / mass
    COMPUTE thrust-n = dmg * 8192 * 100 / mass-n
    CALL "sub_i32" USING BY VALUE mo-z(who-i) BY VALUE thrust-oz
        RETURNING tmp
    IF dmg < 40 AND dmg > mo-hp(who-i) AND tmp > 4194304
        PERFORM take-rnd
        CALL "bit_and" USING BY VALUE rnd-n BY VALUE 1 RETURNING bit-n
        IF bit-n NOT = 0
            CALL "add_i32" USING BY VALUE aim-ang BY VALUE -2147483648
                RETURNING aim-ang
            COMPUTE thrust-n = thrust-n * 4
        END-IF
    END-IF
    CALL "fine_cos_ang" USING BY VALUE aim-ang RETURNING cs
    CALL "fine_sin_ang" USING BY VALUE aim-ang RETURNING sn
    CALL "fixed_mul" USING BY VALUE thrust-n BY VALUE cs RETURNING dx
    CALL "fixed_mul" USING BY VALUE thrust-n BY VALUE sn RETURNING dy
    CALL "add_i32" USING BY VALUE mo-mx(who-i) BY VALUE dx
        RETURNING mo-mx(who-i)
    CALL "add_i32" USING BY VALUE mo-my(who-i) BY VALUE dy
        RETURNING mo-my(who-i)
    MOVE 0 TO thrust-ox
    MOVE 0 TO thrust-oy
    MOVE 0 TO thrust-oz
    .

flinch.
    *> P_DamageMobj painOrWake: always P_Random (BAR1 painchance 0 still draws).
    MOVE 0 TO rem-n
    IF mo-name(who-i) = "POSS" OR mo-name(who-i) = "TROO"
        MOVE 200 TO rem-n
    END-IF
    IF mo-name(who-i) = "SPOS" OR mo-name(who-i) = "CPOS"
        OR mo-name(who-i) = "SSWV"
        MOVE 170 TO rem-n
    END-IF
    IF mo-name(who-i) = "SARG"
        MOVE 180 TO rem-n
    END-IF
    IF mo-name(who-i) = "HEAD" OR mo-name(who-i) = "PAIN"
        OR mo-name(who-i) = "BSPI"
        MOVE 128 TO rem-n
    END-IF
    IF mo-name(who-i) = "SKUL"
        MOVE 256 TO rem-n
    END-IF
    IF mo-name(who-i) = "SKEL"
        MOVE 100 TO rem-n
    END-IF
    IF mo-name(who-i) = "BOSS" OR mo-name(who-i) = "BOS2"
        MOVE 50 TO rem-n
    END-IF
    IF mo-name(who-i) = "SPID"
        MOVE 40 TO rem-n
    END-IF
    IF mo-name(who-i) = "CYBR"
        MOVE 20 TO rem-n
    END-IF
    IF mo-name(who-i) = "VILE"
        MOVE 10 TO rem-n
    END-IF
    IF mo-name(who-i) = "FATT"
        MOVE 80 TO rem-n
    END-IF
    *> Only known shootables + BAR1 draw pain RNG (skip FX/corpses).
    IF rem-n = 0 AND mo-name(who-i) NOT = "BAR1"
        EXIT PARAGRAPH
    END-IF
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 16777216
        RETURNING bit-n
    PERFORM take-rnd
    IF rnd-n < rem-n AND bit-n = 0
        *> MF_JUSTHIT = 64 — next missile check succeeds without range RNG.
        CALL "bit_or" USING BY VALUE mo-flags(who-i) BY VALUE 64
            RETURNING mo-flags(who-i)
        IF mo-name(who-i) = "SARG" OR mo-name(who-i) = "BOSS"
            OR mo-name(who-i) = "BOS2" OR mo-name(who-i) = "HEAD"
            OR mo-name(who-i) = "SPID" OR mo-name(who-i) = "CYBR"
            OR mo-name(who-i) = "BSPI" OR mo-name(who-i) = "VILE"
            OR mo-name(who-i) = "SKEL" OR mo-name(who-i) = "FATT"
            OR mo-name(who-i) = "PAIN" OR mo-name(who-i) = "SKUL"
            MOVE "dmpain" TO snd-name
        ELSE
            MOVE "popain" TO snd-name
        END-IF
        CALL "sfx-play" USING snd-name
        IF mo-name(who-i) NOT = "BOSS" AND mo-name(who-i) NOT = "BOS2"
            AND mo-name(who-i) NOT = "CYBR" AND mo-name(who-i) NOT = "SPID"
            MOVE 5 TO mo-ai(who-i)
            *> PAIN+PAIN2 wait = total tics - 1 (default 3+3 → 5).
            MOVE 5 TO mo-wait(who-i)
            IF mo-name(who-i) = "TROO" OR mo-name(who-i) = "SARG"
                OR mo-name(who-i) = "BOSS" OR mo-name(who-i) = "BOS2"
                MOVE 3 TO mo-wait(who-i)
            END-IF
            IF mo-name(who-i) = "SKEL" OR mo-name(who-i) = "VILE"
                MOVE 9 TO mo-wait(who-i)
            END-IF
            IF mo-name(who-i) = "PAIN"
                MOVE 11 TO mo-wait(who-i)
            END-IF
            IF mo-name(who-i) = "TROO"
                MOVE 7 TO mo-frame(who-i)
            ELSE
                MOVE 6 TO mo-frame(who-i)
            END-IF
        END-IF
    END-IF
    *> Always clear reactiontime; wake idle → chase (spawnstate only).
    MOVE 0 TO mo-react(who-i)
    *> P_DamageMobj: a monster source steals the target when threshold is 0.
    IF mo-name(who-i) NOT = "BAR1"
        IF hit-who > 0 AND hit-who NOT = who-i
            AND mo-name(hit-who) NOT = "VILE"
            IF mo-thrs(who-i) = 0 OR mo-name(who-i) = "VILE"
                MOVE hit-who TO mo-tgt(who-i)
                MOVE 100 TO mo-thrs(who-i)
            END-IF
        ELSE
            IF hit-who = 0
                AND (mo-thrs(who-i) = 0 OR mo-name(who-i) = "VILE")
                MOVE 0 TO mo-tgt(who-i)
                MOVE 100 TO mo-thrs(who-i)
            END-IF
        END-IF
    END-IF
    IF mo-ai(who-i) = 0 AND mo-frame(who-i) = 0
        MOVE 2 TO mo-ai(who-i)
        MOVE 0 TO mo-wait(who-i)
        MOVE 0 TO mo-step(who-i)
        MOVE 1 TO moved-out
    END-IF
    .

foe-die.
    *> Death scream is A_Scream on DIE2 (corpse-next step 2), not at kill.
    *> P_KillMobj only setMobjState(DIE1) + tics jitter + drop.
    CONTINUE
    .

a-scream.
    *> Vanilla A_Scream when entering DIE2.
    MOVE SPACES TO snd-name
    IF mo-seq(who-i) = 1
        *> Gibbed trooper: XScream is slop and draws no random.
        IF mo-name(who-i) = "POSS" AND mo-hp(who-i) < -20
            MOVE "slop" TO snd-name
        ELSE
            IF mo-name(who-i) = "SPOS" AND mo-hp(who-i) < -30
                MOVE "slop" TO snd-name
            ELSE
                IF mo-name(who-i) = "SSWV" AND mo-hp(who-i) < -50
                    MOVE "slop" TO snd-name
                ELSE
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
            END-IF
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
    IF mo-seq(who-i) = 4
        MOVE "podth2" TO snd-name
    END-IF
    IF mo-seq(who-i) = 5
        IF mo-name(who-i) = "HEAD"
            MOVE "cacdth" TO snd-name
        END-IF
        IF mo-name(who-i) = "SKUL"
            MOVE "firxpl" TO snd-name
        END-IF
        IF mo-name(who-i) = "PAIN"
            MOVE "pedth" TO snd-name
        END-IF
    END-IF
    IF mo-name(who-i) = "BOSS"
        MOVE "brsdth" TO snd-name
    END-IF
    IF mo-name(who-i) = "BOS2"
        MOVE "kntdth" TO snd-name
    END-IF
    IF mo-name(who-i) = "SPID"
        MOVE "spidth" TO snd-name
    END-IF
    IF mo-name(who-i) = "CYBR"
        MOVE "cybdth" TO snd-name
    END-IF
    IF mo-name(who-i) = "BSPI"
        MOVE "bspdth" TO snd-name
    END-IF
    IF mo-name(who-i) = "VILE"
        MOVE "vildth" TO snd-name
    END-IF
    IF mo-name(who-i) = "SKEL"
        MOVE "skedth" TO snd-name
    END-IF
    IF mo-name(who-i) = "FATT"
        MOVE "mandth" TO snd-name
    END-IF
    IF snd-name NOT = SPACES
        CALL "sfx-play" USING snd-name
    END-IF
    .

start-death.
    *> P_KillMobj clears SHOOTABLE, not SOLID. A_Fall drops SOLID later.
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE -5
        RETURNING tmp
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE 4194304
        RETURNING bit-n
    IF bit-n NOT = 0
        ADD 1 TO ply-kills
    END-IF
    MOVE tmp TO mo-flags(who-i)
    DIVIDE mo-h(who-i) BY 4 GIVING mo-h(who-i)
    MOVE 0 TO mo-seq(who-i)
    MOVE 0 TO mo-count(who-i)
    IF mo-name(who-i) = "POSS" OR mo-name(who-i) = "SPOS"
        OR mo-name(who-i) = "SSWV"
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
    IF mo-name(who-i) = "HEAD" OR mo-name(who-i) = "PAIN"
        OR mo-name(who-i) = "SKUL"
        MOVE 5 TO mo-seq(who-i)
    END-IF
    IF mo-name(who-i) = "CYBR" OR mo-name(who-i) = "SPID"
        OR mo-name(who-i) = "BSPI" OR mo-name(who-i) = "VILE"
        OR mo-name(who-i) = "SKEL" OR mo-name(who-i) = "FATT"
        MOVE 2 TO mo-seq(who-i)
    END-IF
    *> foe-die kept for hook; scream deferred to corpse-next DIE2.
    PERFORM foe-die
    IF mo-name(who-i) = "BAR1"
        *> S_BEXP: BEXP A|5|NULL (scream on B, explode on D).
        MOVE "BEXP" TO mo-name(who-i)
        MOVE 32768 TO mo-frame(who-i)
        MOVE 0 TO mo-step(who-i)
        MOVE 5 TO mo-tic(who-i)
        MOVE 3 TO mo-kind(who-i)
        PERFORM take-rnd
        CALL "bit_and" USING BY VALUE rnd-n BY VALUE 3 RETURNING rem-n
        SUBTRACT rem-n FROM mo-tic(who-i)
        IF mo-tic(who-i) < 1
            MOVE 1 TO mo-tic(who-i)
        END-IF
        *> First tics decrement is the barrel's own mobjThinker (list order),
        *> not here — playerThink already finished this gametic.
        MOVE 1 TO moved-out
        EXIT PARAGRAPH
    END-IF
    MOVE 3 TO mo-kind(who-i)
    IF mo-name(who-i) = "PAIN"
        PERFORM pain-burst
    END-IF
    IF mo-seq(who-i) = 0
        MOVE -1 TO mo-tic(who-i)
        MOVE 1 TO moved-out
        PERFORM death-drop
        EXIT PARAGRAPH
    END-IF
    MOVE 1 TO mo-step(who-i)
    COMPUTE slot = (mo-seq(who-i) - 1) * 8 + 1
    MOVE die-fr(slot) TO mo-frame(who-i)
    MOVE die-tic(slot) TO mo-tic(who-i)
    IF mo-name(who-i) = "POSS" AND mo-hp(who-i) < -20
        MOVE 12 TO mo-frame(who-i)
        MOVE 5 TO mo-tic(who-i)
    END-IF
    *> P_KillMobj: setMobjState (A_Scream) → tics -= R&3 → drop.
    PERFORM take-rnd
    CALL "bit_and" USING BY VALUE rnd-n BY VALUE 3 RETURNING rem-n
    SUBTRACT rem-n FROM mo-tic(who-i)
    IF mo-tic(who-i) < 1
        MOVE 1 TO mo-tic(who-i)
    END-IF
    PERFORM death-drop
    *> Player shot: the victim's thinker still runs this tic and burns one tic.
    *> A missile hits during a later thinker, so that tick already happened.
    IF late-kill = 0 AND mo-tic(who-i) > 0
        SUBTRACT 1 FROM mo-tic(who-i)
        IF mo-tic(who-i) = 0
            PERFORM corpse-next
        END-IF
    END-IF
    MOVE 1 TO moved-out
    .

death-drop.
    *> MT_POSSESSED→CLIP, MT_SHOTGUY→SHOTGUN, MT_CHAINGUY→CHAINGUN,
    *> MT_WOLFSS→CLIP; MF_DROPPED|MF_SPECIAL.
    MOVE SPACES TO drop-name
    IF mo-name(who-i) = "POSS" OR mo-name(who-i) = "SSWV"
        MOVE "CLIP" TO drop-name
    END-IF
    IF mo-name(who-i) = "SPOS"
        MOVE "SHOT" TO drop-name
    END-IF
    IF mo-name(who-i) = "CPOS"
        MOVE "MGUN" TO drop-name
    END-IF
    IF drop-name NOT = SPACES
        PERFORM spawn-drop
    END-IF
    .

spawn-drop.
    CALL "alloc-mobj" USING born-i
    IF born-i = 0
        PERFORM take-rnd
        EXIT PARAGRAPH
    END-IF
    MOVE mo-x(who-i) TO mo-x(born-i)
    MOVE mo-y(who-i) TO mo-y(born-i)
    MOVE mo-z(who-i) TO mo-z(born-i)
    MOVE drop-name TO mo-name(born-i)
    MOVE 0 TO mo-frame(born-i)
    *> MF_SPECIAL|MF_DROPPED = 1|0x20000
    MOVE 131073 TO mo-flags(born-i)
    MOVE 0 TO mo-kind(born-i)
    MOVE 0 TO mo-ai(born-i)
    MOVE 0 TO mo-step(born-i)
    MOVE 0 TO mo-seq(born-i)
    MOVE 0 TO mo-tic(born-i)
    MOVE 0 TO mo-count(born-i)
    MOVE 0 TO mo-dir(born-i)
    MOVE 0 TO mo-wait(born-i)
    *> spawnMobj: lastlook = P_Random % 4
    PERFORM take-rnd
    CALL "bit_and" USING BY VALUE rnd-n BY VALUE 3
        RETURNING mo-look(born-i)
    MOVE 0 TO mo-ang(born-i)
    MOVE 1048576 TO mo-h(born-i)
    MOVE 1310720 TO mo-rad(born-i)
    MOVE 0 TO mo-hp(born-i)
    MOVE 0 TO mo-max(born-i)
    MOVE 0 TO mo-mx(born-i)
    MOVE 0 TO mo-my(born-i)
    MOVE 0 TO mo-mz(born-i)
    ADD 1 TO map-items
    .

pain-burst.
    MOVE mo-ang(who-i) TO burst-ang
    PERFORM VARYING burst-k FROM 1 BY 1 UNTIL burst-k > 3
        PERFORM one-soul
        CALL "add_i32" USING BY VALUE burst-ang BY VALUE 1073741824
            RETURNING burst-ang
    END-PERFORM
    .

one-soul.
    CALL "fine_cos_ang" USING BY VALUE burst-ang RETURNING cs
    CALL "fine_sin_ang" USING BY VALUE burst-ang RETURNING sn
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
    MOVE 4194310 TO mo-flags(born-i)
    MOVE 0 TO mo-kind(born-i)
    MOVE 4 TO mo-ai(born-i)
    MOVE 0 TO mo-step(born-i)
    MOVE 0 TO mo-seq(born-i)
    MOVE 0 TO mo-tic(born-i)
    MOVE 0 TO mo-count(born-i)
    MOVE 0 TO mo-dir(born-i)
    MOVE 0 TO mo-wait(born-i)
    MOVE burst-ang TO mo-ang(born-i)
    MOVE 3670016 TO mo-h(born-i)
    MOVE 1048576 TO mo-rad(born-i)
    MOVE 100 TO mo-hp(born-i)
    MOVE 100 TO mo-max(born-i)
    MOVE 0 TO mo-mx(born-i)
    MOVE 0 TO mo-my(born-i)
    MOVE 0 TO mo-mz(born-i)
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
        IF did-cross = 0
            PERFORM bolt-near
        END-IF
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
                        *> Missile thinker is after this body already ran,
                        *> so the death frame is not burned again here.
                        MOVE 1 TO late-kill
                        PERFORM hurt-thing
                        MOVE 0 TO late-kill
                        MOVE 1 TO boom-n
                    END-IF
                END-IF
            END-IF
        END-IF
    END-PERFORM
    .

start-boom.
    *> tryMove failed, so the blast stays at the last good spot.
    MOVE ox TO spot-x
    MOVE oy TO spot-y
    MOVE mo-z(bolt-i) TO spot-z
    MOVE ox TO mo-x(bolt-i)
    MOVE oy TO mo-y(bolt-i)
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
    *> P_ExplodeMissile jitters the death tics after the blast.
    IF mo-seq(bolt-i) >= 1 AND mo-seq(bolt-i) <= 3
        PERFORM take-rnd
    END-IF
    MOVE 1 TO moved-out
    .

rocket-splash.
    *> Player block is earlier on the map than this barrel, so his
    *> pain roll comes before the barrel's death jitter.
    PERFORM splash-player
    *> P_RadiusAttack walks blocks by increasing y, then x. A slot scan
    *> gave the near shotgun guy the far one's death-tic roll.
    MOVE 10485760 TO spl-tx
    CALL "sub_i32" USING BY VALUE spot-y BY VALUE spl-tx RETURNING tmp
    CALL "sub_i32" USING BY VALUE tmp BY VALUE blk-org-y RETURNING tmp
    CALL "shar32" USING BY VALUE tmp BY VALUE 23 RETURNING spl-y0
    CALL "add_i32" USING BY VALUE spot-y BY VALUE spl-tx RETURNING tmp
    CALL "sub_i32" USING BY VALUE tmp BY VALUE blk-org-y RETURNING tmp
    CALL "shar32" USING BY VALUE tmp BY VALUE 23 RETURNING spl-y1
    CALL "sub_i32" USING BY VALUE spot-x BY VALUE spl-tx RETURNING tmp
    CALL "sub_i32" USING BY VALUE tmp BY VALUE blk-org-x RETURNING tmp
    CALL "shar32" USING BY VALUE tmp BY VALUE 23 RETURNING spl-x0
    CALL "add_i32" USING BY VALUE spot-x BY VALUE spl-tx RETURNING tmp
    CALL "sub_i32" USING BY VALUE tmp BY VALUE blk-org-x RETURNING tmp
    CALL "shar32" USING BY VALUE tmp BY VALUE 23 RETURNING spl-x1
    IF spl-y0 < 0
        MOVE 0 TO spl-y0
    END-IF
    IF spl-x0 < 0
        MOVE 0 TO spl-x0
    END-IF
    COMPUTE tmp = blk-h - 1
    IF spl-y1 > tmp
        MOVE tmp TO spl-y1
    END-IF
    COMPUTE tmp = blk-w - 1
    IF spl-x1 > tmp
        MOVE tmp TO spl-x1
    END-IF
    PERFORM VARYING spl-by FROM spl-y0 BY 1 UNTIL spl-by > spl-y1
        PERFORM VARYING spl-bx FROM spl-x0 BY 1 UNTIL spl-bx > spl-x1
            PERFORM VARYING victim-i FROM 1 BY 1
                UNTIL victim-i > n-mobj
                IF victim-i NOT = bolt-i
                    AND mo-name(victim-i) NOT = "SPID"
                    AND mo-name(victim-i) NOT = "CYBR"
                    CALL "bit_and" USING
                        BY VALUE mo-flags(victim-i) BY VALUE 4
                        RETURNING bit-n
                    IF bit-n NOT = 0
                        CALL "sub_i32" USING
                            BY VALUE mo-x(victim-i) BY VALUE blk-org-x
                            RETURNING tmp
                        CALL "shar32" USING BY VALUE tmp BY VALUE 23
                            RETURNING spl-tx
                        CALL "sub_i32" USING
                            BY VALUE mo-y(victim-i) BY VALUE blk-org-y
                            RETURNING tmp
                        CALL "shar32" USING BY VALUE tmp BY VALUE 23
                            RETURNING spl-ty
                        IF spl-tx = spl-bx AND spl-ty = spl-by
                            PERFORM splash-one
                        END-IF
                    END-IF
                END-IF
            END-PERFORM
        END-PERFORM
    END-PERFORM
    .

splash-player.
    *> Player is a shootable mobj in vanilla blockmap walk.
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
        AND ply-inv = 0
        *> Reuse splash-los geometry with player as the "victim" coords.
        MOVE spot-x TO walk-x
        MOVE spot-y TO walk-y
        PERFORM locate-bolt
        MOVE sec-at TO spot-sec
        MOVE ply-x TO walk-x
        MOVE ply-y TO walk-y
        PERFORM locate-bolt
        MOVE sec-at TO vict-sec
        MOVE 1 TO splash-see
        IF spot-sec >= 1 AND vict-sec >= 1 AND spot-sec NOT = vict-sec
            COMPUTE pnum = (spot-sec - 1) * n-sector + (vict-sec - 1)
            DIVIDE pnum BY 8 GIVING byte-i REMAINDER rem-n
            IF byte-i >= 0 AND byte-i < reject-n
                CALL "byte_at" USING BY REFERENCE reject-buf
                    BY VALUE byte-i RETURNING bit-n
                MOVE 1 TO mask-n
                PERFORM rem-n TIMES
                    MULTIPLY 2 BY mask-n
                END-PERFORM
                CALL "bit_and" USING BY VALUE bit-n BY VALUE mask-n
                    RETURNING tmp
                IF tmp NOT = 0
                    MOVE 0 TO splash-see
                END-IF
            END-IF
        END-IF
        IF splash-see = 1 AND spot-sec NOT = vict-sec
            MOVE spot-x TO ox
            MOVE spot-y TO oy
            CALL "sub_i32" USING BY VALUE ply-x BY VALUE ox
                RETURNING tdx
            CALL "sub_i32" USING BY VALUE ply-y BY VALUE oy
                RETURNING tdy
            PERFORM VARYING li FROM 1 BY 1
                UNTIL li > n-line OR splash-see = 0
                CALL "point_side" USING
                    BY VALUE vtx-x(ln-v1(li)) BY VALUE vtx-y(ln-v1(li))
                    BY VALUE ln-dx(li) BY VALUE ln-dy(li)
                    BY VALUE ox BY VALUE oy
                    RETURNING side-a
                CALL "point_side" USING
                    BY VALUE vtx-x(ln-v1(li)) BY VALUE vtx-y(ln-v1(li))
                    BY VALUE ln-dx(li) BY VALUE ln-dy(li)
                    BY VALUE ply-x BY VALUE ply-y
                    RETURNING side-bit
                IF side-a NOT = side-bit
                    PERFORM bolt-cross
                    IF did-cross = 1 AND frac > 0 AND frac < 65536
                        PERFORM measure-open
                        IF two-side = 0 OR op-bot >= op-top
                            MOVE 0 TO splash-see
                        END-IF
                    END-IF
                END-IF
            END-PERFORM
        END-IF
        IF splash-see = 1
            *> Radius source is the shooter. The player's own rocket
            *> does not turn the corpse (attacker == player).
            MOVE 0 TO ply-atk
            IF bolt-i >= 1 AND bolt-i <= n-mobj
                IF mo-kind(bolt-i) = 4
                    MOVE mo-count(bolt-i) TO ply-atk
                ELSE
                    IF mo-kind(bolt-i) NOT = 5
                        MOVE mo-tgt(bolt-i) TO ply-atk
                    END-IF
                END-IF
            END-IF
            IF ply-atk < 1 OR ply-atk > n-mobj
                MOVE 0 TO ply-atk
            END-IF
            SUBTRACT units-n FROM 128 GIVING dmg
            MOVE dmg TO tmp
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
            IF ply-skill = 0
                DIVIDE dmg BY 2 GIVING dmg
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
            MOVE 1 TO atk-on
            MOVE spot-x TO atk-x
            MOVE spot-y TO atk-y
            CALL "face-hit" USING dmg atk-on atk-x atk-y
            CALL "push-ply" USING tmp atk-x atk-y
            CALL "ply-ouch"
            *> painOrWake consumes P_Random
            PERFORM take-rnd
        END-IF
    END-IF
    .

splash-one.
    *> P_RadiusAttack: dist then P_CheckSight(victim, spot).
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
        PERFORM splash-los
        IF splash-see = 1
            SUBTRACT units-n FROM 128 GIVING dmg
            MOVE victim-i TO who-i
            MOVE spot-x TO thrust-ox
            MOVE spot-y TO thrust-oy
            MOVE spot-z TO thrust-oz
            *> Barrels already share this splash. Only a player missile
            *> lands after the victim's thinker has run.
            IF mo-kind(bolt-i) = 5
                MOVE 1 TO late-kill
            END-IF
            PERFORM hurt-thing
            MOVE 0 TO late-kill
        END-IF
    END-IF
    .

splash-los.
    *> P_CheckSight-ish: same sector → yes; REJECT block → no; else line walk.
    MOVE 1 TO splash-see
    MOVE spot-x TO walk-x
    MOVE spot-y TO walk-y
    PERFORM locate-bolt
    MOVE sec-at TO spot-sec
    MOVE mo-x(victim-i) TO walk-x
    MOVE mo-y(victim-i) TO walk-y
    PERFORM locate-bolt
    MOVE sec-at TO vict-sec
    IF spot-sec < 1 OR vict-sec < 1
        EXIT PARAGRAPH
    END-IF
    IF spot-sec = vict-sec
        EXIT PARAGRAPH
    END-IF
    COMPUTE pnum = (spot-sec - 1) * n-sector + (vict-sec - 1)
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
            MOVE 0 TO splash-see
            EXIT PARAGRAPH
        END-IF
    END-IF
    MOVE spot-x TO ox
    MOVE spot-y TO oy
    CALL "sub_i32" USING BY VALUE mo-x(victim-i) BY VALUE ox
        RETURNING tdx
    CALL "sub_i32" USING BY VALUE mo-y(victim-i) BY VALUE oy
        RETURNING tdy
    PERFORM VARYING li FROM 1 BY 1
        UNTIL li > n-line OR splash-see = 0
        *> Only lines that separate the two points (straddle).
        CALL "point_side" USING
            BY VALUE vtx-x(ln-v1(li)) BY VALUE vtx-y(ln-v1(li))
            BY VALUE ln-dx(li) BY VALUE ln-dy(li)
            BY VALUE ox BY VALUE oy
            RETURNING side-a
        CALL "point_side" USING
            BY VALUE vtx-x(ln-v1(li)) BY VALUE vtx-y(ln-v1(li))
            BY VALUE ln-dx(li) BY VALUE ln-dy(li)
            BY VALUE mo-x(victim-i) BY VALUE mo-y(victim-i)
            RETURNING side-bit
        IF side-a NOT = side-bit
            PERFORM bolt-cross
            IF did-cross = 1 AND frac > 0 AND frac < 65536
                PERFORM measure-open
                IF two-side = 0 OR op-bot >= op-top
                    MOVE 0 TO splash-see
                END-IF
            END-IF
        END-IF
    END-PERFORM
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

bolt-near.
    CALL "sub_i32" USING BY VALUE nx BY VALUE mo-rad(bolt-i)
        RETURNING box-l
    CALL "add_i32" USING BY VALUE nx BY VALUE mo-rad(bolt-i)
        RETURNING box-r
    CALL "sub_i32" USING BY VALUE ny BY VALUE mo-rad(bolt-i)
        RETURNING box-b
    CALL "add_i32" USING BY VALUE ny BY VALUE mo-rad(bolt-i)
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
    PERFORM VARYING hop-n FROM 1 BY 1 UNTIL hop-n > 1024
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
    *> Only puff/blood/corpse (mo-kind 1..3). Living monsters use enemy-tic.
    PERFORM VARYING mo-i FROM 1 BY 1 UNTIL mo-i > n-mobj
        IF mo-kind(mo-i) >= 1 AND mo-kind(mo-i) <= 3
            AND mo-tic(mo-i) > 0
            AND mo-name(mo-i) NOT = "BEXP"
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

bexp-next.
    *> Vanilla: S_BEXP A|5 → B|5|A_Scream → C|5 → D|10|A_Explode → E|10.
    *> splash-one/hurt-thing overwrite who-i — keep barrel index.
    MOVE who-i TO bexp-i
    CALL "bit_and" USING BY VALUE mo-frame(bexp-i) BY VALUE 32767
        RETURNING mo-frame(bexp-i)
    ADD 1 TO mo-frame(bexp-i)
    *> S_BEXP2: A_Scream → barexp (no podth RNG).
    IF mo-frame(bexp-i) = 1
        MOVE "barexp" TO snd-name
        CALL "sfx-play" USING snd-name
    END-IF
    *> S_BEXP4 (frame D = 3): A_Explode → P_RadiusAttack 128.
    IF mo-frame(bexp-i) = 3
        MOVE mo-x(bexp-i) TO spot-x
        MOVE mo-y(bexp-i) TO spot-y
        MOVE mo-z(bexp-i) TO spot-z
        MOVE bexp-i TO bolt-i
        PERFORM rocket-splash
        MOVE bexp-i TO who-i
    END-IF
    IF mo-frame(bexp-i) > 4
        MOVE SPACES TO mo-name(bexp-i)
        MOVE 0 TO mo-flags(bexp-i)
        MOVE 0 TO mo-kind(bexp-i)
        MOVE 0 TO mo-tic(bexp-i)
        MOVE 0 TO mo-frame(bexp-i)
        MOVE 0 TO mo-step(bexp-i)
    ELSE
        CALL "bit_or" USING BY VALUE mo-frame(bexp-i) BY VALUE 32768
            RETURNING mo-frame(bexp-i)
        *> A..C = 5 tics; D..E = 10 tics.
        IF mo-frame(bexp-i) >= 32771
            MOVE 10 TO mo-tic(bexp-i)
        ELSE
            MOVE 5 TO mo-tic(bexp-i)
        END-IF
    END-IF
    MOVE 1 TO moved-out
    .

corpse-next.
    IF mo-name(who-i) = "POSS" AND mo-hp(who-i) < -20
        PERFORM poss-gib
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO mo-step(who-i)
    COMPUTE slot = (mo-seq(who-i) - 1) * 8 + mo-step(who-i)
    IF mo-seq(who-i) < 1 OR mo-step(who-i) > die-len(mo-seq(who-i))
        OR slot < 1 OR slot > 40
        MOVE -1 TO mo-tic(who-i)
    ELSE
        MOVE die-fr(slot) TO mo-frame(who-i)
        MOVE die-tic(slot) TO mo-tic(who-i)
        *> DIE2 = A_Scream. A_Fall clears MF_SOLID:
        *> POSS/SPOS/SSWV step 3; TROO/SARG step 4.
        IF mo-step(who-i) = 2
            *> Vanilla runs A_Scream inside this mobj's thinker, after
            *> earlier mobjs have already consumed P_Random.
            MOVE 98 TO mo-react(who-i)
        END-IF
        *> Clear SOLID after this tic's player move (thinker is after P_XYMovement).
        IF mo-step(who-i) = 3
            AND (mo-name(who-i) = "POSS" OR mo-name(who-i) = "SPOS"
                OR mo-name(who-i) = "SSWV")
            MOVE 99 TO mo-react(who-i)
        END-IF
        IF mo-step(who-i) = 4
            AND (mo-name(who-i) = "TROO" OR mo-name(who-i) = "SARG")
            MOVE 99 TO mo-react(who-i)
        END-IF
    END-IF
    MOVE 1 TO moved-out
    .

poss-gib.
    ADD 1 TO mo-step(who-i)
    IF mo-step(who-i) > 9
        MOVE -1 TO mo-tic(who-i)
    ELSE
        COMPUTE mo-frame(who-i) = 11 + mo-step(who-i)
        IF mo-step(who-i) = 9
            MOVE -1 TO mo-tic(who-i)
        ELSE
            MOVE 5 TO mo-tic(who-i)
        END-IF
        IF mo-step(who-i) = 2
            MOVE 98 TO mo-react(who-i)
        END-IF
        IF mo-step(who-i) = 3
            MOVE 99 TO mo-react(who-i)
        END-IF
    END-IF
    MOVE 1 TO moved-out
    .

take-rnd.
    CALL "p-random" USING rnd-n
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
    EXIT PARAGRAPH
    .

END PROGRAM gun-tic.

IDENTIFICATION DIVISION.
PROGRAM-ID. alloc-mobj.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "sprstate.cpy".
01 i BINARY-LONG.

LINKAGE SECTION.
01 slot BINARY-LONG.

PROCEDURE DIVISION USING slot.
    *> Append until the table is full so thinker order stays put.
    *> After that, reuse an expired puff, blood, missile or picked-up item.
    IF n-mobj < 768
        ADD 1 TO n-mobj
        MOVE n-mobj TO slot
        GOBACK
    END-IF
    MOVE 0 TO slot
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > n-mobj OR slot > 0
        IF mo-name(i) = SPACES AND mo-kind(i) = 0
            MOVE 0 TO mo-flags(i)
            MOVE 0 TO mo-hp(i)
            MOVE 0 TO mo-mx(i)
            MOVE 0 TO mo-my(i)
            MOVE 0 TO mo-mz(i)
            MOVE 0 TO mo-ai(i)
            MOVE 0 TO mo-tgt(i)
            MOVE 0 TO mo-thrs(i)
            MOVE 0 TO mo-react(i)
            MOVE i TO slot
        END-IF
    END-PERFORM
    GOBACK.

END PROGRAM alloc-mobj.
