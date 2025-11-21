# Launch hyprland on login
if uwsm check may-start; then
	exec uwsm start hyprland.desktop
fi

# Add to PATH
path+=('/home/james/.cargo/bin')
export PATH

# Initialize zoxide every session
eval "$(zoxide init zsh)"

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Environment variables
export EDITOR=nvim

launch() {
    args=$*
    shift
    ($1 $args &)
}

# Aliases
alias hardware="zenith -c 18 -d 18 -n 18 -g 18 -p 8"
alias gpu="nvidia-smi"
alias system="systemctl list-units --state=failed"
alias ls="eza -a"
alias cd="z"
alias vi="nvim"
alias vim="nvim"

# Web
browse() {
    (librewolf $1 &)
}

brave() {
    browse "https://search.brave.com/search?safesearch=off&q=$*"
}
