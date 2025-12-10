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

# Get current branch
current_branch=$(git rev-parse --abbrev-ref HEAD)

print_info "Current branch: $current_branch"
echo ""

# ABSOLUTE BLOCK: Never allow closing dev or main
if [ "$current_branch" = "dev" ] || [ "$current_branch" = "main" ]; then
  print_error "Cannot close protected branch: $current_branch"
  print_error "Protected branches (dev, main) cannot be deleted"
  exit 1
fi

# Determine target branch based on branch type
target_branch=""
if [ "${current_branch#feature/}" != "$current_branch" ]; then
  target_branch="dev"
elif [ "${current_branch#bugfix/}" != "$current_branch" ]; then
  target_branch="dev"
elif [ "${current_branch#hotfix/}" != "$current_branch" ]; then
  target_branch="main"
else
  print_error "Unknown branch type: $current_branch"
  print_info "Supported types: feature/*, bugfix/*, hotfix/*"
  exit 1
fi

print_info "Target branch: $target_branch"
echo ""

# Check if branch is merged into target
print_info "Checking if branch is merged into $target_branch..."
print_info "Executing: git fetch origin $target_branch"
git fetch origin "$target_branch" >/dev/null 2>&1 || true

print_info "Executing: git merge-base --is-ancestor $current_branch origin/$target_branch"

merged=false
# Check if current branch's HEAD is an ancestor of remote target branch
# This means all commits in current_branch are already in target_branch
if git merge-base --is-ancestor "$current_branch" "origin/$target_branch" 2>/dev/null; then
  merged=true
fi

# If NOT merged, create PR instead
if [ "$merged" = false ]; then
  print_warning "Branch '$current_branch' is NOT merged into $target_branch"
  print_info "Creating PR instead of deleting..."
  echo ""

  # Get script directory
  script_dir="$(cd "$(dirname "$0")" && pwd)"

  # Create PR
  print_info "Executing: $script_dir/pr.sh $target_branch"
  if "$script_dir/pr.sh" "$target_branch"; then
    print_success "PR created successfully!"
    print_warning "Branch not merged. PR created instead."
    print_info "Exiting without deleting anything."
    print_info "After PR is merged, run this script again to delete the branch."
    exit 0
  else
    print_error "Failed to create PR"
    exit 1
  fi
fi

# Branch is merged, proceed with cleanup
print_success "Branch '$current_branch' is merged into $target_branch"
echo ""

# Switch to target branch
print_info "Switching to target branch..."
print_info "Executing: git checkout $target_branch"
if ! git checkout "$target_branch"; then
  print_error "Failed to checkout $target_branch"
  exit 1
fi

# Pull latest
print_info "Executing: git pull origin $target_branch"
if ! git pull origin "$target_branch"; then
  print_warning "Failed to pull latest changes (continuing anyway)"
fi

# Delete local branch
print_info "Deleting local branch..."
print_info "Executing: git branch -d $current_branch"
if git branch -d "$current_branch"; then
  print_success "Local branch deleted: $current_branch"
else
  print_warning "Could not delete local branch (may have unmerged changes)"
fi

# Delete remote branch if it exists
print_info "Checking for remote branch..."
if git ls-remote --heads origin "$current_branch" | grep -q "$current_branch"; then
  print_info "Executing: git push origin --delete $current_branch"
  if git push origin --delete "$current_branch"; then
    print_success "Remote branch deleted: $current_branch"
  else
    print_warning "Could not delete remote branch"
  fi
else
  print_info "Remote branch does not exist, skipping deletion"
fi

echo ""
print_success "Branch '$current_branch' closed successfully!"
print_info "You are now on: $target_branch"
