---
name: designer
description: >-
  Generate a reusable DESIGN.md design-system document from any user-provided
  artifact: text briefs, product ideas, brand notes, screenshots, mockups,
  images, existing DESIGN.md files, frontend codebases, HTML/CSS, design tokens,
  or mixed inputs. Use when Codex needs to extract, infer, or document visual
  direction, design language, UI tokens, component styling, layout rules, or
  implementation-ready design guidance before building, redesigning, auditing,
  or handing off a product UI.
---

# Designer

Create a `DESIGN.md` that acts as the source of truth for a product's visual language. Ground the document in the user's artifacts first, then make conservative designerly inferences where the artifact is incomplete.

## Workflow

### 1. Gather Evidence

Identify every artifact the user provided and treat it as design evidence:

- Text or product brief: extract audience, tone, content types, domain constraints, platform, and implied workflows.
- Image, screenshot, or mockup: inspect layout, hierarchy, colors, typography character, density, spacing, shapes, shadows, and component patterns.
- Codebase or source files: read design-token files first, then global styles, theme config, root layout, and representative components.
- HTML/CSS: inspect linked and inline styles, CSS custom properties, font loading, major selectors, media queries, and repeated component classes.
- Existing design docs: preserve explicit decisions unless the user asks to revise them.

Prefer direct evidence over invention. If a value is inferred, make it plausible and label it as a recommendation in prose rather than pretending it was present in the artifact.

### 2. Choose Extraction Strategy

For code, detect the styling source before reading deeply:

- Tailwind: inspect `tailwind.config.*`, `globals.css`, `index.css`, and representative `className` usage.
- React/Next: inspect `package.json`, `src/app/layout.*`, `src/App.*`, theme/token files, and components.
- Vue/Nuxt/Svelte/Angular: inspect framework config, global CSS, component style blocks, and theme/plugin files.
- Plain CSS/Sass/Less: inspect HTML entry points, main stylesheets, variables/tokens files, and media queries.
- Component libraries: inspect override/theme files, not just library defaults.

For images or text-only briefs, create a coherent token system from the observed or requested mood, domain, and UX needs. Do not overfit a screenshot's accidental browser chrome, sample content, compression artifacts, or one-off decorative elements.

### 3. Extract Design Dimensions

Cover these dimensions in order:

1. Visual theme and atmosphere: mood, design philosophy, density, contrast, warmth/coolness, and interaction feel.
2. Colors: group by functional role, not hue. Include descriptive names, hex values when known or recommended, and usage rules.
3. Typography: font families, character, hierarchy, weights, line heights, letter spacing, and usage contexts.
4. Layout and spacing: grid, max widths, responsive breakpoints, page margins, section rhythm, and touch-target expectations.
5. Depth and shape: radius scale, shadows, borders, translucency, blur, elevation hierarchy.
6. Components: buttons, cards, navigation, inputs/forms, tables/lists, feedback states, and domain-specific primitives.
7. Assets and imagery: illustration/photo style, icon style, charts, avatars, product imagery, and empty/loading states when relevant.

When source values are numerous, deduplicate near-identical colors and repeated spacing/radius values into a small intentional scale.

### 4. Write DESIGN.md

Write or update `DESIGN.md` at the user-requested path. If the user is working in a repo and no path is specified, prefer `DESIGN.md` at the project root. If the project already uses `.stitch/DESIGN.md`, preserve that convention.

The file must start with YAML frontmatter. Include at least `name` and `colors`; include `typography`, `rounded`, and `spacing` when enough evidence exists or when a useful recommended system can be inferred.

Use this structure:

```markdown
---
name: Project Name
colors:
  background: "#ffffff"
  surface: "#f7f7f8"
  text: "#151515"
  primary: "#2454ff"
  on-primary: "#ffffff"
  border: "#d9dde3"
  error: "#ba1a1a"
typography:
  display:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: "700"
    lineHeight: 56px
    letterSpacing: "0"
  body:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: "400"
    lineHeight: 24px
    letterSpacing: "0"
rounded:
  sm: 4px
  md: 8px
  lg: 12px
  full: 9999px
spacing:
  unit: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
---

# Design System: Project Name

## 1. Visual Theme & Atmosphere

## 2. Color Palette & Roles
### Primary Foundation
### Accent & Interactive
### Typography & Text Hierarchy
### Functional States

## 3. Typography Rules
### Hierarchy & Weights
### Spacing Principles

## 4. Layout Principles
### Grid & Structure
### Whitespace Strategy
### Responsive Behavior

## 5. Depth, Shape & Motion

## 6. Component Styling
### Buttons
### Cards & Containers
### Navigation
### Inputs & Forms
### Feedback & Status
### Domain-Specific Components

## 7. Design Notes for Future Generation
### Language to Use
### Color References
### Component Prompts
### Implementation Notes
```

Adapt headings to the artifact. Keep the YAML parseable and the prose rich enough for another agent to recreate the design without seeing the original input.

## Writing Rules

- Use concrete values when available: hex colors, font names, px/rem sizes, radius values, breakpoints, and motion timings.
- Add descriptive names for important colors and styles, such as "Deep Ink Navy" or "Warm Porcelain Surface".
- Explain intent, not just CSS. Say what a choice communicates and where to use it.
- Preserve user constraints exactly: platform, brand words, accessibility needs, implementation stack, color restrictions, or "do not use" requests.
- Make accessibility part of the design system: contrast, focus states, touch targets, text labels for color-only states, and reduced-motion expectations.
- Avoid stuffing generation prompts with raw token dumps. Put raw values in frontmatter and role sections; use natural language in future-generation notes.
- If evidence conflicts, note the conflict briefly and choose the source closest to design intent: explicit tokens over component overrides, global styles over one-off inline styles, user instruction over inferred style.

## Quality Checklist

Before finishing, verify:

- YAML frontmatter is valid and includes `name` plus functional `colors`.
- Every major color has a role and usage guidance.
- Typography includes hierarchy, character, and practical usage.
- Layout covers spacing, responsiveness, and density.
- Component rules include shape, state, and interaction guidance.
- Inferences are sensible and do not contradict supplied artifacts.
- The document can guide both a designer and an implementation agent.
