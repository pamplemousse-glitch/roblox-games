# Quick Start: Automated Setup

Choose your setup method below.

---

## **Option A: Bash Script (Recommended for Mac)**

### Step 1: Make script executable
```bash
chmod +x ~/Roblox/Roblox/setup-roblox-dev.sh
```

### Step 2: Run setup
```bash
~/Roblox/Roblox/setup-roblox-dev.sh
```

**What it does:**
- ✓ Installs Homebrew (if needed)
- ✓ Installs Git, Node.js, Rokit
- ✓ Clones Roblox Game Template
- ✓ Installs Rojo, Wally, Selene, StyLua via Rokit
- ✓ Creates all config files
- ✓ Installs Claude Code + MCP
- ✓ Initializes Git repository
- ✓ Verifies everything

**Time:** ~10-15 minutes

**Requires:** Xcode Command Line Tools (script installs if missing)

---

## **Option B: Node.js Script (Cross-Platform)**

Requires: Git, Node.js 18+, and Rokit installed separately

### Step 1: Make script executable
```bash
chmod +x ~/Roblox/Roblox/setup-roblox-dev.js
```

### Step 2: Run setup
```bash
node ~/Roblox/Roblox/setup-roblox-dev.js
```

**Difference from Bash:**
- Doesn't install Rokit (you must install manually)
- Better error handling
- Cross-platform compatible

---

## **Option C: Manual (If Bash/Node Fail)**

Follow the 11 phases in `ROBLOX_DEV_SETUP_GUIDE_UPDATED.md` manually.

---

## **What Gets Created**

After setup, you'll have:

```
~/Roblox/my-roblox-clicker-game/
├── src/
│   ├── shared/
│   ├── client/
│   └── server/
├── .vscode/
│   ├── settings.json      # Luau autocomplete config
│   └── launch.json        # Debug config
├── .claude-code-config.json  # Claude Code MCP config
├── .gitignore             # Git ignore rules
├── rojo.json              # File sync config
├── wally.toml             # Package manager config
├── rokit.toml             # Tool versions
└── .git/                  # Git repository
```

---

## **Post-Setup: Verify Everything Works**

### Test 1: Rojo Sync
```bash
cd ~/Roblox/my-roblox-clicker-game
rojo serve
```
Open Roblox Studio → Plugins → Rojo → Connect
✓ Should say "Connected"

### Test 2: Create Test File
In VS Code, create `src/shared/TestModule.lua`:
```lua
local Test = {}
function Test.sayHello()
    return "Hello from Roblox!"
end
return Test
```

In Roblox Studio, check ReplicatedStorage > Shared > TestModule
✓ Should appear instantly

### Test 3: Claude Code
```bash
claude-code "List all the scripts in my Roblox game"
```
✓ Should show scripts from your open Studio project

---

## **Troubleshooting**

### "Permission denied" when running bash script
```bash
chmod +x setup-roblox-dev.sh
```

### Script hangs on Homebrew
Press Ctrl+C, then manually:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Rojo plugin not in Studio
- Download Roblox Studio from https://create.roblox.com
- Studio → Creator Store → Search "Rojo" → Install

### Claude Code doesn't see Roblox tools
```bash
npm uninstall -g roblox-studio-mcp
npm install -g roblox-studio-mcp
```

---

## **Next Steps After Setup**

1. ✓ Complete setup (10-15 min)
2. ✓ Verify everything syncs (5 min)
3. → Start building clicker game (we'll generate code together)
4. → Deploy to Roblox

---

## **Questions?**

See `ROBLOX_DEV_SETUP_GUIDE_UPDATED.md` for full documentation.
