# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

autoload -Uz colors && colors
zstyle ":completion:*:commands" rehash 1
# 小文字でも大文字ディレクトリ、ファイルを補完できるようにする
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

export PATH=/Users/keimoriyama/Documents/hogeticlab/collectro/:$PATH
export GITHUB_USER=keimoriyama
export GITHUB_ACCESS_TOKEN=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

export PYENV_ROOT="$HOME/.pyenv"
export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include"

export PKG_CONFIG_PATH="/opt/homebrew/opt/libpq/lib/pkgconfig"

export PATH=$HOME/.pyenv/bin:$PATH
export PATH=/opt/homebrew/opt/llvm/bin:$PATH
export PATH=/Users/keimoriyama/.local/bin:$PATH

setopt no_beep

alias g='git'
alias ga='git add'
alias gd='git diff'
alias gs='git status'
alias gp='git push'
alias gpo='git push origin'
alias gb='git branch'
alias gst='git status'
alias gco='git checkout'
alias gf='git fetch'
alias gc='git commit'

alias ls='ls -G'
alias c='clear'

alias vim='nvim'

chpwd() {
	if [[ $(pwd) != $HOME ]]; then;
		ls
	fi
}
# コマンド補完についての設定
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
setopt correct

if type brew &>/dev/null; then
	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
	source $(brew --prefix)/opt/zsh-git-prompt/zshrc.sh
	source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	source $(brew --prefix)/opt/z/etc/profile.d/z.sh
	autoload -Uz compinit
	compinit
fi
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

eval "$(pyenv init --path)" # これを追記
eval "$(pyenv init -)"

