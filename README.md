# rules_lightningcss

Bazel rules for https://github.com/parcel-bundler/lightningcss,
an extremely fast parser, transformer, and minifier written in Rust.

## Status

Core functionality:

- [x] **CSS modules**
  - Basic support is implemented; some dependency resolution features
    may be missing
- [x] **browserslist**
- [x] **Minification**
- [x] **Source map generation**
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
