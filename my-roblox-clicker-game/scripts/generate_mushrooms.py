#!/usr/bin/env python3
"""
FunGuy — Meshy AI Mushroom Batch Generator
Generates all 36 mushroom species as FBX files using Meshy text-to-3D API.
API key read from macOS Keychain (service: GameDevMeshy). Never stored in code.

Usage: python3 scripts/generate_mushrooms.py
"""

import subprocess, json, time, os, sys
import urllib.request, urllib.error

# ── Config ─────────────────────────────────────────────────────────────────────
OUT_DIR   = os.path.join(os.path.dirname(__file__), "..", "assets", "mushrooms")
API_BASE  = "https://api.meshy.ai/openapi/v2/text-to-3d"
ART_STYLE = "realistic"
NEG_PROMPT = (
    "low quality, blurry, ugly, floating disconnected parts, "
    "multiple unrelated objects, text, watermark, background scene"
)
POLL_INTERVAL = 15  # seconds between status checks

# ── Keychain ───────────────────────────────────────────────────────────────────
def get_api_key():
    r = subprocess.run(
        ["security", "find-generic-password", "-s", "GameDevMeshy", "-w"],
        capture_output=True, text=True
    )
    key = r.stdout.strip()
    if not key:
        sys.exit("ERROR: Could not retrieve GameDevMeshy key from Keychain.\n"
                 "Run: security add-generic-password -s GameDevMeshy -a $(whoami) -w YOUR_KEY")
    return key

# ── Mushroom Definitions ────────────────────────────────────────────────────────
# (id, tier, prompt)
MUSHROOMS = [
    # ── Common ─────────────────────────────────────────────────────────────────
    ("button",        "Common",
     "single button mushroom, smooth ivory-white perfectly domed cap, short thick "
     "cylindrical white stem, pale pink gills underneath, clean compact form, "
     "bioluminescent warm white rim glow, dark cave fantasy mushroom game asset"),

    ("oyster",        "Common",
     "oyster mushroom cluster, overlapping fan-shaped grey-cream caps growing sideways, "
     "wavy ruffled edges, stubby off-center stem, silver-blue bioluminescent shimmer "
     "on gill lines, dark cave fantasy game asset"),

    ("shiitake",      "Common",
     "shiitake mushroom, broad umbrella-shaped brown cap with cracked pale tan mosaic "
     "pattern radiating from center, cream fibrous stem, warm amber bioluminescent glow "
     "through cracked cap pattern, dark cave fantasy game asset"),

    ("chanterelle",   "Common",
     "chanterelle mushroom, golden-yellow deeply funnel-shaped cap ruffled at edges, "
     "forking blunt ridge veins instead of gills running down stem, apricot-gold color, "
     "warm golden bioluminescent lantern glow, dark cave fantasy game asset"),

    ("portobello",    "Common",
     "portobello mushroom, large flat open dark chocolate-brown cap, wide relative to "
     "thick pale stem, deep dark gills exposed underneath, amber-brown bioluminescent "
     "glow along gill edges, dark cave fantasy game asset"),

    ("enoki",         "Common",
     "enoki mushroom cluster, dense bundle of long thin white stems topped with tiny "
     "pin-sized round caps, slightly translucent stems, soft white bioluminescent glow "
     "running up each stem like fiber optic light, dark cave fantasy game asset"),

    ("maitake",       "Common",
     "maitake mushroom hen of the woods, large mass of overlapping grey-brown fronds "
     "with wavy edges radiating from central base, silver-green bioluminescent edge "
     "lining on each frond, dark cave fantasy game asset"),

    ("porcini",       "Common",
     "porcini mushroom, bulbous rounded chocolate-brown cap, thick swollen white stem "
     "with fine net-like reticulate pattern, sponge of pores underneath, warm cream-gold "
     "bioluminescent glow from pore layer, dark cave fantasy game asset"),

    ("morel",         "Common",
     "morel mushroom, hollow conical cap completely covered in deep honeycomb network "
     "of ridges and pits like natural lattice, earthy tan-brown, hollow white stem, "
     "pale amber bioluminescent light channeled through honeycomb pattern, dark cave "
     "fantasy game asset"),

    ("lionsmane",     "Common",
     "lion's mane mushroom, cascading pom-pom of long white icicle-like spines drooping "
     "downward from central mass, no cap or stem visible, white shaggy spherical form, "
     "cool blue-white bioluminescent glow at each spine tip, dark cave fantasy game asset"),

    ("kingtrumpet",   "Common",
     "king trumpet mushroom, very thick meaty white barrel cylindrical stem dominating "
     "the form, small flat pale grey-brown cap on top, smooth firm stem, pale violet "
     "bioluminescent glow rising from stem base upward, dark cave fantasy game asset"),

    ("cremini",       "Common",
     "cremini mushroom, light caramel-brown firmly domed smooth cap, compact classic "
     "mushroom shape, pale stem, soft warm orange bioluminescent glow at cap center, "
     "dark cave fantasy game asset"),

    # ── Uncommon ───────────────────────────────────────────────────────────────
    ("henofwoods",    "Uncommon",
     "hen of the woods mushroom, massive overlapping rosettes of dark grey-brown wavy "
     "tongue-shaped fronds, paler underside, wide fan radiating from central branching "
     "base, silvery-green bioluminescent shimmer on each frond underside, dark cave "
     "fantasy game asset"),

    ("blacktrumpet",  "Uncommon",
     "black trumpet mushroom cluster, deeply funnel-shaped trumpets with no cap flared "
     "open like horns, dark grey to near-black, finely wrinkled channeled surface, "
     "deep violet bioluminescent glow rising from inside each funnel, dark cave "
     "fantasy game asset"),

    ("lobster",       "Uncommon",
     "lobster mushroom, irregular lumpy rounded form coated in vivid cracked orange-red "
     "shell like lobster carapace, white flesh visible in cracks, glowing coral-orange "
     "bioluminescent light with bright white crack lines, dark cave fantasy game asset"),

    ("coralfungus",   "Uncommon",
     "coral fungus, branching upward-reaching fingers of pale yellow-cream color, smooth "
     "rounded tips, densely packed fractal bushy structure like undersea coral, soft "
     "yellow-green bioluminescent glow rippling down from each branch tip, dark cave "
     "fantasy game asset"),

    ("cauliflower",   "Uncommon",
     "cauliflower fungus, extremely dense convoluted cream pale-yellow fronds folded "
     "tightly, brain-like cloud mass of ruffled wavy lobes, no clear cap or stem, "
     "warm golden bioluminescent light glowing from within the folds like a lantern, "
     "dark cave fantasy game asset"),

    ("chestnut",      "Uncommon",
     "chestnut mushroom cluster, tight group of small mushrooms, warm chestnut-brown "
     "convex smooth glossy caps touching each other, slender pale stems, rich amber-brown "
     "bioluminescent glow at each cap center, dark cave fantasy game asset"),

    ("velvetpiop",    "Uncommon",
     "velvet pioppino mushroom cluster, dark chocolate-brown bell-shaped caps with "
     "distinctly velvety matte suede texture, slight central bump, slender pale tan "
     "stems, deep purple-brown bioluminescent glow at cap center fading to dark edges, "
     "dark cave fantasy game asset"),

    ("nameko",        "Uncommon",
     "nameko mushroom cluster, dense group of small glossy amber-orange caps with "
     "gelatinous wet-looking coating, rich caramel to tangerine orange, slender pale "
     "stems, bright warm orange bioluminescent glow amplified by reflective surface, "
     "dark cave fantasy game asset"),

    # ── Rare ───────────────────────────────────────────────────────────────────
    ("matsutake",     "Rare",
     "matsutake mushroom, thick firm white-to-brown mottled cap with fibrous shaggy "
     "surface, prominent ring on dense white stem, robust architectural silhouette, "
     "warm cream bioluminescent glow with cinnamon-brown accents, dark cave fantasy "
     "game asset"),

    ("caesars",       "Rare",
     "caesar's mushroom amanita, vivid scarlet-orange smooth convex cap, bright yellow "
     "stem inside white egg-like volva sac at base, bright orange-red cap glow and soft "
     "white volva glow creating flame-like contrast, dark cave fantasy game asset"),

    ("saffronmilk",   "Rare",
     "saffron milk cap mushroom, flat funnel-shaped orange cap with faint concentric "
     "darker rings, slightly tacky surface, vivid orange gills, pale orange hollow stem, "
     "deep saffron-amber bioluminescent glow throughout, dark cave fantasy game asset"),

    ("indigomilk",    "Rare",
     "indigo milk cap mushroom, blue-grey cap with concentric darker bands, smooth waxy "
     "surface, deep blue gills, deep indigo-blue bioluminescent glow, dark cave "
     "fantasy game asset"),

    ("chickenwoods",  "Rare",
     "chicken of the woods mushroom, broad overlapping shelf brackets, vivid yellow-orange "
     "on top bright yellow underside, large layered fans stacked like plates, blazing "
     "orange-yellow bioluminescent glow radiating outward, dark cave fantasy game asset"),

    ("giantpuffball", "Rare",
     "giant puffball mushroom, perfectly smooth large white sphere sitting on ground, "
     "no cap no stem no gills, slightly leathery surface, pure steady white bioluminescent "
     "glow like a miniature moon, dark cave fantasy game asset"),

    ("hedgehog",      "Rare",
     "hedgehog mushroom, pale cream-yellow convex cap smooth on top, underside covered "
     "in hundreds of tiny densely packed cream-white downward-hanging spines like "
     "stalactites, pale gold cap glow with cool blue-white pinpoints at each spine tip, "
     "dark cave fantasy game asset"),

    ("flyagaric",     "Rare",
     "fly agaric amanita muscaria, vivid scarlet-red hemispherical dome cap covered in "
     "irregular white wart spots, sturdy white stem with prominent skirt-like ring, "
     "bulbous white volva base, deep vermillion-crimson cap glow with blazing white "
     "spots like scattered stars, dark cave fantasy game asset"),

    # ── Epic ───────────────────────────────────────────────────────────────────
    ("ghostfungus",   "Epic",
     "ghost fungus, flat wavy bracket-like pale cream-white caps in overlapping cluster, "
     "slightly translucent waxy surface, white closely-spaced gills, full intense "
     "green-white bioluminescent glow across entire cap surface, dark cave fantasy "
     "game asset"),

    ("bleedingtooth", "Epic",
     "bleeding tooth mushroom, pure white lumpy rounded irregular cap, bright blood-red "
     "droplets forming on surface and dripping from edges, white body with vivid glowing "
     "crimson red sap drops, dramatic contrast, dark cave fantasy game asset"),

    ("amethyst",      "Epic",
     "amethyst deceiver mushroom, intensely vivid violet-purple convex smooth cap, "
     "slender violet stem, violet gills, fully saturated uniform deep purple throughout, "
     "deep purple bioluminescent glow covering the entire mushroom, dark cave fantasy "
     "game asset"),

    ("violetweb",     "Epic",
     "violet webcap cortinarius mushroom, lilac-violet convex silky cap, fine cobweb-like "
     "violet threads connecting cap edge to stem like a veil, club-shaped base, pale "
     "violet stem, violet bioluminescent glow, dark cave fantasy game asset"),

    ("biolumpanellus","Epic",
     "bioluminescent panellus mushroom, small fan-shaped orange-brown caps in tight "
     "overlapping cluster on flat surface, orange-tinted caps, pale tan gills, intense "
     "green-blue bioluminescent glow from gills and underside creating two-tone light "
     "effect, dark cave fantasy game asset"),

    # ── Mythic ─────────────────────────────────────────────────────────────────
    ("goldenteacher", "Mythic",
     "golden teacher mushroom, large broad golden-caramel smooth convex cap with slight "
     "central nipple, pale yellow-gold gills, thick white stem with prominent skirt-like "
     "ring midway up, radiant golden-amber bioluminescent glow filling surrounding area, "
     "glowing white ring like a halo, dark cave fantasy game asset"),

    ("azuredragon",   "Mythic",
     "azure dragon oyster mushroom, enormous fan-shaped clusters deep sapphire blue with "
     "iridescent dragon-scale patterning across cap surface, each scale catching light "
     "differently, silver-white gills, multiple caps layered like armor plates, deep blue "
     "bioluminescent glow with shifting iridescent blue-teal highlights, dark cave "
     "fantasy game asset"),

    ("starfire",      "Mythic",
     "starfire mushroom, large perfectly circular convex cap near-black on top with "
     "radiating star pattern of bioluminescent white-gold veins spreading from center "
     "to edges like a galaxy map, dark smooth slightly translucent stem, glowing "
     "star-vein pattern, particles of light drifting upward, dark cave fantasy game asset"),

    # ── Shared prop ────────────────────────────────────────────────────────────
    ("rootspot",      "Prop",
     "mycelium root cluster on cave floor, thick gnarled dark roots radiating outward "
     "from a central point, flat low-profile organic form, roots taper to thin thread-like "
     "tips, dark brown-grey with faint bioluminescent white glow at the root tips, "
     "no mushroom cap, top-down radial symmetry, dark cave fantasy game asset"),
]

# ── API Helpers ─────────────────────────────────────────────────────────────────
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

def create_task(key, prompt):
    return api_post(API_BASE, key, {
        "mode":             "preview",
        "prompt":           prompt,
        "art_style":        ART_STYLE,
        "negative_prompt":  NEG_PROMPT,
        "target_polycount": 5000,
    })

def poll_until_done(key, task_id, label):
    url = f"{API_BASE}/{task_id}"
    while True:
        result = api_get(url, key)
        status   = result.get("status",   "UNKNOWN")
        progress = result.get("progress", 0)
        if status == "SUCCEEDED":
            print()  # newline after \r progress
            return result
        elif status in ("FAILED", "EXPIRED"):
            print(f"\n  ✗ {label}: {status}")
            return None
        print(f"  ↻ {label}: {status} {progress}%   ", end="\r", flush=True)
        time.sleep(POLL_INTERVAL)

def download_file(url, path):
    urllib.request.urlretrieve(url, path)

# ── Main ────────────────────────────────────────────────────────────────────────
def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    key = get_api_key()
    print(f"✓ API key loaded from Keychain")
    print(f"  Generating {len(MUSHROOMS)} mushrooms → {os.path.abspath(OUT_DIR)}\n")

    failed = []
    for i, (mid, tier, prompt) in enumerate(MUSHROOMS, 1):
        out_path = os.path.join(OUT_DIR, f"{mid}.fbx")

        # Skip if already downloaded (re-run friendly)
        if os.path.exists(out_path) and os.path.getsize(out_path) > 1024:
            print(f"[{i:02}/{len(MUSHROOMS)}] ↷ {mid}.fbx already exists, skipping")
            continue

        print(f"[{i:02}/{len(MUSHROOMS)}] {tier:8}  {mid}")

        try:
            task_resp = create_task(key, prompt)
            task_id = task_resp.get("result")
            if not task_id:
                print(f"  ✗ No task ID: {task_resp}")
                failed.append(mid)
                continue

            result = poll_until_done(key, task_id, mid)
            if not result:
                failed.append(mid)
                continue

            urls = result.get("model_urls", {})
            fbx_url = urls.get("fbx")
            glb_url = urls.get("glb")

            if fbx_url:
                download_file(fbx_url, out_path)
                size_kb = os.path.getsize(out_path) // 1024
                print(f"  ✓ {mid}.fbx  ({size_kb} KB)")
            elif glb_url:
                out_path = out_path.replace(".fbx", ".glb")
                download_file(glb_url, out_path)
                size_kb = os.path.getsize(out_path) // 1024
                print(f"  ✓ {mid}.glb  ({size_kb} KB)  [no FBX available]")
            else:
                print(f"  ✗ No download URL in result for {mid}")
                failed.append(mid)

        except urllib.error.HTTPError as e:
            body = e.read().decode(errors="replace")
            print(f"  ✗ HTTP {e.code}: {body[:200]}")
            failed.append(mid)
        except Exception as e:
            print(f"  ✗ {type(e).__name__}: {e}")
            failed.append(mid)

    print(f"\n{'─' * 50}")
    succeeded = len(MUSHROOMS) - len(failed)
    print(f"Done: {succeeded}/{len(MUSHROOMS)} mushrooms generated.")
    if failed:
        print(f"Failed ({len(failed)}): {', '.join(failed)}")
        print("Re-run the script to retry — already-downloaded files are skipped.")

if __name__ == "__main__":
    main()
