
#include "main.h"

void prep_countdown ()
{

}

void render_countdown ()
{
    int seconds_left = time_to();
    double fseconds_left = time_to() - seconds_left;

    char second_str[4];
    sprintf(second_str, "%d", seconds_left);

    SDL_Color render_color = { 255 * fseconds_left, 255 * fseconds_left, 250 * fseconds_left, 255 * fseconds_left };
    SDL_Surface *number_surface = TTF_RenderText_Blended(font_numbig, second_str, render_color);
    SDL_Texture *number_texture = SDL_CreateTextureFromSurface(renderer, number_surface);

    SDL_Rect number_target = { RES_WIDTH / 2 - number_surface->w / 2,
                               RES_HEIGHT / 2 - number_surface->h / 2,
                               number_surface->w, number_surface->h };
    SDL_FreeSurface(number_surface);
    SDL_RenderCopy(renderer, number_texture, NULL, &number_target);
}
