export ZSH=~/.oh-my-zsh
ZSH_THEME="mortalscumbag"
plugins=(git)
source $ZSH/oh-my-zsh.sh
. ~/.aliases
. ~/.shortcuts
. ~/.functions
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

  export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion
