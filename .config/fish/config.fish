if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting

end

# alias e="emacs -fs"
# export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"

# set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin /home/iupiew/.ghcup/bin $PATH # ghcup-env

function fish_prompt
  # interactive user name @ host name, date/time in YYYY-mm-dd format and path
  echo (whoami)@(hostname) ">> "
end
