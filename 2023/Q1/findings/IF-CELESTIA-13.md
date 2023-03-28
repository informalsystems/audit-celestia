---
finding:
  id: IF-CELESTIA-13
  title: verifyLeafHashes function will panic if called from VerifyInclusion function over an empty proof
  severity: ???
  impact: ???
  exploitability: ???
  type: Protocol
  status: In progress.
  issue: https://github.com/celestiaorg/nmt/issues/140
---



## Description
[`verifyLeafHashes`](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/proof.go#L177) function will panic  when called over an empty proof. Panic will happen when [`getSplitPoint(proof.end)`](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/proof.go#L248) is called because an empty proof has proof.end = 0 that will lead to panic within `getSplitPoint` function [here](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/nmt.go#L454-L456).

This can happen if the [VerifyInclusion](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/proof.go#L265) function is called over an empty proof. This function will not process the empty proof before calling `verifyLeafHashes`.

In contrast to when called from `VerifyInclusion`, `verifyLeafHashes` will not be called with an empty proof from the `VerifyNamespace` which handles empty proof before calling `verifyLeafHashes` ([here](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/proof.go#L132) and [here](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/proof.go#L168)).


## Problem Scenarios
`verifyLeafHashes` function will panic when called over an empty proof.


## Recommendation
`VerifyInclusion` should process the empty proof before calling `verifyLeafHashes`, but we suggest an additional protection in `verifyLeafHashes`.


## Status Update
In progress.
