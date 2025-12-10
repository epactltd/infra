# Git Workflow Scripts

Simple and robust git workflow scripts for the Zarex24 project.

## Branch Structure

- **`main`**: Production branch (stable, deployed code)
- **`dev`**: Development branch (active development)

## Available Commands

### 1. Push Changes
```bash
git/push.sh 'commit message'
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
git/push.sh 'Add login form'
git/push.sh 'Add validation logic'

# Finish feature
git/close.sh  # Merges to dev
```

### Bug Fix
```bash
# Start bug fix
git/bugfix.sh 'fix-email-validation'

# Make changes and commit
git/push.sh 'Fix email regex pattern'

# Finish bug fix
git/close.sh  # Merges to dev
```

### Hotfix (Critical Production Fix)
```bash
# Start hotfix
git/hotfix.sh 'critical-security-fix'

# Make changes and commit
git/push.sh 'Patch security vulnerability'

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
# 4. Push everything
# 5. Sync main back to dev
```

## Branch Naming Convention

- **Features**: `feature/feature-name`
- **Bug fixes**: `bugfix/bug-description`
- **Hotfixes**: `hotfix/critical-fix-name`

## Notes

- All feature and bugfix branches merge directly into `dev`
- Hotfix branches create PRs to `main` (manual review required)
- Releases automatically merge `dev` into `main` with version tagging
- Version numbers follow semantic versioning (major.minor.patch)
- All scripts include help: add `-h` or `--help` to any command

## Version Management

Version is automatically managed in `git/version.txt`:
- **Patch**: Bug fixes, small changes (1.0.0 → 1.0.1)
- **Minor**: New features, backwards compatible (1.0.0 → 1.1.0)  
- **Major**: Breaking changes (1.0.0 → 2.0.0)
