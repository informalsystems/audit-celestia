---
finding:
  id: IF-CELESTIA-20
  title: VerifyNamespace panics if called on an empty range, but with non-empty nodes
  severity: ???
  impact: ???
  exploitability: ???
  type: Protocol
  status: In progress.
  issue: https://github.com/celestiaorg/nmt/issues/164
---



## Description
If `VerifyNamespace` is called with a proof that has an empty range (e.g., `start=end=0`), but non-empty `nodes`, it will panic. An example proof that would cause the panic is

``` go
customNode := []byte{7}
panickingProof := Proof{
	start:                   0,
	end:                     0,
	nodes:                   [][]byte{customNode},
	leafHash:                []byte{},
	isMaxNamespaceIDIgnored: true,
	}
```

`VerifyNamespace` does check for empty range, but only together with empty nodes. The panic happens in the [getSplitPoint](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/nmt.go#L454-L456) function.


## Problem Scenarios
`VerifyNamespace` function will panic when called over an proof with an empty range but not empty `nodes`.


## Recommendation
`VerifyNamespace` should process the this edge case.


## Status Update
In progress.
