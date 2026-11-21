#!/bin/sh

FORGE_URL=${FORGE_URL:-https://dev.vchu.net}
FORGE_USER=${FORGE_USER:-chu}

usage() {
    cmd=$(basename "$0")
    cat << EOF
Usage: $cmd -t generic|gen owner/name/version[/file] <artifact>
       $cmd -t debian|deb|apt owner/distribution/component <package.deb>

Uploads an artifact to Forgejo. For generic packages, if file is omitted,
the artifact's basename is used.
EOF
    exit "$1"
}

path_generic() {
    owner=${1%%/*}
    path=${1#*/}
    name=${path%%/*}
    path=${path#*/}
    version=${path%%/*}
    file=${path#*/}
    [ "$file" != "$path" ] || file=$(basename "$2")
    echo "$owner/generic/$name/$version/$file"
}

path_debian() {
    owner=${1%%/*}
    path=${1#*/}
    echo "$owner/debian/pool/$path/upload"
}

[ "$#" -gt 0 ] || usage 0
while getopts ':ht:' opt; do
    case "$opt" in
        h) usage 0 ;;
        t) type=$OPTARG ;;
        *) usage 1 ;;
    esac
done
shift $((OPTIND - 1))

[ "$#" -eq 2 ] || usage 1

case $type in
    gen | generic) path=$(path_generic "$1" "$2") ;;
    deb | debian | apt) path=$(path_debian "$1") ;;
    *)
        echo "ERROR: invalid package type: $type"
        usage 1
        ;;
esac

curl --silent --show-error --fail-with-body --location \
    --user "$FORGE_USER" \
    --upload-file "$2" \
    --write-out '\nHTTP %{http_code}\n' \
    "$FORGE_URL/api/packages/$path"
