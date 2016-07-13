### Apps
- Chrome https://www.google.se/chrome/browser/desktop/
- iTerm2 https://www.iterm2.com/
- Oh My Zsh  ```sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"```
- 1 Password https://1password.com/
- Dropbox https://www.dropbox.com/downloading
- Shortcat https://shortcatapp.com/
- Spectacle https://www.spectacleapp.com/


### Settings
PNG as standard screenshot format ```defaults write com.apple.screencapture type png;killall SystemUIServer```

Set Git email ```git config --global user.email "your_email@example.com"```



### Generate SSH-key
```
ssh-keygen -t rsa -b 4096 -C "Kommentar på nyckel" && ssh-add ~/.ssh/id_rsa && pbcopy < ~/.ssh/id_rsa.pub
```

### Sublime
- Sublime Text https://www.sublimetext.com/
Add shortcut to Sublime ```sudo mkdir -p /usr/local/bin && sudo ln -sv "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl```
- Sublime Package Control https://packagecontrol.io/installation
- Sublime Packages
 - Emmet
 - GitGutter-Edge
 - GitSavvy