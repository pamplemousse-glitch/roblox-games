#!/bin/bash

################################################################################
# Roblox + Claude Development Setup (Automated)
# For macOS Intel
# This script automates all setup phases in one go
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

################################################################################
# Phase 1: Check Prerequisites
################################################################################

log_info "=== Phase 1: Checking Prerequisites ==="

check_command() {
    if ! command -v $1 &> /dev/null; then
        return 1
    fi
    return 0
}

log_info "Checking for required tools..."

if ! check_command xcode-select; then
    log_warn "Xcode Command Line Tools not found. Installing..."
    xcode-select --install
    log_success "Xcode Command Line Tools installed"
else
    log_success "Xcode Command Line Tools found"
fi

################################################################################
# Phase 2: Install Homebrew & Core Tools
################################################################################

log_info "=== Phase 2: Installing Homebrew & Core Tools ==="

# Install Homebrew if needed
if ! check_command brew; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    log_success "Homebrew installed"
else
    log_success "Homebrew already installed"
fi

# Install/update Git
if ! check_command git; then
    log_info "Installing Git..."
    brew install git
    log_success "Git installed"
else
    log_success "Git already installed ($(git --version))"
fi

# Install/update Node.js
if ! check_command node; then
    log_info "Installing Node.js (LTS)..."
    brew install node@18
    brew link node@18 --force
    log_success "Node.js installed ($(node --version))"
else
    log_success "Node.js already installed ($(node --version))"
fi

################################################################################
# Phase 3: Install Roblox Development Tools
################################################################################

log_info "=== Phase 3: Installing Roblox Development Tools ==="

# Install Rokit
if ! check_command rokit; then
    log_info "Installing Rokit (toolchain manager)..."
    brew install rokit
    log_success "Rokit installed"
else
    log_success "Rokit already installed ($(rokit --version))"
fi

################################################################################
# Phase 4: Clone Template Repository
################################################################################

log_info "=== Phase 4: Setting Up Project ==="

PROJECT_DIR="$HOME/Roblox/my-roblox-clicker-game"

if [ -d "$PROJECT_DIR" ]; then
    log_warn "Project directory already exists at $PROJECT_DIR"
    read -p "Overwrite? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$PROJECT_DIR"
    else
        log_info "Using existing directory: $PROJECT_DIR"
        cd "$PROJECT_DIR"
        goto_setup_config
        exit 0
    fi
fi

log_info "Cloning Roblox Game Template..."
git clone https://github.com/grilme99/roblox-project-template.git "$PROJECT_DIR"
cd "$PROJECT_DIR"
log_success "Project cloned to $PROJECT_DIR"

################################################################################
# Phase 5: Install Tools via Rokit
################################################################################

log_info "=== Phase 5: Installing Rokit Tools (Rojo, Wally, Selene, StyLua) ==="

log_info "Initializing Rokit..."
rokit init --skip-template
log_success "Rokit initialized"

log_info "Installing toolchain..."
rokit toolchain install
log_success "Toolchain installed (Rojo, Wally, Selene, StyLua)"

################################################################################
# Phase 6: Create Configuration Files
################################################################################

log_info "=== Phase 6: Creating Configuration Files ==="

# .vscode/settings.json
log_info "Creating VS Code settings..."
mkdir -p .vscode
cat > .vscode/settings.json << 'EOF'
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
EOF
log_success "VS Code settings created"

# .vscode/launch.json
log_info "Creating VS Code debug config..."
cat > .vscode/launch.json << 'EOF'
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
EOF
log_success "Debug config created"

# .gitignore
log_info "Creating .gitignore..."
cat > .gitignore << 'EOF'
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
.vscode/local.json
.idea/

# OS
.DS_Store
Thumbs.db

# Build outputs
build/
dist/

# Npm
node_modules/
EOF
log_success ".gitignore created"

# selene.toml (if doesn't exist)
if [ ! -f "selene.toml" ]; then
    log_info "Creating selene.toml (linter config)..."
    cat > selene.toml << 'EOF'
std = "roblox"

[rules]
undefined_variable = "error"
unused_variable = "warn"
empty_if = "warn"
multiple_statements = "warn"
EOF
    log_success "selene.toml created"
fi

# .claude-code-config.json
log_info "Creating Claude Code config..."
cat > .claude-code-config.json << 'EOF'
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
EOF
log_success "Claude Code config created"

################################################################################
# Phase 7: Install Node.js Dependencies & Claude Tools
################################################################################

log_info "=== Phase 7: Installing Claude Code & MCP ==="

log_info "Installing Claude Code globally..."
npm install -g @anthropic-ai/claude-code
log_success "Claude Code installed"

log_info "Adding Roblox Studio MCP to Claude Code..."
claude mcp add robloxstudio -- npx -y robloxstudio-mcp@latest
log_success "Roblox Studio MCP added to Claude Code"

log_info "Creating CLAUDE.md with Roblox/Luau context..."
cat > CLAUDE.md << 'EOF'
# Roblox Game Development Context

## Language
- This project uses Luau (Roblox's modified Lua). NOT standard Lua.
- File suffixes matter: `.server.luau` runs on server, `.client.luau` on client, `.luau` is shared/module.

## Architecture
- Server scripts go in `src/server/` — never trust client input here
- Client scripts go in `src/client/`
- Shared modules go in `src/shared/` — imported via `require()`
- Use RemoteEvents for server<->client communication, never direct access

## Key Roblox APIs
- `game:GetService("Players")` — player management
- `game:GetService("ReplicatedStorage")` — shared assets/remotes
- `game:GetService("DataStoreService")` — persistent data (server only)
- `game:GetService("RunService")` — frame loops, IsServer/IsClient checks
- `game:GetService("TweenService")` — animations/transitions

## Rules
- Always validate on the server — client data is untrusted
- Use `task.spawn()` not `coroutine.wrap()` for async
- Use `task.wait()` not `wait()` (deprecated)
- DataStore operations must be pcall-wrapped
- Keep scripts under 300 lines — split into modules if larger
EOF
log_success "CLAUDE.md created"

################################################################################
# Phase 8: Initialize Git
################################################################################

log_info "=== Phase 8: Setting Up Git ==="

if ! git rev-parse --git-dir > /dev/null 2>&1; then
    log_info "Initializing Git repository..."
    git init
    git add .
    git commit -m "Initial commit: Roblox clicker game setup"
    log_success "Git repository initialized"
else
    log_success "Git repository already exists"
fi

################################################################################
# Phase 9: Verify Setup
################################################################################

log_info "=== Phase 9: Verifying Setup ==="

echo ""
log_info "Checking installed tools..."

check_tool() {
    if check_command $1; then
        log_success "$1: $(eval $1 --version 2>/dev/null || echo 'installed')"
    else
        log_error "$1: NOT FOUND"
    fi
}

check_tool git
check_tool node
check_tool rokit
check_tool rojo
check_tool wally
check_tool selene

if [ -f "rojo.json" ]; then
    log_success "rojo.json: found"
else
    log_warn "rojo.json: NOT FOUND (may need manual creation)"
fi

################################################################################
# Phase 10: Print Next Steps
################################################################################

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                   SETUP COMPLETE! ✓                         ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

log_info "Project location: $PROJECT_DIR"
log_info "Next steps:"
echo ""
echo "1. Open Roblox Studio and create a new blank game"
echo ""
echo "2. In your terminal, navigate to project and start Rojo:"
echo "   cd $PROJECT_DIR"
echo "   rojo serve"
echo ""
echo "3. In Roblox Studio:"
echo "   - Go to Plugins → Rojo"
echo "   - Click Connect"
echo ""
echo "4. Open VS Code:"
echo "   code $PROJECT_DIR"
echo ""
echo "5. Install VS Code extensions:"
echo "   - Roblox (by Roblox)"
echo "   - Luau Language Server (by JohnnyMorganz)"
echo "   - Selene (by JohnnyMorganz)"
echo "   - StyLua (by JohnnyMorganz)"
echo "   - GitLens (by Eric Amodio)"
echo ""
echo "6. Test the setup:"
echo "   - Create a test file in src/shared/Test.lua"
echo "   - Watch it sync to Studio instantly via Rojo"
echo ""
echo "7. Generate code with Claude Code:"
echo "   claude-code \"Create a clicker button in src/client\""
echo ""
echo "8. Push to GitHub (optional):"
echo "   git remote add origin https://github.com/YOUR_USERNAME/my-roblox-clicker-game.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""

log_success "Setup is ready! 🚀"
log_info "Questions? Check ROBLOX_DEV_SETUP_GUIDE_UPDATED.md for troubleshooting"
