# go
if which go &> /dev/null; then
    path_append "$(go env GOPATH)/bin"
    if type gocomplete &> /dev/null; then
        complete -C "$(type -p gocomplete)" go
    fi
    if which godoc &> /dev/null; then
        godocs() {
            killall godoc &> /dev/null
            GO111MODULE=off godoc -index &> /dev/null &
            disown $!
        }
    fi
fi