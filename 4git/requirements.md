# 4git: Requirements / Idea Sheet

This is not implemented in any way, I just wanted to write down my thoughts about a tool I've had for a long time.

I often forget to commit and my git worktree piles up a lot of garbage files in the untracked section. Then I have the problem that I often cannot use `git add --patch` easily to separate the changes out. Additionally when changes in my git worktree linger there for a long time, I might forget why I made them

*Why the Name?*: 4git or "four git" sounds similar to forget. I wrote this tool to help me keep track of things when working with git.

## Functions

* Integration Into Tmux & Vim & Git
* On every branch you can commit separate changes with the use of `git add -p`
  * You can choose the branch to commit to dynamically with something like fzf
  * Of course fix up commits for quick edits are great, because you can then save it up for later
  * Tag commits automatically with some logic for different repos
  * Support fixup commits.
    * Advanced: Maybe integrate this with when saving from withing vim with vim-fugitive???
* Basically it's a big stash heap, but with actual commits and branches with some notes
* You should be able to list out the different work branches, and switch them quickly
* The goal is to have separate places to be able to commits to
  * so you can make notes during development and commit more often
  * use parts change parts
  * fix parts up etc.
* Rebase and merge separate branches together to push later on
* Make use of interactively rebasing when merging branches, also support fixup commit with --autosquash
  * This should allow you to create more meaning full commit messages from your notes taken from the little commits
* Integration into automatically running tests after rebasing, this might be error prone...

## Quality

* it should work reliably
* it should be a fast user interface
* have good keybindings
* display status information so the user better knows what's going on


## Design

* Idea 1:
  * Every tmux window holds one base upstream branch most of the time
    * The name of the tmux window
    * All the branches created from within this tmux window are based upon the branch of the tmux window.
    * Let's assume we want to have most of the panes in a tmux window are in the same directory
    * Use existing `tmux-branch` tool
      * It creates a git branch based on the name of the tmux window
  * *Maybe* every branch should have separate git workspaces in a separate directory
* Idea 2: Always force to commit, but do it UX friendly
  * Automatically create commits from vim when saving
    * When normally saving create fixup commits with the changes done to the file (on the same branch?)
      * Warning: a vim buffer may not be backed by a file (Quickfixlist... etc.)
    * When using a "commit-save" function then a note can be taken for the commit
  * What about other files?


## Possible complications

* Stashing will have to be handled properly
  * Or avoid it entirely by committing everything to temporary branches
* As well as rebasing
* and merge conflicts due to both
* This might just move the problems so I have a lot of branches
  * changing branches might not be easy
  * it might also not be clear which branch changes made in vim are based upon
* Switchting branches might be difficult due to untracked changes that conflict
* tmux shows you the correct branch and working directory
    * for the zsh terminals in it as well
* you don't accidentally edit the wrong file in vim (old buffer)
* you might have to fetch from upstream and rebase all the branches at once...

## Utilities

* branch creator
  * create a branch based upon a given upstream brancha (how do we know)
  * maybe integrate it with renaming a tmux window
* branch tree listing and selection
  * will list all the commit bucket branches based upton the upstream branch of the tmux window and will let you select one or more of them
  * this tool will be used by other utilities
  * maybe use fzf
  * add option to show the commit patches as well
* branch switcher
  * you will have to change branches often this way I guess so to edit other stuff
* branch cleanup
  * you should be able to select commits and delete them
* cherry picker
  * I can imagine I'd want to move commits from one branch to the other
  * use the `fzf-commit` for for this
* vim save integration
  * makes fixup commits onto a temporary branch the based on the last place you commited too
  * easy save and commit to a branch you can select and immediately switch to (hopefully, or else cherry-pick the commit over from the temporary fixup commit branch?)
* rebaser
  * should provide a commit listing of the current branch
  * so you can delete commits fast
  * should help you rebasing multiple branches ontop of each other
  * and that ontop of upstream
    * it should never ever directly act on-top upstream and rebase it accidentally!
  * should support interactive and squashing commit rebasing
* fetcher and workspace forwarder
  * a little tool which fetches git remotes
  * I want to always be able to *fast-forward* our base branch to our master branch
* merge & pull request tool
  * the workspace branches need to be merged against master
  * this can either happen locally if it's a single person project
  * or you should be able to automatically create a pull request for example on GitHub (which I use most) and push the workspace branch to your fork.

## Configuration

This is the base branch you work off. This is a **local branch** which you manually update and maintain, just that all the stuff this tool does is based upon this branch.

    UPSTREAM_BASE_BRANCH=master

* Configure it where?
* Maybe extract it from the tmux window title?
* Maybe name of a git worktree directory?

