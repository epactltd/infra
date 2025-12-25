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

# Must be executed from dev or main
current_branch=$(git rev-parse --abbrev-ref HEAD)

print_info "Current branch: $current_branch"
print_info "Version type: $version_type"
echo ""

if [ "$current_branch" != "dev" ] && [ "$current_branch" != "main" ]; then
  print_error "Release must be executed from dev or main branch"
  print_info "Current branch: $current_branch (allowed: dev, main)"
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
has_previous_tag=true

if [ -z "$latest_tag" ]; then
  print_warning "No tags found, starting from v0.0.0"
  latest_tag="v0.0.0"
  has_previous_tag=false
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

# GitHub Release helper (deploy workflow triggers on release:published)
script_dir="$(cd "$(dirname "$0")" && pwd)"

save_release_notes() {
  # Persists the exact GitHub-generated notes to files in the repo.
  # This happens AFTER publishing the GitHub Release, so the saved notes match what deployed.
  if ! command -v gh >/dev/null 2>&1; then
    return 0
  fi

  local notes_dir="$script_dir/releases"
  local notes_file="$notes_dir/$new_tag.md"
  local latest_file="$script_dir/release-note.txt"

  mkdir -p "$notes_dir"

  print_info "Saving GitHub Release notes to:"
  print_info " - $notes_file"
  print_info " - $latest_file"

  if gh release view "$new_tag" --json body -q .body > "$notes_file"; then
    cp "$notes_file" "$latest_file"
  else
    print_warning "Could not fetch release notes via gh (skipping saving notes to files)"
    return 1
  fi

  # Commit & push notes (keeps dev in sync later via main → dev merge)
  print_info "Committing release notes..."
  git add "$notes_file" "$latest_file"

  if git diff --cached --quiet; then
    print_warning "No release notes changes to commit"
    return 0
  fi

  if git commit -m "docs: release notes for $new_tag"; then
    print_info "Executing: git push origin main"
    if ! git push origin main; then
      print_warning "Failed to push release notes commit to main (continuing)"
      return 1
    fi
  else
    print_warning "Failed to commit release notes (continuing)"
    return 1
  fi

  return 0
}

create_github_release() {
  if command -v gh >/dev/null 2>&1; then
    print_info "Publishing GitHub Release (triggers deploy)..."
    print_info "Executing: gh release create $new_tag --title 'Release $new_tag' --generate-notes"
    if gh release create "$new_tag" --title "Release $new_tag" --generate-notes; then
      print_success "GitHub Release published successfully!"
      save_release_notes || true
      return 0
    else
      print_warning "Failed to publish GitHub Release via gh"
      print_warning "You may need to publish it manually in GitHub UI."
      return 1
    fi
  fi

  print_warning "GitHub CLI (gh) not available. Tag was created, but deploy will NOT trigger until a GitHub Release is published."
  repo_url=$(git config --get remote.origin.url | sed 's#https://github.com/##;s#git@[^:]*:##;s#\.git$##')
  print_info "Publish a Release for tag $new_tag here:"
  print_info "https://github.com/$repo_url/releases/new?tag=$new_tag"
  return 1
}

# RELEASE FLOW - STRICT ORDER (two modes)
# - dev  : full release train (dev → main tag/release → main → dev)
# - main : hotfix release (main tag/release → main → dev)

if [ "$current_branch" = "dev" ]; then
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

  # 8. Publish GitHub Release (triggers deploy workflow)
  create_github_release || true

  # 9. Checkout dev
  print_info "Executing: git checkout dev"
  if ! git checkout dev; then
    print_error "Failed to checkout dev branch"
    exit 1
  fi

  # 10. Merge main back into dev
  print_info "Executing: git merge --no-ff main -m 'Merge main back into dev after release $new_tag'"
  if ! git merge --no-ff main -m "Merge main back into dev after release $new_tag"; then
    print_error "Failed to merge main back into dev"
    print_info "Please resolve conflicts and try again"
    exit 1
  fi

  # 11. Push dev
  print_info "Executing: git push origin dev"
  if ! git push origin dev; then
    print_error "Failed to push dev branch"
    exit 1
  fi
else
  # main: hotfix-style release (do NOT merge dev → main)
  print_success "Validated on main branch"
  print_success "Calculated new version: $new_tag"

  # 1. Pull latest main
  print_info "Executing: git pull origin main"
  if ! git pull origin main; then
    print_error "Failed to pull latest changes from main"
    exit 1
  fi

  # 2. Create tag on main HEAD
  print_info "Executing: git tag -a $new_tag -m 'Release $new_tag'"
  if ! git tag -a "$new_tag" -m "Release $new_tag"; then
    print_error "Failed to create tag"
    exit 1
  fi

  # 3. Push main (no-op if already up to date) and tag
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

  # 4. Publish GitHub Release (triggers deploy workflow)
  create_github_release || true

  # 5. Sync dev with main so hotfix is not lost
  print_info "Executing: git checkout dev"
  if ! git checkout dev; then
    print_error "Failed to checkout dev branch"
    exit 1
  fi

  print_info "Executing: git pull origin dev"
  if ! git pull origin dev; then
    print_error "Failed to pull latest changes from dev"
    exit 1
  fi

  print_info "Executing: git merge --no-ff main -m 'Merge main back into dev after release $new_tag'"
  if ! git merge --no-ff main -m "Merge main back into dev after release $new_tag"; then
    print_error "Failed to merge main back into dev"
    print_info "Please resolve conflicts and try again"
    exit 1
  fi

  print_info "Executing: git push origin dev"
  if ! git push origin dev; then
    print_error "Failed to push dev branch"
    exit 1
  fi

  print_info "Executing: git checkout main"
  if ! git checkout main; then
    print_error "Failed to checkout main branch"
    exit 1
  fi
fi

echo ""
print_success "Release $new_tag completed successfully!"
print_info "Tagged and pushed: $new_tag"
if [ "$current_branch" = "dev" ]; then
  print_info "Merged dev → main → dev"
  print_info "You are now on: dev"
else
  print_info "Tagged from main and synced main → dev"
  print_info "You are now on: main"
fi
