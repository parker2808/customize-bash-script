#!/bin/bash

# Configuration file for work automation scripts

# =============================================================================
# ENVIRONMENT CONFIGURATION
# =============================================================================

# Default browser to use
export BROWSER="${BROWSER:-Google Chrome}"

# Chrome profile to use (if needed)
export CHROME_PROFILE="${CHROME_PROFILE:-}"

# Delay settings (in seconds)
export APP_LAUNCH_DELAY="${APP_LAUNCH_DELAY:-2}"
export TAB_OPEN_DELAY="${TAB_OPEN_DELAY:-0.5}"
export CHROME_LAUNCH_DELAY="${CHROME_LAUNCH_DELAY:-3}"

# =============================================================================
# ENVIRONMENT FILE LOADING
# =============================================================================

# Function to load environment file
load_env_file() {
    local env_file="$1"
    
    if [ -f "$env_file" ]; then
        log_debug "Loading environment file: $env_file"
        
        # Read the file line by line and export variables
        while IFS='=' read -r key value; do
            # Skip comments and empty lines
            if [[ $key =~ ^[[:space:]]*# ]] || [[ -z $key ]]; then
                continue
            fi
            
            # Remove quotes from value
            value="${value%\"}"
            value="${value#\"}"
            
            # Export the variable
            export "$key"="$value"
            log_debug "Loaded: $key=$value"
        done < "$env_file"
        
        log_info "✅ Environment file loaded: $env_file"
    else
        log_warn "Environment file not found: $env_file"
        return 1
    fi
}

# Function to parse comma-separated URLs into array
parse_urls() {
    local url_string="$1"
    local array_name="$2"
    
    # Clear the array using eval
    eval "$array_name=()"
    
    # Split comma-separated string into array
    IFS=',' read -ra temp_array <<< "$url_string"
    for url in "${temp_array[@]}"; do
        # Trim whitespace
        url=$(echo "$url" | xargs)
        if [ -n "$url" ]; then
            eval "$array_name+=(\"$url\")"
        fi
    done
    
    # Get array length for logging
    local array_length
    eval "array_length=\${#$array_name[@]}"
    log_debug "Parsed $array_length URLs from string"
}

# =============================================================================
# LOGGING CONFIGURATION
# =============================================================================

# Log level: DEBUG, INFO, WARN, ERROR
export LOG_LEVEL="${LOG_LEVEL:-INFO}"

# Log file path
export LOG_FILE="${LOG_FILE:-$(dirname "$0")/../work.log}"

# =============================================================================
# VALIDATION FUNCTIONS
# =============================================================================

# Validate that required directories and commands exist
validate_paths() {
    local errors=0
    
    # Check if Cursor project path exists (if defined)
    if [ -n "$CURSOR_PROJECT_PATH" ] && [ ! -d "$CURSOR_PROJECT_PATH" ]; then
        log_error "Cursor project path does not exist: $CURSOR_PROJECT_PATH"
        ((errors++))
    fi
    
    # Check if Chrome is installed
    if ! command -v "open" >/dev/null 2>&1; then
        log_error "Cannot use 'open' command (required for macOS)"
        ((errors++))
    fi
    
    # Check if osascript is available (for full screen functionality)
    if ! command -v "osascript" >/dev/null 2>&1; then
        log_warn "osascript not available - full screen functionality may not work"
    fi
    
    if [ $errors -gt 0 ]; then
        log_error "Configuration validation failed with $errors error(s)"
        return 1
    fi
    
    log_info "Configuration validation passed"
    return 0
} 
