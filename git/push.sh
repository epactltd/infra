#!/bin/bash
# ⚠️ DO NOT MODIFY WITHOUT REVIEW
# Enforces Conventional Commits with typed arguments

set -e

# ========================
# Colors
# ========================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ========================
# Output Helpers
# ========================
print_error()   { echo -e "${RED}❌ $1${NC}" >&2; }
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_info()    { echo -e "${BLUE}ℹ️  $1${NC}"; }

# ========================
# Help
# ========================
print_help() {
cat <<EOF
Usage:
  git/push.sh <type> "<message>"
  git/push.sh <type> breaking "<message>"

Examples:
  git/push.sh feat "add otp login"
  git/push.sh fix "prevent double charge"
  git/push.sh feat breaking "change auth token format"

────────────────────────────────────────────
Commit Types Guide (When to Use Each)
────────────────────────────────────────────

feat       → NEW feature for users
             Examples: new API, new UI page, new trading feature
             Affects version: MINOR

fix        → BUG fix in existing functionality
             Examples: wrong calculation, crash, validation bug
             Affects version: PATCH

perf       → Performance improvement ONLY
             Examples: query optimization, caching, memory reduction
             Affects version: PATCH

refactor   → Code restructure WITHOUT behavior change
             Examples: rename classes, split services, simplify logic
             Affects version: NONE

docs       → Documentation only
             Examples: README, comments, API docs
             Affects version: NONE

test       → Tests only
             Examples: unit tests, feature tests
             Affects version: NONE

chore      → Maintenance & tooling
             Examples: dependency updates, env changes, scripts
             Affects version: NONE

ci         → CI/CD pipeline changes only
             Examples: GitHub Actions, GitLab pipelines
             Affects version: NONE

build      → Build system changes
             Examples: Vite, Webpack, Docker, bundlers
             Affects version: NONE

style      → Formatting only (NO logic change)
             Examples: spacing, lint fixes, prettier
             Affects version: NONE

────────────────────────────────────────────
Breaking Changes
────────────────────────────────────────────

Use the keyword: breaking

Example:
  git/push.sh feat breaking "change auth token format"

This generates:
  feat!: change auth token format

Breaking changes trigger a MAJOR version increase.

────────────────────────────────────────────
Protected Branch Rules
────────────────────────────────────────────

Direct push is BLOCKED on:
  - dev
  - main

You must use feature/*, bugfix/*, or hotfix/* branches.
Then open a PR using: git/pr.sh

EOF
}

# ========================
# Validate Arguments
# ========================
if [ -z "$1" ]; then
  print_help
  exit 1
fi

TYPE="$1"
BREAKING_FLAG=""
MESSAGE=""

ALLOWED_TYPES="feat|fix|docs|style|refactor|perf|test|chore|ci|build"

if ! echo "$TYPE" | grep -Eq "^($ALLOWED_TYPES)$"; then
  print_error "Invalid commit type: '$TYPE'"
  print_help
  exit 1
fi

if [ "$2" = "breaking" ]; then
  if [ -z "$3" ]; then
    print_error "Commit message is required when using 'breaking'"
    exit 1
  fi
  BREAKING_FLAG="!"
  MESSAGE="$3"
else
  if [ -z "$2" ]; then
    print_error "Commit message is required"
    print_help
    exit 1
  fi
  MESSAGE="$2"
fi

if [ -z "$MESSAGE" ]; then
  print_error "Commit message cannot be empty"
  exit 1
fi

FINAL_COMMIT_MESSAGE="${TYPE}${BREAKING_FLAG}: ${MESSAGE}"

# ========================
# Validate Final Commit Message
# ========================
COMMIT_REGEX="^(feat|fix|docs|style|refactor|perf|test|chore|ci|build)(\\(.+\\))?(!)?: .+$"

if ! echo "$FINAL_COMMIT_MESSAGE" | grep -Eq "$COMMIT_REGEX"; then
  print_error "Generated commit message is invalid:"
  echo "  $FINAL_COMMIT_MESSAGE"
  exit 1
fi

# ========================
# Git Repository Check
# ========================
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  print_error "Not in a Git repository"
  exit 1
fi

# ========================
# Detect Current Branch
# ========================
current_branch=$(git rev-parse --abbrev-ref HEAD)

print_info "Current branch: $current_branch"
print_info "Commit message: $FINAL_COMMIT_MESSAGE"
echo ""

# ========================
# Block Protected Branches
# ========================
if [ "$current_branch" = "main" ] || [ "$current_branch" = "dev" ]; then
  print_error "Cannot push directly to '$current_branch'"
  print_warning "Protected branches cannot be pushed directly"
  print_info "Use git/pr.sh to create a pull request instead"
  exit 1
fi

# ========================
# Git Add
# ========================
print_info "Executing: git add ."
git add .

# ========================
# Commit
# ========================
if git diff --cached --quiet; then
  print_warning "No changes to commit"
else
  print_info "Executing: git commit -m \"$FINAL_COMMIT_MESSAGE\""
  git commit -m "$FINAL_COMMIT_MESSAGE"
  print_success "Changes committed successfully"
fi

# ========================
# Pull with Rebase
# ========================
print_info "Executing: git pull --rebase origin $current_branch"
if ! git pull --rebase origin "$current_branch"; then
  print_warning "No remote branch found or rebase skipped (this is OK for new branches)"
fi

# ========================
# Push with Upstream
# ========================
print_info "Executing: git push -u origin $current_branch"
git push -u origin "$current_branch"

print_success "Branch '$current_branch' pushed successfully!"
