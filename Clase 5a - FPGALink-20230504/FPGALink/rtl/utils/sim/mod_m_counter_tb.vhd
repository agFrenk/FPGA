-- Company:
-- Engineer:
--
-- Create Date:   15:29:06 05/27/2010
-- Design Name:  
-- Module Name:   E:/Laburo/INTI/Xilinx/ISE/TimeInter/mod_m_counter_tb.vhd
-- Project Name:  TimeInter
-- Target Device: 
-- Tool versions: 
-- Description:  
-- 
-- VHDL Test Bench Created by ISE for module: mod_m_counter
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
library comun;
USE ieee.std_logic_1164.ALL;
use comun.funciones.all;

ENTITY mod_m_counter_tb IS
END mod_m_counter_tb;
 
ARCHITECTURE behavior OF mod_m_counter_tb IS

     constant M : natural := 6;
 
    -- Component Declaration for the Unit Under Test (UUT)
 
   COMPONENT mod_m_counter
   generic	( 
				M : natural
				);   
   port  ( 
			clk      : in  STD_LOGIC;
         reset    : in  STD_LOGIC;
         pause_n	: in STD_LOGIC;
         q        : out  STD_LOGIC_VECTOR (ceil2power(M)-1 downto 0)
			);
   END COMPONENT;
   
   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
	signal pause_n: std_logic := '1';

     --Outputs
   signal q : std_logic_vector(ceil2power(M)-1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 1 us;
 
BEGIN
 
    -- Instantiate the Unit Under Test (UUT)
   uut: mod_m_counter
    GENERIC MAP( M => M)
    PORT MAP (
          clk 		=> clk,
          reset 	=> reset,
			 pause_n => pause_n,
          q 		=> q
        );

   -- Clock process definitions
   clk_process :process
   begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
   end process;
 
    reset 	<= '1', '0' after 5 us;
    pause_n <= '1', '0' after 20 us, '1' after 30 us;
END;