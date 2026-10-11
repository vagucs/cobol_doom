/* DOOM generic portado do python_doom para COBOL com SDL2.

   Por Wagner Nunes da Silva

   vagucs@bol.com.br
   vagucs@vagucs.com.br
   vagucs@gmail.com

   www.vagucs.com.br

   Escala da planta e cores da paleta. O mapa em si fica no COBOL. */

#include <math.h>
#include <stdlib.h>

static double mv_minx;
static double mv_maxy;
static double mv_scale;
static double mv_ox;
static double mv_oy;

void map_fit(int minx, int maxx, int miny, int maxy)
{
    double spanx;
    double spany;
    double sy;

    spanx = (double)maxx - (double)minx;
    spany = (double)maxy - (double)miny;
    if (spanx < 1.0)
        spanx = 1.0;
    if (spany < 1.0)
        spany = 1.0;
    mv_scale = (320.0 - 16.0) / spanx;
    sy = (200.0 - 16.0) / spany;
    if (sy < mv_scale)
        mv_scale = sy;
    mv_minx = (double)minx;
    mv_maxy = (double)maxy;
    mv_ox = (320.0 - spanx * mv_scale) / 2.0;
    mv_oy = (200.0 - spany * mv_scale) / 2.0;
}

void map_to(int x, int y, int *sx, int *sy)
{
    *sx = (int)floor(mv_ox + ((double)x - mv_minx) * mv_scale + 0.5);
    *sy = (int)floor(mv_oy + (mv_maxy - (double)y) * mv_scale + 0.5);
}

void map_arrow(int x, int y, int deg, int *sx, int *sy)
{
    double rad;
    double wx;
    double wy;

    rad = (double)deg * 3.14159265358979323846 / 180.0;
    wx = (double)x + cos(rad) * 128.0;
    wy = (double)y + sin(rad) * 128.0;
    *sx = (int)floor(mv_ox + (wx - mv_minx) * mv_scale + 0.5);
    *sy = (int)floor(mv_oy + (mv_maxy - wy) * mv_scale + 0.5);
}

void pick_map_colors(unsigned char *pal, int *wall, int *open, int *arrow)
{
    int i;
    int r;
    int g;
    int b;
    int sum;
    int spread;
    int dist;
    int best;
    int mid;
    int red;
    int w;
    int o;
    int a;

    best = -1;
    mid = 1000000000;
    red = -1;
    w = 4;
    o = 4;
    a = 4;
    for (i = 0; i < 256; i++) {
        r = pal[i * 3];
        g = pal[i * 3 + 1];
        b = pal[i * 3 + 2];
        sum = r + g + b;
        if (sum > best) {
            best = sum;
            w = i;
        }
        spread = abs(r - g) + abs(g - b) + abs(r - b);
        if (spread < 24 && sum > 180 && sum < 520) {
            dist = abs(sum - 320);
            if (dist < mid) {
                mid = dist;
                o = i;
            }
        }
        if (r > red && r > g + 80 && r > b + 80) {
            red = r;
            a = i;
        }
    }
    if (mid == 1000000000)
        o = w;
    *wall = w;
    *open = o;
    *arrow = a;
}
