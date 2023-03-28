---
finding:
  id: IF-CELESTIA-17
  title: Proof struct is missing a function for range verification
  severity: ???
  impact: ???
  exploitability: ???
  type: Protocol
  status: In progress.
  issue: https://github.com/celestiaorg/nmt/issues/154
---



## Description
Proof struct does not have a function for verifying a range of leaves that do not have to belong to the same namespace.

In the nmt.go there is a function [ProveRange](https://github.com/celestiaorg/nmt/blob/d993c7d69a252da4a98609fa16a87dcc52be88a6/nmt.go#L209-L209) that does not depend on namespaceID and builds a proof for a given range. However, there is no its Verify- inverse function in proof.go. All verify functions (`VerifyNamespace` and `VerifyInclusion`) in proof.go depend on the namespaceID.

Function [verifyLeafHashes](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/proof.go#L177) could be used for proving a range of leaves that do not have to belong to the same namespace if its parameter `verifyCompleteness` is set to false (then its parameter `nID` would not be used, so it could be nil). This functions is used for internal purposes (called from `VerifyNamespace` and `VerifyInclusion`), so it could be as a called from the new function for verifying proof for a given range of leaves.


## Problem Scenarios
Inability to verify a proof that does not depend on the namespace id.


## Recommendation
Create a function for verification of ranged proofs.


## Status Update
In progress.
