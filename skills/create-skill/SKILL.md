---
name: create-skill
description: Use this standards-first skill when creating or refining a portable, client-neutral Agent Skill that must follow agentskills.io, including requests to distill real tasks, project artifacts, or execution feedback into a SKILL.md-based skill folder and validate, evaluate, or optimize it.
---

# Create Agent Skills

Create the smallest skill that reliably adds knowledge or procedure an agent would otherwise lack. Ground it in real work, keep it portable, and prove that it helps.

## Use the current standard

Treat [agentskills.io/specification](https://agentskills.io/specification) as the format authority. Recheck it when internet access is available and current compliance matters. Use the site's authoring guides for [best practices](https://agentskills.io/skill-creation/best-practices), [description optimization](https://agentskills.io/skill-creation/optimizing-descriptions), [output evaluation](https://agentskills.io/skill-creation/evaluating-skills), and [scripts](https://agentskills.io/skill-creation/using-scripts).

Distinguish specification requirements from recommendations and client behavior. The standard defines the portable skill directory, not universal installation paths, registration commands, activation APIs, permission systems, or UI metadata.

## Workflow

### 1. Ground the skill in evidence

Inspect the target workspace, its instructions, and any existing skill before editing. Preserve unrelated work and update an existing skill in place rather than replacing it blindly.

Extract expertise from the best available sources:

- A successfully completed task and the sequence that worked
- User corrections, preferences, and rejected approaches
- Runbooks, API specifications, schemas, templates, and style guides
- Review history, recurring failures, and verified fixes
- Execution traces from earlier uses of the skill

Define two or three realistic requests the skill should handle and at least two near-misses it should not claim. Identify the reusable outcome, required inputs, and scope boundary. Ask one focused question only when missing information would materially change the skill; otherwise make a conservative assumption and proceed.

Do not create a skill from generic filler. If the agent already performs the whole task well without special context, first identify the concrete procedure, constraint, or resource the skill will add.

### 2. Choose one coherent capability

Give the skill a scope broad enough to complete a useful workflow but narrow enough to activate precisely and compose with other skills. Split unrelated capabilities; combine steps that normally belong to one outcome.

Choose a short, action-led name. The name must:

- Contain 1-64 characters using only `a-z`, `0-9`, and hyphens
- Have no leading, trailing, or consecutive hyphens
- Match the skill directory name exactly

Use the destination requested by the user. If none is given, inspect the target client's documentation or local conventions before choosing. Do not present `.agents/skills/`, `.codex/skills/`, or another client location as a requirement of the Agent Skills specification.

### 3. Plan the minimum contents

Always create `SKILL.md`. Add other files only when they earn their context or maintenance cost:

| Path | Add it when |
| --- | --- |
| `scripts/` | Repeated or fragile work benefits from deterministic executable code |
| `references/` | Detailed knowledge should load only for a specific situation |
| `assets/` | Templates, media, or data are copied or used in produced output |
| `evals/` | Structured development tests will be retained with the skill |
| Client-specific files | The user, target client, or repository convention requires them |

Do not create empty directories, duplicate the same guidance across files, or add auxiliary documents such as `README.md`, changelogs, and installation guides unless the target repository explicitly requires them.

Check licenses before adapting third-party skills or substantial source material. Preserve required license and attribution files, mark modifications when the license requires it, and prefer original synthesis over copied prose.

### 4. Write `SKILL.md`

Start with YAML frontmatter followed by Markdown:

```markdown
---
name: example-skill
description: Use this skill when the user needs [outcome], including [specific intents and artifacts].
---

# Example Skill

[Imperative instructions for performing the workflow.]
```

Apply these frontmatter rules:

| Field | Rule |
| --- | --- |
| `name` | Required; follow the naming constraints above and match the parent directory |
| `description` | Required; 1-1024 characters; state what the skill enables and when to use it |
| `license` | Optional; use a short license name or a reference to a bundled license file |
| `compatibility` | Optional; 1-500 characters; include only genuine environment requirements |
| `metadata` | Optional; map string keys to string values |
| `allowed-tools` | Optional and experimental; use a space-separated string only when the target client supports it |

Make the description an imperative routing instruction such as `Use this skill when ...`. Describe user intent rather than internal implementation. Include concrete tasks, artifacts, synonyms, and implicit contexts that distinguish the skill from adjacent capabilities. Keep it concise; do not turn it into a summary of the body. Quote or use a YAML block scalar for values whose punctuation could be misparsed.

Write the body as a reusable procedure:

- Use imperative instructions and a clear default path.
- Explain non-obvious reasons that help the agent adapt correctly.
- Match control to fragility: allow judgment where several approaches work; prescribe exact sequences where mistakes are costly.
- Prefer procedures, decision rules, concise examples, checklists, output templates, and concrete gotchas over broad declarations.
- Keep always-needed constraints and surprising gotchas in `SKILL.md`.
- Keep `SKILL.md` below 500 lines and roughly 5,000 tokens.

### 5. Apply progressive disclosure

Design for three loading layers:

1. `name` and `description` route the task during discovery.
2. The complete `SKILL.md` body loads after activation.
3. Bundled resources load or execute only when needed.

Move lengthy APIs, schemas, variants, and situational examples into focused reference files. Link every support file directly from `SKILL.md` with a relative path from the skill root and state the condition for loading it, for example: `Read references/api-errors.md after a non-2xx response.` Keep references one level deep; avoid chains of references to references.

Keep output templates in `assets/` when they are too large or too situational to place inline. Treat assets as files to use in outputs, not documentation to load by default.

### 6. Design scripts for agents

Bundle a script only after repeated use shows that code is being reconstructed or deterministic handling matters. Test every added script on a representative success case and failure case.

Make scripts:

- Non-interactive; accept input through arguments, environment variables, or stdin
- Self-contained or explicit about pinned dependencies and runtime requirements
- Discoverable through concise `--help` output and examples
- Helpful on failure by stating what was wrong, what was expected, and how to recover
- Machine-readable on stdout, with diagnostics on stderr when structured output matters
- Safe to retry, bounded in output, and equipped with dry-run or explicit confirmation for risky actions

Reference scripts with skill-root-relative paths. Declare real runtime or network requirements in `compatibility`; do not assume every client supports the same language, tools, or permissions.

### 7. Validate three separate gates

Do not treat one successful check as proof of the others.

1. **Structure:** Run `agentskills validate <skill-directory>` when the `agentskills` reference CLI is available. This checks frontmatter and naming, not instruction quality. Do not silently install it; if unavailable, check every hard rule manually and report that full reference validation was not run.
2. **Activation:** Confirm the client discovers the skill and loads `SKILL.md` for representative positive prompts but not near-misses. Registration and observability are client-specific, so inspect that client's documentation or logs.
3. **Execution:** Run realistic tasks and verify produced files, commands, and claims. Exercise bundled scripts directly and remove all placeholders, stale links, unused resources, and duplicated guidance.

For a quick quality pass, use two or three realistic cases, including an edge case, in clean contexts. Compare the skill against no skill or the previous version. Inspect outputs and traces, add objective assertions after seeing the first results, and retain only instructions that improve the outcome enough to justify their time and token cost.

For rigorous description tuning, use roughly 8-10 should-trigger prompts and 8-10 near-miss prompts with varied phrasing, detail, and explicitness. Run each more than once, keep a fixed train/validation split, revise from training failures, and select by validation performance. Finish with fresh prompts that were not used during optimization.

### 8. Iterate and hand off

Generalize from failures instead of patching the exact eval prompt. Tighten ambiguous instructions, cut steps that create wasted work, add a tested script when the same code recurs, and add a gotcha when a plausible assumption repeatedly fails. Stop when feedback is consistently empty or further changes do not materially improve results.

Report:

- The skill path and files created or changed
- The capability and boundaries encoded
- Structure, activation, and execution checks actually run
- Any client-specific metadata or behavior
- Validation gaps, untested requirements, or external dependencies
