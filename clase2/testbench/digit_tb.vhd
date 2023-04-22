library IEEE;
library utils;
use IEEE.std_logic_1164.all;

entity digit_tb is
end entity;

architecture tb_arch of digit_tb is
  constant N : natural := 4;
    -- import the entity to be tested
    component digit is
        generic(N:natural);
        port(
            clk_i           : in std_logic;
            reset_i          : in std_logic;
            carry_i         : in std_logic;
            carry_o         : out std_logic;
            clr_o           : out std_logic_vector(N-1 downto 0) 
        );
    end component;
    
    -- signals to connect to the entity under test

    --Inputs
    signal carry_i : std_logic := '0';   
    signal clk     : std_logic := '0';
    signal reset_i :  std_logic := '0';
    --Outputs
    signal carry_o: std_logic;
    signal clr_o : std_logic_vector(N-1 downto 0) := (others => '0');

  -- Clock period definitions
  constant clk_period : time := 1 us;

begin
    -- instantiate the entity under test
    uut: digit
    generic map(N => 4)
    port map(
        clk_i => clk,
        reset_i => reset_i,
        carry_i => carry_i,
        carry_o => carry_o,
        clr_o => clr_o

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
