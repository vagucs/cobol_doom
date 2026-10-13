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
*> Entrada. Confere o ponto fixo, le o IWAD e desenha a vista 3D.
*> Setas andam. Espaco ou E abre a porta. Ctrl dispara. A saida abre o mapa seguinte. Sem rato.
IDENTIFICATION DIVISION.
PROGRAM-ID. doom.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 rc BINARY-LONG.
01 pressed BINARY-LONG.
01 got BINARY-LONG.
01 lump-n BINARY-LONG.
01 pal-n BINARY-LONG.
01 pal-cap BINARY-LONG VALUE 16384.
01 ink BINARY-LONG.
01 n-lines BINARY-LONG.
01 n-verts BINARY-LONG.
01 n-tex BINARY-LONG.
01 n-flat BINARY-LONG.
01 map-name PIC X(8).
01 prev-map PIC X(8).
01 want-map PIC X(8).
01 ep-c PIC X.
01 mp-c PIC X.
01 map-num BINARY-LONG.
01 tens-n BINARY-LONG.
01 ones-n BINARY-LONG.
01 cmd-line PIC X(1024).
01 want PIC X(260).
01 arg-at BINARY-LONG.
01 arg-len BINARY-LONG.
01 tok PIC X(260).
01 tok-n BINARY-LONG.
01 tok-c PIC X.
01 quote-n BINARY-LONG.
01 suf-at BINARY-LONG.
01 fps-on BINARY-LONG VALUE 0.
01 fps-n BINARY-LONG VALUE 0.
01 fps-show BINARY-LONG VALUE 0.
01 fps-ms BINARY-LONG VALUE 0.
01 go-mode BINARY-LONG VALUE 3.
01 fin-cmd BINARY-LONG.
01 fin-stage BINARY-LONG.
01 gate-n BINARY-LONG.
01 snd-name PIC X(6).
01 mus-loop BINARY-LONG.
01 found PIC X(260).
01 lname PIC X(8).
01 show-lumps PIC ZZZZ9.
01 show-lines PIC ZZZZ9.
01 show-verts PIC ZZZZ9.
01 show-tex PIC ZZZ9.
01 fb PIC X(64000).
01 pal PIC X(16384).
COPY "playstate.cpy".
COPY "sprstate.cpy".
01 k-up BINARY-LONG.
01 k-down BINARY-LONG.
01 k-left BINARY-LONG.
01 k-right BINARY-LONG.
01 k-shift BINARY-LONG.
01 k-alt BINARY-LONG.
01 k-comma BINARY-LONG.
01 k-dot BINARY-LONG.
01 k-use BINARY-LONG VALUE 0.
01 k-use-down BINARY-LONG VALUE 0.
01 door-busy BINARY-LONG VALUE 0.
01 door-moved BINARY-LONG VALUE 0.
01 k-fire BINARY-LONG VALUE 0.
01 gun-busy BINARY-LONG VALUE 0.
01 gun-drew BINARY-LONG VALUE 0.
01 foe-drew BINARY-LONG VALUE 0.
01 floor-hurt BINARY-LONG VALUE 0.
01 cheat-drew BINARY-LONG VALUE 0.
01 typed-n BINARY-LONG.
01 pain-pal BINARY-LONG.
01 pal-at BINARY-LONG.
01 flash-n BINARY-LONG.
01 bzc-n BINARY-LONG.
01 rad-n BINARY-LONG.
01 bit-n BINARY-LONG.
01 pal-now PIC X(768).
01 act-mode BINARY-LONG.
01 moving BINARY-LONG.
01 draw-now BINARY-LONG.
01 air-n BINARY-LONG.
01 tic-n BINARY-LONG.
01 tic-i BINARY-LONG.
01 key-n BINARY-LONG.
01 mode-n BINARY-LONG VALUE 0.
01 pick-n BINARY-LONG VALUE 0.
01 skull-n BINARY-LONG VALUE 0.
01 skull-wait BINARY-LONG VALUE 8.
01 live-n BINARY-LONG VALUE 0.
01 boot-map PIC X(8).
01 pack-n BINARY-LONG VALUE 0.
01 max-pick BINARY-LONG VALUE 0.
01 save-cmd BINARY-LONG.
01 save-rc BINARY-LONG.
01 save-map PIC X(8).
01 save-desc PIC X(24).
01 show-k BINARY-LONG VALUE 0.
01 show-i BINARY-LONG VALUE 0.
01 show-s BINARY-LONG VALUE 0.
01 show-t BINARY-LONG VALUE 0.
01 goal-k BINARY-LONG VALUE 0.
01 goal-i BINARY-LONG VALUE 0.
01 goal-s BINARY-LONG VALUE 0.
01 goal-t BINARY-LONG VALUE 0.
01 wipe-done BINARY-LONG VALUE 0.
01 wipe-cmd BINARY-LONG VALUE 0.
01 size-was BINARY-LONG VALUE 0.
01 now-ms BINARY-LONG.
01 last-ms BINARY-LONG VALUE 0.
01 wait-ms BINARY-LONG.

PROCEDURE DIVISION.
    CALL "compat_self_check" RETURNING rc
    IF rc NOT = 0
        DISPLAY "ponto fixo falhou " rc
        STOP RUN RETURNING rc
    END-IF
    CALL "fixed_mul" USING BY VALUE 65536 BY VALUE 65536 RETURNING got
    IF got NOT = 65536
        DISPLAY "fixed_mul falhou " got
        STOP RUN RETURNING 3
    END-IF
    ACCEPT cmd-line FROM COMMAND-LINE
    PERFORM read-args
    CALL "find-iwad" USING want found rc
    IF rc = 1
        DISPLAY "IWAD nao encontrado: " FUNCTION TRIM(want)
        STOP RUN RETURNING 1
    END-IF
    IF rc NOT = 0
        DISPLAY "IWAD nao encontrado. Coloque doom1.wad nesta pasta ou numa pasta acima, ou passe -iwad arquivo.wad."
        STOP RUN RETURNING 2
    END-IF
    CALL "wad-open" USING found lump-n rc
    IF rc NOT = 0
        DISPLAY "WAD invalido " rc " " FUNCTION TRIM(found)
        STOP RUN RETURNING rc
    END-IF
    MOVE "PLAYPAL" TO lname
    CALL "wad-read" USING lname pal pal-cap pal-n
    IF pal-n < 768
        DISPLAY "PLAYPAL nao encontrada " pal-n
        STOP RUN RETURNING 4
    END-IF
    CALL "rdata-init" USING n-tex n-flat rc
    IF rc NOT = 0
        DISPLAY "texturas nao carregaram " rc
        STOP RUN RETURNING rc
    END-IF
    CALL "map-load" USING map-name n-lines n-verts rc
    IF rc = 2
        DISPLAY "mapa E1M1 nao encontrado"
        STOP RUN RETURNING 5
    END-IF
    IF rc NOT = 0
        DISPLAY "mapa nao carregou " rc
        STOP RUN RETURNING rc
    END-IF
    MOVE 10 TO ply-blocks
    MOVE 2 TO ply-scale
    MOVE 2 TO ply-skill
    MOVE 0 TO ply-iddt
    MOVE 0 TO ply-mapon
    CALL "view-frame" USING fb ink
    IF ink < 1000
        DISPLAY "vista vazia " ink
        STOP RUN RETURNING 6
    END-IF
    CALL "video_init" USING BY VALUE 320 BY VALUE 200 BY VALUE 2
        RETURNING rc
    IF rc NOT = 0
        DISPLAY "SDL2 nao abriu a janela " rc
        CALL "video_shutdown"
        STOP RUN RETURNING rc
    END-IF
    CALL "audio_init" RETURNING rc
    CALL "mus-title"
    MOVE map-name TO boot-map
    MOVE "MAP01" TO want-map
    CALL "wad-find" USING want-map lump-n
    IF lump-n >= 0
        MOVE 1 TO pack-n
    ELSE
        MOVE 0 TO pack-n
    END-IF
    MOVE 0 TO mode-n
    MOVE 0 TO pick-n
    MOVE 0 TO live-n
    PERFORM draw-front
    MOVE lump-n TO show-lumps
    MOVE n-lines TO show-lines
    MOVE n-verts TO show-verts
    MOVE n-tex TO show-tex
    DISPLAY "IWAD " FUNCTION TRIM(found)
    DISPLAY FUNCTION TRIM(map-name) "  linhas " FUNCTION TRIM(show-lines)
        "  vertices " FUNCTION TRIM(show-verts)
        "  texturas " FUNCTION TRIM(show-tex)
        "  lumps " FUNCTION TRIM(show-lumps)
        "  vista"
    PERFORM UNTIL pressed = -1
        CALL "video_present"
        PERFORM note-fps
        CALL "video_poll" RETURNING pressed
        CALL "music_pump"
        IF pressed NOT = -1
            IF mode-n = 3 AND pressed = 27
                MOVE 1 TO mode-n
                MOVE 1 TO live-n
                MOVE 0 TO pick-n
                PERFORM draw-front
            ELSE
            IF mode-n = 6
                PERFORM finale-step
            ELSE
            IF mode-n = 5
                CALL "video_ms" RETURNING now-ms
                CALL "sub_i32" USING BY VALUE now-ms BY VALUE last-ms
                    RETURNING wait-ms
                IF last-ms = 0 OR wait-ms >= 28
                    MOVE now-ms TO last-ms
                    MOVE 3 TO wipe-cmd
                    CALL "ui-wipe" USING fb wipe-cmd wipe-done
                    PERFORM paint-screen
                    IF wipe-done = 1
                        MOVE go-mode TO mode-n
                    END-IF
                END-IF
            ELSE
            IF mode-n NOT = 3
                PERFORM front-keys
                PERFORM front-clock
            ELSE
            IF pressed = 9
                IF ply-mapon = 0
                    MOVE 1 TO ply-mapon
                ELSE
                    MOVE 0 TO ply-mapon
                END-IF
                PERFORM paint-view
                MOVE 0 TO pressed
            END-IF
            PERFORM size-key
            PERFORM read-keys
            MOVE pressed TO typed-n
            IF typed-n >= 65 AND typed-n <= 90
                ADD 32 TO typed-n
            END-IF
            IF typed-n >= 97 AND typed-n <= 122
                OR (typed-n >= 48 AND typed-n <= 57)
                CALL "cheat-feed" USING typed-n cheat-drew
            ELSE
                MOVE 0 TO cheat-drew
            END-IF
            IF ply-warp = 1
                PERFORM do-warp
            END-IF
            IF k-use = 0
                MOVE 0 TO k-use-down
            END-IF
            MOVE 0 TO moving
            IF k-up NOT = 0 OR k-down NOT = 0
                OR k-left NOT = 0 OR k-right NOT = 0
                OR k-comma NOT = 0 OR k-dot NOT = 0
                OR ply-momx NOT = 0 OR ply-momy NOT = 0
                MOVE 1 TO moving
            END-IF
            MOVE 0 TO air-n
            IF ply-momz NOT = 0 OR ply-dvh NOT = 0
                OR ply-z > ply-floor
                MOVE 1 TO air-n
            END-IF
            IF ply-hp <= 0
                MOVE 0 TO moving
                MOVE 0 TO k-fire
                MOVE 0 TO ply-dvh
                MOVE 0 TO ply-bob
                MOVE 0 TO ply-vbob
            END-IF
            CALL "video_ms" RETURNING now-ms
                CALL "sub_i32" USING BY VALUE now-ms BY VALUE last-ms
                    RETURNING wait-ms
                IF last-ms = 0 OR wait-ms >= 28
                    IF last-ms = 0
                        MOVE 1 TO tic-n
                    ELSE
                        DIVIDE wait-ms BY 28 GIVING tic-n
                        IF tic-n < 1
                            MOVE 1 TO tic-n
                        END-IF
                        IF tic-n > 4
                            MOVE 4 TO tic-n
                        END-IF
                    END-IF
                    MOVE now-ms TO last-ms
                    MOVE 0 TO draw-now
                    IF cheat-drew = 1
                        MOVE 1 TO draw-now
                    END-IF
                    PERFORM tic-n TIMES
                        IF ply-hp <= 0 AND ply-vh > 393216
                            SUBTRACT 65536 FROM ply-vh
                            IF ply-vh < 393216
                                MOVE 393216 TO ply-vh
                            END-IF
                            MOVE 1 TO draw-now
                        END-IF
                        IF ply-exit = 0
                            AND (moving = 1 OR air-n = 1)
                            CALL "walk-tic" USING k-up k-down k-left
                                k-right k-shift k-alt k-comma k-dot
                            MOVE 1 TO draw-now
                        END-IF
                        CALL "floor-tic" USING floor-hurt
                        IF floor-hurt = 1
                            MOVE 1 TO draw-now
                        END-IF
                        MOVE 0 TO act-mode
                        IF k-use = 1 AND k-use-down = 0
                            MOVE 1 TO act-mode
                            MOVE 1 TO k-use-down
                        END-IF
                        IF moving = 1 OR air-n = 1 OR act-mode = 1
                            OR door-busy = 1
                            CALL "door-act" USING act-mode door-busy
                                door-moved
                            IF door-moved = 1
                                MOVE 1 TO draw-now
                            END-IF
                        END-IF
                        CALL "gun-tic" USING k-fire gun-busy gun-drew
                        IF gun-drew = 1
                            MOVE 1 TO draw-now
                        END-IF
                        CALL "enemy-tic" USING foe-drew
                        IF foe-drew = 1
                            MOVE 1 TO draw-now
                        END-IF
                        PERFORM fade-powers
                        IF ply-pain > 0
                            SUBTRACT 1 FROM ply-pain
                            MOVE 1 TO draw-now
                        END-IF
                        IF ply-fwait > 0
                            SUBTRACT 1 FROM ply-fwait
                            MOVE 1 TO draw-now
                        END-IF
                        IF ply-exit > 1
                            SUBTRACT 1 FROM ply-exit
                        END-IF
                        IF ply-exit = 1
                            EXIT PERFORM
                        END-IF
                    END-PERFORM
                    IF pressed = 9
                        MOVE 1 TO draw-now
                    END-IF
                    IF draw-now = 1 AND ply-exit NOT = 1
                        PERFORM paint-view
                    END-IF
                    IF ply-exit = 1
                        PERFORM begin-tally
                    END-IF
                ELSE
                    IF cheat-drew = 1 AND ply-exit NOT = 1
                        PERFORM paint-view
                    END-IF
                END-IF
            END-IF
            END-IF
            END-IF
            END-IF
        END-IF
    END-PERFORM
    CALL "video_shutdown"
    STOP RUN.

do-warp.
    MOVE 0 TO ply-warp
    MOVE ply-dest TO map-name
    MOVE 0 TO ply-k0
    MOVE 0 TO ply-k1
    MOVE 0 TO ply-k2
    MOVE 0 TO ply-k3
    MOVE 0 TO ply-k4
    MOVE 0 TO ply-k5
    MOVE 1 TO ply-keep
    MOVE map-name TO prev-map
    PERFORM load-level
    .

fade-powers.
    IF ply-msgn > 0
        SUBTRACT 1 FROM ply-msgn
    END-IF
    IF ply-inv > 0
        SUBTRACT 1 FROM ply-inv
    END-IF
    IF ply-suit > 0
        SUBTRACT 1 FROM ply-suit
    END-IF
    IF ply-lite > 0
        SUBTRACT 1 FROM ply-lite
    END-IF
    IF ply-invis > 0
        SUBTRACT 1 FROM ply-invis
    END-IF
    IF ply-str > 0
        ADD 1 TO ply-str
    END-IF
    .

draw-front.
    CALL "ui-draw" USING fb mode-n pick-n skull-n
        show-k show-i show-s show-t
    PERFORM paint-screen
    .

finale-step.
    IF pressed > 0
        MOVE pressed TO fin-cmd
        CALL "fin-act" USING fb fin-cmd map-name fin-stage
        IF fin-stage = 9
            PERFORM end-finale
            EXIT PARAGRAPH
        END-IF
        IF fin-stage = 8
            PERFORM after-story
            EXIT PARAGRAPH
        END-IF
        PERFORM paint-screen
    END-IF
    CALL "video_ms" RETURNING now-ms
    CALL "sub_i32" USING BY VALUE now-ms BY VALUE last-ms
        RETURNING wait-ms
    IF last-ms = 0 OR wait-ms >= 28
        MOVE now-ms TO last-ms
        MOVE 2 TO fin-cmd
        CALL "fin-act" USING fb fin-cmd map-name fin-stage
        PERFORM paint-screen
    END-IF
    .

end-finale.
    MOVE 1 TO wipe-cmd
    CALL "ui-wipe" USING fb wipe-cmd wipe-done
    MOVE 0 TO mode-n
    MOVE 0 TO live-n
    MOVE 0 TO pick-n
    CALL "mus-title"
    PERFORM draw-front
    MOVE 2 TO wipe-cmd
    CALL "ui-wipe" USING fb wipe-cmd wipe-done
    MOVE 0 TO go-mode
    MOVE 5 TO mode-n
    .

after-story.
    MOVE 1 TO wipe-cmd
    CALL "ui-wipe" USING fb wipe-cmd wipe-done
    MOVE 1 TO ply-keep
    PERFORM restart-level
    MOVE 3 TO go-mode
    MOVE 2 TO wipe-cmd
    CALL "ui-wipe" USING fb wipe-cmd wipe-done
    MOVE 5 TO mode-n
    .

size-key.
    MOVE ply-blocks TO size-was
    IF pressed = 45 OR pressed = 1073741910
        IF ply-blocks > 3
            SUBTRACT 1 FROM ply-blocks
        END-IF
    END-IF
    IF pressed = 61 OR pressed = 43 OR pressed = 1073741911
        IF ply-blocks < 11
            ADD 1 TO ply-blocks
        END-IF
    END-IF
    IF ply-blocks NOT = size-was
        PERFORM paint-view
    END-IF
    .

front-keys.
    IF pressed = 0
        EXIT PARAGRAPH
    END-IF
    IF mode-n = 0
        IF pressed = 27
            MOVE -1 TO pressed
        ELSE
            MOVE 1 TO mode-n
            MOVE 0 TO pick-n
            PERFORM draw-front
        END-IF
        EXIT PARAGRAPH
    END-IF
    IF mode-n = 4
        PERFORM tally-key
        EXIT PARAGRAPH
    END-IF
    IF pressed = 1073741906
        IF pick-n > 0
            SUBTRACT 1 FROM pick-n
        END-IF
    END-IF
    IF pressed = 1073741905
        PERFORM menu-max
        IF pick-n < max-pick
            ADD 1 TO pick-n
        END-IF
    END-IF
    IF mode-n = 2 AND pressed = 1073741904
        PERFORM opt-left
    END-IF
    IF mode-n = 2 AND pressed = 1073741903
        PERFORM opt-right
    END-IF
    IF pressed = 13 OR pressed = 32
        PERFORM opt-enter
        IF mode-n = 5 OR pressed = -1
            EXIT PARAGRAPH
        END-IF
    END-IF
    IF pressed = 27
        IF mode-n = 2 OR mode-n = 7 OR mode-n = 8
            OR mode-n = 9 OR mode-n = 10
            MOVE 1 TO mode-n
            MOVE 0 TO pick-n
        ELSE
            IF live-n = 1
                MOVE 3 TO mode-n
                PERFORM paint-view
                EXIT PARAGRAPH
            ELSE
                MOVE 0 TO mode-n
                CALL "mus-title"
            END-IF
        END-IF
    END-IF
    PERFORM draw-front
    .

opt-left.
    IF pick-n = 1 AND ply-blocks > 3
        SUBTRACT 1 FROM ply-blocks
    END-IF
    IF pick-n = 2 AND ply-scale > 1
        SUBTRACT 1 FROM ply-scale
        CALL "video_set_scale" USING BY VALUE ply-scale RETURNING rc
    END-IF
    .

opt-right.
    IF pick-n = 1 AND ply-blocks < 11
        ADD 1 TO ply-blocks
    END-IF
    IF pick-n = 2 AND ply-scale < 4
        ADD 1 TO ply-scale
        CALL "video_set_scale" USING BY VALUE ply-scale RETURNING rc
    END-IF
    .

opt-enter.
    IF mode-n = 1 AND pick-n = 0
        IF pack-n = 1
            MOVE 8 TO mode-n
            MOVE 2 TO pick-n
        ELSE
            MOVE 7 TO mode-n
            MOVE 0 TO pick-n
        END-IF
        EXIT PARAGRAPH
    END-IF
    IF mode-n = 1 AND pick-n = 1
        MOVE 2 TO mode-n
        MOVE 0 TO pick-n
        EXIT PARAGRAPH
    END-IF
    IF mode-n = 1 AND pick-n = 2
        MOVE 9 TO mode-n
        MOVE 0 TO pick-n
        EXIT PARAGRAPH
    END-IF
    IF mode-n = 1 AND pick-n = 3
        IF live-n = 0
            MOVE "oof" TO snd-name
            CALL "sfx-play" USING snd-name
        ELSE
            MOVE 10 TO mode-n
            MOVE 0 TO pick-n
        END-IF
        EXIT PARAGRAPH
    END-IF
    IF mode-n = 1 AND pick-n = 4
        MOVE -1 TO pressed
        EXIT PARAGRAPH
    END-IF
    IF mode-n = 7
        PERFORM begin-episode
        EXIT PARAGRAPH
    END-IF
    IF mode-n = 8
        PERFORM begin-skill
        EXIT PARAGRAPH
    END-IF
    IF mode-n = 9
        PERFORM load-picked
        EXIT PARAGRAPH
    END-IF
    IF mode-n = 10
        PERFORM save-picked
        EXIT PARAGRAPH
    END-IF
    IF mode-n = 2 AND pick-n = 0
        MOVE 0 TO mode-n
        MOVE 0 TO live-n
        MOVE 0 TO pick-n
        CALL "mus-title"
    END-IF
    .

menu-max.
    MOVE 0 TO max-pick
    IF mode-n = 1
        MOVE 4 TO max-pick
    END-IF
    IF mode-n = 2
        MOVE 2 TO max-pick
    END-IF
    IF mode-n = 7
        MOVE 3 TO max-pick
    END-IF
    IF mode-n = 8
        MOVE 4 TO max-pick
    END-IF
    IF mode-n = 9 OR mode-n = 10
        MOVE 5 TO max-pick
    END-IF
    .

begin-episode.
    IF pick-n > 0
        MOVE "E2M1" TO want-map
        CALL "wad-find" USING want-map lump-n
        IF lump-n < 0
            MOVE "REGISTERED VERSION ONLY" TO ply-msg
            MOVE 140 TO ply-msgn
            EXIT PARAGRAPH
        END-IF
    END-IF
    MOVE "E1M1" TO map-name
    IF pick-n = 1
        MOVE "2" TO map-name(2:1)
    END-IF
    IF pick-n = 2
        MOVE "3" TO map-name(2:1)
    END-IF
    IF pick-n = 3
        MOVE "4" TO map-name(2:1)
    END-IF
    MOVE 8 TO mode-n
    MOVE 2 TO pick-n
    .

begin-skill.
    MOVE pick-n TO ply-skill
    IF pack-n = 1
        MOVE "MAP01" TO map-name
    END-IF
    PERFORM start-picked
    .

load-picked.
    MOVE 2 TO save-cmd
    CALL "slot-act" USING save-cmd pick-n save-rc save-map save-desc
    IF save-rc = 0
        MOVE save-map TO map-name
        MOVE 0 TO ply-mapon
        MOVE 0 TO ply-iddt
        CALL "view-frame" USING fb ink
        CALL "mus-level" USING map-name
        MOVE 2 TO wipe-cmd
        CALL "ui-wipe" USING fb wipe-cmd wipe-done
        MOVE 1 TO live-n
        MOVE 3 TO go-mode
        MOVE 5 TO mode-n
    ELSE
        MOVE "empty slot" TO ply-msg
        MOVE 140 TO ply-msgn
    END-IF
    .

save-picked.
    MOVE 1 TO save-cmd
    CALL "slot-act" USING save-cmd pick-n save-rc save-map save-desc
    IF save-rc = 0
        MOVE "GAME SAVED" TO ply-msg
        MOVE 140 TO ply-msgn
        MOVE 3 TO mode-n
        PERFORM paint-view
    ELSE
        MOVE "oof" TO snd-name
        CALL "sfx-play" USING snd-name
    END-IF
    .

paint-view.
    IF ply-mapon = 1
        CALL "map-draw" USING fb pal ink
        CALL "status-draw" USING fb
        PERFORM paint-screen
    ELSE
        CALL "view-frame" USING fb ink
        PERFORM paint-screen
    END-IF
    .

front-clock.
    IF mode-n = 5
        EXIT PARAGRAPH
    END-IF
    CALL "video_ms" RETURNING now-ms
    CALL "sub_i32" USING BY VALUE now-ms BY VALUE last-ms
        RETURNING wait-ms
    IF last-ms NOT = 0 AND wait-ms < 28
        EXIT PARAGRAPH
    END-IF
    MOVE now-ms TO last-ms
    IF mode-n = 1 OR mode-n = 2 OR mode-n = 7
        OR mode-n = 8 OR mode-n = 9 OR mode-n = 10
        OR (mode-n = 4 AND ply-loc = 1)
        SUBTRACT 1 FROM skull-wait
        IF skull-wait <= 0
            MOVE 8 TO skull-wait
            IF skull-n = 0
                MOVE 1 TO skull-n
            ELSE
                MOVE 0 TO skull-n
            END-IF
        END-IF
    END-IF
    IF mode-n = 4
        PERFORM bump-tally
    END-IF
    PERFORM draw-front
    .

tally-key.
    PERFORM fill-goals
    IF show-k < goal-k OR show-i < goal-i
        OR show-s < goal-s OR show-t < goal-t
        MOVE goal-k TO show-k
        MOVE goal-i TO show-i
        MOVE goal-s TO show-s
        MOVE goal-t TO show-t
        PERFORM draw-front
    ELSE
        IF ply-loc = 0
            MOVE 1 TO ply-loc
            MOVE 0 TO skull-n
            MOVE 8 TO skull-wait
            PERFORM draw-front
        ELSE
            PERFORM finish-tally
        END-IF
    END-IF
    .

bump-tally.
    PERFORM fill-goals
    IF show-k < goal-k
        ADD 2 TO show-k
        IF show-k > goal-k
            MOVE goal-k TO show-k
        END-IF
    END-IF
    IF show-i < goal-i
        ADD 2 TO show-i
        IF show-i > goal-i
            MOVE goal-i TO show-i
        END-IF
    END-IF
    IF show-s < goal-s
        ADD 2 TO show-s
        IF show-s > goal-s
            MOVE goal-s TO show-s
        END-IF
    END-IF
    IF show-t < goal-t
        ADD 1 TO show-t
    END-IF
    .

fill-goals.
    MOVE 0 TO goal-k
    MOVE 0 TO goal-i
    MOVE 0 TO goal-s
    IF map-kills > 0
        COMPUTE goal-k = ply-kills * 100 / map-kills
    END-IF
    IF map-items > 0
        COMPUTE goal-i = ply-items * 100 / map-items
    END-IF
    IF map-secs > 0
        COMPUTE goal-s = ply-secs * 100 / map-secs
    END-IF
    IF goal-k > 100
        MOVE 100 TO goal-k
    END-IF
    IF goal-i > 100
        MOVE 100 TO goal-i
    END-IF
    IF goal-s > 100
        MOVE 100 TO goal-s
    END-IF
    COMPUTE goal-t = ply-time / 35
    .

begin-tally.
    MOVE 0 TO ply-exit
    MOVE 0 TO ply-loc
    MOVE 0 TO show-k
    MOVE 0 TO show-i
    MOVE 0 TO show-s
    MOVE 0 TO show-t
    MOVE 1 TO wipe-cmd
    CALL "ui-wipe" USING fb wipe-cmd wipe-done
    MOVE 4 TO mode-n
    CALL "mus-inter"
    CALL "ui-draw" USING fb mode-n pick-n skull-n
        show-k show-i show-s show-t
    MOVE 2 TO wipe-cmd
    CALL "ui-wipe" USING fb wipe-cmd wipe-done
    MOVE 4 TO go-mode
    MOVE 5 TO mode-n
    .

story-gate.
    MOVE 0 TO gate-n
    IF map-name(1:3) NOT = "MAP"
        EXIT PARAGRAPH
    END-IF
    COMPUTE map-num = FUNCTION NUMVAL(map-name(4:2))
    IF map-num = 6 OR map-num = 11 OR map-num = 20
        OR map-num = 30
        MOVE 1 TO gate-n
    END-IF
    IF ply-secret = 1
        IF map-num = 15 OR map-num = 31
            MOVE 1 TO gate-n
        END-IF
    END-IF
    .

finish-tally.
    MOVE 1 TO wipe-cmd
    CALL "ui-wipe" USING fb wipe-cmd wipe-done
    PERFORM story-gate
    IF gate-n = 1
        OR (map-name(1:1) = "E" AND map-name(4:1) = "8"
            AND ply-secret = 0)
        MOVE 1 TO fin-cmd
        CALL "fin-act" USING fb fin-cmd map-name fin-stage
        IF gate-n = 1
            MOVE "read_m" TO snd-name
        ELSE
            MOVE "victor" TO snd-name
        END-IF
        MOVE 1 TO mus-loop
        CALL "mus-play" USING snd-name mus-loop
        MOVE 6 TO go-mode
    ELSE
        MOVE 1 TO ply-keep
        PERFORM restart-level
        MOVE 3 TO go-mode
    END-IF
    MOVE 2 TO wipe-cmd
    CALL "ui-wipe" USING fb wipe-cmd wipe-done
    MOVE 5 TO mode-n
    .

fresh-game.
    MOVE boot-map TO map-name
    PERFORM start-picked
    .

start-picked.
    MOVE 1 TO wipe-cmd
    CALL "ui-wipe" USING fb wipe-cmd wipe-done
    MOVE 0 TO ply-keep
    MOVE 0 TO ply-mapon
    MOVE 0 TO ply-iddt
    PERFORM load-level
    MOVE 2 TO wipe-cmd
    CALL "ui-wipe" USING fb wipe-cmd wipe-done
    MOVE 1 TO live-n
    MOVE 3 TO go-mode
    MOVE 5 TO mode-n
    .

restart-level.
    MOVE map-name TO prev-map
    PERFORM next-map
    MOVE 1 TO ply-keep
    PERFORM load-level
    .

load-level.
    CALL "map-load" USING map-name n-lines n-verts rc
    IF rc NOT = 0
        MOVE prev-map TO map-name
        CALL "map-load" USING map-name n-lines n-verts rc
    END-IF
    IF rc NOT = 0
        MOVE 0 TO ply-exit
        EXIT PARAGRAPH
    END-IF
    MOVE 0 TO spr-once
    MOVE 0 TO ply-on
    MOVE 0 TO ply-exit
    MOVE 0 TO ply-mapon
    MOVE 0 TO ply-iddt
    MOVE 9 TO act-mode
    CALL "door-act" USING act-mode door-busy door-moved
    CALL "view-frame" USING fb ink
    PERFORM paint-screen
    CALL "mus-level" USING map-name
    .

next-map.
    MOVE map-name TO want-map
    IF map-name(1:3) = "MAP"
        PERFORM next-pack
    ELSE
        IF map-name(1:1) = "E" AND map-name(3:1) = "M"
            PERFORM next-episode
        END-IF
    END-IF
    MOVE want-map TO lname
    CALL "wad-find" USING lname lump-n
    IF lump-n >= 0
        MOVE want-map TO map-name
    END-IF
    MOVE 0 TO ply-secret
    .

next-episode.
    MOVE map-name(2:1) TO ep-c
    MOVE map-name(4:1) TO mp-c
    IF ply-secret = 1
        MOVE "9" TO mp-c
    ELSE
        IF mp-c = "9"
            MOVE "4" TO mp-c
        ELSE
            IF mp-c = "8"
                MOVE "1" TO mp-c
            ELSE
                PERFORM bump-map
            END-IF
        END-IF
    END-IF
    MOVE SPACES TO want-map
    MOVE "E" TO want-map(1:1)
    MOVE ep-c TO want-map(2:1)
    MOVE "M" TO want-map(3:1)
    MOVE mp-c TO want-map(4:1)
    .

bump-map.
    EVALUATE mp-c
        WHEN "1" MOVE "2" TO mp-c
        WHEN "2" MOVE "3" TO mp-c
        WHEN "3" MOVE "4" TO mp-c
        WHEN "4" MOVE "5" TO mp-c
        WHEN "5" MOVE "6" TO mp-c
        WHEN "6" MOVE "7" TO mp-c
        WHEN "7" MOVE "8" TO mp-c
        WHEN OTHER MOVE "1" TO mp-c
    END-EVALUATE
    .

next-pack.
    MOVE 0 TO tens-n
    MOVE 0 TO ones-n
    EVALUATE map-name(4:1)
        WHEN "1" MOVE 1 TO tens-n
        WHEN "2" MOVE 2 TO tens-n
        WHEN "3" MOVE 3 TO tens-n
        WHEN OTHER MOVE 0 TO tens-n
    END-EVALUATE
    EVALUATE map-name(5:1)
        WHEN "1" MOVE 1 TO ones-n
        WHEN "2" MOVE 2 TO ones-n
        WHEN "3" MOVE 3 TO ones-n
        WHEN "4" MOVE 4 TO ones-n
        WHEN "5" MOVE 5 TO ones-n
        WHEN "6" MOVE 6 TO ones-n
        WHEN "7" MOVE 7 TO ones-n
        WHEN "8" MOVE 8 TO ones-n
        WHEN "9" MOVE 9 TO ones-n
        WHEN OTHER MOVE 0 TO ones-n
    END-EVALUATE
    COMPUTE map-num = tens-n * 10 + ones-n
    IF ply-secret = 1
        IF map-num = 15
            MOVE 31 TO map-num
        ELSE
            IF map-num = 31
                MOVE 32 TO map-num
            ELSE
                ADD 1 TO map-num
            END-IF
        END-IF
    ELSE
        IF map-num = 31
            MOVE 16 TO map-num
        ELSE
            ADD 1 TO map-num
            IF map-num > 32
                MOVE 1 TO map-num
            END-IF
        END-IF
    END-IF
    DIVIDE map-num BY 10 GIVING tens-n REMAINDER ones-n
    MOVE SPACES TO want-map
    MOVE "MAP" TO want-map(1:3)
    EVALUATE tens-n
        WHEN 1 MOVE "1" TO want-map(4:1)
        WHEN 2 MOVE "2" TO want-map(4:1)
        WHEN 3 MOVE "3" TO want-map(4:1)
        WHEN OTHER MOVE "0" TO want-map(4:1)
    END-EVALUATE
    EVALUATE ones-n
        WHEN 1 MOVE "1" TO want-map(5:1)
        WHEN 2 MOVE "2" TO want-map(5:1)
        WHEN 3 MOVE "3" TO want-map(5:1)
        WHEN 4 MOVE "4" TO want-map(5:1)
        WHEN 5 MOVE "5" TO want-map(5:1)
        WHEN 6 MOVE "6" TO want-map(5:1)
        WHEN 7 MOVE "7" TO want-map(5:1)
        WHEN 8 MOVE "8" TO want-map(5:1)
        WHEN 9 MOVE "9" TO want-map(5:1)
        WHEN OTHER MOVE "0" TO want-map(5:1)
    END-EVALUATE
    .

paint-screen.
    IF ply-msgn > 0
        CALL "msg-stamp" USING fb ply-msg
    END-IF
    IF fps-on = 1
        CALL "fps-stamp" USING fb fps-show
    END-IF
    MOVE ply-pain TO flash-n
    IF ply-str > 0
        DIVIDE ply-str BY 64 GIVING bzc-n
        SUBTRACT bzc-n FROM 12 GIVING bzc-n
        IF bzc-n > flash-n
            MOVE bzc-n TO flash-n
        END-IF
    END-IF
    MOVE 0 TO rad-n
    IF flash-n <= 0 AND ply-suit > 0
        IF ply-suit > 128
            MOVE 1 TO rad-n
        ELSE
            CALL "bit_and" USING BY VALUE ply-suit BY VALUE 8
                RETURNING bit-n
            IF bit-n NOT = 0
                MOVE 1 TO rad-n
            END-IF
        END-IF
    END-IF
    IF flash-n <= 0 AND rad-n = 0
        CALL "video_upload" USING fb pal
        EXIT PARAGRAPH
    END-IF
    IF rad-n = 1
        IF pal-n < 10752
            CALL "video_upload" USING fb pal
            EXIT PARAGRAPH
        END-IF
        MOVE 9985 TO pal-at
        MOVE pal(pal-at:768) TO pal-now
        CALL "video_upload" USING fb pal-now
        EXIT PARAGRAPH
    END-IF
    IF pal-n < 6912
        CALL "video_upload" USING fb pal
        EXIT PARAGRAPH
    END-IF
    ADD flash-n TO 7 GIVING pain-pal
    DIVIDE pain-pal BY 8 GIVING pain-pal
    IF pain-pal > 7
        MOVE 7 TO pain-pal
    END-IF
    ADD 1 TO pain-pal
    COMPUTE pal-at = pain-pal * 768 + 1
    MOVE pal(pal-at:768) TO pal-now
    CALL "video_upload" USING fb pal-now
    .

read-args.
    MOVE SPACES TO want
    MOVE 0 TO fps-on
    MOVE FUNCTION LENGTH(FUNCTION TRIM(cmd-line)) TO arg-len
    IF arg-len < 1
        EXIT PARAGRAPH
    END-IF
    MOVE 1 TO arg-at
    PERFORM UNTIL arg-at > arg-len
        PERFORM skip-sp
        IF arg-at > arg-len
            EXIT PERFORM
        END-IF
        PERFORM read-tok
        PERFORM take-tok
    END-PERFORM
    .

skip-sp.
    PERFORM UNTIL arg-at > arg-len
        IF cmd-line(arg-at:1) NOT = " "
            EXIT PERFORM
        END-IF
        ADD 1 TO arg-at
    END-PERFORM
    .

read-tok.
    MOVE SPACES TO tok
    MOVE 0 TO tok-n
    MOVE 0 TO quote-n
    IF arg-at <= arg-len AND cmd-line(arg-at:1) = '"'
        MOVE 1 TO quote-n
        ADD 1 TO arg-at
    END-IF
    PERFORM UNTIL arg-at > arg-len OR tok-n >= 260
        MOVE cmd-line(arg-at:1) TO tok-c
        IF quote-n = 1 AND tok-c = '"'
            ADD 1 TO arg-at
            EXIT PERFORM
        END-IF
        IF quote-n = 0 AND tok-c = " "
            EXIT PERFORM
        END-IF
        ADD 1 TO tok-n
        MOVE tok-c TO tok(tok-n:1)
        ADD 1 TO arg-at
    END-PERFORM
    .

take-tok.
    IF tok-n < 1
        EXIT PARAGRAPH
    END-IF
    IF FUNCTION UPPER-CASE(FUNCTION TRIM(tok)) = "-FPS"
        MOVE 1 TO fps-on
        EXIT PARAGRAPH
    END-IF
    IF FUNCTION UPPER-CASE(FUNCTION TRIM(tok)) = "-IWAD"
        PERFORM skip-sp
        PERFORM read-tok
        MOVE tok TO want
        EXIT PARAGRAPH
    END-IF
    IF tok-n >= 4
        SUBTRACT 3 FROM tok-n GIVING suf-at
        IF FUNCTION UPPER-CASE(tok(suf-at:4)) = ".WAD"
            MOVE tok TO want
        END-IF
    END-IF
    .

note-fps.
    IF fps-on = 0
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO fps-n
    CALL "video_ms" RETURNING now-ms
    IF fps-ms = 0
        MOVE now-ms TO fps-ms
        EXIT PARAGRAPH
    END-IF
    CALL "sub_i32" USING BY VALUE now-ms BY VALUE fps-ms
        RETURNING wait-ms
    IF wait-ms < 1000
        EXIT PARAGRAPH
    END-IF
    MOVE fps-n TO fps-show
    MOVE 0 TO fps-n
    MOVE now-ms TO fps-ms
    IF mode-n = 3
        PERFORM paint-view
    ELSE
        IF mode-n = 0 OR mode-n = 1 OR mode-n = 2
            OR mode-n = 4
            PERFORM draw-front
        END-IF
    END-IF
    .

read-keys.
    CALL "video_key" USING BY VALUE 1073741906 RETURNING k-up
    CALL "video_key" USING BY VALUE 1073741905 RETURNING k-down
    CALL "video_key" USING BY VALUE 1073741904 RETURNING k-left
    CALL "video_key" USING BY VALUE 1073741903 RETURNING k-right
    CALL "video_key" USING BY VALUE 1073742049 RETURNING k-shift
    CALL "video_key" USING BY VALUE 1073742053 RETURNING key-n
    IF key-n NOT = 0
        MOVE 1 TO k-shift
    END-IF
    CALL "video_key" USING BY VALUE 1073742050 RETURNING k-alt
    CALL "video_key" USING BY VALUE 1073742054 RETURNING key-n
    IF key-n NOT = 0
        MOVE 1 TO k-alt
    END-IF
    CALL "video_key" USING BY VALUE 44 RETURNING k-comma
    CALL "video_key" USING BY VALUE 46 RETURNING k-dot
    MOVE 0 TO k-use
    CALL "video_key" USING BY VALUE 32 RETURNING key-n
    IF key-n NOT = 0
        MOVE 1 TO k-use
    END-IF
    CALL "video_key" USING BY VALUE 101 RETURNING key-n
    IF key-n NOT = 0
        MOVE 1 TO k-use
    END-IF
    MOVE 0 TO k-fire
    CALL "video_key" USING BY VALUE 1073742048 RETURNING key-n
    IF key-n NOT = 0
        MOVE 1 TO k-fire
    END-IF
    CALL "video_key" USING BY VALUE 1073742052 RETURNING key-n
    IF key-n NOT = 0
        MOVE 1 TO k-fire
    END-IF
    .

END PROGRAM doom.
