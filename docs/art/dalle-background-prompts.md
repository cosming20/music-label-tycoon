# DALL-E 3 Prompts - Background Screens

**Game:** Music Label Tycoon
**Resolution:** 540x960 (portrait mobile)
**Art Style:** 16-bit pixel art
**Engine:** Godot 4.3+

All backgrounds must work with overlaid UI elements: a HUD bar at the top (~80px) showing the CD counter, and a navigation bar at the bottom (~100px) with tab buttons. These regions should naturally be darker or less detailed so UI remains readable.

---

## Style Anchor (prepended to every prompt)

> 16-bit pixel art style, detailed background scene, limited color palette, portrait orientation, game background asset, atmospheric lighting, no characters, no text, no UI elements

---

## 1. Main Screen - Recording Studio

**Scene:** The player's home base where CDs float on screen and get tapped.

**Base Color:** Dark blue-gray `Color(0.12, 0.12, 0.18)` / `#1F1F2E`

### DALL-E Prompt

```
16-bit pixel art style, detailed background scene, limited color palette, portrait orientation, game background asset, atmospheric lighting, no characters, no text, no UI elements.

Interior of a cozy music recording studio viewed from straight on. A large analog mixing console dominates the lower-center of the scene with dozens of faders and knobs. Behind it, a pair of tall studio monitor speakers flanking a window that looks into a vocal booth with a hanging microphone and pop filter. The walls are covered in acoustic foam panels, framed gold and platinum vinyl records, and a shelf of cassette tapes. A reel-to-reel tape machine sits in the corner. Warm amber light from a desk lamp and overhead recessed cans casts soft pools of golden light, while the rest of the room stays in deep blue-gray shadow. Cables snake across the floor. A lava lamp glows orange on a side table. The ceiling and floor edges fade to near-black darkness to allow UI overlay. The overall palette is dark blue-gray (#1F1F2E) with warm amber and gold highlights. The center area is relatively open and uncluttered to allow game objects to float over it clearly.
```

### Mood / Atmosphere Notes

- Warm, inviting, "creative sanctuary" feeling
- Amber and gold light pools against cool blue-gray shadows create depth
- The open center space (roughly the middle 60% of the screen) must remain visually calm so floating CD sprites are clearly visible and tappable
- Top and bottom 10-15% of the image should be the darkest areas -- ceiling shadow at the top, dark floor / console edge at the bottom
- Should feel like late-night studio session energy

---

## 2. Artist Roster - Talent Agency / Backstage

**Scene:** Where the player manages their signed artists.

**Base Color:** Dark blue-purple `Color(0.1, 0.12, 0.2)` / `#1A1F33`

### DALL-E Prompt

```
16-bit pixel art style, detailed background scene, limited color palette, portrait orientation, game background asset, atmospheric lighting, no characters, no text, no UI elements.

A backstage talent agency lounge and green room viewed from the front. A worn leather couch and coffee table sit in the center-left. The walls are covered with framed band posters, concert photos, and a corkboard with pinned headshots and contracts. Stage lights in warm pink, purple, and blue spill through a partially open door in the background revealing the edge of a concert stage with speaker stacks. A vanity mirror with round bulbs lines one wall. A guitar leans against an amp in the corner. A potted plant and a mini fridge add life to the scene. The lighting is moody and theatrical: cool blue-purple ambient with warm stage light streaks cutting through. The ceiling is dark with exposed pipes and rigging. The floor is scuffed dark hardwood fading to black at the edges. The overall palette is dark blue-purple (#1A1F33) with pink and magenta accent lighting. The center of the image is moderately detailed but not visually noisy, as UI cards will be placed over it.
```

### Mood / Atmosphere Notes

- Theatrical, backstage energy -- the glamor behind the curtain
- Purple and magenta stage light streaks create visual interest without overwhelming
- The center area needs moderate visual calm because the artist roster UI (cards, buttons, level bars) will overlay most of the screen
- The partially open door to the stage creates narrative depth -- your artists perform out there
- Top area darkens into ceiling rigging; bottom darkens into shadowed floor

---

## 3. Studio Upgrades - Control Room

**Scene:** The technical heart of the studio where the player buys equipment upgrades.

**Base Color:** Dark red-brown `Color(0.15, 0.1, 0.1)` / `#261A1A`

### DALL-E Prompt

```
16-bit pixel art style, detailed background scene, limited color palette, portrait orientation, game background asset, atmospheric lighting, no characters, no text, no UI elements.

A professional recording studio control room packed with audio equipment, viewed from the operator's perspective. Tall 19-inch equipment racks line both walls, filled with compressors, equalizers, preamps, and effects units -- each with tiny blinking LED meters in green, yellow, and red. Patch bays with tangled XLR and TRS cables run along the mid-section. A large analog VU meter panel sits mounted on the back wall with needles at rest. The room has a dark red-brown wood paneling aesthetic with copper and brass hardware accents. Dim overhead red-tinted work lights cast a warm glow on the equipment while leaving deep shadows between the racks. Small power indicator LEDs dot the darkness like stars. A thick multi-core cable snake runs across the carpeted floor. The overall palette is dark red-brown (#261A1A) with warm copper, amber LED glows, and small green/red indicator lights providing color accents. The center of the image has some visual breathing room for UI overlay.
```

### Mood / Atmosphere Notes

- Technical, professional, "serious gear" atmosphere
- The LED indicator lights scattered across the dark equipment racks create a starfield-like effect that feels alive
- Red-brown warmth of wood paneling gives it a premium, vintage feel
- The VU meters and blinking LEDs suggest the studio is active and operational
- UI upgrade cards will overlay the center, so equipment detail should concentrate along the left and right edges (the racks) with the center being slightly more open
- Top darkens into ceiling panels; bottom darkens into dark carpet

---

## 4. Casino - Neon Casino Floor

**Scene:** The gambling area where players can bet CDs on mini-games.

**Base Color:** Dark green `Color(0.08, 0.15, 0.08)` / `#142614`

### DALL-E Prompt

```
16-bit pixel art style, detailed background scene, limited color palette, portrait orientation, game background asset, atmospheric lighting, no characters, no text, no UI elements.

A flashy casino floor seen from a slightly elevated angle. Rows of pixel-art slot machines with glowing screens line the left and right sides, their chrome surfaces reflecting colored light. A green felt card table sits in the mid-ground. The ceiling is low and covered in small recessed lights creating a dotted light pattern. Neon tube lights in hot pink, electric blue, and gold trace along the walls and ceiling edges. A large decorative chandelier made of golden CDs and vinyl records hangs from the center ceiling. The carpet has a bold geometric diamond pattern in dark green and black. Stacks of colorful poker chips and scattered playing cards decorate the table surfaces. The atmosphere is smoky with light haze catching the neon glow. The overall palette is dark green (#142614) with vivid neon pink, electric blue, and gold accents. The far background fades into darkness suggesting the casino extends further. The center area remains moderately open for gambling mini-game UI overlay.
```

### Mood / Atmosphere Notes

- Exciting, slightly dangerous, high-stakes energy
- The neon lighting should feel vivid and punchy against the deep green darkness -- this is the most colorful screen
- The CD/vinyl chandelier ties the casino theme back to the music label identity
- Smoky haze effect (subtle light scattering) adds atmosphere and helps soften the background for UI readability
- The geometric carpet pattern should be low-contrast enough not to interfere with overlaid UI
- This screen hosts multiple gambling sub-screens (slots, card flip, spin wheel) so the background should feel generically "casino" rather than specific to one game
- Top darkens into low ceiling; bottom darkens into deep shadow under tables

---

## 5. Shop - Music Merchandise Store

**Scene:** The in-app purchase and ad rewards screen.

**Base Color:** Dark gold-brown `Color(0.15, 0.12, 0.05)` / `#261F0D`

### DALL-E Prompt

```
16-bit pixel art style, detailed background scene, limited color palette, portrait orientation, game background asset, atmospheric lighting, no characters, no text, no UI elements.

Interior of a retro music merchandise shop and record store viewed from the entrance looking in. Wooden shelves line both walls stacked with rows of CD jewel cases, vinyl records in crates, and boxed cassette tapes. A glass display counter runs across the mid-ground with headphones, guitar picks, and band pins displayed inside. The back wall features a large pegboard with hanging merchandise: t-shirts, tote bags, and keychains. A neon "OPEN" sign glows in warm orange-pink in the upper corner, casting a soft halo. Vintage string lights with round bulbs drape across the ceiling. A turntable on the counter has a record spinning. The floor is worn dark hardwood with a welcome mat. The overall palette is dark gold-brown (#261F0D) with warm amber, honey, and occasional orange-pink neon accents. The lighting feels like a cozy independent record shop at dusk. The center area has moderate open space for shop UI cards to overlay.
```

### Mood / Atmosphere Notes

- Cozy, nostalgic, "independent record shop" warmth
- The gold-brown palette with amber lighting feels inviting and encourages browsing/purchasing (warm colors support conversion in shop UIs)
- The neon "OPEN" sign is a focal point but positioned in the upper area where the HUD will partially cover it, creating a nice layered effect
- String lights add whimsy and warmth without being visually noisy
- Shelves along the sides frame the center where shop item cards and purchase buttons will be displayed
- The spinning turntable is a small animated detail that could be referenced later if we add subtle background animation
- Top darkens into ceiling with string lights; bottom darkens into shadowed floor/mat area

---

## Production Notes

### Generation Settings

- **Model:** DALL-E 3 via OpenAI API
- **Size:** Request at 1024x1792 (closest portrait ratio available in DALL-E 3), then downscale to 540x960 in Aseprite/LibreSprite
- **Quality:** `hd` (for more detail and better pixel art rendering)
- **Style:** `natural` (avoids DALL-E's tendency to over-dramatize with `vivid`)

### Post-Processing Pipeline

1. **Generate** base image at 1024x1792 via DALL-E 3
2. **Downscale** to 540x960 using nearest-neighbor interpolation (preserves pixel art sharpness)
3. **Color correct** in Aseprite/LibreSprite to match the exact base color values specified above
4. **Darken edges** -- apply a subtle vignette or manual darkening to the top ~80px and bottom ~100px to ensure HUD and navbar readability
5. **Reduce palette** to 32 colors max per background using indexed color mode for authentic 16-bit feel
6. **Test overlay** -- place actual HUD and navbar mockups over the background to verify readability
7. **Export** as PNG with transparency disabled

### Consistency Tips

- Generate all 5 backgrounds in the same session if possible to maintain style consistency
- If one background looks stylistically different, regenerate it with slight prompt adjustments rather than mixing sessions
- The style anchor text at the beginning of each prompt is critical for consistency -- do not modify it
- After generation, manually compare color temperatures across all 5 backgrounds to ensure they feel like they belong to the same game

### File Naming Convention

```
assets/sprites/backgrounds/
    bg_main_studio.png
    bg_artist_roster.png
    bg_studio_upgrades.png
    bg_casino.png
    bg_shop.png
```
