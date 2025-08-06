#!/bin/bash

# Bash utilities for common functions
# Optimized version with better error handling and logging

# Import configuration and logging
source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
source "$(dirname "${BASH_SOURCE[0]}")/logger.sh"

# Function to open an app in full screen
open_app_fullscreen() {
    local app_name="$1"
    local app_path="${2:-}"
    
    log_info "Opening $app_name in full screen..."
    
    # Validate app name
    if [ -z "$app_name" ]; then
        log_error "App name is required"
        return 1
    fi
    
    # Open the app
    if [ -n "$app_path" ]; then
        log_debug "Opening $app_name with path: $app_path"
        if ! open -a "$app_name" "$app_path"; then
            log_error "Failed to open $app_name with path: $app_path"
            return 1
        fi
    else
        log_debug "Opening $app_name without path"
        if ! open -a "$app_name"; then
            log_error "Failed to open $app_name"
            return 1
        fi
    fi
    
    # Wait for app to launch
    log_debug "Waiting $APP_LAUNCH_DELAY seconds for $app_name to launch..."
    sleep "$APP_LAUNCH_DELAY"
    
    # Use AppleScript to make the app full screen
    log_debug "Making $app_name full screen..."
    if ! osascript <<EOF
tell application "System Events"
    tell process "$app_name"
        set frontmost to true
        delay 0.5
        key code 3 using {command down, control down}
    end tell
end tell
EOF
    then
        log_warn "Failed to make $app_name full screen (app may not support full screen)"
    else
        log_info "✅ $app_name opened in full screen"
    fi
}

# Function to open multiple URLs in Chrome
open_urls_in_chrome() {
    local urls=("$@")
    local browser="${BROWSER:-Google Chrome}"
    local total_urls=${#urls[@]}
    local current=0
    
    log_info "Opening $total_urls work tabs in $browser..."
    
    # Validate URLs
    if [ $total_urls -eq 0 ]; then
        log_warn "No URLs provided to open"
        return 0
    fi
    
    # Open Chrome first
    log_info "Opening $browser..."
    if ! open -a "$browser"; then
        log_error "Failed to open $browser"
        return 1
    fi
    
    log_debug "Waiting $CHROME_LAUNCH_DELAY seconds for $browser to launch..."
    sleep "$CHROME_LAUNCH_DELAY"
    
    # Then open all URLs with progress
    for url in "${urls[@]}"; do
        ((current++))
        log_info "Opening tab $current/$total_urls: $url"
        
        if ! open -a "$browser" "$url"; then
            log_error "Failed to open URL: $url"
            continue
        fi
        
        show_progress "$current" "$total_urls"
        sleep "$TAB_OPEN_DELAY"
    done
    
    log_info "✅ All $total_urls tabs opened successfully"
}

# Function to grant full permissions to all shell scripts in current directory
grant_script_permissions() {
    log_info "Granting full permissions to all shell scripts..."
    
    local script_count=0
    local success_count=0
    
    for script in *.sh; do
        if [ -f "$script" ]; then
            ((script_count++))
            if chmod +x "$script" 2>/dev/null; then
                ((success_count++))
                log_debug "✅ Made executable: $script"
            else
                log_error "❌ Failed to make executable: $script"
            fi
        fi
    done
    
    log_info "✅ Permissions granted to $success_count/$script_count scripts"
    
    if [ $script_count -gt 0 ]; then
        log_debug "Scripts in current directory:"
        ls -la *.sh 2>/dev/null | while read line; do
            log_debug "  $line"
        done
    fi
}

# Function to list available Chrome profiles
list_chrome_profiles() {
    local chrome_data_dir="$HOME/Library/Application Support/Google/Chrome"
    local default_dir="$chrome_data_dir/Default"
    local local_state="$chrome_data_dir/Local State"
    
    echo "Available Chrome profiles:"
    echo "========================="
    
    # Check if Chrome data directory exists
    if [ -d "$chrome_data_dir" ]; then
        # Look for profile directories
        for profile_dir in "$chrome_data_dir"/Profile*; do
            if [ -d "$profile_dir" ]; then
                profile_name=$(basename "$profile_dir")
                echo "✅ $profile_name"
            fi
        done
        
        # Check for Default profile
        if [ -d "$default_dir" ]; then
            echo "✅ Default"
        fi
    else
        echo "❌ Chrome data directory not found at: $chrome_data_dir"
    fi
    
    echo ""
    echo "To use a specific profile, set CHROME_PROFILE environment variable:"
    echo "export CHROME_PROFILE=\"Profile 1\""
    echo "export CHROME_PROFILE=\"Default\""
}
