"""Module extensions for lightningcss"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def _parse_binary_name(binary_name):
    platform_name = binary_name[len("lightningcss-cli-"):]
    parts = platform_name.split("-")
    os = parts[0]
    cpu = parts[1]
    if cpu == "x64":
        cpu = "x86_64"
    if os == "darwin":
        os = "macos"
    if os == "win32":
        os = "windows"
    libc = ""
    if len(parts) >= 3:
        libc = parts[2]
    return struct(
        os = os,
        cpu = cpu,
        libc = libc,
    )

def _toolchains_repo_impl(ctx):
    # type: (repository_ctx) -> Unknown
    root_lines = []
    toolchains_lines = [
        'load("@rules_lightningcss//toolchain:toolchain.bzl", "lightningcss_toolchain")',
        "",
    ]
    for binary_name in ctx.attr.binary_names:
        build = _parse_binary_name(binary_name)
        os, cpu = build.os, build.cpu
        root_lines.extend([
            "toolchain(",
            '    name = "lightningcss_{os}_{cpu}_toolchain",'.format(os = os, cpu = cpu),
            "    exec_compatible_with = [",
            '        "@@platforms//os:{os}",'.format(os = os),
            '        "@@platforms//cpu:{cpu}",'.format(cpu = cpu),
            "    ],",
            '    toolchain = "//toolchains:lightningcss_toolchain_{os}_{cpu}",'.format(os = os, cpu = cpu),
            '    toolchain_type = "@rules_lightningcss//toolchain:toolchain_type",',
            ")",
        ])
        toolchains_lines.extend([
            "lightningcss_toolchain(",
            '    name = "lightningcss_toolchain_{os}_{cpu}",'.format(os = os, cpu = cpu),
            '    cli = "@com_github_parcel-bundler_lightningcss_{}//:lightningcss",'.format(binary_name),
            ")",
        ])

    ctx.file("BUILD", "\n".join(root_lines) + "\n")
    ctx.file("toolchains/BUILD", "\n".join(toolchains_lines) + "\n")

_toolchains_repo = repository_rule(
    implementation = _toolchains_repo_impl,
    attrs = {
        "binary_names": attr.string_list(mandatory = True),
    },
)

_download_cli = tag_class(
    attrs = {
        "version": attr.string(doc = "lightningcss-cli version to download"),
    },
)

def _is_supported(binary_name):
    build = _parse_binary_name(binary_name)
    return (
        build.os in ["linux", "macos", "windows"] and
        build.cpu in ["arm64", "x86_64"] and
        (build.os != "linux" or build.libc == "gnu")
    )

def _lightningcss_impl(ctx):
    # type: (module_ctx) -> Unknown
    for mod in ctx.modules:
        # TODO: figure out how to deal with multiple download_cli tags
        for download_cli in mod.tags.download_cli:
            version = download_cli.version
            ctx.download("https://registry.npmjs.org/lightningcss-cli/" + version, output = "metadata.json")
            metadata = json.decode(ctx.read("metadata.json"))
            binary_names = [
                binary_name
                for binary_name in metadata["optionalDependencies"].keys()
                if _is_supported(binary_name)
            ]
            downloads = {}
            for b in binary_names:
                downloads[b] = ctx.download(
                    "https://registry.npmjs.org/" + b + "/" + version,
                    output = b + ".metadata.json",
                    block = False,
                )

            for b in downloads:
                downloads[b].wait()
                metadata = json.decode(ctx.read(b + ".metadata.json"))

                http_archive(
                    name = "com_github_parcel-bundler_lightningcss_" + b,
                    urls = [metadata["dist"]["tarball"]],
                    integrity = metadata["dist"]["integrity"],
                    build_file_content = 'exports_files(["lightningcss"])',
                    strip_prefix = "package",
                )

            _toolchains_repo(
                name = "lightningcss_toolchains",
                binary_names = binary_names,
            )

lightningcss = module_extension(
    implementation = _lightningcss_impl,
    tag_classes = {
        "download_cli": _download_cli,
    },
)
