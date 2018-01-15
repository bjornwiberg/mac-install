## Install Brew
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### Git
```
brew install git
```
- Git email
```
git config --global user.email "b@bjrn.nu"
```

- vim as default git commit editor
```
git config --global core.editor /usr/bin/vim
```

## Glone repo
```
cd && git clone --depth=1 https://github.com/bjornwiberg/mac-install.git
```

### Brew bundle
```
cd ~/mac-install && brew bundle
```
### Osx settings
```
cd ~/mac-install && chmod +x .osx && ./.osx
```

### Create directories
```
mkdir ~/.vim
cd ~/.vim
mkdir bundle undo swap
```

### Symlink dotfiles
```
cd
touch ~/.aliases
ln -s mac-install/dotfiles/.vimrc
rm ~/.zshrc
ln -s mac-install/dotfiles/.zshrc
ln -s mac-install/dotfiles/.shortcuts
ln -s mac-install/dotfiles/.functions


### Oh My Zsh
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```
### Vim things
```
- Spacegrey color scheme
```
cd ~/.vim/bundle && git clone git://github.com/ajh17/Spacegray.vim.git
```
- Vundle
```
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

```

### Fonts
- Nerd Font Patched
```
cd ~/Library/Fonts && curl -fLo "Droid Sans Mono Nerd Font Complete Mono.otf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono.otf\?raw\=true
```


### Generate SSH-key
```
ssh-keygen -t rsa -b 4096 -C "Kommentar på nyckel" && ssh-add ~/.ssh/id_rsa && pbcopy < ~/.ssh/id_rsa.pub
```

