#!/usr/bin/env bash
set -u

bundle_path="${1:-}"

if [ -z "$bundle_path" ]; then
  echo "SPEC_BUNDLE_INVALID missing_bundle_path"
  echo "usage: validate-spec-bundle.sh <target-spec-directory>"
  exit 64
fi

if [ -f "$bundle_path" ]; then
  echo "SPEC_BUNDLE_INVALID single_file_spec"
  echo "path=$bundle_path"
  echo "expected=directory containing requirements.md design.md tasks.md"
  exit 65
fi

if [ ! -d "$bundle_path" ]; then
  echo "SPEC_BUNDLE_INVALID missing_directory"
  echo "path=$bundle_path"
  exit 66
fi

missing=""
for rel_path in requirements.md design.md tasks.md; do
  if [ ! -f "$bundle_path/$rel_path" ]; then
    missing="${missing}${rel_path}
"
  fi
done

if [ -n "$missing" ]; then
  echo "SPEC_BUNDLE_INVALID missing_required_files"
  echo "path=$bundle_path"
  echo "missing_files:"
  printf '%s' "$missing" | sed 's/^/  - /'
  exit 67
fi

link_errors=""

if ! grep -Fq 'Linked design: `design.md`' "$bundle_path/requirements.md"; then
  link_errors="${link_errors}requirements.md missing Linked design: \`design.md\`
"
fi

if ! grep -Fq 'Linked tasks: `tasks.md`' "$bundle_path/requirements.md"; then
  link_errors="${link_errors}requirements.md missing Linked tasks: \`tasks.md\`
"
fi

if ! grep -Fq 'Requirement source: `requirements.md`' "$bundle_path/design.md"; then
  link_errors="${link_errors}design.md missing Requirement source: \`requirements.md\`
"
fi

if ! grep -Fq 'Task source: `tasks.md`' "$bundle_path/design.md"; then
  link_errors="${link_errors}design.md missing Task source: \`tasks.md\`
"
fi

if ! grep -Fq 'Requirement source: `requirements.md`' "$bundle_path/tasks.md"; then
  link_errors="${link_errors}tasks.md missing Requirement source: \`requirements.md\`
"
fi

if ! grep -Fq 'Design source: `design.md`' "$bundle_path/tasks.md"; then
  link_errors="${link_errors}tasks.md missing Design source: \`design.md\`
"
fi

if [ -n "$link_errors" ]; then
  echo "SPEC_BUNDLE_INVALID link_errors"
  echo "path=$bundle_path"
  echo "errors:"
  printf '%s' "$link_errors" | sed 's/^/  - /'
  exit 68
fi

echo "SPEC_BUNDLE_VALID"
echo "path=$bundle_path"
echo "files=requirements.md,design.md,tasks.md"
