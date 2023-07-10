library IEEE;
library utils;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use utils.funciones.all; 
entity encoder_rle is
    generic ( WIDTH : natural := 64);
   port(
      characters_to_compress_i          : in std_logic_vector (WIDTH-1 downto 0);
      ready_i                           : in std_logic;
      clk_i                             : in std_logic;
      reset_i                           : in std_logic;
      compression_o                     : out std_logic_vector ((WIDTH*2)-1 downto 0);
      ready_o                           : out std_logic;
      size_o                            : out integer
   );
end encoder_rle;

architecture encoder_architecture of encoder_rle is
    constant CHARACTER_SIZE                     : integer := 8;
    signal character_index                      : integer := (WIDTH/8)-1;
    signal consecutive_characters               : integer := 1;
    signal compression_size                     : natural := 0;
    signal characters_to_compress_s             : std_logic_vector (WIDTH-1 downto 0) :=  (others => '0');
    signal where_to_write_in_result             : integer := (WIDTH*2);
    signal compression_result                   : std_logic_vector((WIDTH*2)-1 downto 0) := (others => '0');
    signal ready_s                              : std_logic := '0';


begin
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if reset_i = '1' then                                           -- RESET
                character_index <= (WIDTH/CHARACTER_SIZE)-1;
                compression_size <= 0;
                consecutive_characters <= 1;
                where_to_write_in_result <= (WIDTH*2);
                compression_result <= (others => '0');
                characters_to_compress_s <= (others => '0');
            else                                                           
                if ready_i = '1' then                          -- set characters to compress
                    characters_to_compress_s <= characters_to_compress_i;
                else                                                        -- compression process
                    if(character_index > 0) then                            
                        if(get_character_from_array(characters_to_compress_s, character_index, CHARACTER_SIZE) = 
                            get_character_from_array(characters_to_compress_s, character_index -1, CHARACTER_SIZE)) then        -- repeated characters
                                consecutive_characters <= consecutive_characters + 1;
                                compression_result <= compression_result;    
                        else                                                                                                    -- different characters
                                compression_result(where_to_write_in_result-1 downto where_to_write_in_result - CHARACTER_SIZE) <= std_logic_vector(to_unsigned(consecutive_characters, CHARACTER_SIZE));
                                compression_result(where_to_write_in_result-1-CHARACTER_SIZE downto where_to_write_in_result - CHARACTER_SIZE*2) <= get_character_from_array(characters_to_compress_s, character_index, CHARACTER_SIZE);
                                where_to_write_in_result <= where_to_write_in_result - CHARACTER_SIZE*2;
                                consecutive_characters <= 1;
                                compression_size <= compression_size + 2;

                        end if;
                        ready_s <= '0';
                        character_index <= character_index - 1;
                    elsif character_index = 0 then                          -- last character edge case
                        compression_result(where_to_write_in_result-1 downto where_to_write_in_result - CHARACTER_SIZE) <= std_logic_vector(to_unsigned(consecutive_characters, CHARACTER_SIZE));
                        compression_result(where_to_write_in_result-1-CHARACTER_SIZE downto where_to_write_in_result - CHARACTER_SIZE-CHARACTER_SIZE) <= get_character_from_array(characters_to_compress_s, character_index, CHARACTER_SIZE);
                        compression_size <= compression_size + 2;
                        character_index <= character_index - 1;
                    else
                    ready_s <= '1';
                    end if;
                    compression_o <= compression_result;
                    size_o <= compression_size;
                end if;
            end if;
        end if;
    end process;
    ready_o <= ready_s;
end architecture;