#!/bin/bash

add_PS1() {
    # Check if Git is installed
    if ! command -v git &>/dev/null; then
        echo "Error: Git is not installed. Skipping PS1 customization."
        return
    fi

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
        # Find unique lines from ./.bash_aliases not in $HOME/.bash_aliases
        new_aliases=$(comm -23 <(sort ./.bash_aliases | uniq) <(sort $HOME/.bash_aliases | uniq))
        
        # Check if there are any new aliases to append
        if [ -n "$new_aliases" ]; then
            echo "$new_aliases" >> $HOME/.bash_aliases
            echo "New aliases from ./.bash_aliases added to $HOME/.bash_aliases."
        else
            echo "No new aliases to add from ./.bash_aliases."
        fi
    else
        echo "No ./.bash_aliases file found. Skipping alias merge."
    fi

    # Ensure .bashrc sources .bash_aliases
    if ! grep -qxF "if [ -f ~/.bash_aliases ]; then" ~/.bashrc; then
        echo -e "\nif [ -f ~/.bash_aliases ]; then\n    . ~/.bash_aliases\nfi" >> ~/.bashrc
        echo ".bashrc updated to source .bash_aliases."
    else
        echo ".bashrc already sources .bash_aliases."
    fi
}


print_help() {
    echo "Usage: $0 {PS1|aliases|help}"
    echo "Options:"
    echo "  PS1      Add custom PS1 prompt to .bashrc"
    echo "  aliases  Merge aliases into ~/.bash_aliases and update .bashrc"
    echo "  help     Display this help message"
    echo "Run without arguments to execute both 'PS1' and 'aliases'."
}

case "$1" in
    PS1)
        add_PS1
        ;;
    aliases)
        add_aliases
        ;;
    help|-?|?|--help|-h)
        print_help
        ;;
    *)
        add_PS1
        add_aliases
        ;;
esac
