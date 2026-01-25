const std = @import("std");

/// Takes two structs of the same type.
/// Returns a new struct where fields are taken from `primary`.
/// However, if a field is optional (?T) and is null in `primary`, 
/// the value is taken from `defaults`.
pub fn structOrElse(primary: anytype, defaults: @TypeOf(primary)) @TypeOf(primary) {
    const T = @TypeOf(primary);

    // Verify that the input is a struct
    if (@typeInfo(T) != .@"struct") {
        @compileError("structOrElse expects a struct, but got: " ++ @typeName(T));
    }

    var result: T = undefined;

    // Iterate over all fields at compile-time
    inline for (std.meta.fields(T)) |field| {
        const name = field.name;
        const val_a = @field(primary, name);
        const val_b = @field(defaults, name);

        // Check if the field type is Optional (?T)
        const is_optional = @typeInfo(field.type) == .@"optional";

        if (is_optional) {
            // If the field is optional: use primary if not null, otherwise use defaults
            if (val_a) |payload| {
                @field(result, name) = payload;
            } else {
                @field(result, name) = val_b;
            }
        } else {
            // If the field is not optional, always take from primary
            @field(result, name) = val_a;
        }
    }

    return result;
}

fn enreach(b: *std.Build, conf: std.Build.Module.CreateOptions) @TypeOf(conf){
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
    const optimize = std.builtin.OptimizeMode.ReleaseSafe;
    const dflt = std.Build.Module.CreateOptions{
        .target = target,
        .optimize = optimize,
        .code_model = .kernel,
        .pic = false,
        .stack_protector = false,
        .unwind_tables = .none,
        .red_zone = false,
    };

    return structOrElse(conf, dflt);
}

fn imp(mod:  std.Build.Module) std.Build.Module.Import {
    return .{.name=mod.name};
}


pub fn build(b: *std.Build) void {

    // const compat = b.addModule("compat", enreach(b, .{
    //     .root_source_file = b.path("generated/stub.zig"),
    //     .code_model = .kernel,
    // }));
    //
    // const common = b.addModule("common", enreach(b, .{
    //     .root_source_file = b.path("src/common.zig"),
    //     .code_model = .kernel,
    //     .imports = &.{compat},
    // }));
    //
    // const super = b.addModule("super", enreach(b, .{
    //     .root_source_file = b.path("src/super.zig"),
    //     .code_model = .kernel,
    //     .imports = &.{common},
    // }));
    //
    // const inode = b.addModule("inode", enreach(b, .{
    //     .root_source_file = b.path("src/inode.zig"),
    //     .code_model = .kernel,
    //     .imports = &.{common},
    // }));
    //
    const module = b.addModule("main", enreach(b, .{
        .root_source_file = b.path("main.zig"),
        // .root_source_file = b.path("mn.zig"),
        .code_model = .kernel,
        // .imports = &.{super, inode},
    }));


    const obj = b.addObject(.{
        .name = "main",
        .root_module = module,
        .use_llvm = true
    });

    // obj.addIncludePath(gen_path);

    const install_file = b.addInstallFile(
        obj.getEmittedBin(),
        "imply.o"
    );

    b.getInstallStep().dependOn(&install_file.step);
}

