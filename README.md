# OpenClaw Job Hunt Kit

An automated job application system powered by **OpenClaw + Claude Code + Playwright MCP**. Works for **any role** — software engineering, product management, design, marketing, data science, or anything else.

Three autonomous agents work together every night to find relevant jobs, apply to them, and log everything — so you wake up to a Telegram summary of what got done.

## Architecture

```
┌─────────────┐
│ jobmanager   │  Orchestrator — runs nightly via cron
│  (SOUL.md)   │  Spawns searcher, then batches of applyers
└──────┬───────┘
       │
       ▼
┌─────────────┐
│ jobsearcher  │  Scrapes job boards, validates URLs,
│  (SOUL.md)   │  dedup-checks Notion, returns JSON list
└──────┬───────┘
       │
       ▼
┌─────────────────────────────────┐
│ jobapplyer × N (batch of 10)    │  Fills forms via Playwright MCP,
│  (SOUL.md)                      │  writes cover letters, logs to Notion
└─────────────────────────────────┘
```

**jobmanager** is the orchestrator. It:
1. Spawns **jobsearcher** to find up to N jobs from configured job boards
2. Saves the verified job list to `/tmp/jobmanager-jobs.json`
3. Spawns **jobapplyer** agents in parallel batches (default: 10 at a time)
4. Monitors progress, kills stuck agents, logs everything
5. Sends a final Telegram summary

## Prerequisites

- [OpenClaw](https://openclaw.dev) installed and configured
- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) (`claude` command available)
- [Playwright MCP](https://github.com/anthropics/playwright-mcp) server configured
- A Notion API key + a Notion database for tracking applications
- A Telegram bot for notifications (create one via [@BotFather](https://t.me/BotFather))
- Your CV as a PDF

## Quick Setup (< 30 minutes)

### 1. Clone this repo

```bash
git clone https://github.com/JoeClaudeVanDamn/openclaw-job-hunt-kit.git
cd openclaw-job-hunt-kit
```

### 2. Run the setup script

```bash
chmod +x setup.sh
./setup.sh
```

This will:
- Check that prerequisites are installed
- Create agent directories under `~/.openclaw/agents/`
- Copy SOUL.md files into place
- Prompt you to fill in your configuration

### 3. Fill in your config

Edit `templates/config.json` with your details:

```json
{
  "candidate_name": "Your Name",
  "email": "you@example.com",
  "phone": "+1234567890",
  "linkedin": "https://www.linkedin.com/in/your-profile/",
  "cv_path": "/path/to/your/cv.pdf",
  "notion_db_id": "your-notion-db-id",
  "telegram_chat_id": "your-chat-id",
  "telegram_bot_token": "your-bot-token",
  "target_locations": ["Your target countries/cities"],
  "target_titles": ["Your Target Role", "Senior Your Target Role"],
  "search_urls": ["https://indeed.com/jobs?q=your+role&l=your+location"],
  ...
}
```

### 4. Fill in your profile

Edit `templates/profile.json` with your full work history, education, and skills.

### 5. Customize templates

- `templates/cover-letter-template.md` — your cover letter skeleton
- `templates/form-answers.md` — canonical answers to common form questions

### 6. Set up Notion

Create a Notion database with these properties:
| Property | Type |
|----------|------|
| Role | Title |
| Company | Rich text |
| Location | Rich text |
| Job URL | URL |
| Platform | Select (greenhouse, workday, lever, etc.) |
| Visa Sponsorship | Checkbox |
| Status | Select (Applied, Flagged, Rejected, Interview) |
| Applied Date | Date |
| Salary Range | Rich text |
| Notes | Rich text |

Copy the database ID from the URL and add it to your config.

### 7. Register the nightly cron

```bash
openclaw cron add \
  --agent jobmanager \
  --schedule "0 2 * * *" \
  --description "Nightly job hunt"
```

This runs the job manager at 2 AM every night.

## How the Nightly Cron Works

1. **2:00 AM** — OpenClaw triggers the jobmanager agent
2. **jobmanager** spawns **jobsearcher** with a 15-minute timeout
3. **jobsearcher** scrapes configured job board URLs, validates every link, dedup-checks against Notion, and returns a JSON array
4. **jobmanager** saves the list and begins processing in batches of N
5. For each batch, N **jobapplyer** agents run in parallel — each fills out the application form via Playwright, writes a tailored cover letter, and logs everything to Notion
6. **jobmanager** monitors all agents, kills any stuck for >25 minutes, and sends a Telegram summary when done

## Customizing for Different Roles / Locations

### Set your target roles
Edit `target_titles` in `config.json` with your desired job titles:
```json
"target_titles": ["Software Engineer", "Senior Software Engineer", "Backend Engineer"]
```
Then update the title matching rules in `agents/jobsearcher/SOUL.md` with your accept/reject patterns.

### Set your target locations
Edit `target_locations` in `config.json`:
```json
"target_locations": ["USA", "Canada", "Remote North America"]
```

### Add job board sources
Add URLs to `search_urls` in `config.json`. The jobsearcher will scrape each one and follow pagination.

### Adjust batch size / max jobs
```json
"max_jobs": 50,
"batch_size": 10
```

## File Structure

```
openclaw-job-hunt-kit/
├── README.md
├── setup.sh                          # Setup script
├── .gitignore
├── agents/
│   ├── jobmanager/SOUL.md            # Orchestrator agent
│   ├── jobsearcher/SOUL.md           # Job finder agent
│   └── jobapplyer/SOUL.md            # Application filler agent
└── templates/
    ├── config.json                   # Central configuration
    ├── profile.json                  # Your professional profile
    ├── cover-letter-template.md      # Cover letter skeleton
    └── form-answers.md               # Canonical form answers
```

## Troubleshooting

- **Agent stuck / timing out** — Check Playwright MCP logs. Some sites have aggressive bot detection.
- **Notion logging fails** — Verify your API key and database ID. Make sure the integration has access to the database.
- **No Telegram notifications** — Test your bot token with a curl: `curl "https://api.telegram.org/bot<TOKEN>/sendMessage?chat_id=<CHAT_ID>&text=test"`
- **Jobs not found** — Update your `search_urls` — job board URLs change frequently.

## License

MIT
