#compdef bcf
#autoload

_bcf() {
    local state
    if (( CURRENT == 2 )); then
        _values "Operation" \
            "update" \
            "list" \
            "flash" \
            "devices" \
            "search" \
            "pull" \
            "clean" \
            "create" \
            "read" \
            "log" \
            "reset" \
            "eeprom" \
            "help"
    else
        local log_args = false
        local arguments = ()
        case "${words[2]}" in
            list)
                arguments += (
                    "--all[show all releases]",
                    "--description[show description]",
                    "--show-pre-release[show pre-release version"
                )
                ;;
            flash)
                arguments += (
                    "--device[device]:->device",
                    "--dfu[use dfu mode]",
                    "--erase-eeprom[erase eeprom]"
                )
                log_args = true
                # TODO firmware and so on?
                ;;
            devices)
                arguments += (
                    {-v,--verbose}"[show more messages]"
                )
                ;;
            search)
                arguments += (
                    "--all[show all releases]",
                    "--description[show description",
                    "--show-pre-release[show pre-release version]"
                )
                ;;
            pull)
                # TODO firmwares?
                ;;
            create)
                arguments += ("--no-git[disable git]")
                ;;
            read)
                arguments += (
                    "--device[device]:->device",
                    "--lenght[lenght]:->ignore"
                )
                ;;
            log)
                log_args = true
                arguments += ("--device[device]:->device")
                ;;
            reset)
                log_args = true
                arguments += ("--device[device]:->device")
                ;;
            eeprom)
                arguments += (
                    "--device[device]:->device",
                    "--dfu[use dfu mode]",
                    "--erase[erase]"
                )
                ;;
            help)
                arguments += ("--all[show help for all commands]")
                ;;
        esac
        if $log_args; then
            arguments += (
                "--log["
            )
        fi
        _arguments "${arguments[@]}"
        if [ "$state" = "ignore" ]; then
            # TODO and device
            false
        fi
    fi
    if [ -z "$state" ]; then
        _arguments \
            {-h,--help}"[show help message]" \
            {-v,--version}"[show program's version number]"
    fi
}

compdef _bcf bfg
#_bcf
# vim: ft=zsh
