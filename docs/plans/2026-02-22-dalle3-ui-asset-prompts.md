# Music Label Tycoon - DALL-E 3 Asset Generation Prompts

Prompts for generating pixel art UI elements and particle effect textures for the Music Label Tycoon mobile game. All prompts share a common style anchor to ensure visual consistency across the asset set.

**Style Anchor (prepended to every prompt):**
> "16-bit pixel art style, limited color palette, black outline, transparent background, game UI asset"

**Post-Generation Workflow:**
1. Generate with DALL-E 3 at 1024x1024 (highest fidelity)
2. Remove background (if not transparent) using remove.bg or manual selection
3. Downscale to target size in Aseprite using nearest-neighbor interpolation
4. Clean up pixel grid alignment and ensure black outlines are 1px consistent
5. Export as `.png` with transparency

---

## 1. UI Elements

---

### 1.1 CD Currency Icon

**Target size:** 16x16 pixels
**Output path:** `assets/sprites/ui/icon_cd_currency.png`

**Prompt:**
```
16-bit pixel art style, limited color palette, black outline, transparent background, game UI asset.
A tiny gold compact disc (CD) icon, 16x16 pixel size. The disc is a warm gold color with a darker
gold inner ring and a bright white shine highlight in the upper-left quadrant. The center hole of
the CD is visible as a small dark circle. The disc has subtle concentric arc lines suggesting the
reflective surface. A single small sparkle star sits at the top-right edge. Clean pixel grid,
no anti-aliasing, crisp edges. Viewed straight-on, flat 2D, no perspective.
```

**Color palette notes:**
- Primary gold: `#FFD700`
- Dark gold / shadow: `#B8860B`
- Highlight shine: `#FFFACD` (lemon chiffon) and pure `#FFFFFF`
- Center hole: `#4A3728` (dark brown)
- Outline: `#000000`

---

### 1.2 Navigation Bar Buttons (5 Icons)

**Target size:** 32x32 pixels each
**Output path:** `assets/sprites/ui/nav_*.png`

#### 1.2a Music Note Icon (Main / Label Screen)

**File:** `nav_music.png`

**Prompt:**
```
16-bit pixel art style, limited color palette, black outline, transparent background, game UI asset.
A 32x32 pixel icon of a single musical eighth note. The note head is a solid filled oval tilted
slightly, connected to a vertical stem with a single flag curving to the right. The note is bright
white with a subtle cyan-blue tint (#A8D8EA). Small pixel sparkles around it suggest sound or
vibration. Clean pixel grid, no anti-aliasing, flat 2D, suitable for a bottom navigation bar in
a mobile game.
```

**Color palette notes:**
- Note body: `#FFFFFF` with `#A8D8EA` (light blue) shading
- Shadow edge: `#5B7B8A`
- Sparkle accents: `#FFE66D` (soft yellow)
- Outline: `#000000`

#### 1.2b Person / Microphone Icon (Artists Screen)

**File:** `nav_artists.png`

**Prompt:**
```
16-bit pixel art style, limited color palette, black outline, transparent background, game UI asset.
A 32x32 pixel icon showing a stylized pixel art figure silhouette holding a microphone. The figure
is shown from the waist up, simplified to essential shapes: round head, rectangular torso, one arm
extended holding a classic ball-top microphone. The figure is in warm orange (#FF8C42) with the
microphone in silver-gray. A small sound wave arc emanates from the microphone. Clean pixel grid,
no anti-aliasing, flat 2D, suitable for a bottom navigation bar button.
```

**Color palette notes:**
- Figure body: `#FF8C42` (warm orange)
- Figure shadow: `#CC6B2E`
- Microphone: `#C0C0C0` (silver) with `#808080` shadow
- Sound wave arcs: `#FFE66D`
- Outline: `#000000`

#### 1.2c Gear / Mixing Board Icon (Studio Screen)

**File:** `nav_studio.png`

**Prompt:**
```
16-bit pixel art style, limited color palette, black outline, transparent background, game UI asset.
A 32x32 pixel icon of a mixing board / equalizer. Three vertical slider bars at different heights
sitting on a rectangular base panel. Each slider has a small knob (square) at its current position.
Above the sliders, a small gear/cog symbol indicates settings and upgrades. The mixing board is in
cool gray (#708090) with slider knobs in bright teal (#20B2AA). The gear is in lighter silver.
Clean pixel grid, no anti-aliasing, flat 2D, suitable for a bottom navigation bar button.
```

**Color palette notes:**
- Board base: `#708090` (slate gray)
- Slider tracks: `#4A5568`
- Slider knobs: `#20B2AA` (teal)
- Gear accent: `#B0C4DE` (light steel blue)
- Outline: `#000000`

#### 1.2d Dice / Card Icon (Casino Screen)

**File:** `nav_casino.png`

**Prompt:**
```
16-bit pixel art style, limited color palette, black outline, transparent background, game UI asset.
A 32x32 pixel icon combining a six-sided die and a playing card overlapping. The die is in the
foreground, tilted at a slight angle showing three faces, colored bright red (#E74C3C) with white
pip dots. Behind it, a playing card peeks out at an angle, white with a small spade symbol visible.
A tiny golden star sparkle sits near the top to suggest luck and fortune. Clean pixel grid, no
anti-aliasing, flat 2D, suitable for a bottom navigation bar button.
```

**Color palette notes:**
- Die body: `#E74C3C` (bright red)
- Die shadow face: `#C0392B`
- Die pips: `#FFFFFF`
- Card: `#FFFFFF` with `#2C3E50` (dark blue) spade
- Star sparkle: `#FFD700`
- Outline: `#000000`

#### 1.2e Shopping Bag Icon (Shop Screen)

**File:** `nav_shop.png`

**Prompt:**
```
16-bit pixel art style, limited color palette, black outline, transparent background, game UI asset.
A 32x32 pixel icon of a small shopping bag viewed from the front. The bag is a vibrant purple
(#8B5CF6) with two small handle loops at the top. A bright golden dollar sign or star emblem is
centered on the front of the bag. The bag has a slight paper-bag crinkle texture suggested by
one or two darker pixel lines. A small price tag hangs from one handle. Clean pixel grid, no
anti-aliasing, flat 2D, suitable for a bottom navigation bar button.
```

**Color palette notes:**
- Bag body: `#8B5CF6` (vivid purple)
- Bag shadow: `#6D28D9`
- Handles: `#7C3AED`
- Dollar/star emblem: `#FFD700` (gold)
- Price tag: `#FFFFFF` with `#E74C3C` accent
- Outline: `#000000`

---

### 1.3 Buy / Upgrade Button Background

**Target size:** 128x48 pixels (scalable 9-slice)
**Output path:** `assets/sprites/ui/btn_buy_upgrade.png`

**Prompt:**
```
16-bit pixel art style, limited color palette, black outline, transparent background, game UI asset.
A wide rounded rectangle button background, approximately 128x48 pixels. The button has a green
gradient going from bright lime green (#4ADE80) at the top to deeper green (#16A34A) at the bottom.
A 2-pixel black outline surrounds the entire shape. The top edge has a 1-pixel bright highlight line
in light green (#86EFAC) to simulate light reflection. The corners are rounded with a 4-pixel radius
in pixel art style (chamfered corners). Inside is empty (no text) so text can be overlaid in-engine.
The button looks pressable and satisfying, with a subtle 2-pixel darker green (#15803D) shadow strip
along the bottom edge to give a raised/3D feel. Clean pixel grid, no anti-aliasing.
```

**Color palette notes:**
- Top gradient: `#86EFAC` (highlight) to `#4ADE80` (bright green)
- Bottom gradient: `#16A34A` to `#15803D` (deep green shadow)
- Outline: `#000000` (2px)
- Inner highlight: `#86EFAC` (1px top edge)

**Implementation note:** Export as a 9-slice / NinePatchRect texture in Godot. Define stretch margins so the button scales horizontally without distorting corners.

---

### 1.4 Panel / Card Background

**Target size:** 256x128 pixels (scalable 9-slice)
**Output path:** `assets/sprites/ui/panel_card_bg.png`

**Prompt:**
```
16-bit pixel art style, limited color palette, black outline, game UI asset.
A rectangular panel background for a card or information display, approximately 256x128 pixels.
The panel is dark navy blue (#1E293B) at about 85% opacity (semi-transparent). It has a 2-pixel
border in a lighter steel blue (#475569). The corners are rounded with a 4-pixel chamfer in pixel
art style. Inside the border, a subtle 1-pixel inner highlight line runs along the top edge in
a slightly lighter shade (#334155) to give depth. The panel interior is clean and empty, designed
to hold text and icons overlaid in-engine. No decorations inside. The overall feel is sleek,
dark, and modern while maintaining the pixel art aesthetic. Clean pixel grid, no anti-aliasing.
```

**Color palette notes:**
- Background fill: `#1E293B` at 85% opacity
- Border: `#475569` (2px)
- Inner highlight: `#334155` (1px along top)
- Corner chamfer: 4px radius

**Implementation note:** Export as 9-slice / NinePatchRect. Set the background as a `CanvasItem` with modulated alpha for the semi-transparency, or bake the alpha into the PNG.

---

### 1.5 Spin Wheel Segments

**Target size:** 256x256 pixels (full wheel), individual wedges extractable
**Output path:** `assets/sprites/ui/spin_wheel.png`

**Prompt:**
```
16-bit pixel art style, limited color palette, black outline, transparent background, game UI asset.
A circular prize spin wheel divided into 6 equal wedge segments, viewed straight on. The wheel is
256x256 pixels. Each wedge is a distinct bright color in this clockwise order: red (#EF4444),
gold/yellow (#FBBF24), green (#22C55E), blue (#3B82F6), purple (#A855F7), orange (#F97316).
Each wedge is separated by a 2-pixel black dividing line radiating from the center. The outer rim
of the wheel has a 3-pixel dark border with small evenly-spaced notch marks (like a carnival wheel).
The center has a small circular hub in dark gray (#374151) with a metallic highlight. Each wedge
has a subtle lighter shade along its leading edge to create a slight bevel effect. No text or
icons inside the wedges (those will be added in-engine). Clean pixel grid, no anti-aliasing.
```

**Color palette notes:**
- Segment 1 (Red): `#EF4444` / highlight `#FCA5A5`
- Segment 2 (Gold): `#FBBF24` / highlight `#FDE68A`
- Segment 3 (Green): `#22C55E` / highlight `#86EFAC`
- Segment 4 (Blue): `#3B82F6` / highlight `#93C5FD`
- Segment 5 (Purple): `#A855F7` / highlight `#C084FC`
- Segment 6 (Orange): `#F97316` / highlight `#FDBA74`
- Dividers and rim: `#000000`
- Center hub: `#374151` with `#9CA3AF` metallic highlight

**Implementation note:** The wheel rotates as a single sprite in Godot. The pointer/indicator arrow is a separate sprite positioned at the top of the wheel.

---

### 1.6 Mystery Crate / Loot Box

**Target size:** 64x64 pixels per frame, 5 frames total
**Output path:** `assets/sprites/ui/crate_mystery_sheet.png` (sprite sheet: 320x64)

#### Frame 1: Closed Crate

**Prompt:**
```
16-bit pixel art style, limited color palette, black outline, transparent background, game UI asset.
A 64x64 pixel mystery loot crate, closed and sealed. The crate is a wooden chest shape with a
curved lid, colored in deep royal purple (#7C3AED) with gold (#FFD700) metal corner brackets,
hinges, and a prominent gold latch/lock on the front. A glowing question mark symbol in bright
gold hovers or is embossed on the front face of the crate. Subtle purple particle dots float
around the crate suggesting magical energy. The wood grain texture is suggested with slightly
darker purple pixel lines. A faint golden glow emanates from the seam of the lid. Clean pixel
grid, no anti-aliasing, flat 2D front-facing view.
```

#### Frame 2: Crate Shaking (slight offset)

**Prompt:**
```
16-bit pixel art style, limited color palette, black outline, transparent background, game UI asset.
A 64x64 pixel mystery loot crate, identical to the closed version (deep purple #7C3AED with gold
#FFD700 brackets and question mark), but tilted 2-3 pixels to the left as if shaking. Small
motion lines (2-3 short horizontal pixel lines) appear on the right side. The golden glow from
the lid seam is slightly brighter and wider. A few more particle dots appear around the crate.
The latch appears to be straining. Clean pixel grid, no anti-aliasing, flat 2D.
```

#### Frame 3: Crate Cracking Open

**Prompt:**
```
16-bit pixel art style, limited color palette, black outline, transparent background, game UI asset.
A 64x64 pixel mystery loot crate in the process of opening. The lid is raised about 30 degrees,
revealing a bright white-gold (#FFFACD) light beam shooting upward from inside the crate. The
purple (#7C3AED) body of the crate is still intact. Gold (#FFD700) brackets are visible. The
question mark on the front is starting to dissolve into sparkle particles. Bright sparkle stars
surround the opening. The light beam fans out slightly. Clean pixel grid, no anti-aliasing,
flat 2D.
```

#### Frame 4: Crate Fully Open with Light Burst

**Prompt:**
```
16-bit pixel art style, limited color palette, black outline, transparent background, game UI asset.
A 64x64 pixel mystery loot crate fully open. The lid is flipped back behind the crate body. A
massive bright white and gold light burst erupts from inside, with radial light rays extending
to the edges of the frame. The purple (#7C3AED) crate body sits at the bottom third. Sparkle
particles and small star shapes fill the upper portion. The light is brightest white (#FFFFFF)
at center, fading to gold (#FFD700) at the edges of the rays. Clean pixel grid, no anti-aliasing,
flat 2D.
```

#### Frame 5: Empty Open Crate (post-reveal)

**Prompt:**
```
16-bit pixel art style, limited color palette, black outline, transparent background, game UI asset.
A 64x64 pixel mystery loot crate, empty and fully open. The lid rests flipped back. The interior
of the crate is visible as a darker purple (#4C1D95) void. The gold (#FFD700) brackets and hinges
are visible. A few residual sparkle particles drift upward from the empty interior. The overall
mood is "spent" and quiet compared to the opening frames. No glow, minimal effects. Clean pixel
grid, no anti-aliasing, flat 2D.
```

**Color palette notes (all frames):**
- Crate body: `#7C3AED` (royal purple)
- Crate shadow: `#5B21B6`
- Crate interior: `#4C1D95` (deep purple)
- Gold accents: `#FFD700`
- Gold shadow: `#B8860B`
- Light beam: `#FFFFFF` center, `#FFFACD` mid, `#FFD700` edge
- Sparkle particles: `#FFFFFF`, `#FFD700`, `#FBBF24`
- Outline: `#000000`

**Implementation note:** Assemble all 5 frames into a horizontal sprite sheet (320x64). Use Godot's `AnimatedSprite2D` or `SpriteFrames` with timing: Frame 1 (idle, looping with frame 2), Frame 2 (shake, 0.1s), Frame 3 (crack, 0.15s), Frame 4 (burst, 0.2s), Frame 5 (settle, hold).

---

### 1.7 Scratch Card Template

**Target size:** 192x128 pixels
**Output path:** `assets/sprites/ui/scratch_card_template.png`

**Prompt:**
```
16-bit pixel art style, limited color palette, black outline, transparent background, game UI asset.
A 192x128 pixel scratch card viewed from the front. The card has a bright gradient border going from
gold (#FFD700) on the left to a warm orange (#F97316) on the right, 3 pixels wide. Inside the
border, the scratchable area is filled with a silver metallic foil texture (#C0C0C0) with subtle
pixel noise pattern using slightly darker (#A8A8A8) and lighter (#D4D4D4) pixels to simulate the
foil shimmer. In the center of the silver area, faint text reading "SCRATCH HERE" is barely visible
in a slightly darker silver (#9CA3AF), as if embossed. The top of the card above the scratch area
has a small banner strip in purple (#7C3AED) with space for a title. Small star decorations in
gold sit in the top-left and top-right corners. Clean pixel grid, no anti-aliasing, flat 2D.
```

**Color palette notes:**
- Border gradient: `#FFD700` to `#F97316`
- Silver foil base: `#C0C0C0`
- Foil noise dark: `#A8A8A8`
- Foil noise light: `#D4D4D4`
- Embossed text hint: `#9CA3AF`
- Title banner: `#7C3AED`
- Star decorations: `#FFD700`
- Outline: `#000000`

**Implementation note:** The silver foil layer is rendered on top of hidden prize content. In Godot, use a `Sprite2D` with a shader that reveals the layer underneath based on touch input coordinates (scratch-off mechanic via alpha masking).

---

### 1.8 Star / Gem Icon (Premium Currency)

**Target size:** 16x16 pixels
**Output path:** `assets/sprites/ui/icon_gem_premium.png`

**Prompt:**
```
16-bit pixel art style, limited color palette, black outline, transparent background, game UI asset.
A 16x16 pixel gemstone icon, specifically a cut diamond/gem shape viewed from the front. The gem
is a rich purple (#A855F7) with a faceted appearance created by lighter purple (#C084FC) triangular
highlights on the upper facets and darker purple (#7C3AED) on the lower facets. A bright white
(#FFFFFF) specular highlight sits on the top-left facet as a 2-pixel sparkle. The gem has the
classic diamond silhouette: flat top (table), angled crown facets, widest at the girdle, then
tapering to a point at the bottom (pavilion). A tiny 1-pixel sparkle star floats above the top-right
corner. Clean pixel grid, no anti-aliasing, flat 2D.
```

**Color palette notes:**
- Gem body: `#A855F7` (medium purple)
- Light facets: `#C084FC` (light purple)
- Dark facets: `#7C3AED` (deep purple)
- Deepest shadow: `#6D28D9`
- Specular highlight: `#FFFFFF`
- Sparkle: `#FFFFFF`
- Outline: `#000000`

---

## 2. Effect Textures

---

### 2.1 Sparkle Particle (Animated)

**Target size:** 8x8 pixels per frame, 4 frames
**Output path:** `assets/sprites/effects/particle_sparkle_sheet.png` (sprite sheet: 32x8)

#### Frame 1: Small Point

**Prompt:**
```
16-bit pixel art style, limited color palette, black outline, transparent background, game UI asset.
An 8x8 pixel sparkle particle, frame 1 of 4 in an animation. This frame shows a tiny bright point:
a single center pixel in pure white (#FFFFFF) surrounded by 4 adjacent pixels (up, down, left, right)
in pale yellow (#FDE68A). The rest of the 8x8 area is fully transparent. This represents the sparkle
at its smallest state. No outline on the sparkle itself (it is a light effect). Clean pixel grid,
no anti-aliasing.
```

#### Frame 2: Small Cross

**Prompt:**
```
16-bit pixel art style, limited color palette, transparent background, game UI asset.
An 8x8 pixel sparkle particle, frame 2 of 4. A small 4-pointed star shape centered in the frame.
The center pixel is pure white (#FFFFFF). The four cardinal arms extend 2 pixels each in bright
yellow (#FBBF24). The tips of the arms are pale yellow (#FDE68A). Total sparkle is about 5x5 pixels
within the 8x8 frame. Fully transparent background. No black outline (it is a glowing light effect).
Clean pixel grid, no anti-aliasing.
```

#### Frame 3: Full Star Burst (peak)

**Prompt:**
```
16-bit pixel art style, limited color palette, transparent background, game UI asset.
An 8x8 pixel sparkle particle, frame 3 of 4, the peak of the animation. A bright 4-pointed star
that nearly fills the 8x8 frame. The center 2x2 pixels are pure white (#FFFFFF). Four cardinal arms
extend to the edges, each 1 pixel wide, in bright yellow (#FBBF24). Four diagonal pixels at 45
degrees in pale yellow (#FDE68A) create an 8-pointed star effect. Maximum brightness. Fully
transparent background. No black outline. Clean pixel grid, no anti-aliasing.
```

#### Frame 4: Fading Cross

**Prompt:**
```
16-bit pixel art style, limited color palette, transparent background, game UI asset.
An 8x8 pixel sparkle particle, frame 4 of 4, the fade-out. Similar to frame 2 but dimmer: the
center pixel is pale yellow (#FDE68A) instead of white. The four cardinal arms are 2 pixels each
in soft warm yellow (#FCD34D) with tips in very pale (#FEF3C7). The sparkle is fading out. Fewer
lit pixels than frame 3. Fully transparent background. No black outline. Clean pixel grid, no
anti-aliasing.
```

**Color palette notes (all frames):**
- Peak white: `#FFFFFF`
- Bright yellow: `#FBBF24`
- Medium yellow: `#FCD34D`
- Pale yellow: `#FDE68A`
- Faintest yellow: `#FEF3C7`

**Implementation note:** Assemble into 32x8 sprite sheet. Use as a `GPUParticles2D` texture in Godot with animation set to play through all 4 frames over the particle lifetime (0.3-0.5 seconds). Randomize rotation and scale per particle.

---

### 2.2 Glow Circle

**Target size:** 16x16 pixels
**Output path:** `assets/sprites/effects/glow_circle.png`

**Prompt:**
```
16-bit pixel art style, limited color palette, transparent background, game UI asset.
A 16x16 pixel soft circular glow effect. The center 4x4 pixels are pure white (#FFFFFF) with full
opacity. Surrounding that is a ring of bright gold (#FFD700) at about 75% opacity. The next ring
outward is warm yellow (#FBBF24) at about 50% opacity. The outermost ring is pale gold (#FDE68A)
at about 25% opacity, with the very edge pixels at about 10% opacity before fading to full
transparency. The overall shape is circular, and the gradient is smooth in a pixel art way (each
ring is 1-2 pixels wide, creating a stepped radial gradient). No black outline (this is a light
effect). The glow should look like a soft halo or lens flare. Clean pixel grid, no anti-aliasing.
```

**Color palette notes:**
- Center: `#FFFFFF` (100% opacity)
- Ring 1: `#FFD700` (75% opacity)
- Ring 2: `#FBBF24` (50% opacity)
- Ring 3: `#FDE68A` (25% opacity)
- Edge fade: `#FDE68A` (10% opacity)

**Implementation note:** Use as a particle texture or additive-blend overlay. In Godot, set the `CanvasItem` blend mode to "Add" for proper light accumulation. This glow circle serves as the base for CD aura effects (Tier 4 Album gold glow, etc.).

---

### 2.3 Rainbow Shimmer

**Target size:** 16x16 pixels
**Output path:** `assets/sprites/effects/rainbow_shimmer.png`

**Prompt:**
```
16-bit pixel art style, limited color palette, transparent background, game UI asset.
A 16x16 pixel prismatic rainbow shimmer effect texture. The texture shows a diagonal gradient
sweeping from bottom-left to top-right through the colors of the rainbow in this order: red
(#EF4444), orange (#F97316), yellow (#FBBF24), green (#22C55E), blue (#3B82F6), purple (#A855F7).
Each color band is 2-3 pixels wide. The edges of each color band blend into the next with a single
row of intermediate-color pixels. The overall opacity fades from about 70% in the center to 0% at
the edges, creating a soft diamond or lens-shaped shimmer. No black outline (this is a light overlay
effect). Clean pixel grid, no anti-aliasing.
```

**Color palette notes:**
- Red band: `#EF4444`
- Orange band: `#F97316`
- Yellow band: `#FBBF24`
- Green band: `#22C55E`
- Blue band: `#3B82F6`
- Purple band: `#A855F7`

**Implementation note:** Used as the rainbow aura for Tier 6 Diamond CDs. Animate by scrolling UV coordinates diagonally over time in a shader (shifting the gradient continuously). Layer on top of the CD sprite with additive blending. Can also be used for the scratch card "big win" reveal effect.

---

### 2.4 Coin / CD Collect Burst

**Target size:** 16x16 pixels
**Output path:** `assets/sprites/effects/burst_collect.png`

**Prompt:**
```
16-bit pixel art style, limited color palette, transparent background, game UI asset.
A 16x16 pixel radial burst effect for when a coin or CD is collected. The center is a bright white
(#FFFFFF) circle of about 4x4 pixels. From the center, 8 thin lines (1 pixel wide) radiate outward
in all cardinal and diagonal directions, extending to the edge of the 16x16 frame. The lines are
bright gold (#FFD700) near the center, fading to pale yellow (#FDE68A) at the tips. Between the
main lines, there are tiny 1-pixel dots in warm yellow (#FBBF24) at about 60-70% of the radius,
creating a secondary ring of energy. The overall effect looks like a small starburst or impact flash.
No black outline (light effect). Clean pixel grid, no anti-aliasing.
```

**Color palette notes:**
- Center flash: `#FFFFFF`
- Inner rays: `#FFD700`
- Outer ray tips: `#FDE68A`
- Secondary dots: `#FBBF24`

**Implementation note:** Displayed as a one-shot particle when the player taps a CD. Use `AnimatedSprite2D` or instantiate as a brief flash (0.2s) that scales up from 0 to 1.5x then fades out. Pair with a "bling" sound effect for satisfying tap feedback.

---

### 2.5 Level Up Flash

**Target size:** 32x32 pixels
**Output path:** `assets/sprites/effects/flash_level_up.png`

**Prompt:**
```
16-bit pixel art style, limited color palette, transparent background, game UI asset.
A 32x32 pixel level-up celebration flash effect. At the center, a large bright starburst with
an 8-pointed star shape in white (#FFFFFF) and bright gold (#FFD700). The starburst occupies
about 70% of the frame. Above and through the starburst, 3 small upward-pointing arrow chevrons
(^) are stacked vertically, each about 6 pixels wide, in bright cyan (#22D3EE). The arrows
suggest "powering up" or "leveling up." Small sparkle dots in yellow (#FBBF24) and white scatter
around the starburst. The bottom of the starburst fades into a softer glow. The effect conveys
achievement, power, and celebration. No black outline on the light elements. Clean pixel grid,
no anti-aliasing.
```

**Color palette notes:**
- Starburst center: `#FFFFFF`
- Starburst rays: `#FFD700`
- Starburst edge glow: `#FBBF24`
- Up arrows: `#22D3EE` (cyan)
- Arrow highlight: `#67E8F9` (light cyan)
- Scatter sparkles: `#FFFFFF`, `#FBBF24`

**Implementation note:** Used when an artist or studio upgrade hits a milestone level (25/50/75/100). Display centered on the upgraded element, scale from 0 to 1.2x over 0.3s, hold 0.2s, then fade out over 0.3s. Pair with a triumphant chiptune jingle from the SFX set.

---

### 2.6 Musical Notes Floating

**Target size:** 8x8 pixels per note, 6 variants
**Output path:** `assets/sprites/effects/notes_floating_sheet.png` (sprite sheet: 48x8)

#### Variant 1: Eighth Note (right flag)

**Prompt:**
```
16-bit pixel art style, limited color palette, transparent background, game UI asset.
An 8x8 pixel musical eighth note. Solid filled oval note head (2x2 pixels) at bottom-left, thin
1-pixel vertical stem going up, single flag curving to the right from the top of the stem. The note
is pure white (#FFFFFF). Clean pixel grid, no anti-aliasing, no outline. Minimal and iconic.
```

#### Variant 2: Eighth Note (left flag)

**Prompt:**
```
16-bit pixel art style, limited color palette, transparent background, game UI asset.
An 8x8 pixel musical eighth note, mirrored version. Solid filled oval note head (2x2 pixels) at
bottom-right, thin 1-pixel vertical stem going up, single flag curving to the left from the top
of the stem. The note is bright yellow (#FBBF24). Clean pixel grid, no anti-aliasing, no outline.
```

#### Variant 3: Pair of Beamed Eighth Notes

**Prompt:**
```
16-bit pixel art style, limited color palette, transparent background, game UI asset.
An 8x8 pixel pair of beamed eighth notes. Two solid oval note heads (each 2x2 pixels) at the
bottom, separated by 2 pixels, connected by vertical stems going up, joined at the top by a
horizontal beam. The notes are in soft pink (#F9A8D4). Clean pixel grid, no anti-aliasing,
no outline.
```

#### Variant 4: Quarter Note

**Prompt:**
```
16-bit pixel art style, limited color palette, transparent background, game UI asset.
An 8x8 pixel musical quarter note. A solid filled oval note head (2x3 pixels) at the bottom,
connected to a thin 1-pixel vertical stem going straight up. No flag. The note is in light
cyan (#67E8F9). Simple and clean. Clean pixel grid, no anti-aliasing, no outline.
```

#### Variant 5: Double Eighth Notes (beamed, tilted)

**Prompt:**
```
16-bit pixel art style, limited color palette, transparent background, game UI asset.
An 8x8 pixel pair of beamed sixteenth notes. Two solid oval note heads at the bottom connected
by stems to a double beam at the top (two horizontal lines). The notes are in light green (#86EFAC).
Slightly tilted to the right to suggest motion. Clean pixel grid, no anti-aliasing, no outline.
```

#### Variant 6: Treble Clef (simplified)

**Prompt:**
```
16-bit pixel art style, limited color palette, transparent background, game UI asset.
An 8x8 pixel highly simplified treble clef symbol. The iconic S-curve shape of a treble clef
reduced to its most essential pixel form: a vertical line with a small loop at the bottom and a
curve at the top. The symbol is in warm orange (#FDBA74). It should be recognizable as a treble
clef despite the extreme simplification. Clean pixel grid, no anti-aliasing, no outline.
```

**Color palette notes (all variants):**
- Variant 1: `#FFFFFF` (white)
- Variant 2: `#FBBF24` (yellow)
- Variant 3: `#F9A8D4` (pink)
- Variant 4: `#67E8F9` (cyan)
- Variant 5: `#86EFAC` (green)
- Variant 6: `#FDBA74` (orange)

**Implementation note:** Assemble all 6 into a 48x8 sprite sheet. Use as `GPUParticles2D` textures in Godot. Spawn notes drifting upward from artist characters and the main screen with slow sinusoidal horizontal drift (sine wave on X axis), random rotation, and gradual fade-out. Randomize which variant appears per particle. Lifetime: 1.5-3 seconds.

---

## 3. Generation Tips and Best Practices

### DALL-E 3 Settings
- **Size:** Always generate at 1024x1024 for maximum detail, then downscale
- **Style:** Use "natural" style mode (not "vivid") for more predictable pixel art results
- **Consistency:** Generate multiple versions of each asset and pick the one closest to the style guide
- **Iteration:** If the first result has anti-aliasing or smooth gradients, re-prompt with additional emphasis on "crisp pixel edges, no smoothing, no anti-aliasing, each pixel clearly defined"

### Common Issues and Fixes
| Issue | Fix |
|-------|-----|
| DALL-E adds anti-aliasing/smooth edges | Add "no anti-aliasing, no sub-pixel rendering, hard pixel edges only" to prompt |
| Background not transparent | Generate on solid green/magenta and chroma-key remove, or use remove.bg |
| Inconsistent pixel scale | Add "each pixel is exactly NxN screen pixels" to prompt (e.g., "each game pixel is 8x8 rendered pixels in the 1024x1024 output") |
| Too much detail for target size | Add "extremely simple, minimal detail, only essential shapes" |
| Colors too muted or too saturated | Specify exact hex colors in the prompt and adjust in Aseprite post-generation |
| Style drift between assets | Always include the full style anchor and reference the same color palette |

### Post-Processing Pipeline
1. **Generate** at 1024x1024 in DALL-E 3
2. **Background removal** using remove.bg or manual selection
3. **Downscale** to target pixel size using nearest-neighbor (no interpolation)
4. **Grid alignment** in Aseprite: ensure all edges fall on pixel boundaries
5. **Outline cleanup**: verify 1px black outlines are consistent and connected
6. **Color correction**: map generated colors to the defined palette using Aseprite's palette swap or recolor tool
7. **Animation assembly**: combine frames into sprite sheets with consistent frame sizes
8. **Export** as `.png` with transparency (PNG-8 if color count allows, PNG-32 otherwise)

### Master Color Palette Reference

| Color Name | Hex | Usage |
|------------|-----|-------|
| Pure White | `#FFFFFF` | Highlights, sparkles, light centers |
| Lemon Chiffon | `#FFFACD` | Light beams, warm glow |
| Gold | `#FFD700` | CD currency, gold accents, premium feel |
| Dark Gold | `#B8860B` | Gold shadows |
| Bright Yellow | `#FBBF24` | Sparkle particles, warm accents |
| Pale Yellow | `#FDE68A` | Fade edges, subtle glow |
| Orange | `#F97316` | Energy, casino excitement |
| Warm Orange | `#FF8C42` | Artist figures |
| Red | `#EF4444` | Casino die, urgency, alerts |
| Deep Red | `#C0392B` | Red shadows |
| Pink | `#F9A8D4` | Musical note variant |
| Vivid Purple | `#8B5CF6` | Shop, premium elements |
| Medium Purple | `#A855F7` | Gem currency, premium |
| Royal Purple | `#7C3AED` | Crate, mystery, rarity |
| Deep Purple | `#5B21B6` | Purple shadows |
| Darkest Purple | `#4C1D95` | Deep interiors |
| Cyan | `#22D3EE` | Level up, power |
| Light Cyan | `#67E8F9` | Cyan highlights, note variant |
| Light Blue | `#A8D8EA` | Music note tint |
| Blue | `#3B82F6` | UI accents, spin wheel |
| Teal | `#20B2AA` | Studio sliders |
| Bright Green | `#4ADE80` | Buy button top |
| Medium Green | `#22C55E` | Spin wheel, positive |
| Deep Green | `#16A34A` | Buy button bottom |
| Light Green | `#86EFAC` | Highlights, note variant |
| Navy | `#1E293B` | Panel backgrounds |
| Dark Slate | `#334155` | Panel inner highlight |
| Slate | `#475569` | Panel border |
| Slate Gray | `#708090` | Mixing board |
| Dark Gray | `#374151` | Wheel hub, structural |
| Medium Gray | `#4A5568` | Slider tracks |
| Silver | `#C0C0C0` | Scratch card foil, microphone |
| Light Steel Blue | `#B0C4DE` | Gear accents |
| Cool Gray | `#9CA3AF` | Metallic highlights |
| Dark Brown | `#4A3728` | CD center hole |
| Pure Black | `#000000` | All outlines, dividers |
