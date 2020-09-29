# Customize to your needs...
function htail() {
  read input

  tail=$(grep 'Run heroku logs' <<< $input | sed -E 's:Run (.*) to view.*:\1 --tail:')
  echo "Running \`$tail\`..."

  eval $tail
}

function hstaging() {
  heroku run "$@" -a jeancaisse-staging
}

function hprod() {
  heroku run "$@" -a jeancaisse-prod
}

function hdstaging() {
  heroku run:detached "$@" -a jeancaisse-staging | htail
}

function hdprod() {
  heroku run:detached "$@" -a jeancaisse-prod | htail
}

function rcstaging() {
  heroku run rails console -a jeancaisse-staging
}

function rcprod() {
  heroku run rails console -a jeancaisse-prod
}

function gar() {
  ag -l -G "$1" | xargs git add
}

function refresh() {
  local CURRENT=$(git_current_branch)
  if [ "$CURRENT" = 'develop' ]; then
    git pull && git checkout master && git pull && git checkout develop
  elif [ "$CURRENT" = 'master' ]; then
    git pull && git checkout develop && git pull && git checkout master
  else
    gwip
    git checkout develop && git pull &&
      git checkout master && git pull &&
      git checkout $CURRENT && gunwip
  fi
}

function fgps {
  git push --set-upstream origin $(git_current_branch)
}

# fco - checkout git branch/tag
fco() {
  git checkout $(select_branch_or_tag)
}

# fgm - git merge
fgm() {
  git checkout $(select_branch_or_tag)
}

# helper to select branch
select_branch_or_tag() {
  local tags branches target

  tags=$(
    git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
    git branch --all | grep -v HEAD             |
    sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
    sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
    (echo "$tags"; echo "$branches") |
    fzf-tmux -l30 -- --no-hscroll --ansi +m -d "\t" -n 2 $argv) || return

  echo "$target" | awk '{print $2}'
}

# fshow - git commit browser (enter for show, ctrl-d for diff, ctrl-r for reset, ` toggles sort)
fshow() {
  local out shas sha q k
  while out=$(
      git log --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr %C(red)%an" "$@" |
      fzf --ansi --multi --no-sort --reverse --query="$q" --tiebreak=index \
          --print-query --expect=ctrl-d,ctrl-r,ctrl-o --toggle-sort=\`); do
    q=$(head -1 <<< "$out")
    k=$(head -2 <<< "$out" | tail -1)
    shas=$(sed '1,2d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
    [ -z "$shas" ] && continue
    if [ "$k" = 'ctrl-d' ]; then
      git diff --color=always $shas | less -R
    elif [ "$k" = 'ctrl-r' ]; then
      git reset $shas
    elif [ "$k" = 'ctrl-o' ]; then
      git checkout $shas
    else
      for sha in $shas; do
        git show --color=always $sha | less -R
      done
    fi
  done
}

# ftags - search ctags
ftags() {
  local line
  [ -e tags ] &&
  line=$(
    awk 'BEGIN { FS="\t" } !/^!/ {print toupper($4)"\t"$1"\t"$2"\t"$3}' tags |
    cut -c1-80 | fzf --nth=1,2
  ) && $EDITOR $(cut -f3 <<< "$line") -c "set nocst" \
                                      -c "silent tag $(cut -f2 <<< "$line")"
}

# fe - fuzzy file edit
fe() {
  local file
  file=$(fzf --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && ${EDITOR:-nvim} "$file"
}

git_cleanup() {
  git fetch -p && git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D
}

function git_reviews() {
  hub pr list -f "%pC%>(8)%i   %au %Creset%t  %l  %U%n" --color=always | grep -v 'jlebray' | rg 'review level' --color never
}

function prespec() {
  rake parallel:prepare
  rake parallel:spec
}

function start_release() {
  local number current res

  if [ -z "$1" ]
  then
    number="$(date +'%Y.%m.%d')"
    i=2
  else
    current=$1
    number="$(date +'%Y.%m.%d-')$current"
    i=$((current+1))
  fi

  git flow release start $number
  res=$?

  if [ $res -eq 1 ]; then
    start_release $i
  fi
}

function finish_release() {
  local branch=$(git branch | grep "release/" | sed "s:.*/::")

  refresh
  git flow release finish $branch
}

function push_prod () {
  local CURRENT=$(git_current_branch)

  if [ "$CURRENT" = 'master' ]; then
    gps && gps --tags && git push production master:master
  else
    echo "You are not on master"
  fi
}

function dbd() {
  rake db:migrate:down VERSION=$1
}

function revert_migrations() {
  local CURRENT=$(git_current_branch)

  echo "Calculating current structure"
  local new=($(dbs | grep -E "\d{14}" | sed -E "s/[^0-9]*([0-9]+).*/\1/"))

  echo "Calculating develop structure"
  local old=($(git show develop:db/structure.sql | grep -E "INTO schema" | sed -E "s/[^0-9]*([0-9]+).*/\1/"))

  local changes=($(echo ${new[@]} ${old[@]} | tr ' ' '\n' | sort | uniq -u))
  local changes=($(echo ${(Oa)changes}))

  for version in $changes; do
    echo "===== Reverting $version ====="
    env VERSION="$version" rake db:migrate:down
  done
}

function fix_spring() {
  spring stop
  rake db:test:prepare
  spring stop
}

function replace_all() {
  local from=$1
  local to=$2

  rg -l "$from" | xargs -0 perl -pi -e "s/$from/$to/g"
}

function start_elastic() {
  (sudo sysctl -w vm.max_map_count=262144) && docker start d0
}

function stop_elastic() {
  docker stop d0
}

function start_rails() {
  rails s -d -p 4100
}

function stop_rails() {
  kill -9 $(lsof -i :4100 -t)
}

function restart_rails() {
  stop_rails && start_rails
}

function prompt_ruby_version() {
  local ex=$(rbenv local 2> /dev/null)
  if [ ! -z "$ex" ]
  then
    echo "%{$fg_bold[red]%}💎 $(rbenv version-name)"
  fi
}

function prompt_python_version() {
  local ex=$(pyenv local 2> /dev/null)
  if [ ! $ex = 'system' ]
  then
    echo "%{$fg_bold[green]%}🐍 $(pyenv version-name)"
  fi
}

# function load:nvm() {
#   export NVM_DIR="$HOME/.nvm"
#   [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
#   [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash completion
# }

# lazyload load:nvm nvm
