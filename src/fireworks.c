
#include "main.h"
///

struct firework
{
    int x;
    int y;
    int explode;
    int stars;
};

#define firework_blank 100
#define firework_size  100
#define firework_count 5
struct firework fireworks[firework_count];

int firework_gone (struct firework *fw)
{
    return fw->y >= fw->explode + firework_size + firework_blank;
}

void firework_repurpose (struct firework *fw)
{
    fw->x = rand() % RES_WIDTH;
    fw->y = 0;
    fw->explode = rand() % (RES_HEIGHT * 2 / 3) + RES_HEIGHT / 6;
    fw->stars = 3 + rand() % 17;
}

///

SDL_Texture *firework_star;
SDL_Texture *firework_launch;

int initial_fireworks = 1;
struct {
    char first : 1;
    char second : 1;
    char third : 1;
    char fourth : 1;
} show_digits;

void prep_fireworks ()
{
    SDL_Surface *firework_star_surface = SDL_LoadBMP("data/fw_star.bmp");
    SDL_Surface *firework_launch_surface = SDL_LoadBMP("data/fw_launch.bmp");
    firework_star = SDL_CreateTextureFromSurface(renderer, firework_star_surface);
    firework_launch = SDL_CreateTextureFromSurface(renderer, firework_launch_surface);

    fireworks[0] = (struct firework){ RES_WIDTH * 1 / 5,   0,  RES_HEIGHT / 2, 10 };
    fireworks[1] = (struct firework){ RES_WIDTH * 2 / 5, -30,  RES_HEIGHT / 2, 10 };
    fireworks[2] = (struct firework){ RES_WIDTH * 3 / 5, -60,  RES_HEIGHT / 2, 10 };
    fireworks[3] = (struct firework){ RES_WIDTH * 4 / 5, -90,  RES_HEIGHT / 2, 10 };
    fireworks[4] = (struct firework){ RES_WIDTH * 2    , -120, RES_HEIGHT / 2, 10 };
}

void render_fireworks ()
{
    // render text

    SDL_Color text_color = { 32, 32, 64, 255 };
    SDL_Surface *two_surface = TTF_RenderText_Blended(font_numbig, "2", text_color);
    SDL_Surface *zer_surface = TTF_RenderText_Blended(font_numbig, "0", text_color);
    SDL_Texture *two_texture = SDL_CreateTextureFromSurface(renderer, two_surface);
    SDL_Texture *zer_texture = SDL_CreateTextureFromSurface(renderer, zer_surface);

    SDL_Point two_size = { two_surface->w, two_surface->h };
    SDL_Point zer_size = { zer_surface->w, zer_surface->h };

    SDL_FreeSurface(two_surface);
    SDL_FreeSurface(zer_surface);

    SDL_Rect year_rect;

    if (show_digits.first) {
        year_rect = (SDL_Rect){ RES_WIDTH * 1 / 5 - two_size.x / 2,
                                RES_HEIGHT / 2 - two_size.y / 2,
                                two_size.x, two_size.y };
        SDL_RenderCopy(renderer, two_texture, NULL, &year_rect);
    }

    if (show_digits.second) {
        year_rect = (SDL_Rect){ RES_WIDTH * 2 / 5 - zer_size.x / 2,
                                RES_HEIGHT / 2 - zer_size.y / 2,
                                zer_size.x, zer_size.y };
        SDL_RenderCopy(renderer, zer_texture, NULL, &year_rect);
    }

    if (show_digits.third) {
        year_rect = (SDL_Rect){ RES_WIDTH * 3 / 5 - two_size.x / 2,
                                RES_HEIGHT / 2 - two_size.y / 2,
                                two_size.x, two_size.y };
        SDL_RenderCopy(renderer, two_texture, NULL, &year_rect);
    }

    if (show_digits.fourth) {
        year_rect = (SDL_Rect){ RES_WIDTH * 4 / 5 - zer_size.x / 2,
                                RES_HEIGHT / 2 - zer_size.y / 2,
                                zer_size.x, zer_size.y };
        SDL_RenderCopy(renderer, zer_texture, NULL, &year_rect);
    }

    // render fw

    for (int i = 0; i < firework_count; i++) {
        struct firework *fw = &fireworks[i];

        if (firework_gone(fw)) {
            if (initial_fireworks && fw == &fireworks[3]) {
                initial_fireworks = 0;
            }

            // SDL_Log("Firework %d: Repurposed", i);
            firework_repurpose(fw);
        }
        
        if (fw->y < fw->explode) {
            // SDL_Log("Firework %d: Before explosion", i);
            SDL_Rect rect = { fw->x, RES_HEIGHT - fw->y, 8, 8 };
            SDL_RenderCopy(renderer, firework_launch, NULL, &rect);
        } else if (fw->y >= fw->explode) {
            if (initial_fireworks && fw == &fireworks[0]) show_digits.first = 1;
            if (initial_fireworks && fw == &fireworks[1]) show_digits.second = 1;
            if (initial_fireworks && fw == &fireworks[2]) show_digits.third = 1;
            if (initial_fireworks && fw == &fireworks[3]) show_digits.fourth = 1;

            int center_x = fw->x;
            int distance = fw->y - fw->explode;
            int center_y = RES_HEIGHT - fw->explode/*  + distance / 3 */;
            int gone_pt = fw->explode + firework_size + firework_blank;
            double size = 1 - (double)(fw->y - fw->explode) / firework_size;

            for (int i = 0; i < 360; i += 360 / fw->stars) {
                double rad = i * M_PI / 180.0;
                double dx = SDL_cos(rad);
                double dy = SDL_sin(rad);

                SDL_Rect rect = { center_x + dx * distance - 8 * size / 2,
                                  center_y + dy * distance - 8 * size / 2,
                                  8 * size, 8 * size };
                SDL_RenderCopy(renderer, firework_star, NULL, &rect);
            }
        }

        fw->y += 2;
    }

    SDL_DestroyTexture(two_texture);
    SDL_DestroyTexture(zer_texture);
}
