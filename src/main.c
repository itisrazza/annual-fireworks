
#include <locale.h>
#include <math.h>

#include <SDL.h>
#include <SDL_ttf.h>

const char *WINDOW_TITLE = "Happy New Year! 2020";
const int RES_WIDTH = 320;
const int RES_HEIGHT = 180;
const int RES_SCALE  = 2;

SDL_Window *window;
SDL_Renderer* renderer;

// TODO: Change the fonts to aliasable ones
TTF_Font *font_text;
TTF_Font *font_num;
TTF_Font *font_numbig;

////

void prep_background ();
void render_background ();

void prep_time ();
void render_time ();

void prep_countdown ();
void render_countdown ();

void prep_fireworks ();
void render_fireworks ();

////

int init ()
{
    if (SDL_Init(SDL_INIT_EVERYTHING) != 0) {
        SDL_Log("Failed to init SDL: %s", SDL_GetError());
        return 0;
    }

    if (TTF_Init() != 0) {
        SDL_Log("Failed to init TTF: %s", SDL_GetError());
        return 0;
    }

    window = SDL_CreateWindow(WINDOW_TITLE,
                              SDL_WINDOWPOS_UNDEFINED,
                              SDL_WINDOWPOS_UNDEFINED,
                              RES_WIDTH * RES_SCALE, RES_HEIGHT * RES_SCALE,
                              SDL_WINDOW_ALLOW_HIGHDPI);
    if (window == NULL) {
        SDL_Log("Failed to create window: %s", SDL_GetError());
        return 0;
    }

    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_PRESENTVSYNC);
    if (renderer == NULL) {
        SDL_Log("Failed to create renderer: %s", SDL_GetError());
        return 0;
    }

    return 1;   
}

int load_media ()
{
    font_text = TTF_OpenFont("data/unifont.ttf", 16);
    if (font_text == NULL) {
        SDL_Log("Failed to load font: %s", SDL_GetError());
        return 0;
    }

    font_num = TTF_OpenFont("data/unifont.ttf", 16);
    if (font_num == NULL) {
        SDL_Log("Failed to load font: %s", SDL_GetError());
        return 0;
    }
    
    font_numbig = TTF_OpenFont("data/B612Mono-Bold.ttf", 65);
    if (font_numbig == NULL) {
        SDL_Log("Failed to load font: %s", SDL_GetError());
        return 0;
    }

    prep_background();

    return 1;
}

int loop ()
{
    // manage events
    SDL_Event event;
    while (SDL_PollEvent(&event)) {
        if (event.type == SDL_QUIT) return 0;
    }
    
    // render things
    render_background();
    render_time();

    // update renderer
    SDL_RenderPresent(renderer);

    return 1;
}

void finish ()
{
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);

    SDL_Quit();
}

int main (int argc, char *argv[])
{
    if (argc < 2) {
        SDL_Log("Usage: %s [time]", argv[0]);
        SDL_Log("  time - UNIX epoch eg (1577836800 for 1/1/2020 at UTC)");
        return 1;
    }

    // convert the string to time

    int target_time = atoi(argv[1]);


    SDL_Log("Starting New Years showcase with time: ");

    // start the game

    if (!init()) {
        SDL_Log("Failed to initalise. Quitting...");
        return 1;
    }

    if (!load_media()) {
        SDL_Log("Failed to load assets. Quitting...");
        return 1;
    }

    SDL_RenderSetLogicalSize(renderer, RES_WIDTH, RES_HEIGHT);
    while (loop()) ;

    finish();
    return 0;
}
