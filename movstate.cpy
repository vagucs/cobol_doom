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
*> Portas e pisos em movimento. O save grava este bloco.
01 mov-state EXTERNAL.
   05 dr-on BINARY-LONG OCCURS 32 TIMES.
   05 dr-sec BINARY-LONG OCCURS 32 TIMES.
   05 dr-type BINARY-LONG OCCURS 32 TIMES.
   05 dr-dir BINARY-LONG OCCURS 32 TIMES.
   05 dr-top BINARY-LONG OCCURS 32 TIMES.
   05 dr-spd BINARY-LONG OCCURS 32 TIMES.
   05 dr-wait BINARY-LONG OCCURS 32 TIMES.
   05 sec-door BINARY-LONG OCCURS 512 TIMES.
   05 fl-on BINARY-LONG OCCURS 32 TIMES.
   05 fl-sec BINARY-LONG OCCURS 32 TIMES.
   05 fl-dest BINARY-LONG OCCURS 32 TIMES.
   05 fl-spd BINARY-LONG OCCURS 32 TIMES.
   05 fl-dir BINARY-LONG OCCURS 32 TIMES.
   05 fl-wait BINARY-LONG OCCURS 32 TIMES.
   05 fl-high BINARY-LONG OCCURS 32 TIMES.
   05 fl-kind BINARY-LONG OCCURS 32 TIMES.
   05 pend-tag BINARY-LONG VALUE 0.
