#!/usr/bin/env bash


tapped="$(brew tap)"

taps=(
  domt4/autoupdate
)

for t in ${taps[@]}; do
  if echo "${tapped[@]}" | grep -qw "$t"; then
    echo "$t already tapped"
  else
    brew tap $t
  fi
done

installed="$(brew list)"

pkgs=(
  colima
  docker
  docker-buildx
  docker-compose
  jetbrains-toolbox
  visual-studio-code
)

for p in ${pkgs[@]}; do
  if echo "${installed[@]}" | grep -qw "$p"; then
    echo "$p already installed"
  else
    brew install $p
  fi
done

# brew autoupdate start
