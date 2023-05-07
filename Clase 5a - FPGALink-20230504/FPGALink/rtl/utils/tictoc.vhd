----------------------------------------------------------------------------------
-- Unidad tictoc
--
-- Esta unidad genera un pulso toc (presumiblemente mas largo) a partir de un 
-- pulso tic. Es posible especificar la duracion del pulso toc en ambos estados.
-- Si se especifican dos duraciones en tocup y tocdown != 0, por cada pulso tic,
-- se generar un pulso toc de las duraciones correspondientes y luego se vuelve 
-- al estado inicial.

-- Los pulsos tic son inhibidos durante la realizacion del toc

-- La duracion de los pulsos se especifica en ticks de clk

----------------------------------------------------------------------------------
library IEEE;
library comun;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use comun.funciones.all;

entity tictoc is
    generic( TOC_MAX : natural);
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           tocup : in  std_logic_vector (ceil2power(TOC_MAX) - 1 downto 0);
           tocdown : in  STD_LOGIC_VECTOR (ceil2power(TOC_MAX) - 1 downto 0);
           tic : in  STD_LOGIC;
           toc : out  STD_LOGIC
			  );
end tictoc;

architecture Behavioral of tictoc is

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

type state is (WAIT_FOR_TIC,
					TOC_UP,
					TOC_DOWN
					);

signal state_reg, state_next: state;

signal tocup_en : std_logic;
signal tocup_expire : std_logic;
signal tocup_maxcount : std_logic_vector(ceil2power(TOC_MAX) -1 downto 0);

signal tocdown_en : std_logic;
signal tocdown_expire : std_logic;

begin

-- state register			
process(clk)
begin
	if(clk = '1' and clk'event) then
		if(rst = '1') then
			state_reg <= WAIT_FOR_TIC;
		else
			state_reg <= state_next;
		end if;
	end if;
end process;

-- next state logic

process(state_reg, tic, tocup_expire, tocdown_expire)
begin
	
	case state_reg is
	
		when WAIT_FOR_TIC =>
		
			if(tic = '1') then
				state_next <= TOC_UP;
			else
				state_next <= WAIT_FOR_TIC;
			end if;
			
		when TOC_UP =>
			
			-- ya termino el tocup?
			if(tocup_expire = '1') then
				state_next <= TOC_DOWN;
			else
				state_next <= TOC_UP;
			end if;
			
		when TOC_DOWN     =>
					
			if(tocdown_expire = '1') then
				state_next <= WAIT_FOR_TIC;
			else
				state_next <= TOC_DOWN;
			end if;
			
	end case;

end process;

--output logic

process(state_reg, tic, tocup_expire, tocdown_expire)
begin


	toc 		  <= '0';
	tocdown_en <= '0';
	tocup_en   <= '0';
	
	case state_reg is
	
		when WAIT_FOR_TIC =>
			
			if(tic = '1') then
				toc        <= '1';
			end if;
			
		when TOC_UP =>
			
			tocup_en <= '1';
			toc <= '1';
						
		when TOC_DOWN     =>
		
			tocdown_en <= '1';
			
	end case;

end process;

tocup_counter: mod_m_counter
generic map(
	M => TOC_MAX
)
port map(
	clk	=> clk,
	rst   => rst,
	en    => tocup_en,
	max_count => tocup_maxcount,
	max       => tocup_expire,
	count     => open
);

tocup_maxcount <= decrement(tocup,2);

tocdown_counter: mod_m_counter
generic map(
	M => TOC_MAX
)
port map(
	clk	=> clk,
	rst   => rst,
	en    => tocdown_en,
	max_count => decrement(tocdown),
	max       => tocdown_expire,
	count     => open
);


end Behavioral;

