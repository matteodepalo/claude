# Claude Code Instructions

This file contains project-specific instructions for Claude Code and other AI coding assistants.

**Important**: When the user tells you to use a certain pattern or workflow, add it to this file so it's remembered in future sessions.

## Project Overview

A web application built with React Router (Remix).

<!-- Add project-specific description here -->

## Development

```bash
npm run dev    # Start dev server on http://localhost:5173
npm run build  # Build for production
npm run test   # Run acceptance tests
```

## Rules

### Testing

- **Run acceptance tests (`npm run test`) after making any changes** to ensure nothing is broken
- **Keep acceptance tests up to date** when adding, removing, or changing features
- Tests are located in the `e2e/` directory
- **For manual verification**, use `browser_snapshot` for accessibility-based testing
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

## Tech Stack

- **Framework**: React Router v7 (Remix)
- **Styling**: Tailwind CSS v4

<!-- Add project-specific tech stack details here -->

## Key Files

- `app/routes/` - Page routes and loaders
- `app/components/` - Reusable UI components
- `app/context/` - React Context providers
- `app/lib/` - Server-side utilities

<!-- Add project-specific key files here -->

## Environment Variables

Create a `.env` file with required environment variables (see `.env.example` if available).

<!-- Add project-specific environment variables here -->
