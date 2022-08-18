---
visibility: PRIVATE
---

#  Audit Workspace _of_ Informal Systems ⨯ Celestia

This repository is a workspace for [Informal Systems](https://informal.systems/)
and [Celestia](https://celestia.org) to collaborate on auditing the software developed
by Celestia.

## Usage and organization

The artifacts for each audit engagement are gathered in a subdirectory named
after the year and quarter in which the audit was carried out.

These artifacts include:

- The artifacts generated in the course of the audit.
- The artifacts under audit, referenced as git submodules.

### To clone just the artifacts Informal created during the audit

``` sh
git clone git@github.com:informalsystems/audit-Celestia.git
```

### To clone all artifacts, including Interlay's source code at the relevant commits

``` sh
git clone --recurse-submodules git@github.com:informalsystems/audit-Celestia.git
```


### To update the submodules if you've already cloned the repository

``` sh
git submodule update --init --recursive
```

### To add an artifact into an `artifacts` directory

From within an the `artifacts` subdirectory of an audit:

```sh
git submodule add https://github.com/Celestia/$PROJECT$
cd $PROJECT$
git checkout $TAG$
```

where $TAG$ is the tag or commit agreed to be under audit.

Then

```sh
cd .. # back into the workspace repository
git commit -m "pin client artifact $PROJECT$"
```

###  To update the report generation tooling

The report generation is also tracked as a git submodule (allowing us to share
code between audit efforts, and update the templating logic in one place). To
update, run

``` sh
git submodule update --init --recursive
```
