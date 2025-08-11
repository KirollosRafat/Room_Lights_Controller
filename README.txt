## Overview
This project implements a Finite State Machine (FSM) to control the lights of a meeting room based on occupancy detected via two infrared (IR) sensors at the door.

## How it works
- The room has two IR sensors positioned at the entrance.

- When a person enters the room, the sensors detect a sequence 10 (sensor 1 triggers, then sensor 2).

- When a person leaves the room, the sensors detect a sequence 01 (sensor 2 triggers, then sensor 1).

- The FSM monitors these sequences on a single input (seq_in) and increments or decrements a people counter accordingly.

- The Lights output turns ON when there is at least one person inside (people count > 0), and OFF when the room is empty.

- The system limits the maximum occupancy to a configurable capacity (default: 8). 

## Files
- Room_Lights_FSM.sv: The main SystemVerilog module implementing the FSM and people counter logic. Parameterized by room capacity.

- tb_Room_Lights_FSM.sv: Testbench that simulates people entering and exiting by generating appropriate seq_in sequences.


## Design Highlights
- FSM-based sequence detection: Detects entry/exit sequences 10 and 01.

- Synchronous counter update: Maintains an accurate count of people inside.

- Lights control: Automatically turns lights ON/OFF based on occupancy.

- Reset functionality: Resets FSM and counter asynchronously.

- Modular and parameterized for easy adaptation. 