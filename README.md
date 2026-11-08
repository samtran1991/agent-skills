# Agent Skills Bootstrap (`179 Skills`)

One-command installer and pre-packaged `tar.gz` bundle for all **179 AI Agent Skills** across 15 repositories.

## 1. Fast Install in Any New Google Account (Uses Pre-Built Tar Bundle)

```bash
git clone --depth 1 https://github.com/samtran1991/agent-skills.git /tmp/agent-skills && bash /tmp/agent-skills/install-all-skills.sh && rm -rf /tmp/agent-skills
```

Or extract the `tar.gz` bundle directly into `$HOME`:

```bash
git clone --depth 1 https://github.com/samtran1991/agent-skills.git /tmp/agent-skills && cat /tmp/agent-skills/all-skills.tar.gz.part-* | tar -xzf - -C "$HOME" && rm -rf /tmp/agent-skills
```

## 2. Instant Restore Within the Same Google Account (`~/.gemini/all-skills.tar.gz`)

```bash
tar -xzf ~/.gemini/all-skills.tar.gz -C "$HOME"
```

## 3. Rebuild Fresh From All 15 Upstream GitHub Repos

```bash
git clone --depth 1 https://github.com/samtran1991/agent-skills.git /tmp/agent-skills && bash /tmp/agent-skills/install-all-skills.sh --from-source && rm -rf /tmp/agent-skills
```

## Included Repositories (179 Skills)
1. `coreyhaines31/marketingskills` (53 skills)
2. `mbfinotti/advertising-skills` (31 skills)
3. `Panniantong/agent-reach` (1 skill)
4. `blader/humanizer` (1 skill)
5. `nidhinjs/prompt-master` (1 skill)
6. `AgriciDaniel/claude-blog` (33 skills + 5 agents)
7. `hugohe3/ppt-master` (1 skill)
8. `nextlevelbuilder/ui-ux-pro-max-skill` (7 skills)
9. `anthropics/skills` (19 skills)
10. `Ryze-AI-Adgent/open-seo-mcp-skills` (8 skills, with `seo-audit` aliased as `open-seo-audit`)
11. `AminForou/mcp-gsc` (4 skills)
12. `googleanalytics/google-analytics-mcp` (1 skill)
13. `google/adk-docs` (6 skills)
14. `ai-job-search-dev/ai-job-search` (9 skills + agents/commands)
15. `trussary/vietnamese-language-skill` (5 skills)
