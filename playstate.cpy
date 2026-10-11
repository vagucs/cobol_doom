*> Jogador que anda. O quadro inicial nasce do thing tipo 1.
01 play-state EXTERNAL.
   05 ply-on BINARY-LONG VALUE 0.
   05 ply-x BINARY-LONG VALUE 0.
   05 ply-y BINARY-LONG VALUE 0.
   05 ply-z BINARY-LONG VALUE 0.
   05 ply-ang BINARY-LONG VALUE 0.
   05 ply-momx BINARY-LONG VALUE 0.
   05 ply-momy BINARY-LONG VALUE 0.
   05 ply-floor BINARY-LONG VALUE 0.
   05 ply-ceil BINARY-LONG VALUE 0.
   05 ply-bob BINARY-LONG VALUE 0.
   05 ply-vbob BINARY-LONG VALUE 0.
   05 ply-tic BINARY-LONG VALUE 0.
   05 ply-turn BINARY-LONG VALUE 0.
   05 ply-rad BINARY-LONG VALUE 0.
   05 ply-h BINARY-LONG VALUE 0.
   05 ply-momz BINARY-LONG VALUE 0.
   05 ply-vh BINARY-LONG VALUE 2686976.
   05 ply-dvh BINARY-LONG VALUE 0.
   05 ply-ammo BINARY-LONG VALUE 50.
   05 gun-body PIC X(8) VALUE "PISGA0".
   05 gun-flash PIC X(8) VALUE SPACES.
   05 gun-mode BINARY-LONG VALUE 0.
   05 ply-hp BINARY-LONG VALUE 100.
   05 ply-shot BINARY-LONG VALUE 0.
