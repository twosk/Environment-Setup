#!/bin/bash
add_PS1() {
    # Define the block of text to add
    block_text=$(cat << 'EOF'
# Define the function to parse the Git branch and repository name
function parse_git_branch {
    git rev-parse --is-inside-work-tree &>/dev/null || return
    branch=$(git branch --show-current 2>/dev/null || echo "detached")
    repo=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
    echo "($repo:$branch)"
}

# Customize PS1
export PS1='\[\033[1;34m\]\u\[\033[0m\] \[\033[1;32m\]$(parse_git_branch)\[\033[0m\] \W \$ '
EOF
    )

    # Check if the block is already in .bashrc
    if ! grep -Fxq "# Customize PS1" ~/.bashrc; then
        echo -e "\n$block_text" >> ~/.bashrc
        echo "Block added to ~/.bashrc."
    else
        echo "Block already exists in ~/.bashrc."
    fi
}

add_aliases() {
    # Ensure .bash_aliases exists
    touch $HOME/.bash_aliases

    # Merge aliases if the local file exists
    if [ -f ./.bash_aliases ]; then
        grep -qFf ./.bash_aliases $HOME/.bash_aliases || cat ./.bash_aliases >> $HOME/.bash_aliases
    fi

    # Ensure .bashrc sources .bash_aliases
    grep -qxF "if [ -f ~/.bash_aliases ]; then" ~/.bashrc || echo -e "\nif [ -f ~/.bash_aliases ]; then\n    . ~/.bash_aliases\nfi" >> ~/.bashrc
}

case "$1" in
    PS1)
        add_PS1
        ;;
    aliases)
        add_aliases
        ;;

    *)
    	add_PS1
    	add_aliases
    ;;
    help|-?|?|--help|-h)
        echo "Usage: $0 {PS1|aliases}"
        exit 1
        ;;
esac
