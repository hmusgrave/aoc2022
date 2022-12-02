const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn day(allocator: Allocator) !u8 {
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    if (args.len < 2)
        return error.NoDayArg;
    return try std.fmt.parseInt(u8, args[1], 10);
}

pub fn data(allocator: Allocator) ![]u8 {
    const file_name = try std.fmt.allocPrint(allocator, "data/day_{}.txt", .{try day(allocator)});
    defer allocator.free(file_name);

    const data_file = try std.fs.cwd().openFile(file_name, .{});
    defer data_file.close();

    return try data_file.readToEndAlloc(allocator, std.math.maxInt(usize));
}
