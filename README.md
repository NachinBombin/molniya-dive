# molniya-dive

Garry's Mod addon — **Molniya-1** loiter munition.

Part of the **Bombin Support** family. The erratic one — big wobble, lazy seeker, tiny pop.

## Flight personality

| Property | Molniya-1 | Lancet-3 | TB-2 | Shahed-136 |
|---|---|---|---|---|
| **Damage** | **80** | 150 | 350 | 700 |
| **Blast radius** | **200 HU** | 300 HU | 600 HU | 900 HU |
| **Aim error** | **±700 HU** | ±400 HU | ±400 HU | ±400 HU |
| **Track jitter** | **±300 HU** | ±120 HU | ±120 HU | ±120 HU |
| **Re-lock interval** | **0.5 s** | 0.1 s | 0.1 s | 0.1 s |
| **Dive wobble H** | **320** | 180 | 180 | 180 |
| **Dive wobble V** | **240** | 130 | 130 | 130 |
| **Speed lerp** | **0.006** | 0.018 | 0.018 | 0.018 |
| **Orbit jitter amp** | **28 HU** | 12 HU | 12 HU | 12 HU |

## Required files

```
models/sw/avia/molniya/molnia_drone.mdl
sound/sw/molniya/molniya_idle1.wav
```

## ConVars

| ConVar | Default | Description |
|---|---|---|
| `npc_bombinmolniya_enabled` | 1 | Enable NPC calls |
| `npc_bombinmolniya_chance` | 0.12 | Probability per check |
| `npc_bombinmolniya_interval` | 12 | Seconds between checks |
| `npc_bombinmolniya_cooldown` | 50 | Per-NPC cooldown |
| `npc_bombinmolniya_min_dist` | 400 | Min call distance |
| `npc_bombinmolniya_max_dist` | 3000 | Max call distance |
| `npc_bombinmolniya_delay` | 5 | Flare → arrival delay |
| `npc_bombinmolniya_lifetime` | 40 | Munition lifetime (s) |
| `npc_bombinmolniya_speed` | 250 | Orbit speed HU/s |
| `npc_bombinmolniya_radius` | 2500 | Orbit radius HU |
| `npc_bombinmolniya_height` | 2500 | Altitude HU |
| `npc_bombinmolniya_dive_damage` | **80** | Explosion damage |
| `npc_bombinmolniya_dive_radius` | **200** | Explosion radius HU |
| `npc_bombinmolniya_announce` | 0 | Debug prints |

## Menu

Spawnmenu → **Bombin Support** → **Molniya-1**

Or run `bombin_spawnmolniya` in console for a manual test spawn.

## Credits

NachinBombin
