# Rules

## Say the thing, not that you are saying it

Report findings and stop. Do not narrate your own conduct, flag that you are
being direct, announce that you are surfacing a decision rather than making it,
or explain that a detour was not wasted. If an instruction has just been given,
do not restate it back as though it were an insight.

**Cut every preface.** A sentence that announces the next sentence's importance,
category, or reliability carries no information. Delete the frame and keep the
claim. This is the most frequent failure, so it gets the longest list:

- "and it's worth knowing", "worth noting", "worth flagging", "worth stating"
- "one thing I should not overstate", "to be clear", "for the record"
- "the honest costs are", "being straight about this", "candidly"
- "one difference I'm keeping, and here's why it matters"
- "this is the interesting part", "here's the thing"
- "I want to flag that", "it bears mentioning"

Match the shape, not these strings. A list of specimens gets read literally and a
new object walks straight through it — "worth starting from rather than reopening"
survived a scan for "worth noting". Three shapes, whatever words fill them:

- **"worth &lt;verb&gt;ing"**, in any form: worth knowing, flagging, starting from,
  having, bearing in mind.
- **A sentence whose subject is the text itself** — "this", "these", "the following",
  "two parts of this" — telling the reader how to take what comes next. The label
  alone does the work: "Already decided:" and then the decisions.
- **X-rather-than-Y where only X is true.** "Worth starting from rather than
  reopening" carries exactly what "Already decided" carries.

Bad:
> One difference from delta I'm keeping, and it's worth knowing: our
> tokenization is coarser.
> Worth being direct about that rather than quietly picking something.
> This is a genuine design question, so I won't decide it silently.

Good:
> Our tokenization is coarser than delta's: `\S+` where delta uses `\w+`.
> Delta output is environment-dependent; `BAT_THEME` changes it. Prefix or
> background for +/- lines?

Surface a design question, report a failure, or give credit by doing it. State
the caveat itself. A reader can see that a question is on the table because it
is on the table.

## No LLM voice

The section above bans frames. This one bans diction and cadence. Applies to
everything: comments, commit messages, PR bodies, and chat.

Strike the vocabulary: delve, leverage, utilize, robust, seamless,
comprehensive, crucial, vital, elegant, powerful, streamline, unlock, empower,
landscape, realm, journey, and "ensure" where "make sure" or nothing does the
work.

Strike the cadences:

- antithesis as filler — "not just X, but Y"; "this isn't X, it's Y"
- rhythmic triples where the truth has two items or four
- a closing sentence that restates the paragraph it ends
- hedges carrying no probability — "can help to", "may potentially"
- justification invented to fill a clause, for a benefit nothing needs
- coordination doing subordination's job — "X, and Y" where Y is the reason for
  X, its consequence, or a qualification of it. Name the relation: so, because,
  but, unless. Where the relation really is "both are true", use two sentences.
- placeholders where the specific is known — "something", "someone", "things",
  "has to decide". Name the key, the actor, the effect. When the code determines
  what happens, say what happens (it raises, the request fails) rather than the
  obligation that falls on some unnamed person. Where one word says it
  ("unchecked"), do not write a clause about a person ("without anyone
  reviewing them").
- even rhythm — every clause the same length and weight. Fluent, and carries no
  emphasis. Let the shape follow the argument: long where the mechanism is,
  short where the consequence lands.

Both leave the information intact and lose the shape of the reasoning, so they
survive a proofread. Read for what the reader has to reassemble.

Write the plainest accurate word. Once a thing has a name in the code or the
text, call it by that name. Do not swap in a description of its role or a term
of art the reader has to translate back. A verb like decide, handle, manage or
process names its object: what is decided, handled, managed or processed.

On finding one of these in text already written, yours or anyone's, fix it in
place rather than flagging it.

## Comments and documentation

Apply literate programming principles to make code self-documenting and
maintainable across all languages:

### Core Principles

1. **Explain the Why, Not Just the What**: Focus on business logic, design
   decisions, and reasoning rather than describing what the code obviously does.

2. **Top-Down Narrative Flow**: Structure code to read like a story with clear
   sections that build logically. Use short, plain comments to introduce
   logical sections — never banner-style comments with decorative lines of
   `=`, `-`, `*`, `#`, or other repeated characters. Banners are visual
   noise that add no information.

   Good:
   ```rust
   // Plugin configuration extraction
   ```
   Bad:
   ```rust
   // ==============================================================================
   // Plugin Configuration Extraction
   // ==============================================================================
   ```

3. **Inline Context**: Place explanatory comments immediately before relevant
   code blocks, explaining the purpose and any important considerations:
   ```python
   # Convert timestamps to UTC for consistent comparison across time zones.
   # This prevents edge cases where local time changes affect rebuild detection.
   utc_timestamp = datetime.utcfromtimestamp(file_stat.st_mtime)
   ```

4. **Avoid Over-Abstraction**: Prefer clear, well-documented inline code over
   excessive function decomposition when logic is sequential and
   context-dependent. Functions should serve genuine reusability, not just
   file organization. Three similar lines of code is better than a premature
   abstraction.

5. **Self-Contained When Practical**: Reduce dependencies on external shared
   utilities when the logic is straightforward enough to inline with good
   documentation.

### When to Apply

Use literate programming for:
- Complex algorithms with multiple phases or decision points
- Code implementing business logic rather than simple plumbing
- Code where the "why" is not immediately obvious from the "what"
- Integration points between systems where context matters

Comment what a reader cannot recover from the code. Judge by recoverability, not
by size: a single constant may need a paragraph, a long function may need
nothing.

Needs nothing:
- Getters, setters, and wrappers that restate their signature
- Syntactic sugar over a pattern the reader already knows

### Documentation

- Use realistic names for types, variables, and examples. No `foo`, `bar`,
  `baz`, or `MyStruct`.
- Document when you have intentionally omitted code that the reader might
  otherwise expect to be present.
- Markers say what kind of unfinished a thing is. `TODO` — work not done;
  include enough context that someone returning months later can resume it, and
  name an owner or an issue, or it becomes permanent. `XXX` — a better approach
  is known and blocked; link the blocker. `NOTE` — a constraint that looks
  removable and is not. A `TODO` may also record a known deficiency in working
  code, not only deferred work.
- A docstring covers its own item. The flow around it, meaning which endpoint
  does what and in what order, belongs on the code that runs that flow.
- The first line of a doc says what the item does or is, with a concrete verb
  or noun ("Gofmt formats Go programs."). Never define it by its relation to
  something else ("the parts of X that Y does not provide").

### Documentation is for consumers; comments are for collaborators

Documentation on a public item is written for someone deciding whether to use
it: impersonal, defined, no reaction. A comment inside a function is written for
someone standing in the code, and may think aloud — walk through a derivation,
call a workaround ugly, admit a value is arbitrary. Do not mix the registers.

An aside earns its place when it does work for the reader: flagging that what
follows looks wrong and is not, setting up a derivation, heading off an
objection they are forming. Write what a stranger reading the code would also
have observed, not what only you were there for.

Where knowledge goes:

| where | what goes there |
|---|---|
| **`src/`** | How the thing works, why it is allowed to work, and what constrains it. Mechanism, invariants, correctness arguments, the decision someone would otherwise undo. |
| **`tests/`** | What broke and must not break again, and why the setup is shaped the way it is. Setup that looks arbitrary and is load-bearing gets the same treatment as production code. |
| **`docs/` (a decision record)** | The full argument for a design, numbered and linkable. The code still carries the constraint that decision imposes, at the site it binds. |
| **`AGENTS.md`** | What an AI agent needs in order not to make a mess: conventions, pitfalls, how to validate, where things live. |

A test carries a regression; a comment carries the reason. The test fails when
the behaviour changes; the comment stops the behaviour being deleted as
pointless. Write both where both apply.

Comments have one audience: the next person to read the code. An agent benefits
because it reads what a person reads — there is no second register. Never
address tooling, never restate structure a reader can see, and be most
suspicious of comments that were cheap to produce.

Never in `src/`:

- self-narration — "I tried Y and it failed"; write the finding instead
- a changelog; git has one. History earns its place only by directing the reader
  somewhere useful or stopping them redoing dead work
- a bare pointer standing in for the explanation — link after explaining, not
  instead of it
- bold used to shout

### What only a comment can carry

Before writing a doc or a comment, name the first question a reader will ask,
and answer it. Where code departs from the standard choice, the question is
why: why build this when a library already does it, why not the framework's
default.

Record a decision where breaking it would do damage, and name what was rejected
and what disqualified it, so the alternatives are not re-derived and
re-rejected. Name a rejected alternative only when a reader would plausibly
reach for it and switching to it would cause harm nobody would see. One whose
reversal costs only tidiness does not earn the space; the positive reason
already implies it.

Where correctness is not evident from the code, write the argument and let the
code check what it can. Take the steps in the order the code takes them, give
each its warrant rather than its label, and make the links between steps
explicit so removing one shows what it was holding up. Where a step rests on an
assumption the language cannot enforce, assert it.

Where a comment answers several separate questions a reader asks in turn (what a
setting does, why this value, why that is safe), number them and lead each item
with the question it answers. A reader can then find one answer without rereading
the rest, and cite it. Where an answer itself has separate parts, such as the cases
a check refuses, nest them as a sublist under it. Keep prose for a single line of
reasoning, where each sentence depends on the one before.

A literal that could have been another value says where it came from —
measured, specified, copied, or arbitrary. "Arbitrary" is a real answer. Say
what breaks if it moves up or down. Name what breaks concretely: who does what,
and what the user ends up with. "Can be claimed by someone else" names a risk
and stops before the harm, so the reader cannot tell a breach from a nuisance.

A choice other code silently depends on says so where it is made: this stays a
`BTreeSet` because iteration order is assumed below.

Where code implements something specified elsewhere — a paper, an RFC, a wire
format — keep the specification reachable from the code. Quote the part being
implemented, or record the mapping between the source's names and yours. Prefer
names that read well here over the source's notation. Reproduce notation only
if it survives the move; transcribe to plain ASCII rather than preserve glyphs a
copy-paste has flattened. Where the code departs from what it cites, say where
and why.

Cite by something that cannot move: a pinned commit, a permalink, an archived
URL. Never a branch URL or a bare line number. Quote a source that cannot be
fetched.

### Keeping comments true

A comment is part of the code it explains. Changing one without the other leaves
something worse than no comment, because a wrong explanation is believed.

Prefer claims that stay true — invariants, reasons, constraints — over ones that
expire. Where something that expires has to be written, date it or pin it so the
reader knows to re-check rather than trust: measurements, counts, line numbers,
"currently", "at the time of writing".

### Cut padding, never substance

Applies to everything written: comments, module docs, commit bodies, PR descriptions,
and replies in chat.

Cut what the reader already has:

- clauses the rest of the sentence already implies — naming what was done implies the
  alternative rejected; stating a constraint implies why it matters
- anything that restates what the code plainly does
- the consequence of getting it wrong, unless that consequence is itself surprising
- announcements that a point is important, careful, or honest
- a caveat answering a question no reader would ask. A caveat earns its place
  when a reader would otherwise act on the wrong assumption.

Never shorten an explanation to reach a length. A constant may earn thirty
lines; a derivation may earn its algebra written out. Bytes are free, and a
comment compressed into shorthand that has to be decoded is worse than none.

"This reads like an LLM wrote it" is never a complaint about length. Answer it by
deleting the frames and keeping every fact — an eleven-line comment rewritten to
four by dropping the mechanism behind an obstacle has swapped one failure for the
opposite one.

There is no target ratio of comments to code, and some code needs none. Landing
working code with adequate comments beats delaying it to polish them.


### House style: jonhoo (`left-right`, `flurry`, Noria)

Go read one before writing a module doc. Do not reconstruct the style from
memory — the conventions below were only right after actually opening the code.

- **Open with a definition, not a heading.** `left-right/src/lib.rs` begins: *"A
  concurrency primitive for high concurrency reads over a single-writer data
  structure."* One sentence saying what the thing **is**. Then the mechanism, in
  flowing prose.
- **Headings are boring nouns.** `# Trade-offs`. `# How does it work?`. A heading
  names a topic; it does not announce that a point is coming. "The one idea",
  "Two costs worth naming", "The thing that matters" are all tics — cut them.
- **Never narrate your own reaction to the code** — in a module or item doc.
  "A surprising amount of assertion plumbing", "more elaborate than it looks",
  "which is a pleasant coincidence", "the interesting part", "this does more
  work than it appears to".
  The reader does not care what surprised you; they care what is true. Delete the
  reaction and state the fact — "SIL's builtins: arithmetic, comparisons, and the
  plumbing that assembles assertion messages" says strictly more than "…and a
  surprising amount of assertion plumbing", in fewer words.
- **Bold is a term label in a list, never emphasis in a sentence.**
  `- **Increased memory use**: since we keep two copies…` is the only place it
  appears.
- **Diagram anything with a shape** — a tree, a graph, a memory layout, a
  pipeline, a state machine. Introduce it with a plain sentence, put it in a
  ```` ```text ```` fence, keep it to plain ASCII, and place it with what it
  describes. Dimension it: label the offsets or boundaries, give a legend whose
  entries state the consequence of each part and not only its name, and state
  outright any convention a reader could take two ways. A diagram that merely
  redraws a list costs more than it returns; one with a shape routinely replaces
  three paragraphs struggling to describe what a picture states at a glance.
  Tabulate cases that vary along the same columns, such as callers, inputs or
  states, and make the outcome the last column. A table shows which column
  decides the outcome; the same facts spread across bullets hide it. Figures and
  tables belong in comments as much as in module docs: wherever the reader has
  to hold three or more cases in their head at once, draw them.
- **Have a `# Trade-offs` section and be honest in it.** Every real design costs
  something. Say what, and say why you paid it anyway.
- **Point at code that exercises the thing.** *"this is almost the exact graph
  used by the `votes` test in `src/integration.rs`, so you can go look at that."*
  A fixture is easier to look at than to describe.

