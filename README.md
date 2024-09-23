# rules_lightningcss

Bazel rules for https://github.com/parcel-bundler/lightningcss, an
extremely fast CSS parser, transformer, and minifier written in Rust.

## Project status

This project is being developed, and does not yet have an official
release. For now, feel free to click "Watch" on GitHub to be notified when
it is released.

## Features

Core functionality:

- [x] **CSS modules**: module-scoped class names (`composes` is not supported)
- [x] **browserslist**
- [x] **Minification**
- [x] **Source maps**
- [ ] Compiling multiple sources (`--output-dir`)
- [ ] Dependencies and bundling: `@import`, `composes` (CSS modules), custom resolvers
- [ ] Custom transforms

Supporting functionality:

- [x] **JS class map generation**
  - Given a file like `MyComponent.module.css`, generates
    `MyComponent.module.css.js` containing a map with classes that can be
    imported and referenced from JS or TS code.
  - This is done using a small tool written in C that directly generates a
    JS file based on the JSON output from lightningcss.

## Usage

See examples directory.

TODO: publish to Bazel Central Registry.
