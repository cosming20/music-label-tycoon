#!/usr/bin/env python3
"""Generate additional DALL-E assets for casino and studio screens."""

import os
import sys
import json
import time
import base64
import requests
from pathlib import Path

API_KEY = os.environ.get("OPENAI_API_KEY", "")
BUDGET_CAP_USD = 2.00
COST_PER_IMAGE = {"1024x1024": 0.04, "1024x1792": 0.08}
PROJECT_ROOT = Path(__file__).parent.parent
ASSETS_DIR = PROJECT_ROOT / "assets"
COST_LOG = PROJECT_ROOT / "tools" / "extras_generation_costs.json"

PIXEL_ART = "16-bit pixel art style, limited color palette, black outline, transparent background, game asset, clean crisp pixels, retro video game aesthetic"

ASSETS = {
    # === Spin Wheel ===
    "sprites/casino/spin_wheel_base": {
        "prompt": f"A colorful circular prize wheel divided into 6 segments, carnival game wheel, bright neon colors purple gold silver orange gray, spin wheel game show, top-down view of wheel face, {PIXEL_ART}, 128x128 sprite, centered",
        "size": "1024x1024",
    },
    "sprites/casino/spin_wheel_pointer": {
        "prompt": f"A small red arrow pointer triangle pointing downward, game show wheel indicator, shiny metallic red with golden border, {PIXEL_ART}, 32x32 sprite, centered on transparent background",
        "size": "1024x1024",
    },
    "sprites/casino/prize_cd_stack": {
        "prompt": f"A small stack of three silver compact discs piled on top of each other, CD pile reward icon, shiny metallic, {PIXEL_ART}, 32x32 sprite, single item centered",
        "size": "1024x1024",
    },
    "sprites/casino/prize_boost_lightning": {
        "prompt": f"A bright yellow lightning bolt icon with orange glow, power boost energy symbol, electric energy, {PIXEL_ART}, 32x32 sprite, single item centered",
        "size": "1024x1024",
    },
    "sprites/casino/prize_gem": {
        "prompt": f"A shiny purple amethyst gemstone cut diamond shape, premium currency gem, sparkling facets, {PIXEL_ART}, 32x32 sprite, single item centered",
        "size": "1024x1024",
    },
    "sprites/casino/prize_empty": {
        "prompt": f"A sad face emoji or broken empty prize box, consolation prize nothing icon, gray muted colors, disappointed, {PIXEL_ART}, 32x32 sprite, single item centered",
        "size": "1024x1024",
    },
    # === Studio Upgrade Icons ===
    "sprites/studio/icon_recording_quality": {
        "prompt": f"A professional studio microphone with headphones, high quality audio recording equipment, silver and red, {PIXEL_ART}, 64x64 sprite, single item centered, music production",
        "size": "1024x1024",
    },
    "sprites/studio/icon_marketing_reach": {
        "prompt": f"A megaphone or bullhorn with sound waves emanating from it, marketing advertising promotion, blue and white, {PIXEL_ART}, 64x64 sprite, single item centered, loud announcement",
        "size": "1024x1024",
    },
    # === Gacha extras ===
    "sprites/casino/gacha_crate_glow": {
        "prompt": f"A glowing treasure chest mystery box opening with golden light rays bursting out, loot crate reveal moment, magical sparkles, {PIXEL_ART}, 64x64 sprite, centered, dramatic lighting",
        "size": "1024x1024",
    },
}

def load_costs():
    if COST_LOG.exists():
        with open(COST_LOG) as f:
            return json.load(f)
    return {"total_spent": 0.0, "images": []}

def save_costs(data):
    with open(COST_LOG, "w") as f:
        json.dump(data, f, indent=2)

def generate_image(prompt, size="1024x1024"):
    resp = requests.post(
        "https://api.openai.com/v1/images/generations",
        headers={"Authorization": f"Bearer {API_KEY}", "Content-Type": "application/json"},
        json={"model": "dall-e-3", "prompt": prompt, "n": 1, "size": size,
              "quality": "standard", "response_format": "b64_json"},
        timeout=120,
    )
    resp.raise_for_status()
    return base64.b64decode(resp.json()["data"][0]["b64_json"])

def main():
    if not API_KEY:
        print("Error: Set OPENAI_API_KEY env var")
        sys.exit(1)

    costs = load_costs()
    total = len(ASSETS)
    generated = 0
    skipped = 0
    errors = 0

    est = sum(COST_PER_IMAGE.get(a.get("size", "1024x1024"), 0.04) for a in ASSETS.values())
    print(f"=== DALL-E 3 Extras Generator ===")
    print(f"Budget cap: ${BUDGET_CAP_USD:.2f}")
    print(f"Spent so far: ${costs['total_spent']:.2f}")
    print(f"Assets to generate: {total}")
    print(f"Estimated cost: ${est:.2f}\n")

    for i, (path, config) in enumerate(ASSETS.items()):
        out_path = ASSETS_DIR / f"{path}.png"
        if out_path.exists():
            print(f"[{i+1}/{total}] SKIP (exists): {path}")
            skipped += 1
            continue

        size = config.get("size", "1024x1024")
        cost = COST_PER_IMAGE.get(size, 0.04)

        if costs["total_spent"] + cost > BUDGET_CAP_USD:
            print(f"[{i+1}/{total}] SKIP (budget): {path}")
            skipped += 1
            continue

        print(f"[{i+1}/{total}] Generating: {path} (${cost:.2f})...")
        try:
            out_path.parent.mkdir(parents=True, exist_ok=True)
            img_data = generate_image(config["prompt"], size)
            with open(out_path, "wb") as f:
                f.write(img_data)
            print(f"  Saved: {out_path} ({len(img_data)} bytes)")
            costs["total_spent"] += cost
            costs["images"].append({"path": path, "cost": cost})
            save_costs(costs)
            generated += 1
            time.sleep(13)  # Rate limit
        except Exception as e:
            print(f"  ERROR: {e}")
            errors += 1

    print(f"\n=== Generation Complete ===")
    print(f"Generated: {generated}")
    print(f"Already existed: {skipped}")
    print(f"Errors: {errors}")
    print(f"Total spent: ${costs['total_spent']:.2f} / ${BUDGET_CAP_USD:.2f}")

if __name__ == "__main__":
    main()
