const std = @import("std");
const utils = @import("./utils.zig");

inline fn priority(item: anytype) @TypeOf(item) {
    if (item < 91)
        return 27 +% item -% 'A';
    return 1 +% item -% 'a';
}

fn common(left: anytype, right: anytype) @TypeOf(left[0], right[0]) {
    // puzzle input is small enough we can O(n^2) this and
    // have it be probably faster than hashing, probably slower
    // than bitmaps given the small, finite input
    if (@max(left.len, right.len) > 100)
        unreachable;
    for (left) |x| {
        for (right) |y| {
            if (x == y)
                return x;
        }
    }
    unreachable;
}

fn solve0(data: []u8) usize {
    var lines = std.mem.split(u8, data, "\n");
    var total: usize = 0;
    while (lines.next()) |line| {
        if (line.len == 0)
            continue;
        const m = line.len / 2;
        total += priority(common(line[0..m], line[m..]));
    }
    return total;
}

pub fn main() !void {
    var gp = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gp.deinit();
    const allocator = gp.allocator();

    const data = try utils.data(allocator);
    defer allocator.free(data);

    std.debug.print("{}\n{}\n", .{ solve0(data), solve0(data) });
}
