# Installation Quick Start

## Quick Install

```bash
# Clone the repo
git clone https://github.com/g5becks/helix-ide.git
cd helix-ide

# Install the script
cp helix-ide.nu ~/.local/bin/helix-ide
chmod +x ~/.local/bin/helix-ide

# Install the config
cp helix-ide.toml ~/.config/helix/helix-ide.toml

# Install the layout (optional)
mkdir -p ~/.config/zellij/layouts
cp layouts/helix-ide.kdl ~/.config/zellij/layouts/
```

## Helix Configuration

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

## First Run

```bash
# Start Zellij
zellij

# Or with the custom layout
zellij --layout helix-ide

# Then open Helix
hx
```

## Testing

Inside Helix, try:
- `space , g` - Should open lazygit in bottom tab
- `space , e` - Should open yazi file explorer
- `space a g` - Should open Gemini (if installed)

## Troubleshooting

If commands don't work:
1. Make sure you're inside a Zellij session: `echo $ZELLIJ`
2. Check if script is executable: `ls -l ~/.local/bin/helix-ide`
3. Verify nushell is installed: `which nu`
4. Test the script directly: `helix-ide --help`
