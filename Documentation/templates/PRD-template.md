# PRD / BRD template for AIDLC

Copy this template, fill it in, and hand it to the agent (see **How to ingest** at the
bottom). The **fixed headings and the YAML front-matter are the contract** — the agent keys
off them to map your requirement onto the clean-architecture layers, so keep the structure
even when a section is "N/A".

Guiding rules for a smooth run:

- **Write acceptance criteria as Given / When / Then.** They become widget/bloc/integration
  tests almost verbatim — this is what makes test automation reliable.
- **Be explicit in Data & API** (method, path, every field, nullability, error cases). The
  agent maps this to DTOs + null-safe mappers; vagueness becomes tolerant-parsing guesses.
- **State non-goals and open questions.** The agent surfaces open questions instead of
  guessing (per the repo's "don't silently accept uncertain shapes" rule).
- **Keep it bounded.** One PRD = one shippable feature. Split epics into multiple PRDs.

---

## Copy from here

```markdown
---
id: PRD-001                 # stable id
title: <feature name>
type: PRD                   # PRD | BRD
status: draft               # draft | approved
target_env: dev             # dev | preprod | prod  (where this should ship)
priority: P2                # P0..P3
owner: <name>
related: [JIRA-123, "#45"]  # tickets / issues / Figma links
---

# 1. Summary
One or two sentences: what we are building and why.

# 2. Problem / background        <!-- BRD emphasis: the business need -->
The user/business problem this solves. Current pain, evidence if any.

# 3. Goals & non-goals
- Goal: …
- Goal: …
- Non-goal (explicitly out of scope): …

# 4. Users & user stories
- As a <role>, I want <capability> so that <benefit>.
- As a <role>, I want …

# 5. Acceptance criteria (testable)
1. Given <state>, when <action>, then <observable outcome>.
2. Given <state>, when <invalid input>, then <error/handling>.
3. …

# 6. Screens / UX
| Screen / route | States (loading / empty / error / success) | Navigation | Figma |
|---|---|---|---|
| `/example` | … | from … → to … | <frame link> |

# 7. Data & API
| Endpoint | Method | Auth | Request | Response (fields, nullability) | Errors / edge cases |
|---|---|---|---|---|---|
| `/path` | GET | Bearer | … | `field: string?`, `id: int` | 401 →, 200-with-error →, empty → |

Base URL is per-flavor (see `url_constants.dart`). Note any legacy/alternate field names.

# 8. Localization & content
User-facing strings (added to `intl_en.arb` AND `intl_hi.arb`):
- `key`: "English" / "हिन्दी"

# 9. Non-functional
- Accessibility: …
- Performance: …
- Security / privacy: no secrets logged; PII handling …
- Observability: events / errors to capture (Crashlytics, analytics).

# 10. Rollout
Target env(s) and order (dev → preprod → prod), feature flags, data migration, dependencies.

# 11. Open questions / assumptions
- Q: … (blocking? who decides?)
- Assumption: …

# 12. Definition of done
- [ ] Acceptance criteria 1..N implemented and covered by tests
- [ ] Tests at each layer (DTO wire-shape, use-case, bloc, widget)
- [ ] Strings in en + hi; barrels exported
- [ ] `analyze` + `test:unit` green; version bumped
- [ ] Docs updated if behaviour/architecture changed
```

## Worked example (filled, abridged)

```markdown
---
id: PRD-002
title: Show the signed-in user's last login time on Home
type: PRD
status: approved
target_env: dev
priority: P2
owner: amol
related: ["#61"]
---

# 1. Summary
Display the user's last-login timestamp on the Home screen so they can spot unexpected access.

# 4. Users & user stories
- As a signed-in user, I want to see when I last logged in so that I can notice suspicious activity.

# 5. Acceptance criteria (testable)
1. Given I am on Home, when the profile loads, then I see "Last login: <relative time>".
2. Given the API omits the field, when the profile loads, then no last-login row is shown (no crash).

# 7. Data & API
| Endpoint | Method | Auth | Response | Errors |
|---|---|---|---|---|
| `/auth/me` | GET | Bearer | add `lastLoginAt: string?` (ISO-8601, nullable) | missing field → hide row |

# 8. Localization & content
- `home_last_login`: "Last login: {time}" / "अंतिम लॉगिन: {time}"

# 12. Definition of done
- [ ] `lastLoginAt` parsed tolerantly (nullable), mapped to entity, shown via a formatted widget
- [ ] Mapper null test + bloc test + widget test
```

## How to ingest (the loop)

1. **Save the filled PRD** in the repo at `docs/prd/<slug>.md` (or attach/paste it into a
   GitHub issue). Committing it means it is versioned alongside the code it produces.
2. **Trigger the agent:** open an issue (the *Feature request* template links here) and write
   `@codex implement the PRD at docs/prd/<slug>.md` — or paste the PRD body under an
   `@codex` mention.
3. The agent parses the fixed sections, follows
   [feature-development](../../.claude/skills/feature-development/SKILL.md) (and, for large
   PRDs, the [planning](../../.claude/skills/planning/SKILL.md) skill — label the issue
   `needs-plan`), opens a PR into `dev`, and deploys per `target_env` through the promotion
   gate.

Metadata the automation reads: `target_env` (which environment to promote toward),
`type`/`status` (BRD vs PRD, draft vs approved), and `related` (to cross-link tickets).
