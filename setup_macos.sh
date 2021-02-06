# note: assumes that you're running all of this from the root directory of this repo

# install xcode command line tools (does not include xcode)
xcode-select --install

# install brew and brew packages
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install pyenv libusb gdb cmake lsusb wget git cscope python3 pip3
brew install --cask iterm2
# note: ctags already installed by default

# setup git completion, needs brew packages to be installed first
ln -s /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.zsh /usr/local/etc/bash_completion.d/

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
echo "source $PWD/.zprofile" > ~/.zprofile
ln -s .zshrc ~/.zshrc
wget http://cscope.sourceforge.net/cscope_maps.vim ~/.vim/

echo "Consider installing the following:
 - BetterSnapTool
 - Chrome
 - Slack
 - 1Password
 - Adobe Acrobat Reader
 - Zoom
 - Keynote, Pages, Numbers
 - Unarchiver or iZip?
 - CLion (https://www.jetbrains.com/clion/)
 - Android Studio (https://developer.android.com/studio)
 - XCode
 - TurboTax :'(
 - gem install vimgolf && vimgolf setup
"
