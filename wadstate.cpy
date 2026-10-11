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
*> Tabela de lumps. O OCCURS comeca em 1. O indice do Python continua 0-based,
*> entao o slot COBOL e o numero do lump mais 1.
01 wad-state EXTERNAL.
   05 wad-path PIC X(260).
   05 lump-n BINARY-LONG VALUE 0.
   05 lump-tab OCCURS 8192 TIMES.
      10 lump-name PIC X(8).
      10 lump-pos BINARY-LONG.
      10 lump-size BINARY-LONG.
