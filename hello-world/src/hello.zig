const std = @import("std");
const fs = std.fs;
const print = std.debug.print;

pub fn main() !void {
    print("Hello,{s}!\n", .{"World"});
    // const constant: i32 = 5;
    // var variable: u32 = 5000;
    // const inferred_constant = @as(i32, 5);
    // var inferred_variable = @as(u32, 5000);
    // print("{d}{d}{d}{d}", constant, .{variable}, inferred_constant, .{inferred_variable});
    try read_file_line_by_line();
}

pub fn read_file_line_by_line() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var file = try fs.cwd().openFile("global-query.txt", .{});
    defer file.close();
    // Wrap the file reader in a buffered reader.
    // Since it's usually faster to read a bunch of bytes at once.
    var buf_reader = std.io.bufferedReader(file.reader());
    const reader = buf_reader.reader();

    var line = std.ArrayList(u8).init(allocator);
    defer line.deinit();

    const writer = line.writer();
    var line_no: usize = 0;
    while (reader.streamUntilDelimiter(writer, '\n', null)) {
        // Clear the line so we can reuse it.
        defer line.clearRetainingCapacity();
        line_no += 1;

        print("{d}--{s}\n", .{ line_no, line.items });
    } else |err| switch (err) {
        error.EndOfStream => { // end of file
            if (line.items.len > 0) {
                line_no += 1;
                print("{d}--{s}\n", .{ line_no, line.items });
            }
        },
        else => return err, // Propagate error
    }

    print("Total lines: {d}\n", .{line_no});
}
