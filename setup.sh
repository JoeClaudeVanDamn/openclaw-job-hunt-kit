#!/usr/bin/env bash
set -euo pipefail

echo "========================================="
echo "  OpenClaw Job Hunt Kit — Setup"
echo "========================================="
echo ""

# ── Check prerequisites ──────────────────────────────────────────────

check_cmd() {
  if ! command -v "$1" &>/dev/null; then
    echo "❌ $1 is not installed. $2"
    exit 1
  else
    echo "✅ $1 found"
  fi
}

echo "Checking prerequisites..."
check_cmd "openclaw" "Install from https://openclaw.dev"
check_cmd "claude" "Install Claude Code CLI from https://docs.anthropic.com/en/docs/claude-code"
echo ""

# Check Playwright MCP
if claude mcp list 2>/dev/null | grep -q "playwright"; then
  echo "✅ Playwright MCP found"
else
  echo "⚠️  Playwright MCP not detected. Make sure it's configured in Claude Code."
  echo "   See: https://github.com/anthropics/playwright-mcp"
fi
echo ""

# ── Determine script directory ────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_DIR="${AGENTS_DIR:-$HOME/.openclaw/agents}"

echo "Agent directory: $AGENTS_DIR"
echo ""

# ── Create agent directories ──────────────────────────────────────────

echo "Creating agent directories..."
mkdir -p "$AGENTS_DIR/jobmanager/workspace"
mkdir -p "$AGENTS_DIR/jobsearcher/workspace"
mkdir -p "$AGENTS_DIR/jobapplyer/workspace"
echo "✅ Directories created"
echo ""

# ── Copy SOUL.md files ────────────────────────────────────────────────

echo "Copying SOUL.md files..."
cp "$SCRIPT_DIR/agents/jobmanager/SOUL.md"  "$AGENTS_DIR/jobmanager/workspace/SOUL.md"
cp "$SCRIPT_DIR/agents/jobsearcher/SOUL.md" "$AGENTS_DIR/jobsearcher/workspace/SOUL.md"
cp "$SCRIPT_DIR/agents/jobapplyer/SOUL.md"  "$AGENTS_DIR/jobapplyer/workspace/SOUL.md"
echo "✅ SOUL.md files copied"
echo ""

# ── Copy templates ────────────────────────────────────────────────────

echo "Copying template files..."
TEMPLATES_DEST="$AGENTS_DIR/../templates"
mkdir -p "$TEMPLATES_DEST"
cp "$SCRIPT_DIR/templates/profile.json"             "$TEMPLATES_DEST/profile.json"
cp "$SCRIPT_DIR/templates/cover-letter-template.md"  "$TEMPLATES_DEST/cover-letter-template.md"
cp "$SCRIPT_DIR/templates/form-answers.md"           "$TEMPLATES_DEST/form-answers.md"
cp "$SCRIPT_DIR/templates/config.json"               "$TEMPLATES_DEST/config.json"
echo "✅ Templates copied to $TEMPLATES_DEST"
echo ""

# ── Replace placeholders ──────────────────────────────────────────────

CONFIG="$TEMPLATES_DEST/config.json"

echo "========================================="
echo "  Configure your settings"
echo "========================================="
echo ""
echo "Fill in your details in: $CONFIG"
echo "And your profile in:     $TEMPLATES_DEST/profile.json"
echo ""
echo "Then run this command to replace placeholders in SOUL.md files:"
echo ""
echo "  # Example using jq + sed (run manually after editing config.json):"
echo "  NAME=\$(jq -r .candidate_name $CONFIG)"
echo "  sed -i '' \"s|{{CANDIDATE_NAME}}|\$NAME|g\" $AGENTS_DIR/*/workspace/SOUL.md"
echo ""
echo "Placeholders to replace in SOUL.md files:"
echo "  {{CANDIDATE_NAME}}     — Your full name"
echo "  {{AGENTS_DIR}}         — $AGENTS_DIR"
echo "  {{MAX_JOBS}}           — Max jobs per run (default: 50)"
echo "  {{BATCH_SIZE}}         — Parallel batch size (default: 10)"
echo "  {{NOTION_DB_ID}}       — Your Notion database ID"
echo "  {{NOTION_KEY_PATH}}    — Path to Notion API key file"
echo "  {{TELEGRAM_CHAT_ID}}   — Your Telegram chat ID"
echo "  {{TELEGRAM_BOT_TOKEN}} — Your Telegram bot token"
echo "  {{SEARCH_URLS}}        — Job board URLs to scrape"
echo "  {{TARGET_LOCATIONS}}   — Target job locations"
echo "  {{TARGET_TITLES}}      — Target job titles"
echo "  {{SALARY_MIN}}         — Minimum salary filter"
echo "  {{SALARY_MAX}}         — Maximum salary filter"
echo "  {{SALARY_EUR}}         — Default EUR salary"
echo "  {{SALARY_GBP}}         — Default GBP salary"
echo "  {{SALARY_USD}}         — Default USD salary"
echo "  {{DATE_WINDOW_DAYS}}   — How many days back to search"
echo "  {{PROFILE_PATH}}       — Path to profile.json"
echo "  {{CV_PATH}}            — Path to your CV PDF"
echo "  {{COVER_LETTER_PATH}}  — Path to cover letter template"
echo "  {{FORM_ANSWERS_PATH}}  — Path to form-answers.md"
echo "  {{LINKEDIN_URL}}       — Your LinkedIn profile URL"
echo ""

# ── Notion setup instructions ─────────────────────────────────────────

echo "========================================="
echo "  Notion Setup"
echo "========================================="
echo ""
echo "1. Create a Notion integration at https://www.notion.so/my-integrations"
echo "2. Save the API key to: ~/.config/notion/api_key"
echo "   mkdir -p ~/.config/notion && echo 'your-api-key' > ~/.config/notion/api_key"
echo "3. Create a database with columns: Role (title), Company, Location,"
echo "   Job URL, Platform, Visa Sponsorship, Status, Applied Date, Salary Range, Notes"
echo "4. Share the database with your integration"
echo "5. Copy the database ID from the URL and add to config.json"
echo ""

# ── Cron registration ─────────────────────────────────────────────────

echo "========================================="
echo "  Register Nightly Cron"
echo "========================================="
echo ""
echo "Once configured, register the nightly run:"
echo ""
echo "  openclaw cron add \\"
echo "    --agent jobmanager \\"
echo "    --schedule \"0 2 * * *\" \\"
echo "    --description \"Nightly job hunt\""
echo ""

echo "========================================="
echo "  Setup complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "  1. Edit $CONFIG with your details"
echo "  2. Edit $TEMPLATES_DEST/profile.json with your work history"
echo "  3. Customize cover-letter-template.md and form-answers.md"
echo "  4. Replace {{PLACEHOLDERS}} in SOUL.md files (see instructions above)"
echo "  5. Set up Notion database and API key"
echo "  6. Register the nightly cron"
echo ""
echo "Happy job hunting! 🎯"
