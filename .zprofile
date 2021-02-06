source .aliases

export CLICOLOR=1
export COLORTERM=truecolor

function pathadd() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1${PATH:+":$PATH"}"
    export PATH
  fi
}

pathadd /usr/local/Cellar/gdb/10.1/bin

# Setup background screen processes
function screen_setup() {
  screen -ls
  for file in $(ls /dev/ttyUSB*); do
    USB=$(echo $file | grep -o USB.)
    set -x
    screen -L -Logfile /ssd/logs/$USB.log -dmS $USB $file 115200
    { set +x; } &>/dev/null
  done
  screen -ls
}

source .zshrc
