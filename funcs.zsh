#!/usr/bin/env zsh

f () {
    # look for file by name
    sudo find -x . -not -path "*/.MobileBackups/*" -name "$1"
}
f-broken () {
    # look for broken symlinks
    sudo find . -type l -exec sh -c "file -b {} | grep -q ^broken" \; -print
}
f-symlink () {
    # look for all symlinks in $HOME
    sudo find . -not -path "/.MobileBackups/*" -type l ;
}

feed-me () {
    # list all alias, bins & funcs available, http://stackoverflow.com/a/948353
    (alias | cut -f1 -d= ; hash -f; hash -v | cut -f 1 -d= ; typeset +f) | sort
}


# http://ijoshsmith.com/2013/10/29/view-hidden-files-and-directories-with-finder-in-os-x-mavericks/
toggle-hidden-files () {
    local current=$(defaults read com.apple.finder AppleShowAllFiles)
    local new

    [[ "$current" == "YES" ]] && new="NO" || new="YES"

    defaults write com.apple.finder AppleShowAllFiles "$new"

    killall Finder
}

# defaults write com.apple.screencapture disable-shadow -bool false
toggle-drop-shadow () {
    local current=$(defaults read com.apple.screencapture disable-shadow)
    local new

    [[ "$current" == 1 ]] && new=0 || new=1

    defaults write com.apple.screencapture disable-shadow "$new"
}

# http://apple.stackexchange.com/a/212694
toggle-bezels-off () {
    launchctl unload -F /System/Library/LaunchAgents/com.apple.BezelUI.plist
}

# http://stackoverflow.com/a/19458175
remove-xattrs () {
    for file in "$@"
    do
        xattr "$file" | xargs -I {} xattr -d {} "$file"
    done
}

# VS Code
# https://code.visualstudio.com/docs/setup/mac#_command-line

git-tag () {
    git tag -l | xargs git tag -d && git fetch -t
}


# LOADERS
##########

yrn () {
    yarn $@ --no-lockfile
}

nvml () {
    export NVM_DIR=~/.nvm

    # hint: $ ln -s $(brew --prefix nvm)/nvm.sh ~/.nvm/nvm.sh
    source ~/.nvm/nvm.sh

    # thought about conditionally setting `yrn` - eaiser to always be present
    # command -v yarn >/dev/null 2>&1 && { yrn () { yarn $@ --no-lockfile } }
}

nvmu () {
    nvml
    nvm install node --reinstall-packages-from=`nvm current`
    nvm alias default `nvm current`
    cd ~/.nvm/versions
    ln -sfn node/`nvm current` default
    cd -
}

awsl () {
    # A M A Z O N W E B S E R V I C E S
    source /usr/local/share/zsh/site-functions/_aws
    export AWS_ROOT_OATH_KEY=<insert-key>
    alias aws-iotp="oathtool --totp --base32 ${AWS_ROOT_OATH_KEY}"
    export AWS_DEFAULT_PROFILE=arcadia.digital
}

gcloudl () {
    # G O O G L E C L O U D S D K
    source '/Users/rbose85/.gcloud-sdk/path.zsh.inc'       # update PATH gcloud SDK
    path=(/Users/rbose85/.gcloud-sdk/bin $path)
    source '/Users/rbose85/.gcloud-sdk/completion.zsh.inc' # command completion
}
