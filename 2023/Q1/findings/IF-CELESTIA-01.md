---
finding:
  id: IF-CELESTIA-01
  title: Typo at the nmt documentation
  severity: Informational
  impact: None
  exploitability: None
  type: Documentation
  status: Resolved
  issue: https://github.com/informalsystems/audit-celestia/issues/41
---



## Description
In the nmt specification the names (`r` and `l`) of the children of the **Non-leaf Node** `n`  have been switched when introducing them.

In the following code block:

```
**Non-leaf Nodes**: For an intermediary node `n` of the NMT with children

`r` = `l.minNs || l.maxNs || l.hash` and

`l` = `r.minNs || r.maxNs || r.hash`
```

`r` is used for the left node and the `l` is used for the right node, while it should be reversed.

## Problem Scenarios
This issue affects the clearness of the nmt specification.


## Recommendation
We recommend correcting the typo.


## Status Update
Resolved. 