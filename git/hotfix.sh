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

# Check if hotfix name is provided
if [ -z "$1" ]; then
  print_error "Hotfix name is required"
  echo "Usage: git/hotfix.sh <name>"
  exit 1
fi

# Normalize branch name: convert to lowercase and replace spaces with "-"
hotfix_name=$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
branch_name="hotfix/$hotfix_name"
current_branch=$(git rev-parse --abbrev-ref HEAD)

print_info "Current branch: $current_branch"
print_info "Target branch: main"
print_info "New branch: $branch_name"
echo ""

# Check if working tree is dirty
if ! git diff --quiet || ! git diff --cached --quiet; then
  print_error "Working tree is dirty. Please commit or stash changes first."
  exit 1
fi

# Checkout main
print_info "Executing: git checkout main"
if ! git checkout main; then
  print_error "Failed to checkout main branch"
  exit 1
fi

# Pull latest main
print_info "Executing: git pull origin main"
if ! git pull origin main; then
  print_error "Failed to pull latest changes from main"
  exit 1
fi

# Create hotfix branch
print_info "Executing: git checkout -b $branch_name"
if ! git checkout -b "$branch_name"; then
  print_error "Failed to create hotfix branch"
  exit 1
fi

# Push with upstream
print_info "Executing: git push -u origin $branch_name"
if ! git push -u origin "$branch_name"; then
  print_error "Failed to push hotfix branch"
  exit 1
fi

print_success "Hotfix branch '$branch_name' created and pushed successfully!"
print_info "You are now on: $branch_name"
