----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:56:30 06/25/2010 
-- Design Name: 
-- Module Name:    delay_M - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity delay_M is
	 generic ( WORD_WIDTH: natural;
				  DELAY 		: natural);
    Port ( clk : in std_logic;
			  rst: in std_logic;	
			  s : in  STD_LOGIC_VECTOR (WORD_WIDTH - 1 downto 0);
           s_delayed : out  STD_LOGIC_VECTOR (WORD_WIDTH - 1 downto 0));
end delay_M;

architecture Behavioral of delay_M is

	type array_of_stdlv is
	array (DELAY downto 0) of std_logic_vector(WORD_WIDTH-1 downto 0);

	signal tmp : array_of_stdlv;
	
	component delay_1 is
    	generic ( WORD_WIDTH: natural);
		port ( clk : in std_logic;
			  rst: in std_logic;	
			  s : in  STD_LOGIC_VECTOR (WORD_WIDTH - 1 downto 0);
           s_delayed : out  STD_LOGIC_VECTOR (WORD_WIDTH - 1 downto 0)
		);
	end component;

begin
	
tmp(0) <= s;	
	
delay_gen:
for i in 1 to DELAY generate
	
	dly_gen: delay_1
		generic map( WORD_WIDTH => WORD_WIDTH)
		port map( clk 	 => clk,
					 rst => rst,
					 s => tmp(i-1),
					 s_delayed => tmp(i)
					);
end generate;

s_delayed <= tmp(DELAY); 

end Behavioral;

