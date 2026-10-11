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
IDENTIFICATION DIVISION.
PROGRAM-ID. door-act.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 door-ready BINARY-LONG VALUE 0.
01 dr-on BINARY-LONG OCCURS 32 TIMES.
01 dr-sec BINARY-LONG OCCURS 32 TIMES.
01 dr-type BINARY-LONG OCCURS 32 TIMES.
01 dr-dir BINARY-LONG OCCURS 32 TIMES.
01 dr-top BINARY-LONG OCCURS 32 TIMES.
01 dr-spd BINARY-LONG OCCURS 32 TIMES.
01 dr-wait BINARY-LONG OCCURS 32 TIMES.
01 sec-door BINARY-LONG OCCURS 256 TIMES.
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
01 fl-on BINARY-LONG OCCURS 4 TIMES.
01 fl-sec BINARY-LONG OCCURS 4 TIMES.
01 fl-dest BINARY-LONG OCCURS 4 TIMES.
01 fl-spd BINARY-LONG OCCURS 4 TIMES.
01 fl-i BINARY-LONG.
01 nb-h BINARY-LONG.
01 got-nb BINARY-LONG.
COPY "mapstate.cpy".
COPY "playstate.cpy".
COPY "sprstate.cpy".

LINKAGE SECTION.
01 act-mode BINARY-LONG.
01 busy-out BINARY-LONG.
01 moved-out BINARY-LONG.

PROCEDURE DIVISION USING act-mode busy-out moved-out.
main-door.
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
    PERFORM VARYING fl-i FROM 1 BY 1 UNTIL fl-i > 4
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
    PERFORM VARYING di FROM 33 BY 1 UNTIL di > 256
        MOVE 0 TO sec-door(di)
    END-PERFORM
    PERFORM VARYING fl-i FROM 1 BY 1 UNTIL fl-i > 4
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
    PERFORM VARYING li FROM 1 BY 1 UNTIL li > n-line
        IF ln-spec(li) = 36 AND ln-tag(li) NOT = 0
            CALL "trace_frac" USING
                BY VALUE ox BY VALUE oy BY VALUE tdx BY VALUE tdy
                BY VALUE vtx-x(ln-v1(li)) BY VALUE vtx-y(ln-v1(li))
                BY VALUE vtx-x(ln-v2(li)) BY VALUE vtx-y(ln-v2(li))
                RETURNING frac
            IF frac > 0 AND frac < 65536
                PERFORM start-lower
                MOVE 0 TO ln-spec(li)
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
    PERFORM VARYING fl-i FROM 1 BY 1 UNTIL fl-i > 4
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
    PERFORM VARYING step-n FROM 1 BY 1 UNTIL step-n > 4
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
    PERFORM VARYING fl-i FROM 1 BY 1 UNTIL fl-i > 4
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
    MOVE sec-floor-h(keep-sec) TO old-h
    CALL "sub_i32" USING BY VALUE old-h BY VALUE fl-spd(fl-i)
        RETURNING next-h
    IF next-h <= fl-dest(fl-i)
        MOVE fl-dest(fl-i) TO next-h
        MOVE 0 TO fl-on(fl-i)
    END-IF
    IF next-h = old-h
        EXIT PARAGRAPH
    END-IF
    MOVE next-h TO sec-floor-h(keep-sec)
    MOVE 1 TO moved-out
    PERFORM ride-floor
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
    IF spec-n = 26 OR spec-n = 32
        OR spec-n = 27 OR spec-n = 34
        OR spec-n = 28 OR spec-n = 33
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

spawn-door.
    IF sec-slot < 1 OR sec-slot > 256
        EXIT PARAGRAPH
    END-IF
    IF sec-door(sec-slot) NOT = 0
        MOVE sec-door(sec-slot) TO di
        IF dr-on(di) = 1 AND (dtype = 0 OR dtype = 5)
            IF dr-dir(di) = -1
                MOVE 1 TO dr-dir(di)
            ELSE
                MOVE -1 TO dr-dir(di)
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

drop-door.
    MOVE 0 TO dr-on(di)
    IF keep-sec >= 1 AND keep-sec <= 256
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
