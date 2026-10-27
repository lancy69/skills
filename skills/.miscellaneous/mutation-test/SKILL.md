---
name: mutation-test
description: Use this skill when the user asks to run, configure, interpret, compare, or improve mutation testing for a project's test suite, including requests to find surviving mutants, assess assertion strength, or measure a mutation score. Do not use it for ordinary test runs, coverage-only reports, fuzzing, or requests to mutate test files.
---

# Mutation Test

Evaluate a project's tests by applying one controlled mutation at a time to production code and checking whether the tests detect it. Run and report only unless the user also asks to improve the tests.

## Establish a safe scope

1. Read repository instructions, manifests, test configuration, and relevant documentation.
2. Check the worktree state and preserve unrelated changes.
3. Use the user's requested production paths, package, or comparison points. Otherwise choose the smallest meaningful production module supported by the runner; do not default a large repository to an unbounded whole-project run.
4. Exclude tests, generated code, vendored dependencies, fixtures, build output, and trivial declarations unless the repository already configures them intentionally.
5. Reuse the repository's existing mutation runner, configuration, scripts, and test command. Do not install a runner, add dependencies, or change configuration without approval.

If no mutation runner is configured, identify a currently maintained runner compatible with the project's language, build system, and test framework from its official documentation. Present the exact install and first-run changes, then request approval before applying them.

Mutation runners may rewrite files temporarily. Prefer a runner's temporary-copy or sandbox mode. Before using an in-place mode, verify its restoration behavior; do not use it on a dirty worktree if it could overwrite user changes. Never build an ad hoc search-and-replace mutator when an established runner is available.

## Prove the baseline

1. Run the unmodified test suite selected for the mutation run.
2. Stop if the baseline fails. A failing baseline can falsely make mutants appear killed.
3. Record the baseline command, result, duration, and any skipped or quarantined tests.
4. Preview or list the selected mutants when the runner supports it. Use the estimate to bound the scope, concurrency, and timeout.

If the baseline is flaky, rerun it enough to identify the instability and report that mutation results would be unreliable. A mutant is not meaningfully killed when the observed failure is unrelated to its change.

Do not skip the runner's own baseline unless the same revision and test selection already passed in the current workflow and the runner documents how to supply an appropriate timeout.

## Run the mutations

1. Use the project's documented non-interactive command and existing configuration.
2. Mutate production behavior, not tests. Use targeted file, package, class, or diff filters when supported.
3. Keep timeouts enabled because mutations can introduce infinite loops. Base them on the measured baseline or the runner's documented automatic calculation.
4. Capture the runner version, exact command, scope, mutation operators, test selection, concurrency, timeout, elapsed time, exit status, and report path.
5. After success, failure, or interruption, verify that production and test sources match the pre-run worktree state. Preserve user changes and report any generated artifacts.

If the run is too large, reduce the production scope instead of weakening the test selection until unrelated behavior can no longer detect a mutant. Explain the reduced boundary.

## Interpret outcomes

Use the runner's definitions and retain the raw counts:

- **Killed:** at least one test failed because of the mutation.
- **Survived:** covering tests passed; inspect for a missing or weak assertion.
- **No coverage:** no selected test executed the mutated behavior.
- **Timeout:** the mutation caused the selected tests to exceed the limit; report whether the runner counts this as detected.
- **Compile, runtime, or non-viable error:** the mutant could not be evaluated; do not present it as killed.
- **Ignored or pending:** the mutant was not evaluated; keep it outside the completed score.

Prefer the runner's reported mutation score and reproduce its numerator and denominator. When the runner provides no formula, use this fallback and label it explicitly:

```text
detected = killed + timeout
valid = detected + survived + no_coverage
mutation_score = detected / valid * 100
```

Exclude compile errors, runtime errors, ignored mutants, and pending mutants from that fallback denominator. Do not compare scores from different formulas, operators, scopes, test selections, or runner versions.

A survivor is evidence to inspect, not automatic proof of a bad test. Check whether the mutant is behaviorally equivalent, irrelevant to supported behavior, or genuinely killable. Justify equivalent-mutant classifications from the source semantics; do not label inconvenient survivors equivalent to inflate the score.

## Review actionable survivors

Inspect each high-value survivor alongside the relevant tests. Prioritize mutations affecting conditions, boundaries, return values, state changes, error handling, authorization, money, persistence, or public behavior.

Recommend the smallest behavioral test that would distinguish the original program from the mutant. Avoid tests coupled only to implementation details and avoid changing production behavior merely to kill a mutant. Prefer excluding semantically irrelevant operators or code through documented configuration over adding meaningless assertions.

If the user asks to improve the tests:

1. Add the minimum test that captures intended behavior.
2. Run that test normally.
3. Rerun only the relevant mutant or narrow mutation scope when supported.
4. Run the affected normal test suite again.
5. Report which survivors were killed and which remain.

## Compare runs

Keep the revision boundary, production scope, test selection, runner version, operators, configuration, timeouts, and score formula identical. Report added, removed, and changed mutants separately; do not treat a missing mutant as killed.

## Report

Use this compact structure:

```markdown
# Mutation test

## Scope and method
- Revision and production scope: ...
- Baseline test command: ...
- Mutation runner and command: ...
- Operators, test selection, timeout, and exclusions: ...

## Summary
| Generated | Valid | Killed | Survived | No coverage | Timeout | Errors | Score |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| ... | ... | ... | ... | ... | ... | ... | ...% |

## Actionable survivors
| Status | Mutation | Location | Evidence | Recommended test |
| --- | --- | --- | --- | --- |
| ... | ... | `path:line` | ... | ... |

## Limitations and artifacts
- ...
```

Limit the survivor table to the most actionable results unless the user requests the full report. Link to source and generated reports, distinguish no-coverage gaps from weak assertions, and state whether the worktree was unchanged after the run.

Do not invent a universal passing threshold or optimize for 100%. Mutation testing measures the selected mutations and tests; it does not replace correctness, integration, security, performance, or test-design review.

Outcome and score terminology follows Mutation Testing Elements: <https://stryker-mutator.io/docs/mutation-testing-elements/mutant-states-and-metrics/>. Equivalent-mutant and runner-error caveats are illustrated by PIT: <https://pitest.org/quickstart/basic_concepts/>.
