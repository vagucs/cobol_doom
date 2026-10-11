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
*> IWAD e diretorio de lumps, como doom/wad.py. Sem rato.

IDENTIFICATION DIVISION.
PROGRAM-ID. find-iwad.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 step BINARY-LONG.
01 ni BINARY-LONG.
01 hit BINARY-LONG.
01 exists-flag BINARY-LONG.
01 dir-flag BINARY-LONG.
01 env-rc BINARY-LONG.
01 join-rc BINARY-LONG.
01 dir PIC X(260).
01 env-path PIC X(260).
01 candidate PIC X(260).
01 env-name PIC X(16).
01 names.
   05 nm PIC X(16) OCCURS 10 TIMES.

LINKAGE SECTION.
01 want PIC X(260).
01 found PIC X(260).
01 rc BINARY-LONG.

PROCEDURE DIVISION USING want found rc.
    MOVE "DOOM1.WAD" TO nm(1)
    MOVE "doom1.wad" TO nm(2)
    MOVE "DOOM.WAD" TO nm(3)
    MOVE "doom.wad" TO nm(4)
    MOVE "DOOM2.WAD" TO nm(5)
    MOVE "doom2.wad" TO nm(6)
    MOVE "PLUTONIA.WAD" TO nm(7)
    MOVE "TNT.WAD" TO nm(8)
    MOVE "freedoom1.wad" TO nm(9)
    MOVE "freedoom2.wad" TO nm(10)
    IF FUNCTION TRIM(want) NOT = SPACES
        CALL "file_exists" USING BY REFERENCE want BY VALUE 260
            RETURNING exists-flag
        IF exists-flag = 1
            MOVE want TO found
            MOVE 0 TO rc
            GOBACK
        END-IF
        MOVE 1 TO rc
        GOBACK
    END-IF
    MOVE "DOOMWADDIR" TO env-name
    PERFORM try-env
    IF rc = 0
        GOBACK
    END-IF
    MOVE "DOOMWADPATH" TO env-name
    PERFORM try-env
    IF rc = 0
        GOBACK
    END-IF
    CALL "cwd_get" USING BY REFERENCE dir BY VALUE 260 RETURNING env-rc
    IF env-rc NOT = 0
        MOVE 2 TO rc
        GOBACK
    END-IF
    PERFORM VARYING step FROM 1 BY 1 UNTIL step > 5
        PERFORM try-names
        IF hit = 1
            MOVE 0 TO rc
            GOBACK
        END-IF
        CALL "parent_dir" USING BY REFERENCE dir BY VALUE 260 RETURNING env-rc
        IF env-rc NOT = 0
            EXIT PERFORM
        END-IF
    END-PERFORM
    MOVE 2 TO rc
    GOBACK.

try-env.
    MOVE 2 TO rc
    CALL "env_get" USING BY REFERENCE env-name BY VALUE 16
        BY REFERENCE env-path BY VALUE 260 RETURNING env-rc
    IF env-rc NOT = 0
        EXIT PARAGRAPH
    END-IF
    CALL "file_exists" USING BY REFERENCE env-path BY VALUE 260
        RETURNING exists-flag
    IF exists-flag = 1
        MOVE env-path TO found
        MOVE 0 TO rc
        EXIT PARAGRAPH
    END-IF
    CALL "path_is_dir" USING BY REFERENCE env-path BY VALUE 260
        RETURNING dir-flag
    IF dir-flag = 1
        MOVE env-path TO dir
        PERFORM try-names
        IF hit = 1
            MOVE 0 TO rc
        END-IF
    END-IF
    .

try-names.
    MOVE 0 TO hit
    PERFORM VARYING ni FROM 1 BY 1 UNTIL ni > 10 OR hit = 1
        CALL "path_join" USING BY REFERENCE dir BY VALUE 260
            BY REFERENCE nm(ni) BY VALUE 16
            BY REFERENCE candidate BY VALUE 260 RETURNING join-rc
        IF join-rc = 0
            CALL "file_exists" USING BY REFERENCE candidate BY VALUE 260
                RETURNING exists-flag
            IF exists-flag = 1
                MOVE candidate TO found
                MOVE 1 TO hit
            END-IF
        END-IF
    END-PERFORM
    .

END PROGRAM find-iwad.

IDENTIFICATION DIVISION.
PROGRAM-ID. wad-open.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "wadstate.cpy".
01 hdr PIC X(12).
01 dir-buf PIC X(131072).
01 io-rc BINARY-LONG.
01 numlumps BINARY-LONG.
01 info-ofs BINARY-LONG.
01 dir-len BINARY-LONG.
01 i BINARY-LONG.
01 slot BINARY-LONG.
01 base BINARY-LONG.
01 at-pos BINARY-LONG.
01 k BINARY-LONG.
01 byte-n BINARY-LONG.

LINKAGE SECTION.
01 path PIC X(260).
01 count-out BINARY-LONG.
01 rc BINARY-LONG.

PROCEDURE DIVISION USING path count-out rc.
    MOVE path TO wad-path
    MOVE 0 TO lump-n
    MOVE 0 TO count-out
    CALL "file_read" USING BY REFERENCE wad-path BY VALUE 260
        BY VALUE 0 BY VALUE 12 BY REFERENCE hdr RETURNING io-rc
    IF io-rc NOT = 0
        MOVE 3 TO rc
        GOBACK
    END-IF
    IF hdr(1:4) NOT = "IWAD" AND hdr(1:4) NOT = "PWAD"
        MOVE 1 TO rc
        GOBACK
    END-IF
    CALL "u32_le" USING BY REFERENCE hdr BY VALUE 4 RETURNING numlumps
    CALL "u32_le" USING BY REFERENCE hdr BY VALUE 8 RETURNING info-ofs
    IF numlumps < 1 OR numlumps > 8192
        MOVE 2 TO rc
        GOBACK
    END-IF
    COMPUTE dir-len = numlumps * 16
    CALL "file_read" USING BY REFERENCE wad-path BY VALUE 260
        BY VALUE info-ofs BY VALUE dir-len BY REFERENCE dir-buf
        RETURNING io-rc
    IF io-rc NOT = 0
        MOVE 3 TO rc
        GOBACK
    END-IF
    PERFORM VARYING i FROM 0 BY 1 UNTIL i >= numlumps
        COMPUTE slot = i + 1
        COMPUTE base = i * 16
        CALL "u32_le" USING BY REFERENCE dir-buf BY VALUE base
            RETURNING lump-pos(slot)
        COMPUTE at-pos = base + 4
        CALL "u32_le" USING BY REFERENCE dir-buf BY VALUE at-pos
            RETURNING lump-size(slot)
        MOVE SPACES TO lump-name(slot)
        PERFORM VARYING k FROM 0 BY 1 UNTIL k >= 8
            COMPUTE at-pos = base + 8 + k
            CALL "byte_at" USING BY REFERENCE dir-buf BY VALUE at-pos
                RETURNING byte-n
            IF byte-n = 0
                EXIT PERFORM
            END-IF
            IF byte-n >= 97 AND byte-n <= 122
                SUBTRACT 32 FROM byte-n
            END-IF
            CALL "poke_byte" USING BY REFERENCE lump-name(slot)
                BY VALUE k BY VALUE byte-n
        END-PERFORM
    END-PERFORM
    MOVE numlumps TO lump-n
    MOVE numlumps TO count-out
    MOVE 0 TO rc
    GOBACK.

END PROGRAM wad-open.

IDENTIFICATION DIVISION.
PROGRAM-ID. wad-read.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "wadstate.cpy".
01 name-key PIC X(8).
01 i BINARY-LONG.
01 slot BINARY-LONG.
01 io-rc BINARY-LONG.

LINKAGE SECTION.
01 lname PIC X(8).
01 buf PIC X(262144).
01 cap BINARY-LONG.
01 nread BINARY-LONG.

PROCEDURE DIVISION USING lname buf cap nread.
    MOVE lname TO name-key
    INSPECT name-key CONVERTING
        "abcdefghijklmnopqrstuvwxyz" TO "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    MOVE 0 TO slot
    PERFORM VARYING i FROM lump-n BY -1 UNTIL i < 1 OR slot > 0
        IF lump-name(i) = name-key
            MOVE i TO slot
        END-IF
    END-PERFORM
    IF slot = 0
        MOVE -1 TO nread
        GOBACK
    END-IF
    IF lump-size(slot) < 0 OR lump-size(slot) > cap
        MOVE -2 TO nread
        GOBACK
    END-IF
    CALL "file_read" USING BY REFERENCE wad-path BY VALUE 260
        BY VALUE lump-pos(slot) BY VALUE lump-size(slot)
        BY REFERENCE buf RETURNING io-rc
    IF io-rc NOT = 0
        MOVE -3 TO nread
    ELSE
        MOVE lump-size(slot) TO nread
    END-IF
    GOBACK.

END PROGRAM wad-read.

IDENTIFICATION DIVISION.
PROGRAM-ID. wad-find.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "wadstate.cpy".
01 name-key PIC X(8).
01 i BINARY-LONG.
01 slot BINARY-LONG.

LINKAGE SECTION.
01 lname PIC X(8).
01 lump-id BINARY-LONG.

PROCEDURE DIVISION USING lname lump-id.
    MOVE lname TO name-key
    INSPECT name-key CONVERTING
        "abcdefghijklmnopqrstuvwxyz" TO "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    MOVE 0 TO slot
    PERFORM VARYING i FROM lump-n BY -1 UNTIL i < 1 OR slot > 0
        IF lump-name(i) = name-key
            MOVE i TO slot
        END-IF
    END-PERFORM
    IF slot = 0
        MOVE -1 TO lump-id
    ELSE
        COMPUTE lump-id = slot - 1
    END-IF
    GOBACK.

END PROGRAM wad-find.

IDENTIFICATION DIVISION.
PROGRAM-ID. wad-read-num.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "wadstate.cpy".
01 slot BINARY-LONG.
01 io-rc BINARY-LONG.

LINKAGE SECTION.
01 lump-id BINARY-LONG.
01 buf PIC X(262144).
01 cap BINARY-LONG.
01 nread BINARY-LONG.

PROCEDURE DIVISION USING lump-id buf cap nread.
    COMPUTE slot = lump-id + 1
    IF lump-id < 0 OR slot > lump-n
        MOVE -1 TO nread
        GOBACK
    END-IF
    IF lump-size(slot) < 0 OR lump-size(slot) > cap
        MOVE -2 TO nread
        GOBACK
    END-IF
    CALL "file_read" USING BY REFERENCE wad-path BY VALUE 260
        BY VALUE lump-pos(slot) BY VALUE lump-size(slot)
        BY REFERENCE buf RETURNING io-rc
    IF io-rc NOT = 0
        MOVE -3 TO nread
    ELSE
        MOVE lump-size(slot) TO nread
    END-IF
    GOBACK.

END PROGRAM wad-read-num.
