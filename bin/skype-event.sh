#!/usr/bin/env sh
SKYPE_ID="$1"
EVENT_TYPE="$2"
SKYPE_NAME="$3"

which xdotool   >/dev/null 2>&1 || exit 1
which seturgent >/dev/null 2>&1 || exit 1

urgentify() {
    local ids=$@
    for id in $ids; do
        seturgent "$id"
    done
}

findChat() {
    local ids=""
    ids=$(xdotool search --all --limit 1 --name "${SKYPE_NAME}.*Skype.*Chat")
    if [ -z "$ids" ]; then
        ids=$(xdotool search --name ".* - Skype.*(Beta)")
    fi
    echo $ids
}


case "$EVENT_TYPE" in
    ChatIncoming)
        urgentify `findChat`
        ;;
    ChatIncomingInitial)
        urgentify `findChat`
        ;;
    *)
        # echo "Type $EVENT_TYPE    Id $SKYPE_ID    Name $SKYPE_NAME" >> /tmp/skype.log
        ;;
esac
