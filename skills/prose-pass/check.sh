#!/usr/bin/env bash
# Grep the mechanically detectable slop tells. This is the cheap half of the pass;
# the shapes in SKILL.md that grep cannot see are the half that matters.
#
# Usage: check.sh FILE [FILE...]
# Exits 1 if anything matched, so it can gate a commit.

set -euo pipefail

if [ $# -eq 0 ]; then
    echo "usage: $(basename "$0") FILE [FILE...]" >&2
    exit 2
fi

# Each entry is "label<TAB>extended-regex". Case-insensitive throughout.
patterns=(
    "vocabulary	\\b(delve|leverage|utilize|robust|seamless|comprehensive|crucial|vital|elegant|powerful|streamline|unlock|empower|landscape|realm|journey)\\b"
    "ensure	\\bensures?\\b"
    "frame: worth X-ing	\\bworth [a-z]+ing\\b"
    "frame: announcing itself	\\b(to be clear|for the record|it bears mentioning|i want to flag|here'?s the thing|candidly|being straight|the honest (costs?|truth)|one thing i should)\\b"
    "frame: text about itself	\\b(this (is|section|part) (is )?the (interesting|important|key) part|the following|two (things|parts) (of this|worth))\\b"
    "ordering announcement	\\b(so i'?ll start there|i'?ll start (there|with)|let me (start|begin) (with|there)|starting with the|first,? let'?s)\\b"
    "antithesis	(\\bnot just\\b[^.]{1,60}\\bbut\\b|\\bisn'?t\\b[^.]{1,40}\\bit'?s\\b|\\bneither\\b[^.]{1,60}\\bnor\\b|\\brather than\\b[^.]{1,40}\\bit\\b)"
    "empty hedge	\\b(can help to|may potentially|might possibly|could potentially)\\b"
    "AI attribution	\\b(co-authored-by: *claude|generated with \\[?claude|🤖)"
)

found=0

for file in "$@"; do
    if [ ! -f "$file" ]; then
        echo "check.sh: no such file: $file" >&2
        exit 2
    fi

    for entry in "${patterns[@]}"; do
        label=${entry%%	*}
        regex=${entry#*	}

        # -n for line numbers, -i for case, -E for the alternations above.
        if matches=$(grep -niE "$regex" "$file"); then
            found=1
            while IFS= read -r line; do
                printf '%s:%s  [%s]\n' "$file" "${line%%:*}" "$label"
                printf '    %s\n' "${line#*:}"
            done <<<"$matches"
        fi
    done
done

if [ "$found" -eq 1 ]; then
    echo
    echo "Mechanical tells above. Now do the four passes in SKILL.md --" \
         "first sentences, last sentences, the negated half, the joints."
    exit 1
fi

echo "No mechanical tells. The four passes in SKILL.md are still required."
