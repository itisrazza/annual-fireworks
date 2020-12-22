# Happy New Year! 2020

This is the program I've streamed on the night of New Year's 2020. It's meant
to show the time, followed by a countdown and then fireworks.

It's loosely based on the concept of the one I made back last year (2018 → 2019), but I've since lost the source code due to my SSD dying right after I came back home. You can watch the 2019 variant on [YouTube](https://www.youtube.com/watch?v=zznx54EFqSk).

I'll be hosting this year's one on [my YouTube channel](https://www.youtube.com/channel/UC2ZgvSezqPAuGZjQdYPevjQ). You can also keep tabs on [the Twitter thread](https://twitter.com/thegreatrazz/status/1200701552341606400).

## This year's theme

In 2019, I decided to quickly make something in C# with the Windows console and all the came out of it was a flickery mess. At least the ASCII fireworks came out alright.

This year, I decided to go for a more 8-bit... maybe 16-bit pixel looks for things. I was going to write a NES "game" and have a Lua script feed the time into the game... But I don't think I can do that yet.

So as a compromise, I've written this in C using the SDL2 graphics library and set the base resolution to 320x180 (a common denominator between 720p and 1080p) and have it scale up.

## Build

So far, I've only really made it for Linux. Make sure you have SDL and the latest GCC compilers installed and go `make` it! If you're lucky, it might even work on macOS.

If you're on Windows, you can try msys2 or cygwin. I haven't tried either yet.

## Running

The program requires a data folder linking to the `data/` folder in the repository in the current directory. This is where the assets are stored. If it has that... it's good.

To run it, just run `bin/new-year-2020` from the repo folder. It will show you the arguments. You can pass it the UNIX time (was too lazy to implement an actual date and time parser) or the number of seconds relative to the moment the program starts.

```bash
bin/new-year-2020 1577836800    # counts down to 1 Jan 2020 12AM (UTC)
bin/new-year-2020 1577790000    # counts down to 1 Jan 2020 12AM (NZST)
bin/new-year-2020 +120          # counts down to 2 minutes from now
```


