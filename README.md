# helix-ide

Simple Zellij tools panel for Helix development workflow.

## Setup

1. Install the layout:
```bash
cp layouts/helix-tools.kdl ~/.config/zellij/layouts/
```

2. Install the tools launcher:
```bash
cp tools ~/.local/bin/tools
chmod +x ~/.local/bin/tools
```

## Usage

1. Start Helix: `hx`
2. Open Ghostty split (use your existing Ghostty keybinds)
3. In bottom split: `tools`

This starts Zellij with tabs for all your tools:
- terminal
- lazygit
- yazi (file explorer)
- scooter (find/replace)
- sql (lazysql)
- ssh (lazyssh)

Use Zellij's default keybinds to switch tabs.

