---
name: raise-issue
description: >
  File issues in upstream or user-specified repositories.
  Use when the user asks to raise, file, or report an issue;
  check for existing duplicates before creating one.
---

# Raise an issue

1. **Identify the destination.** Use the user's explicit repository; otherwise
   identify upstream from project or package metadata. Read its contribution
   guidance, issue templates, and security-reporting policy. Ask only if the
   destination remains ambiguous after checking available context.

2. **Check for duplicates.** Search open and closed issues and relevant pull
   requests using distinctive error text and symptom synonyms. Read likely
   matches: shared wording alone does not establish a duplicate.
   - If an existing report covers the same underlying problem, do not create
     another issue or comment. Return its URL and explain the overlap.
   - If a related report does not cover this problem, explain the distinction
     and link it in the new report when useful.
   - If search fails or access is incomplete, do not claim there are no
     duplicates. Report the limitation and stop before publishing unless the
     user explicitly authorizes proceeding despite it.

3. **Prepare the report.** Follow the repository's template and requirements.
   Use a concise, descriptive title. For bugs, include reproduction steps,
   expected and actual behavior, and relevant versions and logs. For feature
   requests, describe the use case and desired behavior. Use supplied or
   observed evidence; separate observations from hypotheses. Never invent
   reproduction results, versions, logs, or other missing facts. Mark unknowns;
   ask only when missing information is necessary for a useful, compliant report.

4. **Check publication boundaries.** Respect read-only and draft-only requests:
   do not publish issues or comments in those modes. Remove secrets and
   irrelevant private data from the report and attachments. For suspected
   vulnerabilities, follow the repository's private security-reporting process;
   if none is documented, ask for a private destination rather than posting
   sensitive details publicly.

5. **Publish and verify.** When the user requests filing and the checks above
   pass, create the issue in the selected repository. Confirm creation from
   the tool response or a read-back and return the actual issue URL. If
   creation fails, report the failure rather than claiming success. If the
   outcome is uncertain, check whether the issue exists before retrying to
   avoid duplicates. For draft-only requests, return the proposed title and
   body without publishing.
