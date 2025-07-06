#!/usr/bin/env bash

# Safe NixOS rebuild script for VMs
# This script helps prevent system freezes during builds

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
FLAKE_PATH="/home/jon/Dev/nixy"
HOST="nixvm"
MIN_FREE_MEMORY=500000  # 500MB in KB
MIN_FREE_DISK=2000000   # 2GB in KB

log() {
    echo -e "${BLUE}[$(date '+%H:%M:%S')]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

check_resources() {
    log "Checking system resources..."
    
    # Check available memory
    local free_mem=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
    if [ "$free_mem" -lt "$MIN_FREE_MEMORY" ]; then
        warn "Low memory detected: $(($free_mem / 1024))MB available"
        warn "Consider freeing up memory or adding more swap"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        success "Memory check passed: $(($free_mem / 1024))MB available"
    fi
    
    # Check available disk space
    local free_disk=$(df / | awk 'NR==2 {print $4}')
    if [ "$free_disk" -lt "$MIN_FREE_DISK" ]; then
        warn "Low disk space detected: $(($free_disk / 1024))MB available"
        warn "Consider cleaning up or expanding disk"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        success "Disk space check passed: $(($free_disk / 1024))MB available"
    fi
}

cleanup_before_build() {
    log "Cleaning up before build..."
    
    # Clear systemd journal
    sudo journalctl --vacuum-time=1d
    
    # Clean nix store
    nix-collect-garbage -d
    
    # Clear tmp
    sudo rm -rf /tmp/* 2>/dev/null || true
    
    success "Cleanup completed"
}

monitor_build() {
    local build_pid=$1
    local log_file="/tmp/nixos-build.log"
    
    log "Monitoring build process (PID: $build_pid)"
    log "Build log: $log_file"
    
    # Monitor in background
    (
        while kill -0 $build_pid 2>/dev/null; do
            # Check memory every 30 seconds
            local mem_available=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
            local mem_mb=$(($mem_available / 1024))
            
            if [ "$mem_available" -lt 100000 ]; then  # Less than 100MB
                warn "Critical memory low: ${mem_mb}MB available"
                warn "Consider killing the build to prevent system freeze"
            elif [ "$mem_available" -lt 200000 ]; then  # Less than 200MB
                warn "Memory getting low: ${mem_mb}MB available"
            fi
            
            sleep 30
        done
    ) &
    
    # Wait for build to complete
    wait $build_pid
    local exit_code=$?
    
    # Kill monitoring
    jobs -p | xargs -r kill 2>/dev/null || true
    
    return $exit_code
}

build_nixos() {
    local action=${1:-"switch"}
    
    log "Starting NixOS rebuild ($action) for host: $HOST"
    
    cd "$FLAKE_PATH"
    
    # Start build in background and capture PID
    if [ "$action" = "switch" ]; then
        sudo nixos-rebuild switch --flake ".#$HOST" --show-trace 2>&1 | tee /tmp/nixos-build.log &
    else
        nixos-rebuild build --flake ".#$HOST" --show-trace 2>&1 | tee /tmp/nixos-build.log &
    fi
    
    local build_pid=$!
    
    # Monitor the build
    if monitor_build $build_pid; then
        success "Build completed successfully!"
        
        if [ "$action" = "switch" ]; then
            log "System has been updated. Consider rebooting to ensure stability."
        else
            log "Build completed. Run with 'switch' to apply changes."
        fi
    else
        error "Build failed! Check /tmp/nixos-build.log for details"
        return 1
    fi
}

show_help() {
    cat << EOF
Usage: $0 [COMMAND]

Commands:
    build       Build configuration without switching (safe)
    switch      Build and switch to new configuration
    check       Check system resources only
    cleanup     Clean up system before build
    help        Show this help message

Examples:
    $0 build      # Safe build without switching
    $0 switch     # Full rebuild and switch
    $0 check      # Check if system is ready for build
    $0 cleanup    # Clean up before manual build
EOF
}

main() {
    local command=${1:-"build"}
    
    case "$command" in
        "build")
            check_resources
            cleanup_before_build
            build_nixos "build"
            ;;
        "switch")
            check_resources
            cleanup_before_build
            build_nixos "switch"
            ;;
        "check")
            check_resources
            ;;
        "cleanup")
            cleanup_before_build
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            error "Unknown command: $command"
            show_help
            exit 1
            ;;
    esac
}

main "$@" 