# Claude Code Instructions

This file contains project-specific instructions for Claude Code and other AI coding assistants.

**Important**: When the user tells you to use a certain pattern or workflow, add it to this file so it's remembered in future sessions.

## Agent Usage

Use the following agents proactively for their corresponding tasks:

- **feature-architect**: When planning new features or significant changes, use this agent to create implementation plans with architecture diagrams
- **codebase-researcher**: Before making substantial additions or changes, use this agent to understand existing patterns, architecture, and implementation details
- **code-change-reviewer**: After completing code changes, use this agent to review for bugs, logic errors, and potential issues before committing
- **test-runner**: After modifying code, use this agent to run tests and verify changes work correctly
- **releaser**: When asked to deploy, release, ship, or publish, use this agent to handle the release process

## Project Overview

React Native/Expo mobile application.

## Important Files

- `src/utils/` - Utility functions and helpers
- `src/hooks/` - Custom React hooks
- `src/context/` - React Context providers for state management
- `src/types/index.ts` - TypeScript type definitions
- `src/components/` - Reusable UI components

## Environment Setup

### Environment Files

- `.env.local` - Used during development
- `.env.production` - Production credentials (gitignored)

## Manual Testing (Development)

**Important**: Always verify UI changes visually using the iOS simulator MCP tools before considering a task complete.

### Using Expo Go

Development testing uses **Expo Go**, a pre-built app that loads your JavaScript code without requiring a full native build. This is faster than building a standalone app.

```bash
# Start dev server and open in Expo Go on simulator
npx expo start --ios --localhost
```

This command:
1. Starts the Metro bundler
2. Opens Expo Go in the iOS simulator
3. Loads your app inside Expo Go

**Note**: Expo Go is only for development. For production builds on physical devices, use `npx expo run:ios` (see Deploying to iPhone section).

### MCP Simulator Tools

- `mcp__ios-simulator__ui_view` - Take screenshots to verify UI changes
- `mcp__ios-simulator__ui_tap` - Tap on coordinates to test interactions
- `mcp__ios-simulator__ui_type` - Type text into inputs
- `mcp__ios-simulator__ui_swipe` - Scroll and swipe gestures

### Testing Workflow

1. Start the dev server: `npx expo start --ios --localhost`
2. Make code changes (Metro will hot-reload automatically)
3. Take a screenshot with `mcp__ios-simulator__ui_view` to verify the change
4. Test interactions by tapping/typing as needed
5. Never assume a change looks correct - always verify visually

## Deploying to iPhone

To build and install on the connected iPhone:

```bash
npx expo run:ios --device --configuration Release
```

This creates a self-contained app with the JS bundle embedded. The app works standalone without a dev server.

**Important notes**:
- Always use `--configuration Release` for device builds. Debug builds require Metro and will show "no script url provided" error when opened without the dev server running.
- The phone is usually locked, so the build will fail to launch the app after installing. This is expected - the deploy is complete when you see "Build Succeeded" and the app is installed. Don't wait for the launch step.

## Code Patterns

- **Fix all TypeScript errors properly** - no `any` types, no ignoring errors. Run `npx tsc --noEmit` before committing
- Use strict TypeScript types, avoid string literals where union types exist

## Git Workflow

After making changes, always commit and push to GitHub:

```bash
git add .
git commit -m "Description of changes"
git push
```
