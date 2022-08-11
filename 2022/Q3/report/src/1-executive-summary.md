# Audit overview
[]{id=1-executive-summary}

## The Project

In $start_Month$ $start_year$, $client$ engaged Informal Systems to conduct a
security audit over the documentation and the current state of the
implementation of $project$.

$project_description$

## Scope of this report

The agreed-upon workplan consisted of the following tasks:

1. $task1$
2. $task2$

This report covers the above tasks that were conducted $start_date$ through
$end_date$ by Informal Systems by the following personnel:

- $person1.name$: $person1.title$
- $person2.name$: $person1.title$

## Conducted work

TODO

## Timeline

- mm/dd/yyyy: Start
- mm/dd/yyyy: End of audit
- mm/dd/yyyy: submission of first draft of this report

## Conclusions

We found that the $project$ design and security model in general is well thought
out and ...

Despite the general high quality in ... we found some details
that should be addressed.

$summary_of_key_findings$

<!-- IF MANUAL REVIEW: -->
## Further Increasing Confidence

The scope of this audit was limited to manual code review and manual analysis
and reconstruction of the protocols. To further increase confidence in the
protocol and the implementation, we recommend following up with more rigorous
formal measures, including automated model checking and model-based adversarial
testing. Our experience shows that incorporating test suites driven by TLA+
models that can lead the implementation into suspected edge cases and error
scenarios enables discovery of issues that are unlikely to be identified through
manual review.

It is our understanding that the $client$ team intends to pursue such measures
to further improve the confidence in their system.
