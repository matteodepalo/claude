# Claude Code Instructions

This file contains project-specific instructions for Claude Code and other AI coding assistants.

**Important**: When the user tells you to use a certain pattern or workflow, add it to this file so it's remembered in future sessions.

## Agent Usage

Use the following agents proactively for their corresponding tasks:

- **feature-architect**: BEFORE any code change, use this agent to analyze the codebase, identify refactoring opportunities, and create an implementation plan
- **codebase-researcher**: When you need to understand existing patterns, architecture, or implementation details
- **releaser**: When asked to deploy, release, ship, or publish, use this agent to handle the release process

### MANDATORY: Code Review After Every Change

**The code-change-reviewer agent MUST be called after ANY code change, no matter how small.**

This includes:
- New features
- Bug fixes
- Refactoring
- Single-line changes
- Documentation updates to code files

**Workflow:**
1. Make your code changes
2. **IMMEDIATELY** call the code-change-reviewer agent
3. Address any issues found
4. Then run tests

### MANDATORY: Test After Every Change

**The test-runner agent MUST be called after ANY code change to run the test suite.**

- Also use when investigating issues, bugs, or unexpected behavior
<!-- If using Detox E2E tests, uncomment:
- Always rebuild the test environment first if there were structural changes: `npm run test:e2e:build`
- Then run tests: `npm run test:e2e`
-->

### MANDATORY: Push Changes to GitHub

**After completing ANY code change, ALWAYS commit and push to GitHub.**

Do NOT wait for the user to ask you to push. This should be automatic after every change:

```bash
git add -A && git commit -m "Description of changes" && git push
```

This ensures:
- Changes are backed up immediately
- The user can see the changes in GitHub
- Changes are ready for deployment

## Project Overview

React Native/Expo mobile application.

<!-- Add project-specific description here -->

## Important Files

- `src/utils/` - Utility functions and helpers
- `src/hooks/` - Custom React hooks
- `src/context/` - React Context providers for state management
- `src/types/index.ts` - TypeScript type definitions
- `src/components/` - Reusable UI components

<!-- Add project-specific important files here -->

## Environment Setup

### Environment Files

- `.env.local` - Used during development
- `.env.production` - Production credentials (gitignored)

<!-- Add project-specific environment setup here -->

## Manual Testing (Development)

**Important**: Always verify UI changes visually using Mobile MCP tools before considering a task complete.

### Using Development Build

This project uses a **development build** (via `expo-dev-client`) instead of Expo Go. This allows the app to include custom native code while still supporting hot reload during development.

```bash
# First time (or after native code changes): Build and install on simulator
npx expo run:ios

# Subsequent runs: Just start Metro (app is already installed)
npx expo start
```

The first command builds native code and installs the app on the simulator. After that, you only need `npx expo start` - the app connects to Metro and hot reloads JS changes just like Expo Go.

**When to rebuild with `npx expo run:ios`:**
- First time setup
- After adding/updating native dependencies
- After changing `app.json` native configuration
- After running `npx expo prebuild`

### Mobile MCP Tools

This project uses `mobile-mcp` for visual testing with AI assistants. The MCP server provides capabilities like screenshots, tapping, and automation.

#### Starting the Dev Server

**First time (or after native code changes)**: Build and install the development build:
```bash
npx expo run:ios
```

**Subsequent runs**: In a **separate terminal**, run:
```bash
npx expo start
```

Then press `i` to open the app on the iOS simulator.

**Note**: If you get "No development build installed" error, run `npx expo run:ios` first to install the app.

#### Available MCP Capabilities

The Mobile MCP tools allow you to:
- Take screenshots to verify UI changes
- Tap on coordinates to test interactions
- Type text into inputs
- Scroll and swipe gestures
- Find elements by testID

### Testing Workflow

1. Start the dev server in a separate terminal (see above)
2. Open the app on simulator (press `i`)
3. Make code changes (Metro will hot-reload automatically)
4. Take a screenshot to verify the change
5. Test interactions by tapping/typing as needed
6. Never assume a change looks correct - always verify visually

## Deploying to iPhone via TestFlight

This app uses **EAS Build** and **TestFlight** for deployment to the iPhone.

### Build and Submit to TestFlight

```bash
# Build for production and submit to App Store Connect
eas build --platform ios --profile production --auto-submit
```

This will:
1. Build the app in the cloud using EAS Build
2. Automatically submit to App Store Connect
3. The build will appear in TestFlight for installation

### Manual Steps (if needed)

```bash
# Build only (without auto-submit)
eas build --platform ios --profile production

# Submit an existing build to App Store Connect
eas submit --platform ios
```

### First-Time Setup

If this is a new device or the EAS project hasn't been configured:

```bash
# Login to Expo account
eas login

# Configure the project (creates/links to EAS project)
eas build:configure
```

**Important notes**:
- Builds run in the cloud and take several minutes
- When using the releaser agent, don't block waiting for it to complete
- After the build is submitted, it may take a few minutes to appear in TestFlight
- **Always release after every code change** - deploy to TestFlight so the user can test the changes

## Code Patterns

- **Fix all TypeScript errors properly** - no `any` types, no ignoring errors. Run `npx tsc --noEmit` before committing
- Use strict TypeScript types, avoid string literals where union types exist

## Git Workflow

See "MANDATORY: Push Changes to GitHub" above. Always push after every change - don't wait to be asked.
