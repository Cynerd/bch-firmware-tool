# Bash completion file for bcf
# vim: ft=sh

_bcf_device() {
    COMPREPLY+=($(compgen -S "/dev/tty*" -- ${cur}))
}

_bcf_log() {
    case "$prev" in
        --record)
            COMPREPLY+=($(compgen -o default -- ${cur}))
            return 1
            ;;
        *)
            COMPREPLY+=($(compgen -W "--time --no-color --raw --record" -- ${cur}))
            ;;
    esac
}

_bcf_log_option_not_present() {
    local element
    for element in "${words[@]}"; do
        [ "$element" != "--log" ] || return 1
    done
    return 0
}

_bcf() {
    local cur prev words cword
    _init_completion || return
    if [ "$cword" -gt 1 ]; then
        case "${words[1]}" in
            update)
                # Nothing except of help
                ;;
            list)
                COMPREPLY+=($(compgen -W "--all --description --show-pre-release" -- ${cur}))
                ;;
            flash)
                case "$prev" in
                    --device)
                        _bcf_device
                        return
                        ;;
                    *)
                        _bcf_log_option_not_present || _bcf_log || return
                        COMPREPLY+=($(compgen -W "--device --dfu --log --erase-eeprom" -- ${cur}))
                        COMPREPLY+=($(compgen -S "*.bin" -- ${cur})) # <file>
                        COMPREPLY+=($(compgen -W "$(bcf list)" -- ${cur})) # <firmware>
                        # No completion for <url>
                        ;;
                esac
                ;;
            devices)
                COMPREPLY+=($(compgen -W "-v --verbose" -- ${cur}))
                ;;
            search)
                COMPREPLY+=($(compgen -W "--all --description --show-pre-release" -- ${cur}))
                ;;
            pull)
                COMPREPLY+=($(compgen -W "$(bcf list)" -- ${cur})) # <firmware>
                # No completion for <url>
                ;;
            clean)
                # Nothing except help
                ;;
            create)
                COMPREPLY+=($(compgen -W "--no-git" -- ${cur}))
                ;;
            read)
                case "$prev" in
                    --length)
                        # No completion
                        return
                        ;;
                    --device)
                        _bcf_device
                        return
                        ;;
                    *)
                        COMPREPLY+=($(compgen -W "--device --length" -- ${cur}))
                        ;;
                esac
                ;;
            log)
                _bcf_log || return
                case "$prev" in
                    --device)
                        _bcf_device
                        return
                        ;;
                    *)
                        COMPREPLY+=($(compgen -W "--device" -- ${cur}))
                        ;;
                esac
                ;;
            reset)
                case "$prev" in
                    --device)
                        _bcf_device
                        return
                        ;;
                    *)
                        _bcf_log_option_not_present || _bcf_log || return
                        COMPREPLY+=($(compgen -W "--device --log" -- ${cur}))
                        ;;
                esac
                ;;
            eeprom)
                case "$prev" in
                    --device)
                        _bcf_device
                        return
                        ;;
                    *)
                        COMPREPLY+=($(compgen -W "--device --dfu --erase" -- ${cur}))
                        ;;
                esac
                ;;
            help)
                COMPREPLY+=($(compgen -W "--all" -- ${cur}))
                ;;
        esac
    else
        local cmds="update list flash devices search pull clean create read log reset eeprom help"
        COMPREPLY+=($(compgen -W "${cmds}" -- ${cur}))
        COMPREPLY+=($(compgen -W "-v --version" -- ${cur}))
    fi
    COMPREPLY+=($(compgen -W "-h --help" -- ${cur}))
}

complete  -F _bcf bcf
