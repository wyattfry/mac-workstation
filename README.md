# Workstation Configurer

This script will set up a macOS machine with packages and settings commonly used in for a developer workflow.

Some of the things it does:

* Install homebrew
* Install oh-my-zsh
* Enable auto updates for homebrew
* Install many packages via homebrew (see `packages` array in the script)

The operations all check whether they have already been performed before executing for increased efficiency.

## Usage

```sh
# Install and configure everything
wsconf
[ ] Installing package xyz...

# Add a package to the list and then install
wsconf add jq
[ ] Installing jq...
```