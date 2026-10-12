/* DOOM generic portado do python_doom para COBOL com SDL2.

   Por Wagner Nunes da Silva

   vagucs@bol.com.br
   vagucs@vagucs.com.br
   vagucs@gmail.com

   www.vagucs.com.br

   Ponte de audio. Abre o dispositivo, decodifica o lump DS e mistura
   ate 8 vozes. Qual som toca, e quando, fica no COBOL. */

#define SDL_MAIN_HANDLED
#include <SDL.h>

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <mmsystem.h>

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void music_stop(void);

#define VOICES 8
#define CACHE 64

typedef struct {
    char name[8];
    int16_t *pcm;
    int n;
} clip_t;

typedef struct {
    clip_t *clip;
    int pos;
    int on;
} voice_t;

static SDL_AudioDeviceID dev = 0;
static clip_t cache[CACHE];
static voice_t voices[VOICES];

static int16_t *decode_dmx(const unsigned char *data, int len, int *out_n)
{
    unsigned rate;
    unsigned slen;
    unsigned usable;
    unsigned on;
    unsigned i;
    unsigned o;
    int16_t *pcm;

    if (data == NULL || len < 16 || data[0] != 3)
        return NULL;
    rate = (unsigned)data[2] | ((unsigned)data[3] << 8);
    slen = (unsigned)data[4] | ((unsigned)data[5] << 8)
        | ((unsigned)data[6] << 16) | ((unsigned)data[7] << 24);
    if (rate < 1000 || rate > 48000)
        return NULL;
    if (slen <= 48 || slen > (unsigned)(len - 8))
        return NULL;
    usable = slen - 32;
    if (16u + usable > (unsigned)len)
        return NULL;
    if (usable > 200000u)
        usable = 200000u;
    if (rate == 11025u)
        on = usable;
    else {
        on = (unsigned)(((uint64_t)usable * 11025u) / rate);
        if (on < 1u)
            on = 1u;
        if (on > 200000u)
            on = 200000u;
    }
    pcm = (int16_t *)malloc((size_t)on * sizeof(int16_t));
    if (pcm == NULL)
        return NULL;
    for (i = 0; i < on; i++) {
        if (rate == 11025u)
            o = i;
        else {
            o = (unsigned)(((uint64_t)i * rate) / 11025u);
            if (o >= usable)
                o = usable - 1u;
        }
        pcm[i] = (int16_t)((((int)data[16 + o]) - 128) << 8);
    }
    *out_n = (int)on;
    return pcm;
}

static clip_t *take_clip(const unsigned char *data, int len, const char *name)
{
    int i;
    int free_i;
    int n;
    int16_t *pcm;

    free_i = -1;
    for (i = 0; i < CACHE; i++) {
        if (cache[i].pcm == NULL) {
            if (free_i < 0)
                free_i = i;
            continue;
        }
        if (memcmp(cache[i].name, name, 8) == 0)
            return &cache[i];
    }
    if (free_i < 0)
        return NULL;
    pcm = decode_dmx(data, len, &n);
    if (pcm == NULL)
        return NULL;
    memcpy(cache[free_i].name, name, 8);
    cache[free_i].pcm = pcm;
    cache[free_i].n = n;
    return &cache[free_i];
}

static void mix_cb(void *ud, Uint8 *stream, int len)
{
    int frames;
    int i;
    int v;
    int acc;
    int16_t *out;

    (void)ud;
    frames = len / 2;
    out = (int16_t *)stream;
    memset(stream, 0, (size_t)len);
    for (i = 0; i < frames; i++) {
        acc = 0;
        for (v = 0; v < VOICES; v++) {
            if (!voices[v].on || voices[v].clip == NULL)
                continue;
            if (voices[v].pos >= voices[v].clip->n) {
                voices[v].on = 0;
                continue;
            }
            acc += ((int)voices[v].clip->pcm[voices[v].pos++]) * 8 / 15;
        }
        if (acc > 32767)
            acc = 32767;
        if (acc < -32768)
            acc = -32768;
        out[i] = (int16_t)acc;
    }
}

int audio_init(void)
{
    SDL_AudioSpec want;

    if (dev != 0)
        return 0;
    if (SDL_InitSubSystem(SDL_INIT_AUDIO) != 0)
        return 1;
    SDL_zero(want);
    want.freq = 11025;
    want.format = AUDIO_S16SYS;
    want.channels = 1;
    want.samples = 1024;
    want.callback = mix_cb;
    dev = SDL_OpenAudioDevice(NULL, 0, &want, NULL, 0);
    if (dev == 0)
        return 1;
    SDL_PauseAudioDevice(dev, 0);
    return 0;
}

void audio_shutdown(void)
{
    int i;

    music_stop();
    if (dev != 0) {
        SDL_CloseAudioDevice(dev);
        dev = 0;
    }
    for (i = 0; i < CACHE; i++) {
        free(cache[i].pcm);
        cache[i].pcm = NULL;
        cache[i].n = 0;
    }
    for (i = 0; i < VOICES; i++)
        voices[i].on = 0;
    SDL_QuitSubSystem(SDL_INIT_AUDIO);
}

int audio_play(unsigned char *data, int len, char *name)
{
    clip_t *clip;
    int i;
    int slot;
    int best;
    int left;
    int best_left;

    if (dev == 0 || data == NULL || name == NULL || len < 16)
        return 0;
    SDL_LockAudioDevice(dev);
    clip = take_clip(data, len, name);
    if (clip == NULL) {
        SDL_UnlockAudioDevice(dev);
        return 0;
    }
    slot = -1;
    best = 0;
    best_left = 0x7fffffff;
    for (i = 0; i < VOICES; i++) {
        if (!voices[i].on) {
            slot = i;
            break;
        }
        left = 0;
        if (voices[i].clip != NULL)
            left = voices[i].clip->n - voices[i].pos;
        if (left < best_left) {
            best_left = left;
            best = i;
        }
    }
    if (slot < 0)
        slot = best;
    voices[slot].clip = clip;
    voices[slot].pos = 0;
    voices[slot].on = 1;
    SDL_UnlockAudioDevice(dev);
    return 0;
}

#define MID_MAX 262144

static unsigned char mid_buf[MID_MAX];
static int mid_n;
static int mid_ok;
static int queued;
static int tracksize;
static int velocities[16];
static int channel_map[16];
static char music_path[MAX_PATH];
static char music_name[8];
static int music_on;
static int music_loop;

static const int controller_map[15] = {
    0x00, 0x20, 0x01, 0x07, 0x0A, 0x0B, 0x5B, 0x5D,
    0x40, 0x43, 0x78, 0x7B, 0x7E, 0x7F, 0x79
};

static void mid_byte(int b)
{
    if (mid_n >= MID_MAX) {
        mid_ok = 0;
        return;
    }
    mid_buf[mid_n++] = (unsigned char)b;
}

static void write_time(int time)
{
    uint64_t buffer;
    unsigned t;

    buffer = (unsigned)time & 0x7Fu;
    t = (unsigned)time;
    while ((t >>= 7) != 0) {
        buffer <<= 8;
        buffer |= (uint64_t)((t & 0x7Fu) | 0x80u);
    }
    for (;;) {
        mid_byte((int)(buffer & 0xFFu));
        tracksize++;
        if (buffer & 0x80u)
            buffer >>= 8;
        else {
            queued = 0;
            return;
        }
    }
}

static void write_ev(const unsigned char *p, int n)
{
    int i;

    write_time(queued);
    for (i = 0; i < n; i++)
        mid_byte(p[i]);
    tracksize += n;
}

static int alloc_channel(void)
{
    int i;
    int result;

    result = -1;
    for (i = 0; i < 16; i++) {
        if (channel_map[i] > result)
            result = channel_map[i];
    }
    result += 1;
    if (result == 9)
        result += 1;
    return result;
}

static int midi_channel(int mus_ch)
{
    unsigned char ev[3];

    if (mus_ch == 15)
        return 9;
    if (channel_map[mus_ch] == -1) {
        channel_map[mus_ch] = alloc_channel();
        ev[0] = (unsigned char)(0xB0 | channel_map[mus_ch]);
        ev[1] = 0x7B;
        ev[2] = 0;
        write_ev(ev, 3);
    }
    return channel_map[mus_ch];
}

static int mus_to_mid(const unsigned char *data, int len)
{
    static const unsigned char hdr[18] = {
        0x4D, 0x54, 0x68, 0x64, 0x00, 0x00, 0x00, 0x06,
        0x00, 0x00, 0x00, 0x01, 0x00, 0x46,
        0x4D, 0x54, 0x72, 0x6B
    };
    int i;
    int pos;
    int scorestart;
    int hitscoreend;
    int descriptor;
    int channel;
    int event;
    int key;
    int val;
    int timedelay;
    int working;
    unsigned char ev[3];

    if (data == NULL || len < 4)
        return 0;
    if (data[0] == 'M' && data[1] == 'T' && data[2] == 'h' && data[3] == 'd') {
        if (len > MID_MAX)
            return 0;
        memcpy(mid_buf, data, (size_t)len);
        return len;
    }
    if (len < 16 || data[0] != 'M' || data[1] != 'U'
        || data[2] != 'S' || data[3] != 0x1a)
        return 0;
    scorestart = data[6] | (data[7] << 8);
    if (scorestart < 0 || scorestart >= len)
        return 0;
    mid_n = 22;
    mid_ok = 1;
    queued = 0;
    tracksize = 0;
    for (i = 0; i < 16; i++) {
        velocities[i] = 127;
        channel_map[i] = -1;
    }
    pos = scorestart;
    hitscoreend = 0;
    while (!hitscoreend) {
        while (!hitscoreend) {
            if (pos >= len)
                return 0;
            descriptor = data[pos++];
            channel = midi_channel(descriptor & 0x0F);
            event = descriptor & 0x70;
            if (event == 0x00) {
                if (pos >= len)
                    return 0;
                key = data[pos++];
                ev[0] = (unsigned char)(0x80 | channel);
                ev[1] = (unsigned char)(key & 0x7F);
                ev[2] = 0;
                write_ev(ev, 3);
            } else if (event == 0x10) {
                if (pos >= len)
                    return 0;
                key = data[pos++];
                if (key & 0x80) {
                    if (pos >= len)
                        return 0;
                    velocities[channel] = data[pos++] & 0x7F;
                }
                ev[0] = (unsigned char)(0x90 | channel);
                ev[1] = (unsigned char)(key & 0x7F);
                ev[2] = (unsigned char)velocities[channel];
                write_ev(ev, 3);
            } else if (event == 0x20) {
                if (pos >= len)
                    break;
                key = data[pos++];
                val = key * 64;
                ev[0] = (unsigned char)(0xE0 | channel);
                ev[1] = (unsigned char)(val & 0x7F);
                ev[2] = (unsigned char)((val >> 7) & 0x7F);
                write_ev(ev, 3);
            } else if (event == 0x30) {
                if (pos >= len)
                    return 0;
                key = data[pos++];
                if (key < 10 || key > 14)
                    return 0;
                ev[0] = (unsigned char)(0xB0 | channel);
                ev[1] = (unsigned char)controller_map[key];
                ev[2] = 0;
                write_ev(ev, 3);
            } else if (event == 0x40) {
                if (pos + 1 >= len)
                    return 0;
                key = data[pos++];
                val = data[pos++];
                if (key == 0) {
                    ev[0] = (unsigned char)(0xC0 | channel);
                    ev[1] = (unsigned char)(val & 0x7F);
                    write_ev(ev, 2);
                } else {
                    if (key < 1 || key > 9)
                        return 0;
                    working = (val & 0x80) ? 0x7F : val;
                    ev[0] = (unsigned char)(0xB0 | channel);
                    ev[1] = (unsigned char)controller_map[key];
                    ev[2] = (unsigned char)working;
                    write_ev(ev, 3);
                }
            } else if (event == 0x60) {
                hitscoreend = 1;
            } else {
                return 0;
            }
            if (!mid_ok)
                return 0;
            if (descriptor & 0x80)
                break;
        }
        if (!hitscoreend) {
            timedelay = 0;
            for (;;) {
                if (pos >= len)
                    return 0;
                working = data[pos++];
                timedelay = timedelay * 128 + (working & 0x7F);
                if ((working & 0x80) == 0)
                    break;
            }
            queued += timedelay;
        }
    }
    write_time(queued);
    mid_byte(0xFF);
    mid_byte(0x2F);
    mid_byte(0x00);
    tracksize += 3;
    if (!mid_ok || mid_n < 22)
        return 0;
    memcpy(mid_buf, hdr, 18);
    mid_buf[18] = (unsigned char)((tracksize >> 24) & 0xFF);
    mid_buf[19] = (unsigned char)((tracksize >> 16) & 0xFF);
    mid_buf[20] = (unsigned char)((tracksize >> 8) & 0xFF);
    mid_buf[21] = (unsigned char)(tracksize & 0xFF);
    return mid_n;
}

static int mci_fail(const char *cmd)
{
    return mciSendStringA(cmd, NULL, 0, NULL) != 0;
}

static void music_stop(void)
{
    mciSendStringA("close doommus", NULL, 0, NULL);
    music_on = 0;
    music_loop = 0;
    memset(music_name, 0, sizeof(music_name));
}

static int music_open(void)
{
    char cmd[MAX_PATH + 80];

    mciSendStringA("close doommus", NULL, 0, NULL);
    snprintf(cmd, sizeof(cmd),
        "open \"%s\" type sequencer alias doommus", music_path);
    if (mci_fail(cmd)) {
        snprintf(cmd, sizeof(cmd), "open \"%s\" alias doommus", music_path);
        if (mci_fail(cmd))
            return 0;
    }
    if (mci_fail("play doommus from 0"))
        return 0;
    mciSendStringA("setaudio doommus volume to 533", NULL, 0, NULL);
    return 1;
}

int music_play(unsigned char *data, int len, int loop, char *name)
{
    char dir[MAX_PATH];
    int n;
    FILE *out;

    if (data == NULL || name == NULL || len < 4)
        return 0;
    if (music_on && memcmp(music_name, name, 8) == 0)
        return 0;
    n = mus_to_mid(data, len);
    if (n < 22)
        return 0;
    if (GetTempPathA(MAX_PATH, dir) == 0)
        return 0;
    snprintf(music_path, sizeof(music_path), "%sdoommus.mid", dir);
    music_stop();
    out = fopen(music_path, "wb");
    if (out == NULL)
        return 0;
    if (fwrite(mid_buf, 1, (size_t)n, out) != (size_t)n) {
        fclose(out);
        return 0;
    }
    fclose(out);
    if (!music_open()) {
        music_on = 0;
        return 0;
    }
    memcpy(music_name, name, 8);
    music_loop = loop ? 1 : 0;
    music_on = 1;
    return 0;
}

void music_pump(void)
{
    char buf[64];

    if (!music_on || !music_loop)
        return;
    buf[0] = 0;
    if (mciSendStringA("status doommus mode", buf, sizeof(buf), NULL) != 0)
        return;
    if (strncmp(buf, "playing", 7) != 0)
        mciSendStringA("play doommus from 0", NULL, 0, NULL);
}
