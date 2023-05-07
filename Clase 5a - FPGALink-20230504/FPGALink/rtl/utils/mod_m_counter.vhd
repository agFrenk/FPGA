----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:18:05 05/28/2010 
-- Design Name: 
-- Module Name:    mod_m_counter - Behavioral 
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
library comun;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use comun.FUNCIONES.ALL;

entity mod_m_counter is

   generic( 
		M : natural
		);   
   port  ( 
		clk			: in std_logic;
      rst			: in std_logic;
      en 			: in std_logic;
		max_count	: in std_logic_vector (ceil2power(M-1) -1 downto 0);
		max			: out std_logic;
		count 		: out std_logic_vector (ceil2power(M-1) -1 downto 0)
		);
                 
end mod_m_counter;

architecture Behavioral of mod_m_counter is
   
	signal r_reg		 : unsigned(ceil2power(M-1)-1 downto 0);
	signal r_next		 : unsigned(ceil2power(M-1)-1 downto 0);

begin

	process(clk)
	begin
		if (clk'event and clk ='1') then
		   if (rst = '1') then
			  r_reg <= (others => '0');
		   else	
			  r_reg <= r_next;
           end if;
		end if;
	end process;

	r_next <= (others => '0')	when r_reg = unsigned(max_count) else
						r_reg   when en = '0' else
						r_reg + 1;
	
	max     <= '1' when r_reg = unsigned(max_count) and en = '1' else
			   '0';

	count <= std_logic_vector(r_reg);

end Behavioral;
