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

**Workflow:**
1. Make your code changes
2. **IMMEDIATELY** call the code-change-reviewer agent
3. **Address ALL issues found, even minor ones** - do not skip or dismiss any issues
4. Then run tests

### MANDATORY: Test After Every Change

**The test-runner agent MUST be called after ANY code change to run the test suite.**

**Preferred approach (with Metro hot reload):**
1. Keep Metro running: `npm run start:e2e` (in a separate terminal)
2. Make code changes (Metro hot reloads automatically)
3. Run tests: `npm run test:e2e` - no rebuild needed!

**Running specific tests:** `npm run test:e2e:single .maestro/flows/<path-to-test>.yaml`

### MANDATORY: Push Changes to GitHub

**After completing ANY code change, ALWAYS commit and push to GitHub.**

```bash
git add -A && git commit -m "Description of changes" && git push
```

## CRITICAL: E2E Testing Requirements

**Every feature addition, removal, or change MUST have a corresponding E2E test.**

1. **Always create/update E2E tests** when implementing features
2. **Use Maestro E2E tests** (`npm run test:e2e`) - tests are in `.maestro/flows/`
3. **Use mobile-mcp for manual testing** when you need visual verification
4. **TestID convention**: Always add `testID` props to new UI elements

### Debugging Failing E2E Tests

**IMPORTANT: Before increasing timeouts, ALWAYS use mobile-mcp to investigate first.**

1. Use `mobile_take_screenshot` to see actual screen state
2. Use `mobile_list_elements_on_screen` to verify elements in accessibility tree
3. Fix the actual issue rather than blindly increasing timeouts

Common issues:
- Element not found → Add `testID` prop
- Element not scrolled into view → Use `scrollUntilVisible`
- Keyboard blocking element → Add `hideKeyboard` after `inputText`
- Plain View not visible → Add `accessible={true}` to Views

### Maestro Patterns

**Keyboard/Focus**: `hideKeyboard` hides keyboard but does NOT blur TextInput. For persistence tests, add explicit blur taps between inputs:

```yaml
- tapOn:
    id: "input-field-1"
- inputText: "100"
- hideKeyboard
- waitForAnimationToEnd:
    timeout: 500
- tapOn:
    id: "some-label"  # Blur tap
- waitForAnimationToEnd:
    timeout: 500
- tapOn:
    id: "input-field-2"
- inputText: "8"
- hideKeyboard
```

**Scrolling**: Swipe direction = FINGER movement:
- `swipe: direction: DOWN` = content scrolls UP
- `swipe: direction: UP` = content scrolls DOWN

**Always use `centerElement: true`** when scrolling to elements you'll interact with:
```yaml
- scrollUntilVisible:
    element:
      id: "target"
    direction: DOWN
    centerElement: true
```

**State assertions**: Use `extendedWaitUntil` instead of `assertVisible` for state changes:
```yaml
- extendedWaitUntil:
    visible:
      id: "element-after-state-change"
    timeout: 5000
```

**Native alerts**: Just tap the button text: `- tapOn: "Skip"`

### Common Test Failures

| Symptom | Solution |
|---------|----------|
| Text goes to wrong field | Add blur tap between inputs |
| Complete button disabled | Use blur taps to capture all inputs |
| Element not found after scroll | Use `centerElement: true` |
| State assertion fails | Use `extendedWaitUntil` |
| Data not persisted after reload | Add waits before `launchApp` |

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

## Detailed Documentation

For more details on specific areas, read these README files:

| Area | README | When to read |
|------|--------|--------------|
| E2E Tests | `.maestro/README.md` | Detailed test patterns, persistence tests |

<!-- Add project-specific READMEs here -->

## Environment Setup

<!-- Add project-specific environment setup here -->

## Key Commands

```bash
# Start app for development
npx expo start

# Start app for E2E testing
npm run start:e2e

# Run E2E tests
npm run test:e2e

# Build and install dev client (first time or native changes)
npm run ios:e2e

# Run specific test
npm run test:e2e:single .maestro/flows/<path>.yaml
```

## E2E Test Scripts

| Script | Description |
|--------|-------------|
| `npm run test:e2e` | Run tests (requires Metro) |
| `npm run test:e2e:single <path>` | Run specific test |
| `npm run test:e2e:full` | Start services + run tests |
| `npm run test:e2e:full:build` | Full build + tests |

## TestID Patterns

<!-- Add project-specific testID patterns here -->
<!-- Example:
- `button-{action}` - Action buttons
- `input-{field}` - Input fields
- `card-{index}` - List item cards
-->

## Deploying to iPhone

```bash
eas build --platform ios --profile production --auto-submit
```

## Code Patterns

- **Fix all TypeScript errors properly** - no `any` types. Run `npx tsc --noEmit` before committing
- Use strict TypeScript types, avoid string literals where union types exist

## Troubleshooting

<!-- Add project-specific troubleshooting here -->
