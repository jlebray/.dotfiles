# Path to your oh-my-zsh installation.
export ZSH=/Users/johan/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
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

PROJECT_PATHS=(~/Code)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(brew bundler gem git gitfast git-flow pj rails rake-fast rbenv sublime zsh-syntax-highlighting colorize osx thefuck)

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

PROMPT='${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[red]%}$(work_in_progress_prompt)%{$fg_bold[blue]%} % %{$fg_bold[yellow]%}$(rbenv_prompt_info) % %{$reset_color%}'

eval "$(rbenv init -)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
alias v='nvim'
alias vterm='nvim -c DefaultWorkspace'
alias gpl='git pull'
alias gps='git push'
alias gc='git commit'
alias gs='git status'
alias gd='git diff -w'
alias gco='git co'

alias dbm='rake db:migrate'
alias dbs='rake db:migrate:status'
alias dbr='rake db:rollback'
alias dbd='rake db:migrate:down'

alias paraspec='rake parallel:spec'

alias rs='rails server -b 0.0.0.0 -p 3000'

alias emacs='emacs'

function hstaging() {
  heroku run "$@" -a shopmium-staging
}

function htest() {
  heroku run "$@" -a shopmium-test
}

function hprod() {
  heroku run "$@" -a shopmium
}

function hdstaging() {
  heroku run:detached "$@" -a shopmium-staging
}

function hdtest() {
  heroku run:detached "$@" -a shopmium-test
}

function hdprod() {
  heroku run:detached "$@" -a shopmium
}

function rcstaging() {
  heroku run rails console -a shopmium-staging
}

function rctest() {
  heroku run rails console -a shopmium-test
}

function rcprod() {
  heroku run rails console -a shopmium
}

function cbr() {
  git_current_branch
}

function refresh() {
  local CURRENT=$(git_current_branch)
  gwip
  git checkout develop
  git pull
  git checkout master
  git pull
  git checkout $CURRENT
  gunwip
}

function fgps {
  git push --set-upstream origin $(git_current_branch)
}

# function fbr() {
#   local branches branch
#   branches=$(git branch -a) &&
#     branch=$(echo "$branches" | sed -E "s/.*((develop|master|remotes|origin|feature)[a-zA-Z0-9/-]*).*/\1/" | fzf +s +m -e) &&
#   git checkout $(echo "$branch" | sed "s:.* remotes/origin/::" | sed "s:.* ::")
# }

# fbr - checkout git branch
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fco - checkout git branch/tag
fco() {
  local tags branches target
  tags=$(
    git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
    git branch --all | grep -v HEAD             |
    sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
    sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
    (echo "$tags"; echo "$branches") |
    fzf-tmux -l30 -- --no-hscroll --ansi +m -d "\t" -n 2) || return
  git checkout $(echo "$target" | awk '{print $2}')
}

# fshow - git commit browser (enter for show, ctrl-d for diff, ctrl-r for reset, ` toggles sort)
fshow() {
  local out shas sha q k
  while out=$(
      git log --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr %C(red)%an" "$@" |
      fzf --ansi --multi --no-sort --reverse --query="$q" --tiebreak=index \
          --print-query --expect=ctrl-d,ctrl-r --toggle-sort=\`); do
    q=$(head -1 <<< "$out")
    k=$(head -2 <<< "$out" | tail -1)
    shas=$(sed '1,2d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
    [ -z "$shas" ] && continue
    if [ "$k" = 'ctrl-d' ]; then
      git diff --color=always $shas | less -R
    elif [ "$k" = 'ctrl-r' ]; then
      git reset $shas
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

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local file
  file=$(fzf-tmux --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

function prespec() {
  rake parallel:prepare
  rake parallel:spec
}

function replace_all() {
  ag -l "$1" | xargs perl -pi -E "s/$1/$2/g"
}

function pjson {
    if [ $# -gt 0 ];
        then
        for arg in $@
        do
            if [ -f $arg ];
                then
                less $arg | python -m json.tool
            else
                echo "$arg" | python -m json.tool
            fi
        done
    fi
}

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

#iterm2 shell
#source ~/.iterm2_shell_integration.`basename $SHELL`
