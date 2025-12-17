# Claude Code Instructions

This file contains project-specific instructions for Claude Code and other AI coding assistants.

**Important**: When the user tells you to use a certain pattern or workflow, add it to this file so it's remembered in future sessions.

## Agent Usage

Use the following agents proactively for their corresponding tasks:

- **feature-architect**: BEFORE any code change, use this agent to analyze the codebase, identify refactoring opportunities, and create an implementation plan
- **code-change-reviewer**: MUST be called after ANY code change to review for bugs, logic errors, and issues
- **test-runner**: MUST be called after ANY code change to run the test suite and verify nothing is broken. Also use when investigating issues, bugs, or unexpected behavior
- **codebase-researcher**: When you need to understand existing patterns, architecture, or implementation details
- **releaser**: When asked to deploy, release, ship, or publish, use this agent to handle the release process

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

**Important**: Always verify UI changes visually using Expo MCP tools before considering a task complete.

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

**Note**: Expo Go is only for development. For production builds, use EAS Build and TestFlight.

### Expo MCP Tools

This project uses `expo-mcp` for visual testing. Use the available MCP tools to:
- Take screenshots to verify UI changes
- Tap on coordinates to test interactions
- Type text into inputs
- Scroll and swipe gestures

### Testing Workflow

1. Start the dev server: `npx expo start --ios --localhost`
2. Make code changes (Metro will hot-reload automatically)
3. Take a screenshot to verify the change
4. Test interactions by tapping/typing as needed
5. Never assume a change looks correct - always verify visually

## Deploying to TestFlight

This app uses **EAS Build** and **TestFlight** for deployment.

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
