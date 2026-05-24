# Roblox + Claude Development Setup Guide

Your optimal development environment for building profitable Roblox games with AI assistance.

---

## **Phase 1: Core Requirements (30 min)**

### 1.1 System Specs
- **OS:** Windows 10+, macOS 10.14+, or Linux
- **RAM:** 8GB minimum (16GB recommended)
- **Disk Space:** 20GB free
- **Internet:** Stable connection required

### 1.2 Install Roblox Studio
1. Go to [create.roblox.com](https://create.roblox.com)
2. Sign in/create free Roblox account
3. Click "Create" → Download Roblox Studio
4. Install and launch

**Verify:** Open Roblox Studio, create new blank project. Should load in <10 seconds.

---

## **Phase 2: Developer Tools (45 min)**

### 2.1 Install Git
- **Windows/Mac:** Download from [git-scm.com](https://git-scm.com)
- **Linux:** `sudo apt-get install git`

**Verify:** Open terminal/cmd, run `git --version`

### 2.2 Install Node.js (LTS)
- Download from [nodejs.org](https://nodejs.org)
- Version 18+ required

**Verify:** Run `node --version` and `npm --version`

### 2.3 Install VS Code (Optional but Recommended)
- Download from [code.visualstudio.com](https://code.visualstudio.com)
- Install "Roblox" extension by Roblox

---

## **Phase 3: Roblox Development Tools (1 hour)**

### 3.1 Install Foreman (Toolchain Manager)
Controls versions of Rojo, Selene, Stylua automatically.

```bash
# Windows: Use Scoop
scoop install foreman

# Mac: Use Homebrew
brew install foreman

# Linux: Download from https://github.com/roblox/foreman/releases
```

**Verify:** Run `foreman --version`

### 3.2 Install Rojo (Project Sync Tool)
Syncs your code files with Roblox Studio in real-time.

```bash
foreman install
```

This installs Rojo, Selene, and Stylua based on foreman.toml config.

### 3.3 Install Wally (Package Manager)
Manages Roblox libraries and dependencies.

```bash
foreman add --github UpliftGames/wally
foreman install
```

**Verify:** Run `wally --version`

---

## **Phase 4: Claude Integration (1.5 hours)**

### 4.1 Install Claude Code (if not already installed)
```bash
npm install -g @anthropic-ai/claude-code
```

### 4.2 Install Roblox Studio MCP
This allows Claude to directly control Roblox Studio.

```bash
npm install -g roblox-studio-mcp
```

### 4.3 Configure Claude Code for Roblox
Create `.claude-code-config.json` in your project root:

```json
{
  "mcpServers": {
    "roblox-studio": {
      "command": "roblox-studio-mcp",
      "args": []
    }
  },
  "tools": ["file_operations", "bash", "roblox_studio"]
}
```

**Verify:** Run `claude-code --list-tools` - should show Roblox Studio tools

---

## **Phase 5: Project Structure Setup (30 min)**

### 5.1 Clone Recommended Template
```bash
git clone https://github.com/MonzterDev/Roblox-Game-Template.git my-roblox-game
cd my-roblox-game
```

### 5.2 Directory Structure (Simplified for Clicker Game)
```
my-roblox-game/
├── src/
│   ├── shared/          # Shared modules (both client & server)
│   │   ├── Constants.lua
│   │   └── Utilities.lua
│   ├── client/          # Client-side scripts
│   │   ├── UI.lua
│   │   └── InputHandler.lua
│   └── server/          # Server-side scripts
│       ├── GameLogic.lua
│       ├── PlayerData.lua
│       └── Monetization.lua
├── foreman.toml         # Tool versions
├── wally.toml           # Package dependencies
├── rojo.json            # Rojo configuration
└── README.md
```

### 5.3 Initialize Git
```bash
git init
git add .
git commit -m "Initial commit: Roblox clicker game setup"
```

---

## **Phase 6: VS Code Setup (20 min)**

### 6.1 Install Extensions
1. Open VS Code
2. Go to Extensions (Ctrl+Shift+X)
3. Install:
   - "Roblox" (by Roblox)
   - "Luau Language Server" (by JohnnyMorganz)
   - "Selene" (Lua linter)
   - "GitLens" (Git integration)

### 6.2 Configure Luau for Intellisense
Create `.vscode/settings.json`:

```json
{
  "luau-lsp.sourcemap.autogenerate": true,
  "luau-lsp.sourcemap.enabled": true,
  "[lua]": {
    "editor.defaultFormatter": "JohnnyMorganz.stylua",
    "editor.formatOnSave": true
  }
}
```

---

## **Phase 7: Rojo Sync Setup (30 min)**

### 7.1 Configure `rojo.json`
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

Open Roblox Studio, go to **Plugins** → **Rojo** → **Connect**. Should sync automatically.

---

## **Phase 8: Testing Your Setup (20 min)**

### 8.1 Quick Test Workflow

1. **In VS Code**, create `src/shared/Test.lua`:
```lua
local Test = {}

function Test.sayHello()
    print("Hello from Roblox + Claude!")
    return true
end

return Test
```

2. **In Roblox Studio**, verify Rojo synced the file (check ReplicatedStorage > Shared)

3. **Run Claude Code** to test integration:
```bash
claude-code "Create a simple clicker button script for Roblox and save it to src/client/ClickerButton.lua"
```

4. Verify the file appears in VS Code and syncs to Studio

### 8.2 Checklist
- [ ] Roblox Studio launches and creates projects
- [ ] Git is installed and working
- [ ] Foreman, Rojo, Wally installed
- [ ] Claude Code MCP recognizes Roblox Studio tools
- [ ] Rojo successfully syncs files from VS Code → Studio
- [ ] VS Code has Luau intellisense working
- [ ] Can run Claude Code commands

---

## **Phase 9: Production Optimization (Optional, can do later)**

### 9.1 Enable Type Checking
Add to `rojo.json`:
```json
"luauTypes": true
```

### 9.2 Set Up CI/CD (GitHub Actions)
Auto-test and validate Lua code on every commit.

### 9.3 ProfileService for Data Persistence
```bash
wally add UpliftGames/profile-service@0.4.3
```

---

## **Your Ready-to-Go Checklist**

Before starting the clicker game, verify:

- [ ] Roblox Studio installed and working
- [ ] Git, Node.js, Foreman installed
- [ ] Rojo syncing files from VS Code → Studio in real-time
- [ ] VS Code has Luau intellisense
- [ ] Claude Code MCP recognizes Roblox tools
- [ ] Project folder initialized with Git
- [ ] Can run `claude-code` commands successfully

---

## **Troubleshooting**

**Rojo won't connect?**
- Verify Rojo plugin is installed in Studio: Plugins → Manage Plugins → search "Rojo"
- Run `rojo serve` in terminal first, then connect from Studio

**Claude Code doesn't see Roblox tools?**
- Verify MCP installed: `npm list -g roblox-studio-mcp`
- Restart Claude Code

**Luau intellisense not working?**
- Check `.vscode/settings.json` is in project root
- Reload VS Code window (Ctrl+Shift+P → "Developer: Reload Window")

**Wally packages not installing?**
- Make sure `wally.toml` exists in project root
- Run `wally install` in terminal

---

## **Estimated Total Setup Time: 4-5 hours**

Once complete, you'll have a professional development environment ready for rapid game development with Claude + Roblox Studio MCP.

**Next Step:** Start building your clicker game! 🚀
