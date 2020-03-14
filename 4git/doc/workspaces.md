# `4git-workspace`

The command `4git-workspace` can be used to manipulate workspaces. But all the other 4git tools will interact with the workspace in some way.

A workspace is basically nothing but simple `git branch`, but it's what we make out of it. A workspace branch always has the following naming-scheme:

    4git/<base-branch>/<workspace-name>

* Every branch created by this tools starts with `4git/`. Afterwards we find the base branch enclosed in slashes. After the second slash (`/`), the workspace name follows.
* The base branch (`<base-branch>`, should be the branch you base all your
  work upon. This branch should be a local branch. The goal is to draft up all kinds of stuff in your workspace
  and commit often. During this 4git will never touch this branch. In the
  end you rebase/merge all stuff required into your base branch or create
  a pull request on-top of it.


### EXAMPLES

Create a 4git workspace

    4git-workspace myfeature-workspace

If you use tmux the command above will set the current window title to the given workspace name. Then all you need to do this run this command to create a work space:

    4git-workspace

But note it will use your current window title as the workspace name name.
