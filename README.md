# Happy New Year! 2021

Back for another new year's. This follows the same premise as last year's, but I've "adapted" it to Lua (using love2d) and gone for a more modern (compared to last year's) aesthetic.

This will be streamed over New Year's in NZDT (UTC+13) before I head out to have fun with my friends.

I'll be hosting this year's one on [my YouTube channel](https://www.youtube.com/channel/UC2ZgvSezqPAuGZjQdYPevjQ). You can also keep tabs on [the Twitter thread](https://twitter.com/thegreatrazz/status/1200701552341606400).

## Running

This is written in Lua using the [LÖVE](https://love2d.org/) framework. Run it by dragging the folder onto the LÖVE icon, or running:

```
$ love .
```

The date for New Year's (NZDT) is hard-coded in [main.lua](main.lua#5), but you can change it easily. For testing, you can use `os.time() + 70` instead of the timestamp.
