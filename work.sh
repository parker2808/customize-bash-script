#!/bin/bash

# Work startup script
# Opens all necessary Chrome tabs and Cursor with the project
# Optimized version with better error handling and logging

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Import utilities
source "$(dirname "$0")/base/bash.sh"

# Load work environment
if ! load_env_file "$(dirname "$0")/work.env"; then
    log_error "Failed to load work environment file"
    exit 1
fi

# Parse work URLs from environment
declare -a WORK_URLS_ARRAY
parse_urls "$WORK_URLS" WORK_URLS_ARRAY

# Override default settings with work-specific settings
export BROWSER="${WORK_BROWSER:-$BROWSER}"
export CHROME_PROFILE="${WORK_CHROME_PROFILE:-$CHROME_PROFILE}"
export APP_LAUNCH_DELAY="${WORK_APP_LAUNCH_DELAY:-$APP_LAUNCH_DELAY}"
export TAB_OPEN_DELAY="${WORK_TAB_OPEN_DELAY:-$TAB_OPEN_DELAY}"
export CHROME_LAUNCH_DELAY="${WORK_CHROME_LAUNCH_DELAY:-$CHROME_LAUNCH_DELAY}"

# Script start
log_info "🚀 Starting work routine..."
log_info "📋 Loaded ${#WORK_URLS_ARRAY[@]} work URLs"

# Validate configuration
if ! validate_paths; then
    log_error "Configuration validation failed. Please check your settings."
    exit 1
fi

# Grant permissions to all scripts
grant_script_permissions

# 1. Open Chrome in full screen
log_info "📱 Step 1: Opening Chrome in full screen..."
if ! open_app_fullscreen "Google Chrome"; then
    log_error "Failed to open Chrome in full screen"
    exit 1
fi

# 2. Open work URLs
log_info "🌐 Step 2: Opening work tabs..."
if ! open_urls_in_chrome "${WORK_URLS_ARRAY[@]}"; then
    log_error "Failed to open work URLs"
    exit 1
fi

# 3. Open Cursor with project in full screen
log_info "💻 Step 3: Opening Cursor with project..."
if ! open_app_fullscreen "Cursor" "$CURSOR_PROJECT_PATH"; then
    log_error "Failed to open Cursor with project"
    exit 1
fi

# Script completion
log_info "✅ Work routine completed successfully!"
log_info "📊 Summary:"
log_info "  - Chrome opened in full screen"
log_info "  - ${#WORK_URLS_ARRAY[@]} work tabs opened"
log_info "  - Cursor opened with project in full screen"
