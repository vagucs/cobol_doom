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
*> Mapa a partir de world.py. Planta do episodio 1, mapa 1. Sem rato.
*> O numero da textura vem de rdata.cob.

IDENTIFICATION DIVISION.
PROGRAM-ID. map-load.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "mapstate.cpy".
01 lump-buf PIC X(65536).
01 cap-n BINARY-LONG VALUE 65536.
01 lump-id BINARY-LONG.
01 lump-delta BINARY-LONG.
01 lump-len BINARY-LONG.
01 map-id BINARY-LONG.
01 seek-name PIC X(8).
01 i BINARY-LONG.
01 slot BINARY-LONG.
01 at-pos BINARY-LONG.
01 raw-n BINARY-LONG.
01 byte-n BINARY-LONG.
01 k BINARY-LONG.
01 name-base BINARY-LONG.
01 name-out PIC X(8).
01 v1-id BINARY-LONG.
01 v2-id BINARY-LONG.
01 s0-id BINARY-LONG.
01 s1-id BINARY-LONG.
01 sec-slot BINARY-LONG.
01 side-slot BINARY-LONG.
01 line-slot BINARY-LONG.
01 seg-slot BINARY-LONG.
01 twoside BINARY-LONG.
01 side-n BINARY-LONG.
01 sd-id BINARY-LONG.
01 other-id BINARY-LONG.
01 reason PIC X(40).

LINKAGE SECTION.
01 name-out-lnk PIC X(8).
01 lines-out BINARY-LONG.
01 verts-out BINARY-LONG.
01 rc BINARY-LONG.

PROCEDURE DIVISION USING name-out-lnk lines-out verts-out rc.
    MOVE 0 TO n-vertex n-sector n-side n-line n-seg n-ssector n-node
    MOVE 0 TO n-thing n-block reject-n pool-n
    MOVE SPACES TO map-name
    MOVE -1 TO map-id
    IF name-out-lnk NOT = SPACES
        MOVE name-out-lnk TO seek-name
        CALL "wad-find" USING seek-name map-id
    END-IF
    IF map-id < 0
        MOVE "MAP01" TO seek-name
        CALL "wad-find" USING seek-name map-id
    END-IF
    IF map-id < 0
        MOVE "E1M1" TO seek-name
        CALL "wad-find" USING seek-name map-id
    END-IF
    IF map-id < 0
        MOVE 2 TO rc
        GOBACK
    END-IF
    MOVE seek-name TO map-name
    PERFORM load-vertexes
    PERFORM load-sectors
    PERFORM load-sides
    PERFORM load-lines
    PERFORM load-segs
    PERFORM load-ssectors
    PERFORM load-nodes
    PERFORM load-things
    PERFORM load-blockmap
    PERFORM load-reject
    PERFORM link-ssectors
    PERFORM bind-pics
    IF map-name = "E1M1"
        PERFORM prove-e1m1
    END-IF
    MOVE map-name TO name-out-lnk
    MOVE n-line TO lines-out
    MOVE n-vertex TO verts-out
    MOVE 0 TO rc
    GOBACK.

load-vertexes.
    MOVE 4 TO lump-delta
    PERFORM read-at
    COMPUTE n-vertex = lump-len / 4
    IF n-vertex > 1104
        MOVE "vertices demais" TO reason
        PERFORM fail-map
    END-IF
    PERFORM VARYING i FROM 0 BY 1 UNTIL i >= n-vertex
        COMPUTE slot = i + 1
        COMPUTE at-pos = i * 4
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING raw-n
        CALL "fixed_from_i16" USING BY VALUE raw-n RETURNING vtx-x(slot)
        COMPUTE at-pos = i * 4 + 2
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING raw-n
        CALL "fixed_from_i16" USING BY VALUE raw-n RETURNING vtx-y(slot)
    END-PERFORM
    .

load-sectors.
    MOVE 8 TO lump-delta
    PERFORM read-at
    COMPUTE n-sector = lump-len / 26
    IF n-sector > 256
        MOVE "setores demais" TO reason
        PERFORM fail-map
    END-IF
    PERFORM VARYING i FROM 0 BY 1 UNTIL i >= n-sector
        COMPUTE slot = i + 1
        COMPUTE at-pos = i * 26
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING raw-n
        CALL "fixed_from_i16" USING BY VALUE raw-n
            RETURNING sec-floor-h(slot)
        COMPUTE at-pos = i * 26 + 2
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING raw-n
        CALL "fixed_from_i16" USING BY VALUE raw-n
            RETURNING sec-ceil-h(slot)
        COMPUTE name-base = i * 26 + 4
        PERFORM copy-name
        MOVE name-out TO sec-fname(slot)
        COMPUTE name-base = i * 26 + 12
        PERFORM copy-name
        MOVE name-out TO sec-cname(slot)
        COMPUTE at-pos = i * 26 + 20
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING sec-flight(slot)
        COMPUTE at-pos = i * 26 + 22
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING sec-special(slot)
        COMPUTE at-pos = i * 26 + 24
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING sec-tag(slot)
        MOVE 0 TO sec-nlines(slot)
    END-PERFORM
    .

load-sides.
    MOVE 3 TO lump-delta
    PERFORM read-at
    COMPUTE n-side = lump-len / 30
    IF n-side > 2048
        MOVE "lados demais" TO reason
        PERFORM fail-map
    END-IF
    PERFORM VARYING i FROM 0 BY 1 UNTIL i >= n-side
        COMPUTE slot = i + 1
        COMPUTE at-pos = i * 30
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING raw-n
        CALL "fixed_from_i16" USING BY VALUE raw-n RETURNING sd-xoff(slot)
        COMPUTE at-pos = i * 30 + 2
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING raw-n
        CALL "fixed_from_i16" USING BY VALUE raw-n RETURNING sd-yoff(slot)
        COMPUTE name-base = i * 30 + 4
        PERFORM copy-name
        MOVE name-out TO sd-tname(slot)
        COMPUTE name-base = i * 30 + 12
        PERFORM copy-name
        MOVE name-out TO sd-bname(slot)
        COMPUTE name-base = i * 30 + 20
        PERFORM copy-name
        MOVE name-out TO sd-mname(slot)
        COMPUTE at-pos = i * 30 + 28
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING raw-n
        IF raw-n >= 0 AND raw-n < n-sector
            MOVE raw-n TO sd-sec(slot)
        ELSE
            MOVE 0 TO sd-sec(slot)
        END-IF
    END-PERFORM
    .

load-lines.
    MOVE 2 TO lump-delta
    PERFORM read-at
    COMPUTE n-line = lump-len / 14
    IF n-line > 1104
        MOVE "linhas demais" TO reason
        PERFORM fail-map
    END-IF
    MOVE 0 TO pool-n
    PERFORM VARYING i FROM 0 BY 1 UNTIL i >= n-line
        COMPUTE slot = i + 1
        COMPUTE at-pos = i * 14
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING v1-id
        COMPUTE at-pos = i * 14 + 2
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING v2-id
        COMPUTE ln-v1(slot) = v1-id + 1
        COMPUTE ln-v2(slot) = v2-id + 1
        CALL "sub_i32" USING BY VALUE vtx-x(ln-v2(slot))
            BY VALUE vtx-x(ln-v1(slot)) RETURNING ln-dx(slot)
        CALL "sub_i32" USING BY VALUE vtx-y(ln-v2(slot))
            BY VALUE vtx-y(ln-v1(slot)) RETURNING ln-dy(slot)
        COMPUTE at-pos = i * 14 + 4
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING ln-flags(slot)
        COMPUTE at-pos = i * 14 + 6
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING ln-spec(slot)
        COMPUTE at-pos = i * 14 + 8
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING ln-tag(slot)
        COMPUTE at-pos = i * 14 + 10
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING ln-s0(slot)
        COMPUTE at-pos = i * 14 + 12
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING ln-s1(slot)
        IF vtx-x(ln-v1(slot)) < vtx-x(ln-v2(slot))
            MOVE vtx-x(ln-v1(slot)) TO ln-bl(slot)
            MOVE vtx-x(ln-v2(slot)) TO ln-br(slot)
        ELSE
            MOVE vtx-x(ln-v2(slot)) TO ln-bl(slot)
            MOVE vtx-x(ln-v1(slot)) TO ln-br(slot)
        END-IF
        IF vtx-y(ln-v1(slot)) < vtx-y(ln-v2(slot))
            MOVE vtx-y(ln-v1(slot)) TO ln-bb(slot)
            MOVE vtx-y(ln-v2(slot)) TO ln-bt(slot)
        ELSE
            MOVE vtx-y(ln-v2(slot)) TO ln-bb(slot)
            MOVE vtx-y(ln-v1(slot)) TO ln-bt(slot)
        END-IF
        MOVE -1 TO ln-front(slot)
        MOVE -1 TO ln-back(slot)
        MOVE slot TO line-slot
        IF ln-s0(slot) >= 0 AND ln-s0(slot) < n-side
            COMPUTE side-slot = ln-s0(slot) + 1
            MOVE sd-sec(side-slot) TO ln-front(slot)
            COMPUTE sec-slot = sd-sec(side-slot) + 1
            PERFORM add-sec-line
        END-IF
        IF ln-s1(slot) >= 0 AND ln-s1(slot) < n-side
            COMPUTE side-slot = ln-s1(slot) + 1
            MOVE sd-sec(side-slot) TO ln-back(slot)
            IF sd-sec(side-slot) NOT = ln-front(slot)
                COMPUTE sec-slot = sd-sec(side-slot) + 1
                PERFORM add-sec-line
            END-IF
        END-IF
    END-PERFORM
    .

load-segs.
    MOVE 5 TO lump-delta
    PERFORM read-at
    COMPUTE n-seg = lump-len / 12
    IF n-seg > 2048
        MOVE "segs demais" TO reason
        PERFORM fail-map
    END-IF
    PERFORM VARYING i FROM 0 BY 1 UNTIL i >= n-seg
        COMPUTE slot = i + 1
        COMPUTE at-pos = i * 12
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING v1-id
        COMPUTE sg-v1(slot) = v1-id + 1
        COMPUTE at-pos = i * 12 + 2
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING v2-id
        COMPUTE sg-v2(slot) = v2-id + 1
        COMPUTE at-pos = i * 12 + 4
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING raw-n
        CALL "angle_from_i16" USING BY VALUE raw-n RETURNING sg-ang(slot)
        COMPUTE at-pos = i * 12 + 6
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING line-slot
        COMPUTE line-slot = line-slot + 1
        COMPUTE at-pos = i * 12 + 8
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING side-n
        COMPUTE at-pos = i * 12 + 10
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING raw-n
        CALL "fixed_from_i16" USING BY VALUE raw-n RETURNING sg-ofs(slot)
        IF side-n = 0
            MOVE ln-s0(line-slot) TO sd-id
        ELSE
            MOVE ln-s1(line-slot) TO sd-id
        END-IF
        IF sd-id < 0
            MOVE ln-s0(line-slot) TO sd-id
        END-IF
        MOVE -1 TO sg-front(slot)
        MOVE -1 TO sg-back(slot)
        IF sd-id >= 0 AND sd-id < n-side
            COMPUTE side-slot = sd-id + 1
            MOVE sd-sec(side-slot) TO sg-front(slot)
            COMPUTE sg-sd(slot) = sd-id + 1
        ELSE
            MOVE 0 TO sg-sd(slot)
        END-IF
        MOVE line-slot TO sg-line(slot)
        CALL "bit_and" USING BY VALUE ln-flags(line-slot) BY VALUE 4
            RETURNING twoside
        IF twoside NOT = 0
            CALL "bit_xor" USING BY VALUE side-n BY VALUE 1
                RETURNING other-id
            IF other-id = 0
                MOVE ln-s0(line-slot) TO sd-id
            ELSE
                MOVE ln-s1(line-slot) TO sd-id
            END-IF
            IF sd-id >= 0 AND sd-id < n-side
                COMPUTE side-slot = sd-id + 1
                MOVE sd-sec(side-slot) TO sg-back(slot)
            END-IF
        END-IF
    END-PERFORM
    .

load-ssectors.
    MOVE 6 TO lump-delta
    PERFORM read-at
    COMPUTE n-ssector = lump-len / 4
    IF n-ssector > 512
        MOVE "subsectors demais" TO reason
        PERFORM fail-map
    END-IF
    PERFORM VARYING i FROM 0 BY 1 UNTIL i >= n-ssector
        COMPUTE slot = i + 1
        COMPUTE at-pos = i * 4
        CALL "u16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING ss-n(slot)
        COMPUTE at-pos = i * 4 + 2
        CALL "u16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING ss-begin(slot)
        MOVE -1 TO ss-sec(slot)
    END-PERFORM
    .

load-nodes.
    MOVE 7 TO lump-delta
    PERFORM read-at
    COMPUTE n-node = lump-len / 28
    IF n-node > 512
        MOVE "nodes demais" TO reason
        PERFORM fail-map
    END-IF
    PERFORM VARYING i FROM 0 BY 1 UNTIL i >= n-node
        COMPUTE slot = i + 1
        COMPUTE at-pos = i * 28
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING raw-n
        CALL "fixed_from_i16" USING BY VALUE raw-n RETURNING nd-x(slot)
        COMPUTE at-pos = i * 28 + 2
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING raw-n
        CALL "fixed_from_i16" USING BY VALUE raw-n RETURNING nd-y(slot)
        COMPUTE at-pos = i * 28 + 4
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING raw-n
        CALL "fixed_from_i16" USING BY VALUE raw-n RETURNING nd-dx(slot)
        COMPUTE at-pos = i * 28 + 6
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING raw-n
        CALL "fixed_from_i16" USING BY VALUE raw-n RETURNING nd-dy(slot)
        COMPUTE at-pos = i * 28 + 8
        PERFORM node-box-0
        COMPUTE at-pos = i * 28 + 16
        PERFORM node-box-1
        COMPUTE at-pos = i * 28 + 24
        CALL "u16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING nd-c0(slot)
        COMPUTE at-pos = i * 28 + 26
        CALL "u16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING nd-c1(slot)
    END-PERFORM
    .

load-things.
    MOVE 1 TO lump-delta
    PERFORM read-at
    COMPUTE n-thing = lump-len / 10
    IF n-thing > 512
        MOVE "things demais" TO reason
        PERFORM fail-map
    END-IF
    PERFORM VARYING i FROM 0 BY 1 UNTIL i >= n-thing
        COMPUTE slot = i + 1
        COMPUTE at-pos = i * 10
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING th-x(slot)
        COMPUTE at-pos = i * 10 + 2
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING th-y(slot)
        COMPUTE at-pos = i * 10 + 4
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING th-ang(slot)
        COMPUTE at-pos = i * 10 + 6
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING th-kind(slot)
        COMPUTE at-pos = i * 10 + 8
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING th-opt(slot)
    END-PERFORM
    .

load-blockmap.
    MOVE 10 TO lump-delta
    PERFORM read-at
    COMPUTE n-block = lump-len / 2
    IF n-block > 12288
        MOVE "blockmap demais" TO reason
        PERFORM fail-map
    END-IF
    IF n-block < 4
        EXIT PARAGRAPH
    END-IF
    CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE 0 RETURNING raw-n
    CALL "fixed_from_i16" USING BY VALUE raw-n RETURNING blk-org-x
    CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE 2 RETURNING raw-n
    CALL "fixed_from_i16" USING BY VALUE raw-n RETURNING blk-org-y
    CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE 4 RETURNING blk-w
    CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE 6 RETURNING blk-h
    PERFORM VARYING i FROM 0 BY 1 UNTIL i >= n-block
        COMPUTE slot = i + 1
        COMPUTE at-pos = i * 2
        CALL "u16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING blk-raw(slot)
    END-PERFORM
    .

load-reject.
    MOVE 9 TO lump-delta
    PERFORM read-at
    IF lump-len > 8192
        MOVE "reject demais" TO reason
        PERFORM fail-map
    END-IF
    MOVE lump-len TO reject-n
    IF lump-len > 0
        CALL "mem_copy" USING BY REFERENCE reject-buf
            BY REFERENCE lump-buf BY VALUE lump-len
    END-IF
    .

link-ssectors.
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > n-ssector
        COMPUTE seg-slot = ss-begin(i) + 1
        IF seg-slot >= 1 AND seg-slot <= n-seg
            MOVE sg-front(seg-slot) TO ss-sec(i)
        END-IF
    END-PERFORM
    .

node-box-0.
    CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
        RETURNING raw-n
    CALL "fixed_from_i16" USING BY VALUE raw-n RETURNING nd-t0(slot)
    COMPUTE at-pos = at-pos + 2
    CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
        RETURNING raw-n
    CALL "fixed_from_i16" USING BY VALUE raw-n RETURNING nd-b0(slot)
    COMPUTE at-pos = at-pos + 2
    CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
        RETURNING raw-n
    CALL "fixed_from_i16" USING BY VALUE raw-n RETURNING nd-l0(slot)
    COMPUTE at-pos = at-pos + 2
    CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
        RETURNING raw-n
    CALL "fixed_from_i16" USING BY VALUE raw-n RETURNING nd-r0(slot)
    .

node-box-1.
    CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
        RETURNING raw-n
    CALL "fixed_from_i16" USING BY VALUE raw-n RETURNING nd-t1(slot)
    COMPUTE at-pos = at-pos + 2
    CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
        RETURNING raw-n
    CALL "fixed_from_i16" USING BY VALUE raw-n RETURNING nd-b1(slot)
    COMPUTE at-pos = at-pos + 2
    CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
        RETURNING raw-n
    CALL "fixed_from_i16" USING BY VALUE raw-n RETURNING nd-l1(slot)
    COMPUTE at-pos = at-pos + 2
    CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
        RETURNING raw-n
    CALL "fixed_from_i16" USING BY VALUE raw-n RETURNING nd-r1(slot)
    .

add-sec-line.
    IF sec-slot < 1 OR sec-slot > n-sector
        EXIT PARAGRAPH
    END-IF
    IF pool-n >= 2048
        MOVE "listas de setor demais" TO reason
        PERFORM fail-map
    END-IF
    ADD 1 TO pool-n
    MOVE line-slot TO pool-line(pool-n)
    ADD 1 TO sec-nlines(sec-slot)
    .

copy-name.
    MOVE SPACES TO name-out
    PERFORM VARYING k FROM 0 BY 1 UNTIL k >= 8
        COMPUTE at-pos = name-base + k
        CALL "byte_at" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING byte-n
        IF byte-n = 0
            EXIT PERFORM
        END-IF
        IF byte-n >= 97 AND byte-n <= 122
            SUBTRACT 32 FROM byte-n
        END-IF
        CALL "poke_byte" USING BY REFERENCE name-out BY VALUE k
            BY VALUE byte-n
    END-PERFORM
    .

read-at.
    COMPUTE lump-id = map-id + lump-delta
    CALL "wad-read-num" USING lump-id lump-buf cap-n lump-len
    IF lump-len < 0
        MOVE 3 TO rc
        GOBACK
    END-IF
    .

prove-e1m1.
    IF n-vertex NOT = 467 OR n-sector NOT = 85 OR n-side NOT = 648
        OR n-line NOT = 475 OR n-seg NOT = 732 OR n-ssector NOT = 237
        OR n-node NOT = 236 OR n-thing NOT = 138
        MOVE "contagem do E1M1" TO reason
        PERFORM fail-map
    END-IF
    IF vtx-x(1) NOT = 71303168 OR vtx-y(1) NOT = -241172480
        MOVE "vertice 0" TO reason
        PERFORM fail-map
    END-IF
    IF sec-floor-h(1) NOT = 0 OR sec-ceil-h(1) NOT = 4718592
        OR sec-flight(1) NOT = 160 OR sec-nlines(1) NOT = 4
        OR sec-fname(1) NOT = "FLOOR4_8"
        MOVE "setor 0" TO reason
        PERFORM fail-map
    END-IF
    IF ln-flags(1) NOT = 1 OR ln-dx(1) NOT = -4194304 OR ln-dy(1) NOT = 0
        OR ln-s0(1) NOT = 0 OR ln-s1(1) NOT = -1
        OR ln-bl(1) NOT = 67108864 OR ln-br(1) NOT = 71303168
        OR ln-bb(1) NOT = -241172480 OR ln-bt(1) NOT = -241172480
        OR ln-front(1) NOT = 40 OR ln-back(1) NOT = -1
        MOVE "linha 0" TO reason
        PERFORM fail-map
    END-IF
    IF sg-ang(1) NOT = 1073741824 OR sg-ofs(1) NOT = 0
        OR sg-front(1) NOT = 0 OR sg-back(1) NOT = 4
        MOVE "seg 0" TO reason
        PERFORM fail-map
    END-IF
    IF nd-x(1) NOT = 101711872 OR nd-y(1) NOT = -159383552
        OR nd-dx(1) NOT = 7340032 OR nd-dy(1) NOT = 0
        OR nd-c0(1) NOT = 32768 OR nd-c1(1) NOT = 32769
        OR nd-t0(1) NOT = -159383552 OR nd-b0(1) NOT = -167772160
        OR nd-l0(1) NOT = 101711872 OR nd-r0(1) NOT = 109051904
        MOVE "node 0" TO reason
        PERFORM fail-map
    END-IF
    IF th-x(1) NOT = 1056 OR th-y(1) NOT = -3616 OR th-ang(1) NOT = 90
        OR th-kind(1) NOT = 1 OR th-opt(1) NOT = 7
        MOVE "thing 0" TO reason
        PERFORM fail-map
    END-IF
    IF blk-org-x NOT = -50855936 OR blk-org-y NOT = -319291392
        OR blk-w NOT = 36 OR blk-h NOT = 23 OR n-block NOT = 3461
        OR blk-raw(5) NOT = 832
        MOVE "blockmap" TO reason
        PERFORM fail-map
    END-IF
    CALL "byte_at" USING BY REFERENCE reject-buf BY VALUE 0
        RETURNING byte-n
    IF reject-n NOT = 904 OR byte-n NOT = 32
        MOVE "reject" TO reason
        PERFORM fail-map
    END-IF
    IF ss-n(1) NOT = 4 OR ss-begin(1) NOT = 0 OR ss-sec(1) NOT = 0
        OR sd-sec(1) NOT = 40
        MOVE "subsector 0" TO reason
        PERFORM fail-map
    END-IF
    MOVE "DOOR3" TO seek-name
    CALL "tex-num" USING seek-name raw-n
    IF sec-floor-pic(1) NOT = 10 OR sec-ceil-pic(1) NOT = 32
        OR sd-mid(1) NOT = 30 OR raw-n NOT = 30
        MOVE "textura do E1M1" TO reason
        PERFORM fail-map
    END-IF
    .

bind-pics.
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > n-sector
        CALL "flat-num" USING sec-fname(i) sec-floor-pic(i)
        CALL "flat-num" USING sec-cname(i) sec-ceil-pic(i)
    END-PERFORM
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > n-side
        CALL "tex-num" USING sd-tname(i) sd-top(i)
        CALL "tex-num" USING sd-bname(i) sd-bot(i)
        CALL "tex-num" USING sd-mname(i) sd-mid(i)
    END-PERFORM
    .

fail-map.
    DISPLAY "mapa invalido: " reason
    MOVE 8 TO rc
    GOBACK
    .

END PROGRAM map-load.

IDENTIFICATION DIVISION.
PROGRAM-ID. map-draw.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "mapstate.cpy".
01 i BINARY-LONG.
01 have-box BINARY-LONG.
01 raw-n BINARY-LONG.
01 mx BINARY-LONG.
01 my BINARY-LONG.
01 min-x BINARY-LONG.
01 max-x BINARY-LONG.
01 min-y BINARY-LONG.
01 max-y BINARY-LONG.
01 x0 BINARY-LONG.
01 y0 BINARY-LONG.
01 x1 BINARY-LONG.
01 y1 BINARY-LONG.
01 sx0 BINARY-LONG.
01 sy0 BINARY-LONG.
01 sx1 BINARY-LONG.
01 sy1 BINARY-LONG.
01 sx-dot BINARY-LONG.
01 sy-dot BINARY-LONG.
01 wall-c BINARY-LONG.
01 open-c BINARY-LONG.
01 arrow-c BINARY-LONG.
01 pix-c BINARY-LONG.
01 p-slot BINARY-LONG.
01 found-p BINARY-LONG.
01 side-slot BINARY-LONG.
01 sec-slot BINARY-LONG.
01 tex-id BINARY-LONG.

LINKAGE SECTION.
01 fb PIC X(64000).
01 pal PIC X(16384).
01 ink BINARY-LONG.

PROCEDURE DIVISION USING fb pal ink.
    MOVE 0 TO ink
    MOVE ALL X"00" TO fb
    IF n-vertex < 1 OR n-line < 1
        GOBACK
    END-IF
    CALL "pick_map_colors" USING BY REFERENCE pal
        BY REFERENCE wall-c BY REFERENCE open-c BY REFERENCE arrow-c
    MOVE 0 TO have-box
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > n-vertex
        MOVE vtx-x(i) TO raw-n
        CALL "shar32" USING BY VALUE raw-n BY VALUE 16 RETURNING mx
        MOVE vtx-y(i) TO raw-n
        CALL "shar32" USING BY VALUE raw-n BY VALUE 16 RETURNING my
        IF have-box = 0
            MOVE mx TO min-x
            MOVE mx TO max-x
            MOVE my TO min-y
            MOVE my TO max-y
            MOVE 1 TO have-box
        ELSE
            IF mx < min-x
                MOVE mx TO min-x
            END-IF
            IF mx > max-x
                MOVE mx TO max-x
            END-IF
            IF my < min-y
                MOVE my TO min-y
            END-IF
            IF my > max-y
                MOVE my TO max-y
            END-IF
        END-IF
    END-PERFORM
    CALL "map_fit" USING BY VALUE min-x BY VALUE max-x
        BY VALUE min-y BY VALUE max-y
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > n-line
        MOVE vtx-x(ln-v1(i)) TO raw-n
        CALL "shar32" USING BY VALUE raw-n BY VALUE 16 RETURNING x0
        MOVE vtx-y(ln-v1(i)) TO raw-n
        CALL "shar32" USING BY VALUE raw-n BY VALUE 16 RETURNING y0
        MOVE vtx-x(ln-v2(i)) TO raw-n
        CALL "shar32" USING BY VALUE raw-n BY VALUE 16 RETURNING x1
        MOVE vtx-y(ln-v2(i)) TO raw-n
        CALL "shar32" USING BY VALUE raw-n BY VALUE 16 RETURNING y1
        CALL "map_to" USING BY VALUE x0 BY VALUE y0
            BY REFERENCE sx0 BY REFERENCE sy0
        CALL "map_to" USING BY VALUE x1 BY VALUE y1
            BY REFERENCE sx1 BY REFERENCE sy1
        MOVE 0 TO pix-c
        MOVE 0 TO tex-id
        IF ln-s0(i) >= 0
            COMPUTE side-slot = ln-s0(i) + 1
            MOVE sd-mid(side-slot) TO tex-id
            IF tex-id <= 0
                MOVE sd-top(side-slot) TO tex-id
            END-IF
            IF tex-id <= 0
                MOVE sd-bot(side-slot) TO tex-id
            END-IF
            IF tex-id > 0
                CALL "tex-swatch" USING tex-id pix-c
            ELSE
                IF ln-front(i) >= 0
                    COMPUTE sec-slot = ln-front(i) + 1
                    CALL "flat-swatch" USING sec-floor-pic(sec-slot) pix-c
                END-IF
            END-IF
        END-IF
        IF pix-c = 0
            IF ln-back(i) < 0
                MOVE wall-c TO pix-c
            ELSE
                MOVE open-c TO pix-c
            END-IF
        END-IF
        CALL "v-draw-line" USING fb sx0 sy0 sx1 sy1 pix-c ink
    END-PERFORM
    MOVE 0 TO found-p
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > n-thing OR found-p = 1
        IF th-kind(i) = 1
            MOVE i TO p-slot
            MOVE 1 TO found-p
        END-IF
    END-PERFORM
    IF found-p = 0 AND n-thing > 0
        MOVE 1 TO p-slot
        MOVE 1 TO found-p
    END-IF
    IF found-p = 1
        CALL "map_to" USING BY VALUE th-x(p-slot) BY VALUE th-y(p-slot)
            BY REFERENCE sx0 BY REFERENCE sy0
        CALL "map_arrow" USING BY VALUE th-x(p-slot) BY VALUE th-y(p-slot)
            BY VALUE th-ang(p-slot) BY REFERENCE sx1 BY REFERENCE sy1
        CALL "v-draw-line" USING fb sx0 sy0 sx1 sy1 arrow-c ink
        MOVE sx0 TO sx-dot
        MOVE sy0 TO sy-dot
        CALL "v-draw-line" USING fb sx-dot sy-dot sx0 sy0 arrow-c ink
    END-IF
    GOBACK.

END PROGRAM map-draw.
