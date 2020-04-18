#!/usr/bin/env bash

# Create an exclusive right named pipe in tmp to receive and execute
# Arbitrary commands.

FIFO_FILE=/tmp/command-server-pipe
if [ -e $FIFO_FILE ] ; then
    rm $FIFO_FILE
fi
mkfifo $FIFO_FILE

if [ ${1:-notsbt} = "sbt" ] ; then
    SBT_PIPE=$(mktemp -d)
    SBT_PIPE=${SBT_PIPE:-/tmp/tmp.XXXXXX}
    mkfifo $SBT_PIPE/p
    # WTF??? If using sbt, the script must be ran in foreground, otherwise
    # sbt will stop. Yet sbt is ran in background within the script.
    sbt <$SBT_PIPE/p &
    SBT_ID=$!
    trap "pkill -P $SBT_ID ; rm -rf $SBT_PIPE ; exit" TERM INT EXIT
fi

function open-qute {
    _url="$1"
    _qb_version='1.0.4'
    _proto_version=1
    _ipc_socket="${XDG_RUNTIME_DIR}/qutebrowser/ipc-$(echo -n "$USER" | md5sum | cut -d' ' -f1)"
    _qute_bin="/usr/bin/qutebrowser"

    printf '{"args": ["%s"], "target_arg": null, "version": "%s", "protocol_version": %d, "cwd": "%s"}\n'            "${_url}"            "${_qb_version}"            "${_proto_version}"     "${PWD}" | socat - UNIX-CONNECT:"${_ipc_socket}" 2>/dev/null || "$_qute_bin" "$@" &
}

declare -i count=1
# while cmd="$(tail -1 $FIFO_FILE)" ; do
while IFS='#' read -r cmddir cmd <<<"$(tail -1 $FIFO_FILE)" ; do
    cd "$cmddir"
    printf "in \e[7m%s$(tput sgr0)\n>> \e[7m%s$(tput sgr0)\n" "$PWD" "$cmd"
    if [ ${1:-notsbt} = "sbt" ] ; then
        echo "$cmd" >> $SBT_PIPE/p
    else
        eval "$cmd"
    fi
    colcount=$(tput cols)
    printf -v termwidthline '%*s' $colcount
    echo -e "\e[7m$(tput setaf 5)${termwidthline// /-}"
    printf "#%-3s ^%-$((colcount-6))s\n" $count "$cmd"
    echo -e "${termwidthline// /-}$(tput sgr0)"
    count+=1
done

