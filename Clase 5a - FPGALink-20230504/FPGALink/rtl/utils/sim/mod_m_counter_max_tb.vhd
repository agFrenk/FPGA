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
USE ieee.std_logic_1164.all;
use work.funciones.all;

entity mod_m_counter_max_tb is
end mod_m_counter_max_tb;
 
architecture behavior of mod_m_counter_max_tb is

     constant M : natural := 9;
 
    -- Component Declaration for the Unit Under Test (UUT)
 
   component mod_m_counter_max
   generic	( 
				M : natural
				);   
   port  ( 
			clk_i			: in std_logic;
         reset_i		: in std_logic;
         run_i			: in std_logic;
			max_count_i : in std_logic_vector (ceil2power(M)-1 downto 0);
         count_o		: out std_logic_vector (ceil2power(M)-1 downto 0)
			);
   end component;
   
   --Inputs
   signal clk_i		: std_logic := '0';
   signal reset_i		: std_logic := '0';
	signal run_i		: std_logic := '1';
	signal max_count_i: std_logic_vector (ceil2power(M)-1 downto 0):=(others =>'0');
     --Outputs
   signal count_o	: std_logic_vector (ceil2power(M)-1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 1 us;
 
begin
 
    -- Instantiate the Unit Under Test (UUT)
   uut: mod_m_counter_max
    generic map(M => M)
    port map (
          clk_i 		=> clk_i,
          reset_i		=> reset_i,
			 run_i		=> run_i,
			 max_count_i=> max_count_i,
          count_o		=> count_o
        );

   -- Clock process definitions
   clk_process :process
   begin
        clk_i <= '0';
        wait for clk_period/2;
        clk_i <= '1';
        wait for clk_period/2;
   end process;
 
    reset_i			<= '1', '0' after 5 us;
    run_i			<= '1', '0' after 20 us, '1' after 30 us;
	 max_count_i	<= x"8" after 40 us;
END;