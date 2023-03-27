---
finding:
  id: IF-CELESTIA-06
  title: Comment about the return value for ProveNamespace function does not correspond the code
  severity: ???
  impact: ???
  exploitability: ???
  type: Comment
  status: ???
  issue: https://github.com/celestiaorg/nmt/issues/123
---



## Description

[Comment](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/nmt.go#L182-L183) above `ProveNamespace` function stated that an error is returned when the requested nID is not in the tree's range.

It appears that this is not aligned with the [comment and the code](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/nmt.go#L211-L215) in the `ProveNamespace` function for that specific case. These do not mention or return an error (nill is returned).


## Problem Scenarios
This affects the clarity of the code.


## Recommendation
Align the comments with the code.


## Status Update
In discussion.
