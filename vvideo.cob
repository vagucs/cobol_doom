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
*> V_DrawPatch, como doom/v_video.py. O framebuffer e 320x200, um byte por pixel.

IDENTIFICATION DIVISION.
PROGRAM-ID. v-draw-patch.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 pw BINARY-LONG.
01 pic-h BINARY-LONG.
01 origin-x BINARY-LONG.
01 origin-y BINARY-LONG.
01 dx BINARY-LONG.
01 dy BINARY-LONG.
01 col-i BINARY-LONG.
01 col-pos BINARY-LONG.
01 topdelta BINARY-LONG.
01 post-len BINARY-LONG.
01 src-at BINARY-LONG.
01 dest BINARY-LONG.
01 pix BINARY-LONG.
01 step BINARY-LONG.
01 coff BINARY-LONG.
01 next-off BINARY-LONG.

LINKAGE SECTION.
01 fb PIC X(64000).
01 patch PIC X(262144).
01 patch-len BINARY-LONG.
01 ink BINARY-LONG.

PROCEDURE DIVISION USING fb patch patch-len ink.
    MOVE 0 TO ink
    IF patch-len < 8
        GOBACK
    END-IF
    CALL "i16_le" USING BY REFERENCE patch BY VALUE 0 RETURNING pw
    CALL "i16_le" USING BY REFERENCE patch BY VALUE 2 RETURNING pic-h
    CALL "i16_le" USING BY REFERENCE patch BY VALUE 4 RETURNING origin-x
    CALL "i16_le" USING BY REFERENCE patch BY VALUE 6 RETURNING origin-y
    IF pw < 1 OR pw > 2048
        GOBACK
    END-IF
    COMPUTE dx = 0 - origin-x
    COMPUTE dy = 0 - origin-y
    PERFORM VARYING col-i FROM 0 BY 1 UNTIL col-i >= pw
        COMPUTE coff = 8 + col-i * 4
        IF coff + 3 >= patch-len
            EXIT PERFORM
        END-IF
        CALL "u32_le" USING BY REFERENCE patch BY VALUE coff RETURNING col-pos
        PERFORM UNTIL col-pos >= patch-len OR col-pos < 0
            CALL "byte_at" USING BY REFERENCE patch BY VALUE col-pos
                RETURNING topdelta
            IF topdelta = 255
                EXIT PERFORM
            END-IF
            COMPUTE next-off = col-pos + 1
            IF next-off >= patch-len
                EXIT PERFORM
            END-IF
            CALL "byte_at" USING BY REFERENCE patch BY VALUE next-off
                RETURNING post-len
            COMPUTE src-at = col-pos + 3
            COMPUTE dest = (dy + topdelta) * 320 + dx + col-i
            MOVE 0 TO step
            PERFORM UNTIL step >= post-len
                IF src-at >= patch-len OR src-at < 0
                    EXIT PERFORM
                END-IF
                CALL "byte_at" USING BY REFERENCE patch BY VALUE src-at
                    RETURNING pix
                IF dest >= 0 AND dest < 64000
                    CALL "poke_byte" USING BY REFERENCE fb BY VALUE dest
                        BY VALUE pix
                    IF pix NOT = 0
                        ADD 1 TO ink
                    END-IF
                END-IF
                ADD 1 TO src-at
                ADD 320 TO dest
                ADD 1 TO step
            END-PERFORM
            ADD post-len TO col-pos
            ADD 4 TO col-pos
        END-PERFORM
    END-PERFORM
    GOBACK.

END PROGRAM v-draw-patch.

IDENTIFICATION DIVISION.
PROGRAM-ID. v-draw-line.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 x0 BINARY-LONG.
01 y0 BINARY-LONG.
01 x1 BINARY-LONG.
01 y1 BINARY-LONG.
01 adx BINARY-LONG.
01 ady BINARY-LONG.
01 step-x BINARY-LONG.
01 step-y BINARY-LONG.
01 err-n BINARY-LONG.
01 e2 BINARY-LONG.
01 guard-n BINARY-LONG.
01 at-pix BINARY-LONG.
01 neg-dy BINARY-LONG.

LINKAGE SECTION.
01 fb PIC X(64000).
01 ax0 BINARY-LONG.
01 ay0 BINARY-LONG.
01 ax1 BINARY-LONG.
01 ay1 BINARY-LONG.
01 pix-c BINARY-LONG.
01 ink-n BINARY-LONG.

PROCEDURE DIVISION USING fb ax0 ay0 ax1 ay1 pix-c ink-n.
    MOVE ax0 TO x0
    MOVE ay0 TO y0
    MOVE ax1 TO x1
    MOVE ay1 TO y1
    COMPUTE adx = FUNCTION ABS(x1 - x0)
    COMPUTE ady = FUNCTION ABS(y1 - y0)
    MOVE 1 TO step-x
    MOVE 1 TO step-y
    IF x0 >= x1
        MOVE -1 TO step-x
    END-IF
    IF y0 >= y1
        MOVE -1 TO step-y
    END-IF
    COMPUTE err-n = adx - ady
    COMPUTE guard-n = adx + ady + 1
    PERFORM UNTIL guard-n <= 0
        IF x0 >= 0 AND y0 >= 0 AND x0 < 320 AND y0 < 200
            COMPUTE at-pix = y0 * 320 + x0
            CALL "poke_byte" USING BY REFERENCE fb BY VALUE at-pix
                BY VALUE pix-c
            IF pix-c NOT = 0
                ADD 1 TO ink-n
            END-IF
        END-IF
        IF x0 = x1 AND y0 = y1
            EXIT PERFORM
        END-IF
        COMPUTE e2 = err-n * 2
        COMPUTE neg-dy = 0 - ady
        IF e2 > neg-dy
            COMPUTE err-n = err-n - ady
            ADD step-x TO x0
        END-IF
        IF e2 < adx
            COMPUTE err-n = err-n + adx
            ADD step-y TO y0
        END-IF
        SUBTRACT 1 FROM guard-n
    END-PERFORM
    GOBACK.

END PROGRAM v-draw-line.
