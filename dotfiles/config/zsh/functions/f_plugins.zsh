#!/usr/bin/env zsh

# Compile multiple files
zcompile-many() {
	local f
	for f; do
		[[ -r $f ]] || continue
		zcompile -R "$f" 2>/dev/null 
	done
}

# Calculate checkmsum for compiling files
checksum() {
	local plugin_dir="$1"
	find "$plugin_dir" -type f \( -name '*.zsh' -o -name '*.ch' \) -print0 | \
		sort -z | xargs -0 sha1sum | sha1sum | awk '{print $1}'
}

# Plugin list and repo
typeset -A PLUGINS
PLUGINS=(
	fzf-tab						https://github.com/Aloxaf/fzf-tab.git
	fast-syntax-highlighting	https://github.com/zdharma-continuum/fast-syntax-highlighting.git
	zsh-autosuggestions			https://github.com/zsh-users/zsh-autosuggestions.git
	powerlevel10k				https://github.com/romkatv/powerlevel10k.git
)

f_plugins() {
	# Create plugin folder and doesn't return error if exists
	mkdir -p "$ZDOTDIR/plugins"
	local plugin repo dir
	# loops throught defined plugins and set it's directory
	for plugin repo in ${(kv)PLUGINS}; do
		dir="$ZDOTDIR/plugins/$plugin"
		checksum_file="$dir/.checksum"

		# check if folder exist
		if [[ -d $dir ]]; then
			# check if folder is git managed
			if [[ -d $dir/.git ]]; then
				if git -C "$dir" pull --ff-only &>/dev/null; then
					zlog OK "$plugin atualizado."
				else
					zlog WARN "Falha ao atualizar o $plugin."
				fi
			else
				zlog WARN "$dir existe, mas não é um git repo. Pulando..."
				continue
			fi
		else
			zlog INFO "Clonando $plugin..."
			git clone --depth=1 "$repo" "$dir" || \
				{ zlog ERR "Falha ao clonar $plugin"; continue; }
		fi

		new_checksum=$(checksum "$dir")
		old_checksum=""
		[[ -f $checksum_file ]] && old_checksum=$(<"$checksum_file")
		if [[ $new_checksum != $old_checksum ]]; then
			zlog INFO "Conteúdo alterado em $plugin, compilando..."
			# Options for compiling per plugin
			case "$plugin" in
				fzf-tab)
					zcompile-many "$dir/fzf-tab.plugin.zsh"
					;;
				fast-syntax-highlighting)
					[[ -d $dir/→chroma ]] && mv "$dir/→chroma" "$dir/tmp"
					zcompile-many $dir/{fast*,.fast*,**/*.ch,**/*.zsh(N)}
					[[ -d $dir/tmp ]] && mv "$dir/tmp" "$dir/→chroma"
					;;
				zsh-autosuggestions)
					zcompile-many $dir/{zsh-autosuggestions.zsh,src/**/*.zsh(N)}
					;;
				powerlevel10k)
					make -C "$dir" pkg || \
						zlog WARN "Falha no make do powerlevel10k"
					;;
			esac
			echo "$new_checksum" >| "$checksum_file"
			zlog OK "$plugin compilado e checksum atualizado."
		else
		fi
	done
}
