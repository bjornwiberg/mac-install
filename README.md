## Install Brew

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
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

- nvim as default git commit editor

```
git config --global core.editor /opt/homebrew/bin/nvim
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

### Symlink dotfiles

```
cd
touch ~/.aliases
rm ~/.zshrc
ln -s mac-install/dotfiles/.zshrc
ln -s mac-install/dotfiles/.shortcuts
ln -s mac-install/dotfiles/.functions
ln -s mac-install/dotfiles/.tmux.conf
```

### Symlink settings for nvim

```
mkdir -p ~/.config
cd ~/.config
ln -s ~/mac-install/dotfiles/nvim
```

### Install pynvim for python3 support in nvim

```
python3 -m pip install --user --upgrade pynvim
```

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

### Install tpm for TMUX

```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

#### Install tmux plugins

```
tmux
```

**Press prefix + I to fetch the plugins and source them.**

### Teamocil

https://github.com/remi/teamocil

```
gem install teamocil
cd && ln -s mac-install/dotfiles/.teamocil
```

### Nerd Font Patched

```
cd ~/Library/Fonts && curl -fLo "FiraCodeNerdFontMono-Regular.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/FiraCodeNerdFontMono-Regular.ttf
```
