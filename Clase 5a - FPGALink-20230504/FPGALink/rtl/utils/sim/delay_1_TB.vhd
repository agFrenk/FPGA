--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:21:53 06/25/2010
-- Design Name:   
-- Module Name:   D:/Marcos/work/Xilinx/ISE/comun/delay_1_TB.vhd
-- Project Name:  CTI
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: delay_1
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY delay_1_TB IS
END delay_1_TB;
 
ARCHITECTURE behavior OF delay_1_TB IS 
 
    constant WORD_WIDTH : natural := 8;
	 
    COMPONENT delay_1
	 generic ( WORD_WIDTH: natural);
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         s : IN  std_logic_vector(WORD_WIDTH-1 downto 0);
         s_delayed : OUT  std_logic_vector(WORD_WIDTH-1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic ;
   signal reset : std_logic ;
   signal s : std_logic_vector(WORD_WIDTH-1 downto 0);

 	--Outputs
   signal s_delayed : std_logic_vector(WORD_WIDTH-1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: delay_1 
	generic map (WORD_WIDTH => WORD_WIDTH)
	PORT MAP (
          clk => clk,
          reset => reset,
          s => s,
          s_delayed => s_delayed
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
   end process;
 
	reset <= '1', '0' after 50 ns;
	s <= "10001111",
		  "10010101" after 100 ns,
		  "00100111" after 150 ns;

END;
