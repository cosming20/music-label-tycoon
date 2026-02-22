#!/usr/bin/env python3
"""
DALL-E 3 asset generator for Music Label Tycoon.
Generates all pixel art sprites, backgrounds, and UI elements.
Tracks cost per image and enforces a budget cap.
"""

import os
import sys
import json
import time
import base64
import requests
from pathlib import Path
from datetime import datetime

# --- Configuration ---
API_KEY = os.environ.get("OPENAI_API_KEY", "")
BUDGET_CAP_USD = 5.00  # Maximum spend in USD
COST_PER_IMAGE = {
    "1024x1024": {"standard": 0.04, "hd": 0.08},
    "1024x1792": {"standard": 0.08, "hd": 0.12},
    "1792x1024": {"standard": 0.08, "hd": 0.12},
}
DEFAULT_SIZE = "1024x1024"
DEFAULT_QUALITY = "standard"

# Project root
PROJECT_ROOT = Path(__file__).parent.parent
ASSETS_DIR = PROJECT_ROOT / "assets"

# Cost tracking file
COST_LOG = PROJECT_ROOT / "tools" / "image_generation_costs.json"

# --- Style Anchors ---
PIXEL_ART_ANCHOR = "16-bit pixel art style, limited color palette, black outline, transparent background, game asset, clean crisp pixels, retro video game aesthetic"
BACKGROUND_ANCHOR = "16-bit pixel art style, detailed interior scene, limited color palette, atmospheric lighting, portrait aspect ratio, retro video game background, no characters, no text, no UI elements"

# --- Asset Definitions ---
ASSETS = {
    # === CD Sprites (32x32) ===
    "sprites/cds/cd_demo": {
        "prompt": f"A simple plain silver compact disc, basic demo CD, minimal design, {PIXEL_ART_ANCHOR}, 32x32 sprite size, single small item centered",
        "size": "1024x1024",
    },
    "sprites/cds/cd_single": {
        "prompt": f"A compact disc in a blue jewel case, music single release, slightly shiny, {PIXEL_ART_ANCHOR}, 32x32 sprite size, single small item centered, blue color scheme",
        "size": "1024x1024",
    },
    "sprites/cds/cd_ep": {
        "prompt": f"A compact disc in a green jewel case with small sparkle effects around it, EP music release, {PIXEL_ART_ANCHOR}, 32x32 sprite size, single small item centered, green color scheme, tiny star sparkles",
        "size": "1024x1024",
    },
    "sprites/cds/cd_album": {
        "prompt": f"A compact disc in a luxurious gold jewel case with subtle golden glow aura, full album release, premium look, {PIXEL_ART_ANCHOR}, 32x32 sprite size, single small item centered, gold color scheme",
        "size": "1024x1024",
    },
    "sprites/cds/cd_platinum": {
        "prompt": f"A platinum colored compact disc with shimmering particle effects surrounding it, platinum certified record, very prestigious, {PIXEL_ART_ANCHOR}, 32x32 sprite size, single small item centered, white and silver color scheme, glowing particles",
        "size": "1024x1024",
    },
    "sprites/cds/cd_diamond": {
        "prompt": f"A diamond-encrusted compact disc with rainbow prismatic aura and sparkles, legendary diamond record, most valuable, {PIXEL_ART_ANCHOR}, 32x32 sprite size, single small item centered, cyan and rainbow color scheme, brilliant shine",
        "size": "1024x1024",
    },

    # === Artist Sprites (64x64) ===
    "sprites/artists/artist_busker": {
        "prompt": f"A street busker character with acoustic guitar, worn casual clothes, hat for tips, humble musician, chibi proportions, front-facing idle pose, {PIXEL_ART_ANCHOR}, 64x64 character sprite, sandy brown warm tones",
        "size": "1024x1024",
    },
    "sprites/artists/artist_garage_band": {
        "prompt": f"A garage band rock musician with electric guitar, band t-shirt, jeans, energetic casual look, chibi proportions, front-facing idle pose, {PIXEL_ART_ANCHOR}, 64x64 character sprite, slate blue cool tones",
        "size": "1024x1024",
    },
    "sprites/artists/artist_indie": {
        "prompt": f"A trendy indie artist musician, unique hipster style, headphones around neck, creative outfit, chibi proportions, front-facing idle pose, {PIXEL_ART_ANCHOR}, 64x64 character sprite, medium purple tones",
        "size": "1024x1024",
    },
    "sprites/artists/artist_studio_pro": {
        "prompt": f"A professional studio musician with studio headphones, clean modern outfit, confident pose, chibi proportions, front-facing idle pose, {PIXEL_ART_ANCHOR}, 64x64 character sprite, orange-red tones",
        "size": "1024x1024",
    },
    "sprites/artists/artist_chart_topper": {
        "prompt": f"A flashy pop star musician, stylish trendy outfit, microphone, stage presence, chibi proportions, front-facing idle pose, {PIXEL_ART_ANCHOR}, 64x64 character sprite, hot pink tones",
        "size": "1024x1024",
    },
    "sprites/artists/artist_superstar": {
        "prompt": f"A glamorous music superstar celebrity, gold jewelry and accessories, designer clothes, sunglasses, chibi proportions, front-facing idle pose, {PIXEL_ART_ANCHOR}, 64x64 character sprite, gold tones",
        "size": "1024x1024",
    },
    "sprites/artists/artist_legend": {
        "prompt": f"An iconic legendary rockstar, dark mysterious aura, legendary status, dramatic cape or coat, chibi proportions, front-facing idle pose, {PIXEL_ART_ANCHOR}, 64x64 character sprite, dark violet purple tones, subtle glow",
        "size": "1024x1024",
    },

    # === Backgrounds (portrait) ===
    "sprites/backgrounds/bg_main_studio": {
        "prompt": f"Interior of a cozy music recording studio, mixing console desk with knobs and sliders, large speakers on walls, vinyl records hanging as decoration, warm amber lighting, cables on floor, microphone stand visible, {BACKGROUND_ANCHOR}, dark blue-gray color base, warm and inviting atmosphere",
        "size": "1024x1792",
    },
    "sprites/backgrounds/bg_artist_roster": {
        "prompt": f"Backstage talent agency office interior, music posters on walls, comfortable couch, stage lights visible through a doorway, gold records on display, {BACKGROUND_ANCHOR}, dark blue-purple color base, professional yet creative atmosphere",
        "size": "1024x1792",
    },
    "sprites/backgrounds/bg_studio_upgrades": {
        "prompt": f"Recording studio control room with equipment racks full of gear, LED level meters glowing, mixing board, patch cables, audio compressors, {BACKGROUND_ANCHOR}, dark red-brown color base, technical and professional atmosphere",
        "size": "1024x1792",
    },
    "sprites/backgrounds/bg_casino": {
        "prompt": f"Neon-lit casino floor interior, slot machines with colorful lights, card table visible, flashy neon signs, exciting nightlife atmosphere, {BACKGROUND_ANCHOR}, dark green color base, exciting and energetic atmosphere, lots of neon glow",
        "size": "1024x1792",
    },
    "sprites/backgrounds/bg_shop": {
        "prompt": f"Music merchandise store interior, shelves stocked with CDs and vinyl records, band posters on walls, neon OPEN sign, display cases, {BACKGROUND_ANCHOR}, dark warm gold-brown color base, inviting retail atmosphere",
        "size": "1024x1792",
    },

    # === UI Elements ===
    "sprites/ui/icon_cd_currency": {
        "prompt": f"A small shiny gold compact disc icon, currency symbol for a game, simple and recognizable, {PIXEL_ART_ANCHOR}, 16x16 sprite size, gold and yellow tones, bright and clear",
        "size": "1024x1024",
    },
    "sprites/ui/icon_nav_music": {
        "prompt": f"A music note icon, simple eighth note or treble clef, game navigation button icon, {PIXEL_ART_ANCHOR}, 32x32 sprite size, white on transparent",
        "size": "1024x1024",
    },
    "sprites/ui/icon_nav_artist": {
        "prompt": f"A microphone icon, simple stage microphone, game navigation button icon, {PIXEL_ART_ANCHOR}, 32x32 sprite size, white on transparent",
        "size": "1024x1024",
    },
    "sprites/ui/icon_nav_studio": {
        "prompt": f"A mixing board or equalizer icon with sliders, game navigation button icon, {PIXEL_ART_ANCHOR}, 32x32 sprite size, white on transparent",
        "size": "1024x1024",
    },
    "sprites/ui/icon_nav_casino": {
        "prompt": f"A dice and playing card icon, gambling casino symbol, game navigation button icon, {PIXEL_ART_ANCHOR}, 32x32 sprite size, white on transparent",
        "size": "1024x1024",
    },
    "sprites/ui/icon_nav_shop": {
        "prompt": f"A shopping bag icon, small retail bag with handle, game navigation button icon, {PIXEL_ART_ANCHOR}, 32x32 sprite size, white on transparent",
        "size": "1024x1024",
    },
    "sprites/ui/icon_gem_premium": {
        "prompt": f"A small purple gemstone, premium currency gem, faceted jewel, game currency icon, {PIXEL_ART_ANCHOR}, 16x16 sprite size, purple and violet tones, shiny",
        "size": "1024x1024",
    },
    "sprites/ui/mystery_crate_closed": {
        "prompt": f"A closed treasure chest or loot box, mystery crate, wooden chest with gold trim and a question mark on front, {PIXEL_ART_ANCHOR}, 64x64 sprite size, purple and gold color scheme",
        "size": "1024x1024",
    },
    "sprites/ui/mystery_crate_open": {
        "prompt": f"An opened treasure chest or loot box with golden light beaming out, mystery crate revealing prizes, {PIXEL_ART_ANCHOR}, 64x64 sprite size, purple and gold color scheme, bright golden glow from inside",
        "size": "1024x1024",
    },

    # === Effects ===
    "sprites/effects/particle_sparkle": {
        "prompt": f"A small sparkle star burst effect, white and yellow, 4-pointed star twinkle, particle effect for games, {PIXEL_ART_ANCHOR}, 8x8 sprite size, bright white and yellow",
        "size": "1024x1024",
    },
    "sprites/effects/particle_glow": {
        "prompt": f"A soft circular glow effect, radial gradient from bright center to transparent edge, warm golden light, particle effect for games, {PIXEL_ART_ANCHOR}, 16x16 sprite size, gold and white",
        "size": "1024x1024",
    },
    "sprites/effects/particle_notes": {
        "prompt": f"Small floating music notes, various musical note symbols scattered, eighth notes and quarter notes, {PIXEL_ART_ANCHOR}, 16x16 sprite size, white and pastel colors",
        "size": "1024x1024",
    },
    "sprites/effects/collect_burst": {
        "prompt": f"A radial burst explosion effect, lines emanating outward from center point, coin collect impact effect, {PIXEL_ART_ANCHOR}, 16x16 sprite size, gold and white rays",
        "size": "1024x1024",
    },
    "sprites/effects/levelup_flash": {
        "prompt": f"A bright starburst level up effect with small upward arrows, celebratory flash, upgrade complete effect, {PIXEL_ART_ANCHOR}, 32x32 sprite size, bright yellow and white with upward arrows",
        "size": "1024x1024",
    },
}


def load_cost_log() -> dict:
    """Load or initialize cost tracking."""
    if COST_LOG.exists():
        with open(COST_LOG) as f:
            return json.load(f)
    return {"total_spent": 0.0, "images_generated": 0, "log": []}


def save_cost_log(data: dict) -> None:
    """Save cost tracking."""
    with open(COST_LOG, "w") as f:
        json.dump(data, f, indent=2)


def get_image_cost(size: str, quality: str) -> float:
    """Get cost for an image generation."""
    return COST_PER_IMAGE.get(size, {}).get(quality, 0.08)


def generate_image(prompt: str, size: str, quality: str = DEFAULT_QUALITY) -> bytes | None:
    """Call DALL-E 3 API and return image bytes."""
    headers = {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json",
    }
    payload = {
        "model": "dall-e-3",
        "prompt": prompt,
        "n": 1,
        "size": size,
        "quality": quality,
        "response_format": "b64_json",
    }

    resp = requests.post(
        "https://api.openai.com/v1/images/generations",
        headers=headers,
        json=payload,
        timeout=120,
    )

    if resp.status_code != 200:
        print(f"  ERROR: {resp.status_code} - {resp.text[:200]}")
        return None

    data = resp.json()
    b64 = data["data"][0]["b64_json"]
    return base64.b64decode(b64)


def main():
    if not API_KEY:
        print("ERROR: Set OPENAI_API_KEY environment variable")
        sys.exit(1)

    cost_log = load_cost_log()
    total_assets = len(ASSETS)
    already_generated = 0
    skipped_budget = 0
    errors = 0

    print(f"=== DALL-E 3 Asset Generator ===")
    print(f"Budget cap: ${BUDGET_CAP_USD:.2f}")
    print(f"Spent so far: ${cost_log['total_spent']:.2f}")
    print(f"Assets to generate: {total_assets}")
    print()

    # Estimate total cost
    estimated_cost = sum(
        get_image_cost(asset["size"], DEFAULT_QUALITY)
        for asset in ASSETS.values()
    )
    print(f"Estimated cost for all assets: ${estimated_cost:.2f}")

    if cost_log["total_spent"] + estimated_cost > BUDGET_CAP_USD:
        print(f"WARNING: Estimated total (${cost_log['total_spent'] + estimated_cost:.2f}) exceeds budget cap (${BUDGET_CAP_USD:.2f})")
        resp = input("Continue anyway? (y/n): ").strip().lower()
        if resp != "y":
            print("Aborted.")
            return

    print()

    for i, (asset_path, asset_config) in enumerate(ASSETS.items(), 1):
        output_path = ASSETS_DIR / f"{asset_path}.png"

        # Skip if already generated
        if output_path.exists():
            print(f"[{i}/{total_assets}] SKIP (exists): {asset_path}")
            already_generated += 1
            continue

        # Check budget
        cost = get_image_cost(asset_config["size"], DEFAULT_QUALITY)
        if cost_log["total_spent"] + cost > BUDGET_CAP_USD:
            print(f"[{i}/{total_assets}] SKIP (budget): {asset_path} (would exceed ${BUDGET_CAP_USD:.2f})")
            skipped_budget += 1
            continue

        print(f"[{i}/{total_assets}] Generating: {asset_path} (${cost:.2f})...")

        # Ensure directory exists
        output_path.parent.mkdir(parents=True, exist_ok=True)

        # Generate
        image_bytes = generate_image(asset_config["prompt"], asset_config["size"])

        if image_bytes:
            with open(output_path, "wb") as f:
                f.write(image_bytes)
            print(f"  Saved: {output_path} ({len(image_bytes)} bytes)")

            # Track cost
            cost_log["total_spent"] += cost
            cost_log["images_generated"] += 1
            cost_log["log"].append({
                "asset": asset_path,
                "cost": cost,
                "size": asset_config["size"],
                "timestamp": datetime.now().isoformat(),
            })
            save_cost_log(cost_log)
        else:
            errors += 1

        # Rate limit: DALL-E 3 allows ~5 req/min on free tier
        time.sleep(13)

    print()
    print(f"=== Generation Complete ===")
    print(f"Generated: {cost_log['images_generated']} images")
    print(f"Already existed: {already_generated}")
    print(f"Skipped (budget): {skipped_budget}")
    print(f"Errors: {errors}")
    print(f"Total spent: ${cost_log['total_spent']:.2f} / ${BUDGET_CAP_USD:.2f}")


if __name__ == "__main__":
    main()
