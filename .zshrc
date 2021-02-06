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

bindkey "[D" backward-word
bindkey "[C" forward-word
bindkey "^[a" beginning-of-line
bindkey "^[e" end-of-line
# new feature added Feb 2020
source ~/.iterm2_shell_integration.zsh
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
