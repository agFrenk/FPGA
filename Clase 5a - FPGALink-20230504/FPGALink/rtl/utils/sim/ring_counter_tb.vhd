--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:09:15 06/03/2010
-- Design Name:   
-- Module Name:   D:/Marcos/work/Xilinx/ISE/comun/ring_counter_tb.vhd
-- Project Name:  TI
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ring_counter
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity ring_counter_tb is
end ring_counter_tb;
 
architecture behavior of ring_counter_tb is 
 
    -- component declaration for the unit under test (uut)
	 constant WIDTH: natural := 10;
 
    component ring_counter
	 generic ( WIDTH : natural := 8); 	
    port(
         clk_i : in  std_logic;
         reset_i : in  std_logic;
         enable_i : in  std_logic;
         output_o : out  std_logic_vector(WIDTH-1 downto 0)
        );
    end component;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal reset_i : std_logic := '0';
   signal enable_i : std_logic := '0';

 	--Outputs
   signal output_o : std_logic_vector(WIDTH - 1 downto 0);

   -- Clock period definitions
   constant clk_i_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ring_counter 
	generic map ( WIDTH => WIDTH)
	PORT MAP (
          clk_i => clk_i,
          reset_i => reset_i,
          enable_i => enable_i,
          output_o => output_o
        );

   -- Clock process definitions
   clk_i_process :process
   begin
		clk_i <= '0';
		wait for clk_i_period/2;
		clk_i <= '1';
		wait for clk_i_period/2;
   end process;
 
	reset_i  <= '1', '0' after 40 ns;
	enable_i <= '0', '1' after 95 ns;
   

END;
