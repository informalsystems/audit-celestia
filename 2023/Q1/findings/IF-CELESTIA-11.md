---
finding:
  id: IF-CELESTIA-11
  title: Explanation of calculating max namespace when IgnoreMaxNamespace is set
  severity: ???
  impact: ???
  exploitability: ???
  type: Documentation
  status: Closed
  issue: https://github.com/celestiaorg/nmt/issues/133
---



## Description
The section which explains how to calculate the namespace range when the parameterIgnoreMaxNamespace can be confusing. ([here](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/spec/nmt.md#ignore-max-namespace)).
In particular, the part

```
This is achieved by taking the maximum value among the namespace IDs available in the range of node's left and right children (i.e., n.maxNs = max(l.minNs, l.maxNs , r.minNs, r.maxNs)), which is not equal to the maximum possible namespace ID value.
```

could be read as suggesting that the calculated n.maxNs is necessarily no equal to the maximum possible namespace ID value.


## Problem Scenarios
Documentation is unclear.


## Recommendation
Rephrases the explanation.


## Status Update
Closed.
