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
*> Cheats digitados: iddqd, idkfa, idfa, idclip, idspispopd,
*> idbehold, idmus, idclev, iddt, idmypos e idchoppers.
IDENTIFICATION DIVISION.
PROGRAM-ID. cheat-feed.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "playstate.cpy".
01 letters PIC X(26) VALUE "abcdefghijklmnopqrstuvwxyz".
01 ch-c PIC X.
01 ix BINARY-LONG.
01 seq-at BINARY-LONG.
01 seq-len BINARY-LONG.
01 seq-body PIC X(10).
01 fired BINARY-LONG.
01 give-keys BINARY-LONG.
01 n-god BINARY-LONG VALUE 0.
01 n-kfa BINARY-LONG VALUE 0.
01 n-fa BINARY-LONG VALUE 0.
01 n-clip BINARY-LONG VALUE 0.
01 n-pop BINARY-LONG VALUE 0.
01 god-seq PIC X(10) VALUE "iddqd".
01 kfa-seq PIC X(10) VALUE "idkfa".
01 fa-seq PIC X(10) VALUE "idfa".
01 clip-seq PIC X(10) VALUE "idclip".
01 pop-seq PIC X(10) VALUE "idspispopd".
01 beh-seq PIC X(10) VALUE "idbehold".
01 behv-seq PIC X(10) VALUE "idbeholdv".
01 behs-seq PIC X(10) VALUE "idbeholds".
01 behi-seq PIC X(10) VALUE "idbeholdi".
01 behr-seq PIC X(10) VALUE "idbeholdr".
01 beha-seq PIC X(10) VALUE "idbeholda".
01 behl-seq PIC X(10) VALUE "idbeholdl".
01 mus-seq PIC X(10) VALUE "idmus".
01 clev-seq PIC X(10) VALUE "idclev".
01 dt-seq PIC X(10) VALUE "iddt".
01 pos-seq PIC X(10) VALUE "idmypos".
01 chop-seq PIC X(10) VALUE "idchoppers".
01 n-beh BINARY-LONG VALUE 0.
01 n-behv BINARY-LONG VALUE 0.
01 n-behs BINARY-LONG VALUE 0.
01 n-behi BINARY-LONG VALUE 0.
01 n-behr BINARY-LONG VALUE 0.
01 n-beha BINARY-LONG VALUE 0.
01 n-behl BINARY-LONG VALUE 0.
01 n-mus BINARY-LONG VALUE 0.
01 n-clev BINARY-LONG VALUE 0.
01 n-dt BINARY-LONG VALUE 0.
01 n-pos BINARY-LONG VALUE 0.
01 n-chop BINARY-LONG VALUE 0.
01 grab-n BINARY-LONG VALUE 0.
01 grab-got BINARY-LONG VALUE 0.
01 par-a PIC X.
01 par-b PIC X.
01 digits PIC X(10) VALUE "0123456789".
01 lname PIC X(8).
01 lump-id BINARY-LONG.
01 sname PIC X(6).
01 loop-n BINARY-LONG.
01 map-num BINARY-LONG.
01 x-u BINARY-LONG.
01 y-u BINARY-LONG.
01 a-u BINARY-LONG.
01 x-pic PIC -ZZZZ9.
01 y-pic PIC -ZZZZ9.
01 a-pic PIC -ZZ9.
01 note-txt PIC X(40).

LINKAGE SECTION.
01 key-n BINARY-LONG.
01 did-out BINARY-LONG.

PROCEDURE DIVISION USING key-n did-out.
    MOVE 0 TO did-out
    IF ply-on = 0
        GOBACK
    END-IF
    IF key-n >= 97 AND key-n <= 122
        SUBTRACT 96 FROM key-n GIVING ix
        MOVE letters(ix:1) TO ch-c
    ELSE
        IF key-n >= 48 AND key-n <= 57
            SUBTRACT 47 FROM key-n GIVING ix
            MOVE digits(ix:1) TO ch-c
        ELSE
            GOBACK
        END-IF
    END-IF
    IF grab-n > 0
        PERFORM take-par
        GOBACK
    END-IF
    MOVE n-god TO seq-at
    MOVE god-seq TO seq-body
    MOVE 5 TO seq-len
    PERFORM feed-one
    MOVE seq-at TO n-god
    IF fired = 1
        PERFORM do-god
    END-IF
    MOVE n-kfa TO seq-at
    MOVE kfa-seq TO seq-body
    MOVE 5 TO seq-len
    PERFORM feed-one
    MOVE seq-at TO n-kfa
    IF fired = 1
        MOVE 1 TO give-keys
        PERFORM do-ammo
    END-IF
    MOVE n-fa TO seq-at
    MOVE fa-seq TO seq-body
    MOVE 4 TO seq-len
    PERFORM feed-one
    MOVE seq-at TO n-fa
    IF fired = 1
        MOVE 0 TO give-keys
        PERFORM do-ammo
    END-IF
    MOVE n-clip TO seq-at
    MOVE clip-seq TO seq-body
    MOVE 6 TO seq-len
    PERFORM feed-one
    MOVE seq-at TO n-clip
    IF fired = 1
        PERFORM do-clip
    END-IF
    MOVE n-pop TO seq-at
    MOVE pop-seq TO seq-body
    MOVE 10 TO seq-len
    PERFORM feed-one
    MOVE seq-at TO n-pop
    IF fired = 1
        PERFORM do-clip
    END-IF
    MOVE n-beh TO seq-at
    MOVE beh-seq TO seq-body
    MOVE 8 TO seq-len
    PERFORM feed-one
    MOVE seq-at TO n-beh
    IF fired = 1
        MOVE "INVIN VISIS RAD ALLMAP LITE AMP" TO note-txt
        PERFORM say-msg
    END-IF
    MOVE n-behv TO seq-at
    MOVE behv-seq TO seq-body
    MOVE 9 TO seq-len
    PERFORM feed-one
    MOVE seq-at TO n-behv
    IF fired = 1
        PERFORM tog-inv
    END-IF
    MOVE n-behs TO seq-at
    MOVE behs-seq TO seq-body
    MOVE 9 TO seq-len
    PERFORM feed-one
    MOVE seq-at TO n-behs
    IF fired = 1
        IF ply-str = 0
            IF ply-hp < 100
                MOVE 100 TO ply-hp
            END-IF
            MOVE 1 TO ply-str
            MOVE 1 TO ply-pend
        ELSE
            MOVE 0 TO ply-str
        END-IF
        MOVE "POWER-UP TOGGLED" TO note-txt
        PERFORM say-msg
    END-IF
    MOVE n-behi TO seq-at
    MOVE behi-seq TO seq-body
    MOVE 9 TO seq-len
    PERFORM feed-one
    MOVE seq-at TO n-behi
    IF fired = 1
        PERFORM tog-invis
    END-IF
    MOVE n-behr TO seq-at
    MOVE behr-seq TO seq-body
    MOVE 9 TO seq-len
    PERFORM feed-one
    MOVE seq-at TO n-behr
    IF fired = 1
        PERFORM tog-suit
    END-IF
    MOVE n-beha TO seq-at
    MOVE beha-seq TO seq-body
    MOVE 9 TO seq-len
    PERFORM feed-one
    MOVE seq-at TO n-beha
    IF fired = 1
        IF ply-amap = 0
            MOVE 1 TO ply-amap
            MOVE "COMPUTER AREA MAP" TO note-txt
        ELSE
            MOVE 0 TO ply-amap
            MOVE "MAP OFF" TO note-txt
        END-IF
        PERFORM say-msg
    END-IF
    MOVE n-behl TO seq-at
    MOVE behl-seq TO seq-body
    MOVE 9 TO seq-len
    PERFORM feed-one
    MOVE seq-at TO n-behl
    IF fired = 1
        PERFORM tog-lite
    END-IF
    MOVE n-mus TO seq-at
    MOVE mus-seq TO seq-body
    MOVE 5 TO seq-len
    PERFORM feed-one
    MOVE seq-at TO n-mus
    IF fired = 1
        MOVE 1 TO grab-n
        MOVE 0 TO grab-got
    END-IF
    MOVE n-clev TO seq-at
    MOVE clev-seq TO seq-body
    MOVE 6 TO seq-len
    PERFORM feed-one
    MOVE seq-at TO n-clev
    IF fired = 1
        MOVE 2 TO grab-n
        MOVE 0 TO grab-got
    END-IF
    MOVE n-dt TO seq-at
    MOVE dt-seq TO seq-body
    MOVE 4 TO seq-len
    PERFORM feed-one
    MOVE seq-at TO n-dt
    IF fired = 1
        ADD 1 TO ply-iddt
        IF ply-iddt > 2
            MOVE 0 TO ply-iddt
        END-IF
        MOVE 1 TO ply-mapon
        IF ply-iddt = 1
            MOVE "MAP ALL" TO note-txt
        END-IF
        IF ply-iddt = 2
            MOVE "MAP THINGS" TO note-txt
        END-IF
        IF ply-iddt = 0
            MOVE "MAP NORMAL" TO note-txt
        END-IF
        PERFORM say-msg
    END-IF
    MOVE n-pos TO seq-at
    MOVE pos-seq TO seq-body
    MOVE 7 TO seq-len
    PERFORM feed-one
    MOVE seq-at TO n-pos
    IF fired = 1
        PERFORM do-pos
    END-IF
    MOVE n-chop TO seq-at
    MOVE chop-seq TO seq-body
    MOVE 10 TO seq-len
    PERFORM feed-one
    MOVE seq-at TO n-chop
    IF fired = 1
        MOVE 1 TO ply-saw
        MOVE 8 TO ply-pend
        MOVE "DOESNT SUCK - GM" TO note-txt
        PERFORM say-msg
    END-IF
    GOBACK.

feed-one.
    MOVE 0 TO fired
    ADD 1 TO seq-at
    IF seq-at >= 1 AND seq-at <= seq-len
        AND seq-body(seq-at:1) = ch-c
        CONTINUE
    ELSE
        IF seq-body(1:1) = ch-c
            MOVE 1 TO seq-at
        ELSE
            MOVE 0 TO seq-at
        END-IF
    END-IF
    IF seq-at = seq-len
        MOVE 1 TO fired
        MOVE 0 TO seq-at
    END-IF
    .

do-god.
    IF ply-god = 0
        MOVE 1 TO ply-god
        MOVE 100 TO ply-hp
        MOVE 2686976 TO ply-vh
        MOVE 0 TO ply-dvh
    ELSE
        MOVE 0 TO ply-god
    END-IF
    MOVE 1 TO did-out
    .

do-ammo.
    MOVE 1 TO ply-sg
    MOVE 1 TO ply-cg
    MOVE 1 TO ply-rl
    MOVE 1 TO ply-pg
    MOVE 1 TO ply-bf
    MOVE 1 TO ply-saw
    MOVE ply-maxc TO ply-ammo
    MOVE ply-maxs TO ply-shell
    MOVE ply-maxe TO ply-cell
    MOVE ply-maxr TO ply-misl
    MOVE 200 TO ply-armor
    MOVE 2 TO ply-atype
    IF give-keys = 1
        MOVE 1 TO ply-k0
        MOVE 1 TO ply-k1
        MOVE 1 TO ply-k2
        MOVE 1 TO ply-k3
        MOVE 1 TO ply-k4
        MOVE 1 TO ply-k5
    END-IF
    MOVE 1 TO did-out
    .

do-clip.
    IF ply-clip = 0
        MOVE 1 TO ply-clip
    ELSE
        MOVE 0 TO ply-clip
    END-IF
    MOVE 1 TO did-out
    .

say-msg.
    MOVE note-txt TO ply-msg
    MOVE 140 TO ply-msgn
    MOVE 1 TO did-out
    .

tog-inv.
    IF ply-inv > 0
        MOVE 0 TO ply-inv
    ELSE
        MOVE 1050 TO ply-inv
    END-IF
    MOVE "POWER-UP TOGGLED" TO note-txt
    PERFORM say-msg
    .

tog-suit.
    IF ply-suit > 0
        MOVE 0 TO ply-suit
    ELSE
        MOVE 1050 TO ply-suit
    END-IF
    MOVE "POWER-UP TOGGLED" TO note-txt
    PERFORM say-msg
    .

tog-lite.
    IF ply-lite > 0
        MOVE 0 TO ply-lite
    ELSE
        MOVE 1050 TO ply-lite
    END-IF
    MOVE "POWER-UP TOGGLED" TO note-txt
    PERFORM say-msg
    .

tog-invis.
    IF ply-invis > 0
        MOVE 0 TO ply-invis
    ELSE
        MOVE 1050 TO ply-invis
    END-IF
    MOVE "POWER-UP TOGGLED" TO note-txt
    PERFORM say-msg
    .

take-par.
    IF ch-c < "0" OR ch-c > "9"
        MOVE 0 TO grab-n
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO grab-got
    IF grab-got = 1
        MOVE ch-c TO par-a
        EXIT PARAGRAPH
    END-IF
    MOVE ch-c TO par-b
    IF grab-n = 1
        PERFORM do-mus
    ELSE
        PERFORM do-clev
    END-IF
    MOVE 0 TO grab-n
    .

do-mus.
    MOVE "MAP01" TO lname
    CALL "wad-find" USING lname lump-id
    IF lump-id >= 0
        PERFORM mus-pack
    ELSE
        PERFORM mus-ep
    END-IF
    .

mus-ep.
    IF par-a < "1" OR par-a > "4" OR par-b < "1" OR par-b > "9"
        MOVE "IMPOSSIBLE SELECTION" TO note-txt
        PERFORM say-msg
        EXIT PARAGRAPH
    END-IF
    MOVE SPACES TO lname
    MOVE "D_E" TO lname(1:3)
    MOVE par-a TO lname(4:1)
    MOVE "M" TO lname(5:1)
    MOVE par-b TO lname(6:1)
    CALL "wad-find" USING lname lump-id
    IF lump-id < 0
        MOVE "IMPOSSIBLE SELECTION" TO note-txt
        PERFORM say-msg
        EXIT PARAGRAPH
    END-IF
    MOVE SPACES TO sname
    MOVE "e" TO sname(1:1)
    MOVE par-a TO sname(2:1)
    MOVE "m" TO sname(3:1)
    MOVE par-b TO sname(4:1)
    MOVE 1 TO loop-n
    CALL "mus-play" USING sname loop-n
    MOVE "MUSIC CHANGE" TO note-txt
    PERFORM say-msg
    .

mus-pack.
    PERFORM pack-num
    IF map-num < 1 OR map-num > 32
        MOVE "IMPOSSIBLE SELECTION" TO note-txt
        PERFORM say-msg
        EXIT PARAGRAPH
    END-IF
    MOVE "MAP00" TO lname
    MOVE par-a TO lname(4:1)
    MOVE par-b TO lname(5:1)
    CALL "mus-level" USING lname
    MOVE "MUSIC CHANGE" TO note-txt
    PERFORM say-msg
    .

do-clev.
    MOVE "MAP01" TO lname
    CALL "wad-find" USING lname lump-id
    IF lump-id >= 0
        PERFORM clev-pack
    ELSE
        PERFORM clev-ep
    END-IF
    .

clev-ep.
    IF par-a < "1" OR par-a > "4" OR par-b < "1" OR par-b > "9"
        MOVE "IMPOSSIBLE SELECTION" TO note-txt
        PERFORM say-msg
        EXIT PARAGRAPH
    END-IF
    MOVE "E0M0" TO lname
    MOVE par-a TO lname(2:1)
    MOVE par-b TO lname(4:1)
    CALL "wad-find" USING lname lump-id
    IF lump-id < 0
        MOVE "IMPOSSIBLE SELECTION" TO note-txt
        PERFORM say-msg
        EXIT PARAGRAPH
    END-IF
    MOVE lname TO ply-dest
    MOVE 1 TO ply-warp
    MOVE "CHANGING LEVEL" TO note-txt
    PERFORM say-msg
    .

clev-pack.
    PERFORM pack-num
    IF map-num < 1 OR map-num > 32
        MOVE "IMPOSSIBLE SELECTION" TO note-txt
        PERFORM say-msg
        EXIT PARAGRAPH
    END-IF
    MOVE "MAP00" TO lname
    MOVE par-a TO lname(4:1)
    MOVE par-b TO lname(5:1)
    CALL "wad-find" USING lname lump-id
    IF lump-id < 0
        MOVE "IMPOSSIBLE SELECTION" TO note-txt
        PERFORM say-msg
        EXIT PARAGRAPH
    END-IF
    MOVE lname TO ply-dest
    MOVE 1 TO ply-warp
    MOVE "CHANGING LEVEL" TO note-txt
    PERFORM say-msg
    .

pack-num.
    IF par-a = "1"
        MOVE 10 TO map-num
    ELSE
        IF par-a = "2"
            MOVE 20 TO map-num
        ELSE
            IF par-a = "3"
                MOVE 30 TO map-num
            ELSE
                MOVE 0 TO map-num
            END-IF
        END-IF
    END-IF
    IF par-b = "1"
        ADD 1 TO map-num
    END-IF
    IF par-b = "2"
        ADD 2 TO map-num
    END-IF
    IF par-b = "3"
        ADD 3 TO map-num
    END-IF
    IF par-b = "4"
        ADD 4 TO map-num
    END-IF
    IF par-b = "5"
        ADD 5 TO map-num
    END-IF
    IF par-b = "6"
        ADD 6 TO map-num
    END-IF
    IF par-b = "7"
        ADD 7 TO map-num
    END-IF
    IF par-b = "8"
        ADD 8 TO map-num
    END-IF
    IF par-b = "9"
        ADD 9 TO map-num
    END-IF
    .

do-pos.
    DIVIDE ply-x BY 65536 GIVING x-u
    DIVIDE ply-y BY 65536 GIVING y-u
    DIVIDE ply-ang BY 11930464 GIVING a-u
    IF a-u < 0
        ADD 360 TO a-u
    END-IF
    MOVE x-u TO x-pic
    MOVE y-u TO y-pic
    MOVE a-u TO a-pic
    MOVE SPACES TO ply-msg
    STRING "X=" FUNCTION TRIM(x-pic)
        " Y=" FUNCTION TRIM(y-pic)
        " A=" FUNCTION TRIM(a-pic)
        INTO ply-msg
    END-STRING
    MOVE 140 TO ply-msgn
    MOVE 1 TO did-out
    .

END PROGRAM cheat-feed.

IDENTIFICATION DIVISION.
PROGRAM-ID. msg-stamp.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 lname PIC X(8).
01 lump-id BINARY-LONG.
01 patch PIC X(8192).
01 cap-n BINARY-LONG VALUE 8192.
01 nread BINARY-LONG.
01 ink-n BINARY-LONG.
01 ch-i BINARY-LONG.
01 msg-n BINARY-LONG.
01 code-n BINARY-LONG.
01 pen-x BINARY-LONG.
01 pen-y BINARY-LONG VALUE 2.
01 glyph-w BINARY-LONG.
01 tens-n BINARY-LONG.
01 ones-n BINARY-LONG.
01 ch-c PIC X.

LINKAGE SECTION.
01 fb PIC X(64000).
01 msg PIC X(40).

PROCEDURE DIVISION USING fb msg.
    MOVE FUNCTION LENGTH(FUNCTION TRIM(msg)) TO msg-n
    IF msg-n < 1
        GOBACK
    END-IF
    IF msg-n > 40
        MOVE 40 TO msg-n
    END-IF
    MOVE 4 TO pen-x
    PERFORM VARYING ch-i FROM 1 BY 1 UNTIL ch-i > msg-n
        MOVE msg(ch-i:1) TO ch-c
        PERFORM one-glyph
        ADD glyph-w TO pen-x
    END-PERFORM
    GOBACK.

one-glyph.
    MOVE 4 TO glyph-w
    IF ch-c = " "
        EXIT PARAGRAPH
    END-IF
    MOVE 0 TO code-n
    IF ch-c = "-"
        MOVE 45 TO code-n
    END-IF
    IF ch-c >= "0" AND ch-c <= "9"
        COMPUTE code-n = 48 + FUNCTION ORD(ch-c) - FUNCTION ORD("0")
    END-IF
    IF ch-c >= "A" AND ch-c <= "Z"
        COMPUTE code-n = 65 + FUNCTION ORD(ch-c) - FUNCTION ORD("A")
    END-IF
    IF code-n = 0
        EXIT PARAGRAPH
    END-IF
    MOVE "STCFN000" TO lname
    DIVIDE code-n BY 100 GIVING tens-n REMAINDER ones-n
    IF tens-n = 1
        MOVE "1" TO lname(6:1)
    END-IF
    DIVIDE ones-n BY 10 GIVING tens-n REMAINDER ones-n
    EVALUATE tens-n
        WHEN 1 MOVE "1" TO lname(7:1)
        WHEN 2 MOVE "2" TO lname(7:1)
        WHEN 3 MOVE "3" TO lname(7:1)
        WHEN 4 MOVE "4" TO lname(7:1)
        WHEN 5 MOVE "5" TO lname(7:1)
        WHEN 6 MOVE "6" TO lname(7:1)
        WHEN 7 MOVE "7" TO lname(7:1)
        WHEN 8 MOVE "8" TO lname(7:1)
        WHEN 9 MOVE "9" TO lname(7:1)
        WHEN OTHER MOVE "0" TO lname(7:1)
    END-EVALUATE
    EVALUATE ones-n
        WHEN 1 MOVE "1" TO lname(8:1)
        WHEN 2 MOVE "2" TO lname(8:1)
        WHEN 3 MOVE "3" TO lname(8:1)
        WHEN 4 MOVE "4" TO lname(8:1)
        WHEN 5 MOVE "5" TO lname(8:1)
        WHEN 6 MOVE "6" TO lname(8:1)
        WHEN 7 MOVE "7" TO lname(8:1)
        WHEN 8 MOVE "8" TO lname(8:1)
        WHEN 9 MOVE "9" TO lname(8:1)
        WHEN OTHER MOVE "0" TO lname(8:1)
    END-EVALUATE
    CALL "wad-find" USING lname lump-id
    IF lump-id < 0
        EXIT PARAGRAPH
    END-IF
    CALL "wad-read-num" USING lump-id patch cap-n nread
    IF nread < 8
        EXIT PARAGRAPH
    END-IF
    CALL "i16_le" USING BY REFERENCE patch BY VALUE 0 RETURNING glyph-w
    IF glyph-w < 1
        MOVE 4 TO glyph-w
    END-IF
    CALL "v-draw-patch" USING fb patch nread ink-n pen-x pen-y
    .

END PROGRAM msg-stamp.
