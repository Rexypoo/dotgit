# dotgit (`.git`)

`.git` is a special handler for git configuration management of the configuration dotfiles in a *nix user's home directory. `.git` is a wrapper for git that only applies to directories under the user's `$HOME` directory and keeps a separate context such that the user may use git normally in subfolders of `$HOME`.

## Prerequisites

Bash

Git

## Installation

Make the configuration script executable, run the configuration script to initialize an empty, bare git repository, and then source `$HOME/.bashrc` to make the alias immediately available

```shell
chmod u+x configure_dotgit.sh
./configure_dotgit.sh
. ~/.bashrc
```

The repository is configured to ignore untracked files by default.

## Usage

Whenever you make a change in your home directory that you want to track you can add and/or commit it as you normally would with git, using the `.git` alias that was installed to `$HOME/.bashrc`.

```shell
$ # Let's add a shorter alias for .git!
$ echo 'alias .g='"'"'git --git-dir="$HOME"/.config/dotgit --work-tree="$HOME"'"'" >> "$HOME"/.bashrc
$ .git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   .bashrc

no changes added to commit (use "git add" and/or "git commit -a")
$ .git add .bashrc
$ .git status
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   .bashrc

Untracked files not listed (use -u option to show untracked files)
$ .git commit -m 'Added shorter alias for .git'
[master 16d4fd1] Added shorter alias for .git
 1 file changed, 1 insertion(+)
```

## Other features

By default `.git` will attempt to exclude files likely to contain cryptographic keys, including ssh keys using the standard naming conventions.

If you wish to commit cryptographic keys you may need to modify the entries at `$HOME/.config/dotgit/info/exclude`.

## Why `.git`?

I got the idea from [an atlassian tutorial](https://www.atlassian.com/git/tutorials/dotfiles). I found it appealing because you can hide the cruft of a git directory and avoid potential git conflicts with downstream folders (e.g. if I track source code under `~/src`, I'm less likely to accidentally commit code to the dotfile git). I prefer to keep configuration information under `$HOME/.config`, and wanted an alias that was easier to remember, so `.git` was born.

Feel free to customize it to your needs.

## License
This project is subject to the MIT license included in this repository.