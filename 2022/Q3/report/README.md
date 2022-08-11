# An Informal Systems Audit Report

The source files in this directory are compiled into an audit report.

## Preparing the report

Fill in the report metadata in the file [./metadata.yml](./metadata.yml).

## Writing the report

All the content for the report goes into the [./src/](./src/) directory.

- Fill in the content for the default sections supplied, replacing template
  variables and changing wording as needed.
- Add new sections as desired, using the numbering that precedes the file
  names to control the ordering.
- Add findings to the [./src/findings/](./src/findings/) directory, by filing in
  the [./findings-template.md](./findings-template.md). Note that the file name
  for each finding should match the finding's `id`, with the `.md` suffix
  added.

## Building the report

Running

``` sh
make
```

will create `_build/report.pdf`.

For debugging purposes, you can build

``` sh
make tex
```

which will create `_build/report.tex`.

To promote the PDF to add it to your git worktree, run

``` sh
make promote
```
