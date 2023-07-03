function __virtual_env
    if test -n "$VIRTUAL_ENV"
        printf ' in '
        set_color -o yellow
        printf '%s' (basename "$VIRTUAL_ENV")
        set_color normal
        printf ' env'
    end
end

function __prompt_pwd
    set --local max_len 64
    set --local dir (string replace "$HOME" "~" "$PWD")

    if test (string length "$dir") -gt $max_len;
        set dir (prompt_pwd)
    end
    echo "$dir"
end

function __cmd_duration --argument-names last_duration
    test "$last_duration" -lt 1000 && return

    set --local secs (math --scale=1 $CMD_DURATION/1000 % 60)
    set --local mins (math --scale=0 $CMD_DURATION/60000 % 60)
    set --local hours (math --scale=0 $CMD_DURATION/3600000)

    test $hours -gt 0 && set --local --append out $hours"h"
    test $mins -gt 0 && set --local --append out $mins"m"
    test $secs -gt 0 && set --local --append out $secs"s"

    set_color cyan
    printf ' %s' $out
    set_color normal
end

function fish_prompt
    set last_status $status

    printf '\n'

    # error status code
    if test $last_status -ne 0
        set_color red -o
        printf '[%d] ' $last_status
        set_color normal
    end

    if test "$SSH_CONNECTION" != ""
        # username
        set_color $fish_color_user
        printf '%s' (whoami)
        # at
        set_color normal
        printf ' at '
        # host
        set_color $fish_color_host
        printf '%s' (hostname|cut -d . -f 1)
        # in
        set_color normal
        printf ' in '
    end

    # pwd
    set_color $fish_color_cwd
    printf '%s' (__prompt_pwd)
    set_color normal

    # cool stuff
    set -g __fish_git_prompt_show_informative_status
    fish_git_prompt
    __virtual_env
    __cmd_duration $CMD_DURATION

    # if test -n "$fish_bind_mode"
    #     switch $fish_bind_mode
    #         case default
    #             set_color -b green black
    #             printf " N "
    #         case insert
    #             set_color black
    #             printf " I "
    #         case visual
    #             set_color -b yellow black
    #             printf " V "
    #     end
    #     set_color normal
    # end

    printf '\n'

    if test $last_status -eq 0
        set_color white -o
        printf '❯‹((°❯ '
    else
        set_color red -o
        printf '❯‹((ˣ❯ '
    end

    set_color normal
end
