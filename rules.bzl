"""TODO: module docs
"""

JSInfo = provider(
    doc = "Supplies the generated JavaScript file from a CSS module.",
    fields = {
        "file": "The generated .js `File` containing the mapping from unprefixed class names to prefixed ones.",
    },
)
CSSInfo = provider(
    doc = "Supplies the generated CSS file from a CSS module.",
    fields = {
        "file": "The generated .css `File` produces by lightningcss.",
    },
)

def _css_module_impl(ctx):
    # type: (ctx) -> Unknown

    css = ctx.actions.declare_file(ctx.attr.name + ".prefixed.css")
    json = ctx.actions.declare_file(ctx.attr.name + ".prefixed.json")
    js = ctx.actions.declare_file(ctx.attr.name + ".js")

    ctx.actions.run(
        executable = ctx.toolchains["//toolchain:toolchain_type"].lightningcssinfo.cli,
        arguments = [ctx.file.src.path, "-o", css.path, "--css-modules"],
        inputs = [ctx.file.src],
        outputs = [css, json],
    )
    ctx.actions.run(
        executable = ctx.executable._generate_js,
        arguments = [json.path, js.path],
        inputs = [json],
        outputs = [js],
    )

    return [
        # JSInfo(),
        DefaultInfo(files = depset([css, js])),
        CSSInfo(file = css),
        JSInfo(file = js),
    ]

_css_module = rule(
    attrs = {
        "src": attr.label(mandatory = True, allow_single_file = True),
        "_generate_js": attr.label(
            default = "//tools:generate_js",
            executable = True,
            allow_single_file = True,
            cfg = "exec",
        ),
    },
    implementation = _css_module_impl,
    toolchains = ["//toolchain:toolchain_type"],
)

def css_module(name, **kwargs):
    _css_module(
        name = name,
        **kwargs
    )
