# Roblox + Claude Development Setup Guide (2026 Edition)

Professional development environment for building profitable Roblox games with AI assistance.

---

## **Executive Summary**

**2026 Roblox Stack:**
- **Code Sync:** Rojo (industry standard) syncs VS Code → Roblox Studio in real-time
- **Package Mgmt:** Wally + Rokit (newer toolchain manager, replaces Foreman)
- **Code Quality:** Luau Language Server + Selene (linting) + StyLua (formatting)
- **AI Integration:** Roblox Studio MCP (direct Claude ↔ Studio communication)
- **Version Control:** Git + GitHub (essential for team & portfolio)
- **AI Planning:** Roblox Planning Mode (agentic AI for dev planning)
- **Asset Creation:** AI mesh generation from text descriptions

---

## **Phase 1: Core Requirements (30 min)**

### 1.1 System Specs
- **OS:** Windows 10+, macOS 10.11+
- **Note:** No official Linux support; macOS 10.11 minimum
- **RAM:** 8GB minimum (16GB recommended)
- **Disk Space:** 20GB free
- **Internet:** Stable 4-8 MB/s+ recommended
- **GPU:** Dedicated or integrated GPU (less than 5 years for desktop, less than 3 years for laptop)

### 1.2 Install Roblox Studio
1. Go to [create.roblox.com](https://create.roblox.com)
2. Sign in/create free Roblox account
3. Click "Create" → Download Roblox Studio
4. Install and launch

**Verify:** Open Roblox Studio, create new blank project. Should load in <10 seconds.

---

## **Phase 2: Developer Tools (1 hour)**

### 2.1 Install Git
- **Windows:** Download from [git-scm.com](https://git-scm.com)
- **Mac:** `brew install git`
- **Verify:** `git --version`

### 2.2 Install Node.js (LTS)
- Download from [nodejs.org](https://nodejs.org)
- Version 18+ required for package managers

**Verify:** `node --version` and `npm --version`

### 2.3 Install VS Code (Recommended)
- Download from [code.visualstudio.com](https://code.visualstudio.com)
- Essential extensions (Phase 5)

---

## **Phase 3: Roblox Toolchain (1.5 hours)**

### 3.1 Install Rokit (Next-Gen Toolchain Manager)
**Why Rokit over Foreman?**
- Faster installation times
- Better cross-platform compatibility
- Rokit is the recommended modern choice (Foreman maintenance is uncertain)

```bash
# Windows (via Scoop)
scoop install rokit

# Mac (via Homebrew)
brew install rokit

# Linux (download from https://github.com/rojo-rbx/rokit/releases)
```

**Verify:** `rokit --version`

### 3.2 Initialize Rokit in Project
```bash
cd your-roblox-game-folder
rokit init
```

This creates `rokit.toml`. Now install tools:
```bash
rokit toolchain install
```

This installs Rojo, Selene, StyLua, and other tools specified in your config.

### 3.3 Install Rojo (File Sync Engine)
Rojo is automatically installed via Rokit. It's the **industry standard** for syncing code to Studio.

```bash
# Verify Rojo installed
rojo --version
```

**What Rojo Does:**
- Syncs code files from VS Code → Roblox Studio in real-time
- Zero manual copy-pasting
- Enables professional version control workflow
- Works with hot-reload (changes appear instantly)

### 3.4 Install Wally (Package Manager)
```bash
rokit add wally
rokit toolchain install
```

**What Wally Does:**
- Manages Roblox library dependencies
- Similar to npm for JavaScript
- Prevents version conflicts on team projects

**Verify:** `wally --version`

---

## **Phase 4: Claude Code + Roblox Studio MCP (1.5 hours)**

### 4.1 Install Claude Code
```bash
npm install -g @anthropic-ai/claude-code
```

**Verify:** `claude-code --version`

### 4.2 Choose Your MCP Server

You have **3 options** for Roblox Studio MCP:

#### Option A: Official Roblox MCP (Recommended)
Most stable, maintained by Roblox directly.

```bash
npm install -g @roblox/studio-mcp
```

#### Option B: WEPPY MCP (Feature-Rich Alternative)
Better for mesh generation and asset management.

```bash
npm install -g weppy-roblox-mcp
```

#### Option C: Community MCP (ZubeidHendricks)
Well-established in community.

```bash
npm install -g zubeidhendricks-roblox-studio-mcp
```

**Choose one** based on preference. Official Roblox MCP is safest choice.

### 4.3 Configure Claude Code for Roblox
Create `.claude-code-config.json` in project root:

```json
{
  "mcpServers": {
    "roblox-studio": {
      "command": "roblox-studio-mcp",
      "env": {
        "STUDIO_PORT": "8008"
      }
    }
  },
  "tools": [
    "file_operations",
    "bash",
    "roblox_studio",
    "javascript_exec"
  ]
}
```

**Verify:** `claude-code --list-tools` should show Roblox Studio tools

### 4.4 Test MCP Connection
```bash
claude-code "List all scripts in the current Roblox game"
```

Should return list of scripts from your open Studio project.

---

## **Phase 5: VS Code Setup (45 min)**

### 5.1 Install Essential Extensions
1. Open VS Code
2. Extensions (Ctrl+Shift+X)
3. Install:
   - **Roblox** (by Roblox) - Official Roblox support
   - **Luau Language Server** (by JohnnyMorganz) - Type checking & autocomplete
   - **Selene** (by JohnnyMorganz) - Lua linter
   - **StyLua** (by JohnnyMorganz) - Code formatter
   - **GitLens** (by Eric Amodio) - Git integration
   - **Thunder Client** or **REST Client** - API testing (optional)

### 5.2 Configure Settings
Create `.vscode/settings.json`:

```json
{
  "luau-lsp.sourcemap.autogenerate": true,
  "luau-lsp.sourcemap.enabled": true,
  "[lua]": {
    "editor.defaultFormatter": "JohnnyMorganz.stylua",
    "editor.formatOnSave": true,
    "editor.tabSize": 4
  },
  "selene.lintOn": "save",
  "search.exclude": {
    "**/.git": true,
    "**/node_modules": true,
    "**/packages": true
  }
}
```

### 5.3 Create Workspace Settings
`.vscode/launch.json` (for debugging):

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Attach to Roblox Studio",
      "type": "lua",
      "request": "attach",
      "sourceRoot": "${workspaceFolder}/src",
      "host": "localhost",
      "port": 55999
    }
  ]
}
```

---

## **Phase 6: Project Structure & Git (45 min)**

### 6.1 Clone Recommended Template
```bash
git clone https://github.com/MonzterDev/Roblox-Game-Template.git my-roblox-game
cd my-roblox-game
```

### 6.2 Directory Structure (Optimized)
```
my-roblox-game/
├── src/
│   ├── shared/              # Both client & server
│   │   ├── Constants.lua
│   │   ├── Config.lua
│   │   └── Util/
│   ├── client/              # Client-side only
│   │   ├── UI/
│   │   ├── Input.lua
│   │   └── LocalPlayer.lua
│   └── server/              # Server-side only
│       ├── GameLogic.lua
│       ├── PlayerData.lua
│       ├── Monetization.lua
│       └── API/
├── rokit.toml               # Toolchain versions (Rokit)
├── wally.toml               # Package dependencies
├── rojo.json                # File sync config
├── selene.toml              # Linter config
├── .github/
│   └── workflows/
│       └── lint.yml         # CI/CD (optional)
└── README.md
```

### 6.3 Create GitHub Repository
```bash
git init
git add .
git commit -m "Initial: Roblox clicker game setup"

# On GitHub, create repo, then:
git remote add origin https://github.com/YOUR_USERNAME/my-roblox-game.git
git branch -M main
git push -u origin main
```

### 6.4 Create .gitignore
```
# Dependencies
packages/
*.lock

# Roblox files
*.rbxmx
*.rbxlx

# Tools
.selene/
.stylua/

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db

# Build outputs
build/
dist/
```

---

## **Phase 7: Rojo Configuration (30 min)**

### 7.1 Create `rojo.json`
```json
{
  "name": "roblox-clicker-game",
  "tree": {
    "$className": "DataModel",
    "ReplicatedStorage": {
      "$className": "Folder",
      "Shared": {
        "$path": "src/shared"
      }
    },
    "ServerScriptService": {
      "$className": "Folder",
      "Server": {
        "$path": "src/server"
      }
    },
    "StarterPlayer": {
      "$className": "Folder",
      "StarterPlayerScripts": {
        "$className": "Folder",
        "Client": {
          "$path": "src/client"
        }
      }
    }
  }
}
```

### 7.2 Test Rojo Sync
```bash
rojo serve
```

Open Roblox Studio → **Plugins** → **Rojo** → **Connect**

Files should sync instantly. Create a test file in VS Code, watch it appear in Studio.

---

## **Phase 8: GitHub Actions CI/CD (Optional, 20 min)**

### 8.1 Create Automated Linting
`.github/workflows/lint.yml`:

```yaml
name: Lint Code

on: [push, pull_request]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Selene
        run: |
          curl -L https://github.com/Kampfkarren/selene/releases/download/0.25.0/selene-0.25.0-linux.zip -o selene.zip
          unzip selene.zip
      - name: Run Selene
        run: ./selene src/
```

This auto-checks code quality on every push.

---

## **Phase 9: AI Tools Available in 2026 (New!)**

### 9.1 Roblox Planning Mode
Built-in agentic AI in Roblox Creator Hub. Use before coding to:
- Generate development plans from text prompts
- Create game architecture
- Design feature roadmaps

### 9.2 AI Mesh Generation
Text → 3D models in seconds:
- "medieval wooden chair"
- "sci-fi control panel"
- Works with Creator Store integration

### 9.3 Claude Code + Studio MCP
- Generate Lua code → directly insert into Studio
- Run code and see output instantly
- Debug by inspecting game state from terminal

---

## **Phase 10: Setup Verification Checklist**

- [ ] Roblox Studio installs and creates projects
- [ ] Git is installed and working
- [ ] Rokit installed with Rojo, Wally, Selene, StyLua
- [ ] Rojo syncs files from VS Code → Studio in real-time
- [ ] VS Code has Luau Language Server working
- [ ] Claude Code recognizes Roblox Studio MCP tools
- [ ] GitHub repo created and linked locally
- [ ] Selene lints code without major errors
- [ ] StyLua auto-formats on save
- [ ] Can run `claude-code` commands successfully

---

## **Phase 11: Workflow (Your Day-to-Day)**

```bash
# Start your session:
rojo serve              # Terminal 1: Syncs files to Studio
code .                  # Terminal 2: Open code editor

# When writing code:
# 1. Edit code in VS Code
# 2. Rojo auto-syncs to Studio
# 3. Test in Studio
# 4. Commit changes to Git

# When generating with Claude:
claude-code "Create a clicker button script in src/client/ClickerButton.lua"

# Generate → Auto-syncs via Rojo → Appears in Studio instantly

# Push to GitHub when milestone done:
git add .
git commit -m "Add clicker mechanics"
git push
```

---

## **Estimated Total Setup Time: 6-8 hours**

- Phase 1: 30 min
- Phase 2: 1 hour
- Phase 3: 1.5 hours
- Phase 4: 1.5 hours
- Phase 5: 45 min
- Phase 6: 45 min
- Phase 7: 30 min
- Phase 8: 20 min
- Phase 9: Overview only
- Phase 10-11: Testing

---

## **Troubleshooting**

### Rojo won't connect to Studio
```bash
# Make sure Rojo plugin is installed:
# Studio → Plugins → Manage Plugins → Search "Rojo"

# If missing, install from Creator Store
# Then: rojo serve → Studio Plugins → Rojo → Connect
```

### Claude Code doesn't see Roblox tools
```bash
# Reinstall MCP
npm uninstall -g roblox-studio-mcp
npm install -g roblox-studio-mcp

# Restart Claude Code
```

### Luau Language Server not working
```bash
# Reload VS Code window: Ctrl+Shift+P → "Developer: Reload Window"
# Check .vscode/settings.json exists in project root
```

### Wally packages not installing
```bash
# Verify wally.toml exists
# Run: wally install
# Check Packages/ folder created
```

---

## **Key Advantages of This Setup**

✅ **Professional Grade** - Used by studios building Roblox games  
✅ **AI-Native** - Direct Claude Code ↔ Studio integration  
✅ **Version Control** - Full Git history and team collaboration  
✅ **Code Quality** - Linting + formatting catches bugs early  
✅ **Real-time Sync** - No manual copy-pasting between tools  
✅ **Scalable** - Works for solo projects or large teams  
✅ **Portfolio Ready** - GitHub proves you shipped games  

---

## **Next Steps**

1. Complete **Phases 1-7** (essential)
2. **Verify everything** syncs (Phase 10)
3. **Create first test file** in VS Code → confirm appears in Studio
4. **Run Claude Code command** → watch script generate and sync
5. Ready to build your clicker game!

Let me know when setup is complete. We'll start generating your clicker game code. 🚀
