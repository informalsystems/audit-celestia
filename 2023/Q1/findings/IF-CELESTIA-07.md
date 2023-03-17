---
finding:
  id: IF-CELESTIA-07
  title: Check ordering of namespace among child nodes in HashNode function
  severity: ???
  impact: ???
  exploitability: ???
  type: Protocol
  status: In discussion
  issue: https://github.com/celestiaorg/nmt/issues/129
---



## Description

Function `validateSiblingsNamespaceOrder` only checks if the maximum namespace id of the left child is less or equal to the minimum of the right minimum namespace id. It does not check the of leftMinNs, leftMaxNs, rightMinNs and rightMaxNs among children nodes.

Evan if the ordering of namespaces will guaranteed by the Push function it would be wise to check the whole ordering for the sake of completeness.

There is a [testCase](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/hasher_test.go#L93-L101) that submits children nodes with invalid namespace ordering to HashNode function. The left child node has minNs larger than the maxNs of the same node, and in addition to that leftMinNs is even larger then the rightMinNs. The test, with invalid data, will pass because `validateSiblingsNamespaceOrder` does not check the complete ordering of namespaces.


## Problem Scenarios
This affects the clarity of the code, and could potentially lead to wrong ordering of namespace ids.


## Recommendation
Function `validateSiblingsNamespaceOrder` should check the of leftMinNs, leftMaxNs, rightMinNs and rightMaxNs among children nodes.


## Status Update
In discussion.
