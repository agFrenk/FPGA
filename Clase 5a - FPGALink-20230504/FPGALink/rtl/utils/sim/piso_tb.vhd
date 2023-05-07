--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:25:12 07/20/2010
-- Design Name:   
-- Module Name:   D:/Marcos/work/Xilinx/ISE/TI/piso_tb.vhd
-- Project Name:  TI
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: piso
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
 
ENTITY piso_tb IS
END piso_tb;
 
ARCHITECTURE behavior OF piso_tb IS 

	 constant WORD_WIDTH		: natural  := 4;
	 constant PARALLEL_WIDTH: natural  := 4;
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component piso
    	 generic (WORD_WIDTH    : natural;
				    PARALLEL_WIDTH: natural);
		 port ( 
			  p_in  : in  std_logic_vector (PARALLEL_WIDTH*WORD_WIDTH-1 downto 0);
           s_out : out  std_logic_vector(WORD_WIDTH-1 downto 0);
           rst   : in  std_logic;
           clk   : in  std_logic;
           write_en : in  std_logic);
    end component;
    

   --Inputs
   signal p_in : std_logic_vector(PARALLEL_WIDTH*WORD_WIDTH-1 downto 0) := (others => '0');
   signal rst : std_logic ;
   signal clk : std_logic ;
   signal write_en : std_logic ;

 	--Outputs
   signal s_out : std_logic_vector(WORD_WIDTH-1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 1 ns;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
   uut: piso generic map(
			 WORD_WIDTH      => WORD_WIDTH,
			 PARALLEL_WIDTH  => PARALLEL_WIDTH)	
	port map (
          p_in 	 => p_in,
          s_out 	 => s_out,
          rst 		 => rst,
          clk 		 => clk,
          write_en => write_en
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
   end process;
 
	rst <= '1', '0' after 5 ns;
	write_en <= '0', '1' after 8 ns
						, '0' after 9 ns
						, '1' after 12 ns
						, '0' after 13 ns
						, '1' after 16 ns
						, '0' after 17 ns
						, '1' after 20 ns
						, '0' after 21 ns
						, '1' after 24 ns
						, '0' after 25 ns
						, '1' after 28 ns
						, '0' after 29 ns
						, '1' after 32 ns
						, '0' after 33 ns
						, '1' after 36 ns
						, '0' after 37 ns
						, '1' after 40 ns
						, '0' after 41 ns;
	
	p_in <= x"0000", x"1234" after 8 ns
						, x"5678" after 12 ns
						, x"9ABC" after 16 ns
						, x"DEF0" after 20 ns
						, x"7623" after 24 ns
						, x"3561" after 28 ns
						, x"B425" after 32 ns
						, x"A564" after 36 ns
						, x"0943" after 40 ns;
end;
