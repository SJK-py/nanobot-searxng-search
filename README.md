# SearXNG Search Skill for nanobot

This project provides an installation script to add a custom "searxng-search" skill to your nanobot instance.

## Overview
By default, nanobot might be configured to use specific search APIs (just Brave for now). This custom skill allows you to bypass hardcoded search providers and route your AI's web searches through your own self-hosted SearXNG instance instead.

## Features
- Direct integration with your personal SearXNG instance (utilizing JSON output).
- Customizable Base URL and content length limits during installation.
- Seamlessly replaces the default web search behavior for the bot.

## Requirements
- **uv**: This tool requires `uv` to be installed on your system. `uv` is used to execute the Python script using PEP 723 inline script metadata (e.g., `# /// script dependencies = ["requests"]`). This allows the script to automatically manage its own dependencies on the fly without requiring you to manually set up a virtual environment.
- **SearXNG**: A running instance of SearXNG with JSON format output enabled.

## Installation
Run the included shell script:
```bash
./install_searxng_search.sh
```
The script will prompt you for:
- Your nanobot workspace path.
- Your SearXNG base URL (e.g., `http://localhost:8080`).
- The maximum content length limit for search results.

*Note: The script will automatically create the following directories in your nanobot workspace if they don't already exist:*
- `skills/searxng-search/` - where the `SKILL.md` instruction file is saved.
- `skill-tools/` - where the actual `searxng_search.py` script is saved.

## Usage
Once installed, simply ask your nanobot to search the web (e.g., "Search the web for the latest news on AI"). The bot will automatically decide to use the `searxng-search` skill to retrieve the information.
Optionally, you can instruct your bot to memorize (save in MEMORY.md) that searxng-search skill is preferred over web search tool.

## License
MIT
