git config --global alias.fix-commit 'commit --edit --file=.git/COMMIT_EDITMSG'
alias gbl="git branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate" # List branches with details
alias gl="git log --pretty=format:\"%C(magenta)%h%Creset -%C(red)%d%Creset %s %C(dim green)(%cr) [%an]\" --abbrev-commit -30 --show-signature" # Pretty Git log with signature
alias gca="git commit -a" # commit all
alias gcf="commit --edit --file=.git/COMMIT_EDITMSG" # Edit previous commit message
alias gcas="git commit -S -a" # commit all with signning
alias gbco="git checkout -b" # makes new branch and switches to it
alias gco="git checkout" # switches to branch
alias gbrm="git branch -D" # force deletes branch
alias gcundo="git reset HEAD~1 --mixed" # undoes last commit but keeps changes
alias gcrm="git reset --hard" # resets to last commit
alias ggg="git config --global --list" # get global config
alias gh="cat ~/.bash_aliases" # git alias help
