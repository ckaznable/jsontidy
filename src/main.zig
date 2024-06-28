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

    var base_json_data = try json.readJsonFileToHashMap(allocator, args.base);
    defer base_json_data.deinit();
}

