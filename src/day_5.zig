const std = @import("std");
const utils = @import("./utils.zig");

fn unique(data: []u8) bool {
    if (data.len == 0)
        return true;
    std.sort.sort(u8, data, {}, struct {
        fn f(context: void, a: u8, b: u8) bool {
            return std.sort.asc(u8)(context, a, b);
        }
    }.f);
    for (data[0 .. data.len - 1]) |x, i| {
        if (x == data[i + 1])
            return false;
    }
    return true;
}

fn solve(data: []u8, comptime n: usize) !usize {
    var i: usize = 0;
    while (i < data.len - n + 1) : (i += 1) {
        var buf: [n]u8 = undefined;
        std.mem.copy(u8, buf[0..], data[i .. i + n]);
        if (unique(buf[0..]))
            return i + n;
    }
    return 0;
}

pub fn main() !void {
    var gp = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gp.deinit();
    const allocator = gp.allocator();

    const data = try utils.data(allocator);
    defer allocator.free(data);

    std.debug.print("{}\n{}\n", .{ try solve(data, 4), try solve(data, 14) });
}
