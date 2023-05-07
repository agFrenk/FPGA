----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:43:42 06/03/2010 
-- Design Name: 
-- Module Name:    ring_counter - Behavioral 
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ring_counter is
	 generic ( WIDTH : natural := 8); 	
    Port ( clk_i    : in std_logic;
			  reset_i  : in std_logic;
			  enable_i : in std_logic;
           output_o : out  std_logic_vector (WIDTH-1 downto 0)
			 );
end ring_counter;

architecture Behavioral of ring_counter is

	signal r_reg : std_logic_vector (WIDTH - 1 downto 0);
	signal r_next: std_logic_vector (WIDTH - 1 downto 0);

begin

	process(clk_i, reset_i)
	begin
		if (reset_i = '1') then
			r_reg <= (0 => '1', others => '0');
		elsif (clk_i'event and clk_i = '0') then
			if enable_i = '1' then
				r_reg <= r_next;
			end if;
		end if;
	end process;

	r_next <= r_reg(0) & r_reg(WIDTH - 1 downto 1);

	output_o(0) <= enable_i and r_reg(0);
	output_o(WIDTH-1 downto 1) <= r_reg(WIDTH - 1 downto 1);

end Behavioral;

