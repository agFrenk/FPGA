--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:14:45 06/01/2010
-- Design Name:   
-- Module Name:   D:/Marcos/work/Xilinx/ISE/comun/mux_tb.vhd
-- Project Name:  TI
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mux
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.funciones.all;
 
USE ieee.numeric_std.ALL;
 
entity mux_tb is
end mux_tb;
 
architecture behavior of mux_tb is 
 
    -- component declaration for the unit under test (uut)
	 constant WIDTH : natural := 16;
 
    --Inputs
   signal input_i : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
   signal sel_i   : std_logic_vector(ceil2power(WIDTH)-1 downto 0) := (others => '0');

 	--Outputs
   signal output_o : std_logic;

begin 
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.mux(simple) 
	generic map (WIDTH => WIDTH)
	port map (
          input_i => input_i,
          sel_i => sel_i,
          output_o => output_o
        );
		  
input_i <=	"0101011101010011";

	process
	begin
		for i in 0 to WIDTH-1 loop
			sel_i <= std_logic_vector(to_signed(i,ceil2power(WIDTH)));
         wait for 60 us;
		end loop;
		
	end process;

END;
