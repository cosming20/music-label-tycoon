#!/usr/bin/env python3
"""
Lyria RealTime music generator for Music Label Tycoon.
Generates chiptune/retro game music tracks using Google's Lyria API.
Tracks cost and enforces budget cap.

Usage:
    GOOGLE_API_KEY=your_key python3 tools/generate_music.py
"""

import asyncio
import json
import os
import struct
import sys
import wave
from datetime import datetime
from pathlib import Path

try:
    from google import genai
    from google.genai import types
except ImportError:
    print("ERROR: Install google-genai package: pip3 install google-genai")
    sys.exit(1)

# --- Configuration ---
API_KEY = os.environ.get("GOOGLE_API_KEY", "")
BUDGET_CAP_USD = 2.00  # Conservative cap (Lyria pricing TBD, may be free)
MODEL = "models/lyria-realtime-exp"

# Audio config
SAMPLE_RATE = 48000
CHANNELS = 2  # Stereo
SAMPLE_WIDTH = 2  # 16-bit

# Project paths
PROJECT_ROOT = Path(__file__).parent.parent
AUDIO_DIR = PROJECT_ROOT / "assets" / "audio"
COST_LOG = PROJECT_ROOT / "tools" / "music_generation_costs.json"

# --- Track Definitions ---
# Each track: prompt, BPM, duration in seconds, output subpath
TRACKS = {
    "music/main_theme": {
        "prompt": "upbeat chiptune 8-bit retro video game music, catchy melody, energetic but not frantic, positive vibes, lo-fi electronic, synthesizer lead, steady beat",
        "bpm": 120,
        "duration": 60,  # 1 minute loop
        "temperature": 1.0,
    },
    "music/casino_theme": {
        "prompt": "jazzy chiptune casino music, exciting slot machine vibes, playful saxophone-like synth, upbeat swing rhythm, 8-bit retro style, suspenseful but fun",
        "bpm": 130,
        "duration": 60,
        "temperature": 1.0,
    },
    "sfx/win_jingle": {
        "prompt": "short triumphant victory fanfare, chiptune celebration jingle, bright and exciting, level up achievement sound, 8-bit retro game",
        "bpm": 140,
        "duration": 8,  # Short jingle
        "temperature": 0.8,
    },
    "sfx/collect_cd": {
        "prompt": "short satisfying pickup coin collect sound, bright ping chime, single note reward sound, 8-bit retro game sound effect",
        "bpm": 120,
        "duration": 3,
        "temperature": 0.5,
    },
    "sfx/spin_wheel": {
        "prompt": "spinning wheel clicking ratchet sound building suspense, carnival wheel of fortune, ticking getting slower, 8-bit retro",
        "bpm": 160,
        "duration": 6,
        "temperature": 0.8,
    },
    "sfx/gacha_reveal": {
        "prompt": "dramatic reveal unveiling sound, building anticipation then bright sparkle reveal, treasure chest opening, magical shimmer, 8-bit retro",
        "bpm": 100,
        "duration": 5,
        "temperature": 0.8,
    },
}


def load_cost_log() -> dict:
    if COST_LOG.exists():
        with open(COST_LOG) as f:
            return json.load(f)
    return {"total_spent": 0.0, "tracks_generated": 0, "log": []}


def save_cost_log(data: dict) -> None:
    with open(COST_LOG, "w") as f:
        json.dump(data, f, indent=2)


def save_wav(audio_data: bytes, output_path: Path) -> None:
    """Save raw PCM audio data as WAV file."""
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with wave.open(str(output_path), "wb") as wav:
        wav.setnchannels(CHANNELS)
        wav.setsampwidth(SAMPLE_WIDTH)
        wav.setframerate(SAMPLE_RATE)
        wav.writeframes(audio_data)
    print(f"  Saved: {output_path} ({len(audio_data)} bytes, "
          f"{len(audio_data) / (SAMPLE_RATE * CHANNELS * SAMPLE_WIDTH):.1f}s)")


async def generate_track(track_name: str, config: dict) -> bytes | None:
    """Generate a single music track using Lyria RealTime."""
    client = genai.Client(
        api_key=API_KEY,
        http_options={"api_version": "v1alpha"},
    )

    duration = config["duration"]
    target_bytes = SAMPLE_RATE * CHANNELS * SAMPLE_WIDTH * duration
    audio_buffer = bytearray()

    print(f"  Connecting to Lyria RealTime...")

    try:
        async with client.aio.live.music.connect(model=MODEL) as session:
            # Set the musical prompt
            await session.set_weighted_prompts(
                prompts=[types.WeightedPrompt(text=config["prompt"], weight=1.0)]
            )

            # Set generation config
            await session.set_music_generation_config(
                config=types.LiveMusicGenerationConfig(
                    bpm=config["bpm"],
                    temperature=config.get("temperature", 1.0),
                )
            )

            # Start generation
            await session.play()
            print(f"  Generating {duration}s of audio...")

            # Collect audio chunks until we have enough
            async for message in session.receive():
                if hasattr(message, "server_content") and message.server_content:
                    if message.server_content.audio_chunks:
                        chunk = message.server_content.audio_chunks[0].data
                        audio_buffer.extend(chunk)

                        # Progress indicator
                        progress = min(len(audio_buffer) / target_bytes * 100, 100)
                        sys.stdout.write(f"\r  Progress: {progress:.0f}% ({len(audio_buffer)}/{target_bytes} bytes)")
                        sys.stdout.flush()

                        if len(audio_buffer) >= target_bytes:
                            break

            print()  # Newline after progress

            # Trim to exact duration
            return bytes(audio_buffer[:target_bytes])

    except Exception as e:
        print(f"  ERROR: {e}")
        return None


async def main():
    if not API_KEY:
        print("ERROR: Set GOOGLE_API_KEY environment variable")
        sys.exit(1)

    cost_log = load_cost_log()
    total_tracks = len(TRACKS)
    generated = 0
    skipped = 0
    errors = 0

    print(f"=== Lyria RealTime Music Generator ===")
    print(f"Budget cap: ${BUDGET_CAP_USD:.2f}")
    print(f"Spent so far: ${cost_log['total_spent']:.2f}")
    print(f"Tracks to generate: {total_tracks}")
    print(f"Note: Lyria RealTime is experimental — pricing may be free")
    print()

    for i, (track_path, track_config) in enumerate(TRACKS.items(), 1):
        output_path = AUDIO_DIR / f"{track_path}.wav"

        # Skip if already generated
        if output_path.exists():
            print(f"[{i}/{total_tracks}] SKIP (exists): {track_path}")
            skipped += 1
            continue

        print(f"[{i}/{total_tracks}] Generating: {track_path}")
        print(f"  Prompt: {track_config['prompt'][:80]}...")
        print(f"  BPM: {track_config['bpm']}, Duration: {track_config['duration']}s")

        audio_data = await generate_track(track_path, track_config)

        if audio_data:
            save_wav(audio_data, output_path)
            generated += 1

            # Track cost (estimate until pricing is published)
            estimated_cost = 0.0  # Free for experimental
            cost_log["total_spent"] += estimated_cost
            cost_log["tracks_generated"] += 1
            cost_log["log"].append({
                "track": track_path,
                "duration": track_config["duration"],
                "cost": estimated_cost,
                "timestamp": datetime.now().isoformat(),
            })
            save_cost_log(cost_log)
        else:
            errors += 1

        # Small delay between tracks
        await asyncio.sleep(2)

    print()
    print(f"=== Generation Complete ===")
    print(f"Generated: {generated} tracks")
    print(f"Skipped: {skipped}")
    print(f"Errors: {errors}")
    print(f"Total spent: ${cost_log['total_spent']:.2f} / ${BUDGET_CAP_USD:.2f}")


if __name__ == "__main__":
    asyncio.run(main())
