# AIDLC Automation

The AI-driven development lifecycle this repo demonstrates, end to end.

## Inputs — how work arrives

1. **GitHub issue / PRD**: open an issue (the `Feature request` template is shaped like a
   mini-PRD) and mention `@claude` in the body or a comment.
2. **PR comment**: mention `@claude` on any PR to request changes or fixes.
3. **JIRA ticket**: with the JIRA template activated, tickets sync to issues (or paste
   the ticket text into an issue) — the `jira-ticket` skill governs how the agent turns a
   ticket into a branch/PR.
4. **Slack**: with the Slack template activated, deploy results post to a channel;
   inbound Slack->issue automation can be added the same way.
5. **Local**: run Claude Code in the repo; `CLAUDE.md` + `.claude/skills/*` apply.

## The loop

```
requirement (@claude mention)
   -> claude.yml: agent plans, implements per feature-development skill,
      runs melos gen/analyze/test, pushes feature branch, opens PR into dev
   -> ci.yml: analyze + tests + web/android builds
   -> claude-code-review.yml: AI review against code-review skill checklist
   -> human merges PR into dev            -> deploy-dev.yml     (DEV)
   -> promotion PR dev -> preprod          -> deploy-preprod.yml (PREPROD)
   -> promotion PR preprod -> main         -> deploy-prod.yml    (PROD)
```

## Workflows

| File | Trigger | Purpose |
|---|---|---|
| `.github/workflows/claude.yml` | `@claude` in issues/PR comments/reviews | Interactive agent: implements features, answers questions, fixes PRs. Flutter + melos are installed first so the agent can run the verification loop. |
| `.github/workflows/claude-code-review.yml` | PR opened/updated | Automated review; posts findings as a PR review using the code-review skill rules. |
| `.github/workflows/ci.yml` | PRs + pushes to dev/preprod/main | analyze, test:unit, web builds (both apps), Android debug build on PRs into preprod/main. |
| `.github/workflows/deploy-*.yml` | push to dev/preprod/main | Firebase Hosting (web) + App Distribution (APK). |

## Agent knowledge

- `CLAUDE.md` / `AGENTS.md` — repo rules, commands, architecture.
- `.claude/skills/feature-development` — the layer-by-layer implementation recipe.
- `.claude/skills/code-review` — the review checklist the review workflow applies.
- `.claude/skills/deploy` — branch-promotion procedure.
- `.claude/skills/jira-ticket` — ticket -> feature workflow.

## Activation

Requires repo secrets (`ANTHROPIC_API_KEY`, optionally `OPENAI_API_KEY`) and the Claude
GitHub App — see [setup/github-setup.md](./setup/github-setup.md). Deploys additionally
need Firebase secrets — see [setup/firebase-setup.md](./setup/firebase-setup.md).
JIRA/Slack/Figma are inert templates in `.github/workflow-templates/` — see
[setup/integrations-jira-slack-figma.md](./setup/integrations-jira-slack-figma.md).

## Try it

1. Wire the secrets + install the Claude GitHub App.
2. Open an issue: *"@claude add a Settings screen with a language toggle (en/hi),
   reachable from Home. Follow the feature-development skill."*
3. Watch the agent open a PR, CI go green, the review bot comment, then merge to `dev`
   and check the DEV site.
