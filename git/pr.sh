#!/bin/bash
# ⚠️ DO NOT MODIFY WITHOUT REVIEW

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print colored messages
print_error() {
  echo -e "${RED}❌ $1${NC}" >&2
}

print_success() {
  echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
  echo -e "${GREEN}ℹ️  $1${NC}"
}

# Ensure we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  print_error "Not in a Git repository"
  exit 1
fi

# Default target is dev
target="${1:-dev}"

# Validate target
if [ "$target" != "dev" ] && [ "$target" != "main" ]; then
  print_error "Invalid target branch: $target"
  print_info "Valid targets: dev, main"
  exit 1
fi

# Auto-detect current branch
current_branch=$(git rev-parse --abbrev-ref HEAD)

print_info "Current branch: $current_branch"
print_info "Target branch: $target"
echo ""

# Determine branch type and validate
branch_type=""
if [ "${current_branch#feature/}" != "$current_branch" ]; then
  branch_type="feature"
elif [ "${current_branch#bugfix/}" != "$current_branch" ]; then
  branch_type="bugfix"
elif [ "${current_branch#hotfix/}" != "$current_branch" ]; then
  branch_type="hotfix"
else
  print_warning "Unknown branch type: $current_branch"
  print_info "Proceeding with manual PR creation"
fi

# Enforce branch type rules
if [ -n "$branch_type" ]; then
  case "$branch_type" in
    feature)
      if [ "$target" != "dev" ]; then
        print_error "feature/* branches can only create PRs to dev"
        exit 1
      fi
      ;;
    bugfix)
      if [ "$target" != "dev" ]; then
        print_error "bugfix/* branches can only create PRs to dev"
        exit 1
      fi
      ;;
    hotfix)
      if [ "$target" != "main" ]; then
        print_error "hotfix/* branches can only create PRs to main"
        exit 1
      fi
      ;;
  esac
fi

# Check if GitHub CLI is available
if command -v gh >/dev/null 2>&1; then
  print_info "Using GitHub CLI (gh) to create PR"
  print_info "Executing: gh pr create --base $target --head $current_branch"

  if gh pr create --base "$target" --head "$current_branch"; then
    print_success "Pull request created successfully!"
    exit 0
  else
    print_warning "GitHub CLI PR creation failed, falling back to URL"
  fi
fi

# Fallback: Print PR URL
print_info "GitHub CLI not available or failed. Use the URL below to create PR manually:"
repo_url=$(git config --get remote.origin.url | sed 's#https://github.com/##;s#git@github.com:##;s#\.git$##')
pr_url="https://github.com/$repo_url/compare/$target...$current_branch?expand=1"
print_info "PR URL: $pr_url"

# Try to open browser
if [ "$OSTYPE" = "msys" ] || [ "$OSTYPE" = "cygwin" ]; then
  start "$pr_url" 2>/dev/null || true
elif [ "$OSTYPE" = "darwin" ]; then
  open "$pr_url" 2>/dev/null || true
elif [ "$OSTYPE" = "linux-gnu" ]; then
  xdg-open "$pr_url" 2>/dev/null || true
fi

print_success "PR URL generated. Please create the PR manually if needed."
