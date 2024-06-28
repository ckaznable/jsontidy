const std = @import("std");

pub const ArgsError = error{
    ArgsRequired
};

pub const Args = struct {
    base: []u8,
    target: []u8,
    allocator: *std.mem.Allocator,

    pub fn init(allocator: *std.mem.Allocator) !Args {
        const args = try std.process.argsAlloc(allocator.*);
        defer std.process.argsFree(allocator.*, args);

        if (args.len < 3) {
            return ArgsError.ArgsRequired;
        }

        const result = Args {
            .base = try allocator.alloc(u8, args[1].len),
            .target = try allocator.alloc(u8, args[2].len),
            .allocator = allocator,
        };

        @memcpy(result.base, args[1]);
        @memcpy(result.target, args[2]);

        return result;
    }

    pub fn deinit(self: Args) void {
        self.allocator.free(self.base);
        self.allocator.free(self.target);
    }
};
