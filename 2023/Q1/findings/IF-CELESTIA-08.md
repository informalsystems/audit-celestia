---
finding:
  id: IF-CELESTIA-08
  title: Duplication of code
  severity: ???
  impact: ???
  exploitability: ???
  type: ???
  status: In progress
  issue: https://github.com/celestiaorg/nmt/issues/129
---



## Description
There is a duplication of code in the `HashNode` function.
Validity checks for internal node children are done within a function called [ValidateNode](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/hasher.go#L200).
The same validity checks have been called individually [here](https://github.com/celestiaorg/nmt/blob/4276d172f18c87ebdd18da0cc4b758f0dd164118/hasher.go#L237-L247).So instead calling these validity checks one by one, `ValidateNode` should be called instead.


## Problem Scenarios
This affects the clarity and maintainability of the code.


## Recommendation
Function `ValidateNode` should be called instead calling validity checks individually.


## Status Update
In progress.
