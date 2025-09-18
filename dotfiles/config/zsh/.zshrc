# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# prevent duplicates and omit additional checks in startup
# https://www.reddit.com/r/zsh/comments/1kjferw/comment/mrmghrt
typeset -gU PATH cdpath fpath path

# GENERAL settings
{%@@ if profile == "fedora" @@%}
path+=(
	$HOME/.nodenv/bin
	$HOME/.rbenv/bin
	$HOME/bin
	$HOME/.deno/bin
	$path
)
{%@@ elif profile == "mac" @@%}
path+=(
	/opt/homebrew/bin
	/opt/homebrew/sbin
	/usr/local/bin
	/usr/bin
	/bin
	/usr/sbin
	/sbin
	$HOME/.local/bin
	$path[@]
)
fpath+=(
  /usr/share/zsh/site-functions
  /opt/homebrew/share/zsh/site-functions
  /usr/local/share/zsh/site-functions
  /usr/share/zsh/"${ZSH_VERSION}"/functions
)
export HOMEBREW_PREFIX="/usr/local";
export HOMEBREW_CELLAR="/usr/local/Cellar";
export HOMEBREW_REPOSITORY="/usr/local/Homebrew";
[ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
export INFOPATH="/usr/local/share/info:${INFOPATH:-}";
{%@@ endif @@%}
export PATH="$HOME/.nodenv/shims:${PATH}"
export EDITOR=nvim
export VISUAL=nvim
export LC_ALL=pt_BR.UTF-8
export LANG=pt_BR.UTF-8
# FZF Settings
export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix --hidden"
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
	--highlight-line \
	--info=inline-right \
	--ansi \
	--layout=reverse \
	--border=none \
	--color=bg+:#283457 \
	--color=bg:#16161e \
	--color=border:#27a1b9 \
	--color=fg:#c0caf5 \
	--color=gutter:#16161e \
	--color=header:#ff9e64 \
	--color=hl+:#2ac3de \
	--color=hl:#2ac3de \
	--color=info:#545c7e \
	--color=marker:#ff007c \
	--color=pointer:#ff007c \
	--color=prompt:#2ac3de \
	--color=query:#c0caf5:regular \
	--color=scrollbar:#27a1b9 \
	--color=separator:#ff9e64 \
	--color=spinner:#ff007c \
"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --strip-cwd-prefix --hidden --type d"
export FZF_CTRL_T_OPTS="
	--preview 'bat -n --color=always {}'
	--bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_CTRL_R_OPTS="
	--preview 'echo {}' --preview-window up:3:hidden:wrap
	--bind 'ctrl-/:toggle-preview'
	--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
	--color header:italic
	--header 'Press CTRL-Y to copy command into clipboard'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
# EXPORTS DIRs
export DOTREPO="$HOME/dotfiles"
export Work="$HOME/Work"
# HISTORY Settings
HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=1000000
HISTTIMEFORMAT="[%F %T]"
SAVEHIST=$HISTSIZE
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt AUTOCD
setopt DOT_GLOB
setopt EXTENDED_GLOB

[[ -f $ZDOTDIR/config/.zsh_aliases ]] && source $ZDOTDIR/config/.zsh_aliases
{%@@ if profile == "fedora" @@%}
[[ -f $ZDOTDIR/config/.zsh_bindings ]] && source $ZDOTDIR/config/.zsh_bindings
{%@@ endif @@%}

# Carrega as funções
fpath+=(
	"$ZDOTDIR/functions"
	"${fpath[@]}"
	)

zcompile -z "$ZDOTDIR/.functions.zwc" \
"$ZDOTDIR/functions/f_load_plugins" \
"$ZDOTDIR/functions/f_update_plugins"
autoload -wUz "$ZDOTDIR/.functions.zwc"

f_load_plugins

[[ -f $ZDOTDIR/config/.zsh_completions ]] && source $ZDOTDIR/config/.zsh_completions
[[ -f $ZDOTDIR/config/.zsh_plugins ]] && source $ZDOTDIR/config/.zsh_plugins

# source $ZDOTDIR/functions/f_init_completions
# f_compile_plugins
