# Music Label Tycoon - Game Design Document

## Overview

A pixel art 2D idle/tycoon game for Android built in Godot 4.3+. The player runs a music label where CDs are both the product and currency. Sign artists, upgrade your studio, tap to collect CDs, and gamble for massive payouts.

**Target Platform:** Android (portrait orientation)
**Engine:** Godot 4.3+ with GDScript
**Art Style:** 16-bit pixel art
**Monetization:** Free-to-play with rewarded ads + optional IAP

---

## Core Game Loop

```
TAP CDs on screen  ->  Earn CDs (currency)  ->  Sign Artists (passive income)
       ^                                              |
  Gambling/Rewards  <-  Upgrade Studio  <-  Accumulate CDs passively
```

The player taps CDs that appear on the main screen to collect them. CDs come in 6 tiers with increasing rarity and value. Artists produce CDs passively (even offline). Earnings are spent on signing more artists, upgrading the studio, or gambling for big wins.

---

## CD Tier System

CDs are the core currency. They appear on the main screen and players tap to collect.

| Tier | CD Type  | Value  | Drop Rate   | Visual                          |
|------|----------|--------|-------------|---------------------------------|
| 1    | Demo CD  | 1      | Very Common | Plain silver disc               |
| 2    | Single   | 5      | Common      | Blue case                       |
| 3    | EP       | 25     | Uncommon    | Green case + sparkle            |
| 4    | Album    | 150    | Rare        | Gold case + glow                |
| 5    | Platinum | 1,000  | Very Rare   | Platinum + particle effects     |
| 6    | Diamond  | 10,000 | Legendary   | Diamond + rainbow aura          |

**Spawn rates** are affected by studio upgrades (Marketing Reach) and temporary boosts from gambling/ads.

---

## Artist System (Passive Income)

Artists are signed with CDs and produce CDs passively over time.

### Artist Tiers

| Tier | Name         | Base Cost | Production | Unlock Requirement   |
|------|--------------|-----------|------------|----------------------|
| 1    | Street Busker| 50        | 1 CD/sec   | Start                |
| 2    | Garage Band  | 500       | 8 CD/sec   | 200 total CDs earned |
| 3    | Indie Artist | 5K        | 50 CD/sec  | 5K total earned      |
| 4    | Studio Pro   | 50K       | 400 CD/sec | 50K total earned     |
| 5    | Chart Topper | 500K      | 3.5K CD/sec| 500K total earned    |
| 6    | Superstar    | 5M        | 30K CD/sec | 5M total earned      |
| 7    | Legend       | 50M       | 250K CD/sec| 50M total earned     |

### Artist Upgrades

- Each artist can be upgraded to level 100
- Each level increases production by ~10%
- Milestone bonuses at levels 25/50/75/100: 2x/3x/4x/5x multiplier
- Cost scales: `base_cost * (1.15 ^ level)`

---

## Studio Upgrades (Global Bonuses)

| Upgrade             | Effect                                    | Max Level |
|---------------------|-------------------------------------------|-----------|
| Recording Quality   | All artist production +X%                 | 50        |
| Marketing Reach     | Higher tier CDs drop more often           | 50        |
| Distribution Network| Offline earnings cap increased            | 30        |
| A&R Department      | Chance for artists to produce higher-tier  | 20        |

---

## Gambling & Reward Systems

All gambling systems unlock progressively as the player advances.

### 1. Daily Spin Wheel (Unlocks: Immediately)

- Free spin every 4 hours (or watch ad for extra spin)
- Prizes: CDs (various amounts), temporary 2x boost, rare artist fragment, premium currency
- Weighted odds visible to player

### 2. Mystery Crate / Gacha (Unlocks: 1K total CDs)

- Cost: 500 CDs per pull, 10-pull at 4,500 CDs
- Drops: Common artist fragments, rare artists, CD multiplier items, cosmetic decorations
- Pity system: Guaranteed rare at 30 pulls, guaranteed legendary at 100 pulls
- Showcase banners rotate weekly with featured artists at boosted rates

### 3. CD Slot Machine (Unlocks: 10K total CDs)

- Bet 50-5,000 CDs per spin
- 3 reels with CD symbols; match 3 = win multiplier (2x-50x bet)
- Special "Platinum Jackpot" symbol = massive payout
- House edge ~15%

### 4. Card Flip Game (Unlocks: 50K total CDs)

- 12 face-down cards, flip pairs to find matches
- Each match = prize (CDs, boosts, fragments)
- Find the "bomb" card = game over, keep what you've won
- Risk/reward: keep going or cash out

### 5. Lucky Scratch Cards (Unlocks: 100K total CDs)

- 1 free scratch card daily, buy more with premium currency
- Scratch to reveal: instant CDs, artist fragments, time warps, jackpot

### Reward Systems

- **Daily login streak:** 7-day cycle, day 7 = premium reward, resets on miss
- **Achievement milestones:** Sign X artists, earn X CDs, win X gambling rounds
- **Prestige ("Go Platinum"):** Reset progress for permanent multipliers at endgame

---

## Monetization

### Rewarded Ads
- Watch ad for 2x CD production for 30 seconds
- Watch ad for free spin wheel spin
- Watch ad for 2x offline earnings on return
- Watch ad to double gambling winnings

### Optional IAP
- **Ad Removal:** One-time purchase, removes interstitials
- **Starter Pack:** Bonus CDs + 1 rare artist + premium currency (one-time)
- **Premium Currency Packs:** For gacha pulls, scratch cards, cosmetics
- **VIP Pass (monthly):** 2x idle earnings, daily premium currency, exclusive cosmetics

### Banner Ads
- Small banner at bottom of non-gambling screens (removed with ad removal purchase)

---

## Asset Pipeline

### Pixel Art
1. Generate base sprites with DALL-E 3 (OpenAI) using consistent style prompts
2. Refine in Aseprite or LibreSprite for pixel-perfect consistency
3. Create sprite sheets and animations

### Music & SFX
1. Chiptune tracks created in BeepBox (free, browser-based) or LMMS
2. SFX generated with sfxr/jsfxr (free retro sound generators)

### Style Guide
- 16-bit pixel art aesthetic
- Limited color palette (32 colors max)
- 32x32 base sprite size for CDs and small items
- 64x64 for artist characters
- Black outlines on all sprites
- Consistent lighting from top-left

---

## Technical Architecture

### Godot Project Structure

```
tycoon/
├── project.godot
├── export_presets.cfg
├── assets/
│   ├── sprites/
│   │   ├── cds/
│   │   ├── artists/
│   │   ├── ui/
│   │   └── effects/
│   ├── audio/
│   │   ├── music/
│   │   └── sfx/
│   └── fonts/
├── scenes/
│   ├── main/                  # Main game screen (tap CDs)
│   ├── artists/               # Artist roster & management
│   ├── studio/                # Studio upgrades
│   ├── casino/                # Gambling mini-games
│   │   ├── spin_wheel.tscn
│   │   ├── gacha.tscn
│   │   ├── slots.tscn
│   │   ├── card_flip.tscn
│   │   └── scratch_card.tscn
│   ├── shop/                  # IAP & ad rewards
│   └── ui/                    # Shared UI components
│       ├── hud.tscn
│       ├── nav_bar.tscn
│       └── popup.tscn
├── scripts/
│   ├── autoload/
│   │   ├── game_manager.gd    # Core state
│   │   ├── save_manager.gd    # Save/load
│   │   ├── ad_manager.gd      # AdMob
│   │   └── audio_manager.gd   # Audio control
│   ├── data/
│   │   ├── cd_data.gd
│   │   ├── artist_data.gd
│   │   └── upgrade_data.gd
│   └── systems/
│       ├── cd_spawner.gd
│       ├── idle_calculator.gd
│       ├── prestige.gd
│       └── gambling/
└── addons/
    └── godot-admob/
```

### Autoloads (Singletons)
- **GameManager:** All player state. Emits signals on state changes.
- **SaveManager:** JSON serialization to `user://save.json`. Auto-save every 30s + on background.
- **AdManager:** AdMob SDK wrapper for rewarded/interstitial/banner ads.
- **AudioManager:** BGM and SFX. Persists across scene changes.

### Scene-Per-Screen Architecture
- Each game screen is a separate `.tscn` scene
- Bottom navigation bar switches between scenes
- HUD overlay persists across all screens
- GameManager signals keep all screens in sync

### Android-Specific
- Godot 4.3+ with Android export template
- AdMob via godot-admob-android plugin
- Touch-only input (tap, swipe)
- Portrait orientation locked
- Save to internal storage via `user://`
- Offline calculation: compare save timestamp to current time on resume

---

## Screen Flow

```
┌─────────────────────────────────────────────┐
│              MAIN GAME SCREEN               │
│  ┌─────────────────────────────────────┐    │
│  │     [CD Count: 1,234,567]  [Level]  │    │
│  ├─────────────────────────────────────┤    │
│  │                                     │    │
│  │    CD   CD       CD                 │    │
│  │         CD   CD      CD             │    │
│  │    CD        CD    CD               │    │
│  │                                     │    │
│  ├─────────────────────────────────────┤    │
│  │ [Studio] [Artists] [Casino] [Shop]  │    │
│  └─────────────────────────────────────┘    │
└─────────────────────────────────────────────┘
```

---

## Version Roadmap

### MVP (v1.0) - Core playable game
1. Main tap screen with 6 CD tiers
2. 3 artist tiers (Busker, Garage Band, Indie Artist)
3. 2 studio upgrades (Recording Quality, Marketing)
4. Daily spin wheel
5. Basic gacha (mystery crate)
6. Daily login rewards
7. Save/load system
8. Placeholder pixel art (colored shapes with labels)
9. AdMob rewarded ads
10. Android export

### v1.1 - Expanded content
- Remaining 4 artist tiers
- Slot machine + card flip gambling
- Achievement system
- DALL-E generated pixel art assets
- Background music (chiptune)

### v1.2 - Polish & endgame
- Scratch cards
- Prestige system ("Go Platinum")
- IAP shop
- More studio upgrades (Distribution, A&R)
- Particle effects and visual polish
- Sound effects
