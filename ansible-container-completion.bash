#!/bin/env bash

_ansible-container() {
    local current_word=${COMP_WORDS[COMP_CWORD]}
    local previous_words=${COMP_WORDS[@]:1:COMP_CWORD-1}
    local subcommands="init version run help install push shipit stop restart build"
    local common_options="-h --help --debug --engine --var-file"
    local help_options="-h --help"
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
            options="-s --server"
            ;;
        run)
            options="--production -d --detached -o --remove-orphans --with-volumes --with-variables --roles-path"
            ;;
        push)
            options="--username --email --password --push-to --with-volumes --with-variables --roles-path"
            ;;
        shipit)
            options="--with-volumes --with-variables --roles-path kube openshift"
            ;;
        stop)
            options="-f --force"
            ;;
        build)
            options="--flatten --no-purge-last --from-scratch --local-builder --save-build-container "
            options+="--services --with-volumes --with-variables --roles-path"
            ;;
    esac

    if [ -z $subcommand ]; then
        COMPREPLY=( $( compgen -W "$subcommands $common_options" -- "$current_word" ) )
    elif [[ "$current_word" == -* ]]; then
        if [ $subcommand == 'build' ] && echo ${previous_words[@]}|grep -q -- '\s--\(\s\|$\)'; then
            local ansible_options=$(     \
                ansible --help         | \
                sed '1,/Options/d'     | \
                grep -Eoie "--?[a-z-]+"  \
            )
            COMPREPLY=( $( compgen -W "$ansible_options" -- "$current_word" ) )
        else
            COMPREPLY=( $( compgen -W "$options $help_options" -- "$current_word" ) )
        fi
    fi

}

complete -o default -F _ansible-container ansible-container
