---
finding:
  id: IF-CELESTIA-09
  title: Hasher initialization and reset should be done after validity checks
  severity: ???
  impact: ???
  exploitability: ???
  type: Good coding practice
  status: Closed
  issue: https://github.com/celestiaorg/nmt/issues/131
---



## Description
This issue is a good coding practice. [Hasher initialization and reset](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/hasher.go#L234-L235) should be done after validity checks.


## Problem Scenarios
Unnecessary resource allocation if the sanity check fails.


## Recommendation
First doing the sanity check, then if it passes allocate the needed resources.


## Status Update
Closed.
