load("@rules_lightningcss//:rules.bzl", "css_library", "css_module_classmap")

css_library(
    name = "example_css",
    srcs = ["example.module.css"],
    arguments = [
        # "--minify",
        # "--css-modules-pattern"
    ],
    browserslist = "//:browserslist",
    css_modules = True,
    sourcemap = True,
)

css_module_classmap(
    name = "example_css_classes",
    out = "example.module.css.js",
    css = ":example_css",
)
