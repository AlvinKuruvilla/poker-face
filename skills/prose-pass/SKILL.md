---
name: prose-pass
description: Strip LLM voice from prose before it reaches a human. Use for a substantive chat answer, which no poker-face hook sees, and for any draft the user will paste somewhere by hand — a PR body, review reply, issue, or design doc. Also use when the user says a draft "sounds like an LLM", "has slop in it", or asks for a slop pass. Runs a shape audit that a vocabulary grep cannot do.
---

# prose-pass

`${CLAUDE_PLUGIN_ROOT}/rules.md` lists the banned words. That list is the least
useful part of this and reading it is not a check. On 2026-09-01 a draft passed a
grep of every specimen in it and still opened:

> You're right about the third point, and it changes what this PR should claim,
> so I'll start there.

Three banned shapes, zero banned words. Grep is for the cheap half. The pass below
is the half that matters.

## Order

Write the draft first. Do not compose through this — self-censoring mid-sentence
produces stilted prose, and the shapes are easier to see in finished text than in
a sentence being formed.

Then, before showing it to anyone:

1. Run `${CLAUDE_PLUGIN_ROOT}/skills/prose-pass/check.sh <file>`. It greps the
   mechanical tells.
2. Do the four passes below.
3. Read it back cold.

## Pass 1: first sentences

Frames cluster at the top of sections. Read the **first sentence of every
paragraph and section, in isolation, ignoring everything else**.

For each one: does it tell the reader about the *subject*, or about the *text*?

A sentence about the text goes. So does the clause explaining why this part comes
where it does. The heading already announced the topic; the reader can see the
order.

| written | fixed |
|---|---|
| You're right about the third point, and it changes what this PR should claim, so I'll start there. | The declaration does not catch "forgot to filter by org." You're right. |
| Where we disagree is what the six defects are. | Four of the six defects are a different bug. |
| Two things came out of building it. | *(delete; state the two things)* |

## Pass 2: last sentences

Read the **last sentence of every paragraph**. Delete it. Is anything lost?

If nothing is lost, it was restating the paragraph it ended. Leave it deleted.

> Ownership here is a property of the row. No foreign key chain reaches a per-row
> fact.

The second sentence is the first sentence again. One of them survives.

## Pass 3: the negated half

Find every `X, not Y` / `neither X nor Y` / `isn't X, it's Y` / `not just X, but Y`.

For each: **is the negated half a real alternative someone would have believed?**

- Real: "The bug was neither a missing filter nor a missing label" — both were
  live hypotheses in the review being answered. Keep.
- Rhythm: "This isn't a workaround, it's the design" — nobody proposed workaround.
  Cut to "This is the design."

Antithesis is free to write and reads as insight. Most of it is filler.

## Pass 4: the joints

Find every `, and `. For each, name the relation between the halves:

- Y is X's reason → `because`
- Y is X's consequence → `so`
- Y qualifies X → `but` / `unless`
- both simply true → two sentences

`and` where one of the first three holds flattens the argument into a list. The
reader then has to reassemble which clause was doing what.

While here: check rhythm. If every clause runs the same length, the prose is
fluent and carries no emphasis. Let the shape follow the argument — long where the
mechanism is, short where the consequence lands.

## Read it back cold

Aloud if the draft is going somewhere public. The tells that survive four passes
are audible ones: an even cadence, a triple where there are two real items, a
paragraph that lands on nothing.

## What this does not license

Cutting substance to hit a length. "This reads like an LLM wrote it" is never a
complaint about length — an eleven-line comment rewritten to four by dropping the
mechanism has swapped one failure for the opposite one. Delete frames, keep every
fact.
