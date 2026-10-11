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
*> Entrada. Confere o ponto fixo, le o IWAD e desenha a vista 3D do E1M1.
*> Setas ou WASD andam. Espaco ou E abre a porta. Ctrl dispara. Os monstros reagem. Sem rato.
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
01 cmd-line PIC X(260).
01 want PIC X(260).
01 found PIC X(260).
01 lname PIC X(8).
01 show-lumps PIC ZZZZ9.
01 show-lines PIC ZZZZ9.
01 show-verts PIC ZZZZ9.
01 show-tex PIC ZZZ9.
01 fb PIC X(64000).
01 pal PIC X(16384).
COPY "playstate.cpy".
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
01 act-mode BINARY-LONG.
01 moving BINARY-LONG.
01 draw-now BINARY-LONG.
01 air-n BINARY-LONG.
01 tic-n BINARY-LONG.
01 tic-i BINARY-LONG.
01 key-n BINARY-LONG.
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
    MOVE FUNCTION TRIM(cmd-line) TO want
    CALL "find-iwad" USING want found rc
    IF rc = 1
        DISPLAY "IWAD nao encontrado: " FUNCTION TRIM(want)
        STOP RUN RETURNING 1
    END-IF
    IF rc NOT = 0
        DISPLAY "IWAD nao encontrado. Coloque doom1.wad nesta pasta ou numa pasta acima, ou passe o caminho."
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
    CALL "video_upload" USING fb pal
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
        CALL "video_poll" RETURNING pressed
        IF pressed NOT = -1
            PERFORM read-keys
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
                    PERFORM tic-n TIMES
                        IF moving = 1 OR air-n = 1
                            CALL "walk-tic" USING k-up k-down k-left
                                k-right k-shift k-alt k-comma k-dot
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
                    END-PERFORM
                    IF draw-now = 1
                        CALL "view-frame" USING fb ink
                        CALL "video_upload" USING fb pal
                    END-IF
                END-IF
        END-IF
    END-PERFORM
    CALL "video_shutdown"
    STOP RUN.

read-keys.
    CALL "video_key" USING BY VALUE 1073741906 RETURNING k-up
    CALL "video_key" USING BY VALUE 119 RETURNING key-n
    IF key-n NOT = 0
        MOVE 1 TO k-up
    END-IF
    CALL "video_key" USING BY VALUE 1073741905 RETURNING k-down
    CALL "video_key" USING BY VALUE 115 RETURNING key-n
    IF key-n NOT = 0
        MOVE 1 TO k-down
    END-IF
    CALL "video_key" USING BY VALUE 1073741904 RETURNING k-left
    CALL "video_key" USING BY VALUE 97 RETURNING key-n
    IF key-n NOT = 0
        MOVE 1 TO k-left
    END-IF
    CALL "video_key" USING BY VALUE 1073741903 RETURNING k-right
    CALL "video_key" USING BY VALUE 100 RETURNING key-n
    IF key-n NOT = 0
        MOVE 1 TO k-right
    END-IF
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
