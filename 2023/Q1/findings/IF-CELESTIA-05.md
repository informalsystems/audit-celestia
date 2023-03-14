---
finding:
  id: IF-CELESTIA-05
  title: Typo in the spec. `end` instead of `end-1`
  severity: ???
  impact: ???
  exploitability: ???
  type: Documentation
  status: ???
  issue: https://github.com/celestiaorg/nmt/issues/122
---



## Description

In the nmt specification, under the Namespace Inclusion Proof section, two parts of the proof are mentioned. The second part is referred to as the siblings right to the leaf at the `end` index. That leaf it self is not part of the proof range because the `end` index is non inclusive.

The nmt documentation states for the second part of the proof:

```
In specific, the nodes include (...) 2) the namespaced hash of the right siblings of the Merkle inclusion proof of the end leaf
```

but it should instead be

```
In specific, the nodes include (...) 2) the namespaced hash of the right siblings of the Merkle inclusion proof of the end-1 leaf
```


## Problem Scenarios
This affects the clarity of the range of given namespace and the proof for it.


## Recommendation
The according index value (`end-1`) should be used in the documentation.


## Status Update
In discussion. 