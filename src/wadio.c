/* DOOM generic portado do python_doom para COBOL com SDL2.

   Por Wagner Nunes da Silva

   vagucs@bol.com.br
   vagucs@vagucs.com.br
   vagucs@gmail.com

   www.vagucs.com.br

   Leitura binaria e caminhos. O diretorio do WAD fica no COBOL. */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>

static int cob_copy(const char *src, int src_len, char *dst, int dst_cap)
{
    int n;
    int i;

    if (src_len < 0)
        src_len = 0;
    n = src_len;
    if (n > dst_cap - 1)
        n = dst_cap - 1;
    for (i = 0; i < n; i++) {
        if (src[i] == '\0') {
            n = i;
            break;
        }
    }
    while (n > 0 && src[n - 1] == ' ')
        n--;
    memcpy(dst, src, (size_t)n);
    dst[n] = '\0';
    return n;
}

static void cob_pad(char *dst, int dst_len, const char *src)
{
    int n;

    n = (int)strlen(src);
    if (n > dst_len)
        n = dst_len;
    memset(dst, ' ', (size_t)dst_len);
    memcpy(dst, src, (size_t)n);
}

int file_exists(char *path, int path_len)
{
    char tmp[520];
    DWORD attr;

    cob_copy(path, path_len, tmp, (int)sizeof tmp);
    attr = GetFileAttributesA(tmp);
    if (attr == INVALID_FILE_ATTRIBUTES)
        return 0;
    if (attr & FILE_ATTRIBUTE_DIRECTORY)
        return 0;
    return 1;
}

int path_is_dir(char *path, int path_len)
{
    char tmp[520];
    DWORD attr;

    cob_copy(path, path_len, tmp, (int)sizeof tmp);
    attr = GetFileAttributesA(tmp);
    if (attr == INVALID_FILE_ATTRIBUTES)
        return 0;
    return (attr & FILE_ATTRIBUTE_DIRECTORY) ? 1 : 0;
}

int file_read(char *path, int path_len, int offset, int length, unsigned char *dest)
{
    char tmp[520];
    FILE *f;
    size_t got;

    if (offset < 0 || length < 0)
        return 1;
    cob_copy(path, path_len, tmp, (int)sizeof tmp);
    f = fopen(tmp, "rb");
    if (f == NULL)
        return 1;
    if (fseek(f, offset, SEEK_SET) != 0) {
        fclose(f);
        return 1;
    }
    got = fread(dest, 1, (size_t)length, f);
    fclose(f);
    return got == (size_t)length ? 0 : 1;
}

int cwd_get(char *out, int out_len)
{
    char tmp[520];
    DWORD n;

    n = GetCurrentDirectoryA((DWORD)sizeof tmp, tmp);
    if (n == 0 || n >= sizeof tmp)
        return 1;
    cob_pad(out, out_len, tmp);
    return 0;
}

int parent_dir(char *path, int path_len)
{
    char tmp[520];
    int n;
    int i;

    n = cob_copy(path, path_len, tmp, (int)sizeof tmp);
    while (n > 0 && (tmp[n - 1] == '\\' || tmp[n - 1] == '/'))
        n--;
    tmp[n] = '\0';
    i = n - 1;
    while (i >= 0 && tmp[i] != '\\' && tmp[i] != '/')
        i--;
    if (i < 0)
        return 1;
    if (i == 2 && tmp[1] == ':') {
        tmp[i + 1] = '\0';
    } else if (i == 0) {
        tmp[1] = '\0';
    } else {
        tmp[i] = '\0';
    }
    cob_pad(path, path_len, tmp);
    return 0;
}

int path_join(char *dir, int dir_len, char *name, int name_len, char *out, int out_len)
{
    char a[520];
    char b[64];
    char joined[600];
    int na;
    int nb;
    int slash;

    na = cob_copy(dir, dir_len, a, (int)sizeof a);
    nb = cob_copy(name, name_len, b, (int)sizeof b);
    slash = 1;
    if (na == 0)
        slash = 0;
    else if (a[na - 1] == '\\' || a[na - 1] == '/')
        slash = 0;
    if (na + slash + nb >= (int)sizeof joined)
        return 1;
    memcpy(joined, a, (size_t)na);
    if (slash)
        joined[na] = '\\';
    memcpy(joined + na + slash, b, (size_t)nb);
    joined[na + slash + nb] = '\0';
    cob_pad(out, out_len, joined);
    return 0;
}

int env_get(char *name, int name_len, char *out, int out_len)
{
    char key[64];
    char *value;

    cob_copy(name, name_len, key, (int)sizeof key);
    value = getenv(key);
    if (value == NULL || value[0] == '\0') {
        memset(out, ' ', (size_t)out_len);
        return 1;
    }
    cob_pad(out, out_len, value);
    return 0;
}

int byte_at(unsigned char *buf, int off)
{
    return buf[off];
}

void poke_byte(unsigned char *buf, int off, int value)
{
    buf[off] = (unsigned char)value;
}

int u16_le(unsigned char *buf, int off)
{
    return buf[off] | (buf[off + 1] << 8);
}

void mem_copy(unsigned char *dst, unsigned char *src, int n)
{
    if (n > 0)
        memcpy(dst, src, (size_t)n);
}

int i16_le(unsigned char *buf, int off)
{
    int v;

    v = buf[off] | (buf[off + 1] << 8);
    if (v >= 32768)
        v -= 65536;
    return v;
}

int u32_le(unsigned char *buf, int off)
{
    return (int)((unsigned int)buf[off]
        | ((unsigned int)buf[off + 1] << 8)
        | ((unsigned int)buf[off + 2] << 16)
        | ((unsigned int)buf[off + 3] << 24));
}
