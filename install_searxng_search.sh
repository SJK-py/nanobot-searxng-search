#!/bin/bash

# Define the base raw GitHub URL for the repository
REPO_BASE_URL="https://raw.githubusercontent.com/SJK-py/nanobot-searxng-search/main"

# 1. Validate workspace directory by checking for 'skills' folder
if [ ! -d "skills" ]; then
    echo "Error: The 'skills' directory was not found."
    echo "This script must be executed from the root of your nanobot workspace directory."
    exit 1
fi

# 2. Create the necessary directories
echo "Creating directories..."
mkdir -p skills/searxng-search/scripts

# Function to handle backing up and downloading files
download_file() {
    local url=$1
    local dest=$2
    local filename=$(basename "$dest")

    # 3. Rename old files with .bak extension if they already exist
    if [ -f "$dest" ]; then
        mv "$dest" "${dest}.bak"
        echo "  -> Backed up existing '$filename' to '${filename}.bak'"
    fi

    # Download the file
    echo "  -> Downloading '$filename'..."
    curl -sS -f -L "$url" -o "$dest"
    
    if [ $? -ne 0 ]; then
        echo "  -> Error: Failed to download '$filename'."
    fi
}

# 4 & 5. Download the files to their respective directories
echo "Downloading files from repository..."

# Download SKILL.md
download_file "${REPO_BASE_URL}/skills/searxng-search/SKILL.md" "skills/searxng-search/SKILL.md"

# Download searxng-search.py
download_file "${REPO_BASE_URL}/skills/searxng-search/scripts/searxng-search.py" "skills/searxng-search/scripts/searxng-search.py"

# Download example.env
download_file "${REPO_BASE_URL}/skills/searxng-search/scripts/example.env" "skills/searxng-search/scripts/example.env"

# 6. Output completion message and reminder
echo ""
echo "============================================================"
echo "Installation complete! SearXNG Search skill has been added."
echo "============================================================"
echo "REMINDER: You must configure your environment variables."
echo "An 'example.env' file has been placed in:"
echo "  skills/searxng-search/scripts/example.env"
echo ""
echo "Please copy it to '.env' and populate it with your settings."
echo "============================================================"
chmod +x "$TOOL_DIR/searxng_search.py"

echo "SearXNG Search Skill installed successfully!"
