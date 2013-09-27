# Activates Python virtualenv for current project.
# Supports reading `.venv` from current directory or from git repo root.
# If that's directory with virtual env, activates it.
# If that's git repo with virtual env, activates it.
# If that's file, reads path to virtual env from there.
# Otherwise locates virtual env in ~/.pyenv/.
function venv
    set -l name ".venv"
    set -l homedir "$HOME/.pyenv"

    set -l venv ""
    set -l curdir (pwd)
    set -l gitroot (git rev-parse --show-toplevel 2>/dev/null)

    # Prefer current directory, otherwise take git root.
    set -l locenv "$curdir/$name"
    if test ! -r "$locenv" -a -n "$gitroot"
        set locenv "$gitroot/$name"
    end

    if test -d "$locenv"
        # Prefer local environment if exists.
        set venv "$locenv"
    else
        if test -f "$locenv"
            # If .env is a file, there must be the path to the env.
            set venv (cat "$locenv")
        else
            # If there is no env in repo root, use one from home directory.
            set -l projectname (basename "$gitroot")
            set venv "$homedir/$projectname"
        end
    end

    set -l activate "$venv/bin/activate.fish"
    if test ! -r "$activate"
        echo "Cannot locate virtualenv for this project." >&2
        exit 1
    else
        . "$activate"
    end
end
