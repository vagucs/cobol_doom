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
*> Texto final do episodio e do Doom 2. Depois do MAP30 vem o desfile. Sem rato.
IDENTIFICATION DIVISION.
PROGRAM-ID. fin-act.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 fin-stage BINARY-LONG VALUE 0.
01 fin-count BINARY-LONG VALUE 0.
01 fin-len BINARY-LONG VALUE 0.
01 fin-at BINARY-LONG VALUE 1.
01 fin-ep BINARY-LONG VALUE 1.
01 fin-x BINARY-LONG VALUE 10.
01 fin-y BINARY-LONG VALUE 10.
01 show-n BINARY-LONG.
01 scan-i BINARY-LONG.
01 ch-c PIC X.
01 code-n BINARY-LONG.
01 alpha PIC X(26) VALUE "ABCDEFGHIJKLMNOPQRSTUVWXYZ".
01 lname PIC X(8).
01 lump-id BINARY-LONG.
01 flat-buf PIC X(4096).
01 art-buf PIC X(262144).
01 cap-flat BINARY-LONG VALUE 4096.
01 cap-art BINARY-LONG VALUE 262144.
01 nread BINARY-LONG.
01 ink-n BINARY-LONG.
01 row-y BINARY-LONG.
01 col-x BINARY-LONG.
01 src-at BINARY-LONG.
01 dst-at BINARY-LONG.
01 glyph-w BINARY-LONG.
01 patch PIC X(8192).
01 cap-glyph BINARY-LONG VALUE 8192.
01 tens-n BINARY-LONG.
01 ones-n BINARY-LONG.
01 snd-name PIC X(6).
01 mus-loop BINARY-LONG.
01 txt PIC X(900).
01 fin-pack BINARY-LONG VALUE 0.
01 fin-map BINARY-LONG VALUE 0.
01 fin-bun BINARY-LONG VALUE 0.
01 fin-bstage BINARY-LONG VALUE -1.
01 scroll-n BINARY-LONG.
01 src-col BINARY-LONG.
01 stage-n BINARY-LONG.
01 pf1-buf PIC X(262144).
01 pf2-buf PIC X(262144).
01 pf1-len BINARY-LONG VALUE 0.
01 pf2-len BINARY-LONG VALUE 0.
01 flat-nm PIC X(8).
01 cast-n BINARY-LONG VALUE 0.
01 cast-fr BINARY-LONG VALUE 0.
01 cast-wait BINARY-LONG VALUE 0.
01 cast-die BINARY-LONG VALUE 0.
01 cast-seen BINARY-LONG VALUE 0.
01 cast-step BINARY-LONG VALUE 0.
01 cast-diefr BINARY-LONG VALUE 6.
01 cast-spr PIC X(4).
01 cast-title PIC X(24).
01 cast-snd PIC X(6).
01 pen-x BINARY-LONG.
01 wide-n BINARY-LONG.
01 ch-i BINARY-LONG.
01 line-n BINARY-LONG.
01 flip-n BINARY-LONG.
01 rc-n BINARY-LONG.
01 ang-z BINARY-LONG VALUE 0.
01 ang-w BINARY-LONG VALUE 0.
01 e1-txt PIC X(500) VALUE
    "ONCE YOU BEAT THE BIG BADASSES AND|" &
    "CLEAN OUT THE MOON BASE YOU'RE SUPPOSED|" &
    "TO WIN, AREN'T YOU? AREN'T YOU? WHERE'S|" &
    "YOUR FAT REWARD AND TICKET HOME? WHAT|" &
    "THE HELL IS THIS? IT'S NOT SUPPOSED TO|" &
    "END THIS WAY!||" &
    "IT STINKS LIKE ROTTEN MEAT, BUT LOOKS|" &
    "LIKE THE LOST DEIMOS BASE.  LOOKS LIKE|" &
    "YOU'RE STUCK ON THE SHORES OF HELL.|" &
    "THE ONLY WAY OUT IS THROUGH.||" &
    "TO CONTINUE THE DOOM EXPERIENCE, PLAY|" &
    "THE SHORES OF HELL AND ITS AMAZING|" &
    "SEQUEL, INFERNO!|~".
01 e2-txt PIC X(500) VALUE
    "YOU'VE DONE IT! THE HIDEOUS CYBER-|" &
    "DEMON LORD THAT RULED THE LOST DEIMOS|" &
    "MOON BASE HAS BEEN SLAIN AND YOU|" &
    "ARE TRIUMPHANT! BUT ... WHERE ARE|" &
    "YOU? YOU CLAMBER TO THE EDGE OF THE|" &
    "MOON AND LOOK DOWN TO SEE THE AWFUL|" &
    "TRUTH.||" &
    "DEIMOS FLOATS ABOVE HELL ITSELF!|" &
    "YOU'VE NEVER HEARD OF ANYONE ESCAPING|" &
    "FROM HELL, BUT YOU'LL MAKE THE BASTARDS|" &
    "SORRY THEY EVER HEARD OF YOU! QUICKLY,|" &
    "YOU RAPPEL DOWN TO THE SURFACE OF|" &
    "HELL.||" &
    "NOW, IT'S ON TO THE FINAL CHAPTER OF|" &
    "DOOM! -- INFERNO.|~".
01 e3-txt PIC X(600) VALUE
    "THE LOATHSOME SPIDERDEMON THAT|" &
    "MASTERMINDED THE INVASION OF THE MOON|" &
    "BASES AND CAUSED SO MUCH DEATH HAS HAD|" &
    "ITS ASS KICKED FOR ALL TIME.||" &
    "A HIDDEN DOORWAY OPENS AND YOU ENTER.|" &
    "YOU'VE PROVEN TOO TOUGH FOR HELL TO|" &
    "CONTAIN, AND NOW HELL AT LAST PLAYS|" &
    "FAIR -- FOR YOU EMERGE FROM THE DOOR|" &
    "TO SEE THE GREEN FIELDS OF EARTH!|" &
    "HOME AT LAST.||" &
    "YOU WONDER WHAT'S BEEN HAPPENING ON|" &
    "EARTH WHILE YOU WERE BATTLING EVIL|" &
    "UNLEASHED. IT'S GOOD THAT NO HELL-|" &
    "SPAWN COULD HAVE COME THROUGH THAT|" &
    "DOOR WITH YOU ...|~".
01 e4-txt PIC X(700) VALUE
    "THE SPIDER MASTERMIND MUST HAVE SENT FORTH|" &
    "ITS LEGIONS OF HELLSPAWN BEFORE YOUR|" &
    "FINAL CONFRONTATION WITH THAT TERRIBLE|" &
    "BEAST FROM HELL. BUT YOU STEPPED FORWARD|" &
    "AND BROUGHT FORTH ETERNAL DAMNATION AND|" &
    "SUFFERING UPON THE HORDE AS A TRUE HERO|" &
    "WOULD IN THE FACE OF SOMETHING SO EVIL.||" &
    "BESIDES, SOMEONE WAS GONNA PAY FOR WHAT|" &
    "HAPPENED TO DAISY, YOUR PET RABBIT.||" &
    "BUT NOW, YOU SEE SPREAD BEFORE YOU MORE|" &
    "POTENTIAL PAIN AND GIBBITUDE AS A NATION|" &
    "OF DEMONS RUN AMOK AMONG OUR CITIES.||" &
    "NEXT STOP, HELL ON EARTH!|~".
01 c1-txt PIC X(700) VALUE
    "YOU HAVE ENTERED DEEPLY INTO THE INFESTED|" &
    "STARPORT. BUT SOMETHING IS WRONG. THE|" &
    "MONSTERS HAVE BROUGHT THEIR OWN REALITY|" &
    "WITH THEM, AND THE STARPORT'S TECHNOLOGY|" &
    "IS BEING SUBVERTED BY THEIR PRESENCE.||" &
    "AHEAD, YOU SEE AN OUTPOST OF HELL, A|" &
    "FORTIFIED ZONE. IF YOU CAN GET PAST IT,|" &
    "YOU CAN PENETRATE INTO THE HAUNTED HEART|" &
    "OF THE STARBASE AND FIND THE CONTROLLING|" &
    "SWITCH WHICH HOLDS EARTH'S POPULATION|" &
    "HOSTAGE.|~".
01 c2-txt PIC X(900) VALUE
    "YOU HAVE WON! YOUR VICTORY HAS ENABLED|" &
    "HUMANKIND TO EVACUATE EARTH AND ESCAPE|" &
    "THE NIGHTMARE.  NOW YOU ARE THE ONLY|" &
    "HUMAN LEFT ON THE FACE OF THE PLANET.|" &
    "CANNIBAL MUTATIONS, CARNIVOROUS ALIENS,|" &
    "AND EVIL SPIRITS ARE YOUR ONLY NEIGHBORS.|" &
    "YOU SIT BACK AND WAIT FOR DEATH, CONTENT|" &
    "THAT YOU HAVE SAVED YOUR SPECIES.||" &
    "BUT THEN, EARTH CONTROL BEAMS DOWN A|" &
    "MESSAGE FROM SPACE: ""SENSORS HAVE LOCATED|" &
    "THE SOURCE OF THE ALIEN INVASION. IF YOU|" &
    "GO THERE, YOU MAY BE ABLE TO BLOCK THEIR|" &
    "ENTRY.  THE ALIEN BASE IS IN THE HEART OF|" &
    "YOUR OWN HOME CITY, NOT FAR FROM THE|" &
    "STARPORT."" SLOWLY AND PAINFULLY YOU GET|" &
    "UP AND RETURN TO THE FRAY.|~".
01 c3-txt PIC X(600) VALUE
    "YOU ARE AT THE CORRUPT HEART OF THE CITY,|" &
    "SURROUNDED BY THE CORPSES OF YOUR ENEMIES.|" &
    "YOU SEE NO WAY TO DESTROY THE CREATURES'|" &
    "ENTRYWAY ON THIS SIDE, SO YOU CLENCH YOUR|" &
    "TEETH AND PLUNGE THROUGH IT.||" &
    "THERE MUST BE A WAY TO CLOSE IT ON THE|" &
    "OTHER SIDE. WHAT DO YOU CARE IF YOU'VE|" &
    "GOT TO GO THROUGH HELL TO GET TO IT?|~".
01 c4-txt PIC X(800) VALUE
    "THE HORRENDOUS VISAGE OF THE BIGGEST|" &
    "DEMON YOU'VE EVER SEEN CRUMBLES BEFORE|" &
    "YOU, AFTER YOU PUMP YOUR ROCKETS INTO|" &
    "HIS EXPOSED BRAIN. THE MONSTER SHRIVELS|" &
    "UP AND DIES, ITS THRASHING LIMBS|" &
    "DEVASTATING UNTOLD MILES OF HELL'S|" &
    "SURFACE.||" &
    "YOU'VE DONE IT. THE INVASION IS OVER.|" &
    "EARTH IS SAVED. HELL IS A WRECK. YOU|" &
    "WONDER WHERE BAD FOLKS WILL GO WHEN THEY|" &
    "DIE, NOW. WIPING THE SWEAT FROM YOUR|" &
    "FOREHEAD YOU BEGIN THE LONG TREK BACK|" &
    "HOME. REBUILDING EARTH OUGHT TO BE A|" &
    "LOT MORE FUN THAN RUINING IT WAS.|~".
01 c5-txt PIC X(400) VALUE
    "CONGRATULATIONS, YOU'VE FOUND THE SECRET|" &
    "LEVEL! LOOKS LIKE IT'S BEEN BUILT BY|" &
    "HUMANS, RATHER THAN DEMONS. YOU WONDER|" &
    "WHO THE INMATES OF THIS CORNER OF HELL|" &
    "WILL BE.|~".
01 c6-txt PIC X(300) VALUE
    "CONGRATULATIONS, YOU'VE FOUND THE|" &
    "SUPER SECRET LEVEL!  YOU'D BETTER|" &
    "BLAZE THROUGH THIS ONE!|~".

LINKAGE SECTION.
01 fb PIC X(64000).
01 cmd BINARY-LONG.
01 map-name PIC X(8).
01 stage-out BINARY-LONG.

PROCEDURE DIVISION USING fb cmd map-name stage-out.
    IF cmd = 1
        PERFORM boot-fin
    ELSE
        IF cmd = 2
            PERFORM tick-fin
        ELSE
            PERFORM key-fin
        END-IF
    END-IF
    MOVE fin-stage TO stage-out
    GOBACK.

boot-fin.
    MOVE 0 TO fin-stage
    MOVE 0 TO fin-count
    MOVE 1 TO fin-at
    MOVE 10 TO fin-x
    MOVE 10 TO fin-y
    MOVE 0 TO fin-pack
    MOVE 0 TO fin-bun
    MOVE 1 TO fin-ep
    IF map-name(1:3) = "MAP"
        PERFORM pick-pack
    ELSE
        PERFORM pick-episode
    END-IF
    MOVE 0 TO fin-len
    PERFORM VARYING scan-i FROM 1 BY 1 UNTIL scan-i > 900
        IF txt(scan-i:1) = "~"
            SUBTRACT 1 FROM scan-i GIVING fin-len
            EXIT PERFORM
        END-IF
    END-PERFORM
    PERFORM paint-flat
    .

pick-episode.
    IF map-name(2:1) = "2"
        MOVE 2 TO fin-ep
    END-IF
    IF map-name(2:1) = "3"
        MOVE 3 TO fin-ep
    END-IF
    IF map-name(2:1) = "4"
        MOVE 4 TO fin-ep
    END-IF
    IF fin-ep = 2
        MOVE e2-txt TO txt
    ELSE
        IF fin-ep = 3
            MOVE e3-txt TO txt
        ELSE
            IF fin-ep = 4
                MOVE e4-txt TO txt
            ELSE
                MOVE e1-txt TO txt
            END-IF
        END-IF
    END-IF
    .

pick-pack.
    MOVE 1 TO fin-pack
    COMPUTE fin-map = FUNCTION NUMVAL(map-name(4:2))
    MOVE "SLIME16" TO flat-nm
    MOVE c1-txt TO txt
    IF fin-map = 11
        MOVE "RROCK14" TO flat-nm
        MOVE c2-txt TO txt
    END-IF
    IF fin-map = 15
        MOVE "RROCK13" TO flat-nm
        MOVE c5-txt TO txt
    END-IF
    IF fin-map = 20
        MOVE "RROCK07" TO flat-nm
        MOVE c3-txt TO txt
    END-IF
    IF fin-map = 30
        MOVE "RROCK17" TO flat-nm
        MOVE c4-txt TO txt
    END-IF
    IF fin-map = 31
        MOVE "RROCK19" TO flat-nm
        MOVE c6-txt TO txt
    END-IF
    .

paint-flat.
    IF fin-pack = 1
        MOVE flat-nm TO lname
    ELSE
    IF fin-ep = 2
        MOVE "SFLR6_1" TO lname
    ELSE
        IF fin-ep = 3
            MOVE "MFLR8_4" TO lname
        ELSE
            IF fin-ep = 4
                MOVE "MFLR8_3" TO lname
            ELSE
                MOVE "FLOOR4_8" TO lname
            END-IF
        END-IF
    END-IF
    END-IF
    MOVE ALL X"00" TO flat-buf
    CALL "wad-find" USING lname lump-id
    IF lump-id >= 0
        CALL "wad-read-num" USING lump-id flat-buf cap-flat nread
    END-IF
    PERFORM VARYING row-y FROM 0 BY 1 UNTIL row-y >= 200
        COMPUTE src-at = FUNCTION MOD(row-y, 64) * 64 + 1
        PERFORM VARYING col-x FROM 0 BY 64 UNTIL col-x >= 320
            COMPUTE dst-at = row-y * 320 + col-x + 1
            CALL "mem_copy" USING fb(dst-at:64) flat-buf(src-at:64)
                BY VALUE 64
        END-PERFORM
    END-PERFORM
    .

tick-fin.
    IF fin-stage = 2
        PERFORM cast-tick
        EXIT PARAGRAPH
    END-IF
    IF fin-stage = 1 AND fin-bun = 1
        ADD 1 TO fin-count
        PERFORM draw-bunny
        EXIT PARAGRAPH
    END-IF
    IF fin-stage NOT = 0
        ADD 1 TO fin-count
        EXIT PARAGRAPH
    END-IF
    ADD 1 TO fin-count
    DIVIDE fin-count BY 3 GIVING show-n
    PERFORM UNTIL fin-at > fin-len OR fin-at > show-n
        PERFORM one-ch
        ADD 1 TO fin-at
    END-PERFORM
    IF fin-pack = 1
        EXIT PARAGRAPH
    END-IF
    COMPUTE scan-i = fin-len * 3 + 250
    IF fin-count > scan-i
        PERFORM show-art
    END-IF
    .

key-fin.
    IF fin-stage = 2
        IF cmd = 27
            MOVE 9 TO fin-stage
        ELSE
            PERFORM cast-hit
        END-IF
        EXIT PARAGRAPH
    END-IF
    IF fin-stage = 0
        IF fin-pack = 1
            IF fin-count <= 50
                EXIT PARAGRAPH
            END-IF
            IF fin-map = 30
                PERFORM start-cast
            ELSE
                MOVE 8 TO fin-stage
            END-IF
            EXIT PARAGRAPH
        END-IF
        PERFORM show-art
        EXIT PARAGRAPH
    END-IF
    IF fin-stage = 1 AND fin-bun = 1 AND fin-count > 1130
        MOVE 9 TO fin-stage
    END-IF
    IF fin-stage = 1 AND fin-bun = 0 AND fin-count > 10
        MOVE 9 TO fin-stage
    END-IF
    .

one-ch.
    MOVE txt(fin-at:1) TO ch-c
    IF ch-c = "|"
        MOVE 10 TO fin-x
        ADD 11 TO fin-y
        EXIT PARAGRAPH
    END-IF
    IF ch-c = " "
        ADD 4 TO fin-x
        EXIT PARAGRAPH
    END-IF
    PERFORM code-of
    IF code-n = 0
        ADD 4 TO fin-x
        EXIT PARAGRAPH
    END-IF
    PERFORM load-glyph
    IF nread < 8
        ADD 4 TO fin-x
        EXIT PARAGRAPH
    END-IF
    ADD fin-x TO glyph-w GIVING col-x
    IF col-x > 320 OR fin-y > 190
        ADD glyph-w TO fin-x
        EXIT PARAGRAPH
    END-IF
    CALL "v-draw-patch" USING fb patch nread ink-n fin-x fin-y
    ADD glyph-w TO fin-x
    .

code-of.
    MOVE 0 TO code-n
    PERFORM VARYING scan-i FROM 1 BY 1 UNTIL scan-i > 26
        IF ch-c = alpha(scan-i:1)
            ADD 64 TO scan-i GIVING code-n
            EXIT PERFORM
        END-IF
    END-PERFORM
    IF ch-c = "!"
        MOVE 33 TO code-n
    END-IF
    IF ch-c = "'"
        MOVE 39 TO code-n
    END-IF
    IF ch-c = ","
        MOVE 44 TO code-n
    END-IF
    IF ch-c = "-"
        MOVE 45 TO code-n
    END-IF
    IF ch-c = "."
        MOVE 46 TO code-n
    END-IF
    IF ch-c = "?"
        MOVE 63 TO code-n
    END-IF
    IF ch-c = ":"
        MOVE 58 TO code-n
    END-IF
    IF ch-c = """"
        MOVE 34 TO code-n
    END-IF
    .

load-glyph.
    MOVE 0 TO nread
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
    CALL "wad-read-num" USING lump-id patch cap-glyph nread
    IF nread < 8
        EXIT PARAGRAPH
    END-IF
    CALL "i16_le" USING BY REFERENCE patch BY VALUE 0 RETURNING glyph-w
    IF glyph-w < 1
        MOVE 4 TO glyph-w
    END-IF
    .

show-art.
    MOVE 1 TO fin-stage
    MOVE 0 TO fin-count
    MOVE ALL X"00" TO fb
    IF fin-ep = 2
        MOVE "VICTORY2" TO lname
    ELSE
        IF fin-ep = 4
            MOVE "ENDPIC" TO lname
        ELSE
            IF fin-ep = 3
                MOVE "PFUB2" TO lname
            ELSE
                MOVE "HELP2" TO lname
            END-IF
        END-IF
    END-IF
    CALL "wad-find" USING lname lump-id
    IF lump-id < 0
        MOVE "HELP2" TO lname
        CALL "wad-find" USING lname lump-id
    END-IF
    IF lump-id < 0
        MOVE "HELP1" TO lname
        CALL "wad-find" USING lname lump-id
    END-IF
    IF lump-id >= 0
        CALL "wad-read-num" USING lump-id art-buf cap-art nread
        IF nread >= 8
            MOVE 0 TO fin-x
            MOVE 0 TO fin-y
            CALL "v-draw-patch" USING fb art-buf nread ink-n fin-x fin-y
        END-IF
    END-IF
    IF fin-ep = 3
        PERFORM load-bunny
        IF fin-bun = 1
            MOVE ALL X"00" TO fb
            MOVE -1 TO fin-bstage
        END-IF
        MOVE "bunny" TO snd-name
        MOVE 1 TO mus-loop
        CALL "mus-play" USING snd-name mus-loop
    END-IF
    .

load-bunny.
    MOVE 0 TO fin-bun
    MOVE "PFUB1" TO lname
    CALL "wad-find" USING lname lump-id
    IF lump-id < 0
        EXIT PARAGRAPH
    END-IF
    CALL "wad-read-num" USING lump-id pf1-buf cap-art pf1-len
    MOVE "PFUB2" TO lname
    CALL "wad-find" USING lname lump-id
    IF lump-id < 0
        EXIT PARAGRAPH
    END-IF
    CALL "wad-read-num" USING lump-id pf2-buf cap-art pf2-len
    IF pf1-len >= 8 AND pf2-len >= 8
        MOVE 1 TO fin-bun
    END-IF
    .

draw-bunny.
    MOVE ALL X"00" TO fb
    MOVE 320 TO scroll-n
    IF fin-count >= 230
        COMPUTE scroll-n = fin-count - 230
        DIVIDE scroll-n BY 2 GIVING scroll-n
        COMPUTE scroll-n = 320 - scroll-n
        IF scroll-n < 0
            MOVE 0 TO scroll-n
        END-IF
    END-IF
    PERFORM VARYING col-x FROM 0 BY 1 UNTIL col-x >= 320
        COMPUTE src-col = col-x + scroll-n
        IF src-col < 320
            CALL "patch_column" USING BY REFERENCE fb BY VALUE col-x
                BY REFERENCE pf2-buf BY VALUE pf2-len BY VALUE src-col
        ELSE
            COMPUTE src-col = src-col - 320
            CALL "patch_column" USING BY REFERENCE fb BY VALUE col-x
                BY REFERENCE pf1-buf BY VALUE pf1-len BY VALUE src-col
        END-IF
    END-PERFORM
    IF fin-count < 1130
        EXIT PARAGRAPH
    END-IF
    MOVE 0 TO stage-n
    IF fin-count >= 1180
        COMPUTE stage-n = fin-count - 1180
        DIVIDE stage-n BY 5 GIVING stage-n
        IF stage-n > 6
            MOVE 6 TO stage-n
        END-IF
    END-IF
    IF stage-n NOT = fin-bstage
        IF fin-bstage >= 0
            MOVE "pistol" TO snd-name
            CALL "sfx-play" USING snd-name
        END-IF
        IF stage-n = 0 AND fin-bstage < 0
            MOVE "pistol" TO snd-name
            CALL "sfx-play" USING snd-name
        END-IF
        MOVE stage-n TO fin-bstage
        MOVE "END0" TO lname
        EVALUATE stage-n
            WHEN 1 MOVE "1" TO lname(4:1)
            WHEN 2 MOVE "2" TO lname(4:1)
            WHEN 3 MOVE "3" TO lname(4:1)
            WHEN 4 MOVE "4" TO lname(4:1)
            WHEN 5 MOVE "5" TO lname(4:1)
            WHEN 6 MOVE "6" TO lname(4:1)
            WHEN OTHER MOVE "0" TO lname(4:1)
        END-EVALUATE
        CALL "wad-find" USING lname lump-id
        IF lump-id >= 0
            CALL "wad-read-num" USING lump-id art-buf cap-art nread
        ELSE
            MOVE 0 TO nread
        END-IF
    END-IF
    IF nread >= 8
        MOVE 108 TO fin-x
        MOVE 68 TO fin-y
        CALL "v-draw-patch" USING fb art-buf nread ink-n fin-x fin-y
    END-IF
    .

start-cast.
    MOVE 2 TO fin-stage
    MOVE 0 TO cast-n
    MOVE 0 TO cast-die
    MOVE 0 TO cast-fr
    MOVE 0 TO cast-seen
    MOVE 0 TO cast-step
    MOVE 8 TO cast-wait
    PERFORM load-cast
    PERFORM draw-cast
    MOVE "evil" TO snd-name
    MOVE 1 TO mus-loop
    CALL "mus-play" USING snd-name mus-loop
    .

cast-hit.
    IF cast-die = 1
        EXIT PARAGRAPH
    END-IF
    MOVE 1 TO cast-die
    MOVE 0 TO cast-step
    MOVE cast-diefr TO cast-fr
    MOVE 6 TO cast-wait
    MOVE "dmpain" TO snd-name
    IF cast-spr = "POSS" OR cast-spr = "SPOS"
        OR cast-spr = "CPOS"
        MOVE "popain" TO snd-name
    END-IF
    IF cast-spr = "PLAY"
        MOVE "pldeth" TO snd-name
    END-IF
    CALL "sfx-play" USING snd-name
    PERFORM draw-cast
    .

cast-tick.
    IF cast-wait > 0
        SUBTRACT 1 FROM cast-wait
        PERFORM draw-cast
        EXIT PARAGRAPH
    END-IF
    IF cast-die = 1
        ADD 1 TO cast-step
        ADD 1 TO cast-fr
        MOVE 6 TO cast-wait
        IF cast-step >= 5
            PERFORM next-cast
        END-IF
    ELSE
        IF cast-fr >= 4
            MOVE 0 TO cast-fr
            MOVE 8 TO cast-wait
        ELSE
            IF cast-fr = 0
                MOVE 1 TO cast-fr
            ELSE
                MOVE 0 TO cast-fr
            END-IF
            ADD 1 TO cast-seen
            MOVE 8 TO cast-wait
            IF cast-seen >= 12
                MOVE 0 TO cast-seen
                MOVE 4 TO cast-fr
                MOVE 12 TO cast-wait
                CALL "sfx-play" USING cast-snd
            END-IF
        END-IF
    END-IF
    PERFORM draw-cast
    .

next-cast.
    ADD 1 TO cast-n
    IF cast-n > 16
        MOVE 0 TO cast-n
    END-IF
    MOVE 0 TO cast-die
    MOVE 0 TO cast-fr
    MOVE 0 TO cast-seen
    MOVE 0 TO cast-step
    MOVE 8 TO cast-wait
    PERFORM load-cast
    .

load-cast.
    MOVE "POSS" TO cast-spr
    MOVE "ZOMBIEMAN" TO cast-title
    MOVE "pistol" TO cast-snd
    MOVE 7 TO cast-diefr
    IF cast-n = 1
        MOVE "SPOS" TO cast-spr
        MOVE "SHOTGUN GUY" TO cast-title
        MOVE "shotgn" TO cast-snd
        MOVE 7 TO cast-diefr
    END-IF
    IF cast-n = 2
        MOVE "CPOS" TO cast-spr
        MOVE "HEAVY WEAPON DUDE" TO cast-title
        MOVE "shotgn" TO cast-snd
        MOVE 7 TO cast-diefr
    END-IF
    IF cast-n = 3
        MOVE "TROO" TO cast-spr
        MOVE "IMP" TO cast-title
        MOVE "claw" TO cast-snd
        MOVE 8 TO cast-diefr
    END-IF
    IF cast-n = 4
        MOVE "SARG" TO cast-spr
        MOVE "DEMON" TO cast-title
        MOVE "sgtatk" TO cast-snd
        MOVE 8 TO cast-diefr
    END-IF
    IF cast-n = 5
        MOVE "SKUL" TO cast-spr
        MOVE "LOST SOUL" TO cast-title
        MOVE "sklatk" TO cast-snd
        MOVE 2 TO cast-diefr
    END-IF
    IF cast-n = 6
        MOVE "HEAD" TO cast-spr
        MOVE "CACODEMON" TO cast-title
        MOVE "firsht" TO cast-snd
        MOVE 6 TO cast-diefr
    END-IF
    IF cast-n = 7
        MOVE "BOS2" TO cast-spr
        MOVE "HELL KNIGHT" TO cast-title
        MOVE "firsht" TO cast-snd
        MOVE 6 TO cast-diefr
    END-IF
    IF cast-n = 8
        MOVE "BOSS" TO cast-spr
        MOVE "BARON OF HELL" TO cast-title
        MOVE "firsht" TO cast-snd
        MOVE 6 TO cast-diefr
    END-IF
    IF cast-n = 9
        MOVE "BSPI" TO cast-spr
        MOVE "ARACHNOTRON" TO cast-title
        MOVE "plasma" TO cast-snd
        MOVE 6 TO cast-diefr
    END-IF
    IF cast-n = 10
        MOVE "PAIN" TO cast-spr
        MOVE "PAIN ELEMENTAL" TO cast-title
        MOVE "sklatk" TO cast-snd
        MOVE 6 TO cast-diefr
    END-IF
    IF cast-n = 11
        MOVE "SKEL" TO cast-spr
        MOVE "REVENANT" TO cast-title
        MOVE "skeatk" TO cast-snd
        MOVE 6 TO cast-diefr
    END-IF
    IF cast-n = 12
        MOVE "FATT" TO cast-spr
        MOVE "MANCUBUS" TO cast-title
        MOVE "firsht" TO cast-snd
        MOVE 6 TO cast-diefr
    END-IF
    IF cast-n = 13
        MOVE "VILE" TO cast-spr
        MOVE "ARCH-VILE" TO cast-title
        MOVE "vilatk" TO cast-snd
        MOVE 6 TO cast-diefr
    END-IF
    IF cast-n = 14
        MOVE "SPID" TO cast-spr
        MOVE "THE SPIDER MASTERMIND" TO cast-title
        MOVE "shotgn" TO cast-snd
        MOVE 6 TO cast-diefr
    END-IF
    IF cast-n = 15
        MOVE "CYBR" TO cast-spr
        MOVE "THE CYBERDEMON" TO cast-title
        MOVE "rlaunc" TO cast-snd
        MOVE 6 TO cast-diefr
    END-IF
    IF cast-n = 16
        MOVE "PLAY" TO cast-spr
        MOVE "OUR HERO" TO cast-title
        MOVE "shotgn" TO cast-snd
        MOVE 6 TO cast-diefr
    END-IF
    .

draw-cast.
    MOVE ALL X"00" TO fb
    MOVE "BOSSBACK" TO lname
    CALL "wad-find" USING lname lump-id
    IF lump-id >= 0
        CALL "wad-read-num" USING lump-id art-buf cap-art nread
        IF nread >= 8
            MOVE 0 TO fin-x
            MOVE 0 TO fin-y
            CALL "v-draw-patch" USING fb art-buf nread ink-n
                fin-x fin-y
        END-IF
    END-IF
    PERFORM cast-print
    MOVE 0 TO ang-z
    MOVE 0 TO ang-w
    CALL "spr-lookup" USING cast-spr cast-fr ang-z ang-w
        lump-id flip-n rc-n
    IF rc-n = 0 AND lump-id >= 0
        CALL "wad-read-num" USING lump-id art-buf cap-art nread
        IF nread >= 8
            MOVE 160 TO col-x
            MOVE 170 TO row-y
            CALL "v-draw-patch" USING fb art-buf nread ink-n
                col-x row-y
        END-IF
    END-IF
    .

cast-print.
    MOVE FUNCTION LENGTH(FUNCTION TRIM(cast-title)) TO line-n
    IF line-n < 1
        EXIT PARAGRAPH
    END-IF
    MOVE 0 TO wide-n
    PERFORM VARYING ch-i FROM 1 BY 1 UNTIL ch-i > line-n
        MOVE cast-title(ch-i:1) TO ch-c
        PERFORM glyph-span
        ADD glyph-w TO wide-n
    END-PERFORM
    DIVIDE wide-n BY 2 GIVING pen-x
    SUBTRACT pen-x FROM 160 GIVING fin-x
    MOVE 10 TO fin-y
    PERFORM VARYING ch-i FROM 1 BY 1 UNTIL ch-i > line-n
        MOVE cast-title(ch-i:1) TO ch-c
        IF ch-c = " "
            ADD 4 TO fin-x
        ELSE
            PERFORM code-of
            PERFORM load-glyph
            IF nread >= 8
                CALL "v-draw-patch" USING fb patch nread ink-n
                    fin-x fin-y
                ADD glyph-w TO fin-x
            ELSE
                ADD 4 TO fin-x
            END-IF
        END-IF
    END-PERFORM
    .

glyph-span.
    IF ch-c = " "
        MOVE 4 TO glyph-w
    ELSE
        PERFORM code-of
        PERFORM load-glyph
        IF nread < 8
            MOVE 4 TO glyph-w
        END-IF
    END-IF
    .

END PROGRAM fin-act.
