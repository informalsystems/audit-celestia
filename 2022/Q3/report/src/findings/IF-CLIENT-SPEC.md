---
finding:
  id: IF-<CLIENT>-SPEC
  title: Specification of Concurrent Behaviors
  severity: Recommendation
  type: Protocol
  difficulty: Hard
  status: Unresolved
---

<!-- Most projects are under-specified. This finding is a place to gather the -->
<!-- general remarks about how to improve the specification  -->

<!-- TODO Replace `CLIENT` with the client's name, both in the YAML header and in the -->
<!-- file name. -->

# Involved artifacts

- <artifact-url>

# Description

In general, the possibility of determining whether a system is operating
correctly is limited by the extent to which its expected behavior has been
specified. As such, specification is a condition of possibility for determining
whether or not something is correct. It is all the more important to specify
behavior when dealing with concurrent systems, since the interaction of
concurrent behaviors are notoriously difficult to reason about and often defy
intuition. That said, the completeness and exactness of specification is a
matter of degree: some aspects of a system are too innocuous to warrant
specification, others are too little understood to enable it, while most aspects
are worthy of general description, but not critical enough to call for rigorous
specification. Each team must make their own cost/benefit analysis when deciding
how extensively to describe their systems' expected behaviors and how
intensively to specify those properties.

This finding collects recommendations regarding aspects of the system which are
unspecified or underspecified.

## Item 1

TODO

## Time 2

TODO

# Problem Scenarios

TODO


# Recommendation

TODO
