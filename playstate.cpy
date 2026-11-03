*> Jogador que anda. O quadro inicial nasce do thing tipo 1.
01 play-state EXTERNAL.
   05 ply-on BINARY-LONG VALUE 0.
   05 ply-x BINARY-LONG VALUE 0.
   05 ply-y BINARY-LONG VALUE 0.
   05 ply-z BINARY-LONG VALUE 0.
   05 ply-ang BINARY-LONG VALUE 0.
   05 ply-momx BINARY-LONG VALUE 0.
   05 ply-momy BINARY-LONG VALUE 0.
   05 ply-floor BINARY-LONG VALUE 0.
   05 ply-ceil BINARY-LONG VALUE 0.
   05 ply-bob BINARY-LONG VALUE 0.
   05 ply-vbob BINARY-LONG VALUE 0.
   05 ply-tic BINARY-LONG VALUE 0.
   05 ply-turn BINARY-LONG VALUE 0.
   05 ply-rad BINARY-LONG VALUE 0.
   05 ply-h BINARY-LONG VALUE 0.
   05 ply-momz BINARY-LONG VALUE 0.
   05 ply-vh BINARY-LONG VALUE 2686976.
   05 ply-dvh BINARY-LONG VALUE 0.
   05 ply-ammo BINARY-LONG VALUE 50.
   05 gun-body PIC X(8) VALUE "PISGA0".
   05 gun-flash PIC X(8) VALUE SPACES.
   05 gun-mode BINARY-LONG VALUE 0.
   05 gun-lift BINARY-LONG VALUE 0.
   05 ply-weap BINARY-LONG VALUE 2.
   05 ply-pend BINARY-LONG VALUE 0.
   05 ply-hp BINARY-LONG VALUE 100.
   05 ply-shot BINARY-LONG VALUE 0.
   *> P_NoiseAlert uses the fire-time position (before walk XY that tic).
   05 ply-shot-x BINARY-LONG VALUE 0.
   05 ply-shot-y BINARY-LONG VALUE 0.
   05 ply-armor BINARY-LONG VALUE 0.
   05 ply-shell BINARY-LONG VALUE 0.
   05 ply-cell BINARY-LONG VALUE 0.
   05 ply-misl BINARY-LONG VALUE 0.
   05 ply-maxc BINARY-LONG VALUE 200.
   05 ply-maxs BINARY-LONG VALUE 50.
   05 ply-maxe BINARY-LONG VALUE 300.
   05 ply-maxr BINARY-LONG VALUE 50.
   05 ply-pack BINARY-LONG VALUE 0.
   05 ply-sg BINARY-LONG VALUE 0.
   05 ply-cg BINARY-LONG VALUE 0.
   05 ply-rl BINARY-LONG VALUE 0.
   05 ply-pg BINARY-LONG VALUE 0.
   05 ply-bf BINARY-LONG VALUE 0.
   05 ply-saw BINARY-LONG VALUE 0.
   05 ply-k0 BINARY-LONG VALUE 0.
   05 ply-k1 BINARY-LONG VALUE 0.
   05 ply-k2 BINARY-LONG VALUE 0.
   05 ply-k3 BINARY-LONG VALUE 0.
   05 ply-k4 BINARY-LONG VALUE 0.
   05 ply-k5 BINARY-LONG VALUE 0.
   05 ply-exit BINARY-LONG VALUE 0.
   05 ply-atype BINARY-LONG VALUE 0.
   05 ply-room BINARY-LONG VALUE 0.
   05 ply-time BINARY-LONG VALUE 0.
   05 ply-pain BINARY-LONG VALUE 0.
   05 ply-oldh BINARY-LONG VALUE 100.
   05 ply-fwait BINARY-LONG VALUE 0.
   05 ply-fkind BINARY-LONG VALUE 0.
   05 ply-god BINARY-LONG VALUE 0.
   05 ply-clip BINARY-LONG VALUE 0.
   05 ply-keep BINARY-LONG VALUE 0.
   05 ply-secret BINARY-LONG VALUE 0.
   05 ply-kills BINARY-LONG VALUE 0.
   05 ply-items BINARY-LONG VALUE 0.
   05 ply-secs BINARY-LONG VALUE 0.
   05 map-kills BINARY-LONG VALUE 0.
   05 map-items BINARY-LONG VALUE 0.
   05 map-secs BINARY-LONG VALUE 0.
   05 ply-blocks BINARY-LONG VALUE 10.
   05 ply-scale BINARY-LONG VALUE 2.
   05 ply-loc BINARY-LONG VALUE 0.
   05 ply-warp BINARY-LONG VALUE 0.
   05 ply-dest PIC X(8) VALUE SPACES.
   05 ply-msg PIC X(40) VALUE SPACES.
   05 ply-msgn BINARY-LONG VALUE 0.
   05 ply-inv BINARY-LONG VALUE 0.
   05 ply-suit BINARY-LONG VALUE 0.
   05 ply-lite BINARY-LONG VALUE 0.
   05 ply-invis BINARY-LONG VALUE 0.
   05 ply-str BINARY-LONG VALUE 0.
   05 ply-amap BINARY-LONG VALUE 0.
   05 ply-skill BINARY-LONG VALUE 2.
   05 ply-iddt BINARY-LONG VALUE 0.
   05 ply-mapon BINARY-LONG VALUE 0.
   05 ply-sfxvol BINARY-LONG VALUE 8.
   05 ply-musvol BINARY-LONG VALUE 8.
   *> Demo playback (Harbour/python -playdemo / -timedemo).
   05 demo-on BINARY-LONG VALUE 0.
   05 demo-timing BINARY-LONG VALUE 0.
   05 demo-single BINARY-LONG VALUE 0.
   05 demo-long BINARY-LONG VALUE 0.
   05 demo-p BINARY-LONG VALUE 0.
   05 demo-len BINARY-LONG VALUE 0.
   05 demo-gametic BINARY-LONG VALUE 0.
   05 demo-start-ms BINARY-LONG VALUE 0.
   05 cmd-fwd BINARY-LONG VALUE 0.
   05 cmd-side BINARY-LONG VALUE 0.
   05 cmd-turn BINARY-LONG VALUE 0.
   05 cmd-btns BINARY-LONG VALUE 0.
   *> Vanilla P_Random: um unico indice partilhado (gun/enemy/floor).
   05 ply-rnd BINARY-LONG VALUE 0.
   *> enemy-tic asks gun-tic to advance this BEXP slot, then returns.
   05 bexp-slot BINARY-LONG VALUE 0.
   *> Corpse A_Scream runs in mobj-list order, not during tick-fx.
   05 scream-slot BINARY-LONG VALUE 0.
   *> Missile PIT_CheckThing: victim slot, then the missile that hit it.
   05 hit-slot BINARY-LONG VALUE 0.
   05 hit-from BINARY-LONG VALUE 0.
   *> Hitscan damage already rolled. 0 = missile rolls (R%8+1)*damage.
   05 hit-dmg BINARY-LONG VALUE 0.
   *> Monster that dealt the hit. 0 = the player.
   05 hit-who BINARY-LONG VALUE 0.
   *> Monster hitscan: gun-tic aims (mode 1) or reports the hit (mode 2).
   05 ray-slot BINARY-LONG VALUE 0.
   05 ray-ang BINARY-LONG VALUE 0.
   05 ray-mode BINARY-LONG VALUE 0.
   05 ray-sl BINARY-LONG VALUE 0.
   05 ray-hit BINARY-LONG VALUE 0.
   05 ray-mo BINARY-LONG VALUE 0.
   *> P_DamageMobj source. 0 = none or the player himself.
   05 ply-atk BINARY-LONG VALUE 0.
