#=============================================================
#=========================== Settings ========================
#=============================================================
export ZSH=~/.oh-my-zsh
export TERM="xterm-256color"

source $ZSH/oh-my-zsh.sh
#source ~/.zshprc

# History per pane
setopt no_share_history

#=============================================================
#=========================== Plugins ========================
#=============================================================
plugins=(docker git)

#=============================================================
#======================== Env Variables ======================
#=============================================================
# Java & Android
export JAVA_HOME="/Applications/Android Studio.app/Contents/jre/jdk/Contents/Home"
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH="$PATH:$HOME/gradle/bin"
export PATH=$PATH:$HOME/Library/flutter/bin

# Node.js
#export PATH="/usr/local/opt/node@8/bin:$PATH"
export NODE_ENV=development

# Python
export PYTHONSTARTUP=~/.pystartup

# FZF
# Setting ag as the default source for fzf
# export FZF_DEFAULT_COMMAND='ag -g ""'
# To apply the command to CTRL-T as well
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

#=============================================================
#======================== Aliases ============================
#=============================================================

# Vim
alias vi='nvim -u ~/Projects/dotfiles/vimrc.vim'
alias ack-grep=ack

# Flutter
alias fl=./.flutter/bin/flutter
alias fll=../.flutter/bin/flutter

# Docker
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias drm='docker rm'
alias drmf='docker rm -f'
alias drmi='docker rmi'
alias dr='docker run'
alias dl='docker logs -f'
alias de='docker exec'
alias dei='docker exec -it'
alias ds='docker start'
alias dsi='docker start -ia'
alias dst='docker stop'
alias drs='docker restart'
alias db='docker build -t'
alias da='docker attach'
alias dp='docker push'
alias dcp='docker cp'

# NPM
alias ni='npm install'
alias nig='npm install -g'
alias nr='npm run'
alias nrb='npm run build'
alias nrbw='npm run build:w'
alias nrd='npm run dev'
alias nrdi='npm run dist'
alias nrl='npm run launch'
alias nrs='npm run start'
alias nrc='npm run clean'

#=============================================================
#======================== Misc ===============================
#=============================================================
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

PROMPT='%{$fg_bold[blue]%}%(!.%1~.%~) %(!.%{$fg_bold[red]%}.%{$fg_bold[green]%}$(git_prompt_info)%_)%{$fg_bold[blue]%}$%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=" "



alias gss='git status -s'
alias gp='git push'
alias ga='git add'
alias gd='git diff'
alias gl='git pull'
alias gc='git commit -v'
