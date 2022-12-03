const std = @import("std");
const utils = @import("./utils.zig");

const Guess = enum(usize) {
    rock,
    paper,
    scissors,
};

const Win = enum(usize) {
    tie,
    win,
    lose,
};

const Game = struct {
    guess: Guess,
    win: Win,

    pub fn parse0(line: []const u8) !@This() {
        if (line.len != 3)
            return error.Invalid;

        const them = line[0] - 'A';
        const us = line[2] - 'X';
        return @This(){
            .guess = @intToEnum(Guess, us),
            .win = @intToEnum(Win, @mod((us + 3) -% them, 3)),
        };
    }

    pub fn parse1(line: []const u8) !@This() {
        if (line.len != 3)
            return error.Invalid;

        const them = line[0] - 'A';
        const win = @intToEnum(Win, @mod((line[2] - 'X') + 3 - 1, 3));
        const us = @intToEnum(Guess, switch (win) {
            .tie => them,
            .win => @mod(them + 1, 3),
            .lose => @mod(them + 3 - 1, 3),
        });
        return @This(){
            .guess = us,
            .win = win,
        };
    }

    pub fn parse(line: []const u8, comptime day: usize) !@This() {
        return switch (day) {
            0 => parse0(line),
            1 => parse1(line),
            else => unreachable,
        };
    }

    fn score(self: @This()) usize {
        return @enumToInt(self.guess) + 1 + switch (self.win) {
            .tie => @as(usize, 3),
            .win => @as(usize, 6),
            .lose => @as(usize, 0),
        };
    }
};

fn solve(data: []u8, comptime day: usize) usize {
    var pairs = std.mem.split(u8, data, "\n");
    var total: usize = 0;
    while (pairs.next()) |pair| {
        if (pair.len < 3)
            continue;
        const game = Game.parse(pair, day) catch unreachable;
        total += game.score();
    }
    return total;
}

pub fn main() !void {
    var gp = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gp.deinit();
    const allocator = gp.allocator();

    const data = try utils.data(allocator);
    defer allocator.free(data);

    std.debug.print("{}\n{}\n", .{ solve(data, 0), solve(data, 1) });
}
