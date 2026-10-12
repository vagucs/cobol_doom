# cobol_doom

DOOM generic portado de **[python_doom](https://github.com/vagucs/python_doom)** para **GnuCOBOL + SDL2**.

Por **Wagner Nunes da Silva**

- vagucs@bol.com.br
- vagucs@vagucs.com.br
- vagucs@gmail.com
- [www.vagucs.com.br](https://www.vagucs.com.br)
- [LinkedIn](https://www.linkedin.com/in/wagner-nunes-da-silva-b0a15360)

Esta árvore é aquele motor em Python, agora em COBOL. O laço do jogo fica em COBOL. Um arquivo C pequeno fala com a SDL2 para a janela, o teclado e a textura. Não há rato. O MCI do Windows toca o MIDI mais adiante, porque a SDL2 não toca.

English version: [README.md](README.md)

---

## O que é este projeto

`python_doom` é um motor de DOOM condensado e jogável, em Python. Este diretório é a **mesma peça de estudo**, começada em COBOL:

- Janela, teclas, cópia da tela: **SDL2**, chamada do COBOL com `CALL`
- Framebuffer: 320×200, esticado numa janela de 640×400
- Ponto fixo: o mesmo estouro 16.16 de `doom/compat.py`, em `src/compat.c`
- Rato: de fora

O programa confere o ponto fixo, lê um IWAD, carrega texturas e flats e desenha a vista em primeira pessoa do E1M1 (ou do MAP01, quando o IWAD é o Doom 2): paredes, piso, teto, céu, os objetos desse primeiro quadro e a pistola já levantada. As setas andam e giram. Shift corre. Alt, com as setas laterais, anda de lado, como a vírgula e o ponto. Espaço, ou E, abre a porta à frente: o teto sobe, espera e volta a descer. Ctrl dispara a pistola: o cano recua, o clarão aparece, o tiro acerta a parede ou quem está na frente, e quem morre cai. Zumbi e sargento acordam, andam e atiram. O diabrete corre, morde de perto ou solta uma bola de fogo. O demônio morde. Quando a vida do jogador acaba, a pistola some, os controles param e a vista desce até o chão. Cada passo segue o relógio do jogo e redesenha a vista, também enquanto a porta, o tiro ou um monstro se move. Uma porta fechada impede a passagem. Esc, ou fechar a janela, sai. A barra embaixo mostra a vida, a munição da pistola, a armadura e a cara, que fica mais machucada quando um tiro acerta e vira a cara de morto quando a vida acaba. Andar sobre um item apanha: estimulante e kit sobem a vida até 100, a esfera passa de 100, a armadura verde vale 100 e a azul 200, a munição entra no contador e a chave aparece na barra. Uma arma acende o número amarelo, soma a munição dela e sobe na mão. As teclas 1 a 7 trocam a arma: 1 é o soco, 2 a pistola, 3 a espingarda, 4 a metralhadora e 5 o míssil. A espingarda solta sete balas, a metralhadora gasta balas e a motosserra corta de perto. Foguete, plasma e BFG disparam. O foguete voa e estoura, o plasma é um raio rápido e o BFG varre quem está na frente. O interruptor da saída troca a face e, um segundo depois, abre o mapa seguinte. As armas, a munição, a vida e as chaves acompanham. O lodo verde tira vida a cada segundo, parado ou andando, e a armadura absorve uma parte. Quando a vida cai, a tela fica vermelha por um instante e volta ao normal. No golpe, a cara olha para quem atirou, o impacto empurra o jogador para trás e, no lodo, a cara mostra os dentes por um segundo. iddqd liga a imortalidade e a cara de deus. idkfa dá todas as armas, a munição, a armadura e as chaves. idfa faz o mesmo sem as chaves. idclip e idspispopd atravessam paredes. A plataforma desce, espera e sobe. A escada sobe em degraus. O teleporte leva ao destino. A porta trancada só abre com a chave, e a grade mostra os vãos. A tela inicial abre o menu. Novo jogo derrete para a fase. Esc abre o menu. Menos e igual mudam o tamanho da vista, e a opção Resolução muda a janela. A saída mostra a contagem e derrete para o mapa seguinte. O espectro aparece translúcido e morde. O barão e o cavaleiro do inferno mordem de perto e soltam uma bola de fogo. Os efeitos sonoros e a música tocam: tiro, porta, monstro, item, dor, morte e a música da fase. Segurar Ctrl mantém o tiro, salvo o lança-mísseis e o BFG, que esperam um novo aperto.

É preciso um IWAD legal (shareware `doom1.wad` ou comercial `doom.wad` / `doom2.wad`). Este repositório não traz WAD comercial.

É um **port educacional condensado**: o motor será COBOL, a camada nativa é a SDL2.

Fora desta árvore:

- Rato
- Rede, joystick, CD de áudio

---

## Proposta educacional

Este projeto é uma **peça de estudo**. O port em Python já tirou o pré-processador e os arrays 1-based do Harbour. O port em COBOL pergunta outra coisa: **o que sobrevive quando os registros são tabelas `OCCURS` e a conta quer ser decimal**.

O que ele pretende ensinar:

- **Python, depois COBOL.** Abra `python_doom/doom/` ao lado de `cobol_doom/`. Os nomes ficam perto (`fixed_mul`, `as_i32`) para os dois arquivos ficarem lado a lado.
- **Estouro de 32 bits, fora do `COMPUTE`.** Um `COMPUTE` do COBOL em item decimal não reproduz o deslocamento 16.16. `src/compat.c` é a mesma conta de `compat.py`, e o COBOL chama.
- **Tabelas 1-based, dados 0-based.** O `OCCURS` do COBOL começa em 1. Os lumps do WAD continuam 0-based nos dados e ficam no slot `número + 1`, como nos ports Lua e Julia.
- **Onde o COBOL basta.** O laço, o mapa e a vista ficam em COBOL. A SDL2 é a janela e o teclado. Seno, tangente e arco-tangente ficam em `src/compat.c`.

Caminho sugerido:

1. Rode `run.bat` e leia `main.cob` — a conferência do ponto fixo, o IWAD e a vista do E1M1.
2. Compare `view.cob` com `python_doom/doom/render.py`, `sprites.cob` com `doom/sprites.py`, `map.cob` com `doom/world.py`, e `rdata.cob` com `doom/r_data.py`.
3. Compare `wad.cob` com `doom/wad.py`, e `src/compat.c` com `doom/compat.py`. O `src/video.c` não lê o rato.

---

## Tecnologia

| Camada | Este port | Python (`python_doom`) |
| --- | --- | --- |
| Linguagem | GnuCOBOL 3.2 | Python 3.10+ |
| Janela, teclas, cópia | SDL2, `CALL` a partir do COBOL | pygame 2.x |
| Ponto fixo 16.16 | `src/compat.c` | `doom/compat.py` |
| Rato | de fora | usado para olhar e atirar |
| IWAD | `wad.cob`, `rdata.cob` e `view.cob`, vista do E1M1 | os mesmos lumps |
| Compilação | `run.bat` (`cobc` + o gcc UCRT64) | `pip install -r requirements.txt` |

O compilador usado aqui é o pacote MSYS2 `mingw-w64-ucrt-x86_64-gnucobol`, com o `gcc` e a `SDL2` de `C:\msys64\ucrt64`. O `run.bat` coloca essa pasta `bin` no `PATH` para achar a `SDL2.dll`.

---

## Como rodar

Neste diretório, no Windows:

```
run.bat
```

O `build.bat` só compila. A janela é 640×400. A textura é 320×200.

O IWAD é o primeiro arquivo que existir entre `DOOM1.WAD`, `doom1.wad`, `DOOM.WAD`, `doom.wad`, `DOOM2.WAD`, `doom2.wad`, `PLUTONIA.WAD`, `TNT.WAD`, `freedoom1.wad` e `freedoom2.wad`. A busca começa em `DOOMWADDIR` ou `DOOMWADPATH`, se a variável existir, e segue pela pasta atual e pelas pastas acima. `-iwad` escolhe o arquivo, como nos outros portes. Um caminho solto terminado em `.wad` também serve. `-fps` mostra os quadros por segundo no canto superior direito.

```
run.bat -iwad C:\wads\doom1.wad -fps
```

Os cheats de sempre valem em pé: `iddqd`, `idkfa`, `idfa`, `idclip`, `idspispopd`, `idchoppers`, `idmypos`, `idbehold` e a letra seguinte (`v` invulnerável, `s` força, `i` invisível, `r` traje, `l` luz), `idmus` e `idclev` com dois números. `idclev16` abre o E1M6. `iddt` não tem mapa automático nesta versão.

---

## Teclas

| Tecla | Ação |
| --- | --- |
| **Seta para cima** ou **W** | Andar para a frente |
| **Seta para baixo** ou **S** | Andar para trás |
| **Seta esquerda** ou **A** | Girar à esquerda |
| **Seta direita** ou **D** | Girar à direita |
| **Shift** | Correr |
| **Alt** com esquerda ou direita | Andar de lado |
| **Vírgula** e **ponto** | Andar de lado |
| **Espaço** ou **E** | Abrir a porta à frente |
| **Ctrl** | Disparar a pistola |
| **Esc** | Sair |
| Fechar a janela | Sair |

O rato é ignorado.

---

## Organização

```
main.cob             entrada, a vista, o andar, o uso, o disparo e os monstros
walk.cob             um tic de movimento e paredes
door.cob             portas verticais, sobem e descem o teto
gun.cob              pistola, o tiro, o sangue e o fumo
enemy.cob            monstros acordam, andam e atacam
status.cob           barra de vida, munição, armadura e a cara
item.cob             itens do chão: vida, armadura, munição, chaves e armas
playstate.cpy        posicao do jogador
wad.cob              doom/wad.py
wadstate.cpy         tabela de lumps (OCCURS, slot = lump + 1)
view.cob             doom/render.py, paredes, piso, teto, céu, sprites, pistola
sprites.cob          doom/sprites.py, quadros e objetos do mapa
sprstate.cpy         quadros dos sprites e objetos
sprdata.cpy          estado inicial de cada doomednum
map.cob              doom/world.py, planta conservada na árvore
mapstate.cpy         vértices, linhas, setores
rdata.cob            doom/r_data.py
rdata.cpy            texturas, flats, colormap
vvideo.cob           V_DrawPatch e traço
build.bat            cobc
run.bat              PATH, compila e abre a janela
src/compat.c         doom/compat.py, mais seno, tangente e arco-tangente
src/wadio.c          leitura binária e caminhos
src/mapdraw.c        escala da planta e cores da paleta
src/video.c          janela, paleta e teclado SDL2
```

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
