# Off-Grid Electrical

A Beamer talk reviewing the off-grid electrical setup documented at
<https://wiki.mikedabay.ca/doku.php?id=electrical>, in the same style as
[jmct/nats](https://github.com/jmct/nats).

## Build

```
make          # -> electrical.pdf
make clean
```

Needs `pdflatex` with `beamer`, `graphicx`, `calc` and `tikz`. On Debian:
`texlive-latex-recommended texlive-pictures texlive-fonts-recommended`.

## Layout

| File | |
|---|---|
| `electrical.tex` | the deck |
| `beamerthemejmct.sty` | theme entry point |
| `beamercolorthemejmct.sty` | the palette |
| `beamerinnerthemejmct.sty` | title page, itemize markers |
| `beamerouterthemejmct.sty` | frame title bar |
| `figs/` | images referenced by the deck |

The four `.sty` files are copied **verbatim** from `jmct/nats` — byte-identical,
so the two decks stay visually in sync and any theme change can be diffed
against the original.

## Status: scaffolding

The structure is in place and builds (79 frames). The content is not — every
hole is marked with `\todo{...}` and renders as a blue **[TODO]** in the PDF:

```
grep -n 'todo{' electrical.tex
```

Those need the wiki page to fill in. The deck walks the power from where it
arrives to where it's used:

1. The site and the loads
2. Generation — the array
3. Storage — the battery bank
4. Conversion — controllers and inverter
5. Distribution and protection
6. Monitoring — what the system tells you
7. Alterations — what I'd change

Section 7 is where the "alterations" live: the wiki describes the setup as
built, and this is the slot for anything that has changed since.

## Releases

`.github/workflows/build.yml` builds the deck on every push and pull request,
and uploads `electrical.pdf` as a build artifact so you can grab the rendered
deck from any run without a local TeX install.

Pushing a tag beginning with `v` additionally publishes a GitHub Release with
the PDF attached:

```
git tag v1 && git push origin v1
```

The asset is named for the tag (`off-grid-electrical-v1.pdf`) so downloads
don't all land as `electrical.pdf`. Re-running a tag build replaces the asset
instead of failing, so you can retag a fix.

The workflow uses only `actions/checkout` and `actions/upload-artifact`; the
release itself goes through the preinstalled `gh` CLI with the built-in
`GITHUB_TOKEN`, so there's no third-party action in the release path and no
secret to configure. `contents: write` is scoped to the job, not the workflow.

## Conventions

Carried over from `nats`: `\blueit{}`, `\blueite{}`, `\myquote{}{}{}`,
`\textover[]{}{}`, and the `\item<2 ->` overlay build-up on list frames.

Added here:

- `\signpost{n}` — the running outline with item `n` highlighted, `\signpost{0}`
  for none. The section list lives in exactly one place (the macro), so
  reordering the talk is a one-line edit instead of nine.
- `\val{48}{V}` — a quantity with a thin space before its unit.
- `\kitname{}` — a piece of kit, styled consistently wherever it's named.
- `kit` environment — the two-column spec blocks:

  ```latex
  \begin{kit}
    Inverter & 3000\,W \\
    Surge    & 6000\,W \\
  \end{kit}
  ```

- `\todo{}` — a scaffolding hole, visible in the built PDF.

## Note on the theme

`beamerouterthemejmct.sty` line 5 reads:

```latex
\newlength{\marginedPaperWidth}{\paperwidth - 0.2cm}
```

`\newlength` takes one argument, so the second group never assigns anything and
the length stays at 0pt. The frame-title rectangle is then drawn from 0.2cm to
0pt, which is why the title bar renders as a thin blue tick on the left rather
than the full-width bar the code is reaching for.

This is inherited from `nats` and is left **unchanged** here, so both decks look
the same. The fix, if you want the full bar, is to split the line:

```latex
\newlength{\marginedPaperWidth}
\setlength{\marginedPaperWidth}{\paperwidth - 0.2cm}
```

Worth making in `nats` too, so the two stay in sync.
