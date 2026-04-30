#!/usr/bin/env bash
# compute-version-bump.sh <feature-name> [major|minor|patch]
#
# Prints the next version for the given feature based on:
#   - the latest git tag reachable from the current branch's merge-base with main
#   - the requested bump level (default: patch)
#
# Bump levels:
#   major  – breaking change: removes/renames option or changes behavior incompatibly  (X+1.0.0)
#   minor  – new option or backwards-compatible new behavior                           (X.Y+1.0)
#   patch  – bug fix, internal refactor, docs/test change only                        (X.Y.Z+1)
#
# Usage:
#   bash .github/skills/feature-modify/scripts/compute-version-bump.sh common-utils patch
#   bash .github/skills/feature-modify/scripts/compute-version-bump.sh common-utils minor
#
# Output (stdout):  e.g. "2.5.10"

set -euo pipefail

FEATURE="${1:?Usage: $0 <feature-name> [major|minor|patch]}"
BUMP="${2:-patch}"

if [[ ! "${BUMP}" =~ ^(major|minor|patch)$ ]]; then
    echo "ERROR: bump level must be 'major', 'minor', or 'patch' (got: '${BUMP}')" >&2
    exit 1
fi

# Find the ref to search tags from:
# - on main: HEAD itself
# - on a branch: the merge-base with main
CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [ "${CURRENT_BRANCH}" = "main" ]; then
    REF="HEAD"
else
    REF="$(git merge-base HEAD main 2>/dev/null || git merge-base HEAD origin/main)"
fi

# Find the latest tag for this feature reachable from REF
LATEST_TAG="$(git tag --list "feature_${FEATURE}_*" --merged "${REF}" \
    | sort -t_ -k3 -V \
    | tail -1)"

if [ -z "${LATEST_TAG}" ]; then
    # No tag yet – read the version from devcontainer-feature.json as baseline
    LATEST_TAG="feature_${FEATURE}_$(jq -r .version "src/${FEATURE}/devcontainer-feature.json" 2>/dev/null || echo "0.0.0")"
fi

# Extract version string from tag (feature_<name>_<version>)
CURRENT_VERSION="${LATEST_TAG##*_}"

MAJOR="${CURRENT_VERSION%%.*}"
REST="${CURRENT_VERSION#*.}"
MINOR="${REST%%.*}"
PATCH="${REST##*.}"

case "${BUMP}" in
    major)
        NEXT="$(( MAJOR + 1 )).0.0"
        ;;
    minor)
        NEXT="${MAJOR}.$(( MINOR + 1 )).0"
        ;;
    patch)
        NEXT="${MAJOR}.${MINOR}.$(( PATCH + 1 ))"
        ;;
esac

echo "${NEXT}"
