---
name: crap
description: Use this skill when the user asks to calculate, audit, rank, compare, or reduce CRAP scores in a codebase, or to find change-risk hotspots by combining cyclomatic complexity with automated-test coverage. Do not use it for coverage-only reports, generic code review, or complexity analysis that does not request CRAP.
---

# CRAP

Evaluate functions and methods with the CRAP metric and produce an evidence-backed maintenance-risk report. Analyze only unless the user also asks for changes.

## Use the metric correctly

For each routine `m`, calculate:

```text
CRAP(m) = comp(m)^2 * (1 - cov(m)/100)^3 + comp(m)
```

- Use McCabe cyclomatic complexity for `comp(m)`.
- Use automated-test coverage for the same routine, from `0` to `100`, for `cov(m)`.
- Prefer basis-path coverage, as used by the original metric. If unavailable, use per-routine branch coverage, then line or statement coverage, and name the approximation in the report.
- Calculate with full precision and round only displayed scores, normally to one decimal place.
- Flag scores greater than `30` by default. Treat this empirical threshold as a review trigger, not a quality verdict.

Never substitute cognitive complexity for cyclomatic complexity. Never assign file- or project-wide coverage to every routine. CRAP is a per-routine metric; do not sum scores into a project score or calculate it from averaged inputs.

## Establish the measurement boundary

1. Read repository instructions, manifests, test configuration, and relevant documentation.
2. Check the worktree state and preserve unrelated changes.
3. Use the user's requested paths or comparison points. Otherwise analyze production source and exclude generated, vendored, dependency, and build-output files. Exclude test code unless requested.
4. Reuse the repository's existing test, coverage, and complexity tooling. Do not install dependencies or change manifests merely to perform the analysis without the user's approval.
5. Record the revision, scope, exclusions, commands, tool versions, and coverage type so the result can be reproduced.

## Collect compatible inputs

1. Run the relevant automated tests with coverage enabled. If tests fail or coverage is incomplete, report that before using the data.
2. Collect cyclomatic complexity per function or method with source locations.
3. Collect coverage for the same routine. When coverage is line-granular, calculate the percentage from executable lines inside the routine's source range.
4. Join the measurements by canonical path, source range, and symbol. Check overloaded methods, nested functions, closures, generated code, and renamed paths rather than joining by name alone.
5. Calculate CRAP only where both measurements are valid. Keep missing or ambiguous measurements in a separate list; never silently treat missing coverage as zero.

For a small, explicitly named scope, manually count one plus the routine's decision points when no analyzer exists, and label the result manual. Do not claim a complete codebase audit from manual counting.

If only aggregate coverage is available, explain that a valid routine-level CRAP ranking cannot yet be produced. Report the complexity results and the missing coverage granularity instead of fabricating scores.

For comparisons, keep the scope, test suite, tool versions, coverage type, and threshold identical. Report added and removed routines separately instead of treating a missing routine as a zero score.

## Review the hotspots

Sort measured routines by descending CRAP score. Inspect the highest-ranked source and its tests before recommending action:

- Add characterization tests before refactoring risky untested behavior.
- Reduce unnecessary decisions when complexity remains the main contributor.
- Call out unreachable code, weak assertions, or misleading coverage when observed; coverage alone does not prove test quality.
- Prefer a focused recommendation for each hotspot over a generic demand for more tests.

A routine with complexity above `30` remains above the default threshold even at full coverage. Treat that as a strong refactoring candidate, subject to source inspection.

Do not call the count of flagged routines "CRAP load." The original CRAP load was a separate experimental estimate of tests needed to bring flagged methods below the threshold. Unless a chosen tool defines and calculates it, report the count and percentage of routines above the threshold instead.

## Report

Use this compact structure:

```markdown
# CRAP evaluation

## Scope and method
- Revision and paths: ...
- Tests and coverage: ...
- Complexity analyzer: ...
- Coverage approximation and exclusions: ...

## Summary
| Measured routines | Unmeasured routines | CRAP > 30 | Percentage | Highest score |
| ---: | ---: | ---: | ---: | ---: |
| ... | ... | ... | ... | ... |

## Hotspots
| CRAP | Complexity | Coverage | Routine | Location | Recommended next step |
| ---: | ---: | ---: | --- | --- | --- |
| ... | ... | ...% | ... | `path:line` | ... |

## Measurement gaps
- ...
```

Limit the hotspot table to the most actionable routines unless the user asks for the full data. Link claims to source locations and include exact commands. State clearly when the result uses a coverage proxy, incomplete tests, manual complexity, or a partial scope.

Use CRAP to prioritize investigation and safer changes, never to rank developers or replace correctness, security, coupling, cohesion, or test-quality review.

The formula and default threshold follow Alberto Savoia and Bob Evans' CRAP1 definition: <https://testing.googleblog.com/2011/02/this-code-is-crap.html>.
