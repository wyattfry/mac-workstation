#!/usr/bin/env bash
set -euo pipefail

pkgs=(
  azure-cli
  colima
  discord
  docker
  docker-buildx
  docker-compose
  font-meslo-for-powerlevel10k
  fzf
  graphviz
  go
  gh
  jetbrains-toolbox
  nikitabobko/tap/aerospace
  powerlevel10k
  tfenv
  visual-studio-code
  zsh-autosuggestions
  zsh-syntax-highlighting
)

function install_ohmyzsh() {
  if [[ ! -d ~/.oh-my-zsh ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    echo '[✓] oh-my-zsh'
  fi
}

function source_pl10k() {
  if grep powerlevel ~/.zshrc &>/dev/null; then
    echo '[✓] sourcing powerlevel10k theme'
  else
    echo 'source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
  fi

}

function enable_brew_autoupdate() {
  if brew autoupdate status 2>&1 | grep 'Autoupdate is installed and running.' &>/dev/null; then
    echo "[✓] brew autoupdate"
  else
    brew autoupdate start
  fi
}

function install_homebrew() {
  if which brew &> /dev/null; then
    echo '[✓] homebrew' 
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

function install_taps() {
	tapped="$(brew tap)"

	taps=(
	  domt4/autoupdate
	)

	for t in "${taps[@]}"; do
	  if echo "${tapped[@]}" | grep -qw "$t"; then
	    echo "[✓] tap: $t"
	  else
	    brew tap "$t" &> /dev/null
	  fi
	done
}

function install_brews() {
	installed="$(brew list)"

	for p in "${pkgs[@]}"; do
	  if ! echo "${installed[@]}" | grep -qw "$p"; then
      printf "[ ] brew: Installing %s...\r" "$p"
	    brew install "$p" &> /dev/null
	  fi
	  echo "[✓] brew: $p                      "
	done
}

function ensure_line_in_file() {
  local line="$1"
  local file="$2"
  if grep -qF "$line" "$file"; then
    echo "[✓] $line"
  else
    echo "$line" >> "$file"
  fi
}

install_homebrew
install_ohmyzsh
enable_brew_autoupdate
install_taps
install_brews
source_pl10k
ensure_line_in_file 'source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' ~/.zshrc
ensure_line_in_file 'source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh' ~/.zshrc
