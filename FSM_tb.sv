module tb_Room_Lights_FSM;

  // Parameters
  parameter CAPACITY = 8;

  // Testbench signals
  logic clk;
  logic reset;
  logic seq_in;
  wire Lights;

  // Instantiate DUT
  Room_Lights_FSM #(CAPACITY) dut (
    .clk(clk),
    .reset(reset),
    .seq_in(seq_in),
    .Lights(Lights)
  );

  // Clock generation (10ns period)
  always #5 clk = ~clk;

  // --- TASKS ---

  // Simulate person entering: seq_in = 1 then 0
  task person_enters();
    begin
      $display("[%0t] Person entering...", $time);
      seq_in = 1; 
      @(posedge clk);
      seq_in = 0; 
      @(posedge clk);
    end
  endtask

  // Simulate person exiting: seq_in = 0 then 1
  task person_exits();
    begin
      $display("[%0t] Person exiting...", $time);
      seq_in = 0; 
      @(posedge clk);
      seq_in = 1; 
      @(posedge clk);
    end
  endtask

  // --- TEST STIMULUS ---
  initial begin

    // Init
    clk = 0;
    reset = 1;
    seq_in = 0;

    // Apply reset
    #7;
    reset = 0;

    // Wait one clock
    //@(posedge clk);

    $display("\n--- Begin Test ---\n");
    // 4 people enter
    person_enters();
    person_enters();
    person_enters();
    person_enters();


    // 3 people exit
    person_exits();
    person_exits();
    person_exits();


    // 1 person enters
    person_exits();

    $display("\n--- End Test ---\n");
    $finish;
  end
    initial begin
    $dumpvars;
    $dumpfile("FSM_tb.vcd");
    $monitor("Time = %0t, State = %b, People_Count=%0d, Lights = %0b", 
      $time,dut.current, dut.people_count, Lights); 
    end
endmodule

