const std = @import("std");

const data = @embedFile("input.txt");

pub fn main() !void {
    std.debug.print("AoC 2022 Day 1!!!\n", .{});

    var gp = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gp.deinit();
    const allocator = gp.allocator();
    _ = allocator;

    var max: ?usize = 0;
    var elf_iter = std.mem.split(u8, data, "\n\n");
    while (elf_iter.next()) |x| {
        var total: usize = 0;
        var cal_iter = std.mem.tokenize(u8, x, "\n");
        while (cal_iter.next()) |y| {
            total += try std.fmt.parseInt(usize, y, 10);
        }
        if (max) |m| {
            max = @max(m, total);
        } else {
            max = total;
        }
    }
    std.debug.print("max: {any}\n", .{max});
}
