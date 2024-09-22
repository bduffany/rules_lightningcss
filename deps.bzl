"""Dependencies for lightningcss"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def lightningcss_register_toolchains():
    register_toolchains(
        "@rules_lightningcss//toolchain:lightningcss_linux_x86_64",
    )

def lightningcss_deps():
    """Declares http_archives for lightningcss-cli version 1.27.0"""
    http_archive(
        name = "com_github_parcel-bundler_lightningcss_lightningcss-cli-darwin-arm64",
        build_file_content = """exports_files(["lightningcss"])""",
        sha512 = "e6f5c26a4240fe6d96495982512a5e123b06cbe2c1fcdd980b2fcf8e866dbab1fb7680175bc20ffe9e57d5f6eec97e00c329e9cc25868958e6145ca63ce4c152",
        strip_prefix = "package",
        urls = ["https://registry.npmjs.org/lightningcss-cli-darwin-arm64/-/lightningcss-cli-darwin-arm64-1.27.0.tgz"],
    )

    http_archive(
        name = "com_github_parcel-bundler_lightningcss_lightningcss-cli-darwin-x64",
        build_file_content = """exports_files(["lightningcss"])""",
        sha512 = "c423229800206e109d2634efc31ba533347f226e12a778e1ea742332acd45c576157abe403db0025e51e16065fb8fbb7713448f30ef80e594bbdb2bbedeefa9f",
        strip_prefix = "package",
        urls = ["https://registry.npmjs.org/lightningcss-cli-darwin-x64/-/lightningcss-cli-darwin-x64-1.27.0.tgz"],
    )

    http_archive(
        name = "com_github_parcel-bundler_lightningcss_lightningcss-cli-freebsd-x64",
        build_file_content = """exports_files(["lightningcss"])""",
        sha512 = "86c22ef5549035471c6545a2518bd45c1ef3abac3ec5b8d3e76559716c5de92bc78814d7194a31e41171609ded29cd87181f2371b60c1fb1d57db10cf64bacce",
        strip_prefix = "package",
        urls = ["https://registry.npmjs.org/lightningcss-cli-freebsd-x64/-/lightningcss-cli-freebsd-x64-1.27.0.tgz"],
    )

    http_archive(
        name = "com_github_parcel-bundler_lightningcss_lightningcss-cli-linux-arm64-gnu",
        build_file_content = """exports_files(["lightningcss"])""",
        sha512 = "4df5673060d6702191c0f05bedab04756604fa44d571e3286fe2e6d9a6df11ea4f3e00cc49cff060c78fe6c6a87c3bd8b0620d96e24ee9b6623e91490860ebef",
        strip_prefix = "package",
        urls = ["https://registry.npmjs.org/lightningcss-cli-linux-arm64-gnu/-/lightningcss-cli-linux-arm64-gnu-1.27.0.tgz"],
    )

    http_archive(
        name = "com_github_parcel-bundler_lightningcss_lightningcss-cli-linux-arm64-musl",
        build_file_content = """exports_files(["lightningcss"])""",
        sha512 = "c963946ab15d8128c120d52de7c8a310610fa42488bbc65017a1da235f2ccc61c6f466e42ccd1eb44313bf5b9da5de9c9839329b19359571db3e40fe0d6b72ec",
        strip_prefix = "package",
        urls = ["https://registry.npmjs.org/lightningcss-cli-linux-arm64-musl/-/lightningcss-cli-linux-arm64-musl-1.27.0.tgz"],
    )

    http_archive(
        name = "com_github_parcel-bundler_lightningcss_lightningcss-cli-linux-arm-gnueabihf",
        build_file_content = """exports_files(["lightningcss"])""",
        sha512 = "228d598df371dd43757e7938a2338cfb1d678ed554a35a41a5daec29e47b1292df7736deb99d95c99d5d429736398e39bb0c2904efc169016277f180cb58fc8e",
        strip_prefix = "package",
        urls = ["https://registry.npmjs.org/lightningcss-cli-linux-arm-gnueabihf/-/lightningcss-cli-linux-arm-gnueabihf-1.27.0.tgz"],
    )

    http_archive(
        name = "com_github_parcel-bundler_lightningcss_lightningcss-cli-linux-x64-gnu",
        build_file_content = """exports_files(["lightningcss"])""",
        sha512 = "6fca2e59e3e2c2141d283f6f06eef2c0bc035c9f98dcc1d663b84b6e7c31a75f87590fd0f5f2cd1297d1e19a055ebc35070303069e53ebc73584f0651a10e0aa",
        strip_prefix = "package",
        urls = ["https://registry.npmjs.org/lightningcss-cli-linux-x64-gnu/-/lightningcss-cli-linux-x64-gnu-1.27.0.tgz"],
    )

    http_archive(
        name = "com_github_parcel-bundler_lightningcss_lightningcss-cli-linux-x64-musl",
        build_file_content = """exports_files(["lightningcss"])""",
        sha512 = "0a78782ad9125d3df48f38e08792261c8a41a6daa67a64f13f25870bb3b897946090f8e7cb2b5f3a38162458e249f7821df34498dcb47af0c7dfc9794d77f912",
        strip_prefix = "package",
        urls = ["https://registry.npmjs.org/lightningcss-cli-linux-x64-musl/-/lightningcss-cli-linux-x64-musl-1.27.0.tgz"],
    )

    http_archive(
        name = "com_github_parcel-bundler_lightningcss_lightningcss-cli-win32-arm64-msvc",
        build_file_content = """exports_files(["lightningcss"])""",
        sha512 = "1d65fa698d021dfb7b424c610ba3610000f4426f72ac01fc24a4df3510f1bf22feaba13e2500cefef1b7df1e1855142820bdc4be1f4250bc870f21c2372d0875",
        strip_prefix = "package",
        urls = ["https://registry.npmjs.org/lightningcss-cli-win32-arm64-msvc/-/lightningcss-cli-win32-arm64-msvc-1.27.0.tgz"],
    )

    http_archive(
        name = "com_github_parcel-bundler_lightningcss_lightningcss-cli-win32-x64-msvc",
        build_file_content = """exports_files(["lightningcss"])""",
        sha512 = "0a4bab4829a3e620c9e4981c83e5e26d5a37192128e96e966d578abb35386df7a1de544b70c1d41bf177f8beba24979d514294abc78c4206cb38f9ad830ab124",
        strip_prefix = "package",
        urls = ["https://registry.npmjs.org/lightningcss-cli-win32-x64-msvc/-/lightningcss-cli-win32-x64-msvc-1.27.0.tgz"],
    )
