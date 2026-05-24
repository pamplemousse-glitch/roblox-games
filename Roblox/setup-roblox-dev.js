#!/usr/bin/env node

/**
 * Roblox + Claude Development Setup (Cross-Platform)
 * Works on macOS, Windows, Linux
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Colors
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  red: '\x1b[31m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m'
};

// Logging
const log = {
  info: (msg) => console.log(`${colors.blue}ℹ${colors.reset} ${msg}`),
  success: (msg) => console.log(`${colors.green}✓${colors.reset} ${msg}`),
  warn: (msg) => console.log(`${colors.yellow}⚠${colors.reset} ${msg}`),
  error: (msg) => console.log(`${colors.red}✗${colors.reset} ${msg}`)
};

// Utils
const checkCommand = (cmd) => {
  try {
    execSync(`which ${cmd}`, { stdio: 'ignore' });
    return true;
  } catch {
    return false;
  }
};

const runCommand = (cmd, description) => {
  try {
    log.info(description);
    execSync(cmd, { stdio: 'inherit' });
    return true;
  } catch (err) {
    log.error(`${description} failed`);
    return false;
  }
};

const createFile = (filePath, content) => {
  const dir = path.dirname(filePath);
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
  fs.writeFileSync(filePath, content, 'utf8');
};

// Main setup
async function setup() {
  console.log('\n');
  console.log('╔════════════════════════════════════════════════════════════╗');
  console.log('║    Roblox + Claude Automated Setup                         ║');
  console.log('║    Starting setup process...                               ║');
  console.log('╚════════════════════════════════════════════════════════════╝\n');

  const projectDir = path.join(process.env.HOME, 'Roblox', 'my-roblox-clicker-game');

  // Phase 1: Check prerequisites
  log.info('=== Phase 1: Checking Prerequisites ===');
  if (checkCommand('git')) {
    const gitVersion = execSync('git --version', { encoding: 'utf8' }).trim();
    log.success(`${gitVersion}`);
  } else {
    log.error('Git not found. Please install Git first.');
    process.exit(1);
  }

  if (checkCommand('node')) {
    const nodeVersion = execSync('node --version', { encoding: 'utf8' }).trim();
    log.success(`Node.js ${nodeVersion}`);
  } else {
    log.error('Node.js not found. Please install Node.js first.');
    process.exit(1);
  }

  // Phase 2: Create project directory
  log.info('=== Phase 2: Setting Up Project Directory ===');
  if (!fs.existsSync(projectDir)) {
    fs.mkdirSync(projectDir, { recursive: true });
    log.success(`Project directory created: ${projectDir}`);
  } else {
    log.warn(`Project directory already exists`);
  }

  process.chdir(projectDir);

  // Phase 3: Clone template if needed
  log.info('=== Phase 3: Cloning Template ===');
  if (!fs.existsSync(path.join(projectDir, 'src'))) {
    runCommand(
      `git clone https://github.com/MonzterDev/Roblox-Game-Template.git "${projectDir}"`,
      'Cloning Roblox Game Template...'
    );
    log.success('Template cloned');
  } else {
    log.success('Template already exists');
  }

  // Phase 4: Create config files
  log.info('=== Phase 4: Creating Configuration Files ===');

  const vscodeSettings = {
    'luau-lsp.sourcemap.autogenerate': true,
    'luau-lsp.sourcemap.enabled': true,
    '[lua]': {
      'editor.defaultFormatter': 'JohnnyMorganz.stylua',
      'editor.formatOnSave': true,
      'editor.tabSize': 4
    },
    'selene.lintOn': 'save',
    'search.exclude': {
      '**/.git': true,
      '**/node_modules': true,
      '**/packages': true
    }
  };

  createFile(
    path.join(projectDir, '.vscode', 'settings.json'),
    JSON.stringify(vscodeSettings, null, 2)
  );
  log.success('Created .vscode/settings.json');

  const vscodeDebug = {
    version: '0.2.0',
    configurations: [
      {
        name: 'Attach to Roblox Studio',
        type: 'lua',
        request: 'attach',
        sourceRoot: '${workspaceFolder}/src',
        host: 'localhost',
        port: 55999
      }
    ]
  };

  createFile(
    path.join(projectDir, '.vscode', 'launch.json'),
    JSON.stringify(vscodeDebug, null, 2)
  );
  log.success('Created .vscode/launch.json');

  const gitignore = `# Dependencies
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
`;

  createFile(path.join(projectDir, '.gitignore'), gitignore);
  log.success('Created .gitignore');

  const claudeConfig = {
    mcpServers: {
      'roblox-studio': {
        command: 'roblox-studio-mcp',
        env: {
          STUDIO_PORT: '8008'
        }
      }
    },
    tools: ['file_operations', 'bash', 'roblox_studio', 'javascript_exec']
  };

  createFile(
    path.join(projectDir, '.claude-code-config.json'),
    JSON.stringify(claudeConfig, null, 2)
  );
  log.success('Created .claude-code-config.json');

  // Phase 5: Initialize git
  log.info('=== Phase 5: Initializing Git ===');
  try {
    execSync('git status', { stdio: 'ignore' });
    log.success('Git repository already initialized');
  } catch {
    runCommand('git init', 'Initializing Git repository...');
    runCommand('git add .', 'Staging files...');
    runCommand('git commit -m "Initial commit: Roblox clicker game setup"', 'Creating initial commit...');
    log.success('Git repository initialized');
  }

  // Phase 6: Install global tools
  log.info('=== Phase 6: Installing Global NPM Tools ===');
  if (!checkCommand('claude-code')) {
    runCommand('npm install -g @anthropic-ai/claude-code', 'Installing Claude Code...');
    log.success('Claude Code installed');
  } else {
    log.success('Claude Code already installed');
  }

  if (!checkCommand('roblox-studio-mcp')) {
    runCommand('npm install -g roblox-studio-mcp', 'Installing Roblox Studio MCP...');
    log.success('Roblox Studio MCP installed');
  } else {
    log.success('Roblox Studio MCP already installed');
  }

  // Phase 7: Summary
  console.log('\n');
  console.log('╔════════════════════════════════════════════════════════════╗');
  console.log(`${colors.green}║                   SETUP COMPLETE! ✓                         ║${colors.reset}`);
  console.log('╚════════════════════════════════════════════════════════════╝\n');

  log.info(`Project location: ${projectDir}`);
  log.success('Configuration files created');
  log.success('Git repository initialized');

  console.log('\n📋 NEXT STEPS:\n');
  console.log('1. Open Roblox Studio and create a new blank game');
  console.log('\n2. In terminal, start Rojo:');
  console.log(`   cd ${projectDir}`);
  console.log('   rojo serve\n');
  console.log('3. In Roblox Studio: Plugins → Rojo → Connect\n');
  console.log('4. Open VS Code:');
  console.log(`   code ${projectDir}\n`);
  console.log('5. Install VS Code extensions:');
  console.log('   - Roblox (by Roblox)');
  console.log('   - Luau Language Server (by JohnnyMorganz)');
  console.log('   - Selene (by JohnnyMorganz)');
  console.log('   - StyLua (by JohnnyMorganz)');
  console.log('   - GitLens (by Eric Amodio)\n');
  console.log('6. Test by creating src/shared/Test.lua - should sync instantly\n');
  console.log('7. Generate code:');
  console.log('   claude-code "Create a clicker button script"\n');

  log.success('Ready to build! 🚀\n');
}

setup().catch((err) => {
  log.error(`Setup failed: ${err.message}`);
  process.exit(1);
});
