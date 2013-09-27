function __prompt_char
    if git root >/dev/null 2>&1
       printf '±'
    else
        if hg root >/dev/null 2>&1
            printf '☿'
        else
            printf '°'
        end
    end
end

function __virtual_env
    if test -n "$VIRTUAL_ENV"
        printf ' in '
        set_color -o yellow
        printf '%s' (basename "$VIRTUAL_ENV")
        printf ' environment'
        set_color normal
    end
end

function fish_prompt
    set last_status $status

    printf ' \n'

    # username
    set_color magenta
    printf '%s' (whoami)
    # at
    set_color normal
    printf ' at '
    # host
    set_color yellow
    printf '%s' (hostname|cut -d . -f 1)
    # in
    set_color normal
    printf ' in '
    # pwd
    set_color $fish_color_cwd
    printf '%s' (prompt_pwd)
    set_color normal
    # cool stuff
    __fish_git_prompt
    __virtual_env

    printf '\n'

    if test $last_status -eq 0
        # scm-aware fishy
        set_color white -o
        printf '><(('
        __prompt_char
        printf '> '
    else
        # dead fishy
        set_color red -o
        printf '[%d] ><((ˣ> ' $last_status
    end

    set_color normal
end
