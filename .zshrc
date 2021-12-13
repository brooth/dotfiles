#=============================================================
#=============================================================
#=========================== Settings ========================
#=============================================================
export ZSH=~/.oh-my-zsh
export TERM="xterm-256color"
export LC_ALL=en_US.UTF-8

#source ~/.zshprc

# History per pane
# setopt no_share_history

# Enabled true color support for terminals
export NVIM_TUI_ENABLE_TRUE_COLOR=1

#=============================================================
#=========================== Plugins ========================
#=============================================================
plugins=(
    docker 
    git 
    zsh-autosuggestions
    brew
    node
    tmux
    you-should-use
)

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

bindkey '^j' autosuggest-accept

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
alias dart=./.flutter/bin/dart

# Docker
alias doc='docker-compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias drm='docker rm'
alias drmf='docker rm -f'
alias drmi='docker rmi'
alias drmif='docker rmi -f'
alias dr='docker run'
alias dl='docker logs'
alias dlf='docker logs -f'
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
alias nrd='npm run debug'
alias nrdi='npm run dist'
alias nrdp='npm run deploy'
alias nrl='npm run lint'
alias nrs='npm run start'
alias nrc='npm run clean'

# git
alias gss='git status -s'
alias gp='git push'
alias ga='git add'
alias gd='git diff'
alias gl='git pull'
alias gc='git commit -v'
alias gco='git checkout'
alias gr='git reset --hard'

#=============================================================
#======================== Misc ===============================
#=============================================================
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source $ZSH/oh-my-zsh.sh

PROMPT='%{$fg[blue]%}%~%{$reset_color%} $(git_prompt_info)'
RPROMPT="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=" %{$reset_color%}"

#=============================================================
#====================== Auto gen =============================
#=============================================================

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/brooth/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/brooth/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/brooth/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/brooth/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

