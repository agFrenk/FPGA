library IEEE;
library utils;
use IEEE.std_logic_1164.all;

entity dimmer_tb is
end entity;

architecture tb_arch of dimmer_tb is
  constant N : natural := 7;
    -- import the entity to be tested
    component dimmer is
        generic(N:natural);
        port(
            clk_i       : in  std_logic;
            duty_cycle_i  : in std_logic_vector(N-1 downto 0);
            led_o         : out std_logic
        );
    end component;
    
    -- signals to connect to the entity under test

    --Inputs
    signal clk     : std_logic := '0';
    signal duty_cycle : std_logic_vector(3 downto 0) := "0010";
    --Outputs
    signal led_out    : std_logic;

  -- Clock period definitions
  constant clk_period : time := 1 us;

begin
    -- instantiate the entity under test
    uut: dimmer
    generic map(N => 4)
    port map(
        clk_i        => clk,
        duty_cycle_i => duty_cycle,
        led_o => led_out
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
