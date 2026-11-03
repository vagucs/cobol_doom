/* DOOM generic portado do python_doom para COBOL com SDL3.

   Por Wagner Nunes da Silva

   vagucs@bol.com.br
   vagucs@vagucs.com.br
   vagucs@gmail.com

   www.vagucs.com.br

   Estouro de 32 bits e ponto fixo 16.16, iguais a doom/compat.py.
   A divisao decimal do COBOL nao reproduz o deslocamento. */

#include <stdint.h>
#include <string.h>

#include "tables_data.h"

int32_t as_i32(int64_t n)
{
    uint32_t u;

    u = (uint32_t)n;
    if (u >= 0x80000000u)
        return (int32_t)((int64_t)u - 4294967296LL);
    return (int32_t)u;
}

uint32_t as_u32(int64_t n)
{
    return (uint32_t)n;
}

uint32_t ushr32(int64_t n, int bits)
{
    uint32_t u;

    u = (uint32_t)n;
    if (bits <= 0)
        return u;
    if (bits >= 32)
        return 0;
    return u >> bits;
}

int32_t shar32(int32_t n, int bits)
{
    if (bits <= 0)
        return n;
    if (bits >= 31)
        return n < 0 ? -1 : 0;
    return n >> bits;
}

/* Harbour P_XYMovement: Int(n/2) toward zero (#18). */
int32_t trunc2_i32(int32_t n)
{
    if (n < 0)
        return -((-n) / 2);
    return n / 2;
}

int32_t fixed_mul(int32_t a, int32_t b)
{
    return as_i32(((int64_t)a * (int64_t)b) >> 16);
}

int32_t fixed_div(int32_t a, int32_t b)
{
    int64_t wide;
    int64_t abs_a;
    int64_t abs_b;
    int64_t q;

    if (b == 0)
        return a >= 0 ? 0x7FFFFFFF : (int32_t)0x80000000;
    abs_a = a < 0 ? -(int64_t)a : (int64_t)a;
    abs_b = b < 0 ? -(int64_t)b : (int64_t)b;
    if ((abs_a >> 14) >= abs_b)
        return (a ^ b) < 0 ? (int32_t)0x80000000 : 0x7FFFFFFF;
    wide = (int64_t)a << 16;
    q = wide / b;
    if ((wide % b) != 0 && ((a ^ b) < 0))
        q -= 1;
    return as_i32(q);
}

int fixed_from_i16(int v)
{
    return as_i32((int64_t)v * 65536);
}

int sub_i32(int a, int b)
{
    return as_i32((int64_t)a - (int64_t)b);
}

int angle_from_i16(int v)
{
    return (int)((uint32_t)(int16_t)v << 16);
}

int bit_and(int a, int b)
{
    return a & b;
}

int bit_xor(int a, int b)
{
    return a ^ b;
}

int bit_or(int a, int b)
{
    return a | b;
}

int add_i32(int a, int b)
{
    return as_i32((int64_t)a + (int64_t)b);
}

int ushr_i(int n, int bits)
{
    unsigned u;

    u = (unsigned)n;
    if (bits <= 0)
        return (int)u;
    if (bits >= 32)
        return 0;
    return (int)(u >> bits);
}

int abs_fixed_i(int n)
{
    if (n >= 0)
        return n;
    if (n == (int)0x80000000)
        return n;
    return -n;
}

int udiv_u32(int a, int b)
{
    if (b == 0)
        return 0;
    return (int)((unsigned)a / (unsigned)b);
}

int ugt_u32(int a, int b)
{
    return (unsigned)a > (unsigned)b;
}

int uge_u32(int a, int b)
{
    return (unsigned)a >= (unsigned)b;
}

int floor_div_i(int a, int b)
{
    int q;
    int r;

    if (b == 0)
        return 0;
    q = a / b;
    r = a % b;
    if (r != 0 && ((a ^ b) < 0))
        q -= 1;
    return q;
}

int slope_div_i(int num, int den)
{
    long long n;
    long long d;
    long long ans;

    if (den < 512)
        return 2048;
    n = (long long)num << 3;
    d = (long long)den >> 8;
    if (d == 0)
        return 2048;
    ans = n / d;
    if (ans > 2048)
        return 2048;
    if (ans < 0)
        return 0;
    return (int)ans;
}

int angle_from_deg(int deg)
{
    return (int)((int64_t)deg * 536870912LL / 45);
}

int deg_from_ang(int ang)
{
    return (int)((int64_t)ang * 45 / 536870912LL);
}

/* P_PointOnLineSide. Axis lines use the vanilla short path; the rest is FixedMul. */
int line_side(int x, int y, int v1x, int v1y, int ldx, int ldy)
{
    int dx;
    int dy;
    long long left;
    long long right;

    if (ldx == 0) {
        if (x <= v1x)
            return ldy > 0 ? 1 : 0;
        return ldy < 0 ? 1 : 0;
    }
    if (ldy == 0) {
        if (y <= v1y)
            return ldx < 0 ? 1 : 0;
        return ldx > 0 ? 1 : 0;
    }
    dx = as_i32((long long)x - v1x);
    dy = as_i32((long long)y - v1y);
    left = ((long long)(ldy >> 16) * (long long)dx) >> 16;
    right = ((long long)dy * (long long)(ldx >> 16)) >> 16;
    return right < left ? 0 : 1;
}

int point_side(int nodex, int nodey, int nodedx, int nodedy, int x, int y)
{
    int dx;
    int dy;
    unsigned xorv;
    int left;
    int right;

    /* R_PointOnSide: axis fast path, sign bits, then FixedMul of >>8. */
    if (nodedx == 0) {
        if (x <= nodex)
            return nodedy > 0 ? 1 : 0;
        return nodedy < 0 ? 1 : 0;
    }
    if (nodedy == 0) {
        if (y <= nodey)
            return nodedx < 0 ? 1 : 0;
        return nodedx > 0 ? 1 : 0;
    }
    dx = as_i32((long long)x - nodex);
    dy = as_i32((long long)y - nodey);
    xorv = as_u32(nodedy) ^ as_u32(nodedx) ^ as_u32(dx) ^ as_u32(dy);
    if (xorv & 0x80000000u)
        return ((as_u32(nodedy) ^ as_u32(dx)) & 0x80000000u) ? 1 : 0;
    left = fixed_mul(shar32(nodedy, 8), shar32(dx, 8));
    right = fixed_mul(shar32(dy, 8), shar32(nodedx, 8));
    return right < left ? 0 : 1;
}

int shl_i(int n, int bits)
{
    if (bits <= 0)
        return n;
    if (bits >= 32)
        return 0;
    return (int)((unsigned)n << bits);
}

int mul_i32(int a, int b)
{
    return (int)((long long)a * (long long)b);
}

int k_ang180(void)
{
    return (int)0x80000000;
}

int tanto_sine(int tanto)
{
    unsigned s;

    s = (unsigned)tanto + 0x40000000u;
    return (int)((s >> 19) & 8191u);
}

/* Movement path: baked extended finesine (10240) — PARITY #58/#59. */
static int ang_sine_ready;

static void ensure_ang_sine(void)
{
    ang_sine_ready = 1;
}

int fine_sin_ang(int angle)
{
    unsigned u;

    ensure_ang_sine();
    u = (unsigned)angle;
    return DOOM_FINESINE[(u >> 19) & 8191u];
}

int fine_cos_ang(int angle)
{
    unsigned u;
    unsigned idx;

    ensure_ang_sine();
    u = (unsigned)angle;
    /* Harbour/Python: finesine[idx + 2048] — no remask (#59). */
    idx = (u >> 19) & 8191u;
    return DOOM_FINESINE[idx + 2048u];
}

void build_finesine(int *dst, int n)
{
    int copy;

    /* Prefer full extended table when caller allocates 10240. */
    copy = n;
    if (copy > DOOM_FINESINE_LEN)
        copy = DOOM_FINESINE_LEN;
    memcpy(dst, DOOM_FINESINE, (size_t)copy * sizeof(int));
}

void build_finetangent(int *dst, int n)
{
    int copy;

    copy = n;
    if (copy > DOOM_FINETANGENT_LEN)
        copy = DOOM_FINETANGENT_LEN;
    memcpy(dst, DOOM_FINETANGENT, (size_t)copy * sizeof(int));
}

void build_tantoangle(int *dst, int n)
{
    int copy;

    copy = n;
    if (copy > DOOM_TANTOANGLE_LEN)
        copy = DOOM_TANTOANGLE_LEN;
    memcpy(dst, DOOM_TANTOANGLE, (size_t)copy * sizeof(int));
}

int add_shr16(int a, int b)
{
    return (int)(((long long)a + (long long)b) >> 16);
}

static long long spr_topscreen(int centeryfrac, int texmid, int scale, int topdelta)
{
    long long top;

    top = (long long)centeryfrac - (long long)fixed_mul(texmid, scale);
    top += (long long)scale * (long long)topdelta;
    return top;
}

int spr_yl(int centeryfrac, int texmid, int scale, int topdelta)
{
    return (int)((spr_topscreen(centeryfrac, texmid, scale, topdelta) + 65535) >> 16);
}

int spr_yh(int centeryfrac, int texmid, int scale, int topdelta, int length)
{
    long long bot;

    bot = spr_topscreen(centeryfrac, texmid, scale, topdelta);
    bot += (long long)scale * (long long)length;
    return (int)((bot - 1) >> 16);
}

int spr_texfrac(int centeryfrac, int texmid, int scale, int topdelta, int yl, int iscale)
{
    long long rel;

    rel = ((long long)yl << 16) - spr_topscreen(centeryfrac, texmid, scale, topdelta);
    return fixed_mul(as_i32(rel), iscale);
}

int spr_tx(int gyt, int gxt, int adjust)
{
    return as_i32(-((long long)gyt + (long long)gxt) + (long long)adjust);
}

int spr_reject_side(int gyt, int gxt, int tz)
{
    long long tx;
    long long ax;

    tx = -((long long)gyt + (long long)gxt);
    ax = tx < 0 ? -tx : tx;
    return ax > (long long)tz * 4LL;
}

int delta_shr16(int a, int b)
{
    return (int)(((long long)a - (long long)b) >> 16);
}

int spr_col(int startfrac, int xiscale, int steps)
{
    long long v;

    v = (long long)startfrac + (long long)xiscale * (long long)steps;
    return (int)(v >> 16);
}

/* P_PointOnLineSide. Axis compares the vertex; the diagonal is FixedMul. */
static int line_point_side(int x, int y, int v1x, int v1y, int ldx, int ldy)
{
    int dx;
    int dy;
    int left;
    int right;

    if (ldx == 0) {
        if (x <= v1x)
            return ldy > 0 ? 1 : 0;
        return ldy < 0 ? 1 : 0;
    }
    if (ldy == 0) {
        if (y <= v1y)
            return ldx < 0 ? 1 : 0;
        return ldx > 0 ? 1 : 0;
    }
    dx = as_i32((int64_t)x - v1x);
    dy = as_i32((int64_t)y - v1y);
    left = fixed_mul(ldy >> 16, dx);
    right = fixed_mul(dy, ldx >> 16);
    return right < left ? 0 : 1;
}

/* P_PointOnDivlineSide — not BSP point_side (>>16). */
static int divline_side(int ox, int oy, int tdx, int tdy, int x, int y)
{
    int dx;
    int dy;
    unsigned xorv;
    int left;
    int right;

    if (tdx == 0) {
        if (x <= ox)
            return tdy > 0 ? 1 : 0;
        return tdy < 0 ? 1 : 0;
    }
    if (tdy == 0) {
        if (y <= oy)
            return tdx < 0 ? 1 : 0;
        return tdx > 0 ? 1 : 0;
    }
    dx = as_i32((int64_t)x - ox);
    dy = as_i32((int64_t)y - oy);
    xorv = as_u32(tdy) ^ as_u32(tdx) ^ as_u32(dx) ^ as_u32(dy);
    if (xorv & 0x80000000u)
        return ((as_u32(tdy) ^ as_u32(dx)) & 0x80000000u) ? 1 : 0;
    left = fixed_mul(shar32(tdy, 8), shar32(dx, 8));
    right = fixed_mul(shar32(dy, 8), shar32(tdx, 8));
    return right < left ? 0 : 1;
}

/* Harbour P_CheckSight side: >>16 products, no sign-xor shortcut. */
static int sight_side(int x, int y, int lx, int ly, int ldx, int ldy)
{
    long long dx;
    long long dy;
    long long left;
    long long right;

    if (ldx == 0) {
        if (x == lx)
            return 2;
        if (x <= lx)
            return ldy > 0 ? 1 : 0;
        return ldy < 0 ? 1 : 0;
    }
    if (ldy == 0) {
        /* Vanilla P_DivlineSide compares x to ly when dy == 0. */
        if (x == ly)
            return 2;
        if (y <= ly)
            return ldx < 0 ? 1 : 0;
        return ldx > 0 ? 1 : 0;
    }
    dx = ((long long)x - lx) >> 16;
    dy = ((long long)y - ly) >> 16;
    left = ((long long)(ldy >> 16)) * dx;
    right = dy * (long long)(ldx >> 16);
    if (right < left)
        return 0;
    if (left == right)
        return 2;
    return 1;
}

/* 1 if the sight segment crosses the linedef. Frac is along the sight. */
int sight_frac(int ox, int oy, int tx, int ty,
    int v1x, int v1y, int v2x, int v2y)
{
    int tdx = as_i32((long long)tx - ox);
    int tdy = as_i32((long long)ty - oy);
    int ldx = as_i32((long long)v2x - v1x);
    int ldy = as_i32((long long)v2y - v1y);
    int s1;
    int s2;
    int den;
    int num;
    int frac;

    s1 = sight_side(v1x, v1y, ox, oy, tdx, tdy);
    s2 = sight_side(v2x, v2y, ox, oy, tdx, tdy);
    if (s1 == s2)
        return -1;
    s1 = sight_side(ox, oy, v1x, v1y, ldx, ldy);
    s2 = sight_side(tx, ty, v1x, v1y, ldx, ldy);
    if (s1 == s2)
        return -1;
    den = as_i32((long long)fixed_mul(shar32(ldy, 8), tdx)
        - (long long)fixed_mul(shar32(ldx, 8), tdy));
    if (den == 0)
        return 1;
    num = as_i32((long long)fixed_mul(shar32(as_i32((long long)v1x - ox), 8), ldy)
        + (long long)fixed_mul(shar32(as_i32((long long)oy - v1y), 8), ldx));
    frac = fixed_div(num, den);
    if (frac <= 0 || frac >= 65536)
        return 1;
    return frac;
}

static int trace_frac_mode(int ox, int oy, int tdx, int tdy,
    int v1x, int v1y, int v2x, int v2y, int short_side)
{
    /* P_InterceptVector. short_side is P_AddLineIntercepts' 16-unit test,
     * used by the player slide so linedef 0 in every blockmap list counts. */
    int ldx = as_i32((int64_t)v2x - v1x);
    int ldy = as_i32((int64_t)v2y - v1y);
    int den;
    int num;
    int frac;
    int s1;
    int s2;

    if (short_side
        && tdx <= 1048576 && tdy <= 1048576
        && tdx >= -1048576 && tdy >= -1048576) {
        s1 = line_point_side(ox, oy, v1x, v1y, ldx, ldy);
        s2 = line_point_side(as_i32((int64_t)ox + tdx),
            as_i32((int64_t)oy + tdy), v1x, v1y, ldx, ldy);
    } else {
        s1 = divline_side(ox, oy, tdx, tdy, v1x, v1y);
        s2 = divline_side(ox, oy, tdx, tdy, v2x, v2y);
    }
    if (s1 == s2)
        return -1;

    den = as_i32((int64_t)fixed_mul(shar32(ldy, 8), tdx)
        - (int64_t)fixed_mul(shar32(ldx, 8), tdy));
    if (den == 0) {
        /* P_InterceptVector returns 0 when the >>8 cross product vanishes.
         * On a step under 16 units that still changes sides, that is a
         * touch (frac 0), not a miss. Hitscan keeps the miss. */
        if (short_side
            && tdx <= 1048576 && tdy <= 1048576
            && tdx >= -1048576 && tdy >= -1048576)
            return 0;
        return -1;
    }
    num = as_i32((int64_t)fixed_mul(shar32(as_i32((int64_t)v1x - ox), 8), ldy)
        + (int64_t)fixed_mul(shar32(as_i32((int64_t)oy - v1y), 8), ldx));
    frac = fixed_div(num, den);
    if (frac < 0 || frac > 65536)
        return -1;
    return frac;
}

int trace_frac(int ox, int oy, int tdx, int tdy,
    int v1x, int v1y, int v2x, int v2y)
{
    return trace_frac_mode(ox, oy, tdx, tdy, v1x, v1y, v2x, v2y, 0);
}

int slide_frac(int ox, int oy, int tdx, int tdy,
    int v1x, int v1y, int v2x, int v2y)
{
    return trace_frac_mode(ox, oy, tdx, tdy, v1x, v1y, v2x, v2y, 1);
}

int point_to_angle(int x1, int y1, int x2, int y2)
{
    static int tanto[2049];
    static int ready;
    int dx;
    int dy;
    int idx;
    int ang90;
    int ang180;
    int ang270;

    if (!ready) {
        build_tantoangle(tanto, 2049);
        ready = 1;
    }
    dx = as_i32((long long)x2 - (long long)x1);
    dy = as_i32((long long)y2 - (long long)y1);
    if (dx == 0 && dy == 0)
        return 0;
    ang90 = 1073741824;
    ang180 = (int)0x80000000;
    ang270 = -1073741824;
    if (dx >= 0) {
        if (dy >= 0) {
            if (dx > dy) {
                idx = slope_div_i(dy, dx);
                return tanto[idx];
            }
            idx = slope_div_i(dx, dy);
            return as_i32((long long)(ang90 - 1) - tanto[idx]);
        }
        dy = as_i32(0LL - (long long)dy);
        if (dx > dy) {
            idx = slope_div_i(dy, dx);
            return as_i32(0LL - (long long)tanto[idx]);
        }
        idx = slope_div_i(dx, dy);
        return add_i32(ang270, tanto[idx]);
    }
    dx = as_i32(0LL - (long long)dx);
    if (dy >= 0) {
        if (dx > dy) {
            idx = slope_div_i(dy, dx);
            return as_i32((long long)(ang180 - 1) - tanto[idx]);
        }
        idx = slope_div_i(dx, dy);
        return add_i32(ang90, tanto[idx]);
    }
    dy = as_i32(0LL - (long long)dy);
    if (dx > dy) {
        idx = slope_div_i(dy, dx);
        return add_i32(ang180, tanto[idx]);
    }
    idx = slope_div_i(dx, dy);
    return as_i32((long long)(ang270 - 1) - tanto[idx]);
}

/* P_HitSlideLine — same math as node_doom Collision.hitSlideLine. */
void hit_slide_line(int px, int py, int v1x, int v1y, int ldx, int ldy,
    int tmx, int tmy, int *out_mx, int *out_my)
{
    int side;
    int lineang;
    unsigned delta;
    int dx;
    int dy;
    int newlen;
    int left;
    int right;

    if (out_mx == NULL || out_my == NULL)
        return;
    if (ldy == 0) {
        *out_mx = tmx;
        *out_my = 0;
        return;
    }
    if (ldx == 0) {
        *out_mx = 0;
        *out_my = tmy;
        return;
    }
    dx = as_i32((int64_t)px - v1x);
    dy = as_i32((int64_t)py - v1y);
    left = fixed_mul(ldy >> 16, dx);
    right = fixed_mul(dy, ldx >> 16);
    side = (right < left) ? 0 : 1;
    lineang = point_to_angle(0, 0, ldx, ldy);
    if (side == 1)
        lineang = (int)((unsigned)lineang + 0x80000000u);
    delta = (unsigned)as_i32((int64_t)point_to_angle(0, 0, tmx, tmy) - lineang);
    if (delta > 0x80000000u)
        delta += 0x80000000u;
    dx = abs_fixed_i(tmx);
    dy = abs_fixed_i(tmy);
    if (dx < dy)
        newlen = dx + dy - (dx >> 1);
    else
        newlen = dx + dy - (dy >> 1);
    newlen = fixed_mul(newlen, fine_cos_ang((int)delta));
    *out_mx = fixed_mul(newlen, fine_cos_ang(lineang));
    *out_my = fixed_mul(newlen, fine_sin_ang(lineang));
}

/* True if a thing overlapping blockmap cells would be visited by vanilla
 * P_PathTraverse DDA from (ox,oy) along (tdx,tdy). */
int thing_on_trace(int ox, int oy, int tdx, int tdy,
    int orgx, int orgy, int bw, int bh,
    int tx, int ty, int rad)
{
    const int MAPBLOCKSHIFT = 23;
    const int MAPBTOFRAC = 7;
    const int FRACBITS = 16;
    const int FRACUNIT = 65536;
    const int MAPBLOCKSIZE = 128 * FRACUNIT;
    int x1 = ox;
    int y1 = oy;
    int x2 = as_i32((int64_t)ox + tdx);
    int y2 = as_i32((int64_t)oy + tdy);
    int x2m, y2m;
    int xt1, yt1, xt2, yt2;
    int mapxstep, mapystep, partial, ystep, xstep;
    int yintercept, xintercept;
    int mapx, mapy;
    int count;
    int xl, xh, yl, yh;

    if (bw < 1 || bh < 1)
        return 1;
    /* Probe: require centre block on DDA, not full radius footprint.
     * Radius overlap was false-hitting BAR1 for rays Node never links. */
    xl = xh = shar32(as_i32((int64_t)tx - orgx), MAPBLOCKSHIFT);
    yl = yh = shar32(as_i32((int64_t)ty - orgy), MAPBLOCKSHIFT);
    (void)rad;
    if ((as_i32((int64_t)x1 - orgx) & (MAPBLOCKSIZE - 1)) == 0)
        x1 = as_i32((int64_t)x1 + FRACUNIT);
    if ((as_i32((int64_t)y1 - orgy) & (MAPBLOCKSIZE - 1)) == 0)
        y1 = as_i32((int64_t)y1 + FRACUNIT);
    x1 = as_i32((int64_t)x1 - orgx);
    y1 = as_i32((int64_t)y1 - orgy);
    x2m = as_i32((int64_t)x2 - orgx);
    y2m = as_i32((int64_t)y2 - orgy);
    xt1 = shar32(x1, MAPBLOCKSHIFT);
    yt1 = shar32(y1, MAPBLOCKSHIFT);
    xt2 = shar32(x2m, MAPBLOCKSHIFT);
    yt2 = shar32(y2m, MAPBLOCKSHIFT);
    if (xt2 > xt1) {
        mapxstep = 1;
        partial = FRACUNIT - (shar32(x1, MAPBTOFRAC) & (FRACUNIT - 1));
        ystep = fixed_div(as_i32((int64_t)y2m - y1),
            abs_fixed_i(as_i32((int64_t)x2m - x1)));
    } else if (xt2 < xt1) {
        mapxstep = -1;
        partial = shar32(x1, MAPBTOFRAC) & (FRACUNIT - 1);
        ystep = fixed_div(as_i32((int64_t)y2m - y1),
            abs_fixed_i(as_i32((int64_t)x2m - x1)));
    } else {
        mapxstep = 0;
        partial = FRACUNIT;
        ystep = 256 * FRACUNIT;
    }
    yintercept = as_i32((int64_t)shar32(y1, MAPBTOFRAC)
        + (int64_t)fixed_mul(partial, ystep));
    if (yt2 > yt1) {
        mapystep = 1;
        partial = FRACUNIT - (shar32(y1, MAPBTOFRAC) & (FRACUNIT - 1));
        xstep = fixed_div(as_i32((int64_t)x2m - x1),
            abs_fixed_i(as_i32((int64_t)y2m - y1)));
    } else if (yt2 < yt1) {
        mapystep = -1;
        partial = shar32(y1, MAPBTOFRAC) & (FRACUNIT - 1);
        xstep = fixed_div(as_i32((int64_t)x2m - x1),
            abs_fixed_i(as_i32((int64_t)y2m - y1)));
    } else {
        mapystep = 0;
        partial = FRACUNIT;
        xstep = 256 * FRACUNIT;
    }
    xintercept = as_i32((int64_t)shar32(x1, MAPBTOFRAC)
        + (int64_t)fixed_mul(partial, xstep));
    mapx = xt1;
    mapy = yt1;
    for (count = 0; count < 64; count++) {
        if (mapx >= xl && mapx <= xh && mapy >= yl && mapy <= yh
            && mapx >= 0 && mapy >= 0 && mapx < bw && mapy < bh)
            return 1;
        if (mapx == xt2 && mapy == yt2)
            break;
        if (shar32(yintercept, FRACBITS) == mapy) {
            yintercept = as_i32((int64_t)yintercept + ystep);
            mapx += mapxstep;
        } else if (shar32(xintercept, FRACBITS) == mapx) {
            xintercept = as_i32((int64_t)xintercept + xstep);
            mapy += mapystep;
        }
    }
    return 0;
}

/* Blocks the vanilla P_PathTraverse DDA visits, plus the nudged trace.
 * xy holds mapx,mapy pairs. The nudge is the block-edge +FRACUNIT. */
int slide_dda(int x1, int y1, int x2, int y2, int orgx, int orgy,
    int *n_out, int *xy, int *ox, int *oy, int *dx, int *dy)
{
    const int FRACUNIT = 65536;
    const int MAPBLOCKSHIFT = 23;
    const int MAPBTOFRAC = 7;
    const int MAPBLOCKSIZE = 128 * FRACUNIT;
    int rel;
    int dxv;
    int dyv;
    int sx;
    int sy;
    int x2m;
    int y2m;
    int xt1;
    int yt1;
    int xt2;
    int yt2;
    int mapxstep;
    int mapystep;
    int partial;
    int ystep;
    int xstep;
    int yintercept;
    int xintercept;
    int mapx;
    int mapy;
    int count;
    int n;

    if (n_out != NULL)
        *n_out = 0;
    rel = as_i32((int64_t)x1 - orgx);
    if ((rel & (MAPBLOCKSIZE - 1)) == 0)
        x1 = as_i32((int64_t)x1 + FRACUNIT);
    rel = as_i32((int64_t)y1 - orgy);
    if ((rel & (MAPBLOCKSIZE - 1)) == 0)
        y1 = as_i32((int64_t)y1 + FRACUNIT);
    dxv = as_i32((int64_t)x2 - x1);
    dyv = as_i32((int64_t)y2 - y1);
    if (ox != NULL)
        *ox = x1;
    if (oy != NULL)
        *oy = y1;
    if (dx != NULL)
        *dx = dxv;
    if (dy != NULL)
        *dy = dyv;
    if (xy == NULL)
        return 0;
    sx = as_i32((int64_t)x1 - orgx);
    sy = as_i32((int64_t)y1 - orgy);
    xt1 = shar32(sx, MAPBLOCKSHIFT);
    yt1 = shar32(sy, MAPBLOCKSHIFT);
    x2m = as_i32((int64_t)x2 - orgx);
    y2m = as_i32((int64_t)y2 - orgy);
    xt2 = shar32(x2m, MAPBLOCKSHIFT);
    yt2 = shar32(y2m, MAPBLOCKSHIFT);
    if (xt2 > xt1) {
        mapxstep = 1;
        partial = FRACUNIT - (shar32(sx, MAPBTOFRAC) & (FRACUNIT - 1));
        ystep = fixed_div(as_i32((int64_t)y2m - sy),
            abs_fixed_i(as_i32((int64_t)x2m - sx)));
    } else if (xt2 < xt1) {
        mapxstep = -1;
        partial = shar32(sx, MAPBTOFRAC) & (FRACUNIT - 1);
        ystep = fixed_div(as_i32((int64_t)y2m - sy),
            abs_fixed_i(as_i32((int64_t)x2m - sx)));
    } else {
        mapxstep = 0;
        partial = FRACUNIT;
        ystep = 256 * FRACUNIT;
    }
    yintercept = as_i32((int64_t)shar32(sy, MAPBTOFRAC) + fixed_mul(partial, ystep));
    if (yt2 > yt1) {
        mapystep = 1;
        partial = FRACUNIT - (shar32(sy, MAPBTOFRAC) & (FRACUNIT - 1));
        xstep = fixed_div(as_i32((int64_t)x2m - sx),
            abs_fixed_i(as_i32((int64_t)y2m - sy)));
    } else if (yt2 < yt1) {
        mapystep = -1;
        partial = shar32(sy, MAPBTOFRAC) & (FRACUNIT - 1);
        xstep = fixed_div(as_i32((int64_t)x2m - sx),
            abs_fixed_i(as_i32((int64_t)y2m - sy)));
    } else {
        mapystep = 0;
        partial = FRACUNIT;
        xstep = 256 * FRACUNIT;
    }
    xintercept = as_i32((int64_t)shar32(sx, MAPBTOFRAC) + fixed_mul(partial, xstep));
    mapx = xt1;
    mapy = yt1;
    n = 0;
    for (count = 0; count < 64; count++) {
        if (n < 64) {
            xy[n * 2] = mapx;
            xy[n * 2 + 1] = mapy;
            n++;
        }
        if (mapx == xt2 && mapy == yt2)
            break;
        if (shar32(yintercept, 16) == mapy) {
            yintercept = as_i32((int64_t)yintercept + ystep);
            mapx += mapxstep;
        } else if (shar32(xintercept, 16) == mapx) {
            xintercept = as_i32((int64_t)xintercept + xstep);
            mapy += mapystep;
        }
    }
    if (n_out != NULL)
        *n_out = n;
    return n;
}

int compat_self_check(void)
{
    if (as_i32(0x80000000LL) != (int32_t)0x80000000)
        return 1;
    if (as_u32(-1) != 0xFFFFFFFFu)
        return 2;
    if (fixed_mul(65536, 65536) != 65536)
        return 3;
    if (fixed_mul(32768, 32768) != 16384)
        return 4;
    if (fixed_mul(-65536, 65536) != -65536)
        return 5;
    if (fixed_div(128, 65536) != 128)
        return 6;
    if (fixed_div(256, 0) != 0x7FFFFFFF)
        return 7;
    if (ushr32(0x80000000LL, 1) != 0x40000000u)
        return 8;
    if (shar32((int32_t)0x80000000, 1) != (int32_t)0xC0000000)
        return 9;
    return 0;
}
