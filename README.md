# Happy New Year! 2020

This is the program I've streamed on the night of New Year's 2020. It's meant
to show the time, followed by a countdown and then fireworks.

It's loosely based on the concept of the one I made back last year (2018 → 2019), but I've since lost the source code due to my SSD dying right after I came back home. You can watch the 2019 variant on [Twitch](https://www.twitch.tv/videos/363180839).

## Screenshots



## This year's theme

In 2019, I decided to quickly make something in C# with the Windows console and all the came out of it was a flickery mess. At least the ASCII fireworks came out alright.

This year, I decided to go for a more 8-bit... maybe 16-bit pixel looks for things. I was going to write a NES "game" and have a Lua script feed the time into the game... But I don't think I can do that yet.

So as a compromise, I've written this in C using the SDL2 graphics library and set the base resolution to 320x180 (a common denominator between 720p and 1080p) and have it scale up.
