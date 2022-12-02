# aoc2022

Another AoC 2022 implementation in Zig.

# Usage

The idea of this template (compared to others) is that you usually only care about one bit of functionality at once in AoC, so there's no real reason to build in every day's problems when you're iterating on `zig build run` quickly. Instead, specify the day you care about and run `zig build run -- 0` to handle day 0's problem/data.

Just to get used to how it works, data handling is done with runtime files rather than `@embedFile`. We don't deal with out-of-RAM conditions and streaming the data, but it's more real-world than assuming all data exists at comptime.

Source/data files are required to follow a `src/day_{i}.zig` and `data/day_{i}.zig` convention for the build file to pick them up.
