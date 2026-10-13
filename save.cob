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
*> Seis slots doomsav0.dsg a doomsav5.dsg. Grava jogador, bichos,
*> alturas, interruptores e o que ainda esta se movendo.
IDENTIFICATION DIVISION.
PROGRAM-ID. slot-act.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "mapstate.cpy".
COPY "playstate.cpy".
COPY "sprstate.cpy".
COPY "movstate.cpy".
01 path-txt PIC X(32).
01 line-buf PIC X(900).
01 ptr BINARY-LONG.
01 show-n PIC -(11)9.
01 tok PIC X(16).
01 num-v BINARY-LONG.
01 io-rc BINARY-LONG.
01 bad-n BINARY-LONG.
01 ti BINARY-LONG.
01 i BINARY-LONG.
01 act-mode BINARY-LONG.
01 busy-n BINARY-LONG.
01 moved-n BINARY-LONG.
01 n-lines BINARY-LONG.
01 n-verts BINARY-LONG.
01 want-map PIC X(8).
01 asked-map PIC X(8).
01 hold-n BINARY-LONG.

LINKAGE SECTION.
01 cmd BINARY-LONG.
01 slot-n BINARY-LONG.
01 rc BINARY-LONG.
01 out-map PIC X(8).
01 out-desc PIC X(24).

PROCEDURE DIVISION USING cmd slot-n rc out-map out-desc.
    MOVE 1 TO rc
    IF cmd = 3
        PERFORM peek-slot
    ELSE
        IF cmd = 1
            PERFORM save-slot
        ELSE
            IF cmd = 2
                PERFORM load-slot
            END-IF
        END-IF
    END-IF
    GOBACK.

peek-slot.
    PERFORM open-read
    IF io-rc NOT = 0
        EXIT PARAGRAPH
    END-IF
    PERFORM read-line
    IF bad-n = 1 OR line-buf(1:8) NOT = "COBDOOM1"
        CALL "slot_close"
        EXIT PARAGRAPH
    END-IF
    PERFORM read-line
    IF bad-n = 0
        MOVE line-buf(1:24) TO out-desc
        MOVE 0 TO rc
    END-IF
    CALL "slot_close"
    .

save-slot.
    PERFORM open-write
    IF io-rc NOT = 0
        EXIT PARAGRAPH
    END-IF
    MOVE SPACES TO line-buf
    MOVE "COBDOOM1" TO line-buf(1:8)
    PERFORM put-line
    MOVE SPACES TO line-buf
    MOVE map-name TO line-buf(1:8)
    PERFORM put-line
    MOVE SPACES TO line-buf
    MOVE map-name TO line-buf(1:8)
    PERFORM put-line
    PERFORM put-reset
    MOVE ply-skill TO num-v
    PERFORM put-num
    PERFORM put-line
    PERFORM write-ply
    MOVE SPACES TO line-buf
    MOVE gun-body TO line-buf(1:8)
    PERFORM put-line
    PERFORM put-reset
    MOVE n-mobj TO num-v
    PERFORM put-num
    PERFORM put-line
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > n-mobj
        PERFORM write-one
    END-PERFORM
    PERFORM put-reset
    MOVE n-sector TO num-v
    PERFORM put-num
    PERFORM put-line
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > n-sector
        PERFORM put-reset
        MOVE sec-floor-h(i) TO num-v
        PERFORM put-num
        MOVE sec-ceil-h(i) TO num-v
        PERFORM put-num
        MOVE sec-floor-pic(i) TO num-v
        PERFORM put-num
        MOVE sec-ceil-pic(i) TO num-v
        PERFORM put-num
        PERFORM put-line
    END-PERFORM
    PERFORM put-reset
    MOVE n-line TO num-v
    PERFORM put-num
    PERFORM put-line
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > n-line
        PERFORM put-reset
        MOVE ln-flags(i) TO num-v
        PERFORM put-num
        MOVE ln-spec(i) TO num-v
        PERFORM put-num
        PERFORM put-line
    END-PERFORM
    PERFORM put-reset
    MOVE n-side TO num-v
    PERFORM put-num
    PERFORM put-line
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > n-side
        PERFORM write-side
    END-PERFORM
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > 32
        PERFORM write-door
    END-PERFORM
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > 32
        PERFORM write-floor
    END-PERFORM
    PERFORM put-reset
    MOVE pend-tag TO num-v
    PERFORM put-num
    PERFORM put-line
    CALL "slot_close"
    MOVE 0 TO rc
    .

load-slot.
    PERFORM open-read
    IF io-rc NOT = 0
        EXIT PARAGRAPH
    END-IF
    PERFORM read-line
    IF bad-n = 1 OR line-buf(1:8) NOT = "COBDOOM1"
        CALL "slot_close"
        EXIT PARAGRAPH
    END-IF
    PERFORM read-line
    PERFORM read-line
    MOVE line-buf(1:8) TO want-map
    MOVE want-map TO asked-map
    PERFORM read-line
    PERFORM get-reset
    PERFORM get-num
    MOVE num-v TO ply-skill
    CALL "map-load" USING want-map n-lines n-verts io-rc
    IF io-rc NOT = 0 OR want-map NOT = asked-map
        CALL "slot_close"
        EXIT PARAGRAPH
    END-IF
    MOVE 9 TO act-mode
    CALL "door-act" USING act-mode busy-n moved-n
    PERFORM read-line
    PERFORM read-ply
    PERFORM read-line
    MOVE line-buf(1:8) TO gun-body
    PERFORM read-line
    PERFORM get-reset
    PERFORM get-num
    MOVE num-v TO n-mobj
    IF n-mobj < 0
        MOVE 0 TO n-mobj
    END-IF
    IF n-mobj > 768
        MOVE 768 TO n-mobj
    END-IF
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > n-mobj OR bad-n = 1
        PERFORM read-one
    END-PERFORM
    PERFORM read-line
    PERFORM get-reset
    PERFORM get-num
    MOVE num-v TO hold-n
    IF hold-n > n-sector
        MOVE n-sector TO hold-n
    END-IF
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > hold-n OR bad-n = 1
        PERFORM read-sec
    END-PERFORM
    PERFORM read-line
    PERFORM get-reset
    PERFORM get-num
    MOVE num-v TO hold-n
    IF hold-n > n-line
        MOVE n-line TO hold-n
    END-IF
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > hold-n OR bad-n = 1
        PERFORM read-ln
    END-PERFORM
    PERFORM read-line
    PERFORM get-reset
    PERFORM get-num
    MOVE num-v TO hold-n
    IF hold-n > n-side
        MOVE n-side TO hold-n
    END-IF
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > hold-n OR bad-n = 1
        PERFORM read-side
    END-PERFORM
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > 32 OR bad-n = 1
        PERFORM read-door
    END-PERFORM
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > 32 OR bad-n = 1
        PERFORM read-floor
    END-PERFORM
    PERFORM read-line
    PERFORM get-reset
    PERFORM get-num
    MOVE num-v TO pend-tag
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > 512
        MOVE 0 TO sec-door(i)
    END-PERFORM
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > 32
        IF dr-on(i) = 1 AND dr-sec(i) >= 1 AND dr-sec(i) <= 512
            MOVE i TO sec-door(dr-sec(i))
        END-IF
    END-PERFORM
    CALL "slot_close"
    IF bad-n = 0
        MOVE 1 TO spr-once
        MOVE 1 TO ply-on
        MOVE want-map TO out-map
        MOVE 0 TO rc
    END-IF
    .

write-ply.
    PERFORM put-reset
    MOVE ply-x TO num-v
    PERFORM put-num
    MOVE ply-y TO num-v
    PERFORM put-num
    MOVE ply-z TO num-v
    PERFORM put-num
    MOVE ply-ang TO num-v
    PERFORM put-num
    MOVE ply-hp TO num-v
    PERFORM put-num
    MOVE ply-armor TO num-v
    PERFORM put-num
    MOVE ply-atype TO num-v
    PERFORM put-num
    MOVE ply-ammo TO num-v
    PERFORM put-num
    MOVE ply-shell TO num-v
    PERFORM put-num
    MOVE ply-cell TO num-v
    PERFORM put-num
    MOVE ply-misl TO num-v
    PERFORM put-num
    MOVE ply-maxc TO num-v
    PERFORM put-num
    MOVE ply-maxs TO num-v
    PERFORM put-num
    MOVE ply-maxe TO num-v
    PERFORM put-num
    MOVE ply-maxr TO num-v
    PERFORM put-num
    MOVE ply-pack TO num-v
    PERFORM put-num
    MOVE ply-weap TO num-v
    PERFORM put-num
    MOVE ply-pend TO num-v
    PERFORM put-num
    MOVE ply-sg TO num-v
    PERFORM put-num
    MOVE ply-cg TO num-v
    PERFORM put-num
    MOVE ply-rl TO num-v
    PERFORM put-num
    MOVE ply-pg TO num-v
    PERFORM put-num
    MOVE ply-bf TO num-v
    PERFORM put-num
    MOVE ply-saw TO num-v
    PERFORM put-num
    MOVE ply-k0 TO num-v
    PERFORM put-num
    MOVE ply-k1 TO num-v
    PERFORM put-num
    MOVE ply-k2 TO num-v
    PERFORM put-num
    MOVE ply-k3 TO num-v
    PERFORM put-num
    MOVE ply-k4 TO num-v
    PERFORM put-num
    MOVE ply-k5 TO num-v
    PERFORM put-num
    MOVE ply-god TO num-v
    PERFORM put-num
    MOVE ply-clip TO num-v
    PERFORM put-num
    MOVE ply-secret TO num-v
    PERFORM put-num
    MOVE ply-kills TO num-v
    PERFORM put-num
    MOVE ply-items TO num-v
    PERFORM put-num
    MOVE ply-secs TO num-v
    PERFORM put-num
    MOVE map-kills TO num-v
    PERFORM put-num
    MOVE map-items TO num-v
    PERFORM put-num
    MOVE map-secs TO num-v
    PERFORM put-num
    MOVE ply-time TO num-v
    PERFORM put-num
    MOVE ply-inv TO num-v
    PERFORM put-num
    MOVE ply-suit TO num-v
    PERFORM put-num
    MOVE ply-lite TO num-v
    PERFORM put-num
    MOVE ply-invis TO num-v
    PERFORM put-num
    MOVE ply-str TO num-v
    PERFORM put-num
    MOVE ply-amap TO num-v
    PERFORM put-num
    MOVE ply-skill TO num-v
    PERFORM put-num
    MOVE ply-vh TO num-v
    PERFORM put-num
    MOVE ply-rad TO num-v
    PERFORM put-num
    MOVE ply-h TO num-v
    PERFORM put-num
    MOVE ply-blocks TO num-v
    PERFORM put-num
    MOVE ply-scale TO num-v
    PERFORM put-num
    MOVE gun-mode TO num-v
    PERFORM put-num
    MOVE ply-momx TO num-v
    PERFORM put-num
    MOVE ply-momy TO num-v
    PERFORM put-num
    MOVE ply-momz TO num-v
    PERFORM put-num
    MOVE ply-pain TO num-v
    PERFORM put-num
    MOVE ply-oldh TO num-v
    PERFORM put-num
    MOVE ply-fwait TO num-v
    PERFORM put-num
    MOVE ply-fkind TO num-v
    PERFORM put-num
    PERFORM put-line
    .

read-ply.
    PERFORM get-reset
    PERFORM get-num
    MOVE num-v TO ply-x
    PERFORM get-num
    MOVE num-v TO ply-y
    PERFORM get-num
    MOVE num-v TO ply-z
    PERFORM get-num
    MOVE num-v TO ply-ang
    PERFORM get-num
    MOVE num-v TO ply-hp
    PERFORM get-num
    MOVE num-v TO ply-armor
    PERFORM get-num
    MOVE num-v TO ply-atype
    PERFORM get-num
    MOVE num-v TO ply-ammo
    PERFORM get-num
    MOVE num-v TO ply-shell
    PERFORM get-num
    MOVE num-v TO ply-cell
    PERFORM get-num
    MOVE num-v TO ply-misl
    PERFORM get-num
    MOVE num-v TO ply-maxc
    PERFORM get-num
    MOVE num-v TO ply-maxs
    PERFORM get-num
    MOVE num-v TO ply-maxe
    PERFORM get-num
    MOVE num-v TO ply-maxr
    PERFORM get-num
    MOVE num-v TO ply-pack
    PERFORM get-num
    MOVE num-v TO ply-weap
    PERFORM get-num
    MOVE num-v TO ply-pend
    PERFORM get-num
    MOVE num-v TO ply-sg
    PERFORM get-num
    MOVE num-v TO ply-cg
    PERFORM get-num
    MOVE num-v TO ply-rl
    PERFORM get-num
    MOVE num-v TO ply-pg
    PERFORM get-num
    MOVE num-v TO ply-bf
    PERFORM get-num
    MOVE num-v TO ply-saw
    PERFORM get-num
    MOVE num-v TO ply-k0
    PERFORM get-num
    MOVE num-v TO ply-k1
    PERFORM get-num
    MOVE num-v TO ply-k2
    PERFORM get-num
    MOVE num-v TO ply-k3
    PERFORM get-num
    MOVE num-v TO ply-k4
    PERFORM get-num
    MOVE num-v TO ply-k5
    PERFORM get-num
    MOVE num-v TO ply-god
    PERFORM get-num
    MOVE num-v TO ply-clip
    PERFORM get-num
    MOVE num-v TO ply-secret
    PERFORM get-num
    MOVE num-v TO ply-kills
    PERFORM get-num
    MOVE num-v TO ply-items
    PERFORM get-num
    MOVE num-v TO ply-secs
    PERFORM get-num
    MOVE num-v TO map-kills
    PERFORM get-num
    MOVE num-v TO map-items
    PERFORM get-num
    MOVE num-v TO map-secs
    PERFORM get-num
    MOVE num-v TO ply-time
    PERFORM get-num
    MOVE num-v TO ply-inv
    PERFORM get-num
    MOVE num-v TO ply-suit
    PERFORM get-num
    MOVE num-v TO ply-lite
    PERFORM get-num
    MOVE num-v TO ply-invis
    PERFORM get-num
    MOVE num-v TO ply-str
    PERFORM get-num
    MOVE num-v TO ply-amap
    PERFORM get-num
    MOVE num-v TO ply-skill
    PERFORM get-num
    MOVE num-v TO ply-vh
    PERFORM get-num
    MOVE num-v TO ply-rad
    PERFORM get-num
    MOVE num-v TO ply-h
    PERFORM get-num
    MOVE num-v TO ply-blocks
    PERFORM get-num
    MOVE num-v TO ply-scale
    PERFORM get-num
    MOVE num-v TO gun-mode
    PERFORM get-num
    MOVE num-v TO ply-momx
    PERFORM get-num
    MOVE num-v TO ply-momy
    PERFORM get-num
    MOVE num-v TO ply-momz
    PERFORM get-num
    MOVE num-v TO ply-pain
    PERFORM get-num
    MOVE num-v TO ply-oldh
    PERFORM get-num
    MOVE num-v TO ply-fwait
    PERFORM get-num
    MOVE num-v TO ply-fkind
    .

write-one.
    PERFORM put-reset
    MOVE mo-name(i) TO line-buf(1:4)
    MOVE 5 TO ptr
    MOVE mo-x(i) TO num-v
    PERFORM put-num
    MOVE mo-y(i) TO num-v
    PERFORM put-num
    MOVE mo-z(i) TO num-v
    PERFORM put-num
    MOVE mo-ang(i) TO num-v
    PERFORM put-num
    MOVE mo-frame(i) TO num-v
    PERFORM put-num
    MOVE mo-flags(i) TO num-v
    PERFORM put-num
    MOVE mo-h(i) TO num-v
    PERFORM put-num
    MOVE mo-rad(i) TO num-v
    PERFORM put-num
    MOVE mo-hp(i) TO num-v
    PERFORM put-num
    MOVE mo-max(i) TO num-v
    PERFORM put-num
    MOVE mo-tic(i) TO num-v
    PERFORM put-num
    MOVE mo-kind(i) TO num-v
    PERFORM put-num
    MOVE mo-seq(i) TO num-v
    PERFORM put-num
    MOVE mo-step(i) TO num-v
    PERFORM put-num
    MOVE mo-ai(i) TO num-v
    PERFORM put-num
    MOVE mo-wait(i) TO num-v
    PERFORM put-num
    MOVE mo-dir(i) TO num-v
    PERFORM put-num
    MOVE mo-count(i) TO num-v
    PERFORM put-num
    MOVE mo-mx(i) TO num-v
    PERFORM put-num
    MOVE mo-my(i) TO num-v
    PERFORM put-num
    MOVE mo-mz(i) TO num-v
    PERFORM put-num
    PERFORM put-line
    .

read-one.
    PERFORM read-line
    IF bad-n = 1
        EXIT PARAGRAPH
    END-IF
    MOVE line-buf(1:4) TO mo-name(i)
    MOVE 5 TO ptr
    PERFORM get-num
    MOVE num-v TO mo-x(i)
    PERFORM get-num
    MOVE num-v TO mo-y(i)
    PERFORM get-num
    MOVE num-v TO mo-z(i)
    PERFORM get-num
    MOVE num-v TO mo-ang(i)
    PERFORM get-num
    MOVE num-v TO mo-frame(i)
    PERFORM get-num
    MOVE num-v TO mo-flags(i)
    PERFORM get-num
    MOVE num-v TO mo-h(i)
    PERFORM get-num
    MOVE num-v TO mo-rad(i)
    PERFORM get-num
    MOVE num-v TO mo-hp(i)
    PERFORM get-num
    MOVE num-v TO mo-max(i)
    PERFORM get-num
    MOVE num-v TO mo-tic(i)
    PERFORM get-num
    MOVE num-v TO mo-kind(i)
    PERFORM get-num
    MOVE num-v TO mo-seq(i)
    PERFORM get-num
    MOVE num-v TO mo-step(i)
    PERFORM get-num
    MOVE num-v TO mo-ai(i)
    PERFORM get-num
    MOVE num-v TO mo-wait(i)
    PERFORM get-num
    MOVE num-v TO mo-dir(i)
    PERFORM get-num
    MOVE num-v TO mo-count(i)
    PERFORM get-num
    MOVE num-v TO mo-mx(i)
    PERFORM get-num
    MOVE num-v TO mo-my(i)
    PERFORM get-num
    MOVE num-v TO mo-mz(i)
    .

read-sec.
    PERFORM read-line
    IF bad-n = 1
        EXIT PARAGRAPH
    END-IF
    PERFORM get-reset
    PERFORM get-num
    MOVE num-v TO sec-floor-h(i)
    PERFORM get-num
    MOVE num-v TO sec-ceil-h(i)
    PERFORM get-num
    MOVE num-v TO sec-floor-pic(i)
    PERFORM get-num
    MOVE num-v TO sec-ceil-pic(i)
    .

read-ln.
    PERFORM read-line
    IF bad-n = 1
        EXIT PARAGRAPH
    END-IF
    PERFORM get-reset
    PERFORM get-num
    MOVE num-v TO ln-flags(i)
    PERFORM get-num
    MOVE num-v TO ln-spec(i)
    .

write-side.
    PERFORM put-reset
    MOVE sd-mid(i) TO num-v
    PERFORM put-num
    MOVE sd-top(i) TO num-v
    PERFORM put-num
    MOVE sd-bot(i) TO num-v
    PERFORM put-num
    MOVE sd-mname(i) TO tok
    PERFORM put-text
    MOVE sd-tname(i) TO tok
    PERFORM put-text
    MOVE sd-bname(i) TO tok
    PERFORM put-text
    PERFORM put-line
    .

read-side.
    PERFORM read-line
    IF bad-n = 1
        EXIT PARAGRAPH
    END-IF
    PERFORM get-reset
    PERFORM get-num
    MOVE num-v TO sd-mid(i)
    PERFORM get-num
    MOVE num-v TO sd-top(i)
    PERFORM get-num
    MOVE num-v TO sd-bot(i)
    PERFORM get-text
    MOVE tok TO sd-mname(i)
    PERFORM get-text
    MOVE tok TO sd-tname(i)
    PERFORM get-text
    MOVE tok TO sd-bname(i)
    .

write-door.
    PERFORM put-reset
    MOVE dr-on(i) TO num-v
    PERFORM put-num
    MOVE dr-sec(i) TO num-v
    PERFORM put-num
    MOVE dr-type(i) TO num-v
    PERFORM put-num
    MOVE dr-dir(i) TO num-v
    PERFORM put-num
    MOVE dr-top(i) TO num-v
    PERFORM put-num
    MOVE dr-spd(i) TO num-v
    PERFORM put-num
    MOVE dr-wait(i) TO num-v
    PERFORM put-num
    PERFORM put-line
    .

read-door.
    PERFORM read-line
    IF bad-n = 1
        EXIT PARAGRAPH
    END-IF
    PERFORM get-reset
    PERFORM get-num
    MOVE num-v TO dr-on(i)
    PERFORM get-num
    MOVE num-v TO dr-sec(i)
    PERFORM get-num
    MOVE num-v TO dr-type(i)
    PERFORM get-num
    MOVE num-v TO dr-dir(i)
    PERFORM get-num
    MOVE num-v TO dr-top(i)
    PERFORM get-num
    MOVE num-v TO dr-spd(i)
    PERFORM get-num
    MOVE num-v TO dr-wait(i)
    .

write-floor.
    PERFORM put-reset
    MOVE fl-on(i) TO num-v
    PERFORM put-num
    MOVE fl-sec(i) TO num-v
    PERFORM put-num
    MOVE fl-dest(i) TO num-v
    PERFORM put-num
    MOVE fl-spd(i) TO num-v
    PERFORM put-num
    MOVE fl-dir(i) TO num-v
    PERFORM put-num
    MOVE fl-wait(i) TO num-v
    PERFORM put-num
    MOVE fl-high(i) TO num-v
    PERFORM put-num
    MOVE fl-kind(i) TO num-v
    PERFORM put-num
    PERFORM put-line
    .

read-floor.
    PERFORM read-line
    IF bad-n = 1
        EXIT PARAGRAPH
    END-IF
    PERFORM get-reset
    PERFORM get-num
    MOVE num-v TO fl-on(i)
    PERFORM get-num
    MOVE num-v TO fl-sec(i)
    PERFORM get-num
    MOVE num-v TO fl-dest(i)
    PERFORM get-num
    MOVE num-v TO fl-spd(i)
    PERFORM get-num
    MOVE num-v TO fl-dir(i)
    PERFORM get-num
    MOVE num-v TO fl-wait(i)
    PERFORM get-num
    MOVE num-v TO fl-high(i)
    PERFORM get-num
    MOVE num-v TO fl-kind(i)
    .

open-write.
    PERFORM make-path
    CALL "slot_wopen" USING path-txt BY VALUE 32 RETURNING io-rc
    .

open-read.
    PERFORM make-path
    CALL "slot_ropen" USING path-txt BY VALUE 32 RETURNING io-rc
    MOVE 0 TO bad-n
    .

make-path.
    MOVE "doomsav0.dsg" TO path-txt
    EVALUATE slot-n
        WHEN 1 MOVE "1" TO path-txt(8:1)
        WHEN 2 MOVE "2" TO path-txt(8:1)
        WHEN 3 MOVE "3" TO path-txt(8:1)
        WHEN 4 MOVE "4" TO path-txt(8:1)
        WHEN 5 MOVE "5" TO path-txt(8:1)
        WHEN OTHER MOVE "0" TO path-txt(8:1)
    END-EVALUATE
    .

put-reset.
    MOVE SPACES TO line-buf
    MOVE 1 TO ptr
    .

put-num.
    MOVE num-v TO show-n
    MOVE FUNCTION TRIM(show-n) TO tok
    IF tok = SPACES
        MOVE "0" TO tok
    END-IF
    IF ptr > 1 AND ptr < 890
        MOVE " " TO line-buf(ptr:1)
        ADD 1 TO ptr
    END-IF
    STRING tok DELIMITED BY " " INTO line-buf WITH POINTER ptr
    .

put-text.
    IF tok = SPACES
        MOVE "-" TO tok
    END-IF
    IF ptr > 1 AND ptr < 890
        MOVE " " TO line-buf(ptr:1)
        ADD 1 TO ptr
    END-IF
    STRING tok DELIMITED BY " " INTO line-buf WITH POINTER ptr
    .

put-line.
    CALL "slot_wline" USING line-buf BY VALUE 900 RETURNING io-rc
    .

read-line.
    CALL "slot_rline" USING line-buf BY VALUE 900 RETURNING io-rc
    IF io-rc NOT = 0
        MOVE 1 TO bad-n
    END-IF
    MOVE 1 TO ptr
    .

get-reset.
    MOVE 1 TO ptr
    .

get-num.
    PERFORM skip-sp
    MOVE SPACES TO tok
    MOVE 0 TO ti
    PERFORM UNTIL ptr > 900 OR line-buf(ptr:1) = " "
        ADD 1 TO ti
        IF ti <= 16
            MOVE line-buf(ptr:1) TO tok(ti:1)
        END-IF
        ADD 1 TO ptr
    END-PERFORM
    IF tok = SPACES
        MOVE 0 TO num-v
    ELSE
        COMPUTE num-v = FUNCTION NUMVAL(tok)
    END-IF
    .

get-text.
    PERFORM skip-sp
    MOVE SPACES TO tok
    MOVE 0 TO ti
    PERFORM UNTIL ptr > 900 OR line-buf(ptr:1) = " "
        ADD 1 TO ti
        IF ti <= 16
            MOVE line-buf(ptr:1) TO tok(ti:1)
        END-IF
        ADD 1 TO ptr
    END-PERFORM
    IF tok = "-"
        MOVE SPACES TO tok
    END-IF
    .

skip-sp.
    PERFORM UNTIL ptr > 900 OR line-buf(ptr:1) NOT = " "
        ADD 1 TO ptr
    END-PERFORM
    .

END PROGRAM slot-act.
