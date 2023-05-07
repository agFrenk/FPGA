----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:49:50 07/16/2010 
-- Design Name: 
-- Module Name:    counter_2D - Behavioral 
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
use work.funciones.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter_2D is
	 generic ( MOD_I_MAX: natural;
				  MOD_J_MAX: natural);
    Port ( clk 		: in  std_logic;
           rst 		: in  std_logic;
           run 		: in  std_logic;
           count_i 	: out  std_logic_vector(ceil2power(MOD_I_MAX-1)-1 downto 0);
           count_j 	: out  std_logic_vector(ceil2power(MOD_J_MAX-1)-1 downto 0);
           cycle 		: out  std_logic;
           modulus_i : in  std_logic_vector(ceil2power(MOD_I_MAX-1)-1 downto 0);
           modulus_j : in std_logic_vector(ceil2power(MOD_J_MAX-1)-1 downto 0)
			 );
end counter_2D;

architecture behavioral of counter_2D is
   signal i_reg	: unsigned(ceil2power(MOD_I_MAX-1)-1 downto 0);
   signal i_next	: unsigned(ceil2power(MOD_I_MAX-1)-1 downto 0);
   signal j_reg   : unsigned(ceil2power(MOD_J_MAX-1)-1 downto 0);
	signal j_next	: unsigned(ceil2power(MOD_J_MAX-1)-1 downto 0);
	
begin
   -- register
   process(clk,rst)
   begin
      if (rst='1') then
         i_reg <= (others=>'0');
         j_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
			if run = '1' then
				i_reg <= i_next;
				j_reg <= j_next;
			end if;
      end if;
   end process;
   
   i_next <= (others=>'0') when  i_reg = (unsigned(modulus_i) - 1) else
             i_reg + 1;
   
	j_next <= (others=>'0') when (j_reg = (unsigned(modulus_j) - 1) and i_reg = (unsigned(modulus_i) - 1)) else
             j_reg + 1     when i_reg = (unsigned(modulus_i) - 1) else
             j_reg;
	
	
   cycle <= '1' when (j_reg = (unsigned(modulus_j) - 1) and i_reg = (unsigned(modulus_i) - 1) and run = '1')  else
           '0';
			  
   count_i <= std_logic_vector(i_reg);
   count_j <= std_logic_vector(j_reg);
	
end behavioral;
