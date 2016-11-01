#!/bin/env bash

_ansible-galaxy() {
    local current_word=${COMP_WORDS[COMP_CWORD]}
    local previous_words=${COMP_WORDS[@]:1:COMP_CWORD-1}
    local subcommands="init info install list remove delete import login search setup"
    local common_options="-h --help -v --verbose --version -c --ignore-certs -s --server"
    local subcommand=""
    local options=""

    for subc in $subcommands; do
        if [[ ${previous_words[@]#$subc} != ${previous_words[@]} ]]; then
            subcommand=$subc
            break
        fi
    done

    case $subcommand in
        init)
            options="-p --init-path --offline -f --force"
            ;;
        info)
            options="-p --roles-path --offline"
            ;;
        install)
            options="-i --ignore-errors -n --no-deps -r --role-file -p --roles-path -f --force"
            ;;
        list)
            options="-p --roles-path"
            ;;
        remove)
            options="-p --roles-path"
            ;;
        import)
            options="--branch --no-wait --status"
            ;;
        login)
            options="--github-token"
            ;;
        search)
            options="--author --galaxy-tags -p --roles-path --platforms"
            ;;
        setup)
            options="--list --remove"
            ;;
    esac

    if [ -z $subcommand ]; then
        COMPREPLY=( $( compgen -W "$subcommands" -- "$current_word" ) )
    elif [[ "$current_word" == -* ]]; then
        COMPREPLY=( $( compgen -W "$options $common_options" -- "$current_word" ) )
    fi

    #case $previous_word in
        #init|info|install|list|remove)
            #options="${options} -h --help"
            #if [[ "$current_word" == -* ]]; then
                #COMPREPLY=( $( compgen -W "$options" -- "$current_word" ) )
            #fi
            #;;
        #*)
            #COMPREPLY=( $( compgen -W "$options" -- "$current_word" ) )
            #;;
    #esac
}

complete -o default -F _ansible-galaxy ansible-galaxy
