#!/bin/bash
# ⚠️ DO NOT MODIFY WITHOUT REVIEW

# Git Workflow Help Guide
# Usage: git/help.sh [command]

show_main_help() {
  cat << EOF
╔══════════════════════════════════════════════════════════════════════════════╗
║                    Git Workflow Guide - Quick Reference                     ║
╚══════════════════════════════════════════════════════════════════════════════╝

📚 OVERVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

This project uses a Git Flow workflow with protected branches:
  • main    - Production-ready code (protected)
  • dev     - Development branch (protected)
  • feature/bugfix/hotfix/* - Working branches

┌─────────────────────────────────────────────────────────────────────────────┐
│ BRANCH TYPES & WHEN TO USE THEM                                             │
└─────────────────────────────────────────────────────────────────────────────┘

🌟 FEATURE BRANCHES (feature/*)
   Use when: Adding new functionality or enhancements
   Source:   dev branch
   Target:   dev branch (via PR or direct merge)

   Example:  git/feature.sh "user-dashboard"
             → Creates: feature/user-dashboard

🐛 BUGFIX BRANCHES (bugfix/*)
   Use when: Fixing bugs found in dev branch
   Source:   dev branch
   Target:   dev branch (via PR or direct merge)

   Example:  git/bugfix.sh "fix-login-validation"
             → Creates: bugfix/fix-login-validation

🚨 HOTFIX BRANCHES (hotfix/*)
   Use when: Fixing critical bugs in production (main branch)
   Source:   main branch
   Target:   main branch (via PR only)

   Example:  git/hotfix.sh "critical-payment-bug"
             → Creates: hotfix/critical-payment-bug

┌─────────────────────────────────────────────────────────────────────────────┐
│ AVAILABLE COMMANDS                                                          │
└─────────────────────────────────────────────────────────────────────────────┘

1. 🌟 git/feature.sh <name>
   Creates a new feature branch from dev

   Rules:
   • Fails if working tree is dirty
   • Checks out dev, pulls latest
   • Creates feature/<name>
   • Auto-pushes with upstream

   Example:
     git/feature.sh "payment-integration"
     # Creates: feature/payment-integration
     # Switches to the new branch automatically

2. 🐛 git/bugfix.sh <name>
   Creates a new bugfix branch from dev

   Rules:
   • Same rules as feature.sh
   • Creates bugfix/<name>

   Example:
     git/bugfix.sh "fix-email-validation"
     # Creates: bugfix/fix-email-validation
     # Switches to the new branch automatically

3. 🚨 git/hotfix.sh <name>
   Creates a new hotfix branch from main

   Rules:
   • Fails if working tree is dirty
   • Checks out main, pulls latest
   • Creates hotfix/<name>
   • Auto-pushes with upstream

   Example:
     git/hotfix.sh "critical-login-bug"
     # Creates: hotfix/critical-login-bug
     # Switches to the new branch automatically

4. 📤 git/push.sh "commit message"
   Commits and safely pushes current branch

   Rules:
   • BLOCKS pushing from main or dev
   • Auto-detects current branch
   • Runs: git add .
   • Runs: git commit -m "message"
   • Runs: git pull --rebase
   • Then: git push -u origin <branch>

   Example:
     git/push.sh "Add user authentication"
     # Adds, commits, pulls with rebase, then pushes current branch

5. 📋 git/pr.sh [dev|main]
   Creates a Pull Request automatically

   Rules:
   • Default target: dev
   • Auto-detects branch type
   • Enforces: feature/* → dev, bugfix/* → dev, hotfix/* → main
   • Uses GitHub CLI (gh) if available, otherwise prints URL

   Example:
     git/pr.sh dev
     # Creates PR from current branch to dev

6. 🔀 git/close.sh
   Safe branch cleanup with auto-PR fallback

   HARD RULES:
   • ABSOLUTE BLOCK: Cannot close dev or main
   • Checks if branch is merged into target
   • If NOT merged: Auto-creates PR instead
   • If merged: Switches to target, deletes local & remote

   Behavior:
   • feature/* → checks merge into dev
   • bugfix/*  → checks merge into dev
   • hotfix/*  → checks merge into main

   Example:
     # On branch: feature/user-dashboard
     git/close.sh
     # Checks merge status, creates PR if needed, or deletes if merged

7. 🚀 git/release.sh [patch|minor|major]
   Automates production releases using semantic versioning

   Rules:
   • Must be executed from dev branch
   • Fails if working tree is dirty
   • Finds latest tag (vX.Y.Z)
   • Auto-increments version

   RELEASE FLOW:
   1. Validate on dev
   2. Calculate new version
   3. Checkout main, pull latest
   4. Merge dev into main
   5. Create tag: vX.Y.Z
   6. Push main and tag
   7. Checkout dev
   8. Merge main back into dev
   9. Push dev

   Example:
     git/release.sh patch
     # v1.0.0 → v1.0.1
     # Full release automation

┌─────────────────────────────────────────────────────────────────────────────┐
│ TYPICAL WORKFLOWS                                                            │
└─────────────────────────────────────────────────────────────────────────────┘

📋 WORKFLOW 1: Adding a New Feature
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  1. Create feature branch:
     git/feature.sh "new-feature-name"

  2. Make your changes, then push:
     git/push.sh "Implement feature X"
     # Adds, commits, and pushes automatically

  3. When complete, close branch:
     git/close.sh
     # Checks merge status, creates PR if needed, or deletes if merged

📋 WORKFLOW 2: Fixing a Bug in Development
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  1. Create bugfix branch:
     git/bugfix.sh "fix-bug-description"

  2. Fix the bug, then push:
     git/push.sh "Fix the bug"
     # Adds, commits, and pushes automatically

  3. When complete, close branch:
     git/close.sh
     # Checks merge status, creates PR if needed, or deletes if merged

📋 WORKFLOW 3: Critical Production Hotfix
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  1. Create hotfix branch:
     git/hotfix.sh "critical-bug-name"

  2. Fix the issue, then push:
     git/push.sh "Fix critical production bug"
     # Adds, commits, and pushes automatically

  3. When done, close branch (first time):
     git/close.sh
     # Checks merge status - if NOT merged, creates PR to main
     # PR will be created automatically

  4. After PR is merged, close branch again:
     git/close.sh
     # Now that branch is merged, it will delete local and remote branch

📋 WORKFLOW 4: Preparing a Release
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  1. Ensure all features/bugfixes are merged to dev

  2. Create release (must be on dev branch):
     git checkout dev
     git/release.sh patch    # or minor, major

  3. Release script automatically:
     • Merges dev → main
     • Creates tag vX.Y.Z
     • Pushes main and tag
     • Merges main back into dev
     • Pushes dev

┌─────────────────────────────────────────────────────────────────────────────┐
│ BRANCH NAMING CONVENTIONS                                                    │
└─────────────────────────────────────────────────────────────────────────────┘

✅ GOOD NAMING:
   • feature/user-authentication
   • bugfix/fix-email-validation
   • hotfix/critical-payment-bug
   • Use lowercase, hyphens for spaces
   • Be descriptive but concise

❌ AVOID:
   • feature/my-work
   • bugfix/fix
   • hotfix/urgent
   • Spaces, special characters, uppercase

┌─────────────────────────────────────────────────────────────────────────────┐
│ SAFETY FEATURES                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

🛡️ PROTECTED BRANCHES:
   • main and dev branches are PROTECTED
   • Cannot push directly to main or dev (use git/push.sh - it blocks)
   • Cannot close main or dev branches
   • Use git/pr.sh to create pull requests instead

✅ SAFETY CHECKS:
   • All scripts check for dirty working tree
   • All scripts validate branch types
   • git/close.sh checks merge status before deletion
   • git/pr.sh validates branch type vs target
   • git/release.sh must be run from dev

┌─────────────────────────────────────────────────────────────────────────────┐
│ TIPS & BEST PRACTICES                                                        │
└─────────────────────────────────────────────────────────────────────────────┘

💡 TIPS:
   • Always commit frequently with git/push.sh
   • Use descriptive commit messages
   • Test your changes before closing a branch
   • Pull latest changes before starting new work
   • Use git/close.sh instead of manual merging
   • Use git/push.sh for safe pushing (blocks protected branches)
   • git/push.sh handles add, commit, and push automatically

⚠️  IMPORTANT:
   • Never work directly on main or dev branches
   • Always create a feature/bugfix/hotfix branch first
   • Hotfixes require PR review before merging to main
   • Feature/bugfix branches can merge to dev via PR or direct merge
   • git/push.sh will BLOCK pushing to main or dev

🔍 GETTING HELP:
   • Run any command with -h or --help for specific help
   • Example: git/feature.sh --help
   • This help: git/help.sh
   • Command-specific help: git/help.sh <command>

┌─────────────────────────────────────────────────────────────────────────────┐
│ QUICK COMMAND REFERENCE                                                      │
└─────────────────────────────────────────────────────────────────────────────┘

  git/feature.sh <name>        Create feature branch from dev
  git/bugfix.sh <name>         Create bugfix branch from dev
  git/hotfix.sh <name>         Create hotfix branch from main
  git/push.sh "message"        Commit and safely push current branch (blocks main/dev)
  git/close.sh                 Close and merge current branch (with merge check)
  git/pr.sh [dev|main]         Create pull request (validates branch type)
  git/release.sh [type]        Full release automation (dev → main → dev)
  git/help.sh                  Show this help (or help for specific command)

For detailed help on any command:
  git/<command>.sh --help
  git/help.sh <command>

EOF
}

show_command_help() {
  local command="$1"

  case "$command" in
    feature)
      echo "🌟 FEATURE COMMAND HELP"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo ""
      echo "Usage: git/feature.sh <feature-name>"
      echo ""
      echo "Creates a new feature branch from the dev branch."
      echo ""
      echo "Rules:"
      echo "  • Fails if working tree is dirty"
      echo "  • Checks out dev, pulls latest"
      echo "  • Creates feature/<name>"
      echo "  • Auto-pushes with upstream"
      echo ""
      echo "When to use:"
      echo "  • Adding new functionality"
      echo "  • Enhancing existing features"
      echo "  • Implementing new user-facing features"
      echo ""
      echo "Examples:"
      echo "  git/feature.sh user-authentication"
      echo "  git/feature.sh payment-integration"
      echo "  git/feature.sh dashboard-redesign"
      echo ""
      echo "What it does:"
      echo "  1. Checks for dirty working tree (fails if dirty)"
      echo "  2. Switches to dev and pulls latest changes"
      echo "  3. Creates feature/<name> branch"
      echo "  4. Pushes branch with upstream tracking"
      ;;

    bugfix)
      echo "🐛 BUGFIX COMMAND HELP"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo ""
      echo "Usage: git/bugfix.sh <bugfix-name>"
      echo ""
      echo "Creates a new bugfix branch from the dev branch."
      echo ""
      echo "Rules:"
      echo "  • Same rules as feature.sh"
      echo "  • Creates bugfix/<name>"
      echo ""
      echo "When to use:"
      echo "  • Fixing bugs found during development"
      echo "  • Fixing issues in the dev branch"
      echo "  • Non-critical bug fixes"
      echo ""
      echo "Examples:"
      echo "  git/bugfix.sh fix-login-validation"
      echo "  git/bugfix.sh fix-email-sending"
      echo "  git/bugfix.sh fix-dashboard-loading"
      echo ""
      echo "What it does:"
      echo "  1. Checks for dirty working tree (fails if dirty)"
      echo "  2. Switches to dev and pulls latest changes"
      echo "  3. Creates bugfix/<name> branch"
      echo "  4. Pushes branch with upstream tracking"
      ;;

    hotfix)
      echo "🚨 HOTFIX COMMAND HELP"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo ""
      echo "Usage: git/hotfix.sh <hotfix-name>"
      echo ""
      echo "Creates a new hotfix branch from the main branch."
      echo ""
      echo "Rules:"
      echo "  • Fails if working tree is dirty"
      echo "  • Checks out main, pulls latest"
      echo "  • Creates hotfix/<name>"
      echo "  • Auto-pushes with upstream"
      echo ""
      echo "When to use:"
      echo "  • Fixing critical production bugs"
      echo "  • Security vulnerabilities"
      echo "  • Issues requiring immediate production fix"
      echo ""
      echo "Examples:"
      echo "  git/hotfix.sh critical-payment-bug"
      echo "  git/hotfix.sh security-patch"
      echo "  git/hotfix.sh fix-data-corruption"
      echo ""
      echo "What it does:"
      echo "  1. Checks for dirty working tree (fails if dirty)"
      echo "  2. Switches to main and pulls latest changes"
      echo "  3. Creates hotfix/<name> branch"
      echo "  4. Pushes branch with upstream tracking"
      echo ""
      echo "Note: Hotfixes require PR review before merging to main"
      ;;

    push)
      echo "📤 PUSH COMMAND HELP"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo ""
      echo "Usage: git/push.sh \"commit message\""
      echo ""
      echo "Commits changes and safely pushes the current branch to remote."
      echo ""
      echo "Rules:"
      echo "  • BLOCKS pushing from main or dev"
      echo "  • Auto-detects current branch"
      echo "  • Runs: git add ."
      echo "  • Runs: git commit -m \"message\""
      echo "  • Runs: git pull --rebase"
      echo "  • Then: git push -u origin <branch>"
      echo ""
      echo "When to use:"
      echo "  • After making changes to your branch"
      echo "  • Regular commits and pushes during development"
      echo "  • Before closing a branch"
      echo ""
      echo "Examples:"
      echo "  git/push.sh \"Add user authentication\""
      echo "  git/push.sh \"Fix login validation bug\""
      echo ""
      echo "What it does:"
      echo "  1. Auto-detects current branch"
      echo "  2. Blocks if branch is main or dev"
      echo "  3. Stages all changes (git add .)"
      echo "  4. Commits with your message"
      echo "  5. Pulls with rebase from remote"
      echo "  6. Pushes to origin with upstream tracking"
      echo ""
      echo "Note: Cannot push directly to protected branches (main/dev)"
      echo "      Use git/pr.sh to create pull requests instead"
      ;;

    close)
      echo "🔀 CLOSE COMMAND HELP"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo ""
      echo "Usage: git/close.sh"
      echo ""
      echo "Safe branch cleanup with auto-PR fallback."
      echo ""
      echo "HARD RULES:"
      echo "  • ABSOLUTE BLOCK: Cannot close dev or main"
      echo "  • Checks if branch is merged into target"
      echo "  • If NOT merged: Auto-creates PR instead"
      echo "  • If merged: Switches to target, deletes local & remote"
      echo ""
      echo "When to use:"
      echo "  • When your feature/bugfix/hotfix is complete"
      echo "  • Ready to merge your work"
      echo "  • After all tests pass"
      echo ""
      echo "Behavior by branch type:"
      echo "  • feature/* → checks merge into dev"
      echo "  • bugfix/*  → checks merge into dev"
      echo "  • hotfix/*  → checks merge into main"
      echo ""
      echo "What it does:"
      echo "  1. Blocks if branch is dev or main"
      echo "  2. Determines target branch based on branch type"
      echo "  3. Checks if branch is merged into target"
      echo "  4. If NOT merged: Creates PR via git/pr.sh"
      echo "  5. If merged: Switches to target, deletes local & remote branch"
      echo ""
      echo "Note: Make sure all changes are committed before closing!"
      ;;

    pr)
      echo "📋 PR COMMAND HELP"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo ""
      echo "Usage: git/pr.sh [dev|main]"
      echo ""
      echo "Creates a Pull Request automatically."
      echo ""
      echo "Rules:"
      echo "  • Default target: dev"
      echo "  • Auto-detects branch type"
      echo "  • Enforces: feature/* → dev, bugfix/* → dev, hotfix/* → main"
      echo "  • Blocks invalid combinations"
      echo "  • Uses GitHub CLI (gh) if available, otherwise prints URL"
      echo ""
      echo "When to use:"
      echo "  • Creating PRs manually"
      echo "  • Hotfix branches (automatically called by close.sh)"
      echo "  • When you need to create a pull request"
      echo ""
      echo "Examples:"
      echo "  git/pr.sh dev"
      echo "  git/pr.sh main"
      echo ""
      echo "What it does:"
      echo "  1. Validates target branch (dev or main)"
      echo "  2. Auto-detects branch type"
      echo "  3. Validates branch type vs target"
      echo "  4. Creates PR using GitHub CLI or prints URL"
      echo ""
      echo "Branch Type Rules:"
      echo "  • feature/* → dev only"
      echo "  • bugfix/*  → dev only"
      echo "  • hotfix/*  → main only"
      ;;

    release)
      echo "🚀 RELEASE COMMAND HELP"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo ""
      echo "Usage: git/release.sh [patch|minor|major]"
      echo ""
      echo "Automates production releases using semantic versioning."
      echo ""
      echo "Rules:"
      echo "  • Must be executed from dev branch"
      echo "  • Fails if working tree is dirty"
      echo "  • Finds latest tag (vX.Y.Z)"
      echo "  • Auto-increments version"
      echo ""
      echo "Arguments:"
      echo "  type    Version bump: major, minor, or patch (default: patch)"
      echo ""
      echo "When to use:"
      echo "  • Preparing a new release"
      echo "  • After features/bugfixes are merged to dev"
      echo "  • Before deploying to production"
      echo ""
      echo "Examples:"
      echo "  git/release.sh patch    # v1.0.0 → v1.0.1"
      echo "  git/release.sh minor    # v1.0.0 → v1.1.0"
      echo "  git/release.sh major    # v1.0.0 → v2.0.0"
      echo ""
      echo "RELEASE FLOW (strict order):"
      echo "  1. Validate on dev"
      echo "  2. Calculate new version"
      echo "  3. Checkout main, pull latest"
      echo "  4. Merge dev into main"
      echo "  5. Create tag: vX.Y.Z"
      echo "  6. Push main and tag"
      echo "  7. Checkout dev"
      echo "  8. Merge main back into dev"
      echo "  9. Push dev"
      echo ""
      echo "Note: Full automation - no manual steps needed!"
      ;;

    *)
      echo "❌ Unknown command: $command"
      echo ""
      echo "Available commands for detailed help:"
      echo "  feature, bugfix, hotfix, push, close, pr, release"
      echo ""
      echo "Or run: git/help.sh (without arguments) for full guide"
      exit 1
      ;;
  esac
}

# Main script logic
if [[ $1 == "-h" || $1 == "--help" ]]; then
  show_main_help
  exit 0
fi

if [[ -z "$1" ]]; then
  show_main_help
else
  show_command_help "$1"
fi
