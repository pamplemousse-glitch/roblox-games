#!/usr/bin/env python3
"""
FunGuy — Blender batch poly reducer + tier resizer
Processes all {id}.fbx files in assets/mushrooms/ that don't already have a _reduced version.

Run:
  /Applications/Blender.app/Contents/MacOS/Blender --background --python scripts/blender_reduce.py

Per model:
  1. Import FBX
  2. Join all meshes into one
  3. Scale to tier target height (1 Blender unit = 1 Roblox stud)
  4. Decimate to ~5000 triangles
  5. Export as {id}_reduced.fbx
"""

import bpy
import os

SCRIPT_DIR   = os.path.dirname(os.path.abspath(__file__))
MUSHROOM_DIR = os.path.normpath(os.path.join(SCRIPT_DIR, "..", "assets", "mushrooms"))
TARGET_TRIS  = 5000

# Midpoint of each tier's height range (studs). 1 BU = 1 stud.
TIER_HEIGHT = {
    "Common":   1.25,   # 1.0–1.5 studs — ankle-height
    "Uncommon": 2.25,   # 2.0–2.5 studs — knee-height
    "Rare":     3.25,   # 3.0–3.5 studs — waist-height
    "Epic":     4.25,   # 4.0–4.5 studs — chest-height
    "Mythic":   6.0,    # 5.0–7.0 studs — towering
    "Prop":     0.25,   # rootspot — flat low-profile ground piece
}

# Full species → tier map (matches generate_mushrooms.py MUSHROOMS list)
SPECIES_TIER = {
    # Common (12)
    "button":        "Common",
    "oyster":        "Common",
    "shiitake":      "Common",
    "chanterelle":   "Common",
    "portobello":    "Common",
    "enoki":         "Common",
    "maitake":       "Common",
    "porcini":       "Common",
    "morel":         "Common",
    "lionsmane":     "Common",
    "kingtrumpet":   "Common",
    "cremini":       "Common",
    # Uncommon (8)
    "henofwoods":    "Uncommon",
    "blacktrumpet":  "Uncommon",
    "lobster":       "Uncommon",
    "coralfungus":   "Uncommon",
    "cauliflower":   "Uncommon",
    "chestnut":      "Uncommon",
    "velvetpiop":    "Uncommon",
    "nameko":        "Uncommon",
    # Rare (8)
    "matsutake":     "Rare",
    "caesars":       "Rare",
    "saffronmilk":   "Rare",
    "indigomilk":    "Rare",
    "chickenwoods":  "Rare",
    "giantpuffball": "Rare",
    "hedgehog":      "Rare",
    "flyagaric":     "Rare",
    # Epic (5)
    "ghostfungus":    "Epic",
    "bleedingtooth":  "Epic",
    "amethyst":       "Epic",
    "violetweb":      "Epic",
    "biolumpanellus": "Epic",
    # Mythic (3)
    "goldenteacher": "Mythic",
    "azuredragon":   "Mythic",
    "starfire":      "Mythic",
    # Prop (1)
    "rootspot":      "Prop",
}


def clear_scene():
    bpy.ops.object.select_all(action='SELECT')
    bpy.ops.object.delete()
    for block in bpy.data.meshes:
        if block.users == 0:
            bpy.data.meshes.remove(block)


def tri_count(obj):
    obj.data.calc_loop_triangles()
    return len(obj.data.loop_triangles)


def process(species_id, tier):
    in_path  = os.path.join(MUSHROOM_DIR, f"{species_id}.fbx")
    out_path = os.path.join(MUSHROOM_DIR, f"{species_id}_reduced.fbx")

    if not os.path.exists(in_path):
        print(f"[{species_id}] ↷ no .fbx found, skipping")
        return

    if os.path.exists(out_path) and os.path.getsize(out_path) > 1024:
        print(f"[{species_id}] ↷ _reduced already exists, skipping")
        return

    print(f"\n[{species_id}] tier={tier}  target_height={TIER_HEIGHT[tier]} studs")

    clear_scene()

    bpy.ops.import_scene.fbx(filepath=in_path)

    meshes = [o for o in bpy.context.scene.objects if o.type == 'MESH']
    if not meshes:
        print(f"  ✗ no mesh objects in file, skipping")
        return

    # Join everything into one mesh
    bpy.ops.object.select_all(action='DESELECT')
    for m in meshes:
        m.select_set(True)
    bpy.context.view_layer.objects.active = meshes[0]
    if len(meshes) > 1:
        bpy.ops.object.join()

    obj = bpy.context.active_object
    bpy.ops.object.transform_apply(location=True, rotation=True, scale=True)

    # Scale to tier height
    current_h = obj.dimensions.z
    target_h  = TIER_HEIGHT[tier]
    if current_h > 0.0001:
        s = target_h / current_h
        obj.scale = (s, s, s)
        bpy.ops.object.transform_apply(scale=True)
        print(f"  Scale: {current_h:.4f} → {target_h} BU  (×{s:.4f})")
    else:
        print(f"  ⚠ zero height, skipping scale step")

    # Decimate — up to 3 passes to handle extreme poly counts
    initial = tri_count(obj)
    print(f"  Tris: {initial:,} → target {TARGET_TRIS:,}")

    for pass_num in range(3):
        current = tri_count(obj)
        if current <= TARGET_TRIS:
            break
        mod = obj.modifiers.new(f"Decimate_{pass_num}", 'DECIMATE')
        mod.decimate_type = 'COLLAPSE'
        mod.ratio = max(0.001, TARGET_TRIS / current)
        bpy.ops.object.modifier_apply(modifier=mod.name)
        print(f"  Pass {pass_num + 1}: {tri_count(obj):,} tris")

    final = tri_count(obj)
    if final > TARGET_TRIS:
        print(f"  ⚠ Could not reach target — {final:,} tris remaining")
    else:
        print(f"  ✓ Final: {final:,} tris")

    # Export
    bpy.ops.export_scene.fbx(
        filepath=out_path,
        use_selection=False,
        global_scale=1.0,
        apply_unit_scale=True,
        apply_scale_options='FBX_SCALE_NONE',
        bake_space_transform=False,
        use_mesh_modifiers=True,
        mesh_smooth_type='FACE',
    )

    size_kb = os.path.getsize(out_path) // 1024
    print(f"  ✓ {species_id}_reduced.fbx  ({size_kb} KB)")


def main():
    print("=" * 54)
    print("FunGuy — Blender Batch Reducer")
    print(f"Dir:    {MUSHROOM_DIR}")
    print(f"Target: {TARGET_TRIS:,} triangles per model")
    print("=" * 54)

    for species_id, tier in SPECIES_TIER.items():
        process(species_id, tier)

    print("\n" + "─" * 54)
    print("Done.")


main()
