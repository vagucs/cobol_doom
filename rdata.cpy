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
*> Texturas e flats. Indice 0 do Python e o slot COBOL menos 1.
01 rdata-state EXTERNAL.
   05 n-tex BINARY-LONG VALUE 0.
   05 n-flat BINARY-LONG VALUE 0.
   05 flats-first BINARY-LONG VALUE 0.
   05 flats-last BINARY-LONG VALUE 0.
   05 sky-flat BINARY-LONG VALUE 0.
   05 sky-tex BINARY-LONG VALUE 0.
   05 cmap-n BINARY-LONG VALUE 0.
   05 n-pname BINARY-LONG VALUE 0.
   05 n-tpatch BINARY-LONG VALUE 0.
   05 n-col BINARY-LONG VALUE 0.
   05 pname-lump BINARY-LONG OCCURS 512 TIMES.
   05 tex-name PIC X(8) OCCURS 512 TIMES.
   05 tex-w BINARY-LONG OCCURS 512 TIMES.
   05 tex-h BINARY-LONG OCCURS 512 TIMES.
   05 tex-mask BINARY-LONG OCCURS 512 TIMES.
   05 tex-pn BINARY-LONG OCCURS 512 TIMES.
   05 tex-p0 BINARY-LONG OCCURS 512 TIMES.
   05 tex-c0 BINARY-LONG OCCURS 512 TIMES.
   05 tp-x BINARY-LONG OCCURS 2048 TIMES.
   05 tp-y BINARY-LONG OCCURS 2048 TIMES.
   05 tp-lump BINARY-LONG OCCURS 2048 TIMES.
   05 col-lump BINARY-LONG OCCURS 48000 TIMES.
   05 col-ofs BINARY-LONG OCCURS 48000 TIMES.
   05 swatch-tex BINARY-LONG OCCURS 512 TIMES.
   05 swatch-flat BINARY-LONG OCCURS 256 TIMES.
   05 cmap-buf PIC X(8704).
   05 col-ready BINARY-LONG OCCURS 48000 TIMES VALUE 0.
   05 col-img PIC X(128) OCCURS 48000 TIMES.
   05 flat-ready BINARY-LONG OCCURS 256 TIMES VALUE 0.
   05 flat-img PIC X(4096) OCCURS 256 TIMES.
