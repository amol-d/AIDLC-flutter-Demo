# AIDLC Automation

The AI-driven development lifecycle this repo demonstrates, end to end.

Two interchangeable AI backends drive the lifecycle; each activates only when its secret
exists, so the repo is never red because of a missing key:

| Backend | Trigger | Secret | Workflows |
|---|---|---|---|
| **OpenAI Codex** (active) | `@codex` | `OPENAI_API_KEY` | `codex.yml`, `openai-code-review.yml` |
| Claude Code (optional) | `@claude` | `ANTHROPIC_API_KEY` + Claude GitHub App | `claude.yml`, `claude-code-review.yml` |

## Inputs — how work arrives

1. **GitHub issue / PRD**: open an issue (the `Feature request` template is shaped like a
   mini-PRD) and mention `@codex` (or `@claude`) in the body or a comment.
1b. **Full PRD / BRD document**: for anything beyond a mini-PRD, write it with the
   [PRD/BRD template](templates/PRD-template.md), save it at `docs/prd/<slug>.md`, and open
   an issue: `@codex implement the PRD at docs/prd/<slug>.md`. The fixed structure maps
   directly onto the clean-architecture layers and its Given/When/Then acceptance criteria
   become tests.
2. **PR comment**: mention the agent on any PR to request changes or fixes.
3. **JIRA ticket**: with the JIRA template activated, tickets sync to issues (or paste
   the ticket text into an issue) — the `jira-ticket` skill governs how the agent turns a
   ticket into a branch/PR.
4. **Slack**: with the Slack template activated, deploy results post to a channel;
   inbound Slack->issue automation can be added the same way.
5. **Local**: run Claude Code in the repo; `CLAUDE.md` + `.claude/skills/*` apply.

## The loop

```
requirement (@codex mention in an issue)
   -> codex.yml: Codex CLI implements per AGENTS.md + feature-development skill,
      runs melos gen/analyze/test; the workflow pushes feature/codex-issue-<N>
      and opens a PR into dev, then comments the PR link on the issue
   -> ci.yml: analyze + tests + web/android builds
   -> openai-code-review.yml: AI review against the code-review skill checklist
   -> human merges PR into dev            -> deploy-dev.yml     (DEV)
   -> promotion PR dev -> preprod          -> deploy-preprod.yml (PREPROD)
   -> promotion PR preprod -> main         -> deploy-prod.yml    (PROD)
```

Per the promotion gate (see the deploy skill), each promotion PR requires explicit
user approval — merges are always human.

## Workflows

| File | Trigger | Purpose |
|---|---|---|
| `.github/workflows/codex.yml` | `@codex` in issues/issue comments | **Active dev agent** (OpenAI): implements the request with the Codex CLI (which reads AGENTS.md natively), then pushes a branch + opens a PR into dev. Flutter + melos installed first so it can run the verification loop. |
| `.github/workflows/openai-code-review.yml` | PR opened/updated | **Active reviewer** (OpenAI): Codex reviews the diff per the code-review skill and posts a PR comment. |
| `.github/workflows/claude.yml` | `@claude` mentions | Optional Anthropic dev agent; skips without `ANTHROPIC_API_KEY`. |
| `.github/workflows/claude-code-review.yml` | PR opened/updated | Optional Anthropic reviewer; skips without `ANTHROPIC_API_KEY`. |
| `.github/workflows/ci.yml` | PRs + pushes to dev/preprod/main | analyze, test:unit, web builds (both apps), Android debug build on PRs into preprod/main. |
| `.github/workflows/agent-autofix.yml` | CI run **failed** on a `feature/codex-issue-*` PR | Re-invokes Codex to fix its own PR from the failing logs, pushes the fix (re-triggers CI); bounded to 3 attempts. |
| `.github/workflows/promotion-guard.yml` | PR into preprod/main | Fails the required `promotion-guard` check unless the lower env's latest deploy+smoke succeeded. |
| `.github/workflows/deploy-*.yml` | push to dev/preprod/main | Firebase Hosting (web) + App Distribution (APK); DEV also runs a post-deploy **smoke** test. |

## Closing the loop

The pieces that make the loop run end-to-end without a human babysitting it:

- **CI on agent PRs** — `codex.yml`/`claude.yml` push and open the PR with a bot identity
  (`AIDLC_BOT_TOKEN` / a GitHub App), so CI and the AI review actually fire (the default
  `GITHUB_TOKEN` is muted by GitHub's anti-recursion rule). See
  [setup/github-setup.md](setup/github-setup.md) §2b.
- **Self-heal** — if CI fails, `agent-autofix.yml` feeds the failing logs back to Codex,
  which fixes and re-pushes (up to 3 attempts, then it asks for a human).
- **Enforced gates** — `analyze-test`, `build-web`, and `ai-review` are *required* status
  checks (`.github/settings.yml`), so nothing merges unless CI is green and the review ran.
- **Verified promotion** — DEV runs a post-deploy smoke test; `promotion-guard` blocks a
  `dev → preprod` (and `preprod → main`) PR until that smoke succeeded.

## Security & guardrails

The agent runs autonomously on a disposable runner, so its blast radius is fenced:

- **Trusted triggers only** — `codex.yml`/`claude.yml` run only when the issue/comment
  author is `OWNER`, `MEMBER`, or `COLLABORATOR`. Arbitrary users cannot drive the agent
  by opening an issue.
- **Untrusted-input framing** — the request text is written to a file and the agent is told
  to treat it as an untrusted product spec: implement only the described app feature and
  ignore any embedded instruction to reveal secrets, touch `.github/`/CI, or weaken tests.
- **No deploy secrets in the agent job** — agent jobs receive only the AI key (+ bot token
  for git); Firebase/signing secrets live solely in the deploy workflows.
- **Human approval before merge** — CI, AI review, and a required PR review gate every merge
  (`.github/settings.yml`); the agent proposes, a human approves.
- **Scanning** — `security.yml` runs gitleaks (committed secrets) and dependency-review
  (vulnerable deps + denied licenses); Dependabot keeps deps patched. `dart analyze
  --fatal-infos` in CI is the Dart SAST (CodeQL does not support Dart).
- **Bounded self-heal** — `agent-autofix` retries at most 3 times, then asks for a human.

## Agent knowledge

- `CLAUDE.md` / `AGENTS.md` — repo rules, commands, architecture.
- `.claude/skills/feature-development` — the layer-by-layer implementation recipe.
- `.claude/skills/code-review` — the review checklist the review workflow applies.
- `.claude/skills/deploy` — branch-promotion procedure.
- `.claude/skills/jira-ticket` — ticket -> feature workflow.

## Activation

Requires the `OPENAI_API_KEY` repo secret (Anthropic path additionally needs
`ANTHROPIC_API_KEY` + the Claude GitHub App) — see
[setup/github-setup.md](./setup/github-setup.md). Deploys additionally need Firebase
secrets — see [setup/firebase-setup.md](./setup/firebase-setup.md). JIRA/Slack/Figma are
inert templates in `.github/workflow-templates/` — see
[setup/integrations-jira-slack-figma.md](./setup/integrations-jira-slack-figma.md).

## Try it

1. Add the `OPENAI_API_KEY` secret.
2. Open an issue: *"@codex add a version label under the login button. Follow the
   feature-development skill."*
3. Watch the workflow push `feature/codex-issue-<N>`, open a PR into dev, and comment
   the link on the issue; review it (the AI reviewer comments too), then merge to `dev`
   and check the DEV deploy.
