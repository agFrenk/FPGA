----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:26:44 06/02/2010 
-- Design Name: 
-- Module Name:    word_mux - Structural 
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
use work.funciones.all;
use work.tipos.all;
use IEEE.NUMERIC_STD.ALL;

entity word_mux is
	generic (WORD_WIDTH : natural := 16;
				MUX_WIDTH  : natural := 32);
	port( 	
		input_i : in std_logic_2d( MUX_WIDTH-1 downto 0, WORD_WIDTH-1 downto 0);
		sel_i	  : in std_logic_vector(ceil2power(MUX_WIDTH-1)-1 downto 0);	
		output_o: out std_logic_vector(WORD_WIDTH - 1 downto 0)
		);
end word_mux;

architecture Structural of word_mux is

type array_of_stdlv is
	array (WORD_WIDTH-1 downto 0) of std_logic_vector(MUX_WIDTH-1 downto 0);
	
	
signal aa: array_of_stdlv;	
signal output_s: std_logic_vector(WORD_WIDTH - 1 downto 0);

	component mux is
		generic ( WIDTH : natural := 32);
		port(
			input_i  : in std_logic_vector (WIDTH-1 downto 0);
			sel_i    : in std_logic_vector (ceil2power(WIDTH-1)-1 downto 0);
			output_o : out std_logic
		);
	end component;

begin

	process(input_i)
	begin
	   for i in 0 to WORD_WIDTH - 1 loop
			for j in 0 to MUX_WIDTH - 1 loop
				aa(i)(j) <= input_i(j,i);
			end loop;
		end loop;
   end process;		

mux_gen: 
   
	for i in WORD_WIDTH-1 downto 0 generate
	
	mux_i: mux 
			generic map(WIDTH  => MUX_WIDTH)
			port map (input_i  => aa(i),
						 sel_i 	 => sel_i,
						 output_o => output_s(i)
                   );
	end generate;
	
	output_o <= output_s;	


end Structural;

