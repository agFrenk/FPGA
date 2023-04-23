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
        carry_i         : in std_logic;
        reset_i          : in std_logic;
        carry_o         : out std_logic;
        clr_o           : out std_logic_vector(N-1 downto 0) 
    );
end entity;

architecture digit_architecture of digit is
    signal carry_out_s        : std_logic := '0';
    signal acumulator    : unsigned(N-1 downto 0) := to_unsigned(0, N);
begin

    process(clk_i, reset_i, carry_i)
    begin
        if (clk_i'event and clk_i = '1') then
            if(reset_i = '1') then
              carry_out_s <= '0';
              acumulator <= (others => '0');
            else
                if(carry_i = '1') then
                    if(acumulator = to_unsigned(9, N)) then
                            acumulator <= (others => '0');
                            carry_out_s <= '1';
                    else
                        acumulator <= acumulator + 1;
                    end if;
                else
                    carry_out_s <= '0';
                end if;
            end if;
        end if;
    end process;
    
    carry_o <= carry_out_s;
    clr_o <= std_logic_vector(acumulator);
end architecture;
