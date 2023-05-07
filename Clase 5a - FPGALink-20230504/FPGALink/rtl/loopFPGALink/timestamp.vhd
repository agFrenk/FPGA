----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.funciones.all;

entity timestamp is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           din : in  STD_LOGIC_VECTOR (31 downto 0);
           dout : out  STD_LOGIC_VECTOR (31 downto 0);
           en : in  STD_LOGIC;
           dv : out  STD_LOGIC);
end timestamp;

architecture Behavioral of timestamp is

component mod_m_counter is

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
                 
end component;

signal time_count_low: std_logic_vector(15 downto 0);
signal time_count_high: std_logic_vector(15 downto 0);
signal start	  : std_logic;
signal max_low   : std_logic; 

begin

time_counter_low: mod_m_counter

   generic map( 
		M => 2**16
		)
   port map ( 
		clk			=> clk,
      rst			=> rst,
      en 			=> start,
		max_count	=> std_logic_vector(to_unsigned(2**16 -1, 16)),
		max			=> max_low,
		count 		=> time_count_low
		);

time_counter_high: mod_m_counter

   generic map( 
		M => 2**16
		)
   port map ( 
		clk			=> clk,
      rst			=> rst,
      en 			=> max_low,
		max_count	=> std_logic_vector(to_unsigned(2**16 -1, 16)),
		max			=> open,
		count 		=> time_count_high
		);
		

	-- loop
   dout <= time_count_high & time_count_low;
	dv   <= en;
	
	-- Se dispara con el primer paquete, luego mantiene
	start_counting: process(clk)
	begin
		if(clk = '1' and clk'event) then
			if(rst = '1') then
				start <= '0';
			elsif(en = '1') then
				start <= '1';
			end if;
		end if;
	end process;


end Behavioral;

