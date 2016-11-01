#!/bin/env bash -e

_ansible-vault() {
    local comp_cword=$COMP_CWORD
    local current_word=${COMP_WORDS[COMP_CWORD]}
    local previous_words=${COMP_WORDS[@]:1:COMP_CWORD-1}
    local subcommands="create decrypt edit encrypt rekey"
    local common_options="--vault-password-file --new-vault-password-file --ask-vault-pass -h --help -v --verbose --version"
    local subcommand=""

    for subc in $subcommands; do
        if [[ ${previous_words[@]#$subc} != ${previous_words[@]} ]]; then
            subcommand=$subc
            break
        fi
    done

    case $subcommand in
        decrypt|encrypt)
            if [[ "$current_word" == -* ]]; then
                local options="--output $common_options"
                COMPREPLY=( $( compgen -W "$options" -- "$current_word" ) )
            fi
            ;;
        create|edit|rekey)
            if [[ "$current_word" == -* ]]; then
                COMPREPLY=( $( compgen -W "$common_options" -- "$current_word" ) )
            fi
            ;;
        *)
            COMPREPLY=( $( compgen -fdW "$subcommands" -- "$current_word" ) )
            ;;
    esac
}

complete -o default -F _ansible-vault ansible-vault
