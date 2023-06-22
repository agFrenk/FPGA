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
          clk_i                           : in  std_logic;
          reset_i                         : in  std_logic;
          input_encoder1_i                : in  std_logic_vector(WIDTH_ENCODER_IN-1 downto 0);
          input_signal_ready_encoder1_i   : in  std_logic;
          input_encoder2_i                : in  std_logic_vector(WIDTH_ENCODER_IN-1 downto 0);
          input_signal_ready_encoder2_i   : in  std_logic;
          output                          : out std_logic_vector((WIDTH_FUSIONATOR_OUT)-1 downto 0);
          output_ready                    : out std_logic);
    end component;
    
    -- signals to connect to the entity under test

    --Inputs
    signal clk_sig    : std_logic := '0';
    signal reset_sig  :  std_logic := '0';

    signal input_encoder1_sig                : std_logic_vector(WIDTH_ENCODER_IN-1 downto 0) := (others => '0');
    signal input_signal_ready_encoder1_sig   : std_logic                       := '0';
    signal input_encoder2_sig                : std_logic_vector(WIDTH_ENCODER_IN-1 downto 0) := (others => '0');
    signal input_signal_ready_encoder2_sig   : std_logic                       := '0';
    
    --Outputs
    signal output_sig                          : std_logic_vector((WIDTH_FUSIONATOR_OUT)-1 downto 0) := (others => '0');
    signal output_ready_sig                    : std_logic := '0';

   
  


begin
    -- instantiate the entity under test
    uut: rle16B
    port map(
          clk_i                           =>  clk_sig,
          reset_i                         =>  reset_sig,
          input_encoder1_i                =>  input_encoder1_sig,
          input_signal_ready_encoder1_i   =>  input_signal_ready_encoder1_sig,
          input_encoder2_i                =>  input_encoder2_sig,
          input_signal_ready_encoder2_i   =>  input_signal_ready_encoder2_sig,
          output                          =>  output_sig,
          output_ready                    =>  output_ready_sig
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
         input_signal_ready_encoder1_sig <= '1';
         input_encoder1_sig <= x"AAAAAAAAAAAAAAAA";
         input_signal_ready_encoder2_sig <= '1';
         input_encoder2_sig <= x"AAAAAAAAAAAAAAAA";
         wait for 10 ns;
         input_signal_ready_encoder1_sig <= '0';
         input_signal_ready_encoder2_sig <= '0';
         wait for 100 ns;
         wait;
     end process;
        
end architecture;
