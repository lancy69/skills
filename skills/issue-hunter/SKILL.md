---
name: issue-hunter
description: Use this skill to hunt for credible unassigned GitHub issues in a repository, reject spam or non-actionable reports, rank worthwhile candidates as easy, medium, or high difficulty, and help the user claim one with a comment. Accept repository inputs such as owner/repo or a full GitHub URL. Do not use it for filing new issues or triaging a private backlog.
compatibility: Requires network access to GitHub. Posting a claim comment requires authenticated GitHub issue-comment access.
---

# Issue Hunter

Find worthwhile GitHub issues that are plausibly available, explain their difficulty, then help the user claim one.

## Inspect the repository

1. Normalize `owner/repo` or a GitHub repository URL to `owner/repo`. Reject malformed inputs and confirm that the repository and issue tracker are accessible.
2. Prefer an available GitHub tool or MCP server. Otherwise use `gh` or GitHub's API, then fall back to web browsing for read-only discovery. Do not install a connector or dependency just for this workflow.
3. Read the repository's current contribution guide, issue templates, security policy, and claim instructions when present. Follow repository-specific commands or etiquette over the defaults below.
4. Record when the scan ran and its boundary. Do not imply an exhaustive review if pagination, permissions, rate limits, or search limits prevented one.

## Find candidates

Search open issues with no assignee. Use labels such as `good first issue`, `help wanted`, bug, or enhancement only as discovery hints; never treat a label as proof of quality, availability, or difficulty.

Keep an issue only when all of these are true:

- It describes a concrete bug, accepted feature, or bounded maintenance task in the repository's scope.
- The issue, maintainer discussion, reproduction, or relevant source provides enough evidence to identify useful work.
- It is not spam, a test issue, an incoherent or content-free report, a duplicate, invalid, support-only, already fixed, or blocked indefinitely on missing reporter information.
- It does not expose a security vulnerability that belongs in the repository's private reporting channel.

Do not fill a quota with weak issues. An empty difficulty group is better than a misleading recommendation.

## Verify availability

For every candidate, inspect the full current issue, comments, labels, timeline or cross-references, and linked pull requests. Exclude it when any of these indicate active ownership:

- an assignee;
- a human saying they are working on it or a maintainer reserving it for someone;
- an open implementation pull request or clearly active public branch;
- a bot or workflow already planning, implementing, or claiming it;
- repository-specific claim state that marks it unavailable.

“No assignee” alone never means “unclaimed.” If availability remains ambiguous, omit the issue or label it clearly as needing maintainer confirmation; do not present it as available.

## Rate difficulty

Inspect relevant source and tests when accessible. Use labels only as supporting evidence.

- **Easy:** narrow and well-specified; likely localized to one component; the expected behavior is clear; testing is straightforward; little domain or architectural uncertainty.
- **Medium:** requires investigation or coordinated changes across several paths; has meaningful edge cases or integration testing; the design is still bounded.
- **High:** crosses architecture, public APIs, migrations, concurrency, security, performance, or several platforms; reproduction or design is uncertain; validation needs substantial domain knowledge or infrastructure.

Rate the work needed for a correct contribution, not the issue's word count. When evidence is insufficient, say so instead of guessing.

## Report and pause

List the strongest candidates under all three headings: `Easy`, `Medium`, and `High`. For each candidate include:

```markdown
- [#123: Issue title](issue URL) — Why it is actionable; why it appears unclaimed; difficulty rationale; important uncertainty, if any.
```

End with the scan time and any coverage limitation, then ask: **Which issue would you like to claim?** Do not comment, assign, fork, or modify anything before the user chooses.

## Claim the selected issue

Treat the user's selection as authorization to post one claim comment on that issue, unless they ask to review a draft first.

1. Immediately re-fetch the issue, assignees, newest comments, linked pull requests, automation state, and repository claim instructions. This final check must happen even if the report was produced moments ago.
2. If the issue is now closed, assigned, claimed, or under active implementation, do not comment. Explain the conflict and offer the remaining candidates.
3. Follow a repository-provided claim command or template exactly. Otherwise post a concise comment that shows understanding without promising a deadline:

   ```text
   I'd like to work on this. My understanding is that the change should [brief scope], with [brief validation]. Is it available for me to take?
   ```

4. Use an authenticated GitHub tool, MCP server, or `gh` to post. Never claim success from a prepared draft or an unverified tool response; re-fetch the comment or its URL after posting.
5. If no authenticated write tool is available, provide the exact draft and say that it was not posted. Do not ask for credentials in chat.

Comment on only the selected issue. Do not assign the user, start implementation, or claim additional issues unless explicitly requested.
