const std = @import("std");
const cli = @import("./cli.zig");
const util = @import("./util.zig");

const json = @import("./json.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var args = cli.Args.init(&allocator) catch |err| {
        switch (err) {
            cli.ArgsError.ArgsRequired => {
                std.debug.print("2 arguments required", .{});
                std.process.exit(1);
            },
            else => return err,
        }
    };
    defer args.deinit();

    if (!json.isJson(args.base)) {
        std.debug.print("arguments 1 is not json file\n", .{});
        std.process.exit(1);
    }

    var base_json_data = try json.readJsonFileToHashMap(allocator, std.fs.cwd(), args.base);
    var base_data = base_json_data.value.object;
    defer base_json_data.deinit();

    const base_keys = base_data.keys();
    std.debug.print("has {} keys in base json\n", .{base_keys.len});

    var dirs = try util.walkDir(allocator, args.target);
    defer dirs.deinit();

    while (true) {
        const entry = try dirs.next();
        if (entry == null)
            break;

        std.debug.print("process {s}\n", .{entry.?.basename});

        const file_name = entry.?.basename;
        var json_data = try json.readJsonFileToHashMap(allocator, entry.?.dir, file_name);
        defer json_data.deinit();

        const data = json_data.value.object;
        const keys = data.keys();
        std.debug.print("{s} has {} keys\n", .{file_name, keys.len});
    }

    std.debug.print("done\n", .{});
}

