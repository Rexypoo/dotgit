#!/usr/bin/env sh

repo_path="${1:-.config/dotgit}"

# Ensure dotgit path exists
mkdir -p "$HOME/$repo_path"

# Create persistent dotgit alias in .bashrc
echo >> "$HOME"/.bashrc
echo alias .git=\'git --git-dir=\"\$HOME\"/"$repo_path" --work-tree=\"\$HOME\"\' >> "$HOME"/.bashrc
alias .git='git --git-dir="$HOME"/'$repo_path' --work-tree="$HOME"'

# Initialize the repo
.git init

# Don't warn about every single file
.git config --local status.showUntrackedFiles no

# Exclude secrets
echo >> "$HOME"/"$repo_path"/info/exclude
echo "# Don't index secrets" >> "$HOME"/"$repo_path"/info/exclude
echo "*.key" >> "$HOME"/"$repo_path"/info/exclude
echo "*.p12" >> "$HOME"/"$repo_path"/info/exclude
echo "*.pem" >> "$HOME"/"$repo_path"/info/exclude
echo "id_dsa" >> "$HOME"/"$repo_path"/info/exclude
echo "id_ecdsa" >> "$HOME"/"$repo_path"/info/exclude
echo "id_ed25519" >> "$HOME"/"$repo_path"/info/exclude
echo "id_rsa" >> "$HOME"/"$repo_path"/info/exclude
