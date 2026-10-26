---
name: cli-guidelines
description: >
  Build command-line interfaces that are delightful for humans and dependable in scripts.
  Use this skill when designing, implementing, or reviewing a command-line interface for
  human-friendly behavior and Unix composability, including help text, output, errors,
  arguments, flags, prompts, destructive operations, configuration, environment variables,
  and automation-safe behavior. Do not use it for full-screen terminal UIs or shell-language
  syntax alone.
license: CC-BY-SA-4.0; see LICENSE.txt
---

# Design Human-First Command-Line Interfaces

Design a CLI as a text-based user interface that serves people first while
remaining a dependable component in scripts and pipelines. Prefer established
terminal conventions, but break them deliberately when they materially harm
usability.

## Start with the operating contexts

Before proposing or changing an interface:

1. Identify the primary human workflows and the stable operations scripts need.
2. Inspect the existing commands, help, docs, output, exit codes, configuration,
   tests, and compatibility promises. Do not redesign from examples alone.
3. Separate interactive terminals from redirected or piped streams. Treat TTY
   detection as a behavior boundary, not a cosmetic detail.
4. Classify state changes as read-only, reversible, destructive, or remote.
5. Preserve established interfaces unless a change has a migration path.

For a new CLI, choose the smallest interface that completes the core workflow.
For an existing CLI, report current behavior separately from recommendations.

## Establish the baseline contract

Get these invariants right before adding polish:

- Use a mature argument parser when available.
- Exit with zero on success and nonzero on failure. Use distinct nonzero codes
  only when callers can act on the distinction.
- Write primary results and machine-readable data to `stdout`.
- Write explanations, progress, warnings, and errors to `stderr`.
- Validate inputs early, before changing state.
- Never mix prompts, decorations, or progress animation into piped data.

## Balance people and composition

Apply these principles together:

- **Human-first:** Optimize the normal invocation for clarity and confidence.
- **Composable:** Preserve streams, exit codes, signals, plain records, and
  structured output so the command works in unanticipated workflows.
- **Discoverable:** Teach through examples, help, corrections, state views, and
  suggested next commands.
- **Conversational:** Treat each invocation as one turn. Explain what happened,
  what failed, and what the user can do next without blaming them.
- **Responsive:** A command should acknowledge slow work quickly, show bounded
  progress, and remain interruptible.
- **Empathetic:** Avoid unexplained jargon, raw internals, surprise network or
  filesystem activity, and interfaces that make users feel trapped.

Follow convention when it makes behavior guessable. If convention conflicts
with the primary workflow, document the tradeoff and choose intentionally.

## Design help and documentation

Make `-h` and `--help` display help, including after subcommands. For a
command that needs more input, a no-argument invocation should normally show a
concise orientation unless interactivity is itself the default.

Concise help should contain:

- A one-sentence purpose
- A usage line
- One or two representative examples
- The common commands or flags, ordered by importance
- A pointer to `--help` or deeper help

Full help should lead with useful examples, cover every supported option, link
to web documentation, and provide a support or issue path. Keep extensive
tutorials and rare examples in separate documentation. Provide terminal-local
documentation where offline or version-matched access matters; consider man
pages where users will expect them.

When input is expected from a pipe but `stdin` is a TTY, fail promptly with an
example instead of appearing to hang.

## Shape output for its reader

Use TTY detection to adapt presentation without changing semantics:

- In a TTY, favor concise confirmation, readable grouping, intentional color,
  and progress for slow work.
- When `stdout` is redirected or piped, disable animations and emit stable,
  composable records.
- Provide `--plain` when the human layout is not reliably line-oriented.
- Provide `--json` when callers need structured data. Treat that schema as a
  compatibility surface.
- Provide `--quiet` when routine human-facing messages need suppression.
- Use a pager only for interactive output and only when it improves navigation.

Tell the user when state changed and make the resulting state inspectable.
Suggest a sensible next command when the workflow naturally continues. Require
explicit intent for activity beyond the command's obvious boundary, such as
accessing an unmentioned file or contacting a remote service.

Use color to carry a small amount of meaning, never as the sole carrier of
meaning. Disable it when the relevant stream is not a TTY, `NO_COLOR` is set,
`TERM=dumb`, or `--no-color` is passed. Check `stdout` and `stderr` separately.
Use symbols only when they improve scanning and remain understandable without
special glyph support.

Keep developer diagnostics behind `--debug` or `--verbose`. Do not prefix every
normal `stderr` message with log levels or internal context.

## Write actionable errors

Rewrite expected failures for humans. A good error states:

1. What failed
2. The relevant object or input
3. Why, when known
4. A concrete recovery action

Put the most important information where it will be seen, suppress repetitive
noise, and group related failures. Do not print a stack trace for a routine
mistake. For unexpected faults, preserve diagnostics in a debug mode or file
and provide an easy bug-report path with useful context and secrets removed.

When a likely typo has a safe correction, suggest it. Do not silently rewrite
input when the corrected action changes state or would establish ambiguous
syntax as a permanent interface.

## Design arguments, flags, and subcommands

Prefer named flags when positional meaning would be ambiguous or hard to extend.
Positional arguments remain appropriate for familiar primary operations and
repeated homogeneous inputs such as file lists.

- Give flags descriptive long forms. Reserve short forms for common operations.
- Reuse conventional names such as `--help`, `--version`, `--json`, `--quiet`,
  `--debug`, `--dry-run`, `--force`, `--output`, and `--no-input` with their
  conventional meanings.
- Make flags and subcommands order-independent where the parser permits it.
- Support `-` for `stdin` or `stdout` when accepting an input or output file.
- Provide an explicit value such as `none` when an optional flag value must be
  disabled; do not depend on an ambiguous empty value.
- Choose defaults for the common case instead of requiring permanent aliases.
- Never accept secrets directly in flags; process listings and shell history
  can expose them.

Introduce subcommands when they reduce genuine complexity or unite closely
related operations. Keep vocabulary, flag names, output, and noun/verb ordering
consistent across them. Avoid near-synonyms such as `update` and `upgrade` when
users cannot reliably distinguish them. Do not infer a catch-all subcommand or
accept arbitrary abbreviations: either prevents future command names. Explicit,
stable aliases are acceptable.

## Preserve interactivity without requiring it

Prompt only when `stdin` is a TTY. Every prompted value must also have a
noninteractive representation through a flag, argument, file, or `stdin`.

- Honor `--no-input` by never prompting; fail with the exact missing input and
  how to supply it.
- Do not echo passwords or other secrets.
- Make escape and cancellation obvious. Keep Ctrl-C effective during network
  waits and child-process execution.
- Confirm dangerous actions in interactive use and provide an explicit,
  scriptable equivalent.

Scale confirmation to risk:

- Mild and explicit local changes may need no extra prompt.
- Moderate, remote, bulk, or hard-to-undo changes should offer a dry run and
  request confirmation.
- Severe changes should require a nontrivial identifier, with a scriptable form
  such as `--confirm=<resource-name>`.

Account for implicit destruction, such as a configuration change that reduces
a desired count and deletes resources.

## Build for interruption and failure

- Acknowledge work promptly; show progress for long operations without corrupting
  non-TTY output.
- Set reasonable network timeouts and allow them to be configured.
- Make retries safe and resumable where possible. Prefer idempotent steps.
- Avoid cleanup requirements when state can instead be repaired on the next run.
- On Ctrl-C, acknowledge interruption immediately and bound cleanup time. Allow
  a second interrupt to skip lengthy cleanup when safe, and explain the effect.
- Expect concurrent runs, weak networks, malformed data, wrappers, scripts, and
  platform filesystem differences.
- If parallel work makes progress unreadable or recovery fragile, prefer the
  simpler execution model.

## Keep interfaces future-compatible

Treat command names, flags, arguments, exit behavior, configuration keys,
environment variables, and machine-readable output as public interfaces.

- Prefer additive changes.
- Before a breaking change, warn on the old usage and show the replacement.
- Stop warning once the user adopts the replacement where practical.
- Direct scripts to `--plain` or `--json`; human-facing output may evolve.
- Avoid dependencies on mutable remote behavior that can make an installed CLI
  stop working unexpectedly.

## Place configuration deliberately

Choose the mechanism by lifetime and scope:

- Use flags for values likely to change per invocation.
- Use environment variables for values that vary with execution context.
- Use a version-controlled, command-specific file for stable project policy.
- Use user configuration for stable per-user preferences.

Apply precedence from highest to lowest: flags, current environment, project
configuration, user configuration, then system configuration. Follow the XDG
Base Directory Specification on systems where it applies. Ask before modifying
another program's configuration and describe the exact change; prefer a new,
owned file over editing a shared one.

Environment variable names should use uppercase letters, digits, and underscores
and should not start with a digit. Prefer single-line values and established
variables such as `NO_COLOR`, `EDITOR`, proxy variables, `SHELL`, `TERM`,
`TMPDIR`, `HOME`, `PAGER`, `LINES`, and `COLUMNS` where their semantics fit.
Do not commandeer common names.

Use `.env` only for simple, project-local contextual values. Do not treat it as
a typed, versioned configuration system. Prefer credential files, pipes, local
sockets, platform secret stores, or secret-management services over flags or
environment variables for secrets.

## Minimize installation surprise and telemetry

Use a short, memorable, lowercase command name that is easy to type and does
not collide with common tools. Prefer a single binary when it suits the language;
otherwise use a native package mechanism. Make uninstalling straightforward and
avoid scattering unmanaged files.

Do not send usage or crash data without informed consent. Explain what is
collected, why, how it is protected, and how to disable it. Prefer opt-in. Before
adding telemetry, consider documentation analytics, download counts, and direct
user feedback.

## Validate the resulting CLI

Exercise representative paths instead of reviewing copy alone:

1. Success, validation failure, expected operational failure, and unexpected
   failure
2. `--help`, subcommand help, no arguments, and a likely typo
3. Interactive TTY, piped `stdout`, redirected `stderr`, and `stdin` without a TTY
4. `--plain`, `--json`, `--quiet`, `--no-input`, `--no-color`, and `NO_COLOR`
   where supported
5. Destructive dry run, declined confirmation, confirmed action, and automation
6. Slow operation, timeout, retry, and Ctrl-C during work and cleanup
7. Configuration precedence and absence of optional configuration
8. Secret redaction in process arguments, output, debug logs, and bug reports

Finish with a concise finding or implementation summary. Distinguish required
correctness fixes from usability improvements and intentional exceptions.

## Scope boundary

Apply this skill to conventional command-line programs and their text interfaces.
Do not use it as the primary guide for full-screen terminal applications such as
editors, dashboards, or games. Do not let it replace language-specific parser,
security, accessibility, packaging, or platform documentation.

## Consult the original guide when needed

Use this distilled workflow by default. Read
[references/cli-guidelines.md](references/cli-guidelines.md) when the task needs
the original wording, complete examples, citations, historical rationale, or a
guideline detail not resolved by this file. The reference is a verbatim snapshot,
so distinguish its original recommendations from any later project-specific
decision or implementation.

## Attribution

This skill is adapted from *Command Line Interface Guidelines*. Read
[ATTRIBUTION.md](ATTRIBUTION.md) for source identification and modifications,
and [LICENSE.txt](LICENSE.txt) for the CC BY-SA 4.0 terms that apply to this
adaptation.
