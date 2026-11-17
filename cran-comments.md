## Resubmission of an archived package

This is a resubmission of tidyindex, which was archived on 2026-01-22 because
email to the maintainer was undeliverable.

* The maintainer's previous address (huize.zhang@monash.edu) is no longer
  active, so I cannot confirm the change from that address. The maintainer
  is still H. Sherry Zhang, now at huizezhangsh@gmail.com.

* I have fixed the NOTEs from the CRAN check results at the time of archival:
  * Added `Depends: R (>= 4.1.0)` because the package uses the native pipe
    `|>` and `\(x)` lambda syntax.
  * Excluded the `demo/` directory from the package build. Its scripts used
    packages that were not declared.

## Test environments

* local macOS (aarch64), R 4.6.1
* win-builder: R-devel and R-release

## R CMD check results

0 errors | 0 warnings | 1 note

* checking CRAN incoming feasibility ... NOTE
  New submission. Package was archived on CRAN.

  This is expected: see the explanation above.
