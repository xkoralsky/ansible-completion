#!/bin/env bash

_ansible-pull() {
    local current_word=${COMP_WORDS[COMP_CWORD]}
    local options=$(ansible-pull --help | \
                    sed '1,/Options/d'  | \
                    grep -Eoie "--?[a-z-]+")

    if [[ "$current_word" == -* ]]; then
        COMPREPLY=( $( compgen -W "$options" -- "$current_word" ) )
    fi
}

complete -o default -F _ansible-pull ansible-pull
