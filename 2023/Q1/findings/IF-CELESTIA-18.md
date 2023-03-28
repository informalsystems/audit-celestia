---
finding:
  id: IF-CELESTIA-18
  title: ValidateInclusion function can panic if it is called with an invalid nid
  severity: ???
  impact: ???
  exploitability: ???
  type: Protocol
  status: In progress.
  issue: https://github.com/celestiaorg/nmt/issues/157
---



## Description
If the [ValidateInclusion](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/proof.go#L265) function is called with an `nID` which size is not equal to the namespace size of the `proof.nodes`, the function could panic.

If this happened, the the [nth](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/proof.go#L266) hasher will be constructed with a different namespace size than the one that the proof was calculated with. This could lead to a panic in [verifyLeafHashes](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/proof.go#L275) function within the [HashNode](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/proof.go#L254) at this [panic](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/hasher.go#L246). Panic ocures  because `validateSiblingsNamespaceOrder` could return an `ErrUnorderedSiblings` error because:

```go
	leftMaxNs := namespace.ID(left[n.NamespaceLen:totalNamespaceLen])
	rightMinNs := namespace.ID(right[:n.NamespaceLen])
```
one of the `leftMaxNs` or `rightMinNs` is wrongly sliced due to different namespace sizes at their construction and thus parsed so that the following check is true and error is returned:

```go
	if rightMinNs.Less(leftMaxNs) {
		return fmt.Errorf("%w: the maximum namespace of the left child %x is greater than the min namespace of the right child %x", ErrUnorderedSiblings, leftMaxNs, rightMinNs)
	}
```

Simple check like this [one](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/proof.go#L124-L129) in the `VerifyNamespace` should be enough.


## Problem Scenarios
Function `ValidateInclusion` could panic if called with invalid namespace id size.


## Recommendation
Check if the passed `nid` parameter length is equal with the length on namespaces within the `root` parameter or the `proof.nodes` field.


## Status Update
In progress.
