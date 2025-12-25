# Git Workflow Scripts

Simple and robust git workflow scripts for the Zarex24 project.

## Branch Structure

-   **`main`**: Production branch (stable, deployed code)
-   **`dev`**: Development branch (active development)

## Available Commands

### 1. Push Changes

```bash
git/push.sh <type> 'commit message'
```

Push changes to the current branch with a commit message.

### 2. Feature Development

```bash
# Create new feature branch from dev
git/feature.sh 'feature name'

# Close feature and merge back to dev
git/close.sh
```

### 3. Bug Fixes

```bash
# Create new bugfix branch from dev
git/bugfix.sh 'bugfix name'

# Close bugfix and merge back to dev
git/close.sh
```

### 4. Hotfixes

```bash
# Create new hotfix branch from main
git/hotfix.sh 'hotfix name'

# Close hotfix and create PR to main
git/close.sh
```

### 5. Releases

```bash
# Create patch release (1.0.0 -> 1.0.1)
git/release.sh

# Create minor release (1.0.0 -> 1.1.0)
git/release.sh minor

# Create major release (1.0.0 -> 2.0.0)
git/release.sh major
```

## Workflow Examples

### Feature Development

```bash
# Start new feature
git/feature.sh 'user-authentication'

# Make changes and commit
git/push.sh feat 'add login form'
git/push.sh feat 'add validation logic'

# Finish feature
git/close.sh  # Merges to dev
```

### Bug Fix

```bash
# Start bug fix
git/bugfix.sh 'fix-email-validation'

# Make changes and commit
git/push.sh fix 'fix email regex pattern'

# Finish bug fix
git/close.sh  # Merges to dev
```

### Hotfix (Critical Production Fix)

```bash
# Start hotfix
git/hotfix.sh 'critical-security-fix'

# Make changes and commit
git/push.sh fix 'patch security vulnerability'

# Finish hotfix
git/close.sh  # Creates PR to main
```

### Release

```bash
# Create a new release
git/release.sh patch  # or minor/major

# This will:
# 1. Merge dev into main
# 2. Update version automatically
# 3. Create git tag
# 4. Publish GitHub Release (triggers deploy)
# 5. Push everything
# 6. Sync main back to dev
```

## Branch Naming Convention

-   **Features**: `feature/feature-name`
-   **Bug fixes**: `bugfix/bug-description`
-   **Hotfixes**: `hotfix/critical-fix-name`

## Notes

-   All feature and bugfix branches merge directly into `dev`
-   Hotfix branches create PRs to `main` (manual review required)
-   Releases automatically merge `dev` into `main` with version tagging
-   Version numbers follow semantic versioning (major.minor.patch)
-   All scripts include help: add `-h` or `--help` to any command

## Version Management

-   **Patch**: Bug fixes, small changes (1.0.0 → 1.0.1)
-   **Minor**: New features, backwards compatible (1.0.0 → 1.1.0)
-   **Major**: Breaking changes (1.0.0 → 2.0.0)

Version is derived from git tags (`vX.Y.Z`). `git/release.sh` finds the latest `v*` tag and bumps it (patch/minor/major).

## Release Notes

When `gh` is available, `git/release.sh` publishes a GitHub Release using `--generate-notes` (this also triggers the production deploy workflow), then saves the exact generated notes into:

-   `git/releases/<tag>.md` (per-release, kept for history)
-   `git/release-note.txt` (latest release notes)
