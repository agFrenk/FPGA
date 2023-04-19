library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity dimmer is
  generic(
    N:natural
    );
  port(
    clk_i         : in std_logic;
    duty_cycle_i  : in std_logic_vector(N-1 downto 0);
    led_o         : out std_logic
    );
end entity;

architecture dimmer_architecture of dimmer is
    signal seconds_passed_int            :   signed(N downto 0) := to_signed(0, N+1);
    signal duty_cicle_int                :   signed(N downto 0) := signed('0' & duty_cycle_i);
    signal led_intermediate              :   std_logic := '0';
begin
    process
        begin
        if seconds_passed_int <= duty_cicle_int then
            led_intermediate <= '1';
        else
            led_intermediate <= '0';
        end if;
        
        seconds_passed_int <= seconds_passed_int + 1;
        -- if seconds_passed_int =(2**N)-1 then
        --     seconds_passed_int <= to_signed(0, N+1);
        -- end if;
        wait for 1 sec;
    end process;

    led_o <= led_intermediate;

end architecture;
