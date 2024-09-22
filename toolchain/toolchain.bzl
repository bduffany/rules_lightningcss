"""Toolchain rules and providers for lightningcss
"""

LightningcssInfo = provider(
    doc = "lightningcss toolchain info",
    fields = {
        "cli": "lightningcss-cli executable `File`.",
    },
)

def _lightningcss_toolchain_impl(ctx):
    # type: (ctx) -> Unknown
    toolchain_info = platform_common.ToolchainInfo(
        lightningcssinfo = LightningcssInfo(
            cli = ctx.executable.cli,
        ),
    )
    return [toolchain_info]

lightningcss_toolchain = rule(
    implementation = _lightningcss_toolchain_impl,
    attrs = {
        "cli": attr.label(
            doc = "lightningss-cli executable",
            executable = True,
            mandatory = True,
            allow_single_file = True,
            cfg = "exec",
        ),
    },
)
