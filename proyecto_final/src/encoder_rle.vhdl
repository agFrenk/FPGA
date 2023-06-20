library IEEE;
library utils;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use utils.funciones.all;

entity encoder_rle is
    generic ( WIDTH : natural := 64);
   port(
      input_i       : in std_logic_vector (WIDTH-1 downto 0);
      clk_i         : in std_logic;
      reset_i       : in std_logic;
      output_o      : out std_logic_vector ((WIDTH*2)-1 downto 0);
      ready_o       : out std_logic
   );
end encoder_rle;

architecture encoder_architecture of encoder_rle is
    constant character_size                 : integer := 8;
    signal character_index                  : integer := (WIDTH/8)-1;
    signal consecutive_characters           : integer := 0;
    signal compresion_size                  : natural := 0;
    signal characters_to_compress           : std_logic_vector (WIDTH-1 downto 0) :=  (others => '0');
    shared variable compresion_result       : std_logic_vector((WIDTH*2)-1 downto 0) := (others => '0');


begin
    process(input_i)
    begin
        characters_to_compress <= input_i;
    end process;

    process(clk_i)
    -- variable compresion_result      : std_logic_vector((WIDTH*2)-1 downto 0) := (others => '0');
    begin
        if rising_edge(clk_i) then
            if(character_index > 0) then
                if(get_character_from_array(characters_to_compress, character_index, character_size) = 
                    get_character_from_array(characters_to_compress, character_index -1, character_size)) then
                        consecutive_characters <= consecutive_characters + 1;      
                else
                        consecutive_characters <= 0;
                        compresion_size <= compresion_size + 2;
                end if;
                ready_o <= '0';
                character_index <= character_index - 1;
            end if;
            output_o <= (others => '0');
            
        end if;
    end process;

    output_o <= compresion_result;
end architecture;