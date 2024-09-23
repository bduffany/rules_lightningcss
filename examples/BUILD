load("@rules_lightningcss//lightningcss:def.bzl", "css_library", "css_module_js")

css_library(
    name = "example_css",
    srcs = ["example.module.css"],
    browserslist = "//:browserslist",
    css_modules = True,
    sourcemap = True,
)

css_module_js(
    name = "example_css_classes",
    out = "example.module.css.js",
    css = ":example_css",
)
