#!/bin/bash

echo "=== Install SearXNG Search Skill ==="
read -p "Enter nanobot workspace path [default: ~/.nanobot/workspace]: " NANOBOT_PATH
NANOBOT_PATH=${NANOBOT_PATH:-~/.nanobot/workspace}
NANOBOT_PATH=$(eval echo "$NANOBOT_PATH")

read -p "Enter SearXNG Base URL (e.g., http://localhost:8080): " BASE_URL
read -p "Enter search content length limit [default: 500]: " CONTENT_LEN_LIMIT
CONTENT_LEN_LIMIT=${CONTENT_LEN_LIMIT:-500}

SKILL_DIR="$NANOBOT_PATH/skills/searxng-search"
TOOL_DIR="$NANOBOT_PATH/skill-tools"

mkdir -p "$SKILL_DIR"
mkdir -p "$TOOL_DIR"

cat << 'EOF' > "$SKILL_DIR/SKILL.md"
# SearXNG Search Skill

This skill allows you to search the web using a self-hosted SearXNG instance instead of the default web search API.

## How to Use

Use the `exec` tool to run the Python script `searxng_search.py` located in `SKILL_TOOL_PATH`.

### Parameters
- `query` (Positional, required): The search query. Enclose in quotes.
- `--count` (Optional): Number of results to return (default: 5).
- `--time_range` (Optional): Time range of results (choices: `day`, `week`, `month`, `year`).
- `--language` (Optional): Language code (e.g., `en`, `ko`).

### Examples

**Basic Search:**
```bash
python3 SKILL_TOOL_PATH "python latest version release date"
```

**Search with parameters:**
```bash
python3 SKILL_TOOL_PATH "AI news" --count 3 --time_range week --language en
```

### Output Format
The script returns a JSON array containing the top search results. Each result includes `title`, `url`, `content` (truncated to save context), `score`, and optionally `publishedDate`.
EOF
sed -i "s|SKILL_TOOL_PATH|$TOOL_DIR/searxng_search.py|g" "$SKILL_DIR/SKILL.md"


cat << 'EOF' > "$TOOL_DIR/searxng_search.py"
#!/usr/bin/env python3
import urllib.request
import urllib.parse
import json
import argparse
import sys

BASE_URL = "REPLACE_BASE_URL"
CONTENT_LEN_LIMIT = REPLACE_CONTENT_LEN_LIMIT

def search(query, count=5, time_range=None, language=None):
    params = {
        'q': query,
        'format': 'json',
    }
    if time_range:
        params['time_range'] = time_range
    if language:
        params['language'] = language
        
    query_string = urllib.parse.urlencode(params)
    url = f"{BASE_URL}/search?{query_string}"
    
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'nanobot-skill/1.0'})
        with urllib.request.urlopen(req) as response:
            data = json.loads(response.read().decode('utf-8'))
            
        results = data.get('results', [])
        sanitized = []
        for r in results[:count]:
            content = r.get('content', '') or r.get('snippet', '')
            if len(content) > CONTENT_LEN_LIMIT:
                content = content[:CONTENT_LEN_LIMIT] + '...'
                
            sanitized.append({
                'title': r.get('title', ''),
                'url': r.get('url', ''),
                'content': content,
                'score': r.get('score'),
                'publishedDate': r.get('publishedDate')
            })
            
        print(json.dumps(sanitized, indent=2, ensure_ascii=False))
        
    except Exception as e:
        print(json.dumps({'error': str(e)}), file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="SearXNG Custom Search Skill")
    parser.add_argument('query', help="Search query")
    parser.add_argument('--count', type=int, default=5, help="Number of results to return")
    parser.add_argument('--time_range', choices=['day', 'week', 'month', 'year'], help="Time range")
    parser.add_argument('--language', help="Language (e.g., en, ko)")
    
    args = parser.parse_args()
    search(args.query, args.count, args.time_range, args.language)
EOF

sed -i "s|REPLACE_BASE_URL|$BASE_URL|g" "$TOOL_DIR/searxng_search.py"
sed -i "s|REPLACE_CONTENT_LEN_LIMIT|$CONTENT_LEN_LIMIT|g" "$TOOL_DIR/searxng_search.py"
chmod +x "$TOOL_DIR/searxng_search.py"

echo "SearXNG Search Skill installed successfully!"
