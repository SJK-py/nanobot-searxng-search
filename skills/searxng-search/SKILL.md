---
name: searxng-search
description: Search web using SearXNG instance. Substitutes web_search tool.
---

# SearXNG Search Skill

This skill allows you to search the web using a self-hosted SearXNG instance instead of the default web_search tool.

## Usage

When web search is needed for generating output, use the `exec` tool to run the Python script

```bash
python3 [skill path (parent directory of SKILL.md)]/scripts/searxng-search.py <QUERY> <Optional Parameters>
```

`<QUERY>` (Positional, required): The search query. Enclose in quotes

### Optional Parameters

- `--count`: Number of results to return (default: 7).
- `--time_range`: Time range of results (choices: `day`, `week`, `month`, `year`).
- `--language`: Language code (e.g., `en`, `ko`).

### Example Usage

```bash
python3 [skill path (parent directory of SKILL.md)]/scripts/searxng-search.py "AI news" --count 5 --time_range week --language en
```

### Output Format
The script returns a JSON array containing the top search results. Each result includes `title`, `url`, `content` (truncated to save context), `score`, and `publishedDate` (may omitted).
