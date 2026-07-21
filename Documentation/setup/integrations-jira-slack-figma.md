# JIRA / Slack / Figma Integrations

These ship as **inert templates** in `.github/workflow-templates/` so the repo works
without any external accounts. Activate each by copying it into `.github/workflows/` and
adding its secrets.

## JIRA — tickets drive development

Template: `.github/workflow-templates/jira-sync.yml`

Two directions are supported:
1. **JIRA → GitHub**: the template creates a JIRA issue for every labeled GitHub issue
   (using `atlassian/gajira-*` actions), keeping ticket IDs in sync. For the reverse
   (JIRA webhook → GitHub issue), point a JIRA automation rule at the
   `repository_dispatch` endpoint shown in the template header.
2. **Agent behavior**: `.claude/skills/jira-ticket` tells the agent how to turn ticket
   text into a `feature/<TICKET-ID>-<slug>` branch and PR.

Secrets: `JIRA_BASE_URL` (e.g. `https://yourorg.atlassian.net`), `JIRA_USER_EMAIL`,
`JIRA_API_TOKEN` (Atlassian account → Security → API tokens).

## Slack — commands and notifications

- **Outbound (active)**: `.github/workflows/slack-notify.yml` posts every DEV/PREPROD/PROD
  deploy result (name, branch, status, run link) to a channel. Just add the
  `SLACK_WEBHOOK_URL` secret (Slack app → Incoming Webhooks); it skips cleanly without it.
- **Inbound (optional)**: a Slack slash-command → GitHub `repository_dispatch` bridge is
  sketched in the template header; the dispatched event can open an issue that mentions
  `@claude`, closing the loop "Slack message → agent builds feature".

## Figma — designs as input

Template: `.github/workflow-templates/figma-mcp-snippet.yml`

Adds the Figma MCP server to the `claude.yml` agent so `@claude implement the login
screen from <figma-url>` lets the agent read frames, styles, and tokens directly.
Secret: `FIGMA_TOKEN` (Figma → Settings → Personal access tokens).

The snippet shows the `--mcp-config` block to merge into `claude.yml`'s `claude_args`.

## Order of activation

Each integration is independent. Typical demo order: GitHub secrets + Claude App first
(see [github-setup.md](./github-setup.md)), Firebase second, then JIRA/Slack/Figma as the
story requires.
