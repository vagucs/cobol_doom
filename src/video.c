/* DOOM generic portado do python_doom para COBOL com SDL3.

   Por Wagner Nunes da Silva

   vagucs@bol.com.br
   vagucs@vagucs.com.br
   vagucs@gmail.com

   www.vagucs.com.br

   Ponte COBOL -> SDL3. Janela, textura, paleta e teclado.
   O rato fica de fora. O motor do jogo nao entra aqui. */

#include <SDL3/SDL.h>

#include <stdlib.h>

void audio_shutdown(void);

static unsigned char key_down[SDL_SCANCODE_COUNT];

static void remember_key(const SDL_KeyboardEvent *key)
{
    if (key->scancode < SDL_SCANCODE_COUNT)
        key_down[key->scancode] = key->down ? 1 : 0;
}

static SDL_Window *window = NULL;
static SDL_Renderer *renderer = NULL;
static SDL_Texture *texture = NULL;
static Uint32 *pixels = NULL;
static int tex_w = 0;
static int tex_h = 0;
static int win_w = 0;
static int win_h = 0;
static int fullscreen = 0;
static int sdl_up = 0;

static int window_locked(void)
{
    SDL_WindowFlags flags;

    if (window == NULL)
        return 1;
    flags = SDL_GetWindowFlags(window);
    if (fullscreen)
        return 1;
    if (flags & (SDL_WINDOW_FULLSCREEN | SDL_WINDOW_MAXIMIZED))
        return 1;
    return 0;
}

static void toggle_maximize(void)
{
    SDL_WindowFlags flags;

    if (window == NULL)
        return;
    flags = SDL_GetWindowFlags(window);
    if (flags & SDL_WINDOW_MAXIMIZED)
        SDL_RestoreWindow(window);
    else
        SDL_MaximizeWindow(window);
}

static void ignore_mouse(void)
{
    SDL_SetEventEnabled(SDL_EVENT_MOUSE_MOTION, false);
    SDL_SetEventEnabled(SDL_EVENT_MOUSE_BUTTON_DOWN, false);
    SDL_SetEventEnabled(SDL_EVENT_MOUSE_BUTTON_UP, false);
    SDL_SetEventEnabled(SDL_EVENT_MOUSE_WHEEL, false);
    SDL_HideCursor();
}

int video_init(int w, int h, int scale, int vsync)
{
    if (w < 1 || h < 1)
        return 1;
    if (scale < 1)
        scale = 1;
    if (!vsync)
        SDL_SetHint(SDL_HINT_RENDER_VSYNC, "0");
    if (!SDL_Init(SDL_INIT_VIDEO | SDL_INIT_EVENTS))
        return 2;
    sdl_up = 1;
    ignore_mouse();
    window = SDL_CreateWindow("DOOM", w * scale, h * scale,
        SDL_WINDOW_RESIZABLE);
    if (window == NULL)
        return 3;
    SDL_SetWindowPosition(window, SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED);
    renderer = SDL_CreateRenderer(window, NULL);
    if (renderer == NULL)
        renderer = SDL_CreateRenderer(window, "software");
    if (renderer == NULL)
        return 4;
    SDL_SetRenderVSync(renderer, vsync ? 1 : 0);
    SDL_SetDefaultTextureScaleMode(renderer, SDL_SCALEMODE_NEAREST);
    texture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_ARGB8888,
        SDL_TEXTUREACCESS_STREAMING, w, h);
    if (texture == NULL)
        return 5;
    SDL_SetTextureScaleMode(texture, SDL_SCALEMODE_NEAREST);
    pixels = (Uint32 *)calloc((size_t)w * (size_t)h, sizeof(Uint32));
    if (pixels == NULL)
        return 6;
    tex_w = w;
    tex_h = h;
    win_w = w * scale;
    win_h = h * scale;
    fullscreen = 0;
    return 0;
}

void video_shutdown(void)
{
    audio_shutdown();
    free(pixels);
    pixels = NULL;
    if (texture != NULL)
        SDL_DestroyTexture(texture);
    if (renderer != NULL)
        SDL_DestroyRenderer(renderer);
    if (window != NULL)
        SDL_DestroyWindow(window);
    texture = NULL;
    renderer = NULL;
    window = NULL;
    tex_w = 0;
    tex_h = 0;
    if (sdl_up) {
        SDL_Quit();
        sdl_up = 0;
    }
}

void video_upload(unsigned char *indexed, unsigned char *pal)
{
    int n;
    int i;
    int c;

    if (pixels == NULL || indexed == NULL || pal == NULL)
        return;
    n = tex_w * tex_h;
    for (i = 0; i < n; i++) {
        c = indexed[i];
        pixels[i] = 0xFF000000u
            | ((Uint32)pal[c * 3] << 16)
            | ((Uint32)pal[c * 3 + 1] << 8)
            | (Uint32)pal[c * 3 + 2];
    }
}

int video_set_scale(int scale)
{
    if (!sdl_up || window == NULL)
        return 1;
    if (scale < 1)
        scale = 1;
    if (scale > 4)
        scale = 4;
    win_w = tex_w * scale;
    win_h = tex_h * scale;
    if (window_locked())
        return 0;
    SDL_SetWindowSize(window, win_w, win_h);
    SDL_SetWindowPosition(window, SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED);
    return 0;
}

extern void audio_pump(void);

void video_present(void)
{
    audio_pump();
    if (renderer == NULL || texture == NULL || pixels == NULL)
        return;
    SDL_UpdateTexture(texture, NULL, pixels, tex_w * (int)sizeof(Uint32));
    SDL_RenderClear(renderer);
    SDL_RenderTexture(renderer, texture, NULL, NULL);
    SDL_RenderPresent(renderer);
}

int video_ms(void)
{
    if (!sdl_up)
        return 0;
    return (int)SDL_GetTicks();
}

int video_key(int sym)
{
    const bool *state;
    SDL_Scancode code;
    SDL_Keymod mods;

    if (!sdl_up)
        return 0;
    mods = SDL_GetModState();
    if (sym == 1073742048 && (mods & SDL_KMOD_LCTRL))
        return 1;
    if (sym == 1073742052 && (mods & SDL_KMOD_RCTRL))
        return 1;
    if (sym == 1073742048)
        code = SDL_SCANCODE_LCTRL;
    else if (sym == 1073742052)
        code = SDL_SCANCODE_RCTRL;
    else
        code = SDL_GetScancodeFromKey((SDL_Keycode)sym, NULL);
    if (code == SDL_SCANCODE_UNKNOWN || code >= SDL_SCANCODE_COUNT)
        return 0;
    if (key_down[code])
        return 1;
    state = SDL_GetKeyboardState(NULL);
    if (state != NULL && state[code])
        return 1;
    return 0;
}

int video_poll(void)
{
    SDL_Event event;
    int found;

    found = 0;
    while (SDL_PollEvent(&event)) {
        if (event.type == SDL_EVENT_QUIT)
            return -1;
        if (event.type == SDL_EVENT_KEY_DOWN || event.type == SDL_EVENT_KEY_UP)
            remember_key(&event.key);
        if (event.type == SDL_EVENT_KEY_DOWN && !event.key.repeat
            && (event.key.key == SDLK_RETURN
                || event.key.key == SDLK_KP_ENTER)
            && (event.key.mod & SDL_KMOD_ALT)) {
            toggle_maximize();
            continue;
        }
        if (found == 0 && event.type == SDL_EVENT_KEY_DOWN && !event.key.repeat)
            found = (int)event.key.key;
    }
    return found;
}
