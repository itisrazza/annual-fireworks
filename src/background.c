
#include "main.h"

struct star
{
    int x, y, z;
};

#define star_count 500
struct star stars[star_count];

int star_gone (struct star *star)
{
    return star->x >= RES_WIDTH;
}

void star_repurpose (struct star *star)
{
    star->x = 0;
    star->y = rand() % RES_HEIGHT;
    star->z = rand() % 3 + 1;
}

void prep_background ()
{
    for (int i = 0; i < star_count; i++) {
        struct star *star = &stars[i];
        star_repurpose(star);
        star->x = rand() % RES_WIDTH;
    }
}

void render_background ()
{
    // fill bg first
    SDL_SetRenderDrawColor(renderer, 0, 0, 16, 255);
    SDL_RenderClear(renderer);

    // draw the stars (and update them)
    SDL_SetRenderDrawColor(renderer, 64, 64, 128, 255);
    for (int i = 0; i < star_count; i++) {
        struct star *star = &stars[i];
        SDL_Rect rect = { RES_WIDTH - star->x, star->y,
                          star->z, star->z };
        SDL_RenderFillRect(renderer, &rect);

        star->x += star->z;

        if (star_gone(star)) {
            star_repurpose(star);
        }
    }
}
