# SearXNG Search Skill for nanobot (rev.2)

A custom skill for your nanobot workspace that substitutes the default `web_search` tool with a self-hosted SearXNG instance. By keeping your search queries local, this skill is perfect for maintaining a fully private retrieval pipeline.

## Changelog

* **rev.2:** reworked installation script to refine directory scheme, pursuant to model skill directory scheme.
* If updating from previous version, remove searxng_search.py from `skill-tools` directory after installation.

## Installation

Follow these steps to install the skill automatically into your nanobot workspace.

1. **Navigate to your workspace:** Open your terminal and ensure your current directory is the root of your nanobot workspace (the folder containing your `skills` directory).

```bash
   cd /path/to/your/nanobot/workspace
```

2. **Download the installer:** Use `wget` to fetch the installation script directly from the repository.

```bash
wget "https://raw.githubusercontent.com/SJK-py/nanobot-searxng-search/main/install_searxng_search.sh"
```

3. **Execute the script:** Make the script executable and run it to set up the directories and download the necessary files.

```bash
chmod +x install_searxng_search.sh
./install_searxng_search.sh
```

Once installed, your nanobot will automatically detect the `searxng-search` skill and can begin using it for web queries.

## Ensuring Nanobot Prefers This Skill

While the nanobot will detect the skill automatically, it may still occasionally default to its built-in web search.

**Pro-Tip:** To guarantee your nanobot routes queries through your local SearXNG instance, you can optionally modify your `USER.md` file. Simply append a direct instruction, such as:

> *"Always use the `searxng-search` skill instead of the built-in `web_search` tool for any web searches."*

## Configuration

Before the nanobot can successfully execute searches, you must configure the environment variables for the skill's underlying Python script.

1. Navigate to the newly created `skills/searxng-search/scripts` directory.
2. Copy the provided `example.env` to a new file named `.env`.
3. Update the `.env` file with your specific instance details:
* `BASE_URL`: The API base URL for your SearXNG instance (defaults to `http://localhost:8080`).
* `CONTENT_LEN_LIMIT`: The character limit for each search result snippet (defaults to `500`). This is crucial for truncating long text to save valuable context space for your LLM.

## How the Nanobot Uses It

When web search is required, the nanobot uses the `exec` tool to run the helper Python script in the background.

The nanobot will construct commands using the following syntax:

```bash
python3 [skill path]/scripts/searxng-search.py "<QUERY>" <Optional Parameters>
```

*Note: The nanobot must enclose the `<QUERY>` argument in quotes.*

### Available Parameters to the Nanobot

* `--count`: Number of results to return (defaults to 7 in the skill description).
* `--time_range`: Restrict the time range of results (`day`, `week`, `month`, `year`).
* `--language`: Language code for the search (e.g., `en`, `ko`).

### Skill Output

The helper script returns a JSON array containing the top search results to the nanobot. Each result object includes the `title`, `url`, `content`, `score`, and `publishedDate`.

## Manual Usage (Optional)

Though designed for autonomous nanobot use, the helper script can be executed independently from the command line for testing or general use:

```bash
python3 scripts/searxng-search.py "AI news" --count 5 --time_range week --language en
```

## License
MIT
