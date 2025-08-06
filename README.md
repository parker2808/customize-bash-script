# Work Automation Scripts

A collection of optimized bash scripts for automating your work routine on macOS.

## 🚀 Features

- **Full Screen Apps**: Automatically opens applications in full screen mode
- **Chrome Tab Management**: Opens multiple work-related URLs in Chrome
- **Progress Tracking**: Visual progress indicators and detailed logging
- **Error Handling**: Robust error handling with graceful failures
- **Configuration Management**: Centralized configuration with environment variables
- **Logging System**: Multi-level logging with color-coded output

## 📁 Project Structure

```
bash/
├── work.sh          # Main work routine script
├── work.env         # Work-specific environment variables
├── base/            # Core utilities and configuration
│   ├── bash.sh      # Core utility functions
│   ├── config.sh    # Base configuration and utilities
│   └── logger.sh    # Logging utilities
└── README.md        # This file
```

## 🛠️ Installation

1. **Clone or download** the scripts to your desired directory
2. **Grant permissions** to all scripts:
   ```bash
   chmod +x *.sh
   ```
3. **Customize configuration** in `config.sh` if needed

## 🎯 Quick Start

Run the work routine:

```bash
./work.sh
```

This will:

1. ✅ Grant permissions to all scripts
2. 📱 Open Chrome in full screen
3. 🌐 Open all work URLs in tabs
4. 💻 Open Cursor with your project in full screen

## ⚙️ Configuration

### Environment Variables

Set these in your shell or in `config.sh`:

```bash
# Browser settings
export BROWSER="Google Chrome"
export CHROME_PROFILE="Parker"

# Timing settings
export APP_LAUNCH_DELAY=2
export TAB_OPEN_DELAY=0.5
export CHROME_LAUNCH_DELAY=3

# Logging settings
export LOG_LEVEL="INFO"  # DEBUG, INFO, WARN, ERROR
export LOG_FILE="./work.log"
```

### Customizing Work URLs

Edit the `work.env` file to customize your work routine:

```bash
# Work-related URLs to open (comma-separated)
WORK_URLS="https://mail.google.com/chat/u/1/#chat/home,https://kobizo.atlassian.net/issues/?filter=10061,https://github.com/"

# Work-specific application paths
CURSOR_PROJECT_PATH="/path/to/your/project"

# Work-specific browser settings
WORK_BROWSER="Google Chrome"
WORK_CHROME_PROFILE=""
```

### Creating Additional Environment Files

You can create different `.env` files for different purposes:

```bash
# Create development environment
cp work.env dev.env

# Create personal environment
cp work.env personal.env

# Then modify each file for different use cases
```

## 📊 Logging

The scripts include a comprehensive logging system:

### Log Levels

- **DEBUG**: Detailed debugging information
- **INFO**: General information (default)
- **WARN**: Warning messages
- **ERROR**: Error messages

### Usage

```bash
# Set log level
export LOG_LEVEL="DEBUG"

# Run with detailed logging
./work.sh

# Check logs
tail -f work.log
```

## 🔧 Functions

### Core Functions (`bash.sh`)

- `open_app_fullscreen(app_name, [app_path])`: Opens an app in full screen
- `open_urls_in_chrome(urls...)`: Opens multiple URLs in Chrome
- `grant_script_permissions()`: Grants execute permissions to all scripts
- `list_chrome_profiles()`: Lists available Chrome profiles

### Logging Functions (`logger.sh`)

- `log_debug(message)`: Debug level logging
- `log_info(message)`: Info level logging
- `log_warn(message)`: Warning level logging
- `log_error(message)`: Error level logging
- `show_progress(current, total)`: Progress bar
- `show_spinner(pid)`: Loading spinner

## 🐛 Troubleshooting

### Common Issues

1. **Permission Denied**

   ```bash
   chmod +x *.sh
   ```

2. **App Not Found**

   - Check app name in `config.sh`
   - Ensure app is installed

3. **Path Not Found**

   - Verify project path in `APP_PATHS`
   - Check if directory exists

4. **Chrome Profile Issues**
   ```bash
   # List available profiles
   source base/bash.sh
   list_chrome_profiles
   ```

### Debug Mode

Run with debug logging:

```bash
LOG_LEVEL="DEBUG" ./work.sh
```

## 🔄 Extending

### Adding New URLs

Edit `work.env`:

```bash
# Add new URLs to the comma-separated list
WORK_URLS="https://mail.google.com/chat/...,https://new-url.com/"
```

### Creating New Script Types

Create a new environment file and script:

```bash
# Create new environment file
cp work.env study.env

# Create new script
cp work.sh study.sh

# Modify study.sh to load study.env instead of work.env
```

### Creating Custom Scripts

```bash
#!/bin/bash
source "$(dirname "$0")/base/bash.sh"

# Your custom logic here
log_info "Custom script running..."
```

## 📝 License

This project is open source and available under the MIT License.

## 🤝 Contributing

Feel free to submit issues and enhancement requests!
