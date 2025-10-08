#!/usr/bin/env nu
# helix-ide - Helix IDE integration with Zellij
# A Nushell script to orchestrate Zellij panes/tabs from Helix editor

# Get the config file path
def get-config-path [] {
    let xdg_config = ($env.XDG_CONFIG_HOME? | default ($env.HOME | path join ".config"))
    $xdg_config | path join "helix" "helix-ide.toml"
}

# Load the configuration
def load-config [] {
    let config_path = get-config-path
    if not ($config_path | path exists) {
        error make {
            msg: "Config file not found"
            label: {
                text: $"Please create ($config_path)"
                span: (metadata $config_path).span
            }
        }
    }
    open $config_path
}

# Get environment variables from Helix
def get-helix-env [] {
    {
        buffer_name: ($env.HELIX_BUFFER_NAME? | default ""),
        cursor_line: ($env.HELIX_CURSOR_LINE? | default "1"),
        selection: ($env.HELIX_SELECTION? | default ""),
    }
}

# Extract file information from buffer name
def extract-file-info [buffer_name: string] {
    let basename = ($buffer_name | path basename)
    let extension = ($buffer_name | path parse | get extension)
    let basedir = ($buffer_name | path dirname)
    let basename_without_ext = ($basename | str replace $".($extension)" "")
    
    {
        buffer_name: $buffer_name,
        basename: $basename,
        extension: $extension,
        basedir: $basedir,
        basename_without_ext: $basename_without_ext,
        binary_output: ($basedir | path basename),
    }
}

# Substitute variables in command template
def substitute-vars [template: string, vars: record] {
    mut result = $template
    
    for key in ($vars | columns) {
        let value = ($vars | get $key | into string)
        $result = ($result | str replace --all $"{{($key)}}" $value)
    }
    
    $result
}

# Check if we're inside a Zellij session
def in-zellij [] {
    ($env.ZELLIJ? | is-not-empty)
}

# Execute a Zellij action
def zellij-action [...args: string] {
    if not (in-zellij) {
        print "Error: Not running inside Zellij session"
        exit 1
    }
    
    run-external "zellij" "action" ...$args
}

# Create or switch to a tab in the bottom pane
def create-bottom-tab [name: string] {
    # Check if tab exists, if not create it
    # Zellij will focus existing tab if it exists with the same name
    zellij-action "new-tab" "--name" $name "--layout" "default"
}

# Send a command to the current tab
def send-command [command: string] {
    # Write the command characters
    zellij-action "write-chars" $command
    
    # Send Enter key (ASCII 10)
    zellij-action "write" "10"
}

# Main action executor
def execute-action [action: string] {
    let config = load-config
    let helix_env = get-helix-env
    let file_info = extract-file-info $helix_env.buffer_name
    
    # Check if action exists in config
    if ($action not-in ($config.actions | columns)) {
        print $"Error: Action '($action)' not found in config"
        print $"Available actions: ($config.actions | columns | str join ', ')"
        exit 1
    }
    
    let action_config = ($config.actions | get $action)
    
    # Get tab name
    let tab_name = ($action_config.tab_name? | default $action)
    
    # Determine command to execute
    let command = if ($action_config.command_template? | is-not-empty) {
        # Build vars for template substitution
        let vars = ($file_info | merge $helix_env)
        substitute-vars $action_config.command_template $vars
    } else if ($action_config.extensions? | is-not-empty) {
        # Extension-specific command
        let ext = $file_info.extension
        if ($ext in ($action_config.extensions | columns)) {
            let template = ($action_config.extensions | get $ext)
            let vars = ($file_info | merge $helix_env)
            substitute-vars $template $vars
        } else {
            print $"Error: No command configured for extension '($ext)'"
            exit 1
        }
    } else if ($action_config.command? | is-not-empty) {
        $action_config.command
    } else {
        print $"Error: No command configured for action '($action)'"
        exit 1
    }
    
    # Create/switch to tab and send command
    create-bottom-tab $tab_name
    send-command $command
}

# Show help
def show-help [config: record] {
    print "Usage: helix-ide <action>"
    print ""
    print "Available actions:"
    for action in ($config.actions | columns) {
        let desc = ($config.actions | get $action | get description? | default "")
        print $"  ($action) - ($desc)"
    }
}

# Main entry point
def main [action?: string] {
    if not (in-zellij) {
        print "Error: This script must be run inside a Zellij session"
        exit 1
    }
    
    let config = load-config
    
    # Show help if no action provided
    if ($action | is-empty) {
        show-help $config
        exit 0
    }
    
    # Show help for help flags
    if $action in ["-h" "--help" "help"] {
        show-help $config
        exit 0
    }
    
    # Execute the action
    execute-action $action
}
