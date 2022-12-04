const std = @import("std");
const utils = @import("./utils.zig");

const Assignment = struct {
    start: usize,
    end: usize,

    pub fn parse(data: anytype) !@This() {
        var idx = std.mem.split(u8, data, "-");
        return @This(){
            .start = try std.fmt.parseInt(usize, idx.next() orelse {
                return error.IncompleteData;
            }, 10),
            .end = try std.fmt.parseInt(usize, idx.next() orelse {
                return error.IncompleteData;
            }, 10),
        };
    }

    pub fn contains(self: @This(), other: @This()) bool {
        return self.start <= other.start and self.end >= other.end;
    }

    pub fn overlaps(self: @This(), other: @This()) bool {
        // note that ranges are given inclusively
        return self.end >= other.start and self.start <= other.end;
    }
};

const AssignmentPair = struct {
    elves: [2]Assignment,

    pub fn parse(data: anytype) !@This() {
        var elves = std.mem.split(u8, data, ",");
        return @This(){
            .elves = [2]Assignment{
                try Assignment.parse(elves.next() orelse {
                    return error.IncompleteData;
                }),
                try Assignment.parse(elves.next() orelse {
                    return error.IncompleteData;
                }),
            },
        };
    }

    pub fn contains(self: @This()) bool {
        const elves = self.elves;
        return elves[0].contains(elves[1]) or elves[1].contains(elves[0]);
    }

    pub fn overlaps(self: @This()) bool {
        return self.elves[0].overlaps(self.elves[1]);
    }
};

fn solve0(data: []u8) !usize {
    var lines = std.mem.split(u8, data, "\n");
    var total: usize = 0;
    while (lines.next()) |line| {
        if (line.len == 0)
            continue;
        var pair = try AssignmentPair.parse(line);
        if (pair.contains())
            total += 1;
    }
    return total;
}

fn solve1(data: []u8) !usize {
    var lines = std.mem.split(u8, data, "\n");
    var total: usize = 0;
    while (lines.next()) |line| {
        if (line.len == 0)
            continue;
        var pair = try AssignmentPair.parse(line);
        if (pair.overlaps())
            total += 1;
    }
    return total;
}

pub fn main() !void {
    var gp = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gp.deinit();
    const allocator = gp.allocator();

    const data = try utils.data(allocator);
    defer allocator.free(data);

    std.debug.print("{}\n{}\n", .{ try solve0(data), try solve1(data) });
}
