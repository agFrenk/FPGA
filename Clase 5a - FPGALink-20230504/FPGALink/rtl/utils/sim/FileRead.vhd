----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:18:15 06/09/2010 
-- Design Name: 
-- Module Name:    FileRead - Behavioral 
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
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;
use work.funciones.all;
use work.TXT_UTIL.ALL;

--use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FileRead is
	generic	(
				stim_file: string :="/home/edgardo/FPGA/Modulador ISDB-T/CombHL/datos1.dat";
				size_o	: integer:=16
				);

	Port	(
			data_o : out	std_logic_vector (size_o-1 downto 0);
			en			: std_logic;
         clk_i  : in		std_logic
			);
end FileRead;
	

architecture Behavioral of FileRead is
	file stimulus: TEXT open read_mode is stim_file;
	signal data : std_logic_vector (0 to size_o-1);
begin

data_o <= data;

process(clk_i)
variable l: line;
variable s: string(size_o downto 1);

begin

if en = '1' then
	if rising_edge(clk_i) then
		-- read digital data from input file 
			readline(stimulus, l);
			read(l, s);
			data <= to_std_logic_vector(s);

		--	wait until clk_i = '1';

   end if;
end if;
	
end process;

end Behavioral;
