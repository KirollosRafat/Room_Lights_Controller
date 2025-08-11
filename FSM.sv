
module Room_Lights_FSM #(parameter CAPACITY = 8) // Assuming an eight-people meeting room
(
input logic clk,
input logic reset,
input logic seq_in, // input sequence from infra-red sensors
output logic Lights // Output lights of the meeting room
);

// Internal Counter to monitor the number of people inside the room 
logic up,down;
logic [$clog2(CAPACITY):0] people_count; // extra bit to account for the total CAPACITY

// State Encoding
typedef enum logic [2:0]{
	A = 3'b000, 
	B = 3'b001, 
	C = 3'b010, 
	D = 3'b011,
	E = 3'b100
}state_; 
state_ current, next;

// Current state logic
always_ff@(posedge clk, posedge reset) // Asynchronous Active High reset signal
begin
	if(reset) begin current <= A; end
	else begin 
	current <= next;
	end
end

// Next state logic
always_comb
begin
	case(current)
	A: next = (seq_in == 1'b1) ? B : A; 
	
	B: next = (seq_in == 1'b1) ? B : C;

	C: next = (seq_in == 1'b1) ? B : D;
	
	D: next = (seq_in == 1'b1) ? E : D;
	
	E: next = (seq_in == 1'b1) ? B : D;
	endcase
end


// Counter logic (Mealy FSM style)
always_comb
begin
	if(reset) people_count = {($clog2(CAPACITY) + 1){1'b0}}; 
	else 
	begin
	case(current)
	B: if(seq_in && (people_count != CAPACITY)) people_count = people_count + 1;
	   else people_count = people_count;

	D: if(~seq_in && (people_count != '0)) people_count = people_count - 1;
	   else people_count = people_count;

	default: people_count = people_count;
	endcase
	end
end

// Continously Update Lights depending on counter value (Number of people inside the room)
assign Lights = (people_count > 0) ? 1'b1 : 1'b0; 

endmodule