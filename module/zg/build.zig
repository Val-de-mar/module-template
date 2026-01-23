const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .x86_64,
        .os_tag = .freestanding,
        .abi = .none,

        .cpu_features_add = std.Target.x86.featureSet(&.{
            .sse, .sse2, .sse3, .ssse3, .sse4_1, .sse4_2,
            .avx, .avx2, .avx512f,
            .mmx,
            .x87,
        })
    });

    const gen_path = b.option(std.Build.LazyPath, "generated_path", "Path to generated headers") 
        orelse b.path("../generated");

    const optimize = std.builtin.OptimizeMode.ReleaseSafe;

    const module = b.addModule("main", .{
        .root_source_file = b.path("main.zig"),
        .target = target,
        .optimize = optimize,
        .code_model = .kernel,
        .pic = false,
        .stack_protector = false,
        .unwind_tables = .none,
        .red_zone = false,
    });

    const obj = b.addObject(.{
        .name = "main",
        .root_module = module,
        .use_llvm = true
    });

    obj.addIncludePath(gen_path);

    const install_file = b.addInstallFile(
        obj.getEmittedBin(),
        "imply.o"
    );

    b.getInstallStep().dependOn(&install_file.step);
}

