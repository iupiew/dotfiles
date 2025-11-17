if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting
end
set -U fish_autosuggestion_enabled 0
alias setdark="~/.config/custom/toggle_theme.sh setdark"
alias setmoon="~/.config/custom/toggle_theme.sh setmoon"
alias setdawn="~/.config/custom/toggle_theme.sh setdawn"
alias e="emacs -fs"
alias wc="$HOME/wifi-connect.sh"
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"
export PATH="/home/iupiew/.local/share/solana/install/active_release/bin:$PATH"

function fish_prompt
    # Set the user and hostname with styling
    set -l user_host (set_color brblack)"$USER@"(hostname|cut -d . -f 1)(set_color normal)
    # Set the current directory with styling
    set -l current_dir (set_color magenta)(prompt_pwd)(set_color normal)
    # Git branch and status indicator
    set -l git_info (fish_git_prompt)
    # Display the prompt with user, host, directory, and Git info
    echo -n -s $user_host " " $current_dir "" $git_info " "
    # Add a custom symbol for the prompt input line
    echo -n -s (set_color brwhite)"❯ "(set_color normal)
end

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin /home/iupiew/.ghcup/bin $PATH # ghcup-env

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Add all binary paths
fish_add_path -a /home/iupiew/.foundry/bin
fish_add_path /home/iupiew/.cargo/bin/
fish_add_path /home/iupiew/.nvm/bin/
fish_add_path /home/iupiew/go/bin          # <- ADD THIS LINE

set -gx PATH /home/iupiew/.nvm/versions/node/v18.20.8/bin $PATH
set -gx PATH /home/iupiew/.nvm/versions/node/v22.16.0/bin $PATH
set -gx PATH $HOME/.avm/bin $PATH
