---
finding:
  id: IF-CELESTIA-16
  title: Sanity check should be done immediately after tree creation
  severity: ???
  impact: ???
  exploitability: ???
  type: Good coding practice
  status: Closed.
  issue: https://github.com/celestiaorg/nmt/issues/147
---



## Description
This issue is a good coding practice. This [sanity check](https://github.com/celestiaorg/celestia-app/blob/651b1cfd03ef6f4db04edf42a49a5ada05a1472d/pkg/proof/proof.go#L178-L180) comes too late. It should probably be done after the `tree` variable is created ([here](https://github.com/celestiaorg/celestia-app/blob/651b1cfd03ef6f4db04edf42a49a5ada05a1472d/pkg/proof/proof.go#L145-L145)).


## Problem Scenarios
Unnecessary resource allocation and computation if the sanity check fails.


## Recommendation
First doing the sanity check, then if it passes allocate the needed resources.


## Status Update
Closed.
