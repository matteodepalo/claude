# Claude Code Instructions

This file contains project-specific instructions for Claude Code and other AI coding assistants.

**Important**: When the user tells you to use a certain pattern or workflow, add it to this file so it's remembered in future sessions.

## Project Overview

<!-- Replace with your app description -->
A web application built with React Router (Remix) featuring:
- [Key feature 1]
- [Key feature 2]
- [Key feature 3]

## Development

```bash
npm run dev    # Start dev server on http://localhost:5173
npm run build  # Build for production
npm run test   # Run acceptance tests
```

## Rules

### Testing

- **Run acceptance tests (`npm run test`) after making any changes** to ensure nothing is broken
- Tests are located in the `e2e/` directory
- **For manual verification**, use Playwright MCP with `browser_snapshot` for accessibility-based testing
- **Always test on the local dev server** (http://localhost:5173), not the deployed site
- Test the full user flow when relevant
- Do not skip testing - every change that affects the UI or user experience requires verification

#### Test Commands

```bash
npm run test          # Run all tests headless
npm run test:headed   # Run tests with visible browser
npm run test:ui       # Run tests with Playwright UI
```

### Version Control

- **Always push changes to GitHub** after completing features or fixes
- Write clear commit messages describing what changed and why

### Deployment

- **Do not run deploy commands automatically** - let the user deploy manually
<!-- Add your deploy command here, e.g.: -->
<!-- - Deploy command: `fly deploy` -->

## Tech Stack

- **Framework**: React Router v7 (Remix)
- **Styling**: Tailwind CSS v4
<!-- Add other tech as needed -->

## Key Files

<!-- Customize based on your project structure -->
- `app/routes/` - Page routes and loaders
- `app/components/` - Reusable UI components
- `app/context/` - React Context providers
- `app/lib/` - Server-side utilities

## Environment Variables

<!-- List your environment variables -->
```
# Example:
# DATABASE_URL=
# API_KEY=
```
