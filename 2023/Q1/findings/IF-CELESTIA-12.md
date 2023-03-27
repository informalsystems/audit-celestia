---
finding:
  id: IF-CELESTIA-12
  title: Computing leaf hashes should be done after the range check
  severity: ???
  impact: ???
  exploitability: ???
  type: Good coding practice
  status: Closed
  issue: https://github.com/celestiaorg/nmt/issues/139
---



## Description
[computeLeafHashesIfNecessary](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/nmt.go#L168) should be done after the range check. This calculation could be time/resource consuming but unnecessarily called if the range is invalid.


## Problem Scenarios
Unnecessary resource allocation if the sanity check fails.


## Recommendation
Range check should be done first.


## Status Update
Closed.
