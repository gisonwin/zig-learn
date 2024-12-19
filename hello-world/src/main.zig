const std = @import("std");

pub fn main() void {
    const ida: i32 = 10;
    std.debug.print("the id = {d} \n", .{ida});
    std.debug.print("Hello World!");
}

test "simple test" {
    try std.testing.expect(true);
}
