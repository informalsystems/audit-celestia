---
finding:
  id: IF-CELESTIA-02
  title: Description of index and leaf hash in absence proof
  severity: Informational
  impact: None
  exploitability: None
  type: Documentation
  status: Resolved
  issue: https://github.com/informalsystems/audit-celestia/issues/40
---



## Description
[Description](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/nmt.go#L335-L338) above the `calculateAbsenceIndex` function about index and leaf hash in case of absence proof is misaligned with the [documentation](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/spec/nmt.md#L88) and [code](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/nmt.go#L355-L357).

Description states that the index of a leaf in the case of absence proof, should be the one with largest namespace ID smaller than the requested namespace, while the documentation states that the index should be the one with the smallest namespace ID that is larger than the requested namespace ID. The code is align with the documentation.

The same issue with the descriptions about index and leaf hash in case of absence proof was addressed trough [this commit](https://github.com/celestiaorg/nmt/commit/4276d172f18c87ebdd18da0cc4b758f0dd164118) in two places to be aligned with the documentation, but was missed above before mentioned function.


## Problem Scenarios
This issue affects the clearness of code.


## Recommendation
We recommend aligning the function description with the documentation.


## Status Update
Resolved. 