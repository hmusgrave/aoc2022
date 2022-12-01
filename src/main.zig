const std = @import("std");

const data = @embedFile("input.txt");

fn Priority(comptime T: type, comptime N: usize) type {
    return struct {
        data: [N]T,
        count: usize,

        pub fn init() @This() {
            return .{
                .data = [_]T{0} ** N,
                .count = 0,
            };
        }

        pub fn update(self: *@This(), val: T) void {
            if (self.count < N) {
                self.data[self.count] = val;
                self.count += 1;
            } else {
                var m = self.data[0];
                var mi: usize = 0;
                for (self.data[1..]) |x, i| {
                    if (x < m) {
                        m = x;
                        mi = i + 1;
                    }
                }
                if (val > m)
                    self.data[mi] = val;
            }
        }

        pub fn all(self: @This()) T {
            var total: T = 0;
            for (self.data) |x|
                total += x;
            return total;
        }
    };
}

pub fn main() !void {
    std.debug.print("AoC 2022 Day 1!!!\n", .{});

    var gp = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gp.deinit();
    const allocator = gp.allocator();
    _ = allocator;

    var max = Priority(usize, 3).init();
    var elf_iter = std.mem.split(u8, data, "\n\n");
    var i: usize = 0;
    while (elf_iter.next()) |x| : (i += 1) {
        var total: usize = 0;
        var cal_iter = std.mem.tokenize(u8, x, "\n");
        while (cal_iter.next()) |y| {
            total += try std.fmt.parseInt(usize, y, 10);
        }
        max.update(total);
    }
    std.debug.print("max: {any}\n", .{max.all()});
}
