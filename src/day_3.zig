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

fn FilterT(comptime IterT: type, comptime predicate: anytype) type {
    return struct {
        state: IterT,

        pub fn next(self: *@This()) @typeInfo(@TypeOf(IterT.next)).Fn.return_type.? {
            while (true) {
                const val = self.state.next() orelse {
                    return null;
                };
                if (predicate(val))
                    return val;
            }
        }
    };
}

pub fn filter(iter: anytype, comptime predicate: anytype) FilterT(@TypeOf(iter), predicate) {
    return .{ .state = iter };
}

fn nonempty(line: anytype) bool {
    return line.len != 0;
}

fn MapT(comptime IterT: type, comptime f: anytype) type {
    const OutOptT = @typeInfo(@TypeOf(IterT.next)).Fn.return_type.?;
    const OutT = @typeInfo(OutOptT).Optional.child;
    const T = @TypeOf(f(@as(OutT, undefined)));
    return struct {
        state: IterT,

        pub fn next(self: *@This()) CoalesceT(?T) {
            return f(self.state.next() orelse {
                return null;
            });
        }
    };
}

pub fn map(iter: anytype, comptime f: anytype) MapT(@TypeOf(iter), f) {
    return .{ .state = iter };
}

pub fn reduce(_iter: anytype, comptime combine: anytype, init: anytype) @TypeOf(init) {
    var iter = _iter;
    var total = init;
    while (iter.next()) |x|
        total = combine(total, x);
    return total;
}

fn NullifyT(comptime EU: type) type {
    return switch (@typeInfo(EU)) {
        .ErrorUnion => |eu| ?eu.payload,
        .ErrorSet => @TypeOf(null),
        else => unreachable,
    };
}

fn RootT(comptime T: type) type {
    return switch (@typeInfo(T)) {
        .Optional => |opt| RootT(opt.child),
        else => T,
    };
}

fn CoalesceT(comptime T: type) type {
    return ?RootT(T);
}

fn nullify(x: anytype) NullifyT(@TypeOf(x)) {
    return x catch null;
}

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

fn add(a: anytype, b: anytype) @TypeOf(a, b) {
    return a + b;
}

fn Const(C: anytype) fn (anytype) @TypeOf(C) {
    return struct {
        pub fn _f(_: anytype) @TypeOf(C) {
            return C;
        }
    }._f;
}

fn solve(data: []u8, comptime day: usize) !usize {
    var lines = filter(std.mem.split(u8, data, "\n"), nonempty);
    var pairs = map(map(lines, AssignmentPair.parse), nullify);
    const predicate = if (day == 0) AssignmentPair.contains else AssignmentPair.overlaps;
    var increments = map(filter(pairs, predicate), Const(@as(usize, 1)));
    return reduce(increments, add, @as(usize, 0));
}

pub fn main() !void {
    var gp = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gp.deinit();
    const allocator = gp.allocator();

    const data = try utils.data(allocator);
    defer allocator.free(data);

    std.debug.print("{}\n{}\n", .{ try solve(data, 0), try solve(data, 1) });
}
