#!/usr/bin/env bash
# One-command installer for all 179 global skills across Projects & Google accounts
# Hosted at: https://github.com/samtran1991/agent-skills
#
# Fast install (uses pre-built archive in repo if available, ~3 seconds):
#   bash install-all-skills.sh
#
# Rebuild fresh from all 15 upstream GitHub repositories:
#   bash install-all-skills.sh --from-source
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
FROM_SOURCE=0
if [ "${1:-}" = "--from-source" ]; then
  FROM_SOURCE=1
fi

mkdir -p "$HOME/.agents/skills" "$HOME/.claude/skills" "$HOME/.claude/agents" "$HOME/.claude/commands" "$HOME/.gemini/skills/agent-skills-bundle"

save_global_bundle() {
  local src_tar="$1"
  cat "$src_tar" > "$HOME/.gemini/all-skills.tar.gz"
  cat "$src_tar" > "$HOME/.gemini/skills/agent-skills-bundle/all-skills.tar.gz"
  cat > "$HOME/.gemini/skills/agent-skills-bundle/SKILL.md" <<'EOF'
---
name: agent-skills-bundle
description: "Global bootstrap bundle for all 179 installed skills across projects and Google accounts. Restore with: tar -xzf ~/.gemini/skills/agent-skills-bundle/all-skills.tar.gz -C $HOME"
---

# Agent Skills Bundle (179 Skills)

Restore all 179 skills into `$HOME`:
```bash
tar -xzf ~/.gemini/skills/agent-skills-bundle/all-skills.tar.gz -C "$HOME" 2>/dev/null || (git clone --depth 1 https://github.com/samtran1991/agent-skills.git /tmp/agent-skills && cat /tmp/agent-skills/all-skills.tar.gz.part-* | tar -xzf - -C "$HOME" && rm -rf /tmp/agent-skills)
```
EOF
  for d in "$HOME/.agents/skills/"*; do
    if [ -d "$d" ] && [ -f "$d/SKILL.md" ]; then
      sname=$(basename "$d")
      mkdir -p "$HOME/.gemini/skills/$sname"
      cat "$d/SKILL.md" > "$HOME/.gemini/skills/$sname/SKILL.md"
    fi
  done
}

# Fast path: extract bundled all-skills.tar.gz (or split parts) if present
if [ "$FROM_SOURCE" = "0" ] && { [ -f "$SCRIPT_DIR/all-skills.tar.gz" ] || [ -f "$SCRIPT_DIR/all-skills.tar.gz.part-aa" ]; }; then
  echo "=== 1/2 Extracting bundled 179-skill archive to $HOME ==="
  if [ -f "$SCRIPT_DIR/all-skills.tar.gz" ]; then
    tar -xzf "$SCRIPT_DIR/all-skills.tar.gz" -C "$HOME"
    save_global_bundle "$SCRIPT_DIR/all-skills.tar.gz"
  else
    cat "$SCRIPT_DIR"/all-skills.tar.gz.part-* > /tmp/all-skills-combined.tar.gz
    tar -xzf /tmp/all-skills-combined.tar.gz -C "$HOME"
    save_global_bundle /tmp/all-skills-combined.tar.gz
    rm -f /tmp/all-skills-combined.tar.gz
  fi
  echo "Done! Installed $(ls -1 "$HOME/.agents/skills" | wc -l) skills globally from archive."
  exit 0
fi

WORK="/tmp/skills-bootstrap-$$"
mkdir -p "$WORK"
trap 'rm -rf "$WORK"' EXIT

REPOS=(
  "coreyhaines31/marketingskills"
  "mbfinotti/advertising-skills"
  "Panniantong/agent-reach"
  "blader/humanizer"
  "nidhinjs/prompt-master"
  "AgriciDaniel/claude-blog"
  "hugohe3/ppt-master"
  "nextlevelbuilder/ui-ux-pro-max-skill"
  "anthropics/skills"
  "Ryze-AI-Adgent/open-seo-mcp-skills"
  "AminForou/mcp-gsc"
  "googleanalytics/google-analytics-mcp"
  "google/adk-docs"
  "ai-job-search-dev/ai-job-search"
  "trussary/vietnamese-language-skill"
)

echo "=== 1/3 Cloning 15 skill repositories ==="
for repo in "${REPOS[@]}"; do
  name=$(basename "$repo")
  echo "  -> $repo"
  git clone --depth 1 --quiet "https://github.com/${repo}.git" "$WORK/$name"
done

echo "=== 2/3 Installing skills to ~/.agents/skills and ~/.claude/skills ==="
cp -r "$WORK/marketingskills/skills/"* "$HOME/.agents/skills/"
cp -r "$WORK/advertising-skills/skills/"* "$HOME/.agents/skills/"

mkdir -p "$HOME/.agents/skills/agent-reach"
cp -r "$WORK/agent-reach/agent_reach/skill/"* "$HOME/.agents/skills/agent-reach/"

mkdir -p "$HOME/.agents/skills/humanizer"
cp -r "$WORK/humanizer/SKILL.md" "$WORK/humanizer/agents" "$WORK/humanizer/scripts" "$HOME/.agents/skills/humanizer/" 2>/dev/null || true

mkdir -p "$HOME/.agents/skills/prompt-master"
cp -r "$WORK/prompt-master/SKILL.md" "$WORK/prompt-master/references" "$HOME/.agents/skills/prompt-master/" 2>/dev/null || true

CLAUDE_BLOG_SKIP_PIP=1 bash "$WORK/claude-blog/install.sh" --force-adopt >/dev/null
cp -r "$HOME/.claude/skills/"* "$HOME/.agents/skills/"
mkdir -p "$HOME/.agents/skills/claude-blog-brain"
cp -r "$WORK/claude-blog/brain/"* "$HOME/.agents/skills/claude-blog-brain/"

cp -r "$WORK/ppt-master/skills/ppt-master" "$HOME/.agents/skills/"
cp -r "$WORK/ui-ux-pro-max-skill/.claude/skills/"* "$HOME/.agents/skills/"
cp -r "$WORK/skills/skills/"* "$HOME/.agents/skills/"

for d in "$WORK/open-seo-mcp-skills/skills/"*; do
  sname=$(basename "$d")
  if [ "$sname" = "seo-audit" ]; then
    mkdir -p "$HOME/.agents/skills/open-seo-audit"
    cp -r "$d/"* "$HOME/.agents/skills/open-seo-audit/"
    sed -i 's/^name: seo-audit/name: open-seo-audit/' "$HOME/.agents/skills/open-seo-audit/SKILL.md"
  else
    cp -r "$d" "$HOME/.agents/skills/"
  fi
done

cp -r "$WORK/mcp-gsc/skills/"* "$HOME/.agents/skills/"

find "$WORK/adk-docs" -iname "SKILL.md" | while read -r smd; do
  cp -r "$(dirname "$smd")" "$HOME/.agents/skills/"
done

mkdir -p "$HOME/.agents/skills/google-analytics-mcp/references"
cat > "$HOME/.agents/skills/google-analytics-mcp/SKILL.md" <<'EOF'
---
name: google-analytics-mcp
description: "Set up, configure, and use the official Google Analytics MCP Server (analytics-mcp) to query Google Analytics 4 (GA4) Admin and Data APIs. Covers account/property discovery (get_account_summaries, get_property_details, list_google_ads_links, list_property_annotations, list_key_events), core reporting (run_report, run_funnel_report, run_conversions_report, get_custom_dimensions_and_metrics), realtime reporting (run_realtime_report), and write operations (--allow-write for create_property_annotation, create_custom_dimension, create_key_event)."
license: Apache-2.0
---

# Google Analytics MCP (`googleanalytics/google-analytics-mcp`)

Use this skill when setting up, troubleshooting, or running queries against the official Google Analytics MCP server (`analytics-mcp`).
See `references/README.md` and `references/TROUBLESHOOTING.md` for full tool documentation and setup.
EOF
cp -r "$WORK/google-analytics-mcp/README.md" "$WORK/google-analytics-mcp/TROUBLESHOOTING.md" "$WORK/google-analytics-mcp/analytics_mcp" "$WORK/google-analytics-mcp/examples" "$HOME/.agents/skills/google-analytics-mcp/references/"

cp -r "$WORK/ai-job-search/.agents/skills/"* "$HOME/.agents/skills/"
cp -r "$WORK/ai-job-search/.claude/skills/"* "$HOME/.agents/skills/"
cp -r "$WORK/ai-job-search/.claude/agents/"* "$HOME/.claude/agents/" 2>/dev/null || true
cp -r "$WORK/ai-job-search/.claude/commands/"* "$HOME/.claude/commands/" 2>/dev/null || true

cp -r "$WORK/vietnamese-language-skill/skills/"* "$HOME/.agents/skills/"

rm -rf "$HOME/.claude/skills" && mkdir -p "$HOME/.claude/skills"
cp -al "$HOME/.agents/skills/"* "$HOME/.claude/skills/" 2>/dev/null || cp -rn "$HOME/.agents/skills/"* "$HOME/.claude/skills/"

echo "=== 3/3 Syncing global ~/.gemini/skills and bundle ==="
tar -czf "$WORK/all-skills.tar.gz" -C "$HOME" .agents/skills .claude/skills .claude/agents .claude/commands .claude/claude-blog-manifest.txt
save_global_bundle "$WORK/all-skills.tar.gz"

echo "Done! Installed $(ls -1 "$HOME/.agents/skills" | wc -l) skills globally."
