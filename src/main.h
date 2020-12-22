#pragma once

// some useful variables and headers from main.h

#include <SDL.h>
#include <SDL_ttf.h>

extern const int RES_WIDTH;
extern const int RES_HEIGHT;

extern SDL_Renderer *renderer;

extern TTF_Font *font_text;
extern TTF_Font *font_num;
extern TTF_Font *font_numbig;

double time_now ();
double time_to ();
