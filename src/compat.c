/* DOOM generic portado do python_doom para COBOL com SDL2.

   Por Wagner Nunes da Silva

   vagucs@bol.com.br
   vagucs@vagucs.com.br
   vagucs@gmail.com

   www.vagucs.com.br

   Estouro de 32 bits e ponto fixo 16.16, iguais a doom/compat.py.
   A divisao decimal do COBOL nao reproduz o deslocamento. */

#include <math.h>
#include <stdint.h>

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

int point_side(int nodex, int nodey, int nodedx, int nodedy, int x, int y)
{
    int dx;
    int dy;
    int sdx;
    int sdy;
    long long left;
    long long right;

    dx = as_i32((long long)x - nodex);
    dy = as_i32((long long)y - nodey);
    sdx = nodedx >> 16;
    sdy = nodedy >> 16;
    left = (long long)sdy * (long long)dx;
    right = (long long)dy * (long long)sdx;
    return right >= left ? 1 : 0;
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

static int ang_sine[8192];
static int ang_sine_ready;

void build_finesine(int *dst, int n);

static void ensure_ang_sine(void)
{
    if (ang_sine_ready)
        return;
    build_finesine(ang_sine, 8192);
    ang_sine_ready = 1;
}

int fine_sin_ang(int angle)
{
    unsigned u;

    ensure_ang_sine();
    u = (unsigned)angle;
    return ang_sine[(u >> 19) & 8191u];
}

int fine_cos_ang(int angle)
{
    unsigned u;

    ensure_ang_sine();
    u = (unsigned)angle;
    return ang_sine[((u >> 19) + 2048u) & 8191u];
}

void build_finesine(int *dst, int n)
{
    int i;
    double a;

    for (i = 0; i < n; i++) {
        a = ((double)i + 0.5) * 3.14159265358979323846 * 2.0 / 8192.0;
        dst[i] = (int)(65536.0 * sin(a));
    }
}

void build_finetangent(int *dst, int n)
{
    int i;
    double a;
    double v;

    for (i = 0; i < n; i++) {
        a = ((double)i - 2048.0 + 0.5) * 3.14159265358979323846 * 2.0 / 8192.0;
        v = 65536.0 * tan(a);
        if (v > 2147483647.0)
            v = 2147483647.0;
        if (v < -2147483647.0)
            v = -2147483647.0;
        dst[i] = (int)v;
    }
}

void build_tantoangle(int *dst, int n)
{
    int i;
    double v;

    for (i = 0; i < n; i++) {
        v = atan((double)i / 2048.0) / (3.14159265358979323846 * 2.0) * 4294967295.0;
        if (v < 0.0)
            v = 0.0;
        if (v > 2147483647.0)
            v = 2147483647.0;
        dst[i] = (int)v;
    }
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

int trace_frac(int ox, int oy, int tdx, int tdy,
    int v1x, int v1y, int v2x, int v2y)
{
    int64_t c1;
    int64_t c2;
    int64_t ldx;
    int64_t ldy;
    int64_t den;
    int64_t num;
    __int128 q;

    c1 = ((int64_t)v1x - ox) * tdy - ((int64_t)v1y - oy) * tdx;
    c2 = ((int64_t)v2x - ox) * tdy - ((int64_t)v2y - oy) * tdx;
    if ((c1 < 0 && c2 < 0) || (c1 > 0 && c2 > 0))
        return -1;
    ldx = (int64_t)v2x - v1x;
    ldy = (int64_t)v2y - v1y;
    den = (int64_t)tdx * ldy - (int64_t)tdy * ldx;
    if (den == 0)
        return -1;
    num = ((int64_t)v1x - ox) * ldy - ((int64_t)v1y - oy) * ldx;
    q = ((__int128)num << 16) / den;
    if (q <= 0 || q > 65536)
        return -1;
    return (int)q;
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
