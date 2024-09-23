"""Public definitions for rules_lightningcss."""

load(
    "//lightningcss/private:rules.bzl",
    _CSSInfo = "CSSInfo",
    _CSSModuleMetadataInfo = "CSSModuleMetadataInfo",
    _CSSSourceMapInfo = "CSSSourceMapInfo",
    _css_library = "css_library",
    _css_module_js = "css_module_js",
)

css_library = _css_library
css_module_js = _css_module_js

CSSInfo = _CSSInfo
CSSSourceMapInfo = _CSSSourceMapInfo
CSSModuleMetadataInfo = _CSSModuleMetadataInfo
