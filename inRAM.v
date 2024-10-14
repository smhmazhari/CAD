// module input_RAM(input read,
//                  input [3:0] addr,
//                  output [15:0] result);
//     reg [15:0] RAM [0:15];
//     initial begin
//         $readmemb("data_input.txt", RAM);
//     end
//     assign result = RAM[addr] ;
// endmodule
module input_RAM();

reg [7:0] data_in;
reg [31:0] address;

// Declare task for reading from the file
task read_file;
  input string filename;
  input reg [31:0] addr;

  begin
    $readmemh(filename, data_in, addr, addr + 8'h01); // Adjust for your file format
    // You can add error handling here if needed 
  end
endtask 

initial begin
  // Start the file read in a separate process
  read_file("input_data.txt", address);
end
endmodule