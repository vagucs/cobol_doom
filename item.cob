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
*> Itens do chao. Vida, armadura, municao, chaves, armas e poderes.
IDENTIFICATION DIVISION.
PROGRAM-ID. item-tic.

DATA DIVISION.
WORKING-STORAGE SECTION.
COPY "sprstate.cpy".
COPY "playstate.cpy".
01 mo-i BINARY-LONG.
01 bit-n BINARY-LONG.
01 dist-n BINARY-LONG.
01 dx BINARY-LONG.
01 dy BINARY-LONG.
01 item-n PIC X(4).
01 snd-name PIC X(6).
01 took BINARY-LONG.
01 add-n BINARY-LONG.
01 cap-hp BINARY-LONG.
01 which-n BINARY-LONG.
01 pack-n BINARY-LONG.
01 unit-n BINARY-LONG.
01 cur-n BINARY-LONG.
01 max-n BINARY-LONG.

PROCEDURE DIVISION.
    PERFORM main-item
    GOBACK.

main-item.
    IF ply-hp <= 0
        EXIT PARAGRAPH
    END-IF
    PERFORM VARYING mo-i FROM 1 BY 1 UNTIL mo-i > n-mobj
        CALL "bit_and" USING BY VALUE mo-flags(mo-i) BY VALUE 1
            RETURNING bit-n
        IF bit-n NOT = 0
            PERFORM try-one
        END-IF
    END-PERFORM
    .

try-one.
    CALL "add_i32" USING BY VALUE mo-rad(mo-i) BY VALUE ply-rad
        RETURNING dist-n
    CALL "sub_i32" USING BY VALUE mo-x(mo-i) BY VALUE ply-x
        RETURNING dx
    CALL "abs_fixed_i" USING BY VALUE dx RETURNING dx
    CALL "sub_i32" USING BY VALUE mo-y(mo-i) BY VALUE ply-y
        RETURNING dy
    CALL "abs_fixed_i" USING BY VALUE dy RETURNING dy
    IF dx >= dist-n OR dy >= dist-n
        EXIT PARAGRAPH
    END-IF
    MOVE mo-name(mo-i) TO item-n
    MOVE 0 TO took
    PERFORM apply-item
    IF took = 1
        IF item-n = "SHOT" OR item-n = "SGN2" OR item-n = "MGUN"
            OR item-n = "LAUN" OR item-n = "PLAS"
            OR item-n = "BFUG" OR item-n = "CSAW"
            MOVE "wpnup" TO snd-name
        ELSE
            IF item-n = "PINV" OR item-n = "PSTR"
                OR item-n = "PINS" OR item-n = "SUIT"
                OR item-n = "PMAP" OR item-n = "PVIS"
                MOVE "getpow" TO snd-name
            ELSE
                MOVE "itemup" TO snd-name
            END-IF
        END-IF
        CALL "sfx-play" USING snd-name
        ADD 1 TO ply-items
        MOVE SPACES TO mo-name(mo-i)
        MOVE 0 TO mo-flags(mo-i)
    END-IF
    .

apply-item.
    IF item-n = "STIM"
        MOVE 10 TO add-n
        MOVE 100 TO cap-hp
        PERFORM give-hp
    END-IF
    IF item-n = "MEDI"
        MOVE 25 TO add-n
        MOVE 100 TO cap-hp
        PERFORM give-hp
    END-IF
    IF item-n = "BON1"
        MOVE 1 TO add-n
        MOVE 200 TO cap-hp
        PERFORM give-hp
    END-IF
    IF item-n = "SOUL"
        MOVE 100 TO add-n
        MOVE 200 TO cap-hp
        PERFORM give-hp
    END-IF
    IF item-n = "MEGA"
        MOVE 200 TO ply-hp
        MOVE 200 TO ply-armor
        MOVE 2 TO ply-atype
        MOVE 1 TO took
    END-IF
    IF item-n = "ARM1"
        IF ply-armor < 100
            MOVE 100 TO ply-armor
            MOVE 1 TO ply-atype
            MOVE 1 TO took
        END-IF
    END-IF
    IF item-n = "ARM2"
        IF ply-armor < 200
            MOVE 200 TO ply-armor
            MOVE 2 TO ply-atype
            MOVE 1 TO took
        END-IF
    END-IF
    IF item-n = "BON2"
        IF ply-armor < 200
            ADD 1 TO ply-armor
            IF ply-atype = 0
                MOVE 1 TO ply-atype
            END-IF
            MOVE 1 TO took
        END-IF
    END-IF
    IF item-n = "CLIP"
        MOVE 1 TO which-n
        MOVE 1 TO pack-n
        PERFORM give-pack
    END-IF
    IF item-n = "AMMO"
        MOVE 1 TO which-n
        MOVE 5 TO pack-n
        PERFORM give-pack
    END-IF
    IF item-n = "SHEL"
        MOVE 2 TO which-n
        MOVE 1 TO pack-n
        PERFORM give-pack
    END-IF
    IF item-n = "SBOX"
        MOVE 2 TO which-n
        MOVE 5 TO pack-n
        PERFORM give-pack
    END-IF
    IF item-n = "CELL"
        MOVE 3 TO which-n
        MOVE 1 TO pack-n
        PERFORM give-pack
    END-IF
    IF item-n = "CELP"
        MOVE 3 TO which-n
        MOVE 5 TO pack-n
        PERFORM give-pack
    END-IF
    IF item-n = "ROCK"
        MOVE 4 TO which-n
        MOVE 1 TO pack-n
        PERFORM give-pack
    END-IF
    IF item-n = "BROK"
        MOVE 4 TO which-n
        MOVE 5 TO pack-n
        PERFORM give-pack
    END-IF
    IF item-n = "BPAK"
        PERFORM take-pack
    END-IF
    IF item-n = "BKEY"
        MOVE 1 TO ply-k0
        MOVE 1 TO took
    END-IF
    IF item-n = "YKEY"
        MOVE 1 TO ply-k1
        MOVE 1 TO took
    END-IF
    IF item-n = "RKEY"
        MOVE 1 TO ply-k2
        MOVE 1 TO took
    END-IF
    IF item-n = "BSKU"
        MOVE 1 TO ply-k3
        MOVE 1 TO took
    END-IF
    IF item-n = "YSKU"
        MOVE 1 TO ply-k4
        MOVE 1 TO took
    END-IF
    IF item-n = "RSKU"
        MOVE 1 TO ply-k5
        MOVE 1 TO took
    END-IF
    IF item-n = "SHOT" OR item-n = "SGN2"
        MOVE 1 TO ply-sg
        MOVE 2 TO which-n
        MOVE 1 TO pack-n
        PERFORM give-pack
        MOVE 1 TO took
        IF ply-weap NOT = 3
            MOVE 3 TO ply-pend
        END-IF
    END-IF
    IF item-n = "MGUN"
        MOVE 1 TO ply-cg
        MOVE 1 TO which-n
        MOVE 1 TO pack-n
        PERFORM give-pack
        MOVE 1 TO took
        IF ply-weap NOT = 4
            MOVE 4 TO ply-pend
        END-IF
    END-IF
    IF item-n = "LAUN"
        MOVE 1 TO ply-rl
        MOVE 4 TO which-n
        MOVE 1 TO pack-n
        PERFORM give-pack
        MOVE 1 TO took
        IF ply-weap NOT = 5
            MOVE 5 TO ply-pend
        END-IF
    END-IF
    IF item-n = "PLAS"
        MOVE 1 TO ply-pg
        MOVE 3 TO which-n
        MOVE 1 TO pack-n
        PERFORM give-pack
        MOVE 1 TO took
        IF ply-weap NOT = 6
            MOVE 6 TO ply-pend
        END-IF
    END-IF
    IF item-n = "BFUG"
        MOVE 1 TO ply-bf
        MOVE 3 TO which-n
        MOVE 1 TO pack-n
        PERFORM give-pack
        MOVE 1 TO took
        IF ply-weap NOT = 7
            MOVE 7 TO ply-pend
        END-IF
    END-IF
    IF item-n = "CSAW"
        MOVE 1 TO ply-saw
        MOVE 1 TO took
        IF ply-weap NOT = 8
            MOVE 8 TO ply-pend
        END-IF
    END-IF
    IF item-n = "PINV"
        MOVE 1050 TO ply-inv
        MOVE "INVULNERABILITY!" TO ply-msg
        MOVE 140 TO ply-msgn
        MOVE 1 TO took
    END-IF
    IF item-n = "PSTR"
        IF ply-hp < 100
            MOVE 100 TO ply-hp
        END-IF
        MOVE 1 TO ply-str
        MOVE 1 TO ply-pend
        MOVE "BERSERK!" TO ply-msg
        MOVE 140 TO ply-msgn
        MOVE 1 TO took
    END-IF
    IF item-n = "PINS"
        MOVE 2100 TO ply-invis
        MOVE "PARTIAL INVISIBILITY" TO ply-msg
        MOVE 140 TO ply-msgn
        MOVE 1 TO took
    END-IF
    IF item-n = "SUIT"
        MOVE 2100 TO ply-suit
        MOVE "RADIATION SHIELDING SUIT" TO ply-msg
        MOVE 140 TO ply-msgn
        MOVE 1 TO took
    END-IF
    IF item-n = "PVIS"
        MOVE 4200 TO ply-lite
        MOVE "LIGHT AMPLIFICATION VISOR" TO ply-msg
        MOVE 140 TO ply-msgn
        MOVE 1 TO took
    END-IF
    IF item-n = "PMAP"
        IF ply-amap = 0
            MOVE 1 TO ply-amap
            MOVE "COMPUTER AREA MAP" TO ply-msg
            MOVE 140 TO ply-msgn
            MOVE 1 TO took
        END-IF
    END-IF
    .

give-hp.
    IF ply-hp >= cap-hp
        EXIT PARAGRAPH
    END-IF
    ADD add-n TO ply-hp
    IF ply-hp > cap-hp
        MOVE cap-hp TO ply-hp
    END-IF
    MOVE 1 TO took
    .

give-pack.
    IF which-n = 1
        MOVE ply-ammo TO cur-n
        MOVE ply-maxc TO max-n
        MOVE 10 TO unit-n
    END-IF
    IF which-n = 2
        MOVE ply-shell TO cur-n
        MOVE ply-maxs TO max-n
        MOVE 4 TO unit-n
    END-IF
    IF which-n = 3
        MOVE ply-cell TO cur-n
        MOVE ply-maxe TO max-n
        MOVE 20 TO unit-n
    END-IF
    IF which-n = 4
        MOVE ply-misl TO cur-n
        MOVE ply-maxr TO max-n
        MOVE 1 TO unit-n
    END-IF
    IF cur-n >= max-n
        EXIT PARAGRAPH
    END-IF
    MULTIPLY pack-n BY unit-n GIVING add-n
    ADD add-n TO cur-n
    IF cur-n > max-n
        MOVE max-n TO cur-n
    END-IF
    IF which-n = 1
        MOVE cur-n TO ply-ammo
    END-IF
    IF which-n = 2
        MOVE cur-n TO ply-shell
    END-IF
    IF which-n = 3
        MOVE cur-n TO ply-cell
    END-IF
    IF which-n = 4
        MOVE cur-n TO ply-misl
    END-IF
    MOVE 1 TO took
    .

take-pack.
    IF ply-pack = 0
        MULTIPLY 2 BY ply-maxc
        MULTIPLY 2 BY ply-maxs
        MULTIPLY 2 BY ply-maxe
        MULTIPLY 2 BY ply-maxr
        MOVE 1 TO ply-pack
    END-IF
    MOVE 1 TO pack-n
    MOVE 1 TO which-n
    PERFORM give-pack
    MOVE 2 TO which-n
    PERFORM give-pack
    MOVE 3 TO which-n
    PERFORM give-pack
    MOVE 4 TO which-n
    PERFORM give-pack
    MOVE 1 TO took
    .

END PROGRAM item-tic.
