# altcheckr

An R package to inspect a webpage for problems with the accessibility of image alt text.

A work in progress.

## Context

Images on websites should have descriptive text so that users of assistive technology can understand their content.

Functions in this package help collect and inspect the images from a provided page for basic problems.

## Install

Install from GitHub with:

```
install.packages("remotes")
remotes::install_github("mattdray/altcheckr")
library(altcheckr)
```

## Use

There are two major functions for now:

* `alt_get_attr()` gets the attributes for each image from a provided webpage
* `alt_check()` checks each image for problems

## Resources

* Web Content Accessibility Guidelines (WCAG) [overview](https://www.w3.org/WAI/standards-guidelines/wcag/)
* W3C's [resources on alternative text for images](https://www.w3.org/WAI/alt/)
* W3C Working Group Note: [using `alt` attributes on `img` elements]()
* W3C's [web accessibility tutorials on images](https://www.w3.org/WAI/tutorials/images/)