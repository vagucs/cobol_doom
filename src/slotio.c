/* DOOM generic portado do python_doom para COBOL com SDL2.

   Por Wagner Nunes da Silva

   vagucs@bol.com.br
   vagucs@vagucs.com.br
   vagucs@gmail.com

   www.vagucs.com.br

   Arquivo dos seis slots de save. O COBOL monta o texto. */

#include <stdio.h>
#include <string.h>

static FILE *slot_fp;

static void copy_path(char *dst, int dstn, const char *src, int n)
{
    int i;
    int m;

    if (dstn < 2)
        return;
    m = n;
    if (m > dstn - 1)
        m = dstn - 1;
    while (m > 0 && (src[m - 1] == ' ' || src[m - 1] == '\0'))
        m--;
    for (i = 0; i < m; i++)
        dst[i] = src[i];
    dst[m] = '\0';
}

int slot_wopen(char *path, int n)
{
    char name[300];

    copy_path(name, (int)sizeof name, path, n);
    if (slot_fp)
        fclose(slot_fp);
    slot_fp = fopen(name, "w");
    return slot_fp ? 0 : 1;
}

int slot_ropen(char *path, int n)
{
    char name[300];

    copy_path(name, (int)sizeof name, path, n);
    if (slot_fp)
        fclose(slot_fp);
    slot_fp = fopen(name, "r");
    return slot_fp ? 0 : 1;
}

void slot_close(void)
{
    if (slot_fp) {
        fclose(slot_fp);
        slot_fp = 0;
    }
}

int slot_wline(char *line, int n)
{
    int m;

    if (!slot_fp)
        return 1;
    m = n;
    while (m > 0 && (line[m - 1] == ' ' || line[m - 1] == '\0'))
        m--;
    if (m > 0)
        fwrite(line, 1, (size_t)m, slot_fp);
    fputc('\n', slot_fp);
    return 0;
}

int slot_rline(char *dst, int n)
{
    char tmp[1200];
    int m;
    int i;

    if (!slot_fp || n < 1)
        return 1;
    if (!fgets(tmp, (int)sizeof tmp, slot_fp))
        return 1;
    m = (int)strlen(tmp);
    while (m > 0 && (tmp[m - 1] == '\n' || tmp[m - 1] == '\r'))
        tmp[--m] = '\0';
    for (i = 0; i < n; i++)
        dst[i] = ' ';
    if (m > n)
        m = n;
    for (i = 0; i < m; i++)
        dst[i] = tmp[i];
    return 0;
}
