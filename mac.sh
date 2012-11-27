#!/usr/bin/env bash

guard() {
	$* || (echo failed 1>&2 && exit 1)
}

echo "Creating SSH key if needed ..."
	[[ -f ~/.ssh/id_rsa.pub ]] || ssh-keygen -t rsa

echo "Copying public key to clipboard ..."
	[[ -f ~/.ssh/id_rsa.pub ]] && cat ~/.ssh/id_rsa.pub | pbcopy

echo "Opening GitHub ..."
	guard open https://github.com/account/ssh

echo "Fixing permissions ..."
	guard sudo chown -R $(whoami) /usr/local

echo "Installing Homebrew ..."
	guard ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
	guard brew doctor
	guard brew update

echo "Installing tools ..."
	guard brew install autoconf
	guard brew install automake
	guard brew install ack
	guard brew install git
	guard brew install node
	guard brew install tmux
	guard brew install tree

echo "Cloning dotfiles ..."
	guard git clone git://github.com/shannonmoeller/dotfiles.git dotfiles
	guard git clone git://github.com/gmarik/vundle.git dotfiles/.vim/bundle/vundle
	guard git clone git://github.com/zsh-users/zsh-syntax-highlighting.git dotfiles/.zsh/bundle/zsh-syntax-highlighting

echo "Installing dotfiles ..."
	guard ln -s dotfiles/.zshrc ~/.zshrc
	guard source ~/.zshrc
	guard vim +BundleInstall +qall

echo "Done."
