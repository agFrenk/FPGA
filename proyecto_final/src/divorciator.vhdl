library IEEE;
library utils;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use utils.funciones.all;

entity divorciator is
  generic (
    WIDTH_INPUT : integer := 128;
    WIDTH_RLE : integer := 128 / 2
  );
  port (
    clk : in std_logic;
    rst_i : in std_logic;
    divorciator_in : in std_logic_vector(WIDTH_INPUT - 1 downto 0); -- input del divorciator
    divorced1_o : out std_logic_vector(WIDTH_RLE - 1 downto 0); -- salida primer rle
    divorced2_o : out std_logic_vector(WIDTH_RLE - 1 downto 0); -- salida segundo rle
    ready_i : in std_logic; -- ready de entrada
    ready_o : out std_logic -- ready de salida
);
  end entity divorciator;

architecture structural of divorciator is
    signal divorced_dad : std_logic_vector(WIDTH_RLE - 1 downto 0) := (others => '0'); -- primer
                                                                   -- senial de
                                                                   -- salida

    signal divorced_mom : std_logic_vector(WIDTH_RLE - 1 downto 0) := (others => '0'); -- segunda
                                                                   -- senial de
                                                                   -- salida
    signal ready_signal : std_logic := '0';
begin
    process(clk)
    begin
      if (clk'event and clk = '1') then
        if( ready_i = '1' ) then
          divorced_mom <= (divorciator_in(WIDTH_INPUT - 1 downto WIDTH_RLE));
          divorced_dad <= (divorciator_in(WIDTH_RLE - 1 downto 0));
          ready_signal <= '1';
        else if ( rst_i = '1' ) then
          divorced_mom <= (others => '0');
          divorced_dad <= (others => '0');
          ready_signal <= '0';
          end if;
        end if;
      end if;
    end process;

    divorced1_o <= divorced_mom;
    divorced2_o <= divorced_dad;
    ready_o <= ready_signal;
end architecture;
