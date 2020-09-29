export PATH="$HOME/.rbenv/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export NVM_DIR="$HOME/.nvm"

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
# bindkey "$terminfo[kcuu1]" up-line-or-beginning-search # Up
# bindkey "$terminfo[kcud1]" down-line-or-beginning-search # Down
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

eval "$(rbenv init -)"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

# Load nvm before modules because it breaks defined completions...
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash completion

for file in ~/.zsh_modules/*; do
  source "$file"
done

# prompt
autoload -U colors && colors
setopt PROMPT_SUBST
PROMPT='%{$fg_bold[cyan]%}%c %{$fg_bold[green]%}$(git_prompt_info)${ret_status}%{$fg_bold[green]%}%p%{$fg_bold[red]%}$(work_in_progress_prompt)%{$fg_bold[blue]%} $(prompt_ruby_version)$(prompt_python_version) %{$reset_color%}
%n@%m%{$fg[cyan]%}$%{$reset_color%} '

nvm use 14

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/johan/.sdkman"
[[ -s "/Users/johan/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/johan/.sdkman/bin/sdkman-init.sh"
