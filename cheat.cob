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
*> Cheats digitados: iddqd, idkfa, idfa, idclip e idspispopd.
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

LINKAGE SECTION.
01 key-n BINARY-LONG.
01 did-out BINARY-LONG.

PROCEDURE DIVISION USING key-n did-out.
    MOVE 0 TO did-out
    IF ply-on = 0
        GOBACK
    END-IF
    IF key-n < 97 OR key-n > 122
        GOBACK
    END-IF
    SUBTRACT 96 FROM key-n GIVING ix
    MOVE letters(ix:1) TO ch-c
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

END PROGRAM cheat-feed.
