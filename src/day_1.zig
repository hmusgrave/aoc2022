const std = @import("std");
const utils = @import("./utils.zig");

fn solve0(data: []u8) usize {
    var pairs = std.mem.split(u8, data, "\n");
    var total: usize = 0;
    while (pairs.next()) |pair| {
        if (pair.len < 3)
            continue;
        var them = pair[0] - 'A';
        var us = pair[2] - 'X';
        total += (us + 1) + switch (@mod((us + 3) -% them, 3)) {
            0 => @as(usize, 3),
            1 => @as(usize, 6),
            2 => @as(usize, 0),
            else => unreachable,
        };
    }
    return total;
}

fn solve1(data: []u8) usize {
    var pairs = std.mem.split(u8, data, "\n");
    var total: usize = 0;
    while (pairs.next()) |pair| {
        if (pair.len < 3)
            continue;
        var them = pair[0] - 'A';
        var us = pair[2] - 'X';
        total += switch (us) {
            0 => @as(usize, 0),
            1 => @as(usize, 3),
            2 => @as(usize, 6),
            else => unreachable,
        } + 1 + switch (us) {
            0 => @mod(them + 3 -% 1, 3),
            1 => them,
            2 => @mod(them + 3 -% 2, 3),
            else => unreachable,
        };
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
