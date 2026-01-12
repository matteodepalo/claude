---
name: prd-to-json
description: Convert a markdown PRD document into prd.json format for use with the ralph autonomous implementation loop. Use after creating a PRD with /prd skill.
---

# PRD to JSON Converter

Convert a markdown PRD document into `prd.json` format for use with the `/ralph` autonomous implementation loop.

## The Job

1. Read the markdown PRD file specified by the user (or find one in `tasks/`)
2. Extract user stories and convert to JSON format
3. Save as `prd.json` in the project root

## Conversion Rules

### Story Sizing

Each user story must be completable in a single focused session. If you cannot describe the change in 2-3 sentences, it is too big.

**Good scope:**
- Add a database column
- Create a single UI component
- Update server logic for one endpoint

**Too big:**
- Build entire authentication system
- Create complete admin dashboard

### Dependency Ordering

Stories execute sequentially by priority. Earlier stories cannot depend on later ones.

**Recommended sequence:**
1. Database schema changes
2. Backend/API logic
3. UI components
4. Aggregate views/reports

### Verifiable Criteria

Acceptance criteria must be objectively checkable.

**Bad:** "Works correctly", "Good UX"
**Good:** "Filter dropdown has options: All, Active, Completed", "Typecheck passes"

## Output Format

```json
{
  "project": "ProjectName",
  "branchName": "ralph/feature-name-kebab-case",
  "description": "Brief feature description",
  "userStories": [
    {
      "id": "US-001",
      "title": "Short descriptive title",
      "description": "As a [user], I want [feature] so that [benefit]",
      "acceptanceCriteria": [
        "Specific criterion 1",
        "Specific criterion 2",
        "Typecheck passes"
      ],
      "priority": 1,
      "passes": false,
      "notes": ""
    }
  ]
}
```

## Required Criteria

Every story MUST include:
- "Typecheck passes" (or equivalent quality check for the project)

UI stories MUST also include:
- "Verify in browser/simulator" (for visual verification)

## Branch Naming

Use kebab-case: `ralph/[feature-name]`

Examples:
- `ralph/task-priority`
- `ralph/user-authentication`
- `ralph/dashboard-charts`

## Workflow

1. Ask user for the PRD file path (or search `tasks/` for PRD files)
2. Read and parse the markdown PRD
3. Extract user stories, ensuring proper sizing and ordering
4. Generate `prd.json` with all stories set to `passes: false`
5. Create the feature branch if it doesn't exist
6. Inform user they can now run `/ralph` to start implementation

## Archive Previous Runs

Before creating a new `prd.json`:

1. Check if `prd.json` already exists
2. If it exists and has a different `branchName`, archive it:
   - Create `archive/[date]-[old-branch-name]/` directory
   - Move `prd.json` and `progress.txt` there
3. This preserves history of previous ralph runs
