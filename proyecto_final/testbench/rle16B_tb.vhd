library IEEE;
library utils;
use IEEE.std_logic_1164.all;

entity rle16b_tb is
end entity;

architecture tb_arch of rle16b_tb is
    constant WIDTH_FUSIONATOR_OUT   : integer := 512;
    constant WIDTH_ENCODER_IN       : integer := 64;
    -- import the entity to be tested
    component rle16B is
        port (
          clk_i                             : in  std_logic;
          reset_i                           : in  std_logic;
          rle_i                             : in  std_logic_vector((WIDTH_ENCODER_IN * 4)-1 downto 0);
          ready_i                           : in  std_logic;
          rle_compressed_o                  : out std_logic_vector((WIDTH_FUSIONATOR_OUT)-1 downto 0);
          rle_size_o                        : out integer;
          ready_o                           : out std_logic);
    end component;
    
    -- signals to connect to the entity under test

    --Inputs
    signal clk_sig              : std_logic := '0';
    signal reset_sig            : std_logic := '0';
    signal ready_in_s    : std_logic := '1';
    signal rle_sig   : std_logic_vector((WIDTH_ENCODER_IN * 4)-1 downto 0) := (others => '0');

    
    --Outputs
    signal rle_compressed_s           : std_logic_vector((WIDTH_FUSIONATOR_OUT)-1 downto 0) := (others => '0');
    signal rle_size_s           : integer := 0;
    signal ready_out_s    : std_logic := '0';

   
  


begin
    -- instantiate the entity under test
    uut: rle16B
    port map(
          clk_i                           =>  clk_sig,
          reset_i                         =>  reset_sig,
          rle_i                           =>  rle_sig,
          ready_i                         =>  ready_in_s,
          rle_compressed_o                =>  rle_compressed_s,
          rle_size_o                      =>  rle_size_s,
          ready_o                         =>  ready_out_s
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
         ready_in_s <= '1';
         wait for 10 ns;
         -- rle_sig <= x"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
         rle_sig <= x"12BBBBBBBBBBDEF3123456789ABCDEF3123456789ABCDEF3123456789ABCDEF2";
         -- rle_sig <= x"AAAAAAAAAAAAAAAABBBBBBBBBBBBBBBBCCCCCCCCCCCCCCCCDDDDDDDDDDDDDDDD";
         wait for 10 ns;
         ready_in_s <= '0';
         wait for 100 ns;
         wait;
     end process;    
end architecture;
