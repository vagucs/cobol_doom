/* DOOM generic portado do python_doom para COBOL com SDL2.

   Por Wagner Nunes da Silva

   vagucs@bol.com.br
   vagucs@vagucs.com.br
   vagucs@gmail.com

   www.vagucs.com.br

   Ponte COBOL -> SDL2. Janela, textura, paleta e teclado.
   O rato fica de fora. O motor do jogo nao entra aqui. */

#define SDL_MAIN_HANDLED
#include <SDL.h>

#include <stdlib.h>

void audio_shutdown(void);

static unsigned char key_down[SDL_NUM_SCANCODES];

static void remember_key(const SDL_KeyboardEvent *key)
{
    if (key->keysym.scancode < SDL_NUM_SCANCODES)
        key_down[key->keysym.scancode] =
            key->type == SDL_KEYDOWN ? 1 : 0;
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

static void toggle_fullscreen(void)
{
    if (window == NULL)
        return;
    if (!fullscreen) {
        SDL_GetWindowSize(window, &win_w, &win_h);
        if (SDL_SetWindowFullscreen(window, SDL_WINDOW_FULLSCREEN_DESKTOP) == 0)
            fullscreen = 1;
        return;
    }
    if (SDL_SetWindowFullscreen(window, 0) == 0) {
        fullscreen = 0;
        if (win_w > 0 && win_h > 0)
            SDL_SetWindowSize(window, win_w, win_h);
        SDL_SetWindowPosition(window, SDL_WINDOWPOS_CENTERED,
            SDL_WINDOWPOS_CENTERED);
    }
}

static void ignore_mouse(void)
{
    SDL_EventState(SDL_MOUSEMOTION, SDL_IGNORE);
    SDL_EventState(SDL_MOUSEBUTTONDOWN, SDL_IGNORE);
    SDL_EventState(SDL_MOUSEBUTTONUP, SDL_IGNORE);
    SDL_EventState(SDL_MOUSEWHEEL, SDL_IGNORE);
    SDL_ShowCursor(SDL_DISABLE);
}

int video_init(int w, int h, int scale, int vsync)
{
    Uint32 flags;

    if (w < 1 || h < 1)
        return 1;
    if (scale < 1)
        scale = 1;
    if (!vsync)
        SDL_SetHint(SDL_HINT_RENDER_VSYNC, "0");
    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_EVENTS) != 0)
        return 2;
    sdl_up = 1;
    ignore_mouse();
    window = SDL_CreateWindow("DOOM",
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        w * scale, h * scale, SDL_WINDOW_SHOWN);
    if (window == NULL)
        return 3;
    flags = SDL_RENDERER_ACCELERATED;
    if (vsync)
        flags |= SDL_RENDERER_PRESENTVSYNC;
    renderer = SDL_CreateRenderer(window, -1, flags);
    if (renderer == NULL)
        renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_SOFTWARE);
    if (renderer == NULL)
        return 4;
    if (!vsync)
        SDL_RenderSetVSync(renderer, 0);
    texture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_ARGB8888,
        SDL_TEXTUREACCESS_STREAMING, w, h);
    if (texture == NULL)
        return 5;
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
    if (fullscreen)
        return 0;
    SDL_SetWindowSize(window, win_w, win_h);
    SDL_SetWindowPosition(window, SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED);
    return 0;
}

void video_present(void)
{
    if (renderer == NULL || texture == NULL || pixels == NULL)
        return;
    SDL_UpdateTexture(texture, NULL, pixels, tex_w * (int)sizeof(Uint32));
    SDL_RenderClear(renderer);
    SDL_RenderCopy(renderer, texture, NULL, NULL);
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
    const Uint8 *state;
    SDL_Scancode code;
    SDL_Keymod mods;

    if (!sdl_up)
        return 0;
    mods = SDL_GetModState();
    if (sym == 1073742048 && (mods & KMOD_LCTRL))
        return 1;
    if (sym == 1073742052 && (mods & KMOD_RCTRL))
        return 1;
    if (sym == 1073742048)
        code = SDL_SCANCODE_LCTRL;
    else if (sym == 1073742052)
        code = SDL_SCANCODE_RCTRL;
    else
        code = SDL_GetScancodeFromKey((SDL_Keycode)sym);
    if (code == SDL_SCANCODE_UNKNOWN || code >= SDL_NUM_SCANCODES)
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
        if (event.type == SDL_QUIT)
            return -1;
        if (event.type == SDL_KEYDOWN || event.type == SDL_KEYUP)
            remember_key(&event.key);
        if (event.type == SDL_KEYDOWN && !event.key.repeat
            && (event.key.keysym.sym == SDLK_RETURN
                || event.key.keysym.sym == SDLK_KP_ENTER)
            && (event.key.keysym.mod & KMOD_ALT)) {
            toggle_fullscreen();
            continue;
        }
        if (found == 0 && event.type == SDL_KEYDOWN && !event.key.repeat)
            found = (int)event.key.keysym.sym;
    }
    return found;
}
