---
finding:
  id: IF-CELESTIA-15
  title: Duplication of test cases or a unfinished test case
  severity: ???
  impact: ???
  exploitability: ???
  type: Tests
  status: Closed.
  issue: https://github.com/celestiaorg/nmt/issues/146
---



## Description
There are two [testCases](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/nmt_test.go#L223-L236) that only have different names (which are similar), but all the other parameters are the same.


## Problem Scenarios
The same thing is tested with these two test case.


## Recommendation
One test case should be removed or modified to test something else.


## Status Update
Tests.
