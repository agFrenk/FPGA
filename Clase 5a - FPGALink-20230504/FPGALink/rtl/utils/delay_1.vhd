----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:13:58 06/25/2010 
-- Design Name: 
-- Module Name:    delay_1 - Behavioral 
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

entity delay_1 is
    	 generic ( WORD_WIDTH: natural);
		Port ( clk : in std_logic;
			  rst: in std_logic;	
			  s : in  STD_LOGIC_VECTOR (WORD_WIDTH - 1 downto 0);
           s_delayed : out  STD_LOGIC_VECTOR (WORD_WIDTH - 1 downto 0));
end delay_1;

architecture Behavioral of delay_1 is

	signal s_next : std_logic_vector(WORD_WIDTH - 1 downto 0);
	signal s_reg : std_logic_vector(WORD_WIDTH - 1 downto 0);

begin

	process(clk,rst)
	begin
		if rst = '1' then
			s_reg <= (others => '0');
		elsif (clk ='1' and clk'event) then
			s_reg <= s_next;
		end if;
	
	
	end process;
	
	s_next <= s;
	s_delayed <= s_reg;
	
	
end Behavioral;

