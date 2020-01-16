# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "$terminfo[kcuu1]" up-line-or-beginning-search # Up
bindkey "$terminfo[kcud1]" down-line-or-beginning-search # Down

eval "$(rbenv init -)"
eval "$(pyenv init -)"

for file in ~/.zsh_modules/*; do
  source "$file"
done

# prompt
autoload -U colors && colors
setopt PROMPT_SUBST
PROMPT='%{$fg_bold[cyan]%}%c %{$fg_bold[green]%}$(git_prompt_info)${ret_status}%{$fg_bold[green]%}%p%{$fg_bold[red]%}$(work_in_progress_prompt)%{$fg_bold[blue]%} $(prompt_ruby_version)$(prompt_python_version) %{$reset_color%}
%n@%m%{$fg[cyan]%}$%{$reset_color%} '
