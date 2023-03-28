---
finding:
  id: IF-CELESTIA-14
  title: Wrapper Push function will panic if the data is invalid
  severity: ???
  impact: ???
  exploitability: ???
  type: Protocol
  status: Closed.
  issue: https://github.com/celestiaorg/nmt/issues/144
---



## Description
[Push](https://github.com/celestiaorg/celestia-app/blob/651b1cfd03ef6f4db04edf42a49a5ada05a1472d/pkg/wrapper/nmt_wrapper.go#L80) function form `ErasuredNamespacedMerkleTree` will panic if it is called with `data` which size is smaller than the `NamespaceSize`. The panic will happen on this [line](https://github.com/celestiaorg/celestia-app/blob/651b1cfd03ef6f4db04edf42a49a5ada05a1472d/pkg/wrapper/nmt_wrapper.go#L88). This is because the slice `data[:appconsts.NamespaceSize]` is out of bounds of the byte array.


## Problem Scenarios
Wrapper `Push` function will panic if called over invalid data.


## Recommendation
Check `data` size before slicing.


## Status Update
Closed.
