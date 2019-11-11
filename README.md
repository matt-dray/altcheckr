# altcheckr

<!-- badges: start -->
[![Travis build status](https://travis-ci.org/matt-dray/altcheckr.svg?branch=master)](https://travis-ci.org/matt-dray/altcheckr)
[![Coverage status](https://codecov.io/gh/matt-dray/altcheckr/branch/master/graph/badge.svg)](https://codecov.io/github/matt-dray/altcheckr?branch=master)
<!-- badges: end -->

An R package to inspect a web page for problems with the accessibility of image alt text. Under development.

## Context

Images on websites should have descriptive text so that users of assistive technology can understand their content.

Functions in this package help collect and inspect the images from a provided page for basic problems.

## Install

Install from GitHub with:

```
install.packages("remotes")
remotes::install_github("matt-dray/altcheckr")
library(altcheckr)
```

## Use

There are two major functions for now:

* `alt_get()` creates a tibble of HTML attributes for each 'img' element on a supplied web page
* `alt_check()` performs basic checks of the alt text for each image

The `alt_get()` function uses {xml2} and {rvest} to scrape a given web page and extract image attributes, with a little bit of {purrr} to get it into a data frame.

Right now, the `alt_check()` function flags when alt text:

* is missing (but this is okay if the image is decorative)
* is noticeably short or long (length can be controlled by the user)
* contains self-evident phrases ('image of', 'picture of', etc)
* is missing terminal punctuation, which interferes with how the sentence is parsed

And it also:

* highlights words that may be misspelled, via the {hunspell} package
* provides a readability score via the {quanteda} package

## Resources

* Wikipedia's page for [the alt attribute](https://en.wikipedia.org/wiki/Alt_attribute)
* Royal National Institute of Blind People's (RNIB) [accessibility guidelines for alt text](https://www.rnib.org.uk/accessibility-guidelines-alt-text-what-you-need-know)
* W3C's [web accessibility tutorials on images](https://www.w3.org/WAI/tutorials/images/), including [a decision tree for using alt text](https://www.w3.org/WAI/tutorials/images/decision-tree/)
* Web Content Accessibility Guidelines (WCAG) [overview](https://www.w3.org/WAI/standards-guidelines/wcag/)

## Code of conduct

Please note that the 'altcheckr' project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you agree to abide by its terms.