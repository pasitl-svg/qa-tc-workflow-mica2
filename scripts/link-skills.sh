#!/usr/bin/env bash
# Link the skills in this repo into the Claude Code skill directory.
#
# Usage: ./scripts/link-skills.sh [DEST]   (DEST defaults to ~/.claude/skills)
#
# For each skills/<name>/SKILL.md (outside procedures/) this creates:
#   DEST/<name>             -> REPO/skills/<name>
#   DEST/procedures/<name>  -> REPO/skills/procedures/<name>   (if it exists)
# so the stub's ../procedures/<name>/WORKFLOW.md link resolves.
# A real directory already at a target is moved to <target>.bak-<timestamp>, never deleted.

set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DEST="${1:-$HOME/.claude/skills}"
STAMP="$(date +%Y%m%d-%H%M%S)"

link_one() {
  local src="$1"
  local target="$2"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$target.bak-$STAMP"
    echo "backed up $target -> $target.bak-$STAMP"
  fi

  ln -sfn "$src" "$target"
  echo "linked $target -> $src"
}

echo "=== link-skills (repo: $REPO, dest: $DEST) ==="

mkdir -p "$DEST"

find "$REPO/skills" -name SKILL.md -not -path '*/procedures/*' -print0 |
while IFS= read -r -d '' skill_md; do
  src="$(dirname "$skill_md")"
  name="$(basename "$src")"

  link_one "$src" "$DEST/$name"

  if [ -d "$REPO/skills/procedures/$name" ]; then
    if [ -L "$DEST/procedures" ]; then
      echo "skip procedures/$name: $DEST/procedures is a symlink to another location"
      continue
    fi
    mkdir -p "$DEST/procedures"
    link_one "$REPO/skills/procedures/$name" "$DEST/procedures/$name"
  fi
done

echo ""
echo "Done. Restart Claude Code, then use /qa-tc-workflow-mica2"
