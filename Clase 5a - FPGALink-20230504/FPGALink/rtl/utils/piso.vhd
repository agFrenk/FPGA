----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:28:55 07/19/2010 
-- Design Name: 
-- Module Name:    piso - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity piso is
	 generic (WORD_WIDTH: natural;
				 PARALLEL_WIDTH: natural);
    port ( p_in : in  std_logic_vector (PARALLEL_WIDTH*WORD_WIDTH-1 downto 0);
           s_out : out  std_logic_vector(WORD_WIDTH-1 downto 0);
           rst : in  std_logic;
           clk : in  std_logic;
           write_en : in  std_logic);
end piso;

architecture Behavioral of piso is

	signal tmp : std_logic_vector (PARALLEL_WIDTH*WORD_WIDTH-1 downto 0);

begin	
	
process(clk,rst)	
begin
	if rst = '1' then
		tmp <= (others=>'0');
	elsif clk'event and clk='1' then
		if write_en = '1' then
			tmp <= p_in;
		else	
			tmp(PARALLEL_WIDTH*WORD_WIDTH-1 downto WORD_WIDTH) <= tmp( (PARALLEL_WIDTH-1)*WORD_WIDTH-1 downto 0);
		end if;	
	end if;	
end process;


s_out <= tmp(PARALLEL_WIDTH*WORD_WIDTH-1 downto (PARALLEL_WIDTH-1)*WORD_WIDTH);


end Behavioral;

