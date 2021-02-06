# this assumes that the operating system is MacOS
# for git completion, see https://stackoverflow.com/questions/26462667/git-completion-not-working-in-zsh-on-os-x-yosemite-with-homebrew
autoload -U compinit && compinit
zmodload -i zsh/complist

# following is not necessary if git-completion.zsh is already in bash_completion
# zstyle ':completion:*:*:git:*' script /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.zsh

HISTSIZE=50000
SAVEHIST=10000
setopt extended_history
setopt hist_expire_dups_first
setopt inc_append_history
setopt share_history
setopt always_to_end
plugins=(git colored-man-pages colorize pip python brew osx zsh-syntax-highlighting zsh-autosuggestions)

# word characters are only alphanumeric (each dir in a path is a word)
autoload -U select-word-style
select-word-style bash
bindkey "^[[D" backward-word # left arrow key
bindkey "^[[C" forward-word # right arrow key
bindkey "^[a" beginning-of-line # ctrl-a
bindkey "^[e" end-of-line # ctrl-e
bindkey "^H" backward-kill-word # ctrl-backspace
# new feature added Feb 2020 to iTerm2
source ~/.iterm2_shell_integration.zsh
# fancy prompt settings so it's easy to see the git status
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%{%F{green}%B%}'
zstyle ':vcs_info:*' unstagedstr '%{%F{red}%}'
zstyle ':vcs_info:git*' formats '%u%c(%b%a)'
precmd () { vcs_info }
setopt prompt_subst
# TODO: show only first two and last two directories
PROMPT='%F{cyan}[%T] %~ ${vcs_info_msg_0_}%F{cyan}%b %#%f '
