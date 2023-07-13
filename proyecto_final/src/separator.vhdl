library IEEE;
library utils;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use utils.funciones.all;

entity separator is
  generic (
    WIDTH_INPUT : integer := 256;
    WIDTH_ENCODER : integer := 256 / 4
  );
  port (
    clk : in std_logic;
    rst_i : in std_logic;
    separator_in : in std_logic_vector(WIDTH_INPUT - 1 downto 0); -- input del separator
    separated1_o : out std_logic_vector(WIDTH_ENCODER - 1 downto 0); -- salida
                                                                     -- a
                                                                     -- primer encoder
    separated2_o : out std_logic_vector(WIDTH_ENCODER - 1 downto 0); -- salida
                                                                     -- a
                                                                     -- segundo encoder
    separated3_o : out std_logic_vector(WIDTH_ENCODER - 1 downto 0); -- salida
                                                                     -- a
                                                                     -- tercer encoder
    separated4_o : out std_logic_vector(WIDTH_ENCODER - 1 downto 0); -- salida
                                                                     -- a
                                                                     -- cuarto encoder
    ready_i : in std_logic; -- ready de entrada
    ready_o : out std_logic -- ready de salida
);
  end entity separator;

architecture structural of separator is
    signal separated_1 : std_logic_vector(WIDTH_ENCODER - 1 downto 0) := (others => '0'); -- primer
                                                                   -- senial de
                                                                   -- salida
    signal separated_2 : std_logic_vector(WIDTH_ENCODER - 1 downto 0) := (others => '0'); -- segunda
                                                                   -- senial de
                                                                   -- salida
    signal separated_3 : std_logic_vector(WIDTH_ENCODER - 1 downto 0) := (others => '0'); -- tercer
                                                                   -- senial de
                                                                   -- salida
    signal separated_4 : std_logic_vector(WIDTH_ENCODER - 1 downto 0) := (others => '0'); -- cuarta
                                                                   -- senial de
                                                                   -- salida
    signal ready_signal : std_logic := '0';
begin
    process(clk)
    begin
      if (clk'event and clk = '1') then
        if( ready_i = '1' ) then
          -- From 255 to 192
          separated_1 <= (separator_in(WIDTH_INPUT - 1 downto WIDTH_ENCODER * 3));
          -- From 191 to 128
          separated_2 <= (separator_in((WIDTH_INPUT - WIDTH_ENCODER ) - 1 downto WIDTH_ENCODER * 2));
          -- From 127 to 64
          separated_3 <= (separator_in((WIDTH_INPUT - WIDTH_ENCODER * 2) - 1 downto WIDTH_ENCODER * 1));
          -- From  63 to 0
          separated_4 <= (separator_in(WIDTH_ENCODER - 1 downto 0));
          ready_signal <= '1';
        else if ( rst_i = '1' ) then
          separated_4 <= (others => '0');
          separated_3 <= (others => '0');
          separated_2 <= (others => '0');
          separated_1 <= (others => '0');
          ready_signal <= '0';
        else if ( ready_signal = '1' ) then
               ready_signal <= '0';
               end if;
        end if;
        end if;
      end if;
    end process;

    separated1_o <= separated_1;
    separated2_o <= separated_2;
    separated3_o <= separated_3;
    separated4_o <= separated_4;
    ready_o <= ready_signal;
end architecture;
