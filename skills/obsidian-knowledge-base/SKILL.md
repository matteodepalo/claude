---
name: obsidian-knowledge-base
description: Search, read, and write to the Obsidian knowledge base. Use proactively when the user asks questions that might have answers in their notes, or when they reference topics like cooking, coffee, training, finances, meditation, interview prep, bonsai, travels, product ideas, or any personal knowledge. Also use when the user wants to save or update notes.
---

# Obsidian Knowledge Base

Search and read markdown notes using `qmd` CLI. Write and update notes using `obsidian` CLI.

Vault path: `/Users/matteodepalo/Library/Mobile Documents/iCloud~md~obsidian/Documents/knowledge`
qmd collection name: `knowledge`

## Searching

Use `qmd` via Bash to find and read notes.

### Keyword search (fast, exact terms)
```bash
qmd search "coffee brewing" -c knowledge -n 5
```

### Semantic search (natural language queries)
```bash
qmd query "how to make iced coffee" -c knowledge -n 5
```

### Structured query (combine keyword + semantic)
```bash
qmd query $'lex: retirement allocation\nvec: how should I allocate retirement assets' -c knowledge -n 5
```

### Get full document content
```bash
# By path (relative to collection root)
qmd get "Coffee/Moka.md" -c knowledge --full

# By doc ID from search results (e.g. #3e5fb0)
qmd get "#3e5fb0" --full
```

### Batch fetch multiple files
```bash
qmd multi-get "Coffee/*" -c knowledge
```

### List files in a folder
```bash
qmd ls knowledge/Coffee
```

## Vault Structure

```
knowledge/
  Meditation/        # Meditation practice, dokusan, notes
  Product ideas/     # App ideas, product concepts
  Cooking/           # Recipes (pizza, bread, grissini, stir-fry)
  LeetCode/          # Algorithm problems and solutions
  Training/          # Training plans, nutrition, recipes
  Health/            # Health notes
  Meta/              # Interview prep, career notes
  Bonsai/            # Bonsai care guides
  Notes/             # Miscellaneous notes
  Financial Planning/ # Retirement, finances, investments
  Coffee/            # Brewing methods and recipes
  Travels/           # Travel plans and notes
  Measures & Sizes/  # Personal measurements and sizes
  Stripe/            # Interview prep for Stripe
```

## Writing

Use the `obsidian` CLI via Bash to create and modify notes. Obsidian must be running.

- Vault name: `knowledge` — pass `vault=knowledge` on every command.
- File paths are relative to vault root: `path="Coffee/New Recipe.md"`
- Values with spaces need quotes: `path="Financial Planning/New Note.md"`
- Multiline content uses `\n` for newlines, `\t` for tabs

### Create a new note
```bash
obsidian vault=knowledge create path="Cooking/New Recipe.md" content="# New Recipe\n\nIngredients:\n- Item 1\n- Item 2\n\n## Steps\n\n1. First step"
```

### Append to an existing note
```bash
obsidian vault=knowledge append path="Coffee/Moka.md" content="\n\n## New Section\n- Additional notes here"
```

### Read a note (via obsidian CLI)
```bash
obsidian vault=knowledge read path="Coffee/Moka.md"
```

### Manage checkboxes
```bash
# List open checkboxes with line numbers
obsidian vault=knowledge tasks path="Training/Training plan.md" todo verbose

# Mark a checkbox done by line number
obsidian vault=knowledge task path="Training/Training plan.md" line=15 done
```

### Update frontmatter properties
```bash
obsidian vault=knowledge property:set path="Coffee/Moka.md" name=tags value="coffee,brewing,recipe" type=list
```

### Overwrite a note (use with care)
When you need to insert content in the middle of a file (not just append), read the full content first, then write back the complete modified file:
```bash
obsidian vault=knowledge create path="path/to/file.md" content="<full updated content>" overwrite
```
Only use overwrite when you are writing back the complete file with modifications. Never use it to replace content blindly.

### Naming conventions
- Use descriptive names: `Short Descriptive Name.md`
- Never use `#` in filenames (Obsidian interprets it as a heading anchor)
- Place notes in the appropriate existing folder, or ask the user where to put them

## Reindexing

If the vault may have changed (e.g. user edited notes in Obsidian), reindex before searching:
```bash
qmd update && qmd embed
```

After writing to the vault, run reindexing so subsequent searches include the new content.

## Rules

- Always search the knowledge base when the user asks about topics that could be in their notes
- Present information from notes naturally, not as raw markdown dumps
- If a search returns no results, try alternative search terms or a different search type (keyword vs semantic)
- When writing, never overwrite or remove existing content unless explicitly asked — prefer appending
- After writing notes, run `qmd update && qmd embed` to keep the index fresh
- If unsure where to place a new note, ask the user
