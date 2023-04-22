library IEEE;
library utils;
use IEEE.std_logic_1164.all;

entity stopwatch_tb is
end entity;

architecture tb_arch of stopwatch_tb is
  constant M : natural := 4;
    -- import the entity to be tested
    component stopwatch is
        generic(M:natural);
        port(
            clk_i           : in std_logic;
            reset_i          : in std_logic;
            stpwatch_o           : out std_logic_vector(11 downto 0) 
        );
    end component;
    
    -- signals to connect to the entity under test

    --Inputs
    signal clk     : std_logic := '0';
    signal reset_i :  std_logic := '0';
    --Outputs
    signal stpwatch_o : std_logic_vector(12-1 downto 0);

  -- Clock period definitions
  constant clk_period : time := 1 us;

begin
    -- instantiate the entity under test
    uut: stopwatch
    generic map(M => 4)
    port map(
        clk_i => clk,
        reset_i => reset_i,
        stpwatch_o => stpwatch_o
    );

    -- Clock process definitions
    clk_process : process
    begin
      clk <= '1';
      wait for clk_period/2;
      clk <= '0';
      wait for clk_period/2;
    end process;
        
end architecture;
