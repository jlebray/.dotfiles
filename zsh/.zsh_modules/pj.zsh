PROJECT_PATHS=(~/code)

pj () {
    emulate -L zsh

    cmd="cd"
    project=$1

    for basedir ($PROJECT_PATHS); do
        if [[ -d "$basedir/$*" ]]; then
            $cmd "$basedir/$*"
            return
        fi
    done

    echo "No such project '$*'."
}

_pj () {
    emulate -L zsh

    typeset -a projects
    for basedir ($PROJECT_PATHS); do
        projects+=(${basedir}/*(/N))
    done

    compadd ${projects:t}
}
compdef _pj pj
