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
*> Vista 3D. O jogador anda, abre portas e dispara a pistola. Grades seguem sem textura do meio.
IDENTIFICATION DIVISION.
PROGRAM-ID. view-frame.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "mapstate.cpy".
COPY "rdata.cpy".
COPY "sprstate.cpy".
COPY "playstate.cpy".
01 tables-on BINARY-LONG VALUE 0.
01 finesine BINARY-LONG OCCURS 8192 TIMES.
01 finetangent BINARY-LONG OCCURS 4096 TIMES.
01 tantoangle BINARY-LONG OCCURS 2049 TIMES.
01 vat BINARY-LONG OCCURS 4096 TIMES.
01 xtv BINARY-LONG OCCURS 321 TIMES.
01 yslope BINARY-LONG OCCURS 200 TIMES.
01 dist-scale BINARY-LONG OCCURS 320 TIMES.
01 scale-light BINARY-LONG OCCURS 768 TIMES.
01 z-light BINARY-LONG OCCURS 2048 TIMES.
01 solid-a BINARY-LONG OCCURS 128 TIMES.
01 solid-b BINARY-LONG OCCURS 128 TIMES.
01 ceil-clip BINARY-LONG OCCURS 320 TIMES.
01 floor-clip BINARY-LONG OCCURS 320 TIMES.
01 vp-h BINARY-LONG OCCURS 128 TIMES.
01 vp-pic BINARY-LONG OCCURS 128 TIMES.
01 vp-light BINARY-LONG OCCURS 128 TIMES.
01 vp-min BINARY-LONG OCCURS 128 TIMES.
01 vp-max BINARY-LONG OCCURS 128 TIMES.
01 vp-top BINARY-LONG OCCURS 40960 TIMES.
01 vp-bot BINARY-LONG OCCURS 40960 TIMES.
01 stk-n BINARY-LONG OCCURS 1024 TIMES.
01 dc-src PIC X(128).
01 flat-buf PIC X(4096).
01 flat-have BINARY-LONG VALUE -1.
01 view-w BINARY-LONG.
01 view-h BINARY-LONG.
01 view-ox BINARY-LONG VALUE 0.
01 view-oy BINARY-LONG VALUE 0.
01 sized-n BINARY-LONG VALUE 0.
01 gun-clip BINARY-LONG VALUE 0.
01 center-x BINARY-LONG.
01 center-y BINARY-LONG.
01 center-xf BINARY-LONG.
01 center-yf BINARY-LONG.
01 cy4 BINARY-LONG.
01 ang-90 BINARY-LONG.
01 ang-180 BINARY-LONG.
01 ang-270 BINARY-LONG.
01 clip-a BINARY-LONG.
01 two-clip BINARY-LONG.
01 extra-l BINARY-LONG.
01 player-i BINARY-LONG.
01 sec-slot BINARY-LONG.
01 sub-slot BINARY-LONG.
01 sub-n BINARY-LONG.
01 view-x BINARY-LONG.
01 view-y BINARY-LONG.
01 view-z BINARY-LONG.
01 view-ang BINARY-LONG.
01 base-xs BINARY-LONG.
01 base-ys BINARY-LONG.
01 n-plane BINARY-LONG.
01 floor-pl BINARY-LONG.
01 ceil-pl BINARY-LONG.
01 rw-x BINARY-LONG.
01 rw-stop BINARY-LONG.
01 rw-scale BINARY-LONG.
01 rw-step BINARY-LONG.
01 rw-dist BINARY-LONG.
01 rw-off BINARY-LONG.
01 rw-norm BINARY-LONG.
01 rw-ang1 BINARY-LONG.
01 rw-center BINARY-LONG.
01 rw-mid BINARY-LONG.
01 rw-mask BINARY-LONG.
01 mask-id BINARY-LONG.
01 rw-topm BINARY-LONG.
01 rw-botm BINARY-LONG.
01 mid-tex BINARY-LONG.
01 top-tex BINARY-LONG.
01 bot-tex BINARY-LONG.
01 mark-floor BINARY-LONG.
01 mark-ceil BINARY-LONG.
01 seg-tex BINARY-LONG.
01 masked-tex BINARY-LONG.
01 world-top BINARY-LONG.
01 world-bot BINARY-LONG.
01 world-hi BINARY-LONG.
01 world-lo BINARY-LONG.
01 top-frac BINARY-LONG.
01 top-step BINARY-LONG.
01 bot-frac BINARY-LONG.
01 bot-step BINARY-LONG.
01 pix-hi BINARY-LONG.
01 pix-lo BINARY-LONG.
01 hi-step BINARY-LONG.
01 lo-step BINARY-LONG.
01 hyp-d BINARY-LONG.
01 front-sec BINARY-LONG.
01 back-sec BINARY-LONG.
01 has-back BINARY-LONG.
01 cur-seg BINARY-LONG.
01 line-slot BINARY-LONG.
01 sd-slot BINARY-LONG.
01 v1-slot BINARY-LONG.
01 v2-slot BINARY-LONG.
01 wall-base BINARY-LONG.
01 light-n BINARY-LONG.
01 dc-x BINARY-LONG.
01 dc-yl BINARY-LONG.
01 dc-yh BINARY-LONG.
01 dc-step BINARY-LONG.
01 dc-mid BINARY-LONG.
01 dc-map BINARY-LONG.
01 tex-id BINARY-LONG.
01 col-n BINARY-LONG.
01 tex-col BINARY-LONG.
01 th-out BINARY-LONG.
01 first-x BINARY-LONG.
01 last-x BINARY-LONG.
01 start-i BINARY-LONG.
01 next-i BINARY-LONG.
01 new-end BINARY-LONG.
01 rng-a BINARY-LONG.
01 rng-b BINARY-LONG.
01 save-first BINARY-LONG.
01 save-last BINARY-LONG.
01 lim BINARY-LONG.
01 tmp BINARY-LONG.
01 a1 BINARY-LONG.
01 a2 BINARY-LONG.
01 tspan BINARY-LONG.
01 x1 BINARY-LONG.
01 x2 BINARY-LONG.
01 px BINARY-LONG.
01 py BINARY-LONG.
01 dx BINARY-LONG.
01 dy BINARY-LONG.
01 ang-in BINARY-LONG.
01 ang-out BINARY-LONG.
01 sin-out BINARY-LONG.
01 vis-ang BINARY-LONG.
01 scale-out BINARY-LONG.
01 sinea BINARY-LONG.
01 sineb BINARY-LONG.
01 num-v BINARY-LONG.
01 den-v BINARY-LONG.
01 idx BINARY-LONG.
01 slot BINARY-LONG.
01 peek BINARY-LONG.
01 src BINARY-LONG.
01 dst BINARY-LONG.
01 k BINARY-LONG.
01 i BINARY-LONG.
01 hold-keep BINARY-LONG.
01 j BINARY-LONG.
01 bit-n BINARY-LONG.
01 node-slot BINARY-LONG.
01 bsp BINARY-LONG.
01 bsp-push BINARY-LONG.
01 side-bit BINARY-LONG.
01 stk-sp BINARY-LONG.
01 step-n BINARY-LONG.
01 seg-i BINARY-LONG.
01 yl BINARY-LONG.
01 yh BINARY-LONG.
01 mid-y BINARY-LONG.
01 span-top BINARY-LONG.
01 span-bot BINARY-LONG.
01 clip-top BINARY-LONG.
01 clip-bot BINARY-LONG.
01 vp-at BINARY-LONG.
01 pl-i BINARY-LONG.
01 pl-out BINARY-LONG.
01 seek-i BINARY-LONG.
01 want-h BINARY-LONG.
01 want-pic BINARY-LONG.
01 want-light BINARY-LONG.
01 intr-l BINARY-LONG.
01 intr-h BINARY-LONG.
01 union-l BINARY-LONG.
01 union-h BINARY-LONG.
01 span-a BINARY-LONG.
01 span-b BINARY-LONG.
01 x-i BINARY-LONG.
01 y-i BINARY-LONG.
01 x-end BINARY-LONG.
01 y-end BINARY-LONG.
01 t1 BINARY-LONG.
01 b1 BINARY-LONG.
01 plane-h BINARY-LONG.
01 dist-n BINARY-LONG.
01 dist-out BINARY-LONG.
01 run-len BINARY-LONG.
01 frac BINARY-LONG.
01 prod BINARY-LONG.
01 count-n BINARY-LONG.
01 dest-at BINARY-LONG.
01 at-pos BINARY-LONG.
01 pix BINARY-LONG.
01 byte-n BINARY-LONG.
01 tan-v BINARY-LONG.
01 cos-v BINARY-LONG.
01 sin-v BINARY-LONG.
01 nread BINARY-LONG.
01 old-end BINARY-LONG.
01 focal BINARY-LONG.
01 ft BINARY-LONG.
01 t-scr BINARY-LONG.
01 li BINARY-LONG.
01 lj BINARY-LONG.
01 sc BINARY-LONG.
01 level BINARY-LONG.
01 start-map BINARY-LONG.
01 sh BINARY-LONG.
01 half-w BINARY-LONG.
01 num-h BINARY-LONG.
01 row-off BINARY-LONG.
01 col-off BINARY-LONG.
01 flag-n BINARY-LONG.
01 view-sin BINARY-LONG.
01 view-cos BINARY-LONG.
01 n-ds BINARY-LONG VALUE 0.
01 ds-pool BINARY-LONG VALUE 0.
01 scale-save BINARY-LONG.
01 ds-x1 BINARY-LONG OCCURS 128 TIMES.
01 ds-x2 BINARY-LONG OCCURS 128 TIMES.
01 ds-sc1 BINARY-LONG OCCURS 128 TIMES.
01 ds-sc2 BINARY-LONG OCCURS 128 TIMES.
01 ds-sil BINARY-LONG OCCURS 128 TIMES.
01 ds-bsil BINARY-LONG OCCURS 128 TIMES.
01 ds-tsil BINARY-LONG OCCURS 128 TIMES.
01 ds-seg BINARY-LONG OCCURS 128 TIMES.
01 ds-mask BINARY-LONG OCCURS 128 TIMES.
01 ds-c0 BINARY-LONG OCCURS 128 TIMES.
01 ds-nclip BINARY-LONG OCCURS 128 TIMES.
01 ds-mtex BINARY-LONG OCCURS 128 TIMES.
01 ds-mmid BINARY-LONG OCCURS 128 TIMES.
01 ds-top BINARY-LONG OCCURS 8192 TIMES.
01 ds-bot BINARY-LONG OCCURS 8192 TIMES.
01 ds-mcol BINARY-LONG OCCURS 8192 TIMES.
01 ds-mlit BINARY-LONG OCCURS 8192 TIMES.
01 mhold-col BINARY-LONG OCCURS 320 TIMES.
01 mhold-lit BINARY-LONG OCCURS 320 TIMES.
01 n-vis BINARY-LONG.
01 vis-ord BINARY-LONG OCCURS 128 TIMES.
01 vis-sc BINARY-LONG OCCURS 128 TIMES.
01 vis-gx BINARY-LONG OCCURS 128 TIMES.
01 vis-gy BINARY-LONG OCCURS 128 TIMES.
01 vis-gz BINARY-LONG OCCURS 128 TIMES.
01 vis-gzt BINARY-LONG OCCURS 128 TIMES.
01 vis-mid BINARY-LONG OCCURS 128 TIMES.
01 vis-x0 BINARY-LONG OCCURS 128 TIMES.
01 vis-x1 BINARY-LONG OCCURS 128 TIMES.
01 vis-x2 BINARY-LONG OCCURS 128 TIMES.
01 vis-xis BINARY-LONG OCCURS 128 TIMES.
01 vis-sfrac BINARY-LONG OCCURS 128 TIMES.
01 vis-w BINARY-LONG OCCURS 128 TIMES.
01 vis-lump BINARY-LONG OCCURS 128 TIMES.
01 vis-fuzz BINARY-LONG OCCURS 128 TIMES.
01 fuzz-on BINARY-LONG.
01 ctop BINARY-LONG OCCURS 320 TIMES.
01 cbot BINARY-LONG OCCURS 320 TIMES.
01 patch-buf PIC X(65536).
01 patch-len BINARY-LONG.
01 trx BINARY-LONG.
01 try-y BINARY-LONG.
01 gxt-v BINARY-LONG.
01 gyt-v BINARY-LONG.
01 tz-v BINARY-LONG.
01 xsc-v BINARY-LONG.
01 tx-v BINARY-LONG.
01 mo-i BINARY-LONG.
01 vis-k BINARY-LONG.
01 cur-x0 BINARY-LONG.
01 cur-x1 BINARY-LONG.
01 cur-x2 BINARY-LONG.
01 cur-sc BINARY-LONG.
01 cur-gx BINARY-LONG.
01 cur-gy BINARY-LONG.
01 cur-gz BINARY-LONG.
01 cur-gzt BINARY-LONG.
01 cur-mid BINARY-LONG.
01 cur-xis BINARY-LONG.
01 cur-sfrac BINARY-LONG.
01 cur-w BINARY-LONG.
01 cur-lump BINARY-LONG.
01 y-is BINARY-LONG.
01 col-at BINARY-LONG.
01 post-at BINARY-LONG.
01 post-len BINARY-LONG.
01 top-d BINARY-LONG.
01 src-at BINARY-LONG.
01 hold-i BINARY-LONG.
01 prev-i BINARY-LONG.
01 r1 BINARY-LONG.
01 r2 BINARY-LONG.
01 hi-sc BINARY-LONG.
01 lo-sc BINARY-LONG.
01 sil-n BINARY-LONG.
01 ldx BINARY-LONG.
01 ldy BINARY-LONG.
01 left-v BINARY-LONG.
01 right-v BINARY-LONG.
01 flip-n BINARY-LONG.
01 spr-rc BINARY-LONG.
01 cap-n BINARY-LONG.
01 spr-w BINARY-LONG.
01 spr-left BINARY-LONG.
01 spr-top BINARY-LONG.
01 adj-v BINARY-LONG.
01 di BINARY-LONG.
01 clip-i BINARY-LONG.
01 gun-name PIC X(8).
01 gun-sx BINARY-LONG.
01 sy-v BINARY-LONG.

LINKAGE SECTION.
01 fb PIC X(64000).
01 ink BINARY-LONG.

PROCEDURE DIVISION USING fb ink.
    PERFORM main-view
    GOBACK.

main-view.
    IF tables-on = 0
        CALL "build_finesine" USING BY REFERENCE finesine(1) BY VALUE 8192
        CALL "build_finetangent" USING BY REFERENCE finetangent(1)
            BY VALUE 4096
        CALL "build_tantoangle" USING BY REFERENCE tantoangle(1)
            BY VALUE 2049
        MOVE 1073741824 TO ang-90
        CALL "k_ang180" RETURNING ang-180
        MOVE -1073741824 TO ang-270
        MOVE 0 TO extra-l
        PERFORM init-lights
        MOVE 0 TO sized-n
        MOVE 1 TO tables-on
    END-IF
    PERFORM apply-size
    IF ply-lite > 0
        MOVE 8 TO extra-l
    ELSE
        MOVE 0 TO extra-l
    END-IF
    IF ply-tic = 0
        MOVE 0 TO ink
    END-IF
    MOVE ALL X"00" TO fb
    IF ply-on = 0
        MOVE 0 TO player-i
        PERFORM VARYING i FROM 1 BY 1 UNTIL i > n-thing OR player-i > 0
            IF th-kind(i) = 1
                MOVE i TO player-i
            END-IF
        END-PERFORM
        IF player-i = 0
            EXIT PARAGRAPH
        END-IF
        CALL "fixed_from_i16" USING BY VALUE th-x(player-i) RETURNING ply-x
        CALL "fixed_from_i16" USING BY VALUE th-y(player-i) RETURNING ply-y
        CALL "angle_from_deg" USING BY VALUE th-ang(player-i)
            RETURNING ply-ang
        MOVE 1048576 TO ply-rad
        MOVE 3670016 TO ply-h
        MOVE 0 TO ply-momx
        MOVE 0 TO ply-momy
        MOVE 0 TO ply-bob
        MOVE 0 TO ply-vbob
        MOVE 0 TO ply-momz
        MOVE 2686976 TO ply-vh
        MOVE 0 TO ply-dvh
        MOVE 0 TO ply-tic
        MOVE 0 TO ply-turn
        MOVE ply-keep TO hold-keep
        IF ply-keep = 0
        MOVE 50 TO ply-ammo
        MOVE 100 TO ply-hp
        MOVE 0 TO ply-shot
        MOVE 0 TO ply-armor
        MOVE 0 TO ply-shell
        MOVE 0 TO ply-cell
        MOVE 0 TO ply-misl
        MOVE 200 TO ply-maxc
        MOVE 50 TO ply-maxs
        MOVE 300 TO ply-maxe
        MOVE 50 TO ply-maxr
        MOVE 0 TO ply-pack
        MOVE 0 TO ply-sg
        MOVE 0 TO ply-cg
        MOVE 0 TO ply-rl
        MOVE 0 TO ply-pg
        MOVE 0 TO ply-bf
        MOVE 0 TO ply-saw
        MOVE 0 TO ply-k0
        MOVE 0 TO ply-k1
        MOVE 0 TO ply-k2
        MOVE 0 TO ply-k3
        MOVE 0 TO ply-k4
        MOVE 0 TO ply-k5
        MOVE 0 TO ply-exit
        MOVE 0 TO ply-atype
        MOVE 0 TO ply-time
        MOVE 0 TO ply-pain
        MOVE 100 TO ply-oldh
        MOVE 0 TO ply-fwait
        MOVE 0 TO ply-fkind
        MOVE "PISGA0" TO gun-body
        MOVE SPACES TO gun-flash
        MOVE 0 TO gun-mode
        MOVE 0 TO gun-lift
        MOVE 2 TO ply-weap
        MOVE 0 TO ply-pend
        END-IF
        MOVE 0 TO ply-keep
        MOVE 0 TO ply-inv
        MOVE 0 TO ply-suit
        MOVE 0 TO ply-lite
        MOVE 0 TO ply-invis
        MOVE 0 TO ply-str
        MOVE 0 TO ply-amap
        MOVE 0 TO ply-exit
        MOVE 0 TO ply-time
        MOVE 0 TO ply-pain
        MOVE 0 TO ply-fwait
        MOVE 0 TO ply-fkind
        MOVE 0 TO gun-mode
        MOVE 0 TO gun-lift
        MOVE SPACES TO gun-flash
        IF hold-keep = 1
            IF ply-weap = 1
                MOVE "PUNGA0" TO gun-body
            END-IF
            IF ply-weap = 2 OR ply-weap = 0
                MOVE "PISGA0" TO gun-body
            END-IF
            IF ply-weap = 3
                MOVE "SHTGA0" TO gun-body
            END-IF
            IF ply-weap = 4
                MOVE "CHGGA0" TO gun-body
            END-IF
            IF ply-weap = 5
                MOVE "MISGA0" TO gun-body
            END-IF
            IF ply-weap = 6
                MOVE "PLSGA0" TO gun-body
            END-IF
            IF ply-weap = 7
                MOVE "BFGGA0" TO gun-body
            END-IF
            IF ply-weap = 8
                MOVE "SAWGA0" TO gun-body
            END-IF
        END-IF
        MOVE ply-x TO view-x
        MOVE ply-y TO view-y
        PERFORM point-in-sub
        MOVE sec-slot TO ply-room
        MOVE sec-floor-h(sec-slot) TO ply-floor
        MOVE sec-ceil-h(sec-slot) TO ply-ceil
        MOVE ply-floor TO ply-z
        MOVE 1 TO ply-on
    END-IF
    MOVE ply-x TO view-x
    MOVE ply-y TO view-y
    MOVE ply-ang TO view-ang
    CALL "add_i32" USING BY VALUE ply-z BY VALUE ply-vh RETURNING view-z
    CALL "add_i32" USING BY VALUE view-z BY VALUE ply-vbob RETURNING view-z
    PERFORM setup-frame
    PERFORM clear-clip
    MOVE 0 TO n-plane
    MOVE -1 TO flat-have
    PERFORM render-bsp
    PERFORM draw-planes
    PERFORM draw-things
    PERFORM draw-weapon
    CALL "status-draw" USING fb
    IF ply-tic = 0
        PERFORM VARYING at-pos FROM 0 BY 1 UNTIL at-pos >= 64000
            CALL "byte_at" USING BY REFERENCE fb BY VALUE at-pos
                RETURNING byte-n
            IF byte-n NOT = 0
                ADD 1 TO ink
            END-IF
        END-PERFORM
    END-IF
    .

apply-size.
    IF ply-blocks < 3
        MOVE 10 TO ply-blocks
    END-IF
    IF ply-blocks > 11
        MOVE 11 TO ply-blocks
    END-IF
    IF ply-blocks = sized-n
        EXIT PARAGRAPH
    END-IF
    MOVE ply-blocks TO sized-n
    IF ply-blocks >= 11
        MOVE 320 TO view-w
        MOVE 200 TO view-h
        MOVE 0 TO view-ox
        MOVE 0 TO view-oy
    ELSE
        COMPUTE view-w = ply-blocks * 32
        COMPUTE view-h = ply-blocks * 168 / 10
        COMPUTE view-h = view-h - FUNCTION MOD(view-h, 8)
        IF view-h < 32
            MOVE 32 TO view-h
        END-IF
        COMPUTE view-ox = (320 - view-w) / 2
        IF view-w >= 320
            MOVE 0 TO view-oy
        ELSE
            COMPUTE view-oy = (168 - view-h) / 2
        END-IF
    END-IF
    COMPUTE center-x = view-w / 2
    COMPUTE center-y = view-h / 2
    CALL "fixed_from_i16" USING BY VALUE center-x RETURNING center-xf
    CALL "fixed_from_i16" USING BY VALUE center-y RETURNING center-yf
    CALL "shar32" USING BY VALUE center-yf BY VALUE 4 RETURNING cy4
    PERFORM init-mapping
    PERFORM init-slopes
    .

init-mapping.
    CALL "fixed_div" USING BY VALUE center-xf BY VALUE finetangent(3073)
        RETURNING focal
    PERFORM VARYING i FROM 0 BY 1 UNTIL i >= 4096
        COMPUTE slot = i + 1
        MOVE finetangent(slot) TO ft
        IF ft > 131072
            MOVE -1 TO t-scr
        ELSE
            IF ft < -131072
                COMPUTE t-scr = view-w + 1
            ELSE
                CALL "fixed_mul" USING BY VALUE ft BY VALUE focal
                    RETURNING tmp
                CALL "sub_i32" USING BY VALUE center-xf BY VALUE tmp
                    RETURNING tmp
                CALL "add_i32" USING BY VALUE tmp BY VALUE 65535
                    RETURNING tmp
                CALL "shar32" USING BY VALUE tmp BY VALUE 16 RETURNING t-scr
                IF t-scr < -1
                    MOVE -1 TO t-scr
                END-IF
                COMPUTE tmp = view-w + 1
                IF t-scr > tmp
                    MOVE tmp TO t-scr
                END-IF
            END-IF
        END-IF
        MOVE t-scr TO vat(slot)
    END-PERFORM
    PERFORM VARYING x-i FROM 0 BY 1 UNTIL x-i > view-w
        MOVE 0 TO i
        PERFORM UNTIL i >= 4096
            COMPUTE slot = i + 1
            IF vat(slot) <= x-i
                EXIT PERFORM
            END-IF
            ADD 1 TO i
        END-PERFORM
        CALL "shl_i" USING BY VALUE i BY VALUE 19 RETURNING tmp
        CALL "sub_i32" USING BY VALUE tmp BY VALUE ang-90
            RETURNING xtv(x-i + 1)
    END-PERFORM
    PERFORM VARYING i FROM 0 BY 1 UNTIL i >= 4096
        COMPUTE slot = i + 1
        IF vat(slot) = -1
            MOVE 0 TO vat(slot)
        ELSE
            COMPUTE tmp = view-w + 1
            IF vat(slot) = tmp
                MOVE view-w TO vat(slot)
            END-IF
        END-IF
    END-PERFORM
    MOVE xtv(1) TO clip-a
    CALL "add_i32" USING BY VALUE clip-a BY VALUE clip-a RETURNING two-clip
    .

init-lights.
    PERFORM VARYING li FROM 0 BY 1 UNTIL li >= 16
        COMPUTE start-map = (15 - li) * 4
        PERFORM VARYING lj FROM 0 BY 1 UNTIL lj >= 128
            COMPUTE sh = lj + 1
            CALL "shl_i" USING BY VALUE sh BY VALUE 20 RETURNING sh
            CALL "fixed_div" USING BY VALUE 10485760 BY VALUE sh
                RETURNING sc
            CALL "ushr_i" USING BY VALUE sc BY VALUE 12 RETURNING sc
            DIVIDE sc BY 2 GIVING level
            COMPUTE level = start-map - level
            IF level < 0
                MOVE 0 TO level
            END-IF
            IF level > 31
                MOVE 31 TO level
            END-IF
            COMPUTE slot = li * 128 + lj + 1
            MOVE level TO z-light(slot)
        END-PERFORM
        PERFORM VARYING lj FROM 0 BY 1 UNTIL lj >= 48
            DIVIDE lj BY 2 GIVING level
            COMPUTE level = start-map - level
            IF level < 0
                MOVE 0 TO level
            END-IF
            IF level > 31
                MOVE 31 TO level
            END-IF
            COMPUTE slot = li * 48 + lj + 1
            MOVE level TO scale-light(slot)
        END-PERFORM
    END-PERFORM
    .

init-slopes.
    COMPUTE half-w = view-w / 2
    CALL "fixed_from_i16" USING BY VALUE half-w RETURNING num-h
    PERFORM VARYING i FROM 0 BY 1 UNTIL i >= view-h
        COMPUTE dy = i - center-y
        CALL "shl_i" USING BY VALUE dy BY VALUE 16 RETURNING dy
        CALL "add_i32" USING BY VALUE dy BY VALUE 32768 RETURNING dy
        CALL "abs_fixed_i" USING BY VALUE dy RETURNING dy
        IF dy < 1
            MOVE 1 TO dy
        END-IF
        CALL "fixed_div" USING BY VALUE num-h BY VALUE dy
            RETURNING yslope(i + 1)
    END-PERFORM
    PERFORM VARYING i FROM 0 BY 1 UNTIL i >= view-w
        MOVE xtv(i + 1) TO ang-in
        PERFORM cos-at
        CALL "abs_fixed_i" USING BY VALUE sin-out RETURNING dy
        IF dy < 1
            MOVE 1 TO dy
        END-IF
        CALL "fixed_div" USING BY VALUE 65536 BY VALUE dy
            RETURNING dist-scale(i + 1)
    END-PERFORM
    .

setup-frame.
    CALL "sub_i32" USING BY VALUE view-ang BY VALUE ang-90 RETURNING ang-in
    CALL "ushr_i" USING BY VALUE ang-in BY VALUE 19 RETURNING idx
    CALL "bit_and" USING BY VALUE idx BY VALUE 8191 RETURNING idx
    COMPUTE slot = idx + 2048
    CALL "bit_and" USING BY VALUE slot BY VALUE 8191 RETURNING slot
    ADD 1 TO slot
    CALL "fixed_div" USING BY VALUE finesine(slot) BY VALUE center-xf
        RETURNING base-xs
    COMPUTE slot = idx + 1
    CALL "fixed_div" USING BY VALUE finesine(slot) BY VALUE center-xf
        RETURNING tmp
    CALL "sub_i32" USING BY VALUE 0 BY VALUE tmp RETURNING base-ys
    MOVE view-ang TO ang-in
    PERFORM sine-at
    MOVE sin-out TO view-sin
    PERFORM cos-at
    MOVE sin-out TO view-cos
    .

clear-clip.
    MOVE -2147483647 TO solid-a(1)
    MOVE -1 TO solid-b(1)
    MOVE view-w TO solid-a(2)
    MOVE 2147483647 TO solid-b(2)
    MOVE 2 TO new-end
    MOVE 0 TO n-ds
    MOVE 0 TO ds-pool
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > view-w
        MOVE -1 TO ceil-clip(i)
        MOVE view-h TO floor-clip(i)
    END-PERFORM
    .

point-in-sub.
    MOVE 1 TO sub-slot
    MOVE 1 TO sec-slot
    IF n-node < 1
        IF n-ssector >= 1 AND ss-sec(1) >= 0
            COMPUTE sec-slot = ss-sec(1) + 1
        END-IF
        EXIT PARAGRAPH
    END-IF
    COMPUTE bsp = n-node - 1
    PERFORM VARYING step-n FROM 1 BY 1 UNTIL step-n > 1024
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
            BY VALUE view-x BY VALUE view-y
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

render-bsp.
    MOVE 0 TO stk-sp
    IF n-node < 1
        MOVE 0 TO sub-n
        PERFORM draw-sub
        EXIT PARAGRAPH
    END-IF
    COMPUTE bsp-push = n-node - 1
    PERFORM push-stk
    PERFORM UNTIL stk-sp < 1
        MOVE stk-n(stk-sp) TO bsp
        SUBTRACT 1 FROM stk-sp
        IF bsp < 0
            MOVE 0 TO sub-n
            PERFORM draw-sub
        ELSE
            CALL "bit_and" USING BY VALUE bsp BY VALUE 32768
                RETURNING bit-n
            IF bit-n NOT = 0
                CALL "bit_and" USING BY VALUE bsp BY VALUE 32767
                    RETURNING sub-n
                PERFORM draw-sub
            ELSE
                COMPUTE node-slot = bsp + 1
                IF node-slot >= 1 AND node-slot <= n-node
                    CALL "point_side" USING
                        BY VALUE nd-x(node-slot) BY VALUE nd-y(node-slot)
                        BY VALUE nd-dx(node-slot) BY VALUE nd-dy(node-slot)
                        BY VALUE view-x BY VALUE view-y
                        RETURNING side-bit
                    IF side-bit = 0
                        MOVE nd-c1(node-slot) TO bsp-push
                        PERFORM push-stk
                        MOVE nd-c0(node-slot) TO bsp-push
                        PERFORM push-stk
                    ELSE
                        MOVE nd-c0(node-slot) TO bsp-push
                        PERFORM push-stk
                        MOVE nd-c1(node-slot) TO bsp-push
                        PERFORM push-stk
                    END-IF
                END-IF
            END-IF
        END-IF
    END-PERFORM
    .

push-stk.
    IF stk-sp >= 512
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO stk-sp
    MOVE bsp-push TO stk-n(stk-sp)
    .

draw-sub.
    COMPUTE sub-slot = sub-n + 1
    IF sub-slot < 1 OR sub-slot > n-ssector
        EXIT PARAGRAPH
    END-IF
    IF ss-sec(sub-slot) < 0
        EXIT PARAGRAPH
    END-IF
    COMPUTE front-sec = ss-sec(sub-slot) + 1
    IF front-sec < 1 OR front-sec > n-sector
        EXIT PARAGRAPH
    END-IF
    CALL "ushr_i" USING BY VALUE sec-flight(front-sec) BY VALUE 4
        RETURNING light-n
    ADD extra-l TO light-n
    IF light-n < 0
        MOVE 0 TO light-n
    END-IF
    IF light-n > 15
        MOVE 15 TO light-n
    END-IF
    COMPUTE wall-base = light-n * 48
    MOVE sec-floor-h(front-sec) TO want-h
    MOVE sec-floor-pic(front-sec) TO want-pic
    MOVE sec-flight(front-sec) TO want-light
    PERFORM find-plane
    MOVE pl-out TO floor-pl
    MOVE sec-ceil-h(front-sec) TO want-h
    MOVE sec-ceil-pic(front-sec) TO want-pic
    MOVE sec-flight(front-sec) TO want-light
    PERFORM find-plane
    MOVE pl-out TO ceil-pl
    MOVE ss-begin(sub-slot) TO seg-i
    PERFORM ss-n(sub-slot) TIMES
        COMPUTE cur-seg = seg-i + 1
        PERFORM add-line
        ADD 1 TO seg-i
    END-PERFORM
    .

find-plane.
    IF want-pic = sky-flat
        MOVE 0 TO want-h
        MOVE 0 TO want-light
    END-IF
    MOVE 0 TO pl-out
    PERFORM VARYING seek-i FROM 1 BY 1 UNTIL seek-i > n-plane
        IF vp-h(seek-i) = want-h AND vp-pic(seek-i) = want-pic
            AND vp-light(seek-i) = want-light
            MOVE seek-i TO pl-out
            EXIT PARAGRAPH
        END-IF
    END-PERFORM
    PERFORM alloc-plane
    .

alloc-plane.
    IF n-plane >= 128
        MOVE 0 TO pl-out
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO n-plane
    MOVE n-plane TO pl-out
    MOVE want-h TO vp-h(pl-out)
    MOVE want-pic TO vp-pic(pl-out)
    MOVE want-light TO vp-light(pl-out)
    MOVE view-w TO vp-min(pl-out)
    MOVE -1 TO vp-max(pl-out)
    PERFORM VARYING x-i FROM 0 BY 1 UNTIL x-i >= 320
        COMPUTE vp-at = (pl-out - 1) * 320 + x-i + 1
        MOVE 255 TO vp-top(vp-at)
        MOVE 0 TO vp-bot(vp-at)
    END-PERFORM
    .

check-plane.
    IF pl-i < 1
        MOVE 0 TO want-h
        MOVE 0 TO want-pic
        MOVE 0 TO want-light
        PERFORM find-plane
        EXIT PARAGRAPH
    END-IF
    IF span-a < vp-min(pl-i)
        MOVE vp-min(pl-i) TO intr-l
        MOVE span-a TO union-l
    ELSE
        MOVE span-a TO intr-l
        MOVE vp-min(pl-i) TO union-l
    END-IF
    IF span-b > vp-max(pl-i)
        MOVE vp-max(pl-i) TO intr-h
        MOVE span-b TO union-h
    ELSE
        MOVE span-b TO intr-h
        MOVE vp-max(pl-i) TO union-h
    END-IF
    MOVE intr-l TO x-i
    PERFORM UNTIL x-i > intr-h
        IF x-i >= 0 AND x-i < 320
            COMPUTE vp-at = (pl-i - 1) * 320 + x-i + 1
            IF vp-top(vp-at) NOT = 255
                EXIT PERFORM
            END-IF
        END-IF
        ADD 1 TO x-i
    END-PERFORM
    IF x-i > intr-h
        MOVE union-l TO vp-min(pl-i)
        MOVE union-h TO vp-max(pl-i)
        MOVE pl-i TO pl-out
        EXIT PARAGRAPH
    END-IF
    PERFORM dup-plane
    .

dup-plane.
    MOVE vp-h(pl-i) TO want-h
    MOVE vp-pic(pl-i) TO want-pic
    MOVE vp-light(pl-i) TO want-light
    PERFORM alloc-plane
    IF pl-out > 0
        MOVE span-a TO vp-min(pl-out)
        MOVE span-b TO vp-max(pl-out)
    END-IF
    .

add-line.
    IF cur-seg < 1 OR cur-seg > n-seg
        EXIT PARAGRAPH
    END-IF
    MOVE sg-v1(cur-seg) TO v1-slot
    MOVE sg-v2(cur-seg) TO v2-slot
    IF v1-slot < 1 OR v1-slot > n-vertex
        OR v2-slot < 1 OR v2-slot > n-vertex
        EXIT PARAGRAPH
    END-IF
    MOVE vtx-x(v1-slot) TO px
    MOVE vtx-y(v1-slot) TO py
    PERFORM point-to-angle
    MOVE ang-out TO a1
    MOVE vtx-x(v2-slot) TO px
    MOVE vtx-y(v2-slot) TO py
    PERFORM point-to-angle
    MOVE ang-out TO a2
    CALL "sub_i32" USING BY VALUE a1 BY VALUE a2 RETURNING span-a
    CALL "uge_u32" USING BY VALUE span-a BY VALUE ang-180 RETURNING bit-n
    IF bit-n = 1
        EXIT PARAGRAPH
    END-IF
    MOVE a1 TO rw-ang1
    CALL "sub_i32" USING BY VALUE a1 BY VALUE view-ang RETURNING a1
    CALL "sub_i32" USING BY VALUE a2 BY VALUE view-ang RETURNING a2
    CALL "add_i32" USING BY VALUE a1 BY VALUE clip-a RETURNING tspan
    CALL "ugt_u32" USING BY VALUE tspan BY VALUE two-clip RETURNING bit-n
    IF bit-n = 1
        CALL "sub_i32" USING BY VALUE tspan BY VALUE two-clip RETURNING tspan
        CALL "uge_u32" USING BY VALUE tspan BY VALUE span-a RETURNING bit-n
        IF bit-n = 1
            EXIT PARAGRAPH
        END-IF
        MOVE clip-a TO a1
    END-IF
    CALL "sub_i32" USING BY VALUE clip-a BY VALUE a2 RETURNING tspan
    CALL "ugt_u32" USING BY VALUE tspan BY VALUE two-clip RETURNING bit-n
    IF bit-n = 1
        CALL "sub_i32" USING BY VALUE tspan BY VALUE two-clip RETURNING tspan
        CALL "uge_u32" USING BY VALUE tspan BY VALUE span-a RETURNING bit-n
        IF bit-n = 1
            EXIT PARAGRAPH
        END-IF
        CALL "sub_i32" USING BY VALUE 0 BY VALUE clip-a RETURNING a2
    END-IF
    CALL "add_i32" USING BY VALUE a1 BY VALUE ang-90 RETURNING tmp
    CALL "ushr_i" USING BY VALUE tmp BY VALUE 19 RETURNING idx
    CALL "bit_and" USING BY VALUE idx BY VALUE 4095 RETURNING idx
    COMPUTE slot = idx + 1
    MOVE vat(slot) TO x1
    CALL "add_i32" USING BY VALUE a2 BY VALUE ang-90 RETURNING tmp
    CALL "ushr_i" USING BY VALUE tmp BY VALUE 19 RETURNING idx
    CALL "bit_and" USING BY VALUE idx BY VALUE 4095 RETURNING idx
    COMPUTE slot = idx + 1
    MOVE vat(slot) TO x2
    IF x1 = x2
        EXIT PARAGRAPH
    END-IF
    MOVE x1 TO first-x
    COMPUTE last-x = x2 - 1
    IF sg-back(cur-seg) < 0
        PERFORM clip-solid
    ELSE
        COMPUTE back-sec = sg-back(cur-seg) + 1
        IF sec-ceil-h(back-sec) <= sec-floor-h(front-sec)
            OR sec-floor-h(back-sec) >= sec-ceil-h(front-sec)
            PERFORM clip-solid
        ELSE
            PERFORM clip-pass
        END-IF
    END-IF
    .

clip-solid.
    IF first-x > last-x
        EXIT PARAGRAPH
    END-IF
    MOVE 0 TO start-i
    PERFORM UNTIL start-i >= new-end
        COMPUTE slot = start-i + 1
        CALL "sub_i32" USING BY VALUE first-x BY VALUE 1 RETURNING lim
        IF solid-b(slot) >= lim
            EXIT PERFORM
        END-IF
        ADD 1 TO start-i
    END-PERFORM
    IF start-i >= new-end
        PERFORM store-wall
        EXIT PARAGRAPH
    END-IF
    COMPUTE slot = start-i + 1
    IF first-x < solid-a(slot)
        CALL "sub_i32" USING BY VALUE solid-a(slot) BY VALUE 1 RETURNING lim
        IF last-x < lim
            PERFORM store-wall
            PERFORM insert-solid
            EXIT PARAGRAPH
        END-IF
        MOVE last-x TO save-last
        MOVE lim TO last-x
        PERFORM store-wall
        MOVE save-last TO last-x
        COMPUTE slot = start-i + 1
        MOVE first-x TO solid-a(slot)
    END-IF
    COMPUTE slot = start-i + 1
    IF last-x <= solid-b(slot)
        EXIT PARAGRAPH
    END-IF
    MOVE start-i TO next-i
    PERFORM UNTIL next-i + 1 >= new-end
        COMPUTE slot = next-i + 1
        COMPUTE peek = next-i + 2
        CALL "sub_i32" USING BY VALUE solid-a(peek) BY VALUE 1 RETURNING lim
        IF last-x < lim
            EXIT PERFORM
        END-IF
        CALL "add_i32" USING BY VALUE solid-b(slot) BY VALUE 1 RETURNING tmp
        MOVE first-x TO save-first
        MOVE last-x TO save-last
        MOVE tmp TO first-x
        MOVE lim TO last-x
        PERFORM store-wall
        MOVE save-first TO first-x
        MOVE save-last TO last-x
        ADD 1 TO next-i
        COMPUTE slot = next-i + 1
        IF last-x <= solid-b(slot)
            MOVE solid-b(slot) TO solid-b(start-i + 1)
            PERFORM crunch-solid
            EXIT PARAGRAPH
        END-IF
    END-PERFORM
    COMPUTE slot = next-i + 1
    CALL "add_i32" USING BY VALUE solid-b(slot) BY VALUE 1 RETURNING tmp
    MOVE first-x TO save-first
    MOVE tmp TO first-x
    PERFORM store-wall
    MOVE save-first TO first-x
    MOVE last-x TO solid-b(start-i + 1)
    PERFORM crunch-solid
    .

clip-pass.
    IF first-x > last-x
        EXIT PARAGRAPH
    END-IF
    MOVE 0 TO start-i
    PERFORM UNTIL start-i >= new-end
        COMPUTE slot = start-i + 1
        CALL "sub_i32" USING BY VALUE first-x BY VALUE 1 RETURNING lim
        IF solid-b(slot) >= lim
            EXIT PERFORM
        END-IF
        ADD 1 TO start-i
    END-PERFORM
    IF start-i >= new-end
        PERFORM store-wall
        EXIT PARAGRAPH
    END-IF
    COMPUTE slot = start-i + 1
    IF first-x < solid-a(slot)
        CALL "sub_i32" USING BY VALUE solid-a(slot) BY VALUE 1 RETURNING lim
        IF last-x < lim
            PERFORM store-wall
            EXIT PARAGRAPH
        END-IF
        MOVE last-x TO save-last
        MOVE lim TO last-x
        PERFORM store-wall
        MOVE save-last TO last-x
    END-IF
    COMPUTE slot = start-i + 1
    IF last-x <= solid-b(slot)
        EXIT PARAGRAPH
    END-IF
    MOVE start-i TO next-i
    PERFORM UNTIL next-i + 1 >= new-end
        COMPUTE slot = next-i + 1
        COMPUTE peek = next-i + 2
        CALL "sub_i32" USING BY VALUE solid-a(peek) BY VALUE 1 RETURNING lim
        IF last-x < lim
            EXIT PERFORM
        END-IF
        CALL "add_i32" USING BY VALUE solid-b(slot) BY VALUE 1 RETURNING tmp
        MOVE first-x TO save-first
        MOVE last-x TO save-last
        MOVE tmp TO first-x
        MOVE lim TO last-x
        PERFORM store-wall
        MOVE save-first TO first-x
        MOVE save-last TO last-x
        ADD 1 TO next-i
        COMPUTE slot = next-i + 1
        IF last-x <= solid-b(slot)
            EXIT PARAGRAPH
        END-IF
    END-PERFORM
    COMPUTE slot = next-i + 1
    CALL "add_i32" USING BY VALUE solid-b(slot) BY VALUE 1 RETURNING tmp
    MOVE first-x TO save-first
    MOVE tmp TO first-x
    PERFORM store-wall
    MOVE save-first TO first-x
    .

insert-solid.
    IF new-end >= 128
        EXIT PARAGRAPH
    END-IF
    COMPUTE k = new-end - 1
    PERFORM UNTIL k < start-i
        COMPUTE slot = k + 1
        COMPUTE peek = k + 2
        MOVE solid-a(slot) TO solid-a(peek)
        MOVE solid-b(slot) TO solid-b(peek)
        SUBTRACT 1 FROM k
    END-PERFORM
    COMPUTE slot = start-i + 1
    MOVE first-x TO solid-a(slot)
    MOVE last-x TO solid-b(slot)
    ADD 1 TO new-end
    .

crunch-solid.
    IF next-i = start-i
        EXIT PARAGRAPH
    END-IF
    COMPUTE src = next-i + 1
    COMPUTE dst = start-i + 1
    MOVE new-end TO old-end
    PERFORM UNTIL src >= old-end
        COMPUTE slot = src + 1
        COMPUTE peek = dst + 1
        MOVE solid-a(slot) TO solid-a(peek)
        MOVE solid-b(slot) TO solid-b(peek)
        ADD 1 TO src
        ADD 1 TO dst
    END-PERFORM
    COMPUTE new-end = start-i + old-end - next-i
    .

store-wall.
    IF first-x > last-x
        EXIT PARAGRAPH
    END-IF
    MOVE first-x TO rng-a
    MOVE last-x TO rng-b
    MOVE sg-line(cur-seg) TO line-slot
    MOVE sg-sd(cur-seg) TO sd-slot
    IF line-slot < 1 OR line-slot > n-line
        EXIT PARAGRAPH
    END-IF
    CALL "bit_or" USING BY VALUE ln-flags(line-slot) BY VALUE 256
        RETURNING flag-n
    MOVE flag-n TO ln-flags(line-slot)
    CALL "add_i32" USING BY VALUE sg-ang(cur-seg) BY VALUE ang-90
        RETURNING rw-norm
    CALL "sub_i32" USING BY VALUE rw-norm BY VALUE rw-ang1 RETURNING tmp
    CALL "ugt_u32" USING BY VALUE tmp BY VALUE ang-180 RETURNING bit-n
    IF bit-n = 1
        CALL "sub_i32" USING BY VALUE 0 BY VALUE tmp RETURNING tmp
    END-IF
    CALL "ugt_u32" USING BY VALUE tmp BY VALUE ang-90 RETURNING bit-n
    IF bit-n = 1
        MOVE ang-90 TO tmp
    END-IF
    CALL "sub_i32" USING BY VALUE ang-90 BY VALUE tmp RETURNING ang-in
    PERFORM sine-at
    MOVE vtx-x(v1-slot) TO px
    MOVE vtx-y(v1-slot) TO py
    PERFORM point-to-dist
    MOVE dist-out TO hyp-d
    CALL "fixed_mul" USING BY VALUE hyp-d BY VALUE sin-out RETURNING rw-dist
    MOVE rng-a TO rw-x
    COMPUTE rw-stop = rng-b + 1
    CALL "add_i32" USING BY VALUE view-ang BY VALUE xtv(rng-a + 1)
        RETURNING vis-ang
    PERFORM scale-from
    MOVE scale-out TO rw-scale
    IF rng-b > rng-a
        CALL "add_i32" USING BY VALUE view-ang BY VALUE xtv(rng-b + 1)
            RETURNING vis-ang
        PERFORM scale-from
        CALL "sub_i32" USING BY VALUE scale-out BY VALUE rw-scale
            RETURNING tmp
        COMPUTE sh = rng-b - rng-a
        CALL "floor_div_i" USING BY VALUE tmp BY VALUE sh RETURNING rw-step
    ELSE
        MOVE 0 TO rw-step
    END-IF
    CALL "sub_i32" USING BY VALUE sec-ceil-h(front-sec) BY VALUE view-z
        RETURNING world-top
    CALL "sub_i32" USING BY VALUE sec-floor-h(front-sec) BY VALUE view-z
        RETURNING world-bot
    MOVE 0 TO mid-tex
    MOVE 0 TO top-tex
    MOVE 0 TO bot-tex
    MOVE 0 TO masked-tex
    MOVE 0 TO seg-tex
    IF sd-slot >= 1
        MOVE sd-yoff(sd-slot) TO row-off
        MOVE sd-xoff(sd-slot) TO col-off
    ELSE
        MOVE 0 TO row-off
        MOVE 0 TO col-off
    END-IF
    IF sg-back(cur-seg) < 0
        MOVE 0 TO has-back
        IF sd-slot >= 1
            MOVE sd-mid(sd-slot) TO mid-tex
        END-IF
        MOVE 1 TO mark-floor
        MOVE 1 TO mark-ceil
        CALL "bit_and" USING BY VALUE flag-n BY VALUE 16 RETURNING bit-n
        IF bit-n NOT = 0
            MOVE mid-tex TO tex-id
            PERFORM tex-height
            CALL "add_i32" USING BY VALUE sec-floor-h(front-sec)
                BY VALUE th-out RETURNING tmp
            CALL "sub_i32" USING BY VALUE tmp BY VALUE view-z RETURNING rw-mid
        ELSE
            MOVE world-top TO rw-mid
        END-IF
        CALL "add_i32" USING BY VALUE rw-mid BY VALUE row-off RETURNING rw-mid
    ELSE
        MOVE 1 TO has-back
        COMPUTE back-sec = sg-back(cur-seg) + 1
        CALL "sub_i32" USING BY VALUE sec-ceil-h(back-sec) BY VALUE view-z
            RETURNING world-hi
        CALL "sub_i32" USING BY VALUE sec-floor-h(back-sec) BY VALUE view-z
            RETURNING world-lo
        IF sec-ceil-pic(front-sec) = sky-flat
            AND sec-ceil-pic(back-sec) = sky-flat
            MOVE world-hi TO world-top
        END-IF
        MOVE 0 TO mark-floor
        IF world-lo NOT = world-bot
            OR sec-floor-pic(back-sec) NOT = sec-floor-pic(front-sec)
            OR sec-flight(back-sec) NOT = sec-flight(front-sec)
            MOVE 1 TO mark-floor
        END-IF
        MOVE 0 TO mark-ceil
        IF world-hi NOT = world-top
            OR sec-ceil-pic(back-sec) NOT = sec-ceil-pic(front-sec)
            OR sec-flight(back-sec) NOT = sec-flight(front-sec)
            MOVE 1 TO mark-ceil
        END-IF
        IF sec-ceil-h(back-sec) <= sec-floor-h(front-sec)
            OR sec-floor-h(back-sec) >= sec-ceil-h(front-sec)
            MOVE 1 TO mark-floor
            MOVE 1 TO mark-ceil
        END-IF
        IF world-hi < world-top
            IF sd-slot >= 1
                MOVE sd-top(sd-slot) TO top-tex
            END-IF
            CALL "bit_and" USING BY VALUE flag-n BY VALUE 8 RETURNING bit-n
            IF bit-n NOT = 0
                MOVE world-top TO rw-topm
            ELSE
                MOVE top-tex TO tex-id
                PERFORM tex-height
                CALL "add_i32" USING BY VALUE sec-ceil-h(back-sec)
                    BY VALUE th-out RETURNING tmp
                CALL "sub_i32" USING BY VALUE tmp BY VALUE view-z
                    RETURNING rw-topm
            END-IF
            CALL "add_i32" USING BY VALUE rw-topm BY VALUE row-off
                RETURNING rw-topm
        END-IF
        IF world-lo > world-bot
            IF sd-slot >= 1
                MOVE sd-bot(sd-slot) TO bot-tex
            END-IF
            CALL "bit_and" USING BY VALUE flag-n BY VALUE 16 RETURNING bit-n
            IF bit-n NOT = 0
                MOVE world-top TO rw-botm
            ELSE
                MOVE world-lo TO rw-botm
            END-IF
            CALL "add_i32" USING BY VALUE rw-botm BY VALUE row-off
                RETURNING rw-botm
        END-IF
        IF sd-slot >= 1 AND sd-mid(sd-slot) NOT = 0
            MOVE 1 TO masked-tex
            MOVE sd-mid(sd-slot) TO mask-id
            MOVE mask-id TO tex-id
            PERFORM tex-height
            CALL "bit_and" USING BY VALUE flag-n BY VALUE 16
                RETURNING bit-n
            IF bit-n NOT = 0
                IF sec-floor-h(front-sec) > sec-floor-h(back-sec)
                    MOVE sec-floor-h(front-sec) TO tmp
                ELSE
                    MOVE sec-floor-h(back-sec) TO tmp
                END-IF
                CALL "add_i32" USING BY VALUE tmp BY VALUE th-out
                    RETURNING tmp
                CALL "sub_i32" USING BY VALUE tmp BY VALUE view-z
                    RETURNING rw-mask
            ELSE
                IF sec-ceil-h(front-sec) < sec-ceil-h(back-sec)
                    MOVE sec-ceil-h(front-sec) TO tmp
                ELSE
                    MOVE sec-ceil-h(back-sec) TO tmp
                END-IF
                CALL "sub_i32" USING BY VALUE tmp BY VALUE view-z
                    RETURNING rw-mask
            END-IF
            CALL "add_i32" USING BY VALUE rw-mask BY VALUE row-off
                RETURNING rw-mask
        END-IF
    END-IF
    IF mid-tex NOT = 0 OR top-tex NOT = 0 OR bot-tex NOT = 0
        OR masked-tex NOT = 0
        MOVE 1 TO seg-tex
    END-IF
    IF seg-tex = 1
        CALL "sub_i32" USING BY VALUE rw-norm BY VALUE rw-ang1 RETURNING tmp
        MOVE tmp TO ang-in
        CALL "ugt_u32" USING BY VALUE tmp BY VALUE ang-180 RETURNING bit-n
        IF bit-n = 1
            CALL "sub_i32" USING BY VALUE 0 BY VALUE tmp RETURNING ang-in
        END-IF
        PERFORM sine-at
        CALL "fixed_mul" USING BY VALUE hyp-d BY VALUE sin-out RETURNING rw-off
        CALL "sub_i32" USING BY VALUE rw-norm BY VALUE rw-ang1 RETURNING tmp
        CALL "uge_u32" USING BY VALUE tmp BY VALUE ang-180 RETURNING bit-n
        IF bit-n = 0
            CALL "sub_i32" USING BY VALUE 0 BY VALUE rw-off RETURNING rw-off
        END-IF
        CALL "add_i32" USING BY VALUE rw-off BY VALUE col-off RETURNING rw-off
        CALL "add_i32" USING BY VALUE rw-off BY VALUE sg-ofs(cur-seg)
            RETURNING rw-off
        CALL "sub_i32" USING BY VALUE view-ang BY VALUE rw-norm RETURNING tmp
        CALL "add_i32" USING BY VALUE ang-90 BY VALUE tmp RETURNING rw-center
    END-IF
    IF sec-floor-h(front-sec) >= view-z
        MOVE 0 TO mark-floor
    END-IF
    IF sec-ceil-h(front-sec) <= view-z
        AND sec-ceil-pic(front-sec) NOT = sky-flat
        MOVE 0 TO mark-ceil
    END-IF
    IF mark-ceil = 1
        MOVE ceil-pl TO pl-i
        MOVE rng-a TO span-a
        MOVE rng-b TO span-b
        PERFORM check-plane
        MOVE pl-out TO ceil-pl
    END-IF
    IF mark-floor = 1
        MOVE floor-pl TO pl-i
        MOVE rng-a TO span-a
        MOVE rng-b TO span-b
        PERFORM check-plane
        MOVE pl-out TO floor-pl
    END-IF
    CALL "shar32" USING BY VALUE world-top BY VALUE 4 RETURNING world-top
    CALL "shar32" USING BY VALUE world-bot BY VALUE 4 RETURNING world-bot
    CALL "fixed_mul" USING BY VALUE rw-step BY VALUE world-top RETURNING tmp
    CALL "sub_i32" USING BY VALUE 0 BY VALUE tmp RETURNING top-step
    CALL "fixed_mul" USING BY VALUE world-top BY VALUE rw-scale RETURNING tmp
    CALL "sub_i32" USING BY VALUE cy4 BY VALUE tmp RETURNING top-frac
    CALL "fixed_mul" USING BY VALUE rw-step BY VALUE world-bot RETURNING tmp
    CALL "sub_i32" USING BY VALUE 0 BY VALUE tmp RETURNING bot-step
    CALL "fixed_mul" USING BY VALUE world-bot BY VALUE rw-scale RETURNING tmp
    CALL "sub_i32" USING BY VALUE cy4 BY VALUE tmp RETURNING bot-frac
    IF has-back = 1
        CALL "shar32" USING BY VALUE world-hi BY VALUE 4 RETURNING world-hi
        CALL "shar32" USING BY VALUE world-lo BY VALUE 4 RETURNING world-lo
        IF world-hi < world-top
            CALL "fixed_mul" USING BY VALUE world-hi BY VALUE rw-scale
                RETURNING tmp
            CALL "sub_i32" USING BY VALUE cy4 BY VALUE tmp RETURNING pix-hi
            CALL "fixed_mul" USING BY VALUE rw-step BY VALUE world-hi
                RETURNING tmp
            CALL "sub_i32" USING BY VALUE 0 BY VALUE tmp RETURNING hi-step
        END-IF
        IF world-lo > world-bot
            CALL "fixed_mul" USING BY VALUE world-lo BY VALUE rw-scale
                RETURNING tmp
            CALL "sub_i32" USING BY VALUE cy4 BY VALUE tmp RETURNING pix-lo
            CALL "fixed_mul" USING BY VALUE rw-step BY VALUE world-lo
                RETURNING tmp
            CALL "sub_i32" USING BY VALUE 0 BY VALUE tmp RETURNING lo-step
        END-IF
    END-IF
    MOVE rw-scale TO scale-save
    PERFORM render-cols
    PERFORM push-drawseg
    .

render-cols.
    PERFORM UNTIL rw-x >= rw-stop
        CALL "add_i32" USING BY VALUE top-frac BY VALUE 4095 RETURNING tmp
        CALL "shar32" USING BY VALUE tmp BY VALUE 12 RETURNING yl
        COMPUTE slot = rw-x + 1
        COMPUTE clip-top = ceil-clip(slot) + 1
        IF yl < clip-top
            MOVE clip-top TO yl
        END-IF
        IF mark-ceil = 1 AND ceil-pl > 0
            MOVE clip-top TO span-top
            COMPUTE span-bot = yl - 1
            IF span-bot >= floor-clip(slot)
                COMPUTE span-bot = floor-clip(slot) - 1
            END-IF
            IF span-top <= span-bot
                COMPUTE vp-at = (ceil-pl - 1) * 320 + rw-x + 1
                MOVE span-top TO vp-top(vp-at)
                MOVE span-bot TO vp-bot(vp-at)
            END-IF
        END-IF
        CALL "shar32" USING BY VALUE bot-frac BY VALUE 12 RETURNING yh
        COMPUTE slot = rw-x + 1
        IF yh >= floor-clip(slot)
            COMPUTE yh = floor-clip(slot) - 1
        END-IF
        IF mark-floor = 1 AND floor-pl > 0
            COMPUTE span-top = yh + 1
            COMPUTE span-bot = floor-clip(slot) - 1
            IF span-top <= ceil-clip(slot)
                COMPUTE span-top = ceil-clip(slot) + 1
            END-IF
            IF span-top <= span-bot
                COMPUTE vp-at = (floor-pl - 1) * 320 + rw-x + 1
                MOVE span-top TO vp-top(vp-at)
                MOVE span-bot TO vp-bot(vp-at)
            END-IF
        END-IF
        IF seg-tex = 1
            PERFORM column-setup
        END-IF
        COMPUTE slot = rw-x + 1
        IF mid-tex NOT = 0
            MOVE yl TO dc-yl
            MOVE yh TO dc-yh
            MOVE rw-mid TO dc-mid
            MOVE mid-tex TO tex-id
            MOVE tex-col TO col-n
            PERFORM fetch-column
            PERFORM draw-column
            MOVE view-h TO ceil-clip(slot)
            MOVE -1 TO floor-clip(slot)
        ELSE
            IF top-tex NOT = 0
                CALL "shar32" USING BY VALUE pix-hi BY VALUE 12
                    RETURNING mid-y
                CALL "add_i32" USING BY VALUE pix-hi BY VALUE hi-step
                    RETURNING pix-hi
                COMPUTE slot = rw-x + 1
                IF mid-y >= floor-clip(slot)
                    COMPUTE mid-y = floor-clip(slot) - 1
                END-IF
                IF mid-y >= yl
                    MOVE yl TO dc-yl
                    MOVE mid-y TO dc-yh
                    MOVE rw-topm TO dc-mid
                    MOVE top-tex TO tex-id
                    MOVE tex-col TO col-n
                    PERFORM fetch-column
                    PERFORM draw-column
                    COMPUTE slot = rw-x + 1
                    MOVE mid-y TO ceil-clip(slot)
                ELSE
                    COMPUTE ceil-clip(slot) = yl - 1
                END-IF
            ELSE
                IF mark-ceil = 1
                    COMPUTE ceil-clip(slot) = yl - 1
                END-IF
            END-IF
            IF bot-tex NOT = 0
                CALL "add_i32" USING BY VALUE pix-lo BY VALUE 4095
                    RETURNING tmp
                CALL "shar32" USING BY VALUE tmp BY VALUE 12 RETURNING mid-y
                CALL "add_i32" USING BY VALUE pix-lo BY VALUE lo-step
                    RETURNING pix-lo
                COMPUTE slot = rw-x + 1
                IF mid-y <= ceil-clip(slot)
                    COMPUTE mid-y = ceil-clip(slot) + 1
                END-IF
                IF mid-y <= yh
                    MOVE mid-y TO dc-yl
                    MOVE yh TO dc-yh
                    MOVE rw-botm TO dc-mid
                    MOVE bot-tex TO tex-id
                    MOVE tex-col TO col-n
                    PERFORM fetch-column
                    PERFORM draw-column
                    COMPUTE slot = rw-x + 1
                    MOVE mid-y TO floor-clip(slot)
                ELSE
                    COMPUTE floor-clip(slot) = yh + 1
                END-IF
            ELSE
                IF mark-floor = 1
                    COMPUTE slot = rw-x + 1
                    COMPUTE floor-clip(slot) = yh + 1
                END-IF
            END-IF
        END-IF
        IF masked-tex = 1
            COMPUTE peek = rw-x + 1
            MOVE tex-col TO mhold-col(peek)
            MOVE dc-map TO mhold-lit(peek)
        END-IF
        CALL "add_i32" USING BY VALUE rw-scale BY VALUE rw-step
            RETURNING rw-scale
        CALL "add_i32" USING BY VALUE top-frac BY VALUE top-step
            RETURNING top-frac
        CALL "add_i32" USING BY VALUE bot-frac BY VALUE bot-step
            RETURNING bot-frac
        ADD 1 TO rw-x
    END-PERFORM
    .

column-setup.
    COMPUTE slot = rw-x + 1
    CALL "add_i32" USING BY VALUE rw-center BY VALUE xtv(slot)
        RETURNING ang-in
    CALL "ushr_i" USING BY VALUE ang-in BY VALUE 19 RETURNING idx
    CALL "bit_and" USING BY VALUE idx BY VALUE 4095 RETURNING idx
    COMPUTE slot = idx + 1
    MOVE finetangent(slot) TO tan-v
    CALL "fixed_mul" USING BY VALUE tan-v BY VALUE rw-dist RETURNING tmp
    CALL "sub_i32" USING BY VALUE rw-off BY VALUE tmp RETURNING tmp
    CALL "shar32" USING BY VALUE tmp BY VALUE 16 RETURNING tex-col
    CALL "ushr_i" USING BY VALUE rw-scale BY VALUE 12 RETURNING idx
    IF idx >= 48
        MOVE 47 TO idx
    END-IF
    IF idx < 0
        MOVE 47 TO idx
    END-IF
    COMPUTE slot = wall-base + idx + 1
    MOVE scale-light(slot) TO dc-map
    MOVE rw-x TO dc-x
    IF rw-scale = 0
        MOVE 0 TO dc-step
    ELSE
        CALL "udiv_u32" USING BY VALUE -1 BY VALUE rw-scale
            RETURNING dc-step
    END-IF
    .

fetch-column.
    CALL "tex-column" USING tex-id col-n dc-src
    .

draw-column.
    IF dc-x < 0 OR dc-x >= view-w
        EXIT PARAGRAPH
    END-IF
    COMPUTE count-n = dc-yh - dc-yl
    IF count-n < 0
        EXIT PARAGRAPH
    END-IF
    MOVE dc-yl TO y-i
    IF y-i < 0
        MOVE 0 TO y-i
    END-IF
    IF y-i > 199
        MOVE 199 TO y-i
    END-IF
    COMPUTE prod = dc-yl - center-y
    CALL "mul_i32" USING BY VALUE prod BY VALUE dc-step RETURNING prod
    CALL "add_i32" USING BY VALUE dc-mid BY VALUE prod RETURNING frac
    PERFORM UNTIL count-n < 0
        IF y-i < 0 OR y-i >= 200
            EXIT PERFORM
        END-IF
        COMPUTE dest-at = (y-i + view-oy) * 320 + dc-x + view-ox
        IF dest-at < 0 OR dest-at >= 64000
            EXIT PERFORM
        END-IF
        CALL "ushr_i" USING BY VALUE frac BY VALUE 16 RETURNING idx
        CALL "bit_and" USING BY VALUE idx BY VALUE 127 RETURNING idx
        CALL "byte_at" USING BY REFERENCE dc-src BY VALUE idx RETURNING pix
        COMPUTE at-pos = dc-map * 256 + pix
        CALL "byte_at" USING BY REFERENCE cmap-buf BY VALUE at-pos
            RETURNING byte-n
        CALL "poke_byte" USING BY REFERENCE fb BY VALUE dest-at
            BY VALUE byte-n
        CALL "add_i32" USING BY VALUE frac BY VALUE dc-step RETURNING frac
        ADD 1 TO y-i
        SUBTRACT 1 FROM count-n
    END-PERFORM
    .

draw-hole.
    IF dc-x < 0 OR dc-x >= view-w
        EXIT PARAGRAPH
    END-IF
    COMPUTE count-n = dc-yh - dc-yl
    IF count-n < 0
        EXIT PARAGRAPH
    END-IF
    MOVE dc-yl TO y-i
    IF y-i < 0
        MOVE 0 TO y-i
    END-IF
    IF y-i > 199
        MOVE 199 TO y-i
    END-IF
    COMPUTE prod = dc-yl - center-y
    CALL "mul_i32" USING BY VALUE prod BY VALUE dc-step RETURNING prod
    CALL "add_i32" USING BY VALUE dc-mid BY VALUE prod RETURNING frac
    PERFORM UNTIL count-n < 0
        IF y-i < 0 OR y-i >= 200
            EXIT PERFORM
        END-IF
        COMPUTE dest-at = (y-i + view-oy) * 320 + dc-x + view-ox
        IF dest-at < 0 OR dest-at >= 64000
            EXIT PERFORM
        END-IF
        CALL "ushr_i" USING BY VALUE frac BY VALUE 16 RETURNING idx
        CALL "bit_and" USING BY VALUE idx BY VALUE 127 RETURNING idx
        CALL "byte_at" USING BY REFERENCE dc-src BY VALUE idx RETURNING pix
        IF pix NOT = 0
            COMPUTE at-pos = dc-map * 256 + pix
            CALL "byte_at" USING BY REFERENCE cmap-buf BY VALUE at-pos
                RETURNING byte-n
            CALL "poke_byte" USING BY REFERENCE fb BY VALUE dest-at
                BY VALUE byte-n
        END-IF
        CALL "add_i32" USING BY VALUE frac BY VALUE dc-step RETURNING frac
        ADD 1 TO y-i
        SUBTRACT 1 FROM count-n
    END-PERFORM
    .

draw-planes.
    PERFORM VARYING pl-i FROM 1 BY 1 UNTIL pl-i > n-plane
        IF vp-min(pl-i) <= vp-max(pl-i)
            IF vp-pic(pl-i) = sky-flat
                PERFORM draw-sky
            ELSE
                PERFORM draw-flat
            END-IF
        END-IF
    END-PERFORM
    .

draw-sky.
    MOVE 58982 TO dc-step
    MOVE 6553600 TO dc-mid
    MOVE 0 TO dc-map
    MOVE vp-min(pl-i) TO x-i
    MOVE vp-max(pl-i) TO x-end
    PERFORM UNTIL x-i > x-end
        IF x-i >= 0 AND x-i < view-w
            COMPUTE vp-at = (pl-i - 1) * 320 + x-i + 1
            MOVE vp-top(vp-at) TO t1
            MOVE vp-bot(vp-at) TO b1
            IF t1 <= b1 AND t1 < 255
                CALL "add_i32" USING BY VALUE view-ang BY VALUE xtv(x-i + 1)
                    RETURNING ang-in
                CALL "ushr_i" USING BY VALUE ang-in BY VALUE 22 RETURNING col-n
                MOVE sky-tex TO tex-id
                MOVE x-i TO dc-x
                MOVE t1 TO dc-yl
                MOVE b1 TO dc-yh
                PERFORM fetch-column
                PERFORM draw-column
            END-IF
        END-IF
        ADD 1 TO x-i
    END-PERFORM
    .

draw-flat.
    CALL "ushr_i" USING BY VALUE vp-light(pl-i) BY VALUE 4 RETURNING light-n
    ADD extra-l TO light-n
    IF light-n < 0
        MOVE 0 TO light-n
    END-IF
    IF light-n > 15
        MOVE 15 TO light-n
    END-IF
    COMPUTE wall-base = light-n * 128
    IF vp-pic(pl-i) NOT = flat-have
        MOVE vp-pic(pl-i) TO tex-id
        CALL "flat-load" USING tex-id flat-buf nread
        MOVE vp-pic(pl-i) TO flat-have
    END-IF
    CALL "sub_i32" USING BY VALUE vp-h(pl-i) BY VALUE view-z RETURNING tmp
    CALL "abs_fixed_i" USING BY VALUE tmp RETURNING plane-h
    IF plane-h = 0
        EXIT PARAGRAPH
    END-IF
    MOVE vp-min(pl-i) TO x-i
    IF x-i < 0
        MOVE 0 TO x-i
    END-IF
    MOVE vp-max(pl-i) TO x-end
    COMPUTE tmp = view-w - 1
    IF x-end > tmp
        MOVE tmp TO x-end
    END-IF
    PERFORM UNTIL x-i > x-end
        COMPUTE vp-at = (pl-i - 1) * 320 + x-i + 1
        MOVE vp-top(vp-at) TO t1
        MOVE vp-bot(vp-at) TO b1
        IF t1 <= b1 AND t1 NOT = 255
            MOVE b1 TO y-end
            COMPUTE tmp = view-h - 1
            IF y-end > tmp
                MOVE tmp TO y-end
            END-IF
            IF t1 < 0
                MOVE 0 TO t1
            END-IF
            CALL "add_i32" USING BY VALUE view-ang BY VALUE xtv(x-i + 1)
                RETURNING ang-in
            CALL "ushr_i" USING BY VALUE ang-in BY VALUE 19 RETURNING idx
            CALL "bit_and" USING BY VALUE idx BY VALUE 8191 RETURNING idx
            COMPUTE slot = idx + 1
            MOVE finesine(slot) TO sin-v
            COMPUTE slot = idx + 2048
            CALL "bit_and" USING BY VALUE slot BY VALUE 8191 RETURNING slot
            ADD 1 TO slot
            MOVE finesine(slot) TO cos-v
            PERFORM VARYING y-i FROM t1 BY 1 UNTIL y-i > y-end
                CALL "fixed_mul" USING BY VALUE plane-h BY VALUE yslope(y-i + 1)
                    RETURNING dist-n
                CALL "fixed_mul" USING BY VALUE dist-n
                    BY VALUE dist-scale(x-i + 1) RETURNING run-len
                CALL "fixed_mul" USING BY VALUE cos-v BY VALUE run-len
                    RETURNING tmp
                CALL "add_i32" USING BY VALUE view-x BY VALUE tmp RETURNING dx
                CALL "fixed_mul" USING BY VALUE sin-v BY VALUE run-len
                    RETURNING tmp
                CALL "sub_i32" USING BY VALUE 0 BY VALUE view-y RETURNING dy
                CALL "sub_i32" USING BY VALUE dy BY VALUE tmp RETURNING dy
                CALL "ushr_i" USING BY VALUE dist-n BY VALUE 20 RETURNING idx
                IF idx > 127
                    MOVE 127 TO idx
                END-IF
                IF idx < 0
                    MOVE 127 TO idx
                END-IF
                COMPUTE slot = wall-base + idx + 1
                MOVE z-light(slot) TO dc-map
                CALL "ushr_i" USING BY VALUE dx BY VALUE 16 RETURNING pix
                CALL "bit_and" USING BY VALUE pix BY VALUE 63 RETURNING pix
                CALL "ushr_i" USING BY VALUE dy BY VALUE 10 RETURNING byte-n
                CALL "bit_and" USING BY VALUE byte-n BY VALUE 4032
                    RETURNING byte-n
                CALL "bit_or" USING BY VALUE pix BY VALUE byte-n RETURNING pix
                CALL "byte_at" USING BY REFERENCE flat-buf BY VALUE pix
                    RETURNING byte-n
                COMPUTE at-pos = dc-map * 256 + byte-n
                CALL "byte_at" USING BY REFERENCE cmap-buf BY VALUE at-pos
                    RETURNING prod
                COMPUTE dest-at = (y-i + view-oy) * 320 + x-i + view-ox
                CALL "poke_byte" USING BY REFERENCE fb BY VALUE dest-at
                    BY VALUE prod
            END-PERFORM
        END-IF
        ADD 1 TO x-i
    END-PERFORM
    .

point-to-angle.
    CALL "sub_i32" USING BY VALUE px BY VALUE view-x RETURNING dx
    CALL "sub_i32" USING BY VALUE py BY VALUE view-y RETURNING dy
    IF dx = 0 AND dy = 0
        MOVE 0 TO ang-out
        EXIT PARAGRAPH
    END-IF
    IF dx >= 0
        IF dy >= 0
            IF dx > dy
                CALL "slope_div_i" USING BY VALUE dy BY VALUE dx RETURNING idx
                COMPUTE slot = idx + 1
                MOVE tantoangle(slot) TO ang-out
            ELSE
                CALL "slope_div_i" USING BY VALUE dx BY VALUE dy RETURNING idx
                COMPUTE slot = idx + 1
                CALL "sub_i32" USING BY VALUE ang-90 BY VALUE 1 RETURNING tmp
                CALL "sub_i32" USING BY VALUE tmp BY VALUE tantoangle(slot)
                    RETURNING ang-out
            END-IF
        ELSE
            CALL "sub_i32" USING BY VALUE 0 BY VALUE dy RETURNING dy
            IF dx > dy
                CALL "slope_div_i" USING BY VALUE dy BY VALUE dx RETURNING idx
                COMPUTE slot = idx + 1
                CALL "sub_i32" USING BY VALUE 0 BY VALUE tantoangle(slot)
                    RETURNING ang-out
            ELSE
                CALL "slope_div_i" USING BY VALUE dx BY VALUE dy RETURNING idx
                COMPUTE slot = idx + 1
                CALL "add_i32" USING BY VALUE ang-270 BY VALUE tantoangle(slot)
                    RETURNING ang-out
            END-IF
        END-IF
    ELSE
        CALL "sub_i32" USING BY VALUE 0 BY VALUE dx RETURNING dx
        IF dy >= 0
            IF dx > dy
                CALL "slope_div_i" USING BY VALUE dy BY VALUE dx RETURNING idx
                COMPUTE slot = idx + 1
                CALL "sub_i32" USING BY VALUE ang-180 BY VALUE 1 RETURNING tmp
                CALL "sub_i32" USING BY VALUE tmp BY VALUE tantoangle(slot)
                    RETURNING ang-out
            ELSE
                CALL "slope_div_i" USING BY VALUE dx BY VALUE dy RETURNING idx
                COMPUTE slot = idx + 1
                CALL "add_i32" USING BY VALUE ang-90 BY VALUE tantoangle(slot)
                    RETURNING ang-out
            END-IF
        ELSE
            CALL "sub_i32" USING BY VALUE 0 BY VALUE dy RETURNING dy
            IF dx > dy
                CALL "slope_div_i" USING BY VALUE dy BY VALUE dx RETURNING idx
                COMPUTE slot = idx + 1
                CALL "add_i32" USING BY VALUE ang-180 BY VALUE tantoangle(slot)
                    RETURNING ang-out
            ELSE
                CALL "slope_div_i" USING BY VALUE dx BY VALUE dy RETURNING idx
                COMPUTE slot = idx + 1
                CALL "sub_i32" USING BY VALUE ang-270 BY VALUE 1 RETURNING tmp
                CALL "sub_i32" USING BY VALUE tmp BY VALUE tantoangle(slot)
                    RETURNING ang-out
            END-IF
        END-IF
    END-IF
    .

point-to-dist.
    CALL "sub_i32" USING BY VALUE px BY VALUE view-x RETURNING dx
    CALL "sub_i32" USING BY VALUE py BY VALUE view-y RETURNING dy
    CALL "abs_fixed_i" USING BY VALUE dx RETURNING dx
    CALL "abs_fixed_i" USING BY VALUE dy RETURNING dy
    IF dy > dx
        MOVE dx TO tmp
        MOVE dy TO dx
        MOVE tmp TO dy
    END-IF
    IF dx = 0
        MOVE 0 TO dist-out
        EXIT PARAGRAPH
    END-IF
    CALL "fixed_div" USING BY VALUE dy BY VALUE dx RETURNING frac
    CALL "ushr_i" USING BY VALUE frac BY VALUE 5 RETURNING idx
    IF idx > 2048
        MOVE 2048 TO idx
    END-IF
    IF idx < 0
        MOVE 0 TO idx
    END-IF
    COMPUTE slot = idx + 1
    CALL "tanto_sine" USING BY VALUE tantoangle(slot) RETURNING idx
    COMPUTE slot = idx + 1
    CALL "fixed_div" USING BY VALUE dx BY VALUE finesine(slot)
        RETURNING dist-out
    .

sine-at.
    CALL "ushr_i" USING BY VALUE ang-in BY VALUE 19 RETURNING idx
    CALL "bit_and" USING BY VALUE idx BY VALUE 8191 RETURNING idx
    COMPUTE slot = idx + 1
    MOVE finesine(slot) TO sin-out
    .

cos-at.
    CALL "ushr_i" USING BY VALUE ang-in BY VALUE 19 RETURNING idx
    ADD 2048 TO idx
    CALL "bit_and" USING BY VALUE idx BY VALUE 8191 RETURNING idx
    COMPUTE slot = idx + 1
    MOVE finesine(slot) TO sin-out
    .

scale-from.
    CALL "sub_i32" USING BY VALUE vis-ang BY VALUE view-ang RETURNING ang-in
    CALL "add_i32" USING BY VALUE ang-90 BY VALUE ang-in RETURNING ang-in
    PERFORM sine-at
    MOVE sin-out TO sinea
    CALL "sub_i32" USING BY VALUE vis-ang BY VALUE rw-norm RETURNING ang-in
    CALL "add_i32" USING BY VALUE ang-90 BY VALUE ang-in RETURNING ang-in
    PERFORM sine-at
    MOVE sin-out TO sineb
    CALL "fixed_mul" USING BY VALUE center-xf BY VALUE sineb RETURNING num-v
    CALL "fixed_mul" USING BY VALUE rw-dist BY VALUE sinea RETURNING den-v
    CALL "shar32" USING BY VALUE num-v BY VALUE 16 RETURNING tmp
    IF den-v NOT = 0 AND den-v > tmp
        CALL "fixed_div" USING BY VALUE num-v BY VALUE den-v
            RETURNING scale-out
        IF scale-out > 4194304
            MOVE 4194304 TO scale-out
        END-IF
        IF scale-out < 256
            MOVE 256 TO scale-out
        END-IF
    ELSE
        MOVE 4194304 TO scale-out
    END-IF
    .

tex-height.
    IF tex-id < 0 OR tex-id >= n-tex
        MOVE 0 TO th-out
    ELSE
        COMPUTE slot = tex-id + 1
        CALL "fixed_from_i16" USING BY VALUE tex-h(slot) RETURNING th-out
    END-IF
    .

push-drawseg.
    IF n-ds >= 128
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO n-ds
    MOVE rng-a TO ds-x1(n-ds)
    MOVE rng-b TO ds-x2(n-ds)
    MOVE scale-save TO ds-sc1(n-ds)
    COMPUTE sh = rng-b - rng-a
    IF sh < 0
        MOVE 0 TO sh
    END-IF
    CALL "mul_i32" USING BY VALUE rw-step BY VALUE sh RETURNING tmp
    CALL "add_i32" USING BY VALUE scale-save BY VALUE tmp
        RETURNING ds-sc2(n-ds)
    MOVE cur-seg TO ds-seg(n-ds)
    MOVE masked-tex TO ds-mask(n-ds)
    IF masked-tex = 1
        MOVE mask-id TO ds-mtex(n-ds)
        MOVE rw-mask TO ds-mmid(n-ds)
    ELSE
        MOVE 0 TO ds-mtex(n-ds)
    END-IF
    COMPUTE sh = rng-b - rng-a + 1
    IF sh < 1
        MOVE 0 TO sh
    END-IF
    MOVE sh TO ds-nclip(n-ds)
    COMPUTE ds-c0(n-ds) = ds-pool + 1
    IF has-back = 0
        MOVE 3 TO ds-sil(n-ds)
        MOVE 2147483647 TO ds-bsil(n-ds)
        MOVE -2147483647 TO ds-tsil(n-ds)
        PERFORM VARYING k FROM 0 BY 1 UNTIL k >= sh
            COMPUTE slot = ds-pool + 1 + k
            IF slot >= 1 AND slot <= 8192
                MOVE view-h TO ds-top(slot)
                MOVE -1 TO ds-bot(slot)
            END-IF
        END-PERFORM
    ELSE
        MOVE 0 TO sil-n
        MOVE 0 TO ds-bsil(n-ds)
        MOVE 0 TO ds-tsil(n-ds)
        IF sec-floor-h(front-sec) > sec-floor-h(back-sec)
            MOVE 2 TO sil-n
            MOVE sec-floor-h(front-sec) TO ds-bsil(n-ds)
        ELSE
            IF sec-floor-h(back-sec) > view-z
                MOVE 2 TO sil-n
                MOVE 2147483647 TO ds-bsil(n-ds)
            END-IF
        END-IF
        IF sec-ceil-h(front-sec) < sec-ceil-h(back-sec)
            CALL "bit_or" USING BY VALUE sil-n BY VALUE 1 RETURNING sil-n
            MOVE sec-ceil-h(front-sec) TO ds-tsil(n-ds)
        ELSE
            IF sec-ceil-h(back-sec) < view-z
                CALL "bit_or" USING BY VALUE sil-n BY VALUE 1 RETURNING sil-n
                MOVE -2147483647 TO ds-tsil(n-ds)
            END-IF
        END-IF
        IF sec-ceil-h(back-sec) <= sec-floor-h(front-sec)
            CALL "bit_or" USING BY VALUE sil-n BY VALUE 2 RETURNING sil-n
            MOVE 2147483647 TO ds-bsil(n-ds)
        END-IF
        IF sec-floor-h(back-sec) >= sec-ceil-h(front-sec)
            CALL "bit_or" USING BY VALUE sil-n BY VALUE 1 RETURNING sil-n
            MOVE -2147483647 TO ds-tsil(n-ds)
        END-IF
        IF masked-tex = 1
            CALL "bit_and" USING BY VALUE sil-n BY VALUE 1 RETURNING bit-n
            IF bit-n = 0
                CALL "bit_or" USING BY VALUE sil-n BY VALUE 1 RETURNING sil-n
                MOVE -2147483647 TO ds-tsil(n-ds)
            END-IF
            CALL "bit_and" USING BY VALUE sil-n BY VALUE 2 RETURNING bit-n
            IF bit-n = 0
                CALL "bit_or" USING BY VALUE sil-n BY VALUE 2 RETURNING sil-n
                MOVE 2147483647 TO ds-bsil(n-ds)
            END-IF
        END-IF
        MOVE sil-n TO ds-sil(n-ds)
        PERFORM VARYING k FROM 0 BY 1 UNTIL k >= sh
            COMPUTE slot = ds-pool + 1 + k
            COMPUTE peek = rng-a + k + 1
            IF slot >= 1 AND slot <= 8192
                AND peek >= 1 AND peek <= 320
                MOVE ceil-clip(peek) TO ds-top(slot)
                MOVE floor-clip(peek) TO ds-bot(slot)
                MOVE mhold-col(peek) TO ds-mcol(slot)
                MOVE mhold-lit(peek) TO ds-mlit(slot)
            END-IF
        END-PERFORM
    END-IF
    ADD sh TO ds-pool
    .

draw-masks.
    PERFORM VARYING di FROM n-ds BY -1 UNTIL di < 1
        IF ds-mask(di) = 1 AND ds-mtex(di) NOT = 0
            MOVE ds-x1(di) TO r1
            MOVE ds-x2(di) TO r2
            PERFORM paint-mask
        END-IF
    END-PERFORM
    .

masks-behind.
    MOVE vis-x1(vis-k) TO left-v
    MOVE vis-x2(vis-k) TO right-v
    MOVE vis-sc(vis-k) TO hi-sc
    PERFORM VARYING di FROM n-ds BY -1 UNTIL di < 1
        IF ds-mask(di) = 1 AND ds-mtex(di) NOT = 0
            PERFORM mask-if-behind
        END-IF
    END-PERFORM
    .

mask-if-behind.
    IF ds-x2(di) < left-v OR ds-x1(di) > right-v
        EXIT PARAGRAPH
    END-IF
    MOVE left-v TO r1
    IF ds-x1(di) > r1
        MOVE ds-x1(di) TO r1
    END-IF
    MOVE right-v TO r2
    IF ds-x2(di) < r2
        MOVE ds-x2(di) TO r2
    END-IF
    MOVE r1 TO x-i
    PERFORM seg-scale
    MOVE cur-sc TO lo-sc
    MOVE r2 TO x-i
    PERFORM seg-scale
    IF cur-sc > lo-sc
        MOVE cur-sc TO lo-sc
    END-IF
    IF lo-sc < hi-sc
        PERFORM paint-mask
    END-IF
    .

paint-mask.
    MOVE ds-mtex(di) TO tex-id
    MOVE ds-mmid(di) TO dc-mid
    MOVE r1 TO x-i
    PERFORM UNTIL x-i > r2
        COMPUTE slot = ds-c0(di) + x-i - ds-x1(di)
        IF slot >= 1 AND slot <= 8192
            AND x-i >= 0 AND x-i < view-w
            AND ds-mlit(slot) >= 0
            MOVE ds-mcol(slot) TO col-n
            MOVE ds-mlit(slot) TO dc-map
            MOVE x-i TO dc-x
            PERFORM seg-scale
            IF cur-sc > 0
                CALL "udiv_u32" USING BY VALUE -1 BY VALUE cur-sc
                    RETURNING dc-step
                CALL "fixed_mul" USING BY VALUE dc-mid BY VALUE cur-sc
                    RETURNING tmp
                CALL "sub_i32" USING BY VALUE center-yf BY VALUE tmp
                    RETURNING cur-gzt
                PERFORM fetch-column
                PERFORM mask-runs
                MOVE -1 TO ds-mlit(slot)
            END-IF
        END-IF
        ADD 1 TO x-i
    END-PERFORM
    .

seg-scale.
    IF ds-x2(di) <= ds-x1(di)
        MOVE ds-sc1(di) TO cur-sc
    ELSE
        CALL "sub_i32" USING BY VALUE ds-sc2(di)
            BY VALUE ds-sc1(di) RETURNING tmp
        COMPUTE sh = x-i - ds-x1(di)
        CALL "mul_i32" USING BY VALUE tmp BY VALUE sh RETURNING tmp
        COMPUTE sh = ds-x2(di) - ds-x1(di)
        CALL "floor_div_i" USING BY VALUE tmp BY VALUE sh RETURNING tmp
        CALL "add_i32" USING BY VALUE ds-sc1(di) BY VALUE tmp
            RETURNING cur-sc
    END-IF
    .

mask-runs.
    MOVE 0 TO top-d
    PERFORM UNTIL top-d >= 128
        CALL "byte_at" USING BY REFERENCE dc-src BY VALUE top-d
            RETURNING pix
        IF pix = 0
            ADD 1 TO top-d
        ELSE
            MOVE top-d TO src-at
            MOVE 0 TO post-len
            PERFORM UNTIL top-d >= 128
                CALL "byte_at" USING BY REFERENCE dc-src BY VALUE top-d
                    RETURNING pix
                IF pix = 0
                    EXIT PERFORM
                END-IF
                ADD 1 TO post-len
                ADD 1 TO top-d
            END-PERFORM
            PERFORM mask-run
        END-IF
    END-PERFORM
    .

mask-run.
    CALL "mul_i32" USING BY VALUE cur-sc BY VALUE src-at RETURNING tmp
    CALL "add_i32" USING BY VALUE cur-gzt BY VALUE tmp RETURNING num-v
    CALL "add_i32" USING BY VALUE num-v BY VALUE 65535 RETURNING tmp
    CALL "shar32" USING BY VALUE tmp BY VALUE 16 RETURNING yl
    CALL "mul_i32" USING BY VALUE cur-sc BY VALUE post-len RETURNING tmp
    CALL "add_i32" USING BY VALUE num-v BY VALUE tmp RETURNING tmp
    CALL "sub_i32" USING BY VALUE tmp BY VALUE 1 RETURNING tmp
    CALL "shar32" USING BY VALUE tmp BY VALUE 16 RETURNING yh
    COMPUTE clip-top = ds-top(slot) + 1
    COMPUTE clip-bot = ds-bot(slot) - 1
    IF yl < clip-top
        MOVE clip-top TO yl
    END-IF
    IF yh > clip-bot
        MOVE clip-bot TO yh
    END-IF
    IF yl < 0
        MOVE 0 TO yl
    END-IF
    COMPUTE tmp = view-h - 1
    IF yh > tmp
        MOVE tmp TO yh
    END-IF
    MOVE yl TO dc-yl
    MOVE yh TO dc-yh
    PERFORM draw-hole
    .

draw-things.
    CALL "spr-init"
    CALL "spr-spawn"
    MOVE 0 TO n-vis
    PERFORM VARYING mo-i FROM 1 BY 1 UNTIL mo-i > n-mobj
        PERFORM project-thing
    END-PERFORM
    PERFORM sort-vis
    PERFORM VARYING mo-i FROM 1 BY 1 UNTIL mo-i > n-vis
        MOVE vis-ord(mo-i) TO vis-k
        PERFORM masks-behind
        PERFORM paint-sprite
    END-PERFORM
    PERFORM draw-masks
    .

weapon-origin.
    IF ply-bob = 0 OR gun-mode NOT = 0
        MOVE 65536 TO gun-sx
        CALL "fixed_from_i16" USING BY VALUE 32 RETURNING sy-v
        CALL "add_i32" USING BY VALUE sy-v BY VALUE gun-lift
            RETURNING sy-v
        EXIT PARAGRAPH
    END-IF
    COMPUTE tmp = ply-tic * 128
    CALL "bit_and" USING BY VALUE tmp BY VALUE 8191 RETURNING idx
    COMPUTE slot = idx + 2048
    CALL "bit_and" USING BY VALUE slot BY VALUE 8191 RETURNING slot
    ADD 1 TO slot
    CALL "fixed_mul" USING BY VALUE ply-bob BY VALUE finesine(slot)
        RETURNING tmp
    CALL "add_i32" USING BY VALUE 65536 BY VALUE tmp RETURNING gun-sx
    CALL "bit_and" USING BY VALUE idx BY VALUE 4095 RETURNING idx
    COMPUTE slot = idx + 1
    CALL "fixed_mul" USING BY VALUE ply-bob BY VALUE finesine(slot)
        RETURNING tmp
    CALL "fixed_from_i16" USING BY VALUE 32 RETURNING sy-v
    CALL "add_i32" USING BY VALUE sy-v BY VALUE tmp RETURNING sy-v
    CALL "add_i32" USING BY VALUE sy-v BY VALUE gun-lift RETURNING sy-v
    .

draw-weapon.
    IF ply-hp <= 0
        EXIT PARAGRAPH
    END-IF
    PERFORM weapon-origin
    IF gun-body = SPACES OR gun-body = LOW-VALUES
        MOVE "PISGA0" TO gun-body
    END-IF
    MOVE gun-body TO gun-name
    PERFORM paint-gun
    IF gun-flash NOT = SPACES AND gun-flash NOT = LOW-VALUES
        MOVE gun-flash TO gun-name
        PERFORM paint-gun
    END-IF
    .

paint-gun.
    MOVE 1 TO gun-clip
    CALL "wad-find" USING gun-name cur-lump
    IF cur-lump < 0
        MOVE 0 TO gun-clip
        EXIT PARAGRAPH
    END-IF
    MOVE 65536 TO cap-n
    CALL "wad-read-num" USING cur-lump patch-buf cap-n patch-len
    IF patch-len < 8
        MOVE 0 TO gun-clip
        EXIT PARAGRAPH
    END-IF
    CALL "i16_le" USING BY REFERENCE patch-buf BY VALUE 0 RETURNING spr-w
    CALL "i16_le" USING BY REFERENCE patch-buf BY VALUE 4 RETURNING spr-left
    CALL "i16_le" USING BY REFERENCE patch-buf BY VALUE 6 RETURNING spr-top
    IF spr-w < 1
        MOVE 0 TO gun-clip
        EXIT PARAGRAPH
    END-IF
    MOVE gun-sx TO tx-v
    CALL "fixed_from_i16" USING BY VALUE 160 RETURNING tmp
    CALL "sub_i32" USING BY VALUE tx-v BY VALUE tmp RETURNING tx-v
    CALL "fixed_from_i16" USING BY VALUE spr-left RETURNING adj-v
    CALL "sub_i32" USING BY VALUE tx-v BY VALUE adj-v RETURNING tx-v
    COMPUTE cur-sc = view-w * 65536 / 320
    IF cur-sc < 1
        MOVE 1 TO cur-sc
    END-IF
    COMPUTE cur-xis = 320 * 65536 / view-w
    CALL "fixed_mul" USING BY VALUE tx-v BY VALUE cur-sc RETURNING tmp
    CALL "add_shr16" USING BY VALUE center-xf BY VALUE tmp RETURNING x1
    IF x1 > view-w
        MOVE 0 TO gun-clip
        EXIT PARAGRAPH
    END-IF
    MOVE x1 TO cur-x0
    CALL "fixed_from_i16" USING BY VALUE spr-w RETURNING adj-v
    CALL "add_i32" USING BY VALUE tx-v BY VALUE adj-v RETURNING tx-v
    CALL "fixed_mul" USING BY VALUE tx-v BY VALUE cur-sc RETURNING tmp
    CALL "add_shr16" USING BY VALUE center-xf BY VALUE tmp RETURNING x2
    CALL "sub_i32" USING BY VALUE x2 BY VALUE 1 RETURNING x2
    IF x2 < 0
        MOVE 0 TO gun-clip
        EXIT PARAGRAPH
    END-IF
    IF x1 < 0
        MOVE 0 TO cur-x1
    ELSE
        MOVE x1 TO cur-x1
    END-IF
    COMPUTE tmp = view-w - 1
    IF x2 > tmp
        MOVE tmp TO cur-x2
    ELSE
        MOVE x2 TO cur-x2
    END-IF
    IF cur-x1 > cur-x2
        MOVE 0 TO gun-clip
        EXIT PARAGRAPH
    END-IF
    MOVE 0 TO cur-sfrac
    MOVE spr-w TO cur-w
    CALL "fixed_from_i16" USING BY VALUE spr-top RETURNING tmp
    CALL "sub_i32" USING BY VALUE sy-v BY VALUE tmp RETURNING tmp
    MOVE 6586368 TO adj-v
    CALL "sub_i32" USING BY VALUE adj-v BY VALUE tmp RETURNING cur-mid
    PERFORM VARYING x-i FROM cur-x1 BY 1 UNTIL x-i > cur-x2
        COMPUTE peek = x-i + 1
        MOVE -1 TO ctop(peek)
        IF view-w < 320
            MOVE view-h TO cbot(peek)
        ELSE
            COMPUTE cbot(peek) = 200 - view-oy
        END-IF
    END-PERFORM
    PERFORM paint-span
    MOVE 0 TO gun-clip
    .

project-thing.
    CALL "bit_and" USING BY VALUE mo-flags(mo-i) BY VALUE 8
        RETURNING bit-n
    IF bit-n NOT = 0
        EXIT PARAGRAPH
    END-IF
    IF mo-name(mo-i) = SPACES
        EXIT PARAGRAPH
    END-IF
    IF n-vis >= 128
        EXIT PARAGRAPH
    END-IF
    CALL "sub_i32" USING BY VALUE mo-x(mo-i) BY VALUE view-x
        RETURNING trx
    CALL "sub_i32" USING BY VALUE mo-y(mo-i) BY VALUE view-y
        RETURNING try-y
    CALL "fixed_mul" USING BY VALUE trx BY VALUE view-cos RETURNING gxt-v
    CALL "fixed_mul" USING BY VALUE try-y BY VALUE view-sin RETURNING gyt-v
    CALL "sub_i32" USING BY VALUE 0 BY VALUE gyt-v RETURNING gyt-v
    CALL "sub_i32" USING BY VALUE gxt-v BY VALUE gyt-v RETURNING tz-v
    IF tz-v < 262144
        EXIT PARAGRAPH
    END-IF
    CALL "fixed_div" USING BY VALUE center-xf BY VALUE tz-v RETURNING xsc-v
    CALL "fixed_mul" USING BY VALUE trx BY VALUE view-sin RETURNING gxt-v
    CALL "sub_i32" USING BY VALUE 0 BY VALUE gxt-v RETURNING gxt-v
    CALL "fixed_mul" USING BY VALUE try-y BY VALUE view-cos RETURNING gyt-v
    CALL "spr_reject_side" USING BY VALUE gyt-v BY VALUE gxt-v BY VALUE tz-v
        RETURNING bit-n
    IF bit-n NOT = 0
        EXIT PARAGRAPH
    END-IF
    MOVE mo-x(mo-i) TO px
    MOVE mo-y(mo-i) TO py
    PERFORM point-to-angle
    CALL "spr-lookup" USING mo-name(mo-i) mo-frame(mo-i) ang-out
        mo-ang(mo-i) cur-lump flip-n spr-rc
    IF spr-rc NOT = 0
        EXIT PARAGRAPH
    END-IF
    MOVE 65536 TO cap-n
    CALL "wad-read-num" USING cur-lump patch-buf cap-n patch-len
    IF patch-len < 8
        EXIT PARAGRAPH
    END-IF
    CALL "i16_le" USING BY REFERENCE patch-buf BY VALUE 0 RETURNING spr-w
    CALL "i16_le" USING BY REFERENCE patch-buf BY VALUE 4 RETURNING spr-left
    CALL "i16_le" USING BY REFERENCE patch-buf BY VALUE 6 RETURNING spr-top
    IF spr-w < 1
        EXIT PARAGRAPH
    END-IF
    CALL "fixed_from_i16" USING BY VALUE spr-left RETURNING adj-v
    CALL "sub_i32" USING BY VALUE 0 BY VALUE adj-v RETURNING adj-v
    CALL "spr_tx" USING BY VALUE gyt-v BY VALUE gxt-v BY VALUE adj-v
        RETURNING tx-v
    CALL "fixed_mul" USING BY VALUE tx-v BY VALUE xsc-v RETURNING tmp
    CALL "add_shr16" USING BY VALUE center-xf BY VALUE tmp RETURNING x1
    IF x1 > view-w
        EXIT PARAGRAPH
    END-IF
    MOVE x1 TO cur-x0
    COMPUTE tmp = spr-w - spr-left
    CALL "fixed_from_i16" USING BY VALUE tmp RETURNING adj-v
    CALL "spr_tx" USING BY VALUE gyt-v BY VALUE gxt-v BY VALUE adj-v
        RETURNING tx-v
    CALL "fixed_mul" USING BY VALUE tx-v BY VALUE xsc-v RETURNING tmp
    CALL "add_shr16" USING BY VALUE center-xf BY VALUE tmp RETURNING x2
    CALL "sub_i32" USING BY VALUE x2 BY VALUE 1 RETURNING x2
    IF x2 < 0
        EXIT PARAGRAPH
    END-IF
    IF x1 < 0
        MOVE 0 TO cur-x1
    ELSE
        MOVE x1 TO cur-x1
    END-IF
    COMPUTE tmp = view-w - 1
    IF x2 > tmp
        MOVE tmp TO cur-x2
    ELSE
        MOVE x2 TO cur-x2
    END-IF
    IF cur-x1 > cur-x2
        EXIT PARAGRAPH
    END-IF
    IF xsc-v = 0
        MOVE 65536 TO tmp
    ELSE
        CALL "fixed_div" USING BY VALUE 65536 BY VALUE xsc-v RETURNING tmp
    END-IF
    IF flip-n = 0
        MOVE tmp TO cur-xis
        MOVE 0 TO cur-sfrac
    ELSE
        CALL "sub_i32" USING BY VALUE 0 BY VALUE tmp RETURNING cur-xis
        CALL "shl_i" USING BY VALUE spr-w BY VALUE 16 RETURNING cur-sfrac
        CALL "sub_i32" USING BY VALUE cur-sfrac BY VALUE 1 RETURNING cur-sfrac
    END-IF
    CALL "fixed_from_i16" USING BY VALUE spr-top RETURNING tmp
    CALL "add_i32" USING BY VALUE mo-z(mo-i) BY VALUE tmp RETURNING cur-gzt
    CALL "sub_i32" USING BY VALUE cur-gzt BY VALUE view-z RETURNING cur-mid
    ADD 1 TO n-vis
    MOVE xsc-v TO vis-sc(n-vis)
    MOVE mo-x(mo-i) TO vis-gx(n-vis)
    MOVE mo-y(mo-i) TO vis-gy(n-vis)
    MOVE mo-z(mo-i) TO vis-gz(n-vis)
    MOVE cur-gzt TO vis-gzt(n-vis)
    MOVE cur-mid TO vis-mid(n-vis)
    MOVE cur-x0 TO vis-x0(n-vis)
    MOVE cur-x1 TO vis-x1(n-vis)
    MOVE cur-x2 TO vis-x2(n-vis)
    MOVE cur-xis TO vis-xis(n-vis)
    MOVE cur-sfrac TO vis-sfrac(n-vis)
    MOVE spr-w TO vis-w(n-vis)
    MOVE cur-lump TO vis-lump(n-vis)
    MOVE 0 TO vis-fuzz(n-vis)
    CALL "bit_and" USING BY VALUE mo-flags(mo-i) BY VALUE 262144
        RETURNING bit-n
    IF bit-n NOT = 0
        MOVE 1 TO vis-fuzz(n-vis)
    END-IF
    .

sort-vis.
    PERFORM VARYING k FROM 1 BY 1 UNTIL k > n-vis
        MOVE k TO vis-ord(k)
    END-PERFORM
    PERFORM VARYING k FROM 2 BY 1 UNTIL k > n-vis
        MOVE vis-ord(k) TO hold-i
        MOVE k TO j
        PERFORM UNTIL j <= 1
            COMPUTE slot = j - 1
            MOVE vis-ord(slot) TO prev-i
            IF vis-sc(prev-i) <= vis-sc(hold-i)
                EXIT PERFORM
            END-IF
            MOVE prev-i TO vis-ord(j)
            SUBTRACT 1 FROM j
        END-PERFORM
        MOVE hold-i TO vis-ord(j)
    END-PERFORM
    .

paint-sprite.
    MOVE vis-x0(vis-k) TO cur-x0
    MOVE vis-x1(vis-k) TO cur-x1
    MOVE vis-x2(vis-k) TO cur-x2
    MOVE vis-sc(vis-k) TO cur-sc
    MOVE vis-gx(vis-k) TO cur-gx
    MOVE vis-gy(vis-k) TO cur-gy
    MOVE vis-gz(vis-k) TO cur-gz
    MOVE vis-gzt(vis-k) TO cur-gzt
    MOVE vis-mid(vis-k) TO cur-mid
    MOVE vis-xis(vis-k) TO cur-xis
    MOVE vis-sfrac(vis-k) TO cur-sfrac
    MOVE vis-w(vis-k) TO cur-w
    MOVE vis-lump(vis-k) TO cur-lump
    MOVE vis-fuzz(vis-k) TO fuzz-on
    MOVE 65536 TO cap-n
    CALL "wad-read-num" USING cur-lump patch-buf cap-n patch-len
    IF patch-len < 8
        EXIT PARAGRAPH
    END-IF
    PERFORM VARYING x-i FROM cur-x1 BY 1 UNTIL x-i > cur-x2
        COMPUTE peek = x-i + 1
        MOVE -2 TO ctop(peek)
        MOVE -2 TO cbot(peek)
    END-PERFORM
    PERFORM clip-sprite
    PERFORM paint-span
    .

paint-span.
    CALL "abs_fixed_i" USING BY VALUE cur-xis RETURNING y-is
    IF y-is < 1
        MOVE 1 TO y-is
    END-IF
    PERFORM VARYING x-i FROM cur-x1 BY 1 UNTIL x-i > cur-x2
        PERFORM paint-column
    END-PERFORM
    .

clip-sprite.
    PERFORM VARYING di FROM n-ds BY -1 UNTIL di < 1
        IF ds-x1(di) <= cur-x2 AND ds-x2(di) >= cur-x1
            IF ds-sil(di) NOT = 0 OR ds-mask(di) NOT = 0
                PERFORM clip-one-seg
            END-IF
        END-IF
    END-PERFORM
    PERFORM VARYING x-i FROM cur-x1 BY 1 UNTIL x-i > cur-x2
        COMPUTE peek = x-i + 1
        IF cbot(peek) = -2
            MOVE view-h TO cbot(peek)
        END-IF
        IF ctop(peek) = -2
            MOVE -1 TO ctop(peek)
        END-IF
    END-PERFORM
    .

clip-one-seg.
    IF ds-x1(di) > cur-x1
        MOVE ds-x1(di) TO r1
    ELSE
        MOVE cur-x1 TO r1
    END-IF
    IF ds-x2(di) < cur-x2
        MOVE ds-x2(di) TO r2
    ELSE
        MOVE cur-x2 TO r2
    END-IF
    IF ds-sc1(di) > ds-sc2(di)
        MOVE ds-sc1(di) TO hi-sc
        MOVE ds-sc2(di) TO lo-sc
    ELSE
        MOVE ds-sc2(di) TO hi-sc
        MOVE ds-sc1(di) TO lo-sc
    END-IF
    MOVE 0 TO bit-n
    IF hi-sc < cur-sc
        MOVE 1 TO bit-n
    ELSE
        IF lo-sc < cur-sc
            PERFORM on-seg-side
            IF side-bit = 0
                MOVE 1 TO bit-n
            END-IF
        END-IF
    END-IF
    IF bit-n = 1
        EXIT PARAGRAPH
    END-IF
    MOVE ds-sil(di) TO sil-n
    IF cur-gz >= ds-bsil(di)
        CALL "bit_and" USING BY VALUE sil-n BY VALUE -3 RETURNING sil-n
    END-IF
    IF cur-gzt <= ds-tsil(di)
        CALL "bit_and" USING BY VALUE sil-n BY VALUE -2 RETURNING sil-n
    END-IF
    PERFORM VARYING x-i FROM r1 BY 1 UNTIL x-i > r2
        COMPUTE clip-i = x-i - ds-x1(di)
        IF clip-i >= 0 AND clip-i < ds-nclip(di)
            COMPUTE slot = ds-c0(di) + clip-i
            COMPUTE peek = x-i + 1
            IF slot >= 1 AND slot <= 8192
                AND peek >= 1 AND peek <= 320
                CALL "bit_and" USING BY VALUE sil-n BY VALUE 2
                    RETURNING flag-n
                IF flag-n NOT = 0 AND cbot(peek) = -2
                    MOVE ds-bot(slot) TO cbot(peek)
                END-IF
                CALL "bit_and" USING BY VALUE sil-n BY VALUE 1
                    RETURNING flag-n
                IF flag-n NOT = 0 AND ctop(peek) = -2
                    MOVE ds-top(slot) TO ctop(peek)
                END-IF
            END-IF
        END-IF
    END-PERFORM
    .

on-seg-side.
    MOVE 1 TO side-bit
    IF ds-seg(di) < 1 OR ds-seg(di) > n-seg
        EXIT PARAGRAPH
    END-IF
    MOVE sg-v1(ds-seg(di)) TO v1-slot
    MOVE sg-v2(ds-seg(di)) TO v2-slot
    IF v1-slot < 1 OR v2-slot < 1
        EXIT PARAGRAPH
    END-IF
    CALL "delta_shr16" USING BY VALUE vtx-x(v2-slot)
        BY VALUE vtx-x(v1-slot) RETURNING ldx
    CALL "delta_shr16" USING BY VALUE vtx-y(v2-slot)
        BY VALUE vtx-y(v1-slot) RETURNING ldy
    IF ldx = 0
        IF cur-gx <= vtx-x(v1-slot)
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
        IF cur-gy <= vtx-y(v1-slot)
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
    CALL "sub_i32" USING BY VALUE cur-gx BY VALUE vtx-x(v1-slot)
        RETURNING dx
    CALL "sub_i32" USING BY VALUE cur-gy BY VALUE vtx-y(v1-slot)
        RETURNING dy
    CALL "fixed_mul" USING BY VALUE ldy BY VALUE dx RETURNING left-v
    CALL "fixed_mul" USING BY VALUE dy BY VALUE ldx RETURNING right-v
    IF right-v < left-v
        MOVE 0 TO side-bit
    ELSE
        MOVE 1 TO side-bit
    END-IF
    .

paint-column.
    COMPUTE step-n = x-i - cur-x0
    CALL "spr_col" USING BY VALUE cur-sfrac BY VALUE cur-xis
        BY VALUE step-n RETURNING col-n
    IF col-n < 0 OR col-n >= cur-w
        EXIT PARAGRAPH
    END-IF
    COMPUTE at-pos = 8 + col-n * 4
    IF at-pos < 0 OR at-pos + 3 >= patch-len
        EXIT PARAGRAPH
    END-IF
    CALL "u32_le" USING BY REFERENCE patch-buf BY VALUE at-pos
        RETURNING post-at
    PERFORM UNTIL post-at < 0 OR post-at >= patch-len
        CALL "byte_at" USING BY REFERENCE patch-buf BY VALUE post-at
            RETURNING top-d
        IF top-d = 255
            EXIT PERFORM
        END-IF
        COMPUTE src-at = post-at + 1
        IF src-at >= patch-len
            EXIT PERFORM
        END-IF
        CALL "byte_at" USING BY REFERENCE patch-buf BY VALUE src-at
            RETURNING post-len
        COMPUTE src-at = post-at + 3
        CALL "spr_yl" USING BY VALUE center-yf BY VALUE cur-mid
            BY VALUE cur-sc BY VALUE top-d RETURNING yl
        CALL "spr_yh" USING BY VALUE center-yf BY VALUE cur-mid
            BY VALUE cur-sc BY VALUE top-d BY VALUE post-len RETURNING yh
        COMPUTE peek = x-i + 1
        IF yl <= ctop(peek)
            COMPUTE yl = ctop(peek) + 1
        END-IF
        IF yh >= cbot(peek)
            COMPUTE yh = cbot(peek) - 1
        END-IF
        IF yl < 0
            MOVE 0 TO yl
        END-IF
        IF gun-clip = 1 AND view-w >= 320
            COMPUTE tmp = 199 - view-oy
        ELSE
            COMPUTE tmp = view-h - 1
        END-IF
        IF yh > tmp
            MOVE tmp TO yh
        END-IF
        IF yl <= yh
            CALL "spr_texfrac" USING BY VALUE center-yf BY VALUE cur-mid
                BY VALUE cur-sc BY VALUE top-d BY VALUE yl BY VALUE y-is
                RETURNING frac
            IF frac < 0
                MOVE 0 TO frac
            END-IF
            PERFORM VARYING y-i FROM yl BY 1 UNTIL y-i > yh
                CALL "shar32" USING BY VALUE frac BY VALUE 16 RETURNING idx
                IF idx >= 0 AND idx < post-len
                    COMPUTE at-pos = (y-i + view-oy) * 320 + x-i + view-ox
                    IF fuzz-on = 1
                        IF y-i > 0
                            COMPUTE dest-at = at-pos - 320
                            CALL "byte_at" USING BY REFERENCE fb
                                BY VALUE dest-at RETURNING byte-n
                            CALL "poke_byte" USING BY REFERENCE fb
                                BY VALUE at-pos BY VALUE byte-n
                        END-IF
                    ELSE
                        COMPUTE dest-at = src-at + idx
                        IF dest-at >= 0 AND dest-at < patch-len
                            CALL "byte_at" USING BY REFERENCE patch-buf
                                BY VALUE dest-at RETURNING pix
                            CALL "byte_at" USING BY REFERENCE cmap-buf
                                BY VALUE pix RETURNING byte-n
                            CALL "poke_byte" USING BY REFERENCE fb
                                BY VALUE at-pos BY VALUE byte-n
                        END-IF
                    END-IF
                END-IF
                CALL "add_i32" USING BY VALUE frac BY VALUE y-is
                    RETURNING frac
            END-PERFORM
        END-IF
        COMPUTE post-at = post-at + post-len + 4
    END-PERFORM
    .

END PROGRAM view-frame.
