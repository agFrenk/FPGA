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
    clk               : in std_logic;
    rst_i             : in std_logic;
    in_ready_1        : in std_logic;
    in_ready_2        : in std_logic;
    input_1           : in std_logic_vector(WIDTH-1 downto 0);  -- primer input
    size_1_i          : in integer;   -- size del input 1
    input_2           : in std_logic_vector(WIDTH-1 downto 0);  -- segundo input
    size_2_i          : in integer;   -- size del input 2
    output            : out std_logic_vector((WIDTH*2)-1 downto 0);   -- output
    out_ready         : out std_logic
    );
end entity fusionator;

architecture structural of fusionator is
  constant character_size : integer := 8;

  signal output_sig : std_logic_vector(output'range) := (others => '0');  -- senial de output
  signal out_ready_sig : std_logic := '0';  -- senial para output ready
  signal first_element_input2 : std_logic_vector(character_size - 1 downto 0);
  signal first_element_input2_count : integer;
  signal last_element_input1 : std_logic_vector(character_size - 1 downto 0);
  signal last_element_input1_count  : integer;

begin  -- architecture structural

  process(clk)
  begin
    if (clk'event and clk = '1' and in_ready_1 = '1' and in_ready_2 = '1') then
      first_element_input2 <= get_character_from_array(input_2, (WIDTH/character_size) - 2, character_size);
      first_element_input2_count <= to_integer(unsigned(get_character_from_array(input_2,(WIDTH/character_size) - 1, character_size)));

      last_element_input1 <= get_character_from_array(input_1,(WIDTH/character_size) - size_1 , character_size);
      last_element_input1_count <= to_integer(unsigned(get_character_from_array(input_1, (WIDTH/character_size) - size_1 + 1, character_size)));

      if ( first_element_input2 = last_element_input1) then
      (output_sig(
        -- 256 - 1                 256 - (size_1 - 2) * 8)
        ( (WIDTH*2) - 1 ) downto ((WIDTH*2) - (size_1 - 2) * character_size))
       ) <= input_1(WIDTH - 1 downto (WIDTH - (size_1 - 2) * character_size));

       -- Seteo el ultimo count como la suma
       (output_sig(
        (((WIDTH * 2) - 1) - (size_1 - 2 )* character_size)  downto ((WIDTH * 2) - (size_1 - 1) * character_size))
       ) <= std_logic_vector(to_unsigned(first_element_input2_count + last_element_input1_count , character_size));

       -- Escribo 2*character_size menos de el input_2.
       (output_sig(
        ((WIDTH*2) - 1) - (size_1 - 1 ) * character_size downto ((WIDTH*2) - ( size_1 + size_2 - 2 ) * character_size))
       ) <= input_2(WIDTH - 1 - (1 * character_size) downto (WIDTH - size_2 * character_size));

      -------------------------------------------------------------------------
      -- __C| X |C__
      -------------------------------------------------------------------------

      else
        (output_sig(
          (WIDTH*2)-1
          downto
          ((WIDTH*2) - (size_1 * character_size)))
         ) <= input_1(WIDTH - 1 downto (WIDTH -size_1* character_size));
        (output_sig(
          (WIDTH*2)-1 - size_1 * character_size downto ((WIDTH*2) - size_1 * character_size - size_2 * character_size))
         ) <= input_2(WIDTH - 1 downto (WIDTH - size_2 * character_size));

      end if;
      out_ready_sig <= '1';
    end if;
  end process;

  output <= output_sig;
  out_ready <= out_ready_sig;

end architecture structural;

