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

# Check if feature name is provided
if [ -z "$1" ]; then
  print_error "Feature name is required"
  echo "Usage: git/feature.sh <name>"
  exit 1
fi

# Normalize branch name: convert to lowercase and replace spaces with "-"
feature_name=$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
branch_name="feature/$feature_name"
current_branch=$(git rev-parse --abbrev-ref HEAD)

print_info "Current branch: $current_branch"
print_info "Target branch: dev"
print_info "New branch: $branch_name"
echo ""

# Check if working tree is dirty
if ! git diff --quiet || ! git diff --cached --quiet; then
  print_error "Working tree is dirty. Please commit or stash changes first."
  exit 1
fi

# Checkout dev
print_info "Executing: git checkout dev"
if ! git checkout dev; then
  print_error "Failed to checkout dev branch"
  exit 1
fi

# Pull latest dev
print_info "Executing: git pull origin dev"
if ! git pull origin dev; then
  print_error "Failed to pull latest changes from dev"
  exit 1
fi

# Create feature branch
print_info "Executing: git checkout -b $branch_name"
if ! git checkout -b "$branch_name"; then
  print_error "Failed to create feature branch"
  exit 1
fi

# Push with upstream
print_info "Executing: git push -u origin $branch_name"
if ! git push -u origin "$branch_name"; then
  print_error "Failed to push feature branch"
  exit 1
fi

print_success "Feature branch '$branch_name' created and pushed successfully!"
print_info "You are now on: $branch_name"
