## Install Brew
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

## Install Xcode
```
xcode-select --install
```

### Git
```
brew install git
```
- Generate SSH-key
```
ssh-keygen -t rsa -b 4096 -C "Key comment" && ssh-add ~/.ssh/id_rsa && pbcopy < ~/.ssh/id_rsa.pub
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
cd && git clone --depth=1 git@github.com:bjornwiberg/mac-install.git
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
ln -s mac-install/dotfiles/.tmux.conf
```

### Symlink settings for COC
```
mkdir -p ~/.config/nvim
cd ~/.config/nvim
ln -s ~/mac-install/dotfiles/coc-settings.json
```

### Install pynvim for python3 support in nvim
python3 -m pip install --user --upgrade pynvim

check https://neovim.io/doc/user/provider.html for more info

### Symlink settings for vscode
```
mkdir -p ~/Library/Application\ Support/Code/User
cd ~/Library/Application\ Support/Code/User
rm settings.json
ln -s ~/mac-install/vscode/settings.json
```

### Oh My Zsh
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

### Nerd Font Patched
```
cd ~/Library/Fonts && curl -fLo "Droid Sans Mono Nerd Font Complete Mono.otf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono.otf\?raw\=true
```

### Known Issues
If you encounter
```
Error: An unexpected error occurred during the `brew link` step
```

Then run in terminal
```
sudo chown -R $(whoami) $(brew --prefix)/*
```
