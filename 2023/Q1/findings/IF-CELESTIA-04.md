---
finding:
  id: IF-CELESTIA-04
  title: Assumption that leaves are ordered is not used consistently
  severity: ???
  impact: ???
  exploitability: ???
  type: Protocol and Documentation
  status: ???
  issue: https://github.com/celestiaorg/nmt/issues/121
---



## Description

There is an assumption that leaves of NMTs are ordered by their namespace ids. However, this assumption is not used.

For instance in the [specification](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/spec/nmt.md?plain=1#L38):

  `NsH(n) = min(l.minNs, r.minNs) || max(l.maxNs, r.maxNs) || h(0x01, l, r)`

, the specification takes min(l.minNs, r.minNs), where l.minNs would suffice.

Similarly, int the `HashNode` function same thing happens. The `minNs` is [calculated](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/hasher.go#L255) like `minNs := min(leftMinNs, rightMinNs)` instead of `minNs := leftMinNs`.

But then on the other hand, the assumption on ordering namespace ids is used in the function [CalculateAbsenceIndex](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/nmt.go#L355-L355), when finding the appropriate leaf for the absence proof.


## Problem Scenarios
Differences between assumption, specifications and code can lead to harder understanding.


## Recommendation
We recommend to use this assumption which would make the code and the spec clearer.


## Status Update
In discussion. 