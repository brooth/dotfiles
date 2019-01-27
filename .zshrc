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
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_151.jdk/Contents/Home
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH="$PATH:$HOME/gradle/bin"
export PATH=$PATH:$HOME/Library/flutter/bin

# Node.js
#export PATH="/usr/local/opt/node@8/bin:$PATH"

# Python
export PYTHONSTARTUP=~/.pystartup

# FZF
# Setting ag as the default source for fzf
export FZF_DEFAULT_COMMAND='ag -g ""'
# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

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
alias drm='docker rm -f'
alias drmi='docker rmi'
alias dr='docker run'
alias dl='docker logs -f'
alias de='docker exec -it'
alias ds='docker start'
alias dsi='docker start -ia'
alias dst='docker stop'
alias drs='docker restart'
alias db='docker build -t'
alias da='docker attach'

#=============================================================
#======================== Misc ===============================
#=============================================================
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

PROMPT='%{$fg_bold[blue]%}%(!.%1~.%~) %(!.%{$fg_bold[red]%}.%{$fg_bold[green]%}$(git_prompt_info)%_)%{$fg_bold[blue]%}$%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=" "
