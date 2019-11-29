
#include <time.h>
#include "main.h"

void prep_time ()
{
    // is there any setup?
}

void render_time ()
{
    // get the time
    time_t now = time(NULL);
    struct tm *now_tm = localtime(&now);

    const char now_time_str[64]; // is this enough?
    const char now_date_str[64];

    strftime(now_time_str, 64, "%T", now_tm);
    strftime(now_date_str, 64, "%A, %d %B, %Y", now_tm);

    // render it
    SDL_Color render_color = { 255, 255, 200, 255 };
    SDL_Surface *time_surface = TTF_RenderUTF8_Blended(font_num, now_time_str, render_color);
    SDL_Surface *date_surface = TTF_RenderUTF8_Blended(font_text, now_date_str, render_color);
    SDL_Texture *time_texture = SDL_CreateTextureFromSurface(renderer, time_surface);
    SDL_Texture *date_texture = SDL_CreateTextureFromSurface(renderer, date_surface);

    // calculate positions and copy them
    SDL_Rect time_target = { RES_WIDTH / 2 - time_surface->w / 2,
                             RES_HEIGHT / 2 - time_surface->h * 1.1,
                             time_surface->w, time_surface->h };
    SDL_Rect date_target = { RES_WIDTH / 2 - date_surface->w / 2,
                             RES_HEIGHT / 2 + date_surface->h * 0.1,
                             date_surface->w, date_surface->h };
    SDL_RenderCopy(renderer, time_texture, NULL, &time_target);
    SDL_RenderCopy(renderer, date_texture, NULL, &date_target);                             
    
    // clean up so we don't have mem leaks
    SDL_FreeSurface(time_surface);
    SDL_FreeSurface(date_surface);
    SDL_DestroyTexture(time_texture);
    SDL_DestroyTexture(date_texture);
}
