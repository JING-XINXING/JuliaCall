
<!-- README.md is generated from README.Rmd. Please edit that file -->
JuliaCall for Seamless Integration of R and Julia
=================================================

Package JuliaCall is an R interface to 'Julia', which is a high-level, high-performance dynamic programming language for numerical computing, see <https://julialang.org/> for more information.

[![Travis-CI Build Status](https://travis-ci.org/Non-Contradiction/JuliaCall.svg?branch=master)](https://travis-ci.org/Non-Contradiction/JuliaCall)

Installation
============

You can get `JuliaCall` by

``` r
devtools::install_github("Non-Contradiction/JuliaCall")
```

Basic Usage
===========

``` r
library(JuliaCall)

julia <- julia_setup()
#> Julia version 0.6.0 found.
#> Julia initiation...

julia$command("a = sqrt(2)"); julia$eval_string("a")
#> NULL
#> [1] 1.414214

julia$eval_string("sqrt(2)")
#> [1] 1.414214

julia$call("sqrt", 2)
#> [1] 1.414214

julia$eval_string("sqrt")(2)
#> [1] 1.414214

2 %>J% sqrt
#> [1] 1.414214
```

JuliaCall for R Package Developers
==================================

If you are interested in developing an R package which is an interface for a Julia package, `JuliaCall` is an ideal choice for that!

Basically you only need to find the Julia function or Julia module you want to have in `R` and then just `using` the module and `call` the function. An example is `ipoptjlr`, which can be found at <https://github.com/Non-Contradiction/ipoptjlr>.

If you have any issues in developing an `R` package using `JuliaCall`, you may report it using the link: <https://github.com/Non-Contradiction/JuliaCall/issues/new>. Or email me at <lch34677@gmail.com> or <cxl508@psu.edu>.

Suggestion and Issue Reporting
==============================

`JuliaCall` is under active development now. Any suggestion or issue reporting is welcome! You may report it using the link: <https://github.com/Non-Contradiction/JuliaCall/issues/new>. Or email me at <lch34677@gmail.com> or <cxl508@psu.edu>.

And if you encounter some issues which crash `R` or `RStudio`, then you may have met segfault errors. I am very sorry. And I am trying my best to remove errors like that. It will be much appreciated if you can

-   download the source of `JuliaCall` from Github,
-   open `JuliaCall.Rproj` in your RStudio or open `R` from the directory where you download the source of `JuliaCall`,
-   run `devtools::check()` to see the result of `R CMD check` for `JuliaCall` on your machine,
-   and paste the result to the issue report.
