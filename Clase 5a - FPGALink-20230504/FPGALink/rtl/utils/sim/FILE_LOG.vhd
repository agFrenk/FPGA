----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:26:09 04/29/2010 
-- Design Name: 
-- Module Name:    FILE_LOG - Behavioral 
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
USE IEEE.NUMERIC_STD.ALL; 
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;
USE work.txt_util.all;

--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FILE_LOG is
	generic(
            log_file : string  := "HL_mix.csv";
				size_i	: integer:=16
           );
    Port ( 
			 en			: in std_logic;
			 clk_i      : in std_logic;
			 datos_i		: in STD_LOGIC_VECTOR (size_i-1 downto 0)
			 );
end FILE_LOG;

architecture Behavioral of FILE_LOG is

file l_file: TEXT open write_mode is log_file;

signal datos : integer range 0 to ((2**size_i)-1);

begin
datos <= to_integer( unsigned(datos_i));


process(clk_i)

begin
		--while (true) loop
if en = '1' then
	if rising_edge(clk_i) then
			print(l_file, str(datos));
			--wait until clk_i = '1';
--      end loop;
	end if;
end if;
end process;

end Behavioral;
