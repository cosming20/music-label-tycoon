# DALL-E 3 Prompts - CD Tier Sprites

> **Game:** Music Label Tycoon
> **Asset Type:** CD tier sprites (core collectible/currency)
> **Sprite Size:** 32x32 pixels
> **Art Style:** 16-bit pixel art
> **Pipeline:** Generate with DALL-E 3 --> Refine in Aseprite/LibreSprite --> Export sprite sheets

---

## Style Anchor (prepend to all prompts)

All prompts below include this shared style prefix:

```
16-bit pixel art style, 32x32 sprite, limited color palette, black outline, transparent background, single game asset, top-down perspective, no text
```

---

## Tier 1: Demo CD

**Value:** 1 CD | **Drop Rate:** Very Common

### Base Sprite Prompt

```
16-bit pixel art style, 32x32 sprite, limited color palette, black outline, transparent background, single game asset, top-down perspective, no text. A plain silver compact disc lying flat, viewed from slightly above. The disc has a simple circular shape with a small center hole. Minimal shading with just two tones of silver-gray to indicate the reflective surface. No case or packaging, just the bare disc. The design is deliberately plain and unadorned to convey a cheap demo recording. Subtle single-pixel highlight on the upper-left edge to indicate light source. Clean, simple, retro game item aesthetic similar to early SNES RPG inventory icons.
```

### Collected Animation Frame Prompt

```
16-bit pixel art style, 36x36 sprite, limited color palette, black outline, transparent background, single game asset, top-down perspective, no text. A plain silver compact disc lying flat, viewed from slightly above, slightly larger and brighter than normal as if freshly picked up. The disc has a simple circular shape with a small center hole. The silver surface is brightened with a white highlight bloom on the upper-left quadrant. Two small single-pixel white sparkle dots float just above the disc at the upper-left and upper-right corners to indicate the moment of collection. Clean retro game item aesthetic similar to early SNES RPG inventory icons.
```

### Developer Color Notes

| Element        | Hex Code  | Usage                              |
|----------------|-----------|-------------------------------------|
| Silver base    | `#C0C0C0` | Primary disc surface                |
| Silver shadow  | `#A0A0A0` | Lower-right shading                 |
| Silver dark    | `#808080` | Center hole, outer edge shadow      |
| Highlight      | `#E0E0E0` | Upper-left light reflection         |
| White          | `#FFFFFF` | Sparkle pixels (collected frame)    |
| Black outline  | `#000000` | 1px outline around entire sprite    |

---

## Tier 2: Single

**Value:** 5 CDs | **Drop Rate:** Common

### Base Sprite Prompt

```
16-bit pixel art style, 32x32 sprite, limited color palette, black outline, transparent background, single game asset, top-down perspective, no text. A compact disc inside a blue jewel case, viewed from slightly above at a three-quarter angle. The jewel case is a saturated medium blue with a slightly lighter blue highlight along the top-left edge. The CD is partially visible through the translucent case lid, rendered as a lighter silver-blue circle. The case has a thin dark blue shadow along the bottom-right edge to give depth. The overall look is clean and slightly nicer than a bare disc, conveying a proper commercial single release. Retro 16-bit game item style similar to SNES or GBA collectible icons.
```

### Collected Animation Frame Prompt

```
16-bit pixel art style, 36x36 sprite, limited color palette, black outline, transparent background, single game asset, top-down perspective, no text. A compact disc inside a blue jewel case, viewed from slightly above at a three-quarter angle, slightly larger and brighter than normal as if freshly collected. The blue jewel case surface has an intensified bright blue sheen with a white pixel highlight streak across the top-left corner. The CD inside is visible as a bright silver-white circle through the case. Three small single-pixel white sparkle dots are arranged in a loose triangle pattern just above the case to indicate the pickup moment. Retro 16-bit game item style similar to SNES or GBA collectible icons.
```

### Developer Color Notes

| Element            | Hex Code  | Usage                                 |
|--------------------|-----------|----------------------------------------|
| Blue case base     | `#3366CC` | Primary jewel case surface             |
| Blue highlight     | `#5599EE` | Upper-left edge shine                  |
| Blue shadow        | `#224488` | Lower-right edge depth                 |
| Blue dark          | `#1A3366` | Case spine/edge detail                 |
| Silver disc        | `#B0C0D8` | CD visible through case                |
| White              | `#FFFFFF` | Highlight streak, sparkles (collected) |
| Black outline      | `#000000` | 1px outline around entire sprite       |

---

## Tier 3: EP

**Value:** 25 CDs | **Drop Rate:** Uncommon

### Base Sprite Prompt

```
16-bit pixel art style, 32x32 sprite, limited color palette, black outline, transparent background, single game asset, top-down perspective, no text. A compact disc inside an emerald green jewel case, viewed from slightly above at a three-quarter angle. The green case has a rich saturated color with a lighter green highlight along the top-left edge and a darker green shadow on the bottom-right. A small four-pointed sparkle effect made of bright yellow-white pixels sits on the upper-left corner of the case, composed of 5 pixels in a plus-sign pattern, indicating this is a special item. The CD is faintly visible through the case as a lighter green-silver circle. The overall look conveys a step up in quality, an extended play release worth collecting. Retro 16-bit RPG item aesthetic with the sparkle giving it an enchanted quality.
```

### Collected Animation Frame Prompt

```
16-bit pixel art style, 36x36 sprite, limited color palette, black outline, transparent background, single game asset, top-down perspective, no text. A compact disc inside an emerald green jewel case, viewed from slightly above at a three-quarter angle, slightly larger and brighter than normal. The green case surface is intensified to a bright vivid green with a strong white highlight bloom across the top-left quadrant. Two four-pointed sparkle effects made of bright yellow-white pixels sit at the upper-left and lower-right corners of the case, each composed of 5 pixels in a plus-sign pattern. An additional two single-pixel sparkle dots float above the case. The CD inside glows as a bright silver-white circle. The effect conveys a magical item being collected. Retro 16-bit RPG enchanted item aesthetic.
```

### Developer Color Notes

| Element             | Hex Code  | Usage                                |
|---------------------|-----------|---------------------------------------|
| Green case base     | `#33AA55` | Primary jewel case surface            |
| Green highlight     | `#55CC77` | Upper-left edge shine                 |
| Green shadow        | `#228844` | Lower-right edge depth                |
| Green dark          | `#1A6633` | Case spine/edge detail                |
| Silver disc         | `#A8D8B8` | CD visible through case               |
| Sparkle bright      | `#FFFFAA` | Center pixel of sparkle effect        |
| Sparkle white       | `#FFFFFF` | Outer sparkle arms, collection dots   |
| Black outline       | `#000000` | 1px outline around entire sprite      |

---

## Tier 4: Album

**Value:** 150 CDs | **Drop Rate:** Rare

### Base Sprite Prompt

```
16-bit pixel art style, 32x32 sprite, limited color palette, black outline, transparent background, single game asset, top-down perspective, no text. A compact disc inside a luxurious gold jewel case, viewed from slightly above at a three-quarter angle. The case has a rich metallic gold color with a bright golden-yellow highlight along the top-left edge graduating to a deeper amber-gold on the bottom-right. A subtle warm glow aura surrounds the case, rendered as a 1-2 pixel soft golden-yellow border that fades outward, giving the impression of the case radiating warm light. The CD is visible through the case as a bright golden-white circle. The overall appearance conveys prestige and value, like a gold record award. Retro 16-bit RPG rare treasure item aesthetic with the golden glow suggesting magical or legendary quality.
```

### Collected Animation Frame Prompt

```
16-bit pixel art style, 36x36 sprite, limited color palette, black outline, transparent background, single game asset, top-down perspective, no text. A compact disc inside a luxurious gold jewel case, viewed from slightly above at a three-quarter angle, slightly larger and brighter than normal. The case has an intensified bright metallic gold surface with a strong white-gold highlight bloom covering the top-left third. A prominent warm glow aura surrounds the entire case, rendered as a 2-3 pixel soft golden-yellow radiance that pulses outward. Four single-pixel bright white sparkle dots are arranged at the cardinal points around the case just outside the glow aura. The CD inside blazes as a bright white-gold circle. The effect conveys a rare treasure being claimed. Retro 16-bit RPG legendary loot aesthetic with intense golden radiance.
```

### Developer Color Notes

| Element             | Hex Code  | Usage                                   |
|---------------------|-----------|------------------------------------------|
| Gold case base      | `#DAA520` | Primary jewel case surface               |
| Gold highlight      | `#FFD700` | Upper-left edge bright shine             |
| Gold mid            | `#CC8800` | Mid-tone transitional areas              |
| Gold shadow         | `#AA6600` | Lower-right edge depth                   |
| Gold dark           | `#885500` | Case spine/edge detail                   |
| Glow aura outer     | `#FFE066` | Outer glow pixels (50% alpha in-engine)  |
| Glow aura inner     | `#FFD700` | Inner glow pixels (75% alpha in-engine)  |
| Disc bright         | `#FFF0C0` | CD visible through case                  |
| White               | `#FFFFFF` | Sparkle dots, peak highlight (collected) |
| Black outline       | `#000000` | 1px outline around case (inside glow)    |

---

## Tier 5: Platinum

**Value:** 1,000 CDs | **Drop Rate:** Very Rare

### Base Sprite Prompt

```
16-bit pixel art style, 32x32 sprite, limited color palette, black outline, transparent background, single game asset, top-down perspective, no text. A platinum-colored compact disc without a case, lying flat and viewed from slightly above. The disc has a luminous silvery-white metallic surface with cool blue-tinted highlights along the top-left edge and subtle lavender-gray shadows on the bottom-right. The center hole is dark. Six to eight small single-pixel particle dots in white and light cyan float in a scattered orbit around the disc at varying distances of 2-4 pixels from the edge, suggesting the disc is radiating energy. Two tiny four-pointed sparkle crosses made of 3 pixels each sit at the upper-left and lower-right of the particle field. The overall effect is an ethereal, almost magical platinum record that pulses with power. Retro 16-bit RPG epic-tier item aesthetic, the kind of item that makes the inventory screen glow.
```

### Collected Animation Frame Prompt

```
16-bit pixel art style, 36x36 sprite, limited color palette, black outline, transparent background, single game asset, top-down perspective, no text. A platinum-colored compact disc without a case, lying flat and viewed from slightly above, slightly larger and brighter than normal. The disc surface is intensified to a near-white luminous platinum with a strong cool-white bloom highlight covering the top-left half. A bright silvery-white glow aura radiates 2 pixels out from the disc edge. Ten to twelve small single-pixel particle dots in white, light cyan, and pale lavender orbit around the disc in a wider scattered ring pattern at 3-5 pixels from the edge. Four tiny four-pointed sparkle crosses made of 5 pixels each are positioned at the four corners of the sprite. The entire composition radiates intense cold light energy. Retro 16-bit RPG epic loot collection burst aesthetic.
```

### Developer Color Notes

| Element             | Hex Code  | Usage                                        |
|---------------------|-----------|-----------------------------------------------|
| Platinum base       | `#E8E8F0` | Primary disc surface                          |
| Platinum highlight  | `#F8F8FF` | Upper-left bright reflection                  |
| Platinum mid        | `#C8C8D8` | Mid-tone disc surface                         |
| Platinum shadow     | `#A0A0B8` | Lower-right shading                           |
| Cool blue tint      | `#D0D8F0` | Blue-shifted highlight accents                |
| Lavender shadow     | `#B0A8C0` | Purple-shifted shadow accents                 |
| Particle cyan       | `#AAEEFF` | Orbiting particle dots                        |
| Particle white      | `#FFFFFF` | Brightest particle dots and sparkle centers   |
| Glow aura           | `#E0E8FF` | Edge glow (50-75% alpha in-engine)            |
| Center hole         | `#404050` | Disc center                                   |
| Black outline       | `#000000` | 1px outline around disc (inside particle ring)|

**Animation note:** In-engine, animate the particle dots rotating slowly around the disc using a shader or tween. The DALL-E output provides the particle positions for a single keyframe; create 4-8 rotation frames by shifting particle positions in Aseprite.

---

## Tier 6: Diamond

**Value:** 10,000 CDs | **Drop Rate:** Legendary

### Base Sprite Prompt

```
16-bit pixel art style, 32x32 sprite, limited color palette, black outline, transparent background, single game asset, top-down perspective, no text. A diamond-encrusted compact disc lying flat, viewed from slightly above. The disc surface is covered in tiny diamond facets rendered as a pattern of bright white, ice blue, and pale pink pixels creating a crystalline mosaic texture. The center hole is dark with a bright white pixel ring around it. A prominent rainbow shimmer aura surrounds the entire disc, rendered as a 3-4 pixel multicolored border that cycles through red, orange, yellow, green, cyan, blue, and violet pixels arranged in a gradient arc pattern around the disc. Eight to ten bright white single-pixel sparkle particles float at varying distances from the disc. Four-pointed sparkle crosses made of bright white pixels sit at the top-left and bottom-right. The overall effect is breathtaking and unmistakably legendary, the rarest and most valuable item in the game. Retro 16-bit RPG ultimate legendary item aesthetic with intense prismatic energy.
```

### Collected Animation Frame Prompt

```
16-bit pixel art style, 40x40 sprite, limited color palette, black outline, transparent background, single game asset, top-down perspective, no text. A diamond-encrusted compact disc lying flat, viewed from slightly above, noticeably larger and more radiant than normal as if erupting with energy upon collection. The disc surface blazes with diamond facets rendered as bright white, ice blue, and pale pink pixels in a crystalline pattern, with an intense white-hot center glow. A massive rainbow shimmer aura explodes outward from the disc in a 4-6 pixel multicolored ring, cycling through vivid red, orange, yellow, green, cyan, blue, and violet pixels arranged in radial gradient arcs. Twelve to sixteen bright white single-pixel sparkle particles burst outward in all directions at 4-8 pixels from the disc center. Six four-pointed sparkle crosses made of bright white pixels are scattered around the aura at the cardinal and intercardinal positions. The entire composition is an explosion of prismatic light and diamond brilliance. Retro 16-bit RPG ultimate legendary loot collection explosion aesthetic, the kind of visual that makes the player feel incredible.
```

### Developer Color Notes

| Element              | Hex Code  | Usage                                         |
|----------------------|-----------|------------------------------------------------|
| Diamond white        | `#FFFFFF` | Primary facet highlights, sparkle centers      |
| Diamond ice blue     | `#CCE8FF` | Facet mid-tone, cool diamond surface           |
| Diamond pale pink    | `#FFD8E8` | Facet warm accent for prismatic variety        |
| Diamond pale violet  | `#E0D0FF` | Additional facet accent                        |
| Diamond base         | `#E0F0FF` | Overall disc base tone                         |
| Center ring          | `#FFFFFF` | Bright ring around center hole                 |
| Center hole          | `#303040` | Disc center                                    |
| Rainbow red          | `#FF4444` | Aura gradient segment                          |
| Rainbow orange       | `#FF8844` | Aura gradient segment                          |
| Rainbow yellow       | `#FFDD44` | Aura gradient segment                          |
| Rainbow green        | `#44DD66` | Aura gradient segment                          |
| Rainbow cyan         | `#44DDFF` | Aura gradient segment                          |
| Rainbow blue         | `#4466FF` | Aura gradient segment                          |
| Rainbow violet       | `#AA44FF` | Aura gradient segment                          |
| Sparkle white        | `#FFFFFF` | All sparkle dots and cross centers             |
| Black outline        | `#000000` | 1px outline around disc (inside aura)          |

**Animation note:** In-engine, animate the rainbow aura by rotating the color positions each frame (shift each pixel's color to the next in the spectrum). This creates the "shimmer" effect. Use a color-cycling shader or pre-render 7 frames with shifted rainbow positions. The sparkle particles should gently pulse between full opacity and 50% opacity on a staggered timer.

---

## General DALL-E 3 Tips for This Batch

1. **Generate at 1024x1024** and downscale to 32x32 in Aseprite. DALL-E 3 does not literally produce 32x32 images, but the prompt constrains the style to look pixel-art appropriate. Manual cleanup is expected.

2. **Run each prompt 4 times** and pick the best result per tier. DALL-E 3 output varies significantly between generations.

3. **Post-processing in Aseprite:**
   - Downscale to exact 32x32 (or 36x36/40x40 for collected frames) using nearest-neighbor interpolation
   - Clean up any anti-aliased edges to sharp pixel boundaries
   - Enforce the black outline consistently
   - Snap colors to the palette defined in the color notes above
   - Ensure transparent background (remove any generated background)
   - Verify consistent top-left lighting across all tiers

4. **Sprite sheet layout:** Export all 12 frames (6 base + 6 collected) into a single horizontal sprite sheet for efficient texture atlas loading in Godot.

5. **Consistency pass:** After generating all tiers, review them side-by-side. Ensure they form a clear visual progression from plain (Tier 1) to spectacular (Tier 6). Adjust colors and effects in Aseprite if the DALL-E output doesn't clearly differentiate tiers.

---

## Visual Progression Summary

```
Tier 1 (Demo)     -> Plain silver disc, no effects
Tier 2 (Single)   -> Blue case, clean and simple
Tier 3 (EP)       -> Green case + small sparkle accent
Tier 4 (Album)    -> Gold case + warm glow aura
Tier 5 (Platinum) -> Platinum disc + orbiting particles + sparkles
Tier 6 (Diamond)  -> Diamond disc + rainbow aura + particles + sparkles
```

Each tier should be immediately distinguishable at a glance during gameplay, even at small mobile screen sizes. The progression moves from cool/neutral tones (silver, blue) through warm/rich tones (green, gold) to ethereal/prismatic (platinum, diamond).
