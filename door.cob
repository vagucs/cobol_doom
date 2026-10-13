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
*> Portas verticais. Espaco ou E usa a linha a frente. O teto do setor anda.
*> A linha 36 abaixa o piso marcado ate o vizinho mais alto, e quem esta em cima desce junto.
*> O interruptor troca a textura. A saida recomeça o nível.
*> Elevador, escada, teleporte e porta com chave.
IDENTIFICATION DIVISION.
PROGRAM-ID. door-act.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 door-ready BINARY-LONG VALUE 0.
01 snd-name PIC X(6).
01 dr-on BINARY-LONG OCCURS 32 TIMES.
01 dr-sec BINARY-LONG OCCURS 32 TIMES.
01 dr-type BINARY-LONG OCCURS 32 TIMES.
01 dr-dir BINARY-LONG OCCURS 32 TIMES.
01 dr-top BINARY-LONG OCCURS 32 TIMES.
01 dr-spd BINARY-LONG OCCURS 32 TIMES.
01 dr-wait BINARY-LONG OCCURS 32 TIMES.
01 sec-door BINARY-LONG OCCURS 512 TIMES.
01 n-hit BINARY-LONG.
01 hit-ln BINARY-LONG OCCURS 64 TIMES.
01 hit-fr BINARY-LONG OCCURS 64 TIMES.
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
01 di BINARY-LONG.
01 step-n BINARY-LONG.
01 dx BINARY-LONG.
01 dy BINARY-LONG.
01 ldx BINARY-LONG.
01 ldy BINARY-LONG.
01 side-bit BINARY-LONG.
01 side-a BINARY-LONG.
01 left-v BINARY-LONG.
01 right-v BINARY-LONG.
01 v1-slot BINARY-LONG.
01 den BINARY-LONG.
01 numv BINARY-LONG.
01 frac BINARY-LONG.
01 sh1 BINARY-LONG.
01 sh2 BINARY-LONG.
01 m1 BINARY-LONG.
01 m2 BINARY-LONG.
01 solid-bit BINARY-LONG.
01 stop-scan BINARY-LONG.
01 spec-n BINARY-LONG.
01 dtype BINARY-LONG.
01 sec-slot BINARY-LONG.
01 sec-index BINARY-LONG.
01 nb BINARY-LONG.
01 low-h BINARY-LONG.
01 keep-sec BINARY-LONG.
01 old-h BINARY-LONG.
01 next-h BINARY-LONG.
01 dest-h BINARY-LONG.
01 past BINARY-LONG.
01 bad BINARY-LONG.
01 gap BINARY-LONG.
01 mi BINARY-LONG.
01 bit-n BINARY-LONG.
01 try-x BINARY-LONG.
01 try-y BINARY-LONG.
01 sub-slot BINARY-LONG.
01 sub-n BINARY-LONG.
01 bsp BINARY-LONG.
01 node-slot BINARY-LONG.
01 top-h BINARY-LONG.
01 bot-h BINARY-LONG.
01 fs BINARY-LONG.
01 bs BINARY-LONG.
01 tmp-n BINARY-LONG.
01 saw-on BINARY-LONG VALUE 0.
01 saw-x BINARY-LONG.
01 saw-y BINARY-LONG.
01 fl-on BINARY-LONG OCCURS 32 TIMES.
01 fl-sec BINARY-LONG OCCURS 32 TIMES.
01 fl-dest BINARY-LONG OCCURS 32 TIMES.
01 fl-spd BINARY-LONG OCCURS 32 TIMES.
01 fl-dir BINARY-LONG OCCURS 32 TIMES.
01 fl-wait BINARY-LONG OCCURS 32 TIMES.
01 fl-high BINARY-LONG OCCURS 32 TIMES.
01 fl-kind BINARY-LONG OCCURS 32 TIMES.
01 fl-i BINARY-LONG.
01 nb-h BINARY-LONG.
01 got-nb BINARY-LONG.
01 sw-on BINARY-LONG VALUE 0.
01 n-sw BINARY-LONG VALUE 0.
01 sw-a BINARY-LONG OCCURS 64 TIMES.
01 sw-b BINARY-LONG OCCURS 64 TIMES.
01 sw-buf PIC X(8192).
01 sw-len BINARY-LONG.
01 sw-at BINARY-LONG.
01 sw-cap BINARY-LONG.
01 name-a PIC X(8).
01 name-b PIC X(8).
01 id-a BINARY-LONG.
01 id-b BINARY-LONG.
01 sd-i BINARY-LONG.
01 tex-n BINARY-LONG.
01 swapped BINARY-LONG.
01 pair-i BINARY-LONG.
01 got-sw BINARY-LONG.
01 key-ok BINARY-LONG.
01 step-h BINARY-LONG.
01 spd-h BINARY-LONG.
01 pic-n BINARY-LONG.
01 cur-sec BINARY-LONG.
01 nxt-sec BINARY-LONG.
01 busy-sec BINARY-LONG.
01 tel-done BINARY-LONG.
01 walk-i BINARY-LONG.
01 lname PIC X(8).
01 lump-n BINARY-LONG.
01 byte-n BINARY-LONG.
01 name-at BINARY-LONG.
COPY "mapstate.cpy".
COPY "playstate.cpy".
COPY "sprstate.cpy".

LINKAGE SECTION.
01 act-mode BINARY-LONG.
01 busy-out BINARY-LONG.
01 moved-out BINARY-LONG.

PROCEDURE DIVISION USING act-mode busy-out moved-out.
main-door.
    IF act-mode = 9
        PERFORM init-doors
        MOVE 0 TO saw-on
        MOVE 0 TO busy-out
        MOVE 0 TO moved-out
        MOVE 1 TO door-ready
        GOBACK
    END-IF
    MOVE 0 TO moved-out
    IF door-ready = 0
        PERFORM init-doors
        MOVE 1 TO door-ready
    END-IF
    PERFORM scan-cross
    IF act-mode = 1
        PERFORM do-use
    END-IF
    PERFORM do-tick
    PERFORM move-floors
    MOVE 0 TO busy-out
    PERFORM VARYING di FROM 1 BY 1 UNTIL di > 32
        IF dr-on(di) = 1
            MOVE 1 TO busy-out
        END-IF
    END-PERFORM
    PERFORM VARYING fl-i FROM 1 BY 1 UNTIL fl-i > 32
        IF fl-on(fl-i) = 1
            MOVE 1 TO busy-out
        END-IF
    END-PERFORM
    GOBACK.

init-doors.
    PERFORM VARYING di FROM 1 BY 1 UNTIL di > 32
        MOVE 0 TO dr-on(di)
        MOVE 0 TO sec-door(di)
    END-PERFORM
    PERFORM VARYING di FROM 33 BY 1 UNTIL di > 512
        MOVE 0 TO sec-door(di)
    END-PERFORM
    PERFORM VARYING fl-i FROM 1 BY 1 UNTIL fl-i > 32
        MOVE 0 TO fl-on(fl-i)
    END-PERFORM
    .

scan-cross.
    IF ply-on = 0
        EXIT PARAGRAPH
    END-IF
    IF saw-on = 0
        MOVE ply-x TO saw-x
        MOVE ply-y TO saw-y
        MOVE 1 TO saw-on
        EXIT PARAGRAPH
    END-IF
    IF ply-x = saw-x AND ply-y = saw-y
        EXIT PARAGRAPH
    END-IF
    CALL "sub_i32" USING BY VALUE ply-x BY VALUE saw-x RETURNING tdx
    CALL "sub_i32" USING BY VALUE ply-y BY VALUE saw-y RETURNING tdy
    MOVE saw-x TO ox
    MOVE saw-y TO oy
    MOVE 0 TO tel-done
    PERFORM VARYING li FROM 1 BY 1 UNTIL li > n-line
        IF ln-spec(li) NOT = 0
            CALL "trace_frac" USING
                BY VALUE ox BY VALUE oy BY VALUE tdx BY VALUE tdy
                BY VALUE vtx-x(ln-v1(li)) BY VALUE vtx-y(ln-v1(li))
                BY VALUE vtx-x(ln-v2(li)) BY VALUE vtx-y(ln-v2(li))
                RETURNING frac
            IF frac > 0 AND frac < 65536
                PERFORM cross-hit
                IF tel-done = 1
                    EXIT PERFORM
                END-IF
            END-IF
        END-IF
    END-PERFORM
    MOVE ply-x TO saw-x
    MOVE ply-y TO saw-y
    .

start-lower.
    PERFORM VARYING sec-slot FROM 1 BY 1 UNTIL sec-slot > n-sector
        IF sec-tag(sec-slot) = ln-tag(li)
            PERFORM arm-floor
        END-IF
    END-PERFORM
    .

arm-floor.
    PERFORM VARYING fl-i FROM 1 BY 1 UNTIL fl-i > 32
        IF fl-on(fl-i) = 1 AND fl-sec(fl-i) = sec-slot
            EXIT PARAGRAPH
        END-IF
    END-PERFORM
    MOVE 0 TO got-nb
    MOVE -32768000 TO nb-h
    PERFORM VARYING step-n FROM 1 BY 1 UNTIL step-n > n-line
        COMPUTE fs = ln-front(step-n) + 1
        IF fs = sec-slot AND ln-back(step-n) >= 0
            COMPUTE bs = ln-back(step-n) + 1
            PERFORM note-neighbor
        END-IF
        COMPUTE bs = ln-back(step-n) + 1
        IF ln-back(step-n) >= 0 AND bs = sec-slot
            COMPUTE bs = ln-front(step-n) + 1
            PERFORM note-neighbor
        END-IF
    END-PERFORM
    IF got-nb = 0
        EXIT PARAGRAPH
    END-IF
    IF nb-h >= sec-floor-h(sec-slot)
        EXIT PARAGRAPH
    END-IF
    MOVE 0 TO fl-i
    PERFORM VARYING step-n FROM 1 BY 1 UNTIL step-n > 32
        IF fl-on(step-n) = 0
            MOVE step-n TO fl-i
            EXIT PERFORM
        END-IF
    END-PERFORM
    IF fl-i = 0
        EXIT PARAGRAPH
    END-IF
    MOVE 1 TO fl-on(fl-i)
    MOVE sec-slot TO fl-sec(fl-i)
    MOVE nb-h TO fl-dest(fl-i)
    MOVE 262144 TO fl-spd(fl-i)
    MOVE -1 TO fl-dir(fl-i)
    MOVE 0 TO fl-wait(fl-i)
    MOVE 0 TO fl-kind(fl-i)
    MOVE nb-h TO fl-high(fl-i)
    .

note-neighbor.
    IF bs < 1 OR bs > n-sector OR bs = sec-slot
        EXIT PARAGRAPH
    END-IF
    IF got-nb = 0 OR sec-floor-h(bs) > nb-h
        MOVE sec-floor-h(bs) TO nb-h
        MOVE 1 TO got-nb
    END-IF
    .

move-floors.
    PERFORM VARYING fl-i FROM 1 BY 1 UNTIL fl-i > 32
        IF fl-on(fl-i) = 1
            PERFORM drop-floor
        END-IF
    END-PERFORM
    .

drop-floor.
    MOVE fl-sec(fl-i) TO keep-sec
    IF keep-sec < 1 OR keep-sec > n-sector
        MOVE 0 TO fl-on(fl-i)
        EXIT PARAGRAPH
    END-IF
    IF fl-wait(fl-i) > 0
        SUBTRACT 1 FROM fl-wait(fl-i)
        IF fl-wait(fl-i) <= 0
            MOVE 1 TO fl-dir(fl-i)
            MOVE fl-high(fl-i) TO fl-dest(fl-i)
        END-IF
        EXIT PARAGRAPH
    END-IF
    MOVE sec-floor-h(keep-sec) TO old-h
    IF fl-dir(fl-i) < 0
        CALL "sub_i32" USING BY VALUE old-h BY VALUE fl-spd(fl-i)
            RETURNING next-h
        MOVE 0 TO past
        IF next-h <= fl-dest(fl-i)
            MOVE fl-dest(fl-i) TO next-h
            MOVE 1 TO past
        END-IF
    ELSE
        CALL "add_i32" USING BY VALUE old-h BY VALUE fl-spd(fl-i)
            RETURNING next-h
        MOVE 0 TO past
        IF next-h >= fl-dest(fl-i)
            MOVE fl-dest(fl-i) TO next-h
            MOVE 1 TO past
        END-IF
    END-IF
    IF next-h = old-h
        EXIT PARAGRAPH
    END-IF
    MOVE next-h TO sec-floor-h(keep-sec)
    MOVE 1 TO moved-out
    PERFORM ride-floor
    IF past = 0
        EXIT PARAGRAPH
    END-IF
    IF fl-kind(fl-i) = 1 AND fl-dir(fl-i) < 0
        MOVE 105 TO fl-wait(fl-i)
        MOVE 0 TO fl-dir(fl-i)
    ELSE
        MOVE 0 TO fl-on(fl-i)
    END-IF
    .

ride-floor.
    MOVE ply-x TO try-x
    MOVE ply-y TO try-y
    PERFORM sector-at
    IF sec-slot = keep-sec AND ply-z = old-h
        MOVE next-h TO ply-z
        MOVE next-h TO ply-floor
    END-IF
    PERFORM VARYING mi FROM 1 BY 1 UNTIL mi > n-mobj
        IF mo-z(mi) = old-h
            MOVE mo-x(mi) TO try-x
            MOVE mo-y(mi) TO try-y
            PERFORM sector-at
            IF sec-slot = keep-sec
                MOVE next-h TO mo-z(mi)
            END-IF
        END-IF
    END-PERFORM
    .

cross-hit.
    MOVE ln-spec(li) TO spec-n
    MOVE ox TO dx
    MOVE oy TO dy
    MOVE ln-v1(li) TO v1-slot
    MOVE ln-dx(li) TO ldx
    MOVE ln-dy(li) TO ldy
    PERFORM point-side
    IF spec-n = 36
        PERFORM start-lower
        MOVE 0 TO ln-spec(li)
    END-IF
    IF spec-n = 8 OR spec-n = 100
        MOVE 524288 TO step-h
        MOVE 16384 TO spd-h
        IF spec-n = 100
            MOVE 1048576 TO step-h
            MOVE 262144 TO spd-h
        END-IF
        PERFORM start-stair
        MOVE 0 TO ln-spec(li)
    END-IF
    IF spec-n = 10 OR spec-n = 88 OR spec-n = 121
        OR spec-n = 120
        MOVE 65536 TO spd-h
        IF spec-n = 121 OR spec-n = 120
            MOVE 524288 TO spd-h
        END-IF
        PERFORM start-plat
        IF spec-n = 10 OR spec-n = 121
            MOVE 0 TO ln-spec(li)
        END-IF
    END-IF
    IF spec-n = 39 OR spec-n = 97
        IF side-bit = 0
            PERFORM go-teleport
            IF spec-n = 39 AND tel-done = 1
                MOVE 0 TO ln-spec(li)
            END-IF
        END-IF
    END-IF
    .

need-key.
    MOVE 0 TO key-ok
    IF spec-n = 26 OR spec-n = 32
        IF ply-k0 = 1 OR ply-k3 = 1
            MOVE 1 TO key-ok
        END-IF
    END-IF
    IF spec-n = 27 OR spec-n = 34
        IF ply-k1 = 1 OR ply-k4 = 1
            MOVE 1 TO key-ok
        END-IF
    END-IF
    IF spec-n = 28 OR spec-n = 33
        IF ply-k2 = 1 OR ply-k5 = 1
            MOVE 1 TO key-ok
        END-IF
    END-IF
    .

start-stair.
    MOVE 0 TO got-sw
    IF ln-tag(li) = 0
        EXIT PARAGRAPH
    END-IF
    PERFORM VARYING sec-slot FROM 1 BY 1 UNTIL sec-slot > n-sector
        IF sec-tag(sec-slot) = ln-tag(li)
            PERFORM arm-stair
        END-IF
    END-PERFORM
    .

arm-stair.
    MOVE sec-slot TO cur-sec
    PERFORM sector-busy
    IF busy-sec = 1
        EXIT PARAGRAPH
    END-IF
    MOVE sec-floor-pic(cur-sec) TO pic-n
    CALL "add_i32" USING BY VALUE sec-floor-h(cur-sec)
        BY VALUE step-h RETURNING nb-h
    PERFORM claim-slot
    IF fl-i = 0
        EXIT PARAGRAPH
    END-IF
    MOVE 1 TO got-sw
    PERFORM fill-up
    PERFORM VARYING step-n FROM 1 BY 1 UNTIL step-n > 32
        PERFORM next-step
        IF nxt-sec = 0
            EXIT PERFORM
        END-IF
        MOVE nxt-sec TO cur-sec
        CALL "add_i32" USING BY VALUE sec-floor-h(cur-sec)
            BY VALUE step-h RETURNING nb-h
        PERFORM claim-slot
        IF fl-i = 0
            EXIT PERFORM
        END-IF
        PERFORM fill-up
    END-PERFORM
    IF got-sw = 1
        MOVE "stnmov" TO snd-name
        CALL "sfx-play" USING snd-name
    END-IF
    .

fill-up.
    MOVE 1 TO fl-on(fl-i)
    MOVE cur-sec TO fl-sec(fl-i)
    MOVE nb-h TO fl-dest(fl-i)
    MOVE spd-h TO fl-spd(fl-i)
    MOVE 1 TO fl-dir(fl-i)
    MOVE 0 TO fl-wait(fl-i)
    MOVE 2 TO fl-kind(fl-i)
    MOVE nb-h TO fl-high(fl-i)
    .

next-step.
    MOVE 0 TO nxt-sec
    PERFORM VARYING walk-i FROM 1 BY 1 UNTIL walk-i > n-line
        CALL "bit_and" USING BY VALUE ln-flags(walk-i) BY VALUE 4
            RETURNING bit-n
        IF bit-n NOT = 0 AND nxt-sec = 0
            COMPUTE fs = ln-front(walk-i) + 1
            IF fs = cur-sec AND ln-back(walk-i) >= 0
                COMPUTE bs = ln-back(walk-i) + 1
                PERFORM take-step
            END-IF
            COMPUTE bs = ln-back(walk-i) + 1
            IF nxt-sec = 0 AND ln-back(walk-i) >= 0
                AND bs = cur-sec AND ln-front(walk-i) >= 0
                COMPUTE bs = ln-front(walk-i) + 1
                PERFORM take-step
            END-IF
        END-IF
    END-PERFORM
    .

take-step.
    IF bs < 1 OR bs > n-sector OR bs = cur-sec
        EXIT PARAGRAPH
    END-IF
    IF sec-floor-pic(bs) NOT = pic-n
        EXIT PARAGRAPH
    END-IF
    MOVE cur-sec TO tmp-n
    MOVE bs TO cur-sec
    PERFORM sector-busy
    MOVE tmp-n TO cur-sec
    IF busy-sec = 0
        MOVE bs TO nxt-sec
    END-IF
    .

start-plat.
    MOVE 0 TO got-sw
    IF ln-tag(li) = 0
        EXIT PARAGRAPH
    END-IF
    PERFORM VARYING sec-slot FROM 1 BY 1 UNTIL sec-slot > n-sector
        IF sec-tag(sec-slot) = ln-tag(li)
            PERFORM arm-plat
        END-IF
    END-PERFORM
    IF got-sw = 1
        MOVE "stnmov" TO snd-name
        CALL "sfx-play" USING snd-name
    END-IF
    .

arm-plat.
    MOVE sec-slot TO cur-sec
    PERFORM sector-busy
    IF busy-sec = 1
        EXIT PARAGRAPH
    END-IF
    PERFORM low-floor
    IF got-nb = 0 OR nb-h >= sec-floor-h(cur-sec)
        CALL "sub_i32" USING BY VALUE sec-floor-h(cur-sec)
            BY VALUE 524288 RETURNING nb-h
    END-IF
    MOVE sec-floor-h(cur-sec) TO tmp-n
    PERFORM claim-slot
    IF fl-i = 0
        EXIT PARAGRAPH
    END-IF
    MOVE 1 TO got-sw
    MOVE 1 TO fl-on(fl-i)
    MOVE cur-sec TO fl-sec(fl-i)
    MOVE nb-h TO fl-dest(fl-i)
    MOVE spd-h TO fl-spd(fl-i)
    MOVE -1 TO fl-dir(fl-i)
    MOVE 0 TO fl-wait(fl-i)
    MOVE 1 TO fl-kind(fl-i)
    MOVE tmp-n TO fl-high(fl-i)
    .

low-floor.
    MOVE 0 TO got-nb
    MOVE 2147483647 TO nb-h
    PERFORM VARYING walk-i FROM 1 BY 1 UNTIL walk-i > n-line
        COMPUTE fs = ln-front(walk-i) + 1
        IF fs = cur-sec AND ln-back(walk-i) >= 0
            COMPUTE bs = ln-back(walk-i) + 1
            IF bs >= 1 AND bs <= n-sector
                AND sec-floor-h(bs) < nb-h
                MOVE sec-floor-h(bs) TO nb-h
                MOVE 1 TO got-nb
            END-IF
        END-IF
        IF ln-back(walk-i) >= 0
            COMPUTE fs = ln-back(walk-i) + 1
            IF fs = cur-sec AND ln-front(walk-i) >= 0
                COMPUTE bs = ln-front(walk-i) + 1
                IF bs >= 1 AND bs <= n-sector
                    AND sec-floor-h(bs) < nb-h
                    MOVE sec-floor-h(bs) TO nb-h
                    MOVE 1 TO got-nb
                END-IF
            END-IF
        END-IF
    END-PERFORM
    .

sector-busy.
    MOVE 0 TO busy-sec
    PERFORM VARYING hj FROM 1 BY 1 UNTIL hj > 32
        IF fl-on(hj) = 1 AND fl-sec(hj) = cur-sec
            MOVE 1 TO busy-sec
        END-IF
    END-PERFORM
    .

claim-slot.
    MOVE 0 TO fl-i
    PERFORM VARYING hj FROM 1 BY 1 UNTIL hj > 32
        IF fl-on(hj) = 0
            MOVE hj TO fl-i
            EXIT PERFORM
        END-IF
    END-PERFORM
    .

go-teleport.
    IF ln-tag(li) = 0
        EXIT PARAGRAPH
    END-IF
    PERFORM VARYING mi FROM 1 BY 1 UNTIL mi > n-thing
        IF th-kind(mi) = 14 AND tel-done = 0
            CALL "fixed_from_i16" USING BY VALUE th-x(mi)
                RETURNING try-x
            CALL "fixed_from_i16" USING BY VALUE th-y(mi)
                RETURNING try-y
            PERFORM sector-at
            IF sec-slot >= 1 AND sec-slot <= n-sector
                AND sec-tag(sec-slot) = ln-tag(li)
                MOVE try-x TO ply-x
                MOVE try-y TO ply-y
                CALL "angle_from_deg" USING BY VALUE th-ang(mi)
                    RETURNING ply-ang
                MOVE 0 TO ply-momx
                MOVE 0 TO ply-momy
                MOVE 0 TO ply-momz
                MOVE sec-floor-h(sec-slot) TO ply-floor
                MOVE sec-floor-h(sec-slot) TO ply-z
                MOVE sec-ceil-h(sec-slot) TO ply-ceil
                MOVE sec-slot TO ply-room
                MOVE 1 TO tel-done
                MOVE "telept" TO snd-name
                CALL "sfx-play" USING snd-name
                MOVE 1 TO moved-out
            END-IF
        END-IF
    END-PERFORM
    .

do-use.
    IF ply-on = 0
        EXIT PARAGRAPH
    END-IF
    CALL "fine_cos_ang" USING BY VALUE ply-ang RETURNING cs
    CALL "fine_sin_ang" USING BY VALUE ply-ang RETURNING sn
    CALL "mul_i32" USING BY VALUE cs BY VALUE 64 RETURNING tdx
    CALL "mul_i32" USING BY VALUE sn BY VALUE 64 RETURNING tdy
    MOVE ply-x TO ox
    MOVE ply-y TO oy
    MOVE 0 TO n-hit
    PERFORM VARYING li FROM 1 BY 1 UNTIL li > n-line
        PERFORM consider-line
    END-PERFORM
    IF n-hit < 2
        PERFORM act-hits
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
            MOVE hit-fr(hi) TO tmp-n
            MOVE hit-fr(best) TO hit-fr(hi)
            MOVE tmp-n TO hit-fr(best)
            MOVE hit-ln(hi) TO tmp-n
            MOVE hit-ln(best) TO hit-ln(hi)
            MOVE tmp-n TO hit-ln(best)
        END-IF
    END-PERFORM
    PERFORM act-hits
    .

consider-line.
    IF n-hit >= 64
        EXIT PARAGRAPH
    END-IF
    MOVE vtx-x(ln-v1(li)) TO dx
    MOVE vtx-y(ln-v1(li)) TO dy
    PERFORM trace-side
    MOVE side-bit TO side-a
    MOVE vtx-x(ln-v2(li)) TO dx
    MOVE vtx-y(ln-v2(li)) TO dy
    PERFORM trace-side
    IF side-bit = side-a
        EXIT PARAGRAPH
    END-IF
    CALL "shar32" USING BY VALUE ln-dy(li) BY VALUE 8 RETURNING sh1
    CALL "fixed_mul" USING BY VALUE sh1 BY VALUE tdx RETURNING m1
    CALL "shar32" USING BY VALUE ln-dx(li) BY VALUE 8 RETURNING sh2
    CALL "fixed_mul" USING BY VALUE sh2 BY VALUE tdy RETURNING m2
    CALL "sub_i32" USING BY VALUE m1 BY VALUE m2 RETURNING den
    IF den = 0
        EXIT PARAGRAPH
    END-IF
    CALL "sub_i32" USING BY VALUE vtx-x(ln-v1(li)) BY VALUE ox
        RETURNING dx
    CALL "shar32" USING BY VALUE dx BY VALUE 8 RETURNING sh1
    CALL "fixed_mul" USING BY VALUE sh1 BY VALUE ln-dy(li) RETURNING m1
    CALL "sub_i32" USING BY VALUE oy BY VALUE vtx-y(ln-v1(li))
        RETURNING dy
    CALL "shar32" USING BY VALUE dy BY VALUE 8 RETURNING sh2
    CALL "fixed_mul" USING BY VALUE sh2 BY VALUE ln-dx(li) RETURNING m2
    CALL "add_i32" USING BY VALUE m1 BY VALUE m2 RETURNING numv
    CALL "fixed_div" USING BY VALUE numv BY VALUE den RETURNING frac
    IF frac < 0 OR frac > 65536
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO n-hit
    MOVE li TO hit-ln(n-hit)
    MOVE frac TO hit-fr(n-hit)
    .

act-hits.
    MOVE 0 TO stop-scan
    PERFORM VARYING hi FROM 1 BY 1 UNTIL hi > n-hit OR stop-scan = 1
        MOVE hit-ln(hi) TO li
        IF ln-spec(li) NOT = 0
            MOVE ply-x TO dx
            MOVE ply-y TO dy
            MOVE ln-v1(li) TO v1-slot
            MOVE ln-dx(li) TO ldx
            MOVE ln-dy(li) TO ldy
            PERFORM point-side
            IF side-bit = 0
                PERFORM try-spec
            END-IF
            MOVE 1 TO stop-scan
        ELSE
            PERFORM solid-line
            IF solid-bit = 1
                MOVE 1 TO stop-scan
            END-IF
        END-IF
    END-PERFORM
    .

try-spec.
    MOVE ln-spec(li) TO spec-n
    IF spec-n = 11 OR spec-n = 51
        PERFORM flip-switch
        MOVE 0 TO ln-spec(li)
        IF spec-n = 51
            MOVE 1 TO ply-secret
        ELSE
            MOVE 0 TO ply-secret
        END-IF
        MOVE 35 TO ply-exit
        MOVE 1 TO moved-out
        EXIT PARAGRAPH
    END-IF
    IF spec-n = 29 OR spec-n = 63 OR spec-n = 61 OR spec-n = 103
        OR spec-n = 111 OR spec-n = 112 OR spec-n = 114
        OR spec-n = 115
        PERFORM tag-doors
        EXIT PARAGRAPH
    END-IF
    IF spec-n = 26 OR spec-n = 32
        OR spec-n = 27 OR spec-n = 34
        OR spec-n = 28 OR spec-n = 33
        PERFORM need-key
        IF key-ok = 0
            MOVE "oof" TO snd-name
            CALL "sfx-play" USING snd-name
            EXIT PARAGRAPH
        END-IF
        MOVE 0 TO dtype
        IF spec-n = 32 OR spec-n = 33 OR spec-n = 34
            MOVE 3 TO dtype
            MOVE 0 TO ln-spec(li)
        END-IF
        IF ln-back(li) < 0
            EXIT PARAGRAPH
        END-IF
        COMPUTE sec-slot = ln-back(li) + 1
        PERFORM spawn-door
        EXIT PARAGRAPH
    END-IF
    IF spec-n = 7 OR spec-n = 127
        MOVE 524288 TO step-h
        MOVE 16384 TO spd-h
        IF spec-n = 127
            MOVE 1048576 TO step-h
            MOVE 262144 TO spd-h
        END-IF
        PERFORM start-stair
        IF got-sw = 1
            PERFORM flip-switch
            MOVE 0 TO ln-spec(li)
            MOVE 1 TO moved-out
        END-IF
        EXIT PARAGRAPH
    END-IF
    IF spec-n = 21 OR spec-n = 62 OR spec-n = 120
        OR spec-n = 122
        MOVE 65536 TO spd-h
        IF spec-n = 120 OR spec-n = 122
            MOVE 524288 TO spd-h
        END-IF
        PERFORM start-plat
        IF got-sw = 1
            PERFORM flip-switch
            IF spec-n = 21 OR spec-n = 122
                MOVE 0 TO ln-spec(li)
            END-IF
            MOVE 1 TO moved-out
        END-IF
        EXIT PARAGRAPH
    END-IF
    IF spec-n = 1
        MOVE 0 TO dtype
    ELSE
        IF spec-n = 117
            MOVE 5 TO dtype
        ELSE
            IF spec-n = 118
                MOVE 6 TO dtype
                MOVE 0 TO ln-spec(li)
            ELSE
                IF spec-n = 31 OR spec-n = 32
                    OR spec-n = 33 OR spec-n = 34
                    MOVE 3 TO dtype
                    MOVE 0 TO ln-spec(li)
                ELSE
                    EXIT PARAGRAPH
                END-IF
            END-IF
        END-IF
    END-IF
    IF ln-back(li) < 0
        EXIT PARAGRAPH
    END-IF
    COMPUTE sec-slot = ln-back(li) + 1
    PERFORM spawn-door
    .

door-open-snd.
    IF dr-type(di) >= 5
        MOVE "bdopn" TO snd-name
    ELSE
        MOVE "doropn" TO snd-name
    END-IF
    CALL "sfx-play" USING snd-name
    .

door-shut-snd.
    IF dr-type(di) >= 5
        MOVE "bdcls" TO snd-name
    ELSE
        MOVE "dorcls" TO snd-name
    END-IF
    CALL "sfx-play" USING snd-name
    .

spawn-door.
    IF sec-slot < 1 OR sec-slot > 512
        EXIT PARAGRAPH
    END-IF
    IF sec-door(sec-slot) NOT = 0
        MOVE sec-door(sec-slot) TO di
        IF dr-on(di) = 1 AND (dtype = 0 OR dtype = 5)
            IF dr-dir(di) = -1
                MOVE 1 TO dr-dir(di)
                PERFORM door-open-snd
            ELSE
                MOVE -1 TO dr-dir(di)
                PERFORM door-shut-snd
            END-IF
        END-IF
        EXIT PARAGRAPH
    END-IF
    MOVE 0 TO di
    PERFORM VARYING step-n FROM 1 BY 1 UNTIL step-n > 32
        IF dr-on(step-n) = 0
            MOVE step-n TO di
            EXIT PERFORM
        END-IF
    END-PERFORM
    IF di = 0
        EXIT PARAGRAPH
    END-IF
    COMPUTE sec-index = sec-slot - 1
    MOVE 2147483647 TO low-h
    PERFORM VARYING step-n FROM 1 BY 1 UNTIL step-n > n-line
        IF ln-front(step-n) = sec-index AND ln-back(step-n) >= 0
            AND ln-back(step-n) NOT = sec-index
            COMPUTE nb = ln-back(step-n) + 1
            IF sec-ceil-h(nb) < low-h
                MOVE sec-ceil-h(nb) TO low-h
            END-IF
        END-IF
        IF ln-back(step-n) = sec-index AND ln-front(step-n) >= 0
            AND ln-front(step-n) NOT = sec-index
            COMPUTE nb = ln-front(step-n) + 1
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
    PERFORM door-open-snd
    .

do-tick.
    PERFORM VARYING di FROM 1 BY 1 UNTIL di > 32
        IF dr-on(di) = 1
            PERFORM tick-one
        END-IF
    END-PERFORM
    .

tick-one.
    MOVE dr-sec(di) TO keep-sec
    IF keep-sec < 1 OR keep-sec > n-sector
        MOVE 0 TO dr-on(di)
        EXIT PARAGRAPH
    END-IF
    IF dr-dir(di) = 0
        SUBTRACT 1 FROM dr-wait(di)
        IF dr-wait(di) <= 0
            IF dr-type(di) = 0 OR dr-type(di) = 5 OR dr-type(di) = 2
                MOVE -1 TO dr-dir(di)
                PERFORM door-shut-snd
            END-IF
        END-IF
        EXIT PARAGRAPH
    END-IF
    MOVE sec-ceil-h(keep-sec) TO old-h
    MOVE 0 TO past
    IF dr-dir(di) = 1
        MOVE dr-top(di) TO dest-h
        CALL "add_i32" USING BY VALUE old-h BY VALUE dr-spd(di)
            RETURNING next-h
        IF next-h > dest-h
            MOVE dest-h TO next-h
            MOVE 1 TO past
        END-IF
    ELSE
        MOVE sec-floor-h(keep-sec) TO dest-h
        CALL "sub_i32" USING BY VALUE old-h BY VALUE dr-spd(di)
            RETURNING next-h
        IF next-h < dest-h
            MOVE dest-h TO next-h
            MOVE 1 TO past
        END-IF
    END-IF
    MOVE next-h TO sec-ceil-h(keep-sec)
    IF dr-dir(di) = -1
        PERFORM ceiling-fits
        IF bad = 1
            MOVE old-h TO sec-ceil-h(keep-sec)
            MOVE 0 TO past
        ELSE
            MOVE 1 TO moved-out
        END-IF
    ELSE
        MOVE 1 TO moved-out
    END-IF
    IF past = 0
        EXIT PARAGRAPH
    END-IF
    IF dr-dir(di) = 1
        IF dr-type(di) = 0 OR dr-type(di) = 5
            MOVE 0 TO dr-dir(di)
            MOVE 150 TO dr-wait(di)
        ELSE
            PERFORM drop-door
        END-IF
    ELSE
        PERFORM drop-door
    END-IF
    .

tag-doors.
    MOVE 0 TO dtype
    IF spec-n = 61 OR spec-n = 103
        MOVE 3 TO dtype
    END-IF
    IF spec-n = 111 OR spec-n = 114
        MOVE 5 TO dtype
    END-IF
    IF spec-n = 112 OR spec-n = 115
        MOVE 6 TO dtype
    END-IF
    MOVE 0 TO got-sw
    IF ln-tag(li) = 0
        EXIT PARAGRAPH
    END-IF
    PERFORM VARYING sec-slot FROM 1 BY 1 UNTIL sec-slot > n-sector
        IF sec-tag(sec-slot) = ln-tag(li)
            PERFORM spawn-door
            MOVE 1 TO got-sw
        END-IF
    END-PERFORM
    IF got-sw = 0
        EXIT PARAGRAPH
    END-IF
    PERFORM flip-switch
    MOVE 1 TO moved-out
    IF spec-n = 29 OR spec-n = 103 OR spec-n = 111 OR spec-n = 112
        MOVE 0 TO ln-spec(li)
    END-IF
    .

flip-switch.
    IF sw-on = 0
        PERFORM load-switches
    END-IF
    IF n-sw = 0
        EXIT PARAGRAPH
    END-IF
    IF ln-s0(li) < 0
        EXIT PARAGRAPH
    END-IF
    COMPUTE sd-i = ln-s0(li) + 1
    IF sd-i < 1 OR sd-i > n-side
        EXIT PARAGRAPH
    END-IF
    MOVE 0 TO swapped
    MOVE 1 TO tmp-n
    MOVE sd-top(sd-i) TO tex-n
    PERFORM swap-tex
    IF swapped = 0
        MOVE 2 TO tmp-n
        MOVE sd-mid(sd-i) TO tex-n
        PERFORM swap-tex
    END-IF
    IF swapped = 0
        MOVE 3 TO tmp-n
        MOVE sd-bot(sd-i) TO tex-n
        PERFORM swap-tex
    END-IF
    IF swapped = 0
        EXIT PARAGRAPH
    END-IF
    IF tmp-n = 1
        MOVE tex-n TO sd-top(sd-i)
    END-IF
    IF tmp-n = 2
        MOVE tex-n TO sd-mid(sd-i)
    END-IF
    IF tmp-n = 3
        MOVE tex-n TO sd-bot(sd-i)
    END-IF
    MOVE "swtchn" TO snd-name
    CALL "sfx-play" USING snd-name
    .

swap-tex.
    PERFORM VARYING pair-i FROM 1 BY 1 UNTIL pair-i > n-sw
        OR swapped = 1
        IF tex-n = sw-a(pair-i) AND sw-b(pair-i) > 0
            MOVE sw-b(pair-i) TO tex-n
            MOVE 1 TO swapped
        ELSE
            IF tex-n = sw-b(pair-i) AND sw-a(pair-i) > 0
                MOVE sw-a(pair-i) TO tex-n
                MOVE 1 TO swapped
            END-IF
        END-IF
    END-PERFORM
    .

load-switches.
    MOVE 1 TO sw-on
    MOVE 0 TO n-sw
    MOVE "SWITCHES" TO lname
    CALL "wad-find" USING lname lump-n
    IF lump-n < 0
        EXIT PARAGRAPH
    END-IF
    MOVE 8192 TO sw-cap
    CALL "wad-read-num" USING lump-n sw-buf sw-cap sw-len
    IF sw-len < 20
        EXIT PARAGRAPH
    END-IF
    MOVE 0 TO sw-at
    PERFORM UNTIL sw-at + 20 > sw-len OR n-sw >= 64
        CALL "byte_at" USING BY REFERENCE sw-buf BY VALUE sw-at
            RETURNING byte-n
        IF byte-n = 0
            EXIT PERFORM
        END-IF
        COMPUTE name-at = sw-at + 1
        MOVE sw-buf(name-at:8) TO name-a
        COMPUTE name-at = sw-at + 10
        MOVE sw-buf(name-at:8) TO name-b
        INSPECT name-a REPLACING ALL X"00" BY " "
        INSPECT name-b REPLACING ALL X"00" BY " "
        CALL "tex-num" USING name-a id-a
        CALL "tex-num" USING name-b id-b
        IF id-a > 0 AND id-b > 0
            ADD 1 TO n-sw
            MOVE id-a TO sw-a(n-sw)
            MOVE id-b TO sw-b(n-sw)
        END-IF
        ADD 20 TO sw-at
    END-PERFORM
    .

drop-door.
    MOVE 0 TO dr-on(di)
    IF keep-sec >= 1 AND keep-sec <= 512
        MOVE 0 TO sec-door(keep-sec)
    END-IF
    .

ceiling-fits.
    MOVE 0 TO bad
    MOVE ply-x TO try-x
    MOVE ply-y TO try-y
    PERFORM sector-at
    IF sec-slot = keep-sec
        CALL "sub_i32" USING BY VALUE next-h BY VALUE ply-z RETURNING gap
        IF gap < ply-h
            MOVE 1 TO bad
        END-IF
    END-IF
    .

solid-line.
    MOVE 0 TO solid-bit
    IF ln-back(li) < 0
        MOVE 1 TO solid-bit
        EXIT PARAGRAPH
    END-IF
    COMPUTE fs = ln-front(li) + 1
    COMPUTE bs = ln-back(li) + 1
    IF fs < 1 OR bs < 1 OR fs > n-sector OR bs > n-sector
        MOVE 1 TO solid-bit
        EXIT PARAGRAPH
    END-IF
    IF sec-ceil-h(fs) < sec-ceil-h(bs)
        MOVE sec-ceil-h(fs) TO top-h
    ELSE
        MOVE sec-ceil-h(bs) TO top-h
    END-IF
    IF sec-floor-h(fs) > sec-floor-h(bs)
        MOVE sec-floor-h(fs) TO bot-h
    ELSE
        MOVE sec-floor-h(bs) TO bot-h
    END-IF
    IF bot-h >= top-h
        MOVE 1 TO solid-bit
    END-IF
    .

trace-side.
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

END PROGRAM door-act.
