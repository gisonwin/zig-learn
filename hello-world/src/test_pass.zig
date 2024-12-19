const std = @import("std");
const expect = std.testing.expect;
test "always succeeds" {
    try expect(true);
}
test "always failed" {
    try expect(false);
}
