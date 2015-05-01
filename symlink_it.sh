#!/usr/bin/env bash
# "borrowed" some code Fr0m Jonathan Palardy (http://github.com/jpalardy/etc_config/tree/master)
# Author : g0t3n
# CreateDate : 5/1/2015
# comment : 寂寞的5.1 居然在码代码


DIR_TO_PROCESS=( .pip .ssh .vim )
FILE_TO_PROCESS=( .gdbinit .gitignore-sample .htoprc .vimrc )
# Set the colours you can use
black='\033[0;30m'
white='\033[0;37m'
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
 
# Reset text attributes to normal + without clearing screen.
# both osx&linux can use this
alias Reset="tput sgr0"
 
# Color-echo.
# arg $1 = message   arg $2 = Color
cecho() {
  echo "${2}${1}"
  Reset # Reset to normal.
  return
}

reset
# Starting move file
for tmp_dir in ${DIR_TO_PROCESS[@]};
do if [ -d ${HOME}/$tmp_dir ];
then
    mv ${HOME}/${tmp_dir} ${HOME}/${tmp_dir}-before;
    echo "moving existing ${HOME}/${tmp_dir} to ${HOME}/${tmp_dir}-before"; 
fi;
echo "[+] Doing ln -s $(pwd)/${tmp_dir} ${HOME}/${tmp_dir}"
ln -s $(pwd)/${tmp_dir} ${HOME}/${tmp_dir};
done

for tmp_file in ${FILE_TO_PROCESS[@]};
do if [ -f ${HOME}/${tmp_file} ];
then 
    mv ${HOME}/${tmp_file} ${HOME}/${tmp_file}-before;
    echo "moving existing ${HOME}/${tmp_file} to ${HOME}/${tmp_file}-before"; 
fi; 
echo "[+] Doing ln -s $(pwd)/${tmp_file} ${HOME}/${tmp_file}"
ln -s $(pwd)/${tmp_file} ${HOME}/${tmp_file};
done

# Ask for the administrator password upfront
sudo -v
 
# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
 
echo ""
cecho "##############################################" $white
cecho "#  This script will make your  *nix Pretty ;-)." $white
cecho "#   Follow the prompts and you'll be fine." $white
cecho "#" $white
cecho "#            ~ Happy Hacking ~" $white
cecho "#############################################" $white
echo ""
 
cecho ""
cecho "===================================================" $white
cecho "Install oh-my-zsh?" $blue
cecho "===================================================" $white
read -r response
case $response in
  [yY][eE][sS]|[yY])
    echo ""
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

    curl -o Tomorrow\ Night\ Eighties.terminal https://raw.githubusercontent.com/chriskempson/tomorrow-theme/master/OS%20X%20Terminal/Tomorrow%20Night%20Eighties.terminal
    cp Tomorrow\ Night\ Eighties.terminal ~/Desktop/Tomorrow\ Night\ Eighties.terminal

    # copy zsh config files
    cp ./zsh/.zshrc ~/.zshrc
    cp ./zsh/.zprofile ~/.zprofile
    ;;
  *)
    ;;
esac

echo ""
cecho "===================================================" $white
cecho "Install homebrew and other utilities?" $blue
cecho "===================================================" $white
read -r response
case $response in
  [yY][eE][sS]|[yY])
    echo ""
    cecho "🍺  Installing homebrew and other utilities" $blue
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
    brew doctor
    brew update
    brew install bash coreutils curl findutils heroku-toolbelt httpie imagemagick launchrocket \
      node python rabbitmq ssh-copy-id wget

    # cecho "Initializing and loading LaunchControl services from previously installed utilities" $blue
    # ln -sfv /usr/local/opt/redis/*.plist ~/Library/LaunchAgents
    # ln -sfv /usr/local/opt/rabbitmq/*.plist ~/Library/LaunchAgents
   #  ln -sfv /usr/local/opt/mongodb/*.plist ~/Library/LaunchAgentsauth

 #    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.redis.plist
    # launchctl load ~/Library/LaunchAgents/homebrew.mxcl.rabbitmq.plist
    # launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist

    cecho "Installing pip and some python packages" $blue
    sudo easy_install pip
    pip install virtualenv virtualenvwrapper pygments speedtest-cli

    cecho "Installing some global npm modules" $blue
    npm install -g n grunt-cli gulp hicat js-beautify uglify-js pure-prompt resume-cli keybase-installer npm-release \
        duo nsm

    cecho "Installing node stable and latest" $blue
    n stable
    n latest

    cecho "Installing brew-cask" $blue
    brew tap caskroom/versions
    brew install brew-cask

#     echo 'Installing items not installed here (most likely from App store, or other sources):'
    # echo '- Airmail (app store)'
    # echo '- Instashare (app store)'
    # echo '- Tweetdeck (app store)'
    # echo '- XCode (app store)'
    # echo '- '
    # echo 'Installing apps'
    # brew cask install \
      # air-video-server-hd airserver airdisplay alfred android-studio appcleaner atom \
      # cakebrew cinch daisydisk dropbox evernote \
      # firefox firefox-aurora flux google-chrome google-chrome-canary iterm2 istat-menus \
      # licecap mou onepassword postgres steam send-to-kindle \
      # skype sublime-text3 transmission vlc virtualbox

    brew cask cleanup
    ;;
  *)
    ;;
esac


# finally
# both linux&osx have reset
reset
