import os
import urllib.request
import urllib.parse
import json
import argparse
import sys
from pathlib import Path
from dotenv import load_dotenv

env_path = Path(__file__).parent / '.env'
load_dotenv(env_path)

BASE_URL = os.getenv("BASE_URL", "http://localhost:8080")
CONTENT_LEN_LIMIT = int(os.getenv("CONTENT_LEN_LIMIT", "500"))

def search(query, count=7, time_range=None, language=None):
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
