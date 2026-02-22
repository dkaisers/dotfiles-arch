#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIGS_DIR="$DOTFILES_DIR/configs"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Calculate target path from source path
get_target_path() {
    local source_path="$1"
    local relative_path="${source_path#$CONFIGS_DIR/}"
    echo "$HOME/$relative_path"
}

# Backup and create symlink
link_config() {
    local source_path="$1"
    local target_path
    target_path="$(get_target_path "$source_path")"
    local target_name="${target_path#$HOME/}"

    # Create target directory if needed
    local target_dir
    target_dir="$(dirname "$target_path")"
    if [[ ! -d "$target_dir" ]]; then
        log_info "Creating directory: $target_dir"
        mkdir -p "$target_dir"
    fi

    # Handle existing file/link
    if [[ -e "$target_path" ]] || [[ -L "$target_path" ]]; then
        if [[ -L "$target_path" ]]; then
            local current_link
            current_link="$(readlink "$target_path")"
            if [[ "$current_link" == "$source_path" ]]; then
                log_info "Already linked: $target_name"
                return 0
            else
                log_warn "Removing old symlink: $target_name"
                rm "$target_path"
            fi
        else
            log_warn "Backing up existing file: $target_name"
            mv "$target_path" "$target_path.backup.$(date +%Y%m%d_%H%M%S)"
        fi
    fi

    # Create symlink
    ln -s "$source_path" "$target_path"
    log_success "Linked: $target_name"
}

# Recursively find all files in configs directory
find_configs() {
    find "$CONFIGS_DIR" -type f -o -type l | sort
}

# Remove broken symlinks pointing to dotfiles
remove_broken_links() {
    log_info "Removing broken symlinks..."
    
    local count=0
    
    # Find symlinks in ~ and ~/.config that point to dotfiles
    while IFS= read -r link_path; do
        local link_target
        link_target="$(readlink "$link_path")"
        
        # Check if it points into dotfiles
        if [[ "$link_target" == "$DOTFILES_DIR"* ]]; then
            # Check if broken
            if [[ ! -e "$link_target" ]]; then
                log_warn "Removing broken symlink: ${link_path#$HOME/}"
                rm "$link_path"
                count=$((count + 1))
            fi
        fi
    done < <(find "$HOME" -maxdepth 1 -type l; find "$HOME/.config" -type l 2>/dev/null)
    
    if [[ $count -gt 0 ]]; then
        log_success "Removed $count broken symlink(s)"
    else
        log_info "No broken symlinks found"
    fi
}

# Main installation
main() {
    if [[ ! -d "$CONFIGS_DIR" ]]; then
        log_error "Configs directory not found: $CONFIGS_DIR"
        exit 1
    fi

    log_info "Installing dotfiles from $CONFIGS_DIR"
    log_info "Target home directory: $HOME"
    echo

    remove_broken_links
    echo

    local count=0
    local failed=0

    while IFS= read -r source_path; do
        if [[ -n "$source_path" ]]; then
            if link_config "$source_path"; then
                count=$((count + 1))
            else
                failed=$((failed + 1))
            fi
        fi
    done < <(find_configs)

    echo
    if [[ $failed -eq 0 ]]; then
        log_success "Installed $count config file(s) successfully!"
    else
        log_error "Installation completed with $failed error(s) ($count succeeded)"
        exit 1
    fi
}

main "$@"
