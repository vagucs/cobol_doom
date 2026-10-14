# cobol_doom

![DOOM rodando em GnuCOBOL com SDL2](screenshot/doom.png)

**Vídeo:** [DOOM rodando em GnuCOBOL — 80 a 180 FPS](https://youtu.be/fAJ51Vo9T58)

DOOM generic portado de **[python_doom](https://github.com/vagucs/python_doom)** para **GnuCOBOL + SDL2**.

Por **Wagner Nunes da Silva**

- vagucs@bol.com.br
- vagucs@vagucs.com.br
- vagucs@gmail.com
- [www.vagucs.com.br](https://www.vagucs.com.br)
- [LinkedIn](https://www.linkedin.com/in/wagner-nunes-da-silva-b0a15360)

Sim: o jogo é feito em COBOL. O laço, o mapa, a vista, as portas, as armas, os monstros, o menu e o placar estão nos `.cob`. Seis arquivos em `src/` são a borda que o GnuCOBOL não cobre: a janela SDL2, o som, a leitura binária do WAD, a conta de 32 bits, a escala da planta e o arquivo dos saves. O rato fica de fora.

English version: [README.md](README.md)

---

## O que é este projeto

`python_doom` é um motor de DOOM condensado e jogável, em Python. Este diretório é a **mesma peça de estudo**, reescrita em COBOL:

- Janela, teclas, cópia da tela e PCM: **SDL2**, chamada do COBOL com `CALL`
- Framebuffer: 320×200, esticado numa janela de 640×400
- Passo: cerca de 28 ms, perto do tic de 35 Hz
- Vista: BSP, paredes, piso, teto, céu, sprites e a arma na mão
- Mapa: VERTEXES, LINEDEFS, SIDEDEFS, SECTORS, SEGS, SSECTORS, NODES, THINGS, BLOCKMAP, REJECT
- Jogo: andar, portas, elevadores, escadas, teleporte, interruptores, saída, itens, armas, barra, automapa no Tab, som `DS*`, música MUS→MIDI, menu no Esc, dificuldade, seis slots de save, contagem, derretimento ao trocar de tela, final do episódio (o coelho do episódio 3 inclusive) e inimigos que olham, perseguem e atacam

É preciso um IWAD legal (shareware `doom1.wad` ou comercial `doom.wad` / `doom2.wad`). Este repositório não traz WAD comercial.

É um **port educacional condensado**: o motor é COBOL. A camada em C é só o que o `CALL` precisa para sair do programa.

Fora desta árvore:

- Rato
- Rede, joystick, CD de áudio
- Save binário do vanilla (os slots são texto, `doomsav0.dsg` a `doomsav5.dsg`, com o cabeçalho `COBDOOM1`)

---

## Proposta educacional

Este projeto é uma **peça de estudo**. O port em Python já tirou o pré-processador e os arrays 1-based do Harbour. O port em COBOL pergunta outra coisa: **o que sobrevive quando os registros são tabelas `OCCURS` e a conta quer ser decimal**.

O que ele pretende ensinar:

- **Python, depois COBOL.** Abra `python_doom/doom/` ao lado de `cobol_doom/`. Os nomes ficam perto (`fixed_mul`, `as_i32`) para os dois arquivos ficarem lado a lado.
- **Estouro de 32 bits, fora do `COMPUTE`.** Um `COMPUTE` do GnuCOBOL em `BINARY-LONG` arredonda. O produto 16.16 precisa estourar como no C. Essa conta mora em `src/compat.c`, igual a `doom/compat.py`, e o COBOL chama.
- **Tabelas 1-based, dados 0-based.** O `OCCURS` começa em 1. Os lumps do WAD continuam 0-based nos dados e ficam no slot `número + 1`.
- **Onde o COBOL basta.** Quem atira, qual porta abre e o que entra no framebuffer ficam nos `.cob`. O C não decide regra de jogo.

Caminho sugerido:

1. Rode `run.bat` e leia `main.cob` — o IWAD, o menu e o laço de 28 ms.
2. Compare `view.cob` com `python_doom/doom/render.py`, `map.cob` com `doom/world.py` e `wad.cob` com `doom/wad.py`.
3. Compare `src/compat.c` com `doom/compat.py`. O `src/video.c` não lê o rato.

---

## De Python para COBOL

Listas em Python são 0-based. `OCCURS` é 1-based. Um objeto vira um grupo `EXTERNAL` compartilhado pelos programas, no `COPY`.

| Python (`python_doom`) | COBOL (`cobol_doom`) |
| --- | --- |
| `thing.x` | `mo-x(i)` ou `ply-x` |
| `None` | espaços, ou zero |
| `items[0]` | `OCCURS`, slot = índice + 1 |
| classe | `PROGRAM-ID` e um `COPY` `EXTERNAL` |
| `int` sem limite | `BINARY-LONG`, 32 bits; o produto largo fica em C |
| `&`, `\|`, `^` | `CALL "bit_and"`, `bit_or`, `bit_xor` |
| `x >> n` | `CALL "ushr32"` / `CALL "shar32"` |
| `a // b` | `DIVIDE` sem `ROUNDED`, ou `CALL "floor_div_i"` |
| `fixed_mul` / `fixed_div` | `CALL "fixed_mul"` / `CALL "fixed_div"` |
| framebuffer `bytearray` | `PIC X(64000)` |
| pygame | SDL2, por `CALL` |
| `+=` | `CALL "add_i32"` — um `COMPUTE` arredonda |

Escrever um campo do `COPY` `EXTERNAL` aparece nos outros programas, do mesmo jeito que um objeto em Python.

### Lado a lado: o impulso

Python (`doom/player.py`):

```python
def thrust(mo: Mobj, angle: int, move: int) -> None:
    mo.momx += fixed_mul(move, fine_cos(angle))
    mo.momy += fixed_mul(move, fine_sin(angle))
```

COBOL (`walk.cob`), no tic de andar:

```cobol
CALL "fine_cos_ang" USING BY VALUE ply-ang RETURNING cs
CALL "fine_sin_ang" USING BY VALUE ply-ang RETURNING sn
CALL "fixed_mul" USING BY VALUE move-n BY VALUE cs RETURNING tmp
CALL "add_i32" USING BY VALUE ply-momx BY VALUE tmp RETURNING ply-momx
CALL "fixed_mul" USING BY VALUE move-n BY VALUE sn RETURNING tmp
CALL "add_i32" USING BY VALUE ply-momy BY VALUE tmp RETURNING ply-momy
```

O Python soma no campo do objeto. O COBOL faz as mesmas duas multiplicações 16.16, e a soma volta por `add_i32` para caber em 32 bits. Seno e cosseno do ângulo também vêm do C, porque a tabela fina não cabe num `COMPUTE` decimal.

---

## O que ficou em C, e por quê

O motor é COBOL. Cada arquivo abaixo é uma função que o `CALL` alcança. Nenhum deles escolhe a fase, a arma ou o monstro.

| Arquivo | Papel | Por que não ficou em COBOL |
| --- | --- | --- |
| `src/video.c` | Janela SDL2, paleta, teclado, Alt+Enter | O compilador não liga a SDL2 |
| `src/audio.c` | Fila PCM dos lumps `DS*` e MIDI pela MCI | Dispositivo de som e `winmm` |
| `src/wadio.c` | Leitura binária e caminho do IWAD | `PIC X` preenche com espaço; o lump é byte cru |
| `src/compat.c` | Estouro de 32 bits, 16.16, seno, arco-tangente, lado do nó | `COMPUTE` arredonda e o produto estoura diferente do C |
| `src/mapdraw.c` | Encaixa a planta na tela, a seta e a coluna do patch | Escala em ponto flutuante e os posts do patch |
| `src/slotio.c` | Abre `doomsavN.dsg` e lê uma linha | O texto do save é montado no COBOL; o arquivo precisa de fim de linha de verdade |

`sound.cob` decide qual efeito toca. `audio.c` só mistura. `save.cob` monta o texto do slot. `slotio.c` só grava e lê a linha. `map.cob` escolhe a cor de cada parede. `mapdraw.c` só transforma coordenada em pixel.

---

## Tecnologia

| Camada | Este port | Python (`python_doom`) |
| --- | --- | --- |
| Linguagem | GnuCOBOL 3.2 | Python 3.10+ |
| Janela, teclas, cópia | SDL2, `CALL` a partir do COBOL | pygame 2.x |
| Som | SDL2 para os efeitos, MCI para o MIDI | mixer do pygame, MCI no Windows |
| Ponto fixo 16.16 | `src/compat.c` | `doom/compat.py` |
| Rato | de fora | usado para olhar e atirar |
| IWAD | os mesmos lumps | os mesmos lumps |
| Compilação | `run.bat` (`cobc` + o gcc UCRT64) | `pip install -r requirements.txt` |

O compilador usado aqui é o pacote MSYS2 `mingw-w64-ucrt-x86_64-gnucobol`, com o `gcc` e a `SDL2` de `C:\msys64\ucrt64`. O `run.bat` coloca essa pasta `bin` no `PATH` para achar a `SDL2.dll`.

---

## Como rodar

Neste diretório, no Windows:

```
run.bat
```

O `build.bat` só compila. A janela é 640×400. A textura é 320×200.

O IWAD é o primeiro arquivo que existir entre `DOOM1.WAD`, `doom1.wad`, `DOOM.WAD`, `doom.wad`, `DOOM2.WAD`, `doom2.wad`, `PLUTONIA.WAD`, `TNT.WAD`, `freedoom1.wad` e `freedoom2.wad`. A busca começa em `DOOMWADDIR` ou `DOOMWADPATH`, se a variável existir, e segue pela pasta atual e pelas pastas acima. `-iwad` escolhe o arquivo. Um caminho solto terminado em `.wad` também serve. `-fps` mostra os quadros por segundo no canto superior direito. A janela nasce com vsync, então esse número pode travar na taxa do monitor. `-novsync` apresenta sem essa espera.

```
run.bat -iwad C:\wads\doom1.wad -fps
run.bat -fps -novsync
```

Se o IWAD tem `MAP01`, o jogo novo pula o menu de episódio e abre a dificuldade, depois o MAP01. No shareware, o episódio 1 é o único; os outros avisam que pedem a versão registrada.

---

## Teclas

As letras não andam. Elas alimentam os truques. O movimento fica nas setas.

| Tecla | Ação |
| --- | --- |
| **Setas** | Frente, trás, virar |
| **Shift** | Correr |
| **Alt** com esquerda ou direita | Andar de lado |
| **Vírgula** e **ponto** | Andar de lado |
| **Espaço** ou **E** | Usar o que está à frente |
| **Ctrl** | Atirar. Segurar repete, salvo o BFG |
| **1** a **7** | Soco, pistola, espingarda, metralhadora, míssil, plasma, BFG. O **1** pega a motosserra quando ela já foi apanhada |
| **Tab** | Automapa. O jogo continua por baixo |
| **-** / **=** | Vista menor ou maior |
| **Alt+Enter** | Tela cheia |
| **Esc** | Menu. Na tela de título, sai |
| Fechar a janela | Sair |

O rato é ignorado. Sair do jogo está no item Sair do menu.

### Truques

Digite durante a fase, com o menu fechado. Sem Enter.

| Código | Efeito |
| --- | --- |
| **IDDQD** | Modo deus |
| **IDKFA** | Todas as armas, munição, chaves e armadura |
| **IDFA** | Armas, munição e armadura |
| **IDCLIP** / **IDSPISPOPD** | Sem colisão |
| **IDCHOPPERS** | Motosserra |
| **IDMYPOS** | Coordenadas e ângulo |
| **IDDT** | No mapa: todas as paredes, depois as coisas, depois o normal |
| **IDBEHOLD** | Depois **V** **S** **I** **R** **A** **L** (invulnerável, força, invisível, traje, mapa do computador, luz) |
| **IDMUS** + 2 dígitos | Troca a música |
| **IDCLEV** + 2 dígitos | Warp. `16` abre o E1M6. Num IWAD com `MAP01`, o número é o mapa |

Os seis slots ficam no menu Carregar e Salvar. A descrição gravada é o nome do mapa.

---

## Organização

```
main.cob             laço, menu, teclas e a troca de fase
walk.cob             um tic de movimento
door.cob             portas, elevadores, escadas, teleporte, interruptores
gun.cob              armas, o tiro e a explosão
enemy.cob            monstros
status.cob           barra e a cara
item.cob             itens do chão
cheat.cob            truques
ui.cob               título, menus, placar e o derretimento
sound.cob            qual efeito ou música tocar
finale.cob           texto final, elenco e o coelho
save.cob             texto dos seis slots
view.cob             vista 3D
sprites.cob          quadros e o que nasce no mapa
map.cob              leitura do mapa e o desenho da planta
rdata.cob            texturas, flats e colormap
wad.cob              diretório do IWAD
vvideo.cob           patch e traço no framebuffer
screenshot/doom.png  a imagem do topo
src/                 a borda em C, descrita acima
```

| Caminho | Python |
| --- | --- |
| `src/compat.c` | `doom/compat.py` |
| `wad.cob` | `doom/wad.py` |
| `src/video.c`, `src/audio.c` | `doom/video.py`, `doom/sound.py` |
| `vvideo.cob` | `doom/v_video.py` |
| `rdata.cob` | `doom/r_data.py` |
| `view.cob` | `doom/render.py` |
| `map.cob` | `doom/world.py` e a planta de `doom/am_map.py` |
| `walk.cob`, `gun.cob` | `doom/player.py` |
| `door.cob` | `doom/specials.py` |
| `sprites.cob` | `doom/sprites.py` |
| `enemy.cob` | `doom/enemy.py` |
| `status.cob` | `doom/status.py` |
| `sound.cob` | o que `doom/sound.py` escolhe tocar |
| `ui.cob` | `doom/menu.py`, `doom/wi_stuff.py`, `doom/wipe.py` |
| `finale.cob` | `doom/finale.py` |
| `save.cob`, `src/slotio.c` | `doom/saveg.py` |
| `cheat.cob` | a máquina de truques em `doom/game.py` |
| `main.cob` | a entrada do Python |

---

## Linhagem

1. **[python_doom](https://github.com/vagucs/python_doom)** — Python + pygame
2. **cobol_doom** — GnuCOBOL + SDL2 (esta árvore)

---

## Doe

### Patrocínio no GitHub

[github.com/sponsors/vagucs](https://github.com/sponsors/vagucs)

### Ethereum

`0x1b64038A2b1DB73ABd0068d8B9B0d1dC5a90C5F1`

![QR Code Ethereum](docs/qr-ethereum.png)

### PIX

Chave: `vagucs@bol.com.br`

![QR Code PIX](docs/qr-pix.png)
