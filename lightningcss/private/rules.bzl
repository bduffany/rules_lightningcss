"""Rules for lightningcss and classmap JS generator.
"""

load(":hash.bzl", "sha256_ascii_printable_chars")

CSSInfo = provider(
    doc = "Supplies the CSS `File` generated by lightningcss.",
    fields = {
        "file": "The generated CSS `File`.",
    },
)
CSSModuleMetadataInfo = provider(
    doc = "Supplies the generated JSON `File` from running lightningcss.",
    fields = {
        "file": "The generated JSON metadata `File`.",
    },
)
CSSSourceMapInfo = provider(
    doc = "Supplies the sourcemap `File` generated by lightningcss.",
    fields = {
        "file": "The generated sourcemap `File`.",
    },
)

def _lightningcss_impl(ctx):
    # type: (ctx) -> Unknown

    css_name = ctx.attr.out or ctx.attr.name + ".compiled.css"
    css = ctx.actions.declare_file(css_name)

    inputs = [f for f in ctx.files.srcs]
    outputs = [css]

    args = []
    args.extend([src.path for src in ctx.files.srcs])
    args.extend(["--output-file", css.path])
    sourcemap = None
    if ctx.attr.sourcemap:
        sourcemap = ctx.actions.declare_file(css_name + ".map")
        outputs.append(sourcemap)
        args.append("--sourcemap")
    if ctx.attr.minify:
        args.append("--minify")

    args.extend(ctx.attr.arguments)

    if ctx.attr.css_modules_metadata_out and not ctx.attr.css_modules:
        fail("css_modules_metadata_out attribute requires setting css_modules = True")
    if ctx.attr.css_modules_dashed_idents and not ctx.attr.css_modules:
        fail("css_modules_dashed_idents attribute requires setting css_modules = True")
    if ctx.attr.css_modules_pattern and not ctx.attr.css_modules:
        fail("css_modules_pattern attribute requires setting css_modules = True")
    metadata = None
    if ctx.attr.css_modules:
        metadata_name = ctx.attr.css_modules_metadata_out or css_name[:-len(".css")] + ".json"
        metadata = ctx.actions.declare_file(metadata_name)
        outputs.append(metadata)
        args.append("--css-modules")
        args.append(metadata.path)

        args.append("--css-modules-pattern")
        args.append(ctx.attr.css_modules_pattern or "%s_[local]" % _hash_target_label(ctx))

    if ctx.attr.css_modules_dashed_idents:
        args.append("--css-modules-dashed-idents")

    env = {}
    if ctx.attr.browserslist:
        args.append("--browserslist")
        env["BROWSERSLIST_CONFIG"] = ctx.file.browserslist.path
        inputs.append(ctx.file.browserslist)
    if ctx.attr.browserslist_env:
        if not ctx.attr.browserslist:
            fail("browserslist_env attribute requires browserslist attribute to be specified")
        env["BROWSERSLIST_ENV"] = ctx.attr.browserslist_env

    ctx.actions.run(
        executable = ctx.toolchains["//toolchain:toolchain_type"].lightningcssinfo.cli,
        arguments = args,
        inputs = inputs,
        outputs = outputs,
        env = env,
    )

    providers = [
        DefaultInfo(files = depset([css])),
        CSSInfo(file = css),
    ]
    if sourcemap:
        providers.append(CSSSourceMapInfo(file = sourcemap))
    if metadata:
        providers.append(CSSModuleMetadataInfo(file = metadata))

    return providers

_lightningcss = rule(
    attrs = {
        "srcs": attr.label_list(
            doc = "CSS source file to process",
            mandatory = True,
            allow_files = True,
        ),
        "out": attr.string(
            doc = "CSS output file path",
        ),
        "browserslist": attr.label(
            doc = "browserslist file label",
            allow_single_file = True,
        ),
        "browserslist_env": attr.string(
            doc = "browserslist env, e.g. 'production'",
        ),
        "sourcemap": attr.bool(
            doc = "If True, generates a sourcemap at <output_file>.map",
        ),
        "css_modules": attr.bool(
            doc = "Enable CSS modules",
        ),
        "css_modules_dashed_idents": attr.bool(
            doc = "Enables module scoping for dashed identifiers such as CSS variables",
        ),
        "css_modules_pattern": attr.string(
            doc = """
            Pattern for generated class names in CSS modules.

            The default pattern used by this rule set is different than the default
            used by lightningcss. By default, lightningcss hashes the path to the
            file, which isn't ideal for bazel use cases because the path can change
            depending on the execution environment.

            So instead, we default to a hash derived from the bazel repository name
            and relative package path, which are stable regardless of where the rules
            are executed.
            """,
        ),
        "css_modules_metadata_out": attr.string(
            doc = "Sets the default CSS module metadata JSON file name. Defaults to the CSS filename with .css replaced by .json",
        ),
        "minify": attr.bool(
            doc = "Output minified CSS",
        ),
        "arguments": attr.string_list(
            doc = "Extra arguments to pass to lightningcss-cli. Should generally not be needed; prefer specifying args as attributes.",
        ),
        "_generate_js": attr.label(
            default = "//tools:generate_js",
            executable = True,
            allow_single_file = True,
            cfg = "exec",
        ),
    },
    implementation = _lightningcss_impl,
    toolchains = ["//toolchain:toolchain_type"],
)

def _hash_target_label(ctx):
    label = "@@{}//{}:{}".format(ctx.label.repo_name, ctx.label.package, ctx.label.name)
    sha256_hex = sha256_ascii_printable_chars(label)
    return sha256_hex[:8]

def css_library(name, **kwargs):
    _lightningcss(
        name = name,
        **kwargs
    )

def _generate_classmap_impl(ctx):
    # type: (ctx) -> Unknown
    js = ctx.actions.declare_file(ctx.attr.out)
    metadata = ctx.attr.css[CSSModuleMetadataInfo].file
    ctx.actions.run(
        executable = ctx.executable._generate_classmap,
        arguments = [metadata.path, js.path],
        inputs = [metadata],
        outputs = [js],
    )

    return [
        DefaultInfo(files = depset([js])),
    ]

_generate_classmap = rule(
    attrs = {
        "css": attr.label(
            doc = "css_library target.",
            mandatory = True,
            providers = [CSSModuleMetadataInfo],
        ),
        "out": attr.string(
            doc = "Generated JS output path.",
            mandatory = True,
        ),
        "_generate_classmap": attr.label(
            default = "//tools:generate_js",
            executable = True,
            cfg = "exec",
        ),
    },
    implementation = _generate_classmap_impl,
)

def css_module_js(name, **kwargs):
    _generate_classmap(
        name = name,
        **kwargs
    )
