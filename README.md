# poker-face

A Claude Code plugin that reviews prose for LLM voice before Claude writes or
sends it, and blocks it with a rewrite when it finds a tell.

A banned-word list catches the cheap half. The tells that survive a proofread are
shapes: a sentence announcing that the next one matters, "not X, but Y" where
nobody proposed X, a closing sentence that restates its paragraph, "and" joining
a cause to its effect. poker-face hands each piece of outgoing prose to a
reviewer agent with a written rulebook, `rules.md`, and the tool call does not
run until the prose passes.

```text
PreToolUse:Bash hook error: Agent hook condition was not met:
1. Subject "core: leverage a robust approach". "leverage" and "robust" are
   banned vocabulary. The subject also says nothing about what changed.
```

## Install

```sh
claude plugin marketplace add AlvinKuruvilla/poker-face
claude plugin install poker-face@poker-face
```

## What it checks

| where the prose goes | tool call reviewed |
|---|---|
| code comments, docstrings, Markdown and other docs | Write, Edit |
| commit messages | `git commit` |
| PR titles, bodies, comments and reviews | `gh pr create`, `edit`, `comment`, `review` |
| issues and issue comments | `gh issue create`, `edit`, `comment` |
| messages, emails, canvases and docs sent through MCP | MCP tools whose names contain `send_message`, `send_email`, `post_message`, `create_comment` and similar verbs |

In code, only comments and docstrings are judged. Other Bash commands, such as
`git status` or `gh pr view`, are not reviewed.

Besides `rules.md`, the reviewer applies the prose rules in the repository's
`CLAUDE.md` or `AGENTS.md` and in your `~/.claude/CLAUDE.md`, so house rules you
already wrote are enforced too.

Chat replies are not checked, because no hook can stop a reply before it is
shown. The `prose-pass` skill covers them: ask for a prose pass, or let Claude
invoke it on a substantive answer.

## Cost

Every reviewed tool call starts a Sonnet agent with a 90-second timeout. Edits
to code that contain no comments return at once. Edits that do contain prose
take several seconds each, and a block costs a retry. Uninstall the plugin or
disable it per project if that trade is wrong for the work.

## Changing the rules

The rules live in `rules.md` and the reviewer's instructions in
`hooks/prompt.md`. Claude Code does not expand `${CLAUDE_PLUGIN_ROOT}` inside an
agent hook's prompt, so the hook cannot read `rules.md` when it runs. Instead,
`build-hooks.sh` copies the rules into every prompt in `hooks/hooks.json`. After
editing either file:

```sh
./build-hooks.sh
```

CI fails when `hooks/hooks.json` does not match its sources.

To keep the same rules in your own `CLAUDE.md`, import them from a checkout with
`@path/to/poker-face/rules.md`. Claude Code drops a missing import without a
warning; [missing-link](https://github.com/AlvinKuruvilla/missing-link) reports
one at session start.

## Limits

- `git -C dir commit` and other commands that do not start with the reviewed
  words are not matched.
- MCP tools are matched by verb in the tool name, so a server that names its
  send tool differently is not reviewed.
- The reviewer is a model. It blocks things a careful human editor would let
  through, and now and then misses one.
