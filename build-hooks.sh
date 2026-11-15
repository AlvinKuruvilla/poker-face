#!/usr/bin/env bash
# Generate hooks/hooks.json from rules.md and hooks/prompt.md.
#
# Claude Code does not expand ${CLAUDE_PLUGIN_ROOT} inside an agent hook's
# prompt (tested on v2.1.325: the prompt received the literal placeholder), so
# the hook cannot read rules.md at run time. The rules are copied into every
# prompt instead. Only this script does the copying, so after editing rules.md
# or hooks/prompt.md, run it. The CI workflow in .github/workflows/check.yml
# reruns it and fails if hooks/hooks.json changes.
#
# Requires jq.

set -euo pipefail

cd "$(dirname "$0")"

# Substitute in jq, not with bash's ${var/pattern/replacement}: bash 5.2
# expands each `&` in the replacement to the matched text, so every `&` in
# rules.md would come out as a literal `{{RULES}}` in the prompt.
prompt=$(jq -rn --rawfile template hooks/prompt.md --rawfile rules rules.md \
    '$template | split("{{RULES}}") | join($rules | sub("\n+$"; ""))')

# Each surface where prose leaves Claude Code, as a matcher on the tool name
# plus, for Bash, an `if` rule on the command. Every matching handler starts a
# model call, so Bash is narrowed to the subcommands that publish text: `gh pr
# view` and `gh pr list` must not pay for a review.
bash_rules=(
    "git commit *"
    "gh pr create *"
    "gh pr edit *"
    "gh pr comment *"
    "gh pr review *"
    "gh issue create *"
    "gh issue edit *"
    "gh issue comment *"
)

# MCP tools that send or publish text. Names vary by server, so this matches
# on the verb: Slack's slack_send_message, a mail server's send_email. Claude
# Docs edits are listed by name because their verbs are generic.
mcp_matcher='mcp__.*(send_message|schedule_message|send_message_draft|create_canvas|update_canvas|send_email|create_draft|post_message|create_comment|add_comment)|mcp__.*Claude_Docs__(batch|create|update)'

printf '%s\n' "${bash_rules[@]}" | jq -R . | jq -s \
    --arg prompt "$prompt" \
    --arg mcp_matcher "$mcp_matcher" '
    def review: {
        type: "agent",
        model: "sonnet",
        timeout: 90,
        statusMessage: "poker-face: checking prose",
        prompt: $prompt
    };
    {
        hooks: {
            PreToolUse: (
                [{ matcher: "Write|Edit", hooks: [review] }]
                + [.[] | { matcher: "Bash", hooks: [review + { if: "Bash(\(.))" }] }]
                + [{ matcher: $mcp_matcher, hooks: [review] }]
            )
        }
    }' >hooks/hooks.json

echo "wrote hooks/hooks.json ($(wc -c <hooks/hooks.json | tr -d ' ') bytes)"
