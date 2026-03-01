# Project Management

This directory contains all project management artifacts for the
Retirement Calculator.

## Structure

- `backlog/` — Active backlog tickets (markdown files using `template.md` format)
- `done/` — Archived completed tickets (moved here when done)
- `template.md` lives in `backlog/` as the canonical ticket format

## Ticket Conventions

### IDs and Filenames

Sequential numbering: **BL-0001**, **BL-0002**, etc. All ticket types
share one sequence.

Ticket filename includes the ID: `BL-0001-short-title.md`. This makes
tickets findable by glob without reading frontmatter.

### Types

| Type    | Use for                                      |
|---------|----------------------------------------------|
| `task`  | Well-defined unit of work                    |
| `bug`   | Something broken                             |
| `spike` | Research / time-boxed investigation          |
| `story` | User-facing capability                       |
| `epic`  | Large body of work spanning multiple tickets |

### Statuses

`backlog` -> `ready` -> `in_progress` -> `done` (move file to `done/`)

Use `blocked` when waiting on a dependency.
Update status when moving.

### Scoring (WSJF-style)

```
score = (value + urgency) / effort
```

Higher score = higher priority. The `score` field in tickets is
advisory and may be recomputed at any time.

### Workflow

1. Create ticket in `backlog/` using `template.md` format
2. Set status to `ready` when acceptance criteria are clear
3. Set status to `in_progress` when work begins
4. Set status to `done` and move file to `done/` when complete
