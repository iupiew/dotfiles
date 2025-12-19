if status is-interactive
    set fish_greeting
end
set -U fish_autosuggestion_enabled 0

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

export PATH="/home/iupiew/.local/bin:$PATH"
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"
export PATH="/home/iupiew/.local/share/solana/install/active_release/bin:$PATH"

function fish_prompt
    set -l user_host (set_color brblack)"$USER@"(hostname|cut -d . -f 1)(set_color normal)
    set -l current_dir (set_color magenta)(prompt_pwd)(set_color normal)
    set -l git_info (fish_git_prompt)
    echo -n -s $user_host " " $current_dir "" $git_info " "
    echo -n -s (set_color brwhite)"❯ "(set_color normal)
end

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin /home/iupiew/.ghcup/bin $PATH

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

fish_add_path -a /home/iupiew/.foundry/bin
fish_add_path /home/iupiew/.cargo/bin/
fish_add_path /home/iupiew/.nvm/bin/

set -gx PATH /home/iupiew/.nvm/versions/node/v18.20.8/bin $PATH
set -gx PATH /home/iupiew/.nvm/versions/node/v22.16.0/bin $PATH
set -gx PATH $HOME/.avm/bin $PATH
set -gx PATH $HOME/.local/share/solana/install/active_release/bin $PATH
