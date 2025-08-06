#!/bin/bash

# Logging utility for work automation scripts

# =============================================================================
# LOGGING FUNCTIONS
# =============================================================================

# Get current timestamp
get_timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

# Get log level numeric value
get_log_level_value() {
    case "$1" in
        "DEBUG") echo 0 ;;
        "INFO")  echo 1 ;;
        "WARN")  echo 2 ;;
        "ERROR") echo 3 ;;
        *)       echo 1 ;;
    esac
}

# Check if should log at given level
should_log() {
    local message_level="$1"
    local current_level_value=$(get_log_level_value "$LOG_LEVEL")
    local message_level_value=$(get_log_level_value "$message_level")
    
    [ $message_level_value -ge $current_level_value ]
}

# Write log message
write_log() {
    local level="$1"
    local message="$2"
    local timestamp=$(get_timestamp)
    local log_entry="[$timestamp] [$level] $message"
    
    # Write to log file if specified
    if [ -n "$LOG_FILE" ]; then
        echo "$log_entry" >> "$LOG_FILE"
    fi
    
    # Write to console with color coding
    case "$level" in
        "DEBUG")
            echo -e "\033[36m$log_entry\033[0m" # Cyan
            ;;
        "INFO")
            echo -e "\033[32m$log_entry\033[0m" # Green
            ;;
        "WARN")
            echo -e "\033[33m$log_entry\033[0m" # Yellow
            ;;
        "ERROR")
            echo -e "\033[31m$log_entry\033[0m" # Red
            ;;
        *)
            echo "$log_entry"
            ;;
    esac
}

# Log functions
log_debug() {
    if should_log "DEBUG"; then
        write_log "DEBUG" "$1"
    fi
}

log_info() {
    if should_log "INFO"; then
        write_log "INFO" "$1"
    fi
}

log_warn() {
    if should_log "WARN"; then
        write_log "WARN" "$1"
    fi
}

log_error() {
    if should_log "ERROR"; then
        write_log "ERROR" "$1"
    fi
}

# =============================================================================
# PROGRESS INDICATORS
# =============================================================================

# Show progress spinner
show_spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Show progress bar
show_progress() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local completed=$((width * current / total))
    local remaining=$((width - completed))
    
    printf "\r["
    printf "%${completed}s" | tr ' ' '#'
    printf "%${remaining}s" | tr ' ' '-'
    printf "] %d%%" $percentage
    
    if [ $current -eq $total ]; then
        echo
    fi
} 
