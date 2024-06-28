const std = @import("std");

const Map = std.json.ArrayHashMap(std.json.Value);

pub fn isJson(str: []u8) bool {
    return std.mem.endsWith(u8, str, ".json");
}

pub fn jsonToHashMap(allocator: std.mem.Allocator, json_str: []const u8) !std.json.Parsed(Map) {
    return try std.json.parseFromSlice(Map, allocator, json_str, .{ .ignore_unknown_fields = true });
}

pub fn readJsonFileToHashMap(allocator: std.mem.Allocator, file_path: []const u8) !std.json.Parsed(Map) {
    var file = try std.fs.cwd().openFile(file_path, .{ .mode = .read_only });
    defer file.close();

    const file_contents = try file.readToEndAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(file_contents);

    return try jsonToHashMap(allocator, file_contents);
}
