Games
=====

I mostly play old emulated stuff, c64, snes and so on.

## sdlmame

Sdlmame is in the arch main repo.
The UI is quite simple, probably there are better frontends, but this one
doesn't need AUR or anything fancy and the dependencies are minimal.

Unfortunately the config __saving is buggy__. It saves into
`.mame/mame.ini`, but reads from `.mame/ini/mame.ini`
(thank you, strace). Just link higher level ones into the ini folder
and be sure to add go+rw with chmod.

Sdlmame (as of this writing) is mame 0.180, earlier ROM sets will NOT work reliably.

Probably it is a good idea to lock the version in `pacman.conf` after installation
(`IgnorePkg = sdlmame`).
