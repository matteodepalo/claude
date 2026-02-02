# Claude Code Instructions

This file contains project-specific instructions for Claude Code and other AI coding assistants.

**Important**: When the user tells you to use a certain pattern or workflow, add it to this file so it's remembered in future sessions.

### MANDATORY: Push Changes to GitHub

**After completing ANY code change, ALWAYS commit and push to GitHub.**

```bash
git add -A && git commit -m "Description of changes" && git push
```

### MANDATORY: Run All Tests Before Releasing

**Before ANY release or deployment, ALL test suites MUST pass.**

```bash
# Run all tests before releasing
npm test         # Unit tests
npm run test:e2e # E2E tests (requires Metro)
```

**Do NOT release if any test fails.** Fix failing tests before proceeding with the release.

## Testing Strategy

**Philosophy**: Use Jest for comprehensive logic testing, Maestro for critical happy paths and persistence verification.

### Test Types and When to Use

| Test Type | When to Use | Location |
|-----------|-------------|----------|
| **Unit Tests (Jest)** | Pure logic, utilities, edge cases | `src/__tests__/utils/` |
| **Component Tests (Jest)** | Screen rendering with mocked state | `src/__tests__/components/` |
| **E2E Tests (Maestro)** | Happy paths, persistence, full integration | `.maestro/flows/` |

### E2E Testing Requirements

**Every feature addition, removal, or change MUST have a corresponding E2E test.**

1. **Always create/update E2E tests** when implementing features
2. **Use Maestro E2E tests** (`npm run test:e2e`) - tests are in `.maestro/flows/`
3. **TestID convention**: Always add `testID` props to new UI elements

### Debugging Failing E2E Tests

**IMPORTANT: Before increasing timeouts, ALWAYS investigate first.**

1. Check actual screen state to verify elements are present
2. Fix the actual issue rather than blindly increasing timeouts

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
