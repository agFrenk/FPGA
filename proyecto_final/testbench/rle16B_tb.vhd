library IEEE;
library utils;
use IEEE.std_logic_1164.all;

entity rle16b_tb is
end entity;

architecture tb_arch of rle16b_tb is
    constant WIDTH_FUSIONATOR_OUT   : integer := 256;
    constant WIDTH_ENCODER_IN       : integer := 64;
    -- import the entity to be tested
    component rle16B is
        port (
          clk_i                             : in  std_logic;
          reset_i                           : in  std_logic;
          input_encoder1_i                  : in  std_logic_vector(WIDTH_ENCODER_IN-1 downto 0);
          ready_enconder1_i                 : in  std_logic;
          input_encoder2_i                  : in  std_logic_vector(WIDTH_ENCODER_IN-1 downto 0);
          ready_enconder2_i                 : in  std_logic;
          rle_compressed_o                  : out std_logic_vector((WIDTH_FUSIONATOR_OUT)-1 downto 0);
          ready_o                           : out std_logic);
    end component;
    
    -- signals to connect to the entity under test

    --Inputs
    signal clk_sig              : std_logic := '0';
    signal reset_sig            : std_logic := '0';
    signal ready_enconder1_s    : std_logic := '0';
    signal ready_enconder2_s    : std_logic := '0';
    signal input_encoder1_sig   : std_logic_vector(WIDTH_ENCODER_IN-1 downto 0) := (others => '0');
    signal input_encoder2_sig   : std_logic_vector(WIDTH_ENCODER_IN-1 downto 0) := (others => '0');

    
    --Outputs
    signal rle_compressed_s           : std_logic_vector((WIDTH_FUSIONATOR_OUT)-1 downto 0) := (others => '0');
    signal ready_s                    : std_logic := '0';

   
  


begin
    -- instantiate the entity under test
    uut: rle16B
    port map(
          clk_i                           =>  clk_sig,
          reset_i                         =>  reset_sig,
          input_encoder1_i                =>  input_encoder1_sig,
          ready_enconder1_i               =>  ready_enconder1_s,
          input_encoder2_i                =>  input_encoder2_sig,
          ready_enconder2_i               =>  ready_enconder2_s,
          rle_compressed_o                =>  rle_compressed_s,
          ready_o                         =>  ready_s
    );

    clk_proc: process
    begin
        while now < 1000 ns loop
            clk_sig <= '0';
            wait for 5 ns;
            clk_sig <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

     -- Stimulus process
     process
     begin
         -- Provide test vector
         ready_enconder1_s <= '1';
         input_encoder1_sig <= x"AAAAAAAAAAAAAAAA";
         ready_enconder2_s <= '1';
         input_encoder2_sig <= x"AAAAAAAAAAAAAAAA";
         wait for 10 ns;
         ready_enconder1_s <= '0';
         ready_enconder2_s <= '0';
         wait for 100 ns;
         wait;
     end process;    
end architecture;
