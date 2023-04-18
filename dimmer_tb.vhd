library IEEE;
use IEEE.std_logic_1164.all;

entity dimmer_tb is
end entity;

architecture tb_arch of dimmer_tb is
    -- import the entity to be tested
    component dimmer is
        generic(N:natural := 7);
        port(
            duty_cycle_i  : in std_logic_vector(N-1 downto 0);
            led_o         : out std_logic
        );
    end component;
    
    -- signals to connect to the entity under test
    signal duty_cycle : std_logic_vector(3 downto 0) := "0011";
    signal led_out    : std_logic;

begin
    -- instantiate the entity under test
    uut: dimmer
    generic map(N => 4)
    port map(
        duty_cycle_i => duty_cycle,
        led_o => led_out
    );

    -- process to generate the clock signal
    process
    begin
        
        wait;
    end process;
        
end architecture;