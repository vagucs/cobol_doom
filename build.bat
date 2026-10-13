@echo off
setlocal
cd /d "%~dp0"
set "PATH=C:\msys64\ucrt64\bin;%PATH%"
set "COB_CONFIG_DIR=C:\msys64\ucrt64\share\gnucobol\config"
set "COB_COPY_DIR=C:\msys64\ucrt64\share\gnucobol\copy"
set "COB_CFLAGS=-IC:\msys64\ucrt64\include -Wno-unused -fsigned-char -Wno-pointer-sign"
set "COB_LIBS=-LC:\msys64\ucrt64\lib -lcob"
where cobc >nul 2>&1
if errorlevel 1 (
  echo cobc nao esta no PATH. O GnuCOBOL fica em C:\msys64\ucrt64\bin
  exit /b 1
)
if not exist build mkdir build
cobc -x -free -O2 -I. -o build\cobol_doom.exe main.cob wad.cob vvideo.cob rdata.cob map.cob sprites.cob walk.cob door.cob gun.cob enemy.cob status.cob item.cob cheat.cob ui.cob sound.cob finale.cob save.cob view.cob src\compat.c src\wadio.c src\mapdraw.c src\audio.c src\video.c src\slotio.c -IC:\msys64\ucrt64\include\SDL2 -LC:\msys64\ucrt64\lib -lSDL2 -lwinmm
exit /b %ERRORLEVEL%
