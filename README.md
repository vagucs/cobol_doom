# cobol_doom

DOOM generic ported from **[python_doom](https://github.com/vagucs/python_doom)** to **GnuCOBOL + SDL2**.

By **Wagner Nunes da Silva**

- vagucs@bol.com.br
- vagucs@vagucs.com.br
- vagucs@gmail.com
- [www.vagucs.com.br](https://www.vagucs.com.br)
- [LinkedIn](https://www.linkedin.com/in/wagner-nunes-da-silva-b0a15360)

This tree is that Python engine again, in COBOL. The game loop will stay in COBOL. A small C file talks to SDL2 for the window, the keyboard, and the texture. There is no mouse. Windows MCI will play the MIDI later, because SDL2 does not.

Versão em português: [README.pt.md](README.pt.md)

---

## What this project is

`python_doom` is a condensed, playable DOOM engine in Python. This directory is the **same study piece**, started in COBOL:

- Window, keys, blit: **SDL2**, reached from COBOL with `CALL`
- Framebuffer: 320×200, stretched to a 640×400 window
- Fixed-point: the same 16.16 wrap as `doom/compat.py`, in `src/compat.c`
- Mouse: left out

The program checks the fixed-point helpers, reads an IWAD, loads textures and flats, and draws the first-person view of E1M1 (or MAP01 when that is the IWAD): walls, floor, ceiling, sky, the things of that first frame, and the pistol already raised. The arrow keys walk and turn. Shift runs. Alt with the side arrows strafes, as do comma and period. Space, or E, opens the door ahead: the ceiling rises, waits, and comes back down. Ctrl fires the pistol: the barrel recoils, the muzzle flash shows, the shot hits the wall or whoever is in front, and a kill falls down. Zombies and shotgun guys wake, walk, and shoot. An imp runs, claws up close, or throws a fireball. A demon bites. When the player's health reaches zero, the pistol disappears, the controls stop, and the view sinks to the floor. Each step follows the game clock and redraws the view, including while a door, a shot, or a monster is moving. A closed door stops the player. Esc, or closing the window, quits. The bar along the bottom shows health, pistol ammo, armor, and the face, which grows bloodier when a shot lands and turns into the dead face when health runs out. Walking over an item takes it: a stimpack or medikit raises health up to 100, a soul sphere goes past 100, green armor is 100 and blue armor is 200, ammo fills the counter, and a key shows on the bar. A weapon lights its yellow number, adds that weapon's ammo, and rises into the hand. Keys 1 through 7 switch weapons: 1 is the fist, 2 the pistol, 3 the shotgun, 4 the chaingun, and 5 the rocket launcher. The shotgun fires seven pellets, the chaingun spends bullets, and the chainsaw cuts up close. The rocket launcher, plasma gun, and BFG fire. The rocket flies and bursts, plasma is a fast bolt, and the BFG sweeps whoever is in front. The exit switch changes face and, a second later, opens the next map. Weapons, ammo, health, and keys come along. The green slime takes health every second, standing still or walking, and armor absorbs part of it. When health drops, the screen flashes red for a moment and returns to normal. On a hit, the face looks toward the shooter, the impact pushes the player back, and in the slime the face bares its teeth for a second. iddqd turns on invulnerability and the god face. idkfa gives every weapon, ammo, armor, and the keys. idfa does the same without the keys. idclip and idspispopd walk through walls. A platform lowers, waits, and rises. A stair climbs in steps. A teleporter carries you to its landing. A locked door opens only with the key, and a grate shows its gaps. The title screen opens the menu. New game melts into the level. Esc opens the menu. Minus and equals change the view size, and the Resolution option changes the window. The exit shows the tally and melts into the next map. A spectre shows up translucent and bites. A baron and a hell knight bite up close and throw a fireball. Sound effects and music play: shots, doors, monsters, items, pain, death, and the level song. Holding Ctrl keeps firing, except the rocket launcher and the BFG, which wait for a new press.

You need a legal IWAD (shareware `doom1.wad` or commercial `doom.wad` / `doom2.wad`). This repository does not ship commercial WAD data.

It is a **condensed educational port**: the engine will be COBOL, the native layer is SDL2.

Left out of this tree:

- Mouse
- Network, joystick, CD audio

---

## Educational purpose

This project is a **study piece**. The Python port already dropped the preprocessor and Harbour's 1-based arrays. The COBOL port asks a different question: **what survives when the records are `OCCURS` tables and the arithmetic wants to be decimal**.

What it is meant to teach:

- **Python, then COBOL.** Open `python_doom/doom/` next to `cobol_doom/`. The names stay close (`fixed_mul`, `as_i32`) so the two files can sit side by side.
- **32-bit wrap, outside `COMPUTE`.** A COBOL `COMPUTE` on decimal items does not match a 16.16 shift. `src/compat.c` is the same math as `compat.py`, and COBOL calls it.
- **1-based tables, 0-based data.** COBOL `OCCURS` starts at 1. WAD lumps stay 0-based in the data and are stored at lump number `+ 1`, as in the Lua and Julia ports.
- **Where COBOL is enough.** The loop, the map, and the view stay in COBOL. SDL2 is the window and the keyboard. Sine, tangent, and arctangent live in `src/compat.c`.

Suggested way to study:

1. Run `run.bat`, then read `main.cob` — the fixed-point check, the IWAD, and the E1M1 view.
2. Compare `view.cob` with `python_doom/doom/render.py`, `sprites.cob` with `doom/sprites.py`, `map.cob` with `doom/world.py`, and `rdata.cob` with `doom/r_data.py`.
3. Compare `wad.cob` with `doom/wad.py`, and `src/compat.c` with `doom/compat.py`. `src/video.c` never reads the mouse.

---

## Technology

| Layer | This port | Python (`python_doom`) |
| --- | --- | --- |
| Language | GnuCOBOL 3.2 | Python 3.10+ |
| Window, keys, blit | SDL2, `CALL` from COBOL | pygame 2.x |
| 16.16 fixed-point | `src/compat.c` | `doom/compat.py` |
| Mouse | left out | used for look and fire |
| IWAD | `wad.cob`, `rdata.cob`, and `view.cob`, E1M1 view | the same lumps |
| Build | `run.bat` (`cobc` + the UCRT64 gcc) | `pip install -r requirements.txt` |

The compiler used here is the MSYS2 package `mingw-w64-ucrt-x86_64-gnucobol`, with `gcc` and `SDL2` from `C:\msys64\ucrt64`. `run.bat` puts that `bin` folder on `PATH` so `SDL2.dll` is found.

---

## How to run

From this directory, on Windows:

```
run.bat
```

`build.bat` only compiles. The window is 640×400. The texture is 320×200.

The IWAD is the first file that exists among `DOOM1.WAD`, `doom1.wad`, `DOOM.WAD`, `doom.wad`, `DOOM2.WAD`, `doom2.wad`, `PLUTONIA.WAD`, `TNT.WAD`, `freedoom1.wad`, and `freedoom2.wad`. The search starts at `DOOMWADDIR` or `DOOMWADPATH` when that variable is set, then the current folder and parent folders. `-iwad` chooses the file, the same way as the other ports. A bare path ending in `.wad` also works. `-fps` shows the frames per second in the top-right corner.

```
run.bat -iwad C:\wads\doom1.wad -fps
```

The usual cheats work while standing still: `iddqd`, `idkfa`, `idfa`, `idclip`, `idspispopd`, `idchoppers`, `idmypos`, `idbehold` plus the next letter (`v` invulnerable, `s` strength, `i` invisible, `r` suit, `l` light), `idmus` and `idclev` with two digits. `idclev16` opens E1M6. `iddt` has no automap in this version.

---

## Keys

| Key | Action |
| --- | --- |
| **Up** or **W** | Walk forward |
| **Down** or **S** | Walk back |
| **Left** or **A** | Turn left |
| **Right** or **D** | Turn right |
| **Shift** | Run |
| **Alt** with left or right | Strafe |
| **Comma** and **period** | Strafe |
| **Space** or **E** | Open the door ahead |
| **Ctrl** | Fire the pistol |
| **Esc** | Quit |
| Close the window | Quit |

The mouse is ignored.

---

## Layout

```
main.cob             entry, the view, walking, use, fire, and monsters
door.cob             vertical doors, ceiling up and down
walk.cob             one movement tic and the walls
gun.cob              pistol, the shot, blood, and puff
enemy.cob            monsters wake, walk, and attack
status.cob           health, ammo, armor, and the face
item.cob             floor items: health, armor, ammo, keys, and weapons
playstate.cpy        player position
wad.cob              doom/wad.py
wadstate.cpy         lump table (OCCURS, slot = lump + 1)
view.cob             doom/render.py, walls, floor, ceiling, sky, sprites, pistol
sprites.cob          doom/sprites.py, frames and map things
sprstate.cpy         sprite frames and things
sprdata.cpy          spawn state of each doomednum
map.cob              doom/world.py, overhead plan kept in the tree
mapstate.cpy         vertexes, lines, sectors
rdata.cob            doom/r_data.py
rdata.cpy            textures, flats, colormap
vvideo.cob           V_DrawPatch and line plot
build.bat            cobc
run.bat              PATH, build, then the window
src/compat.c         doom/compat.py, plus sine, tangent, arctangent
src/wadio.c          binary read and paths
src/mapdraw.c        plan scale and palette colors
src/video.c          SDL2 window, palette, and keyboard
```

---

## Lineage

1. **[python_doom](https://github.com/vagucs/python_doom)** — Python + pygame
2. **cobol_doom** — GnuCOBOL + SDL2 (this tree)

---

## Donate

### GitHub Sponsors

[github.com/sponsors/vagucs](https://github.com/sponsors/vagucs)

### Ethereum

`0x1b64038A2b1DB73ABd0068d8B9B0d1dC5a90C5F1`

![Ethereum QR Code](docs/qr-ethereum.png)

### PIX

Key: `vagucs@bol.com.br`

![PIX QR Code](docs/qr-pix.png)
