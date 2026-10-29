#!/bin/sh
set -euo pipefail

dir="$(dirname "$0")"
refsdir="$(realpath "$dir"/../references)"
tempdir="$(mktemp -dt "agentskills")"

git clone "https://github.com/agentskills/agentskills.git" "$tempdir"

cp "$tempdir/docs/specification.mdx" "$refsdir"
cp -r "$tempdir/docs/skill-creation/" "$refsdir/skill-creation/"

rm -rf "$tempdir"

unset dir
unset refsdir
unset tempdir
