#!/usr/bin/env python3
"""
Regenerates maitake and lionsmane at target_polycount=5000.
Run: python3 scripts/regen_two.py
"""

import subprocess, json, time, os, sys
import urllib.request, urllib.error

OUT_DIR   = os.path.join(os.path.dirname(__file__), "..", "assets", "mushrooms")
API_BASE  = "https://api.meshy.ai/openapi/v2/text-to-3d"
NEG_PROMPT = (
    "low quality, blurry, ugly, floating disconnected parts, "
    "multiple unrelated objects, text, watermark, background scene"
)
POLL_INTERVAL = 15

TARGETS = [
    ("maitake", "realistic",
     "maitake mushroom hen of the woods, large mass of overlapping grey-brown fronds "
     "with wavy edges radiating from central base, silver-green bioluminescent edge "
     "lining on each frond, dark cave fantasy game asset"),

    ("lionsmane", "realistic",
     "lion's mane mushroom, cascading pom-pom of long white icicle-like spines drooping "
     "downward from central mass, no cap or stem visible, white shaggy spherical form, "
     "cool blue-white bioluminescent glow at each spine tip, dark cave fantasy game asset"),
]

def get_api_key():
    r = subprocess.run(
        ["security", "find-generic-password", "-s", "GameDevMeshy", "-w"],
        capture_output=True, text=True
    )
    key = r.stdout.strip()
    if not key:
        sys.exit("ERROR: Could not retrieve GameDevMeshy key from Keychain.")
    return key

def api_post(url, key, data):
    req = urllib.request.Request(url, method="POST")
    req.add_header("Authorization", f"Bearer {key}")
    req.add_header("Content-Type", "application/json")
    req.data = json.dumps(data).encode()
    with urllib.request.urlopen(req, timeout=30) as r:
        return json.loads(r.read())

def api_get(url, key):
    req = urllib.request.Request(url, method="GET")
    req.add_header("Authorization", f"Bearer {key}")
    with urllib.request.urlopen(req, timeout=30) as r:
        return json.loads(r.read())

def poll(key, task_id, label):
    url = f"{API_BASE}/{task_id}"
    while True:
        result = api_get(url, key)
        status = result.get("status", "UNKNOWN")
        progress = result.get("progress", 0)
        if status == "SUCCEEDED":
            print()
            return result
        elif status in ("FAILED", "EXPIRED"):
            print(f"\n  ✗ {label}: {status}")
            return None
        print(f"  ↻ {label}: {status} {progress}%   ", end="\r", flush=True)
        time.sleep(POLL_INTERVAL)

key = get_api_key()
print("✓ API key loaded\n")

for mid, art_style, prompt in TARGETS:
    out_path = os.path.join(OUT_DIR, f"{mid}.fbx")
    print(f"Regenerating {mid}...")

    resp = api_post(API_BASE, key, {
        "mode":             "preview",
        "prompt":           prompt,
        "art_style":        art_style,
        "negative_prompt":  NEG_PROMPT,
        "target_polycount": 5000,
    })

    task_id = resp.get("result")
    if not task_id:
        print(f"  ✗ No task ID: {resp}")
        continue

    result = poll(key, task_id, mid)
    if not result:
        continue

    fbx_url = result.get("model_urls", {}).get("fbx")
    if not fbx_url:
        print(f"  ✗ No FBX URL")
        continue

    urllib.request.urlretrieve(fbx_url, out_path)
    print(f"  ✓ {mid}.fbx ({os.path.getsize(out_path) // 1024} KB)")

print("\nDone. Now delete maitake_reduced.fbx and lionsmane_reduced.fbx and re-run blender_reduce.py")
