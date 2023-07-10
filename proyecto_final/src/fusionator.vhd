library IEEE;
library utils;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use utils.funciones.all;

entity fusionator is
  generic (
    WIDTH : integer := 128
  );
  port (
    clk                         : in std_logic;
    rst_i                       : in std_logic;
    compression_ready1_i        : in std_logic;
    compression_ready2_i        : in std_logic;
    compressed1_i               : in std_logic_vector(WIDTH-1 downto 0);  -- primer input
    compressed2_i               : in std_logic_vector(WIDTH-1 downto 0);  -- segundo input
    compression_size1_i         : in integer;   -- size del input 1
    compression_size2_i         : in integer;   -- size del input 2
    fusion_o                    : out std_logic_vector((WIDTH*2)-1 downto 0);   -- output
    fusion_size_o               : out integer;  -- size de la fusion reusltante
    ready_o                     : out std_logic
    );
end entity fusionator;

architecture structural of fusionator is
  constant character_size : integer := 8;

  signal fusion_size_sig              : integer := 0;
  signal fusion_s                   : std_logic_vector(fusion_o'range) := (others => '0');  -- senial de output
  signal ready_sig                  : std_logic := '0';  -- senial para output ready
  signal first_element_input2       : std_logic_vector(character_size - 1 downto 0);
  signal first_element_input2_count : integer;
  signal last_element_input1        : std_logic_vector(character_size - 1 downto 0);
  signal last_element_input1_count  : integer;
  signal intermedio_suma_de_valores : std_logic := '0';

begin  -- architecture structural

  process(clk, compression_ready1_i, compression_ready2_i, compressed1_i, compressed2_i)
  begin
    if (clk'event and clk = '1' and compression_ready1_i = '1' and compression_ready2_i = '1') then
      first_element_input2 <= get_character_from_array(compressed2_i, (WIDTH/character_size) - 2, character_size);
      first_element_input2_count <= to_integer(unsigned(get_character_from_array(compressed2_i,(WIDTH/character_size) - 1, character_size)));

      last_element_input1 <= get_character_from_array(compressed1_i,(WIDTH/character_size) - compression_size1_i , character_size);
      last_element_input1_count <= to_integer(unsigned(get_character_from_array(compressed1_i, (WIDTH/character_size) - compression_size1_i + 1, character_size)));

      if ( first_element_input2 = last_element_input1) then
      (fusion_s(
        -- 256 - 1                 256 - (size_1 - 2) * 8)
        ( (WIDTH*2) - 1 ) downto ((WIDTH*2) - (compression_size1_i - 2) * character_size))
       ) <= compressed1_i(WIDTH - 1 downto (WIDTH - (compression_size1_i - 2) * character_size));

       -- Seteo el ultimo count como la suma
       (fusion_s(
        (((WIDTH * 2) - 1) - (compression_size1_i - 2 )* character_size)  downto ((WIDTH * 2) - (compression_size1_i - 1) * character_size))
       ) <= std_logic_vector(to_unsigned(first_element_input2_count + last_element_input1_count , character_size));
       intermedio_suma_de_valores <= '1';

       -- Escribo 2*character_size menos de el compressed2_i.
       (fusion_s(
        ((WIDTH*2) - 1) - (compression_size1_i - 1 ) * character_size downto ((WIDTH*2) - ( compression_size1_i + compression_size2_i - 2 ) * character_size))
       ) <= compressed2_i(WIDTH - 1 - (1 * character_size) downto (WIDTH - compression_size2_i * character_size));

      fusion_size_sig <= compression_size1_i + compression_size2_i - 2;

      if (intermedio_suma_de_valores = '1') then
        ready_sig <= '1';
      end if;

      else
        (fusion_s(
          (WIDTH*2)-1
          downto
          ((WIDTH*2) - (compression_size1_i * character_size)))
         ) <= compressed1_i(WIDTH - 1 downto (WIDTH -compression_size1_i* character_size));

        (fusion_s(
          (WIDTH*2)-1 - compression_size1_i * character_size downto ((WIDTH*2) - compression_size1_i * character_size - compression_size2_i * character_size))
         ) <= compressed2_i(WIDTH - 1 downto (WIDTH - compression_size2_i * character_size));

         fusion_size_sig <= compression_size1_i + compression_size2_i;
         ready_sig <= '1';
      end if;

    end if;
  end process;

  fusion_o <= fusion_s;
  fusion_size_o <= fusion_size_sig;
  ready_o <= ready_sig;

end architecture structural;

