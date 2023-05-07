----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:53:26 05/28/2010 
-- Design Name: 
-- Module Name:    mux - Behavioral 
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
use IEEE.numeric_std.all;
use work.funciones.all;

entity mux is
	generic ( WIDTH : natural := 32);
   port(
      input_i  : in std_logic_vector (WIDTH-1 downto 0);
      sel_i    : in std_logic_vector (ceil2power(WIDTH-1)-1 downto 0);
      output_o : out std_logic
   );
end mux;

architecture simple of mux is

begin
	output_o <= input_i(to_integer(unsigned(sel_i)));
	
end simple;