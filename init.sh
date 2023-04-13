FILES=(.zshrc .zshenv .config .tmux.conf .tigrc .vimrc .hammerspoon .p10k.zsh)
# 移動できたらリンクを実行する
for f in ${FILES[@]}; do
	ln -snfv ~/.dotfiles/$f $HOME/$f
	echo $f
done
