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
*> Acha o lump DS e entrega os bytes ao misturador. Sem rato.
IDENTIFICATION DIVISION.
PROGRAM-ID. sfx-play.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 lump-name PIC X(8).
01 lump-id BINARY-LONG.
01 snd-buf PIC X(65536).
01 cap-n BINARY-LONG VALUE 65536.
01 nread BINARY-LONG.

LINKAGE SECTION.
01 sname PIC X(6).

PROCEDURE DIVISION USING sname.
    IF sname = SPACES
        GOBACK
    END-IF
    MOVE SPACES TO lump-name
    MOVE "DS" TO lump-name(1:2)
    MOVE sname TO lump-name(3:6)
    CALL "wad-find" USING lump-name lump-id
    IF lump-id < 0
        GOBACK
    END-IF
    CALL "wad-read-num" USING lump-id snd-buf cap-n nread
    IF nread < 16
        GOBACK
    END-IF
    CALL "audio_play" USING BY REFERENCE snd-buf
        BY VALUE nread BY REFERENCE lump-name
    GOBACK.

END PROGRAM sfx-play.

IDENTIFICATION DIVISION.
PROGRAM-ID. ply-ouch.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "playstate.cpy".
01 died-snd BINARY-LONG VALUE 0.
01 snd-name PIC X(6).

PROCEDURE DIVISION.
    IF ply-god = 1
        GOBACK
    END-IF
    IF ply-hp <= 0
        IF died-snd = 0
            MOVE 1 TO died-snd
            MOVE "pldeth" TO snd-name
            CALL "sfx-play" USING snd-name
        END-IF
    ELSE
        MOVE 0 TO died-snd
        MOVE "plpain" TO snd-name
        CALL "sfx-play" USING snd-name
    END-IF
    GOBACK.

END PROGRAM ply-ouch.

IDENTIFICATION DIVISION.
PROGRAM-ID. mus-play.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 lump-name PIC X(8).
01 lump-id BINARY-LONG.
01 mus-buf PIC X(262144).
01 cap-n BINARY-LONG VALUE 262144.
01 nread BINARY-LONG.

LINKAGE SECTION.
01 sname PIC X(6).
01 loop-n BINARY-LONG.

PROCEDURE DIVISION USING sname loop-n.
    IF sname = SPACES
        GOBACK
    END-IF
    MOVE SPACES TO lump-name
    MOVE "D_" TO lump-name(1:2)
    MOVE sname TO lump-name(3:6)
    CALL "wad-find" USING lump-name lump-id
    IF lump-id < 0
        GOBACK
    END-IF
    CALL "wad-read-num" USING lump-id mus-buf cap-n nread
    IF nread < 16
        GOBACK
    END-IF
    CALL "music_play" USING BY REFERENCE mus-buf
        BY VALUE nread BY VALUE loop-n BY REFERENCE lump-name
    GOBACK.

END PROGRAM mus-play.

IDENTIFICATION DIVISION.
PROGRAM-ID. mus-level.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 sname PIC X(6).
01 loop-n BINARY-LONG.
01 map-num BINARY-LONG.
01 slot BINARY-LONG.
01 d2-block.
    05 FILLER PIC X(6) VALUE "runnin".
    05 FILLER PIC X(6) VALUE "stalks".
    05 FILLER PIC X(6) VALUE "countd".
    05 FILLER PIC X(6) VALUE "betwee".
    05 FILLER PIC X(6) VALUE "doom".
    05 FILLER PIC X(6) VALUE "the_da".
    05 FILLER PIC X(6) VALUE "shawn".
    05 FILLER PIC X(6) VALUE "ddtblu".
    05 FILLER PIC X(6) VALUE "in_cit".
    05 FILLER PIC X(6) VALUE "dead".
    05 FILLER PIC X(6) VALUE "stlks2".
    05 FILLER PIC X(6) VALUE "theda2".
    05 FILLER PIC X(6) VALUE "doom2".
    05 FILLER PIC X(6) VALUE "ddtbl2".
    05 FILLER PIC X(6) VALUE "runni2".
    05 FILLER PIC X(6) VALUE "dead2".
    05 FILLER PIC X(6) VALUE "stlks3".
    05 FILLER PIC X(6) VALUE "romero".
    05 FILLER PIC X(6) VALUE "shawn2".
    05 FILLER PIC X(6) VALUE "messag".
    05 FILLER PIC X(6) VALUE "count2".
    05 FILLER PIC X(6) VALUE "ddtbl3".
    05 FILLER PIC X(6) VALUE "ampie".
    05 FILLER PIC X(6) VALUE "theda3".
    05 FILLER PIC X(6) VALUE "adrian".
    05 FILLER PIC X(6) VALUE "messg2".
    05 FILLER PIC X(6) VALUE "romer2".
    05 FILLER PIC X(6) VALUE "tense".
    05 FILLER PIC X(6) VALUE "shawn3".
    05 FILLER PIC X(6) VALUE "openin".
    05 FILLER PIC X(6) VALUE "evil".
    05 FILLER PIC X(6) VALUE "ultima".
01 d2-name REDEFINES d2-block PIC X(6) OCCURS 32 TIMES.

LINKAGE SECTION.
01 map-name PIC X(8).

PROCEDURE DIVISION USING map-name.
    MOVE 1 TO loop-n
    IF map-name(1:3) = "MAP"
        COMPUTE map-num = FUNCTION NUMVAL(map-name(4:2))
        IF map-num < 1
            MOVE 1 TO map-num
        END-IF
        COMPUTE slot = FUNCTION MOD(map-num - 1, 32) + 1
        MOVE d2-name(slot) TO sname
        CALL "mus-play" USING sname loop-n
        GOBACK
    END-IF
    IF map-name(1:1) = "E" AND map-name(3:1) = "M"
        MOVE SPACES TO sname
        MOVE "e" TO sname(1:1)
        MOVE map-name(2:1) TO sname(2:1)
        MOVE "m" TO sname(3:1)
        MOVE map-name(4:1) TO sname(4:1)
        CALL "mus-play" USING sname loop-n
    END-IF
    GOBACK.

END PROGRAM mus-level.

IDENTIFICATION DIVISION.
PROGRAM-ID. mus-title.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 sname PIC X(6).
01 loop-n BINARY-LONG VALUE 0.
01 lname PIC X(8).
01 lump-id BINARY-LONG.

PROCEDURE DIVISION.
    MOVE "MAP01" TO lname
    CALL "wad-find" USING lname lump-id
    IF lump-id >= 0
        MOVE "dm2ttl" TO sname
    ELSE
        MOVE "D_INTROA" TO lname
        CALL "wad-find" USING lname lump-id
        IF lump-id >= 0
            MOVE "introa" TO sname
        ELSE
            MOVE "intro" TO sname
        END-IF
    END-IF
    MOVE 0 TO loop-n
    CALL "mus-play" USING sname loop-n
    GOBACK.

END PROGRAM mus-title.

IDENTIFICATION DIVISION.
PROGRAM-ID. mus-inter.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 sname PIC X(6).
01 loop-n BINARY-LONG VALUE 1.
01 lname PIC X(8).
01 lump-id BINARY-LONG.

PROCEDURE DIVISION.
    MOVE "MAP01" TO lname
    CALL "wad-find" USING lname lump-id
    IF lump-id >= 0
        MOVE "dm2int" TO sname
    ELSE
        MOVE "inter" TO sname
    END-IF
    MOVE 1 TO loop-n
    CALL "mus-play" USING sname loop-n
    GOBACK.

END PROGRAM mus-inter.
