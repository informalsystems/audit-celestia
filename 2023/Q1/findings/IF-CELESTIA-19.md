---
finding:
  id: IF-CELESTIA-19
  title: TestNamespacedMerkleTree_calculateAbsenceIndex_Panic isn’t complete
  severity: ???
  impact: ???
  exploitability: ???
  type: Test
  status: In progress.
  issue: https://github.com/celestiaorg/nmt/issues/158
---



## Description
[TestNamespacedMerkleTree_calculateAbsenceIndex_Panic](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/nmt_test.go#L581) obviously isn’t complete. It does not push the data from test cases to the nmt. It passes (the tested function panics as expected) because it tests an empty tree so [this panic](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/nmt.go#L362) will be called in both cases. So this test does not test the given cases. Push function should be called for the given data.

One test case should added that tests the panic if the tree is empty, as it is done unintentionally in this test.


## Problem Scenarios
Test cases are not tested because data is not pushed into the NMT.


## Recommendation
Push the data into the NMT, and make a new test case that tests an empty tree.


## Status Update
In progress.
