# Disable fish greeting
if status is-interactive
    set fish_greeting
end

# Disable autosuggestions
set -U fish_autosuggestion_enabled 0

# Dotfiles management alias
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Custom prompt
function fish_prompt
    set -l user_host (set_color brblack)"$USER@"(hostname|cut -d . -f 1)(set_color normal)
    set -l current_dir (set_color magenta)(prompt_pwd)(set_color normal)
    set -l git_info (fish_git_prompt)
    echo -n -s $user_host " " $current_dir "" $git_info " "
    echo -n -s (set_color brwhite)"❯ "(set_color normal)
end

# PATH configuration
fish_add_path -a $HOME/.local/bin
fish_add_path -a $HOME/.cabal/bin
fish_add_path -a $HOME/.ghcup/bin
fish_add_path -a $HOME/.cargo/bin
fish_add_path -a $HOME/.foundry/bin
fish_add_path -a $HOME/.nvm/bin
fish_add_path -a $HOME/.local/share/solana/install/active_release/bin
fish_add_path -a $HOME/.nvm/versions/node/v22.16.0/bin

# Bun
set -gx BUN_INSTALL "$HOME/.bun"
fish_add_path -a $BUN_INSTALL/bin

# GHCup (Haskell)
set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
