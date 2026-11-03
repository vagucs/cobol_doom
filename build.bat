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
if not exist build\inc mkdir build\inc
if not exist build\inc\SDL3 mklink /J build\inc\SDL3 "%~dp0sdl3\include" >nul
if not exist "sdl3\SDL3-3.4.18-win32-x64\SDL3.dll" (
  echo SDL3.dll nao encontrada em sdl3\SDL3-3.4.18-win32-x64\
  exit /b 1
)
C:\msys64\ucrt64\bin\objdump.exe -p "sdl3\SDL3-3.4.18-win32-x64\SDL3.dll" > build\exports.txt
python -c "import re; t=open('build/exports.txt',encoding='utf-8',errors='replace').read(); n=re.findall(r'\+base\[\s*\d+\]\s+[0-9A-Fa-f]+\s+(\S+)', t); open('build/SDL3.def','w',newline='\n').write('LIBRARY SDL3.dll\nEXPORTS\n'+'\n'.join(n)+'\n') if n else (_ for _ in ()).throw(SystemExit(1))"
if errorlevel 1 (
  echo nao foi possivel ler as exportacoes da SDL3.dll
  exit /b 1
)
dlltool -d build\SDL3.def -l build\libSDL3.dll.a -m i386:x86-64
if errorlevel 1 (
  echo dlltool falhou ao gerar libSDL3.dll.a
  exit /b 1
)
del build\exports.txt
del build\SDL3.def
copy /y "sdl3\SDL3-3.4.18-win32-x64\SDL3.dll" build\SDL3.dll >nul
cobc -x -free -O2 -I. -Isrc -o build\cobol_doom.exe main.cob wad.cob vvideo.cob rdata.cob map.cob sprites.cob walk.cob door.cob gun.cob enemy.cob status.cob item.cob cheat.cob ui.cob sound.cob finale.cob save.cob view.cob random.cob src\compat.c src\tables_data.c src\wadio.c src\mapdraw.c src\audio.c src\video.c src\slotio.c -Ibuild\inc -Lbuild -lSDL3 -lwinmm
exit /b %ERRORLEVEL%
