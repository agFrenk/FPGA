----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:06:06 07/07/2010 
-- Design Name: 
-- Module Name:    sipo - Behavioral 
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

entity sipo is
	 generic (WORD_WIDTH: natural;
				 PARALLEL_WIDTH: natural);
    port ( s_in 	 : in  std_logic_vector (WORD_WIDTH-1 downto 0);
           p_out 	 : out std_logic_vector (PARALLEL_WIDTH*WORD_WIDTH-1 downto 0);
           clk  	 : in  std_logic;
			  rst 	 : in  std_logic; 
           read_en : in  std_logic);
end sipo;

architecture Behavioral of sipo is

	type array_of_stdlv is
	array (PARALLEL_WIDTH downto 0) of std_logic_vector(WORD_WIDTH-1 downto 0);

	signal tmp : array_of_stdlv;
	signal p_out_next :  std_logic_vector (PARALLEL_WIDTH*WORD_WIDTH-1 downto 0);
	signal p_out_reg :  std_logic_vector (PARALLEL_WIDTH*WORD_WIDTH-1 downto 0);

	
	component delay_1 is
    	generic ( WORD_WIDTH: natural);
		port ( clk 		: in std_logic;
			  rst		: in std_logic;	
			  s 			: in  std_logic_vector (WORD_WIDTH - 1 downto 0);
           s_delayed : out  STD_LOGIC_VECTOR (WORD_WIDTH - 1 downto 0)
		);
	end component;

begin
	
tmp(0) <= s_in;	
	
delay_gen:
for i in 1 to PARALLEL_WIDTH generate
	
	dly_gen: delay_1
		generic map( WORD_WIDTH => WORD_WIDTH)
		port map( clk 	 => clk,
					 rst => rst,
					 s => tmp(i-1),
					 s_delayed => tmp(i)
					);
		p_out_next((i)*WORD_WIDTH-1 downto (i-1)*WORD_WIDTH) <= tmp(i-1);	
		
end generate;

process(clk,rst)
begin
	if (rst = '1') then
		p_out_reg <= (others => '0');
	elsif (clk'event and clk = '1') then
		if read_en = '1' then
			p_out_reg <= p_out_next;
		end if;
	end if;
end process;

p_out <= p_out_reg;

end Behavioral;

