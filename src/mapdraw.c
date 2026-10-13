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

void map_fit(int minx, int maxx, int miny, int maxy, int viewh)
{
    double spanx;
    double spany;
    double sy;
    double vh;

    spanx = (double)maxx - (double)minx;
    spany = (double)maxy - (double)miny;
    if (spanx < 1.0)
        spanx = 1.0;
    if (spany < 1.0)
        spany = 1.0;
    vh = (double)viewh;
    if (vh < 32.0)
        vh = 168.0;
    mv_scale = (320.0 - 16.0) / spanx;
    sy = (vh - 16.0) / spany;
    if (sy < mv_scale)
        mv_scale = sy;
    mv_minx = (double)minx;
    mv_maxy = (double)maxy;
    mv_ox = (320.0 - spanx * mv_scale) / 2.0;
    mv_oy = (vh - spany * mv_scale) / 2.0;
}

void patch_column(unsigned char *fb, int x, unsigned char *patch,
    int plen, int column)
{
    int offset_pos;
    int offset;
    int top;
    int length;
    int source;
    int i;
    int y;

    if (fb == 0 || patch == 0 || x < 0 || x >= 320 || column < 0)
        return;
    offset_pos = 8 + column * 4;
    if (offset_pos + 4 > plen)
        return;
    offset = (int)patch[offset_pos]
        | ((int)patch[offset_pos + 1] << 8)
        | ((int)patch[offset_pos + 2] << 16)
        | ((int)patch[offset_pos + 3] << 24);
    while (offset >= 0 && offset + 1 < plen && patch[offset] != 255) {
        top = patch[offset];
        length = patch[offset + 1];
        source = offset + 3;
        for (i = 0; i < length; i++) {
            y = top + i;
            if (y >= 200)
                break;
            if (source + i < plen)
                fb[y * 320 + x] = patch[source + i];
        }
        offset += length + 4;
    }
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
