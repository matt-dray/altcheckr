# altcheckr

[![Travis build status](https://travis-ci.org/matt-dray/altcheckr.svg?branch=master)](https://travis-ci.org/matt-dray/altcheckr)

An R package to inspect a webpage for problems with the accessibility of image alt text. Under development.

## Context

Images on websites should have descriptive text so that users of assistive technology can understand their content.

Functions in this package help collect and inspect the images from a provided page for basic problems.

## Install

Install from GitHub with:

```
install.packages("remotes")
remotes::install_github("mattdray/altcheckr")
library(altcheckr)
```

## Use

There are two major functions for now:

* `alt_get_attr()` gets the attributes for each image from a provided webpage
* `alt_check()` checks each image for problems

Right now, `alt_check()` considers alt text that's:

* missing (but this is okay if the image is decorative)
* long (currently greater than an arbitrary 200 characters)
* short (currently smaller than an arbitrary 50 characters)
* self-evident ('image of', 'picture of')
* missing punctuation (just the terminal full stop for now)

## Resources

* Wikipedia's page for [the alt attribute](https://en.wikipedia.org/wiki/Alt_attribute)
* Royal National Institute of Blind People's (RNIB) [accessibility guidelines for alt text](https://www.rnib.org.uk/accessibility-guidelines-alt-text-what-you-need-know)
* W3C's [web accessibility tutorials on images](https://www.w3.org/WAI/tutorials/images/), including [a decision tree for using alt text](https://www.w3.org/WAI/tutorials/images/decision-tree/)
* Web Content Accessibility Guidelines (WCAG) [overview](https://www.w3.org/WAI/standards-guidelines/wcag/)
