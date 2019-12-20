export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="fino"
plugins=(git docker debian dirhistory sudo kubectl kube-ps1 zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh
grep-flag-available() {
    echo | grep $1 "" >/dev/null 2>&1
}
GREP_OPTIONS=""
if grep-flag-available --color=auto; then
    GREP_OPTIONS+=" --color=always"
fi
VCS_FOLDERS="{.bzr,.cvs,.git,.hg,.svn}"
if grep-flag-available --exclude-dir=.cvs; then
    GREP_OPTIONS+=" --exclude-dir=$VCS_FOLDERS"
elif grep-flag-available --exclude=.cvs; then
    GREP_OPTIONS+=" --exclude=$VCS_FOLDERS"
fi
alias grep="grep $GREP_OPTIONS"
export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/ansible/.local/bin
zstyle ':completion:*:processes' command 'ps -ax'
zstyle ':completion:*:processes-names' command 'ps -aeo comm='
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:killall:*:processes-names' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:killall:*' menu yes select
