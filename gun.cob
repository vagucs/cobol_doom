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
*> Pistola. Ctrl dispara, o tiro acerta e quem morre cai. Sem rato.
IDENTIFICATION DIVISION.
PROGRAM-ID. gun-tic.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 die-on BINARY-LONG VALUE 0.
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
01 win-top BINARY-LONG.
01 win-bot BINARY-LONG.
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
01 rem-n BINARY-LONG.
01 q-n BINARY-LONG.
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
    MOVE 0 TO busy-out
    IF gun-mode = 1 OR gun-flash-n > 0
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
        EXIT PARAGRAPH
    END-IF
    IF fire-held = 1 AND ply-ammo >= 1 AND ply-on = 1
        MOVE 1 TO gun-mode
        MOVE 0 TO gun-step
        MOVE 1 TO gun-down
        PERFORM enter-step
        EXIT PARAGRAPH
    END-IF
    IF fire-held = 0
        MOVE 0 TO gun-down
        MOVE 0 TO gun-refire
    END-IF
    .

enter-step.
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
    MOVE "PISGA0" TO gun-body
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

fire-ray.
    CALL "fine_cos_ang" USING BY VALUE shot-ang RETURNING cs
    CALL "fine_sin_ang" USING BY VALUE shot-ang RETURNING sn
    MOVE 2048 TO range-u
    MOVE 134217728 TO range-fu
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
        MOVE 40960 TO win-top
        MOVE -40960 TO win-bot
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
        MOVE 1 TO stop-scan
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
    IF n-mobj >= 256
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
        EXIT PARAGRAPH
    END-IF
    PERFORM take-rnd
    IF rnd-n >= 200
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

start-death.
    CALL "bit_and" USING BY VALUE mo-flags(who-i) BY VALUE -7
        RETURNING tmp
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
