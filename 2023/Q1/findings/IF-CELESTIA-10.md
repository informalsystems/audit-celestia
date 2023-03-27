---
finding:
  id: IF-CELESTIA-10
  title: Introducing a generic function for generating example trees
  severity: ???
  impact: ???
  exploitability: ???
  type: Good coding practice
  status: In progress
  issue: https://github.com/celestiaorg/nmt/issues/132
---



## Description
One generic function could be made for generating nmt trees with different number of leaves and namespace id sizes. [These two](https://github.com/celestiaorg/nmt/blob/1d69de97d68684fdfecb37abeb5fbd75f25826ba/nmt_test.go#L809-L847) functions can be replaced by one generic function with a number of leaves as a function parameter, thus avoiding code duplication.


## Problem Scenarios
Writing many functions that could be replaced by one generic function affects readability and maintainability.


## Recommendation
One generic function could be made for generating nmt trees with different number of leaves and namespace id sizes.


## Status Update
In progress.
