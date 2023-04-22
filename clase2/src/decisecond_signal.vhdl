library ieee;
library utils;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity digit is
    generic(
        N:natural := 4
    );
    port(
        clk_i           : in std_logic;
        reset_i          : in std_logic;
        decisecond_o    : out std_logic;
    );
end entity;

architecture digit_architecture of digit is
    signal decisecond_out_s        : std_logic := '0';
    signal clock_counter : natural := 1;
begin

    process(clk_i, reset_i)
    begin
        if (clk_i'event and clk_i = '1') then
            if (clock_counter = 100001) then
                clock_counter <= 1;
                decisecond_o <= '1';
            else
                clock_counter <= clock_counter + 1;
                decisecond_o <= '0';
            end if;
            if (reset_i'event and reset_i = 1) then
                clock_counter <= 1;
            end if;
        end if;
    end process;
    
end architecture;
