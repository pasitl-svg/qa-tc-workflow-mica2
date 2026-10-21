#!/usr/bin/env bash
# Build a self-contained skill ZIP for uploading to Claude Desktop / claude.ai.
#
# Usage: ./scripts/build-desktop-zip.sh   (output: dist/qa-tc-workflow-mica2.zip)
#
# The repo's SKILL.md is a thin stub that links to ../procedures/<name>/WORKFLOW.md,
# which does not exist inside an uploaded ZIP. This script merges the stub's
# frontmatter with WORKFLOW.md into one SKILL.md and copies references/ next to it.

set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
NAME="qa-tc-workflow-mica2"
STUB="$REPO/skills/$NAME/SKILL.md"
PROC="$REPO/skills/procedures/$NAME"
DIST="$REPO/dist"
BUILD="$(mktemp -d)"
trap 'rm -rf "$BUILD"' EXIT

mkdir -p "$BUILD/$NAME" "$DIST"

# frontmatter (first two --- lines and everything between) + full procedure
awk 'n < 2 { print } /^---$/ { n++ }' "$STUB" > "$BUILD/$NAME/SKILL.md"
printf '\n' >> "$BUILD/$NAME/SKILL.md"
cat "$PROC/WORKFLOW.md" >> "$BUILD/$NAME/SKILL.md"
cp -R "$PROC/references" "$BUILD/$NAME/references"

rm -f "$DIST/$NAME.zip"
(cd "$BUILD" && zip -qr "$DIST/$NAME.zip" "$NAME" -x '*.DS_Store')

echo "Built $DIST/$NAME.zip"
