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

# Validate version type (default: patch)
version_type="${1:-patch}"

if [ "$version_type" != "major" ] && [ "$version_type" != "minor" ] && [ "$version_type" != "patch" ]; then
  print_error "Invalid version type: $version_type"
  print_info "Valid types: patch, minor, major"
  exit 1
fi

# Must be executed from dev
current_branch=$(git rev-parse --abbrev-ref HEAD)

print_info "Current branch: $current_branch"
print_info "Version type: $version_type"
echo ""

if [ "$current_branch" != "dev" ]; then
  print_error "Release must be executed from dev branch"
  print_info "Current branch: $current_branch"
  exit 1
fi

# Check if working tree is dirty
if ! git diff --quiet || ! git diff --cached --quiet; then
  print_error "Working tree is dirty. Please commit or stash changes first."
  exit 1
fi

# Find latest tag
print_info "Finding latest tag..."
print_info "Executing: git tag -l 'v*' | sort -V | tail -1"

latest_tag=$(git tag -l 'v*' | sort -V | tail -1 || echo "")

if [ -z "$latest_tag" ]; then
  print_warning "No tags found, starting from v0.0.0"
  latest_tag="v0.0.0"
fi

print_info "Latest tag: $latest_tag"

# Extract version numbers (remove 'v' prefix)
version="${latest_tag#v}"
IFS='.' read -r major minor patch <<EOF
$version
EOF

# Calculate new version
case "$version_type" in
  major)
    new_major=$((major + 1))
    new_minor=0
    new_patch=0
    ;;
  minor)
    new_major=$major
    new_minor=$((minor + 1))
    new_patch=0
    ;;
  patch)
    new_major=$major
    new_minor=$minor
    new_patch=$((patch + 1))
    ;;
esac

new_version="$new_major.$new_minor.$new_patch"
new_tag="v$new_version"

print_info "New version: $new_tag"
echo ""

# RELEASE FLOW - STRICT ORDER

# 1. Validate on dev (already done)
print_success "Validated on dev branch"

# 2. Calculate new version (already done)
print_success "Calculated new version: $new_tag"

# 3. Checkout main
print_info "Executing: git checkout main"
if ! git checkout main; then
  print_error "Failed to checkout main branch"
  exit 1
fi

# 4. Pull latest main
print_info "Executing: git pull origin main"
if ! git pull origin main; then
  print_error "Failed to pull latest changes from main"
  exit 1
fi

# 5. Merge dev into main
print_info "Executing: git merge --no-ff dev -m 'Merge dev into main for release $new_tag'"
if ! git merge --no-ff dev -m "Merge dev into main for release $new_tag"; then
  print_error "Failed to merge dev into main"
  print_info "Please resolve conflicts and try again"
  exit 1
fi

# 6. Create tag
print_info "Executing: git tag -a $new_tag -m 'Release $new_tag'"
if ! git tag -a "$new_tag" -m "Release $new_tag"; then
  print_error "Failed to create tag"
  exit 1
fi

# 7. Push main and tag
print_info "Executing: git push origin main"
if ! git push origin main; then
  print_error "Failed to push main branch"
  exit 1
fi

print_info "Executing: git push origin $new_tag"
if ! git push origin "$new_tag"; then
  print_error "Failed to push tag"
  exit 1
fi

# 8. Checkout dev
print_info "Executing: git checkout dev"
if ! git checkout dev; then
  print_error "Failed to checkout dev branch"
  exit 1
fi

# 9. Merge main back into dev
print_info "Executing: git merge --no-ff main -m 'Merge main back into dev after release $new_tag'"
if ! git merge --no-ff main -m "Merge main back into dev after release $new_tag"; then
  print_error "Failed to merge main back into dev"
  print_info "Please resolve conflicts and try again"
  exit 1
fi

# 10. Push dev
print_info "Executing: git push origin dev"
if ! git push origin dev; then
  print_error "Failed to push dev branch"
  exit 1
fi

echo ""
print_success "Release $new_tag completed successfully!"
print_info "Tagged and pushed: $new_tag"
print_info "Merged dev → main → dev"
print_info "You are now on: dev"
