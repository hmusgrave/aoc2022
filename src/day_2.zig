const std = @import("std");
const utils = @import("./utils.zig");

inline fn priority(item: anytype) @TypeOf(item) {
    if (item < 91)
        return 27 +% item -% 'A';
    return 1 +% item -% 'a';
}

inline fn bitset(item: anytype) usize {
    return @as(usize, 1) << @intCast(u6, (item - 'A'));
}

inline fn multi_bitset(items: anytype) usize {
    var total: usize = 0;
    for (items) |x|
        total |= bitset(x);
    return total;
}

inline fn common(groups: anytype) usize {
    if (groups.len == 0)
        @compileError("Undefined");
    var total: usize = std.math.maxInt(usize);
    inline for (groups) |g| {
        total &= multi_bitset(g);
    }
    return @ctz(total) + 'A';
}

fn solve0(data: []u8) usize {
    var lines = std.mem.split(u8, data, "\n");
    var total: usize = 0;
    while (lines.next()) |line| {
        if (line.len == 0)
            continue;
        const m = line.len / 2;
        total += priority(common(.{ line[0..m], line[m..] }));
    }
    return total;
}

fn solve1(data: []u8) usize {
    var lines = std.mem.split(u8, data, "\n");
    var total: usize = 0;
    var group: usize = 0;
    var running: usize = std.math.maxInt(usize);
    while (lines.next()) |line| {
        if (line.len == 0)
            continue;
        running &= multi_bitset(line);
        group += 1;
        if (group == 3) {
            total += priority(@ctz(running) + 'A');
            group = 0;
            running = std.math.maxInt(usize);
        }
    }
    return total;
}

pub fn main() !void {
    var gp = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gp.deinit();
    const allocator = gp.allocator();

    const data = try utils.data(allocator);
    defer allocator.free(data);

    std.debug.print("{}\n{}\n", .{ solve0(data), solve1(data) });
}
