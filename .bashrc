source .aliases
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# following assumes debian
function play() {
  case $1 in
    failure|f*)
      paplay /usr/share/sounds/gnome/default/alerts/sonar.ogg;;
    success|pass|s*|p*)
      paplay /usr/share/sounds/gnome/default/alerts/glass.ogg;;
  esac
}

function is_screen_unlocked() {
  ps aux | grep xsecurelock | grep -v grep | wc -l
}

function print_build_failures() {
  # note: this doesn't always work
  awk '/^FAILED:/,/errors? generated/' /ssd/logs/last_build | grep -vE '(PWD|FAILED)'
  echo -e "\e[31;1mBUILD FAILED\e[m"
}

# some default settings for pixel kernel
# TODO: add for qualcomm build
function arm64env() {
    export ARCH=arm64
    export SUBARCH=arm64
    export CROSS_COMPILE=aarch64-linux-android-
}

# generate a progress bar from a line of android build output
function generate_progress_bar() {
  line=$1
  progress=$(echo "$line" | grep -o "[0-9]\+/[0-9]\+" | head -1)
  if [ -z "$progress" ]; then return; fi
  done=$(echo "$progress" | grep -o "[0-9]\+/" | sed "s/\///")
  if [ "$done" -eq "0" ]; then return; fi
  todo=$(echo "$progress" | grep -o "/[0-9]\+" | sed "s/\///")
  if [ -z "$todo" ]; then return; fi
  time_spent=$(echo "$line" | grep -o ": [0-9]\+" | sed "s/: //")
  percent=$(( ($done * 100) / $todo ))
  minutes=$(( $time_spent / 60 ))
  seconds=$(( $time_spent % 60 ))
  echo -ne "\033[1K\r$percent% done, $minutes min $seconds sec"
}

