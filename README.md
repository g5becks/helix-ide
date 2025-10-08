# helix-ide

Turn Helix into a full IDE with Zellij and CLI tools.

![Helix IDE](https://img.shields.io/badge/editor-Helix-blue) ![Multiplexer](https://img.shields.io/badge/multiplexer-Zellij-orange) ![Language](https://img.shields.io/badge/language-Nushell-green)

Inspired by [helix-wezterm](https://github.com/quantonganh/helix-wezterm), adapted for modern terminals and multiplexers.

## Features

- 🎯 **VS Code-style interface** - Tabbed bottom pane for terminals, lazygit, scooter, AI agents
- ⚡ **Fast and elegant** - Written in Nushell with native TOML support
- 🔧 **Highly configurable** - TOML configuration with extension-based commands
- 🚀 **Integrated tools** - lazygit, scooter, yazi, Gemini, Claude, and more
- 🎨 **Clean workflow** - Trigger actions from Helix with simple keybindings
- 🤖 **AI-powered** - Direct integration with Gemini, Claude, and claude-code-router

## Architecture

```
┌─────────────────────────────────────────┐
│                                         │
│           Helix Editor                  │
│                                         │
├─────────────────────────────────────────┤
│ [terminal] [lazygit] [gemini] [claude] │ <- VS Code-style tabs
├─────────────────────────────────────────┤
│                                         │
│   Current tab content here              │
│                                         │
└─────────────────────────────────────────┘
```

## Prerequisites

### Required
- [Helix](https://helix-editor.com/) - Text editor
- [Zellij](https://zellij.dev/) - Terminal multiplexer
- [Nushell](https://www.nushell.sh/) - Shell for the script

### Recommended CLI Tools
- [scooter](https://github.com/thomasschafer/scooter) - Find and replace
- [lazygit](https://github.com/jesseduffield/lazygit) - Git TUI
- [yazi](https://github.com/sxyazi/yazi) - File explorer
- [tig](https://jonas.github.io/tig/) - Git interface for blame
- [lazysql](https://github.com/jorgerojas26/lazysql) - Database TUI
- [lazyssh](https://github.com/Aakash-Sharma-1/lazyssh) - SSH manager
- [slumber](https://github.com/LucasPickering/slumber) - HTTP client
- [glow](https://github.com/charmbracelet/glow) - Markdown viewer
- [presenterm](https://github.com/mfontanini/presenterm) - Markdown presentations

### AI Coding Assistants (Choose your favorites)
- [Gemini CLI](https://github.com/google-gemini/gemini-cli) - Google's Gemini
- [Claude](https://www.anthropic.com/) - Anthropic's Claude
- [claude-code-router](https://github.com/musistudio/claude-code-router) - Route to multiple Claude instances

## Installation

1. **Install the script:**

```bash
# Copy script to your PATH
cp helix-ide.nu ~/.local/bin/helix-ide
chmod +x ~/.local/bin/helix-ide
```

2. **Install the configuration:**

```bash
# Copy config to Helix config directory
cp helix-ide.toml ~/.config/helix/helix-ide.toml
```

3. **Install the Zellij layout (optional):**

```bash
# Copy layout to Zellij config directory
mkdir -p ~/.config/zellij/layouts
cp layouts/helix-ide.kdl ~/.config/zellij/layouts/
```

4. **Configure Helix keybindings:**

Add to `~/.config/helix/config.toml`:

```toml
[keys.normal.space.","]
b = ":sh helix-ide blame"
c = ":sh helix-ide check"
e = ":sh helix-ide explorer"
g = ":sh helix-ide lazygit"
r = ":sh helix-ide run"
s = ":sh helix-ide scooter"
t = ":sh helix-ide test"
q = ":sh helix-ide query"
h = ":sh helix-ide slumber"
S = ":sh helix-ide ssh"

# AI assistants
[keys.normal.space."a"]
g = ":sh helix-ide gemini"
c = ":sh helix-ide claude"
r = ":sh helix-ide claude-router"
```

## Usage

### Starting the IDE

Start Zellij with the Helix IDE layout:

```bash
# Using the custom layout
zellij --layout helix-ide

# Or start Zellij normally and launch Helix
zellij
# Then: hx
```

### Using Actions

Inside Helix, press `space`, then `,`, then the action key:

- `space , g` - Open lazygit in bottom tab
- `space , s` - Open scooter for find/replace
- `space , e` - Open yazi file explorer
- `space , r` - Run current file (extension-based)
- `space , t` - Test current file (extension-based)
- `space , c` - Check/build current project
- `space , b` - Show git blame for current line
- `space , q` - Open database query tool
- `space , h` - Open HTTP client (slumber)
- `space , S` - Open SSH manager

### AI Assistants

Press `space`, then `a`, then:

- `g` - Open Gemini
- `c` - Open Claude
- `r` - Open Claude Code Router

### Environment Variables

The script automatically provides these variables for command templates:

- `{{buffer_name}}` - Full path to current file
- `{{cursor_line}}` - Current cursor line number
- `{{basename}}` - File name with extension
- `{{extension}}` - File extension
- `{{basedir}}` - Directory containing the file
- `{{basename_without_ext}}` - File name without extension
- `{{binary_output}}` - Name of the base directory

## Configuration

Edit `~/.config/helix/helix-ide.toml` to customize:

### Adding a New Action

```toml
[actions.my_action]
tab_name = "my-tab"
description = "Description of my action"
command = "my-command"
```

### Extension-Specific Commands

```toml
[actions.run.extensions]
go = "go run {{basedir}}/*.go"
py = "python {{buffer_name}}"
rs = "cargo run"
```

### Command Templates

Use `{{variable}}` syntax for dynamic values:

```toml
[actions.blame]
command_template = "tig blame {{buffer_name}} +{{cursor_line}}"
```

## Tool Details

### Scooter
Fast find and replace tool that works great with Helix.

### lazyssh
SSH connection manager - makes managing multiple SSH connections easy.

### claude-code-router
Routes coding requests to multiple Claude instances for parallel work.

## Troubleshooting

### "Not running inside Zellij session"

Make sure you're running Helix inside a Zellij session:

```bash
zellij
hx my-file.txt
```

### Commands not working

1. Verify the CLI tool is installed: `which <tool-name>`
2. Check your config: `helix-ide --help`
3. Test Zellij integration: `zellij action --help`

### Tab not appearing

Zellij might need focus. Try:
- Pressing `Ctrl+t` then `n` to create a new tab manually
- Checking Zellij keybindings with `Ctrl+?`

## License

MIT License

## Credits

- Original [helix-wezterm](https://github.com/quantonganh/helix-wezterm) by [@quantonganh](https://github.com/quantonganh)
- Adapted for Zellij + modern tooling
