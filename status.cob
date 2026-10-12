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
*> Barra de status. Vida, municao, armadura e a cara, que reage ao golpe.
IDENTIFICATION DIVISION.
PROGRAM-ID. status-draw.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "playstate.cpy".
01 bar-on BINARY-LONG VALUE 0.
01 seek-name PIC X(8).
01 num-chars PIC X(10) VALUE "0123456789".
01 patch-buf PIC X(65536).
01 cap-n BINARY-LONG.
01 lump-id BINARY-LONG.
01 got-n BINARY-LONG.
01 bar-img PIC X(65536).
01 bar-len BINARY-LONG VALUE 0.
01 arms-img PIC X(32768).
01 arms-len BINARY-LONG VALUE 0.
01 tall-img PIC X(8192) OCCURS 10 TIMES.
01 dig-len BINARY-LONG OCCURS 10 TIMES VALUE 0.
01 tall-w BINARY-LONG VALUE 0.
01 short-img PIC X(4096) OCCURS 10 TIMES.
01 short-len BINARY-LONG OCCURS 10 TIMES VALUE 0.
01 short-w BINARY-LONG VALUE 0.
01 pct-img PIC X(4096).
01 pct-len BINARY-LONG VALUE 0.
01 face-img PIC X(8192) OCCURS 6 TIMES.
01 face-len BINARY-LONG OCCURS 6 TIMES VALUE 0.
01 tr-img PIC X(8192) OCCURS 5 TIMES.
01 tr-len BINARY-LONG OCCURS 5 TIMES VALUE 0.
01 tl-img PIC X(8192) OCCURS 5 TIMES.
01 tl-len BINARY-LONG OCCURS 5 TIMES VALUE 0.
01 ouch-img PIC X(8192) OCCURS 5 TIMES.
01 ouch-len BINARY-LONG OCCURS 5 TIMES VALUE 0.
01 kill-img PIC X(8192) OCCURS 5 TIMES.
01 kill-len BINARY-LONG OCCURS 5 TIMES VALUE 0.
01 god-img PIC X(8192).
01 god-len BINARY-LONG VALUE 0.
01 face-pick PIC X(8192).
01 pick-len BINARY-LONG.
01 gnum-img PIC X(4096) OCCURS 6 TIMES.
01 gnum-len BINARY-LONG OCCURS 6 TIMES VALUE 0.
01 key-img PIC X(4096) OCCURS 6 TIMES.
01 key-len BINARY-LONG OCCURS 6 TIMES VALUE 0.
01 have-n BINARY-LONG.
01 ink-n BINARY-LONG.
01 dig-i BINARY-LONG.
01 gi BINARY-LONG.
01 ch-at BINARY-LONG.
01 slot-n BINARY-LONG.
01 num-v BINARY-LONG.
01 work-v BINARY-LONG.
01 rem-d BINARY-LONG.
01 cur-x BINARY-LONG.
01 pen-x BINARY-LONG.
01 pen-y BINARY-LONG.
01 hp-n BINARY-LONG.
01 span-n BINARY-LONG.
01 span-b BINARY-LONG.
01 pain-n BINARY-LONG.
01 band-n BINARY-LONG.

LINKAGE SECTION.
01 fb PIC X(64000).

PROCEDURE DIVISION USING fb.
    PERFORM main-status
    GOBACK.

main-status.
    IF ply-blocks >= 11
        GOBACK
    END-IF
    IF bar-on = 0
        PERFORM load-bar
        MOVE 1 TO bar-on
    END-IF
    IF bar-len >= 8
        MOVE 0 TO cur-x
        MOVE 168 TO pen-y
        CALL "v-draw-patch" USING fb bar-img bar-len ink-n cur-x pen-y
    END-IF
    IF arms-len >= 8
        MOVE 104 TO cur-x
        MOVE 168 TO pen-y
        CALL "v-draw-patch" USING fb arms-img arms-len ink-n cur-x pen-y
    END-IF
    MOVE 44 TO pen-x
    MOVE 171 TO pen-y
    MOVE ply-ammo TO num-v
    IF ply-weap = 3
        MOVE ply-shell TO num-v
    END-IF
    IF ply-weap = 5
        MOVE ply-misl TO num-v
    END-IF
    IF ply-weap = 6 OR ply-weap = 7
        MOVE ply-cell TO num-v
    END-IF
    IF ply-weap = 1 OR ply-weap = 8
        MOVE 0 TO num-v
    END-IF
    PERFORM draw-tall
    MOVE 90 TO pen-x
    MOVE 171 TO pen-y
    MOVE ply-hp TO num-v
    PERFORM draw-tall
    IF pct-len >= 8
        MOVE 90 TO cur-x
        MOVE 171 TO pen-y
        CALL "v-draw-patch" USING fb pct-img pct-len ink-n cur-x pen-y
    END-IF
    MOVE 221 TO pen-x
    MOVE 171 TO pen-y
    MOVE ply-armor TO num-v
    PERFORM draw-tall
    IF pct-len >= 8
        MOVE 221 TO cur-x
        MOVE 171 TO pen-y
        CALL "v-draw-patch" USING fb pct-img pct-len ink-n cur-x pen-y
    END-IF
    PERFORM draw-arms
    PERFORM draw-face
    PERFORM draw-keys
    MOVE 288 TO pen-x
    MOVE 173 TO pen-y
    MOVE ply-ammo TO num-v
    PERFORM draw-short
    MOVE 314 TO pen-x
    MOVE 173 TO pen-y
    MOVE ply-maxc TO num-v
    PERFORM draw-short
    MOVE 288 TO pen-x
    MOVE 179 TO pen-y
    MOVE ply-shell TO num-v
    PERFORM draw-short
    MOVE 314 TO pen-x
    MOVE 179 TO pen-y
    MOVE ply-maxs TO num-v
    PERFORM draw-short
    MOVE 288 TO pen-x
    MOVE 191 TO pen-y
    MOVE ply-cell TO num-v
    PERFORM draw-short
    MOVE 314 TO pen-x
    MOVE 191 TO pen-y
    MOVE ply-maxe TO num-v
    PERFORM draw-short
    MOVE 288 TO pen-x
    MOVE 185 TO pen-y
    MOVE ply-misl TO num-v
    PERFORM draw-short
    MOVE 314 TO pen-x
    MOVE 185 TO pen-y
    MOVE ply-maxr TO num-v
    PERFORM draw-short
    .

load-bar.
    MOVE "STBAR" TO seek-name
    PERFORM load-named
    IF got-n > 0 AND got-n <= 65536
        MOVE patch-buf(1:got-n) TO bar-img(1:got-n)
        MOVE got-n TO bar-len
    END-IF
    MOVE "STARMS" TO seek-name
    PERFORM load-named
    IF got-n > 0 AND got-n <= 32768
        MOVE patch-buf(1:got-n) TO arms-img(1:got-n)
        MOVE got-n TO arms-len
    END-IF
    MOVE "STTPRCNT" TO seek-name
    PERFORM load-named
    IF got-n > 0 AND got-n <= 4096
        MOVE patch-buf(1:got-n) TO pct-img(1:got-n)
        MOVE got-n TO pct-len
    END-IF
    PERFORM VARYING dig-i FROM 0 BY 1 UNTIL dig-i > 9
        MOVE "STTNUM0" TO seek-name
        COMPUTE ch-at = dig-i + 1
        MOVE num-chars(ch-at:1) TO seek-name(7:1)
        PERFORM load-named
        ADD 1 TO dig-i GIVING slot-n
        IF got-n > 0 AND got-n <= 8192
            MOVE patch-buf(1:got-n) TO tall-img(slot-n)(1:got-n)
            MOVE got-n TO dig-len(slot-n)
        END-IF
        MOVE "STYSNUM0" TO seek-name
        MOVE num-chars(ch-at:1) TO seek-name(7:1)
        PERFORM load-named
        IF got-n > 0 AND got-n <= 4096
            MOVE patch-buf(1:got-n) TO short-img(slot-n)(1:got-n)
            MOVE got-n TO short-len(slot-n)
        END-IF
    END-PERFORM
    IF dig-len(1) >= 8
        CALL "i16_le" USING BY REFERENCE tall-img(1) BY VALUE 0
            RETURNING tall-w
    END-IF
    IF tall-w < 1
        MOVE 0 TO tall-w
    END-IF
    IF short-len(1) >= 8
        CALL "i16_le" USING BY REFERENCE short-img(1) BY VALUE 0
            RETURNING short-w
    END-IF
    IF short-w < 1
        MOVE 0 TO short-w
    END-IF
    PERFORM VARYING pain-n FROM 0 BY 1 UNTIL pain-n > 4
        MOVE "STFST00" TO seek-name
        COMPUTE ch-at = pain-n + 1
        MOVE num-chars(ch-at:1) TO seek-name(6:1)
        PERFORM load-named
        ADD 1 TO pain-n GIVING slot-n
        IF got-n > 0 AND got-n <= 8192
            MOVE patch-buf(1:got-n) TO face-img(slot-n)(1:got-n)
            MOVE got-n TO face-len(slot-n)
        END-IF
    END-PERFORM
    MOVE "STFDEAD0" TO seek-name
    PERFORM load-named
    IF got-n > 0 AND got-n <= 8192
        MOVE patch-buf(1:got-n) TO face-img(6)(1:got-n)
        MOVE got-n TO face-len(6)
    END-IF
    PERFORM VARYING pain-n FROM 0 BY 1 UNTIL pain-n > 4
        ADD 1 TO pain-n GIVING slot-n
        COMPUTE ch-at = pain-n + 1
        MOVE "STFTR00" TO seek-name
        MOVE num-chars(ch-at:1) TO seek-name(6:1)
        PERFORM load-named
        IF got-n > 0 AND got-n <= 8192
            MOVE patch-buf(1:got-n) TO tr-img(slot-n)(1:got-n)
            MOVE got-n TO tr-len(slot-n)
        END-IF
        MOVE "STFTL00" TO seek-name
        MOVE num-chars(ch-at:1) TO seek-name(6:1)
        PERFORM load-named
        IF got-n > 0 AND got-n <= 8192
            MOVE patch-buf(1:got-n) TO tl-img(slot-n)(1:got-n)
            MOVE got-n TO tl-len(slot-n)
        END-IF
        MOVE "STFOUCH0" TO seek-name
        MOVE num-chars(ch-at:1) TO seek-name(8:1)
        PERFORM load-named
        IF got-n > 0 AND got-n <= 8192
            MOVE patch-buf(1:got-n) TO ouch-img(slot-n)(1:got-n)
            MOVE got-n TO ouch-len(slot-n)
        END-IF
        MOVE "STFKILL0" TO seek-name
        MOVE num-chars(ch-at:1) TO seek-name(8:1)
        PERFORM load-named
        IF got-n > 0 AND got-n <= 8192
            MOVE patch-buf(1:got-n) TO kill-img(slot-n)(1:got-n)
            MOVE got-n TO kill-len(slot-n)
        END-IF
    END-PERFORM
    MOVE "STFGOD0" TO seek-name
    PERFORM load-named
    IF got-n > 0 AND got-n <= 8192
        MOVE patch-buf(1:got-n) TO god-img(1:got-n)
        MOVE got-n TO god-len
    END-IF
    PERFORM VARYING gi FROM 0 BY 1 UNTIL gi > 5
        MOVE "STKEYS0" TO seek-name
        COMPUTE ch-at = gi + 1
        MOVE num-chars(ch-at:1) TO seek-name(7:1)
        PERFORM load-named
        ADD 1 TO gi GIVING slot-n
        IF got-n > 0 AND got-n <= 4096
            MOVE patch-buf(1:got-n) TO key-img(slot-n)(1:got-n)
            MOVE got-n TO key-len(slot-n)
        END-IF
    END-PERFORM
    PERFORM VARYING gi FROM 0 BY 1 UNTIL gi > 5
        MOVE "STGNUM2" TO seek-name
        COMPUTE ch-at = gi + 3
        MOVE num-chars(ch-at:1) TO seek-name(7:1)
        PERFORM load-named
        ADD 1 TO gi GIVING slot-n
        IF got-n > 0 AND got-n <= 4096
            MOVE patch-buf(1:got-n) TO gnum-img(slot-n)(1:got-n)
            MOVE got-n TO gnum-len(slot-n)
        END-IF
    END-PERFORM
    .

load-named.
    CALL "wad-find" USING seek-name lump-id
    IF lump-id < 0
        MOVE 0 TO got-n
    ELSE
        MOVE 65536 TO cap-n
        CALL "wad-read-num" USING lump-id patch-buf cap-n got-n
        IF got-n < 8
            MOVE 0 TO got-n
        END-IF
    END-IF
    .

draw-tall.
    IF tall-w < 1
        EXIT PARAGRAPH
    END-IF
    IF num-v < 0
        MOVE 0 TO num-v
    END-IF
    IF num-v > 999
        MOVE 999 TO num-v
    END-IF
    MOVE pen-x TO cur-x
    PERFORM 3 TIMES
        MOVE num-v TO work-v
        DIVIDE work-v BY 10 GIVING num-v REMAINDER rem-d
        ADD 1 TO rem-d GIVING slot-n
        SUBTRACT tall-w FROM cur-x
        IF dig-len(slot-n) >= 8
            CALL "v-draw-patch" USING fb tall-img(slot-n)
                dig-len(slot-n) ink-n cur-x pen-y
        END-IF
        IF num-v = 0
            EXIT PERFORM
        END-IF
    END-PERFORM
    .

draw-short.
    IF short-w < 1
        EXIT PARAGRAPH
    END-IF
    IF num-v < 0
        MOVE 0 TO num-v
    END-IF
    IF num-v > 999
        MOVE 999 TO num-v
    END-IF
    MOVE pen-x TO cur-x
    PERFORM 3 TIMES
        MOVE num-v TO work-v
        DIVIDE work-v BY 10 GIVING num-v REMAINDER rem-d
        ADD 1 TO rem-d GIVING slot-n
        SUBTRACT short-w FROM cur-x
        IF short-len(slot-n) >= 8
            CALL "v-draw-patch" USING fb short-img(slot-n)
                short-len(slot-n) ink-n cur-x pen-y
        END-IF
        IF num-v = 0
            EXIT PERFORM
        END-IF
    END-PERFORM
    .

draw-arms.
    PERFORM VARYING gi FROM 0 BY 1 UNTIL gi > 5
        COMPUTE cur-x = 111 + FUNCTION MOD(gi, 3) * 12
        DIVIDE gi BY 3 GIVING band-n
        COMPUTE pen-y = 172 + band-n * 10
        ADD 1 TO gi GIVING slot-n
        MOVE 0 TO have-n
        IF gi = 0 AND ply-sg = 1
            MOVE 1 TO have-n
        END-IF
        IF gi = 1 AND ply-cg = 1
            MOVE 1 TO have-n
        END-IF
        IF gi = 2 AND ply-rl = 1
            MOVE 1 TO have-n
        END-IF
        IF gi = 3 AND ply-pg = 1
            MOVE 1 TO have-n
        END-IF
        IF gi = 4 AND ply-bf = 1
            MOVE 1 TO have-n
        END-IF
        IF have-n = 1
            ADD 3 TO gi GIVING slot-n
            IF short-len(slot-n) >= 8
                CALL "v-draw-patch" USING fb short-img(slot-n)
                    short-len(slot-n) ink-n cur-x pen-y
            END-IF
        ELSE
            IF gnum-len(slot-n) >= 8
                CALL "v-draw-patch" USING fb gnum-img(slot-n)
                    gnum-len(slot-n) ink-n cur-x pen-y
            END-IF
        END-IF
    END-PERFORM
    .

draw-keys.
    MOVE 0 TO slot-n
    IF ply-k3 = 1
        MOVE 4 TO slot-n
    ELSE
        IF ply-k0 = 1
            MOVE 1 TO slot-n
        END-IF
    END-IF
    IF slot-n > 0
        MOVE 239 TO cur-x
        MOVE 171 TO pen-y
        PERFORM paint-key
    END-IF
    MOVE 0 TO slot-n
    IF ply-k4 = 1
        MOVE 5 TO slot-n
    ELSE
        IF ply-k1 = 1
            MOVE 2 TO slot-n
        END-IF
    END-IF
    IF slot-n > 0
        MOVE 239 TO cur-x
        MOVE 181 TO pen-y
        PERFORM paint-key
    END-IF
    MOVE 0 TO slot-n
    IF ply-k5 = 1
        MOVE 6 TO slot-n
    ELSE
        IF ply-k2 = 1
            MOVE 3 TO slot-n
        END-IF
    END-IF
    IF slot-n > 0
        MOVE 239 TO cur-x
        MOVE 191 TO pen-y
        PERFORM paint-key
    END-IF
    .

paint-key.
    IF key-len(slot-n) >= 8
        CALL "v-draw-patch" USING fb key-img(slot-n)
            key-len(slot-n) ink-n cur-x pen-y
    END-IF
    .

draw-face.
    IF ply-hp <= 0
        MOVE 6 TO slot-n
        MOVE face-len(slot-n) TO pick-len
        IF pick-len >= 8
            MOVE face-img(slot-n) TO face-pick
        END-IF
    ELSE
        MOVE ply-hp TO hp-n
        IF hp-n > 100
            MOVE 100 TO hp-n
        END-IF
        SUBTRACT hp-n FROM 100 GIVING span-n
        MULTIPLY span-n BY 5 GIVING span-b
        DIVIDE span-b BY 101 GIVING pain-n
        ADD 1 TO pain-n GIVING slot-n
        IF slot-n < 1 OR slot-n > 5
            MOVE 1 TO slot-n
        END-IF
        MOVE face-len(slot-n) TO pick-len
        IF pick-len >= 8
            MOVE face-img(slot-n) TO face-pick
        END-IF
        IF ply-fwait > 0 AND ply-fkind = 1
            AND tr-len(slot-n) >= 8
            MOVE tr-len(slot-n) TO pick-len
            MOVE tr-img(slot-n) TO face-pick
        END-IF
        IF ply-fwait > 0 AND ply-fkind = 2
            AND tl-len(slot-n) >= 8
            MOVE tl-len(slot-n) TO pick-len
            MOVE tl-img(slot-n) TO face-pick
        END-IF
        IF ply-fwait > 0 AND ply-fkind = 3
            AND ouch-len(slot-n) >= 8
            MOVE ouch-len(slot-n) TO pick-len
            MOVE ouch-img(slot-n) TO face-pick
        END-IF
        IF ply-fwait > 0 AND ply-fkind = 4
            AND kill-len(slot-n) >= 8
            MOVE kill-len(slot-n) TO pick-len
            MOVE kill-img(slot-n) TO face-pick
        END-IF
        IF ply-god = 1 AND ply-fwait = 0 AND god-len >= 8
            MOVE god-len TO pick-len
            MOVE god-img TO face-pick
        END-IF
    END-IF
    IF pick-len >= 8
        MOVE 143 TO cur-x
        MOVE 168 TO pen-y
        CALL "v-draw-patch" USING fb face-pick
            pick-len ink-n cur-x pen-y
    END-IF
    .

END PROGRAM status-draw.

IDENTIFICATION DIVISION.
PROGRAM-ID. face-hit.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "playstate.cpy".
01 aim-ang BINARY-LONG.
01 diff-ang BINARY-LONG.
01 turn-r BINARY-LONG.
01 ang-45 BINARY-LONG VALUE 536870912.
01 ang-180 BINARY-LONG.

LINKAGE SECTION.
01 hit-n BINARY-LONG.
01 atk-on BINARY-LONG.
01 atk-x BINARY-LONG.
01 atk-y BINARY-LONG.

PROCEDURE DIVISION USING hit-n atk-on atk-x atk-y.
    IF hit-n <= 0
        GOBACK
    END-IF
    CALL "k_ang180" RETURNING ang-180
    MOVE 35 TO ply-fwait
    MOVE 4 TO ply-fkind
    CALL "sub_i32" USING BY VALUE ply-hp BY VALUE ply-oldh
        RETURNING diff-ang
    IF diff-ang > 20
        MOVE 3 TO ply-fkind
    ELSE
        IF atk-on = 1
            PERFORM look-at
        END-IF
    END-IF
    MOVE ply-hp TO ply-oldh
    GOBACK.

look-at.
    CALL "point_to_angle" USING
        BY VALUE ply-x BY VALUE ply-y
        BY VALUE atk-x BY VALUE atk-y
        RETURNING aim-ang
    CALL "ugt_u32" USING BY VALUE aim-ang BY VALUE ply-ang
        RETURNING turn-r
    IF turn-r = 1
        CALL "sub_i32" USING BY VALUE aim-ang BY VALUE ply-ang
            RETURNING diff-ang
        CALL "ugt_u32" USING BY VALUE diff-ang BY VALUE ang-180
            RETURNING turn-r
    ELSE
        CALL "sub_i32" USING BY VALUE ply-ang BY VALUE aim-ang
            RETURNING diff-ang
        CALL "ugt_u32" USING BY VALUE diff-ang BY VALUE ang-180
            RETURNING turn-r
        IF turn-r = 1
            MOVE 0 TO turn-r
        ELSE
            MOVE 1 TO turn-r
        END-IF
    END-IF
    CALL "ugt_u32" USING BY VALUE ang-45 BY VALUE diff-ang
        RETURNING aim-ang
    IF aim-ang = 1
        MOVE 4 TO ply-fkind
    ELSE
        IF turn-r = 1
            MOVE 1 TO ply-fkind
        ELSE
            MOVE 2 TO ply-fkind
        END-IF
    END-IF
    .

END PROGRAM face-hit.
