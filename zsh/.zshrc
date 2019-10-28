# Path to your oh-my-zsh installation.
export ZSH=/home/johan/.oh-my-zsh
export EDITOR=`which nvim`
export VISUAL="nvim"
export PKG_CONFIG_PATH=/usr/local/opt/openssl/lib/pkgconfig
export LANG="en_US"
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export ANDROID_HOME=/home/johan/Android/Sdk
export JAVA_HOME=/usr/lib/jvm/oracle-java8-jdk-amd64

export FZF_DEFAULT_COMMAND="rg --files --hidden"

xcape -e 'Control_L=Escape'

TIMEFMT='%J   %U  user %S system %P cpu %*E total'$'\n'\
'avg shared (code):         %X KB'$'\n'\
'avg unshared (data/stack): %D KB'$'\n'\
'total (sum):               %K KB'$'\n'\
'max memory:                %M MB'$'\n'\
'page faults from disk:     %F'$'\n'\
'other page faults:         %R'

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="yyyy/mm/dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

PROJECT_PATHS=(~/code)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git gitfast git-flow pj colorize zsh-lazyload)

# User configuration

# export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
function work_in_progress_prompt() {
  if $(git log -n 1 2>/dev/null | grep -q -c "\-\-wip\-\-"); then
    echo " | WIP!!"
  fi
}

PROMPT='%{$fg_bold[cyan]%}%c %{$fg_bold[green]%}$(git_prompt_info)${ret_status}%{$fg_bold[green]%}%p%{$fg_bold[red]%}$(work_in_progress_prompt)%{$fg_bold[blue]%} %{$reset_color%}
%{$fg[cyan]%}➜%{$reset_color%} '

eval "$(rbenv init -)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias v='nvim'
alias gpl='git pull'
alias gps='git push'
alias gc='git commit'
alias gs='git status --short'
alias gd='git diff -w'
alias gco='git co'

alias dbm='rake db:migrate'
alias dbs='rake db:migrate:status'
alias dbr='rake db:rollback'

alias rgm='rails generate migration'

alias fzf='fzf --height 80%'

alias rs='rails server -p 4200 -e development'
alias rc='rails console'

# pbcopy on Linux
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

function htail() {
  read input

  tail=$(grep 'Run heroku logs' <<< $input | sed -E 's:Run (.*) to view.*:\1 --tail:')
  echo "Running \`$tail\`..."

  eval $tail
}

function hstaging() {
  heroku run "$@" -a shopmium-staging
}

function htest() {
  heroku run "$@" -a shopmium-sandbox
}

function hprod() {
  heroku run "$@" -a shopmium
}

function hdstaging() {
  heroku run:detached "$@" -a shopmium-staging | htail
}

function hdtest() {
  heroku run:detached "$@" -a shopmium-sandbox | htail
}

function hdprod() {
  heroku run:detached "$@" -a shopmium | htail
}

function rcstaging() {
  heroku run rails console -a shopmium-staging
}

function rctest() {
  heroku run rails console -a shopmium-sandbox
}

function rcprod() {
  heroku run rails console -a shopmium
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

function start_rails() {
  rails s -d -p 4100
}

function stop_rails() {
  kill -9 $(lsof -i :4100 -t)
}

function restart_rails() {
  stop_rails && start_rails
}

#iterm2 shell
# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
#source ~/.iterm2_shell_integration.`basename $SHELL`

# # The next line updates PATH for the Google Cloud SDK.
  # if [ -f '/Users/johan/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/johan/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# # The next line enables shell command completion for gcloud.
  # if [ -f '/Users/johan/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/johan/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

function load:nvm() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh --no-use"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}
lazyload load:nvm nvm
