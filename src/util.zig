const std = @import("std");

pub fn withEnd(slice: []const u8, suffix: []const u8) bool {
    if (slice.len < suffix.len) {
        return false;
    }

    const start = slice.len - suffix.len;
    return std.mem.eql(u8, slice[start..], suffix);
}

pub fn walkDir(allocator: std.mem.Allocator, dir_path: []const u8) !std.fs.Dir.Walker {
    var dir = std.fs.cwd().openDir(dir_path, .{.iterate = true}) catch {
        std.debug.print("target directory not exist", .{});
        std.process.exit(1);
    };

    return try dir.walk(allocator);
}
