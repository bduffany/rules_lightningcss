cc_library(
    name = "generate_js_lib",
    srcs = ["generate_js.cc"],
    deps = [
        "//third_party/yyjson",
    ],
)

cc_binary(
    name = "generate_js",
    visibility = ["//visibility:public"],
    deps = [":generate_js_lib"],
)
