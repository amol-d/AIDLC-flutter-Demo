---
name: jira-ticket
description: Turn a JIRA ticket (or any PRD/BRD/issue text) into an implemented feature. Use when given a ticket ID, requirement document, or feature request to build.
---

# Ticket -> feature workflow

## 1. Extract requirements

From the ticket/PRD text, write down:
- User-visible behavior (screens, flows, copy)
- Data needs (entities, endpoints, error cases)
- Environment/flag concerns (dev-only? all flavors?)
- Acceptance criteria (turn each into a test)

If the ticket references JIRA and the integration is active, fetch details via the JIRA
workflow (see `Documentation/setup/integrations-jira-slack-figma.md`). Otherwise ask for
the ticket body inline.

## 2. Plan

Produce a short plan: files per layer (use the table in the `feature-development` skill),
test list, and any open questions. Post the plan as a comment on the issue/PR before
writing code when working via the @claude GitHub workflow.

## 3. Implement

Invoke the `feature-development` skill recipe. Branch name: `feature/<TICKET-ID>-<slug>`
(e.g. `feature/AIDLC-42-forgot-password`). Reference the ticket ID in the PR title and
every commit message.

## 4. Done means

- All acceptance criteria mapped to passing tests
- `dart run melos run analyze` + `test:unit` green
- PR into `dev` with: summary, ticket link, screenshots (run `app1` on chrome), test evidence
- Ticket transitioned/commented (if JIRA integration is active)
