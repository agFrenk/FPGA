--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use work.funciones.all;
 
ENTITY tictoc_tb IS
END tictoc_tb;
 
ARCHITECTURE behavior OF tictoc_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
component tictoc is
    generic( TOC_MAX : natural);
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           tocup : in  std_logic_vector (ceil2power(TOC_MAX) - 1 downto 0);
           tocdown : in  STD_LOGIC_VECTOR (ceil2power(TOC_MAX) - 1 downto 0);
           tic : in  STD_LOGIC;
           toc : out  STD_LOGIC
			  );
end component;
    
	constant TOC_MAX : natural := 48;
   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal tic : std_logic := '0';

 	--Outputs
   signal toc : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20.833 ns; -- 100 Mhz
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: tictoc 
	generic map(TOC_MAX => TOC_MAX)
	PORT MAP (
          clk => clk,
          rst => rst,
          tocup => std_logic_vector(to_unsigned( TOC_MAX /2, ceil2power(TOC_MAX))),
          tocdown => std_logic_vector(to_unsigned( TOC_MAX /2, ceil2power(TOC_MAX))),
          tic => tic,
          toc => toc
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst <= '1';
      wait for clk_period*10 + 1 ps;
		rst <= '0';
		wait for clk_period*10;
		tic <= '1';
		
		wait for clk_period*150;
		tic <= '0';
		
		wait for clk_period*200;
		tic <= '1';
		wait for clk_period;
		tic <= '0';

		
      -- insert stimulus here 

      wait;
   end process;

END;
