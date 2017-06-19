function fish_user_key_bindings --description 'User key bindings for fish'
    # set -l mode
    # if functions -q fish_vi_key_bindings
    #     fish_vi_key_bindings
    #     fish_default_key_bindings -M insert -m insert
    #     if set -q fish_vi_cursor
    #         fish_vi_cursor
    #     end
    #     set fish_bind_mode insert
    #     set mode -M insert -m insert

    #     bind -M insert -e \cc
    #     bind -M insert -m default \cc force-repaint
    #     bind \cc 'commandline ""'

    #     bind dG 'commandline ""'
    #     bind cG -m insert 'commandline ""' force-repaint

    #     bind gt __commandline_toggle
    #     bind ge .edit_cmd
    #     bind : 'read -l -s -m vi_command -p "echo $fish_bind_mode:" var; echo $var|source; commandline -f repaint'

    #     # bind -M default -m default 0 beginning-of-line
    #     # bind -M default -m default \cl 'clear; commandline -f repaint'
    # end
end

