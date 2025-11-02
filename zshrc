# Launch hyprland on login
if uwsm check may-start; then
	exec uwsm start hyprland.desktop
fi

# Initialize zoxide every session
eval "$(zoxide init zsh)"

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Environment variables
export EDITOR=nvim

# Launch function
l() {
    ("$1" &)
    exit
}

# Aliases
alias time="date +\"%a/%d, %H:%M\""
