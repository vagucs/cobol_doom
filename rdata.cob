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
*> Texturas, flats e colormap, como doom/r_data.py. Sem sprites e sem rato.

IDENTIFICATION DIVISION.
PROGRAM-ID. rdata-init.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "rdata.cpy".
01 lump-buf PIC X(65536).
01 patch-buf PIC X(65536).
01 comp-buf PIC X(32768).
01 col-out PIC X(128).
01 cap-n BINARY-LONG VALUE 65536.
01 lump-id BINARY-LONG.
01 lump-len BINARY-LONG.
01 patch-len BINARY-LONG.
01 seek-name PIC X(8).
01 name-out PIC X(8).
01 name-base BINARY-LONG.
01 reason PIC X(40).
01 i BINARY-LONG.
01 slot BINARY-LONG.
01 at-pos BINARY-LONG.
01 raw-n BINARY-LONG.
01 byte-n BINARY-LONG.
01 k BINARY-LONG.
01 num-in-lump BINARY-LONG.
01 tex-ofs BINARY-LONG.
01 patch-n BINARY-LONG.
01 p-i BINARY-LONG.
01 pidx BINARY-LONG.
01 j BINARY-LONG.
01 x-i BINARY-LONG.
01 tex-slot BINARY-LONG.
01 pool BINARY-LONG.
01 col-i BINARY-LONG.
01 masked BINARY-LONG.
01 pw BINARY-LONG.
01 x1 BINARY-LONG.
01 x2 BINARY-LONG.
01 rel BINARY-LONG.
01 column-at BINARY-LONG.
01 origin-y BINARY-LONG.
01 topdelta BINARY-LONG.
01 post-len BINARY-LONG.
01 src-at BINARY-LONG.
01 use-src BINARY-LONG.
01 pos-n BINARY-LONG.
01 count-n BINARY-LONG.
01 dest-at BINARY-LONG.
01 comp-for BINARY-LONG VALUE 0.
01 post-top BINARY-LONG.
01 post-b BINARY-LONG.
01 patch-count BINARY-LONG OCCURS 256 TIMES.
01 byte-tally BINARY-LONG OCCURS 256 TIMES.
01 best-n BINARY-LONG.
01 best-c BINARY-LONG.
01 got-n BINARY-LONG.

LINKAGE SECTION.
01 ntex-out BINARY-LONG.
01 nflat-out BINARY-LONG.
01 rc BINARY-LONG.

PROCEDURE DIVISION USING ntex-out nflat-out rc.
    MOVE 0 TO n-tex n-flat n-pname n-tpatch n-col cmap-n comp-for
    MOVE 0 TO sky-flat sky-tex
    PERFORM load-pnames
    PERFORM load-texture-file
    PERFORM build-lookups
    PERFORM load-flats
    PERFORM load-colormap
    MOVE "F_SKY1" TO seek-name
    CALL "flat-num" USING seek-name sky-flat
    MOVE "SKY1" TO seek-name
    CALL "tex-num" USING seek-name sky-tex
    IF n-tex = 125 AND tex-name(1) = "AASTINKY"
        PERFORM prove-shareware
    END-IF
    PERFORM fill-swatches
    MOVE n-tex TO ntex-out
    MOVE n-flat TO nflat-out
    MOVE 0 TO rc
    GOBACK.

load-pnames.
    MOVE "PNAMES" TO seek-name
    CALL "wad-find" USING seek-name lump-id
    IF lump-id < 0
        MOVE "PNAMES ausente" TO reason
        PERFORM fail-res
    END-IF
    PERFORM read-lump
    CALL "u32_le" USING BY REFERENCE lump-buf BY VALUE 0 RETURNING n-pname
    IF n-pname < 1 OR n-pname > 512
        MOVE "PNAMES invalido" TO reason
        PERFORM fail-res
    END-IF
    PERFORM VARYING i FROM 0 BY 1 UNTIL i >= n-pname
        COMPUTE slot = i + 1
        COMPUTE name-base = 4 + i * 8
        PERFORM copy-name
        CALL "wad-find" USING name-out lump-id
        MOVE lump-id TO pname-lump(slot)
    END-PERFORM
    .

load-texture-file.
    MOVE "TEXTURE1" TO seek-name
    CALL "wad-find" USING seek-name lump-id
    IF lump-id < 0
        MOVE "TEXTURE1 ausente" TO reason
        PERFORM fail-res
    END-IF
    PERFORM read-lump
    PERFORM parse-directory
    MOVE "TEXTURE2" TO seek-name
    CALL "wad-find" USING seek-name lump-id
    IF lump-id >= 0
        PERFORM read-lump
        PERFORM parse-directory
    END-IF
    .

parse-directory.
    CALL "u32_le" USING BY REFERENCE lump-buf BY VALUE 0 RETURNING num-in-lump
    PERFORM VARYING i FROM 0 BY 1 UNTIL i >= num-in-lump
        IF n-tex >= 512
            MOVE "texturas demais" TO reason
            PERFORM fail-res
        END-IF
        COMPUTE at-pos = 4 + i * 4
        CALL "u32_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING tex-ofs
        PERFORM parse-one
    END-PERFORM
    .

parse-one.
    ADD 1 TO n-tex
    MOVE n-tex TO slot
    MOVE tex-ofs TO name-base
    PERFORM copy-name
    MOVE name-out TO tex-name(slot)
    COMPUTE at-pos = tex-ofs + 12
    CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos RETURNING tex-w(slot)
    COMPUTE at-pos = tex-ofs + 14
    CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos RETURNING tex-h(slot)
    COMPUTE at-pos = tex-ofs + 20
    CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos RETURNING patch-n
    IF tex-w(slot) < 1
        MOVE 0 TO tex-w(slot)
    END-IF
    IF tex-h(slot) < 1
        MOVE 0 TO tex-h(slot)
    END-IF
    IF patch-n < 0
        MOVE 0 TO patch-n
    END-IF
    MOVE 1 TO j
    PERFORM UNTIL j * 2 > tex-w(slot)
        COMPUTE j = j * 2
    END-PERFORM
    COMPUTE tex-mask(slot) = j - 1
    IF tex-w(slot) = 0
        MOVE 0 TO tex-c0(slot)
    ELSE
        IF n-col + tex-w(slot) > 48000
            MOVE "colunas demais" TO reason
            PERFORM fail-res
        END-IF
        COMPUTE tex-c0(slot) = n-col + 1
        PERFORM VARYING x-i FROM 0 BY 1 UNTIL x-i >= tex-w(slot)
            COMPUTE pool = tex-c0(slot) + x-i
            MOVE -1 TO col-lump(pool)
            MOVE 0 TO col-ofs(pool)
        END-PERFORM
        ADD tex-w(slot) TO n-col
    END-IF
    MOVE patch-n TO tex-pn(slot)
    COMPUTE tex-p0(slot) = n-tpatch + 1
    COMPUTE at-pos = tex-ofs + 22
    PERFORM VARYING p-i FROM 0 BY 1 UNTIL p-i >= patch-n
        IF n-tpatch >= 2048
            MOVE "patches demais" TO reason
            PERFORM fail-res
        END-IF
        ADD 1 TO n-tpatch
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING tp-x(n-tpatch)
        COMPUTE at-pos = at-pos + 2
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING tp-y(n-tpatch)
        COMPUTE at-pos = at-pos + 2
        CALL "i16_le" USING BY REFERENCE lump-buf BY VALUE at-pos
            RETURNING pidx
        IF pidx >= 0 AND pidx < n-pname
            COMPUTE slot = pidx + 1
            MOVE pname-lump(slot) TO tp-lump(n-tpatch)
        ELSE
            MOVE -1 TO tp-lump(n-tpatch)
        END-IF
        COMPUTE at-pos = at-pos + 6
    END-PERFORM
    .

build-lookups.
    PERFORM VARYING tex-slot FROM 1 BY 1 UNTIL tex-slot > n-tex
        PERFORM lookup-one
    END-PERFORM
    .

lookup-one.
    IF tex-w(tex-slot) < 1
        EXIT PARAGRAPH
    END-IF
    PERFORM VARYING x-i FROM 1 BY 1 UNTIL x-i > tex-w(tex-slot)
        MOVE 0 TO patch-count(x-i)
    END-PERFORM
    PERFORM VARYING p-i FROM 0 BY 1 UNTIL p-i >= tex-pn(tex-slot)
        COMPUTE slot = tex-p0(tex-slot) + p-i
        IF tp-lump(slot) >= 0
            MOVE tp-lump(slot) TO lump-id
            CALL "wad-read-num" USING lump-id patch-buf cap-n patch-len
            IF patch-len >= 8
                CALL "i16_le" USING BY REFERENCE patch-buf BY VALUE 0
                    RETURNING pw
                MOVE tp-x(slot) TO x1
                COMPUTE x2 = x1 + pw
                IF x1 < 0
                    MOVE 0 TO x-i
                ELSE
                    MOVE x1 TO x-i
                END-IF
                IF x2 > tex-w(tex-slot)
                    MOVE tex-w(tex-slot) TO x2
                END-IF
                PERFORM UNTIL x-i >= x2
                    COMPUTE pool = tex-c0(tex-slot) + x-i
                    ADD 1 TO patch-count(x-i + 1)
                    MOVE tp-lump(slot) TO col-lump(pool)
                    COMPUTE rel = x-i - x1
                    COMPUTE at-pos = 8 + rel * 4
                    IF at-pos >= 0 AND at-pos + 3 < patch-len
                        CALL "u32_le" USING BY REFERENCE patch-buf
                            BY VALUE at-pos RETURNING col-ofs(pool)
                    END-IF
                    ADD 1 TO x-i
                END-PERFORM
            END-IF
        END-IF
    END-PERFORM
    PERFORM VARYING x-i FROM 0 BY 1 UNTIL x-i >= tex-w(tex-slot)
        IF patch-count(x-i + 1) > 1
            COMPUTE pool = tex-c0(tex-slot) + x-i
            MOVE -1 TO col-lump(pool)
        END-IF
    END-PERFORM
    .

load-flats.
    MOVE "F_START" TO seek-name
    CALL "wad-find" USING seek-name lump-id
    IF lump-id < 0
        MOVE "F_START ausente" TO reason
        PERFORM fail-res
    END-IF
    COMPUTE flats-first = lump-id + 1
    MOVE "F_END" TO seek-name
    CALL "wad-find" USING seek-name lump-id
    IF lump-id < 0
        MOVE "F_END ausente" TO reason
        PERFORM fail-res
    END-IF
    COMPUTE flats-last = lump-id - 1
    COMPUTE n-flat = flats-last - flats-first + 1
    IF n-flat < 1 OR n-flat > 256
        MOVE "flats invalidos" TO reason
        PERFORM fail-res
    END-IF
    .

load-colormap.
    MOVE "COLORMAP" TO seek-name
    CALL "wad-find" USING seek-name lump-id
    IF lump-id < 0
        MOVE "COLORMAP ausente" TO reason
        PERFORM fail-res
    END-IF
    PERFORM read-lump
    IF lump-len < 8704
        MOVE "COLORMAP curto" TO reason
        PERFORM fail-res
    END-IF
    MOVE lump-buf(1:8704) TO cmap-buf
    MOVE 8704 TO cmap-n
    .

prove-shareware.
    IF n-flat NOT = 56 OR tex-w(1) NOT = 24 OR tex-h(1) NOT = 72
        OR tex-mask(1) NOT = 15 OR tex-pn(1) NOT = 2
        MOVE "textura 0" TO reason
        PERFORM fail-res
    END-IF
    MOVE "STARTAN2" TO seek-name
    CALL "tex-num" USING seek-name got-n
    IF got-n NOT = 69
        MOVE "STARTAN2" TO reason
        PERFORM fail-res
    END-IF
    MOVE "BROWN1" TO seek-name
    CALL "tex-num" USING seek-name got-n
    IF got-n NOT = 14
        MOVE "BROWN1" TO reason
        PERFORM fail-res
    END-IF
    MOVE "-" TO seek-name
    CALL "tex-num" USING seek-name got-n
    IF got-n NOT = 0
        MOVE "traco" TO reason
        PERFORM fail-res
    END-IF
    MOVE "NOTEX" TO seek-name
    CALL "tex-num" USING seek-name got-n
    IF got-n NOT = 0
        MOVE "NOTEX" TO reason
        PERFORM fail-res
    END-IF
    MOVE "NOFLAT" TO seek-name
    CALL "flat-num" USING seek-name got-n
    IF got-n NOT = 0
        MOVE "NOFLAT" TO reason
        PERFORM fail-res
    END-IF
    IF tex-w(70) NOT = 128 OR tex-mask(70) NOT = 127
        OR col-lump(tex-c0(70)) NOT = 1117
        OR col-ofs(tex-c0(70)) NOT = 136
        MOVE "STARTAN2 coluna" TO reason
        PERFORM fail-res
    END-IF
    MOVE 70 TO tex-slot
    MOVE 0 TO col-i
    PERFORM take-column
    CALL "byte_at" USING BY REFERENCE col-out BY VALUE 0 RETURNING byte-n
    IF byte-n NOT = 143
        MOVE "coluna STARTAN2" TO reason
        PERFORM fail-res
    END-IF
    CALL "byte_at" USING BY REFERENCE col-out BY VALUE 64 RETURNING byte-n
    IF byte-n NOT = 141
        MOVE "coluna STARTAN2 64" TO reason
        PERFORM fail-res
    END-IF
    PERFORM first-post
    IF post-top NOT = 0 OR post-b NOT = 143
        MOVE "post STARTAN2" TO reason
        PERFORM fail-res
    END-IF
    IF tex-name(2) NOT = "BIGDOOR1"
        MOVE "BIGDOOR1" TO reason
        PERFORM fail-res
    END-IF
    MOVE 2 TO tex-slot
    MOVE 0 TO col-i
    PERFORM take-column
    CALL "byte_at" USING BY REFERENCE col-out BY VALUE 0 RETURNING byte-n
    IF byte-n NOT = 107
        MOVE "coluna BIGDOOR1" TO reason
        PERFORM fail-res
    END-IF
    CALL "byte_at" USING BY REFERENCE col-out BY VALUE 10 RETURNING byte-n
    IF byte-n NOT = 104
        MOVE "coluna BIGDOOR1 10" TO reason
        PERFORM fail-res
    END-IF
    MOVE 3 TO col-i
    PERFORM take-column
    PERFORM first-post
    IF post-top NOT = 0 OR post-len NOT = 96 OR post-b NOT = 107
        MOVE "post BIGDOOR1" TO reason
        PERFORM fail-res
    END-IF
    MOVE "FLOOR4_8" TO seek-name
    CALL "flat-num" USING seek-name got-n
    IF got-n NOT = 10 OR sky-flat NOT = 54 OR sky-tex NOT = 59
        MOVE "flat ou ceu" TO reason
        PERFORM fail-res
    END-IF
    COMPUTE lump-id = flats-first + 10
    PERFORM read-lump
    CALL "byte_at" USING BY REFERENCE lump-buf BY VALUE 2080 RETURNING byte-n
    IF lump-len < 4096 OR byte-n NOT = 1
        MOVE "FLOOR4_8 pixels" TO reason
        PERFORM fail-res
    END-IF
    CALL "fixed_from_i16" USING BY VALUE tex-h(70) RETURNING got-n
    IF got-n NOT = 8388608 OR tex-w(70) NOT = 128 OR cmap-n NOT = 8704
        MOVE "altura ou colormap" TO reason
        PERFORM fail-res
    END-IF
    CALL "byte_at" USING BY REFERENCE cmap-buf BY VALUE 0 RETURNING byte-n
    IF byte-n NOT = 0
        MOVE "colormap 0" TO reason
        PERFORM fail-res
    END-IF
    CALL "byte_at" USING BY REFERENCE cmap-buf BY VALUE 255 RETURNING byte-n
    IF byte-n NOT = 255
        MOVE "colormap 255" TO reason
        PERFORM fail-res
    END-IF
    CALL "byte_at" USING BY REFERENCE cmap-buf BY VALUE 8192 RETURNING byte-n
    IF byte-n NOT = 4
        MOVE "colormap 32" TO reason
        PERFORM fail-res
    END-IF
    .

take-column.
    IF tex-w(tex-slot) < 1
        MOVE ALL X"00" TO col-out
        EXIT PARAGRAPH
    END-IF
    CALL "bit_and" USING BY VALUE col-i BY VALUE tex-mask(tex-slot)
        RETURNING masked
    MOVE masked TO col-i
    COMPUTE pool = tex-c0(tex-slot) + col-i
    IF col-lump(pool) >= 0
        MOVE col-lump(pool) TO lump-id
        CALL "wad-read-num" USING lump-id patch-buf cap-n patch-len
        MOVE col-ofs(pool) TO column-at
        PERFORM paint-source
    ELSE
        IF comp-for NOT = tex-slot
            PERFORM build-composite
        END-IF
        PERFORM repeat-composite
    END-IF
    .

paint-source.
    MOVE ALL X"00" TO col-out
    PERFORM UNTIL column-at < 0 OR column-at >= patch-len
        CALL "byte_at" USING BY REFERENCE patch-buf BY VALUE column-at
            RETURNING topdelta
        IF topdelta = 255
            EXIT PERFORM
        END-IF
        COMPUTE at-pos = column-at + 1
        IF at-pos >= patch-len
            EXIT PERFORM
        END-IF
        CALL "byte_at" USING BY REFERENCE patch-buf BY VALUE at-pos
            RETURNING post-len
        COMPUTE src-at = column-at + 3
        PERFORM VARYING k FROM 0 BY 1 UNTIL k >= post-len
            COMPUTE dest-at = topdelta + k
            COMPUTE at-pos = src-at + k
            IF dest-at >= 0 AND dest-at < 128 AND at-pos < patch-len
                CALL "byte_at" USING BY REFERENCE patch-buf BY VALUE at-pos
                    RETURNING byte-n
                CALL "poke_byte" USING BY REFERENCE col-out BY VALUE dest-at
                    BY VALUE byte-n
            END-IF
        END-PERFORM
        ADD post-len TO column-at
        ADD 4 TO column-at
    END-PERFORM
    .

repeat-composite.
    MOVE ALL X"00" TO col-out
    IF tex-h(tex-slot) < 1
        EXIT PARAGRAPH
    END-IF
    COMPUTE pool = tex-c0(tex-slot) + col-i
    PERFORM VARYING k FROM 0 BY 1 UNTIL k >= 128
        COMPUTE rel = FUNCTION MOD(k, tex-h(tex-slot))
        COMPUTE at-pos = col-ofs(pool) + rel
        CALL "byte_at" USING BY REFERENCE comp-buf BY VALUE at-pos
            RETURNING byte-n
        CALL "poke_byte" USING BY REFERENCE col-out BY VALUE k BY VALUE byte-n
    END-PERFORM
    .

build-composite.
    MOVE ALL X"00" TO comp-buf
    PERFORM VARYING p-i FROM 0 BY 1 UNTIL p-i >= tex-pn(tex-slot)
        COMPUTE slot = tex-p0(tex-slot) + p-i
        IF tp-lump(slot) >= 0
            MOVE tp-lump(slot) TO lump-id
            CALL "wad-read-num" USING lump-id patch-buf cap-n patch-len
            IF patch-len >= 8
                CALL "i16_le" USING BY REFERENCE patch-buf BY VALUE 0
                    RETURNING pw
                MOVE tp-x(slot) TO x1
                MOVE tp-y(slot) TO origin-y
                COMPUTE x2 = x1 + pw
                IF x1 < 0
                    MOVE 0 TO x-i
                ELSE
                    MOVE x1 TO x-i
                END-IF
                IF x2 > tex-w(tex-slot)
                    MOVE tex-w(tex-slot) TO x2
                END-IF
                PERFORM UNTIL x-i >= x2
                    COMPUTE rel = x-i - x1
                    COMPUTE at-pos = 8 + rel * 4
                    IF at-pos >= 0 AND at-pos + 3 < patch-len
                        CALL "u32_le" USING BY REFERENCE patch-buf
                            BY VALUE at-pos RETURNING column-at
                        PERFORM draw-cached
                    END-IF
                    ADD 1 TO x-i
                END-PERFORM
            END-IF
        END-IF
    END-PERFORM
    PERFORM VARYING x-i FROM 0 BY 1 UNTIL x-i >= tex-w(tex-slot)
        COMPUTE pool = tex-c0(tex-slot) + x-i
        IF col-lump(pool) < 0
            COMPUTE col-ofs(pool) = x-i * tex-h(tex-slot)
        END-IF
    END-PERFORM
    MOVE tex-slot TO comp-for
    .

draw-cached.
    PERFORM UNTIL column-at < 0 OR column-at >= patch-len
        CALL "byte_at" USING BY REFERENCE patch-buf BY VALUE column-at
            RETURNING topdelta
        IF topdelta = 255
            EXIT PERFORM
        END-IF
        COMPUTE at-pos = column-at + 1
        IF at-pos >= patch-len
            EXIT PERFORM
        END-IF
        CALL "byte_at" USING BY REFERENCE patch-buf BY VALUE at-pos
            RETURNING post-len
        COMPUTE src-at = column-at + 3
        COMPUTE pos-n = origin-y + topdelta
        MOVE post-len TO count-n
        MOVE src-at TO use-src
        IF pos-n < 0
            ADD pos-n TO count-n
            COMPUTE use-src = src-at - pos-n
            MOVE 0 TO pos-n
        END-IF
        IF pos-n + count-n > tex-h(tex-slot)
            COMPUTE count-n = tex-h(tex-slot) - pos-n
        END-IF
        IF count-n > 0 AND pos-n >= 0
            COMPUTE dest-at = x-i * tex-h(tex-slot) + pos-n
            PERFORM VARYING k FROM 0 BY 1 UNTIL k >= count-n
                COMPUTE at-pos = use-src + k
                IF at-pos >= 0 AND at-pos < patch-len
                    AND dest-at + k < 32768
                    CALL "byte_at" USING BY REFERENCE patch-buf BY VALUE at-pos
                        RETURNING byte-n
                    COMPUTE rel = dest-at + k
                    CALL "poke_byte" USING BY REFERENCE comp-buf BY VALUE rel
                        BY VALUE byte-n
                END-IF
            END-PERFORM
        END-IF
        ADD post-len TO column-at
        ADD 4 TO column-at
    END-PERFORM
    .

first-post.
    COMPUTE pool = tex-c0(tex-slot) + col-i
    IF col-lump(pool) < 0
        MOVE 0 TO post-top
        MOVE tex-h(tex-slot) TO post-len
        CALL "byte_at" USING BY REFERENCE comp-buf BY VALUE col-ofs(pool)
            RETURNING post-b
    ELSE
        MOVE col-ofs(pool) TO column-at
        MOVE 0 TO post-top
        MOVE 0 TO post-len
        MOVE 0 TO post-b
        IF column-at >= 0 AND column-at + 3 < patch-len
            CALL "byte_at" USING BY REFERENCE patch-buf BY VALUE column-at
                RETURNING post-top
            COMPUTE at-pos = column-at + 1
            CALL "byte_at" USING BY REFERENCE patch-buf BY VALUE at-pos
                RETURNING post-len
            COMPUTE at-pos = column-at + 3
            CALL "byte_at" USING BY REFERENCE patch-buf BY VALUE at-pos
                RETURNING post-b
        END-IF
    END-IF
    .

fill-swatches.
    PERFORM VARYING tex-slot FROM 1 BY 1 UNTIL tex-slot > n-tex
        MOVE 0 TO col-i
        PERFORM take-column
        PERFORM dominant-column
        MOVE best-c TO swatch-tex(tex-slot)
    END-PERFORM
    PERFORM VARYING i FROM 0 BY 1 UNTIL i >= n-flat
        COMPUTE lump-id = flats-first + i
        PERFORM read-lump
        PERFORM dominant-flat
        COMPUTE slot = i + 1
        MOVE best-c TO swatch-flat(slot)
    END-PERFORM
    .

dominant-column.
    PERFORM VARYING k FROM 1 BY 1 UNTIL k > 256
        MOVE 0 TO byte-tally(k)
    END-PERFORM
    MOVE 0 TO best-n
    MOVE 0 TO best-c
    PERFORM VARYING k FROM 0 BY 1 UNTIL k >= 128
        CALL "byte_at" USING BY REFERENCE col-out BY VALUE k RETURNING byte-n
        IF byte-n NOT = 0
            COMPUTE slot = byte-n + 1
            ADD 1 TO byte-tally(slot)
            IF byte-tally(slot) > best-n
                MOVE byte-tally(slot) TO best-n
                MOVE byte-n TO best-c
            END-IF
        END-IF
    END-PERFORM
    IF best-n = 0
        CALL "byte_at" USING BY REFERENCE col-out BY VALUE 0 RETURNING best-c
    END-IF
    .

dominant-flat.
    PERFORM VARYING k FROM 1 BY 1 UNTIL k > 256
        MOVE 0 TO byte-tally(k)
    END-PERFORM
    MOVE 0 TO best-n
    CALL "byte_at" USING BY REFERENCE lump-buf BY VALUE 0 RETURNING best-c
    IF lump-len > 4096
        MOVE 4096 TO raw-n
    ELSE
        MOVE lump-len TO raw-n
    END-IF
    PERFORM VARYING k FROM 0 BY 1 UNTIL k >= raw-n
        CALL "byte_at" USING BY REFERENCE lump-buf BY VALUE k RETURNING byte-n
        IF byte-n NOT = 0
            COMPUTE slot = byte-n + 1
            ADD 1 TO byte-tally(slot)
            IF byte-tally(slot) > best-n
                MOVE byte-tally(slot) TO best-n
                MOVE byte-n TO best-c
            END-IF
        END-IF
    END-PERFORM
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

read-lump.
    CALL "wad-read-num" USING lump-id lump-buf cap-n lump-len
    IF lump-len < 0
        MOVE "lump de textura" TO reason
        PERFORM fail-res
    END-IF
    .

fail-res.
    DISPLAY "texturas invalidas: " reason
    MOVE 8 TO rc
    GOBACK
    .

END PROGRAM rdata-init.

IDENTIFICATION DIVISION.
PROGRAM-ID. tex-num.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "rdata.cpy".
01 name-key PIC X(8).
01 i BINARY-LONG.

LINKAGE SECTION.
01 lname PIC X(8).
01 tex-id BINARY-LONG.

PROCEDURE DIVISION USING lname tex-id.
    MOVE lname TO name-key
    INSPECT name-key CONVERTING
        "abcdefghijklmnopqrstuvwxyz" TO "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    IF FUNCTION TRIM(name-key) = "-" OR FUNCTION TRIM(name-key) = SPACES
        MOVE 0 TO tex-id
        GOBACK
    END-IF
    MOVE 0 TO tex-id
    PERFORM VARYING i FROM n-tex BY -1 UNTIL i < 1
        IF tex-name(i) = name-key
            COMPUTE tex-id = i - 1
            GOBACK
        END-IF
    END-PERFORM
    GOBACK.

END PROGRAM tex-num.

IDENTIFICATION DIVISION.
PROGRAM-ID. flat-num.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "rdata.cpy".
01 name-key PIC X(8).
01 lump-id BINARY-LONG.

LINKAGE SECTION.
01 lname PIC X(8).
01 flat-id BINARY-LONG.

PROCEDURE DIVISION USING lname flat-id.
    MOVE lname TO name-key
    INSPECT name-key CONVERTING
        "abcdefghijklmnopqrstuvwxyz" TO "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    CALL "wad-find" USING name-key lump-id
    IF lump-id < 0
        MOVE 0 TO flat-id
    ELSE
        COMPUTE flat-id = lump-id - flats-first
    END-IF
    GOBACK.

END PROGRAM flat-num.

IDENTIFICATION DIVISION.
PROGRAM-ID. tex-swatch.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "rdata.cpy".
01 slot BINARY-LONG.

LINKAGE SECTION.
01 tex-id BINARY-LONG.
01 color-n BINARY-LONG.

PROCEDURE DIVISION USING tex-id color-n.
    IF tex-id < 0 OR tex-id >= n-tex
        MOVE 0 TO color-n
        GOBACK
    END-IF
    COMPUTE slot = tex-id + 1
    MOVE swatch-tex(slot) TO color-n
    GOBACK.

END PROGRAM tex-swatch.

IDENTIFICATION DIVISION.
PROGRAM-ID. flat-swatch.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "rdata.cpy".
01 slot BINARY-LONG.

LINKAGE SECTION.
01 flat-id BINARY-LONG.
01 color-n BINARY-LONG.

PROCEDURE DIVISION USING flat-id color-n.
    IF flat-id < 0 OR flat-id >= n-flat
        MOVE 0 TO color-n
        GOBACK
    END-IF
    COMPUTE slot = flat-id + 1
    MOVE swatch-flat(slot) TO color-n
    GOBACK.

END PROGRAM flat-swatch.

IDENTIFICATION DIVISION.
PROGRAM-ID. tex-column.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "rdata.cpy".
01 patch-buf PIC X(65536).
01 comp-buf PIC X(32768).
01 cap-n BINARY-LONG VALUE 65536.
01 lump-id BINARY-LONG.
01 patch-len BINARY-LONG.
01 tex-slot BINARY-LONG.
01 pool BINARY-LONG.
01 masked BINARY-LONG.
01 col-i BINARY-LONG.
01 at-pos BINARY-LONG.
01 byte-n BINARY-LONG.
01 k BINARY-LONG.
01 p-i BINARY-LONG.
01 slot BINARY-LONG.
01 pw BINARY-LONG.
01 x1 BINARY-LONG.
01 x2 BINARY-LONG.
01 x-i BINARY-LONG.
01 rel BINARY-LONG.
01 column-at BINARY-LONG.
01 origin-y BINARY-LONG.
01 topdelta BINARY-LONG.
01 post-len BINARY-LONG.
01 src-at BINARY-LONG.
01 use-src BINARY-LONG.
01 pos-n BINARY-LONG.
01 count-n BINARY-LONG.
01 dest-at BINARY-LONG.
01 comp-for BINARY-LONG VALUE 0.
01 patch-cached BINARY-LONG VALUE -1.

LINKAGE SECTION.
01 tex-id BINARY-LONG.
01 col-n BINARY-LONG.
01 dest PIC X(128).

PROCEDURE DIVISION USING tex-id col-n dest.
    MOVE ALL X"00" TO dest
    IF tex-id < 0 OR tex-id >= n-tex
        GOBACK
    END-IF
    COMPUTE tex-slot = tex-id + 1
    IF tex-w(tex-slot) < 1
        GOBACK
    END-IF
    CALL "bit_and" USING BY VALUE col-n BY VALUE tex-mask(tex-slot)
        RETURNING masked
    MOVE masked TO col-i
    COMPUTE pool = tex-c0(tex-slot) + col-i
    IF pool >= 1 AND pool <= 48000 AND col-ready(pool) = 1
        MOVE col-img(pool) TO dest
        GOBACK
    END-IF
    IF col-lump(pool) >= 0
        MOVE col-lump(pool) TO lump-id
        IF lump-id NOT = patch-cached
            CALL "wad-read-num" USING lump-id patch-buf cap-n patch-len
            MOVE lump-id TO patch-cached
        END-IF
        MOVE col-ofs(pool) TO column-at
        PERFORM paint-source
    ELSE
        IF comp-for NOT = tex-slot
            PERFORM build-composite
        END-IF
        PERFORM repeat-composite
    END-IF
    IF pool >= 1 AND pool <= 48000
        MOVE dest TO col-img(pool)
        MOVE 1 TO col-ready(pool)
    END-IF
    GOBACK.

paint-source.
    MOVE ALL X"00" TO dest
    PERFORM UNTIL column-at < 0 OR column-at >= patch-len
        CALL "byte_at" USING BY REFERENCE patch-buf BY VALUE column-at
            RETURNING topdelta
        IF topdelta = 255
            EXIT PERFORM
        END-IF
        COMPUTE at-pos = column-at + 1
        IF at-pos >= patch-len
            EXIT PERFORM
        END-IF
        CALL "byte_at" USING BY REFERENCE patch-buf BY VALUE at-pos
            RETURNING post-len
        COMPUTE src-at = column-at + 3
        PERFORM VARYING k FROM 0 BY 1 UNTIL k >= post-len
            COMPUTE dest-at = topdelta + k
            COMPUTE at-pos = src-at + k
            IF dest-at >= 0 AND dest-at < 128 AND at-pos < patch-len
                CALL "byte_at" USING BY REFERENCE patch-buf BY VALUE at-pos
                    RETURNING byte-n
                CALL "poke_byte" USING BY REFERENCE dest BY VALUE dest-at
                    BY VALUE byte-n
            END-IF
        END-PERFORM
        ADD post-len TO column-at
        ADD 4 TO column-at
    END-PERFORM
    .

repeat-composite.
    MOVE ALL X"00" TO dest
    IF tex-h(tex-slot) < 1
        EXIT PARAGRAPH
    END-IF
    COMPUTE pool = tex-c0(tex-slot) + col-i
    PERFORM VARYING k FROM 0 BY 1 UNTIL k >= 128
        COMPUTE rel = FUNCTION MOD(k, tex-h(tex-slot))
        COMPUTE at-pos = col-ofs(pool) + rel
        CALL "byte_at" USING BY REFERENCE comp-buf BY VALUE at-pos
            RETURNING byte-n
        CALL "poke_byte" USING BY REFERENCE dest BY VALUE k BY VALUE byte-n
    END-PERFORM
    .

build-composite.
    MOVE ALL X"00" TO comp-buf
    MOVE -1 TO patch-cached
    PERFORM VARYING p-i FROM 0 BY 1 UNTIL p-i >= tex-pn(tex-slot)
        COMPUTE slot = tex-p0(tex-slot) + p-i
        IF tp-lump(slot) >= 0
            MOVE tp-lump(slot) TO lump-id
            CALL "wad-read-num" USING lump-id patch-buf cap-n patch-len
            MOVE lump-id TO patch-cached
            IF patch-len >= 8
                CALL "i16_le" USING BY REFERENCE patch-buf BY VALUE 0
                    RETURNING pw
                MOVE tp-x(slot) TO x1
                MOVE tp-y(slot) TO origin-y
                COMPUTE x2 = x1 + pw
                IF x1 < 0
                    MOVE 0 TO x-i
                ELSE
                    MOVE x1 TO x-i
                END-IF
                IF x2 > tex-w(tex-slot)
                    MOVE tex-w(tex-slot) TO x2
                END-IF
                PERFORM UNTIL x-i >= x2
                    COMPUTE rel = x-i - x1
                    COMPUTE at-pos = 8 + rel * 4
                    IF at-pos >= 0 AND at-pos + 3 < patch-len
                        CALL "u32_le" USING BY REFERENCE patch-buf
                            BY VALUE at-pos RETURNING column-at
                        PERFORM draw-cached
                    END-IF
                    ADD 1 TO x-i
                END-PERFORM
            END-IF
        END-IF
    END-PERFORM
    PERFORM VARYING x-i FROM 0 BY 1 UNTIL x-i >= tex-w(tex-slot)
        COMPUTE pool = tex-c0(tex-slot) + x-i
        IF col-lump(pool) < 0
            COMPUTE col-ofs(pool) = x-i * tex-h(tex-slot)
        END-IF
    END-PERFORM
    MOVE tex-slot TO comp-for
    .

draw-cached.
    PERFORM UNTIL column-at < 0 OR column-at >= patch-len
        CALL "byte_at" USING BY REFERENCE patch-buf BY VALUE column-at
            RETURNING topdelta
        IF topdelta = 255
            EXIT PERFORM
        END-IF
        COMPUTE at-pos = column-at + 1
        IF at-pos >= patch-len
            EXIT PERFORM
        END-IF
        CALL "byte_at" USING BY REFERENCE patch-buf BY VALUE at-pos
            RETURNING post-len
        COMPUTE src-at = column-at + 3
        COMPUTE pos-n = origin-y + topdelta
        MOVE post-len TO count-n
        MOVE src-at TO use-src
        IF pos-n < 0
            ADD pos-n TO count-n
            COMPUTE use-src = src-at - pos-n
            MOVE 0 TO pos-n
        END-IF
        IF pos-n + count-n > tex-h(tex-slot)
            COMPUTE count-n = tex-h(tex-slot) - pos-n
        END-IF
        IF count-n > 0 AND pos-n >= 0
            COMPUTE dest-at = x-i * tex-h(tex-slot) + pos-n
            PERFORM VARYING k FROM 0 BY 1 UNTIL k >= count-n
                COMPUTE at-pos = use-src + k
                IF at-pos >= 0 AND at-pos < patch-len
                    AND dest-at + k < 32768
                    CALL "byte_at" USING BY REFERENCE patch-buf BY VALUE at-pos
                        RETURNING byte-n
                    COMPUTE rel = dest-at + k
                    CALL "poke_byte" USING BY REFERENCE comp-buf BY VALUE rel
                        BY VALUE byte-n
                END-IF
            END-PERFORM
        END-IF
        ADD post-len TO column-at
        ADD 4 TO column-at
    END-PERFORM
    .

END PROGRAM tex-column.

IDENTIFICATION DIVISION.
PROGRAM-ID. flat-load.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "rdata.cpy".
01 lump-id BINARY-LONG.
01 cap-n BINARY-LONG VALUE 4096.
01 slot BINARY-LONG.

LINKAGE SECTION.
01 flat-id BINARY-LONG.
01 dest PIC X(4096).
01 nread BINARY-LONG.

PROCEDURE DIVISION USING flat-id dest nread.
    MOVE ALL X"00" TO dest
    MOVE 0 TO nread
    IF flat-id < 0 OR flat-id >= n-flat
        GOBACK
    END-IF
    COMPUTE slot = flat-id + 1
    IF slot < 1 OR slot > 256
        GOBACK
    END-IF
    IF flat-ready(slot) = 0
        COMPUTE lump-id = flats-first + flat-id
        CALL "wad-read-num" USING lump-id flat-img(slot) cap-n nread
        IF nread < 0
            MOVE 0 TO nread
            MOVE ALL X"00" TO flat-img(slot)
        END-IF
        MOVE 1 TO flat-ready(slot)
    END-IF
    MOVE flat-img(slot) TO dest
    MOVE 4096 TO nread
    GOBACK.

END PROGRAM flat-load.
