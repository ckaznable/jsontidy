const std = @import("std");

pub fn isJson(str: []u8) bool {
    return std.mem.endsWith(u8, str, ".json");
}

pub fn jsonToHashMap(allocator: std.mem.Allocator, json_str: []const u8) !std.json.Parsed(std.json.Value) {
    return try std.json.parseFromSlice(std.json.Value, allocator, json_str, .{ .ignore_unknown_fields = true });
}

pub fn readJsonFileToHashMap(allocator: std.mem.Allocator, dir: std.fs.Dir, file_path: []const u8) !std.json.Parsed(std.json.Value) {
    var file = try dir.openFile(file_path, .{ .mode = .read_only });
    defer file.close();

    const file_contents = try file.readToEndAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(file_contents);

    return try jsonToHashMap(allocator, file_contents);
}
