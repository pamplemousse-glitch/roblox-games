#!/usr/bin/env python3
"""Upload all _reduced.fbx mushroom assets to Roblox via Open Cloud Assets API."""

import os
import json
import time
import subprocess
import urllib.request
import urllib.error

ASSETS_DIR = "/Users/antoinewiley/Roblox/my-roblox-clicker-game/assets/mushrooms"
OUTPUT_FILE = "/Users/antoinewiley/Roblox/my-roblox-clicker-game/scripts/asset_ids.json"
CREATOR_ID = "2270535666"
OPERATION_POLL_URL = "https://apis.roblox.com/assets/v1/{operation}"

def get_api_key():
    result = subprocess.run(
        ["security", "find-generic-password", "-s", "roblox-funguy-assets", "-a", "antoinewiley", "-w"],
        capture_output=True, text=True
    )
    return result.stdout.strip()

def upload_asset(api_key, fbx_path, name):
    url = "https://apis.roblox.com/assets/v1/assets"
    request_json = json.dumps({
        "assetType": "Model",
        "displayName": name,
        "description": f"FunGuy mushroom: {name}",
        "creationContext": {
            "creator": {"userId": CREATOR_ID}
        }
    }).encode()

    with open(fbx_path, "rb") as f:
        fbx_data = f.read()

    boundary = "boundary123456789"
    body = (
        f"--{boundary}\r\n"
        f'Content-Disposition: form-data; name="request"\r\n'
        f"Content-Type: application/json\r\n\r\n"
    ).encode() + request_json + (
        f"\r\n--{boundary}\r\n"
        f'Content-Disposition: form-data; name="fileContent"; filename="{os.path.basename(fbx_path)}"\r\n'
        f"Content-Type: model/fbx\r\n\r\n"
    ).encode() + fbx_data + f"\r\n--{boundary}--\r\n".encode()

    req = urllib.request.Request(url, data=body, method="POST")
    req.add_header("x-api-key", api_key)
    req.add_header("Content-Type", f"multipart/form-data; boundary={boundary}")

    try:
        with urllib.request.urlopen(req) as resp:
            return json.loads(resp.read())
    except urllib.error.HTTPError as e:
        return {"error": e.read().decode()}

def poll_operation(api_key, operation_path, max_wait=120):
    url = f"https://apis.roblox.com/assets/v1/{operation_path}"
    for _ in range(max_wait // 5):
        req = urllib.request.Request(url)
        req.add_header("x-api-key", api_key)
        with urllib.request.urlopen(req) as resp:
            data = json.loads(resp.read())
        if data.get("done"):
            return data.get("response", {}).get("assetId")
        time.sleep(5)
    return None

def main():
    api_key = get_api_key()
    if not api_key:
        print("ERROR: Could not load API key from Keychain")
        return

    fbx_files = sorted([
        f for f in os.listdir(ASSETS_DIR)
        if f.endswith("_reduced.fbx")
    ])

    print(f"Found {len(fbx_files)} FBX files to upload\n")

    # Load existing results if resuming
    results = {}
    if os.path.exists(OUTPUT_FILE):
        with open(OUTPUT_FILE) as f:
            results = json.load(f)

    for fbx_file in fbx_files:
        name = fbx_file.replace("_reduced.fbx", "")
        if name in results:
            print(f"  ✓ {name} already uploaded (ID: {results[name]})")
            continue

        fbx_path = os.path.join(ASSETS_DIR, fbx_file)
        print(f"  ↑ Uploading {name}...", end=" ", flush=True)

        resp = upload_asset(api_key, fbx_path, name)

        if "error" in resp:
            print(f"ERROR: {resp['error']}")
            continue

        operation_path = resp.get("path", "")
        if not operation_path:
            print(f"ERROR: No operation path in response: {resp}")
            continue

        asset_id = poll_operation(api_key, operation_path)
        if asset_id:
            results[name] = asset_id
            print(f"done (ID: {asset_id})")
        else:
            print("timed out")

        # Save after each upload in case of interruption
        with open(OUTPUT_FILE, "w") as f:
            json.dump(results, f, indent=2)

        time.sleep(1)

    print(f"\nDone! {len(results)}/{len(fbx_files)} assets uploaded.")
    print(f"Asset IDs saved to: {OUTPUT_FILE}")

if __name__ == "__main__":
    main()
