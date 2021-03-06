#!/usr/bin/env bash
#>         +----------------------+
#>         |    pyenv_setup.sh    |
#>         +----------------------+
#-
#- SYNOPSIS
#-
#-    ./pyenv_setup.sh [-h]
#-
#- OPTIONS
#-
#-    -y,                    all accept.
#-    -h, --help             print help information.
#-
#- EXAMPLES
#-
#-    $ ./pyenv_setup.sh -y

#====================================================
# Part 1. Option Tool (DO NOT MODIFY)
#====================================================
# Print script help
function show_script_help(){
    echo
    head -17 $0 | # find this file top 16 lines.
    grep "^#[-|>]" | # show the line that include "#-" or "#>".
    sed -e "s/^#[-|>]*//1" # use nothing to replace "#-" or "#>" that the first keyword in every line.  
    echo 
}
# Receive arguments in slient mode.
all_accept=0
if [ "$#" -gt 0 ]; then
    while [ "$#" -gt 0 ]; do
        case "$1" in
            # Help
            "-h"|"--help")
                show_script_help
                exit 1
            ;;
            # All Accept
            "-y")
                all_accept=1
                shift 1
            ;;
        esac
    done
fi

function Ask_yn(){
    printf "$1 [y/n]" 
    if [ $all_accept = 1 ]; then
        printf "-y\n"
        return 1
    fi
    read respond
    if [ "$respond" = "y" -o "$respond" = "Y" -o "$respond" = "" ]; then
        return 1
    elif [ "$respond" = "n" -o "$respond" = "N" ]; then
        return 0
    else
        echo 'wrong command!!'
        Ask_yn $1
        return $?
    fi
    unset respond
}

#====================================================
# Part 2. Main
#====================================================
Keyword='export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi'
case $SHELL in
    *zsh )
    shell=zsh
    profile=~/.zshrc
    ;;
    *bash )
    shell=bash
    profile=~/.bashrc
    ;;
    *ksh )
    shell=ksh
    profile=~/.profile
    ;;
    * )
    echo "unknow sehll, need to manually add pyenv config on your shell profile!!"
    ;;
esac
# sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
sudo apt-get update
sudo apt-get install --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# config profile
Ask_yn "Do you want automatic add pyenv config?"; result=$?
if [ $result = 1 ]; then
    if grep -xn "$Keyword" $profile; then
        echo "You have already added pyenv config in $profile !!"
    else
        printf "\n# pyenv setting\n$Keyword\n" >> $profile
    fi
    echo "Done!!"
    
    if [ $shell = bash ]; then
        source $profile
    else
        exec $shell
    fi
fi
