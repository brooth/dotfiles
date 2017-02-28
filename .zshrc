export ZSH=~/.oh-my-zsh

ZSH_THEME="gentoo"

plugins=(git)

# User configuration
export PATH="$PATH:$HOME/gradle/bin:$HOME/Android/Sdk/platform-tools"
export JAVA_HOME=/usr/lib/jvm/java-7-oracle
export ANDROID_HOME=~/Android/Sdk
export PYTHONSTARTUP=~/.pystartup
export TERM="xterm-256color"

# Setting ag as the default source for fzf
export FZF_DEFAULT_COMMAND='ag -g ""'
# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

source $ZSH/oh-my-zsh.sh
source ~/.zshprc

setopt no_share_history

alias g=~/gradle/bin/gradle

alias vi='nvim -u ~/Projects/dotfiles/vimrc.vim'
alias wi='nvim -u ~/Projects/dotfiles/webvimrc.vim'
alias pi='nvim -u ~/Projects/dotfiles/pyvimrc.vim'
alias ack-grep=ack

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
