const std = @import("std");

pub fn withEnd(slice: []const u8, suffix: []const u8) bool {
    if (slice.len < suffix.len) {
        return false;
    }

    const start = slice.len - suffix.len;
    return std.mem.eql(u8, slice[start..], suffix);
}

pub fn walkDir(allocator: std.mem.Allocator, dir_path: []const u8) !std.ArrayList([]u8) {
    var it = try std.fs.cwd().openIterableDir(dir_path, .{});
    defer it.close();

    var path_list = std.ArrayList([]u8).init(allocator.*);

    while (true) {
        const entry = try it.next();
        if (entry == null)
            break;

        if (entry.?.kind == .Directory)
            continue;

        const full_path = try std.fmt.allocPrint(allocator, "{}/{}", .{dir_path, entry.?.name});

        if (std.mem.endsWith(u8, entry.?.name, ".json")) {
            path_list.append(full_path);
        }

        allocator.free(full_path);
    }

    return path_list;
}
