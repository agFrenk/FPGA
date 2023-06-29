library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rle16B is
  port (
    clk_i                           : in  std_logic;
    reset_i                         : in  std_logic;
    input_encoder1_i                : in  std_logic_vector(64-1 downto 0); -- ACA EL 64 ES WITH_ENCODER
    input_signal_ready_encoder1_i   : in  std_logic;
    input_encoder2_i                : in  std_logic_vector(64-1 downto 0); -- ACA EL 64 ES WITH_ENCODER
    input_signal_ready_encoder2_i   : in  std_logic;
    output                          : out std_logic_vector((128*2)-1 downto 0);
    output_ready                    : out std_logic);
end entity rle16B;

architecture rle16B_architecture of rle16B is
    -- Constants
    constant WIDTH_ENCODER : natural := 64;
    constant WIDTH_FUSIONATOR   : integer := 128;      -- ANCHO DE ENTRADA 
    -- Component declaration
    component fusionator is
        -- generic (WIDTH_FUSIONATOR : integer := 128);
        port (
        clk           : in std_logic;
        rst_i         : in std_logic;
        in_ready_1    : in std_logic;
        in_ready_2    : in std_logic;
        input_1       : in std_logic_vector(WIDTH_FUSIONATOR-1 downto 0);
        size_1_i      : in integer;   -- size del input 1
        input_2       : in std_logic_vector(WIDTH_FUSIONATOR-1 downto 0);
        size_2_i      : in integer;   -- size del input 2
        fusion_o        : out std_logic_vector((WIDTH_FUSIONATOR*2)-1 downto 0);
        out_ready     : out std_logic
        );
    end component fusionator;


    -- Component declaration
    component encoder_rle
        -- generic (WIDTH_ENCODER : natural := 64);
        port (
            characters_to_compress_i                 : in std_logic_vector(WIDTH_ENCODER-1 downto 0);
            clk_i                   : in std_logic;
            reset_i                 : in std_logic;
            compression_o                : out std_logic_vector((WIDTH_ENCODER*2)-1 downto 0);
            ready_o                 : out std_logic;
            input_signal_ready_i    : in std_logic;
            size_o                  : out integer
        );
    end component;


    -- Signal declarations fusionator FUSIONATOR
    signal clk_sig              : std_logic := '0';
    signal rst_sig              : std_logic := '1';
    signal output_sig           : std_logic_vector((WIDTH_FUSIONATOR*2)-1 downto 0);
    
    
    -- Signals Encoder1
    signal input_enconder1_sig                : std_logic_vector(WIDTH_ENCODER-1 downto 0);
    signal reset_encoder1_sig                 : std_logic := '0';

    --signals encoder1 y fusionator compartidas 
    signal input_fusionator_output_encoder1_sig         : std_logic_vector(WIDTH_FUSIONATOR-1 downto 0);
    signal size_1_sig                                   : integer;   -- size del input 2
    signal out_ready_enconder1_sig                      : std_logic;
    
    -- Signals Encoder2
    signal input_enconder2_sig                : std_logic_vector(WIDTH_ENCODER-1 downto 0);
    signal reset_encoder2_sig                 : std_logic := '0';
    
    
    --signals encoder2 y fusionator compartidas 
    signal input_fusionator_output_encoder2_sig           : std_logic_vector(WIDTH_FUSIONATOR-1 downto 0);
    signal size_2_sig                                     : integer;   -- size del input 2
    signal out_ready_enconder2_sig                        : std_logic;


begin  -- architecture behavioral

  -- Instantiate the fusionator component
  uut_fusionator: fusionator
    port map (
      clk         => clk_i,
      rst_i       => reset_i,
      in_ready_1  => out_ready_enconder1_sig,
      in_ready_2  => out_ready_enconder2_sig,
      input_1     => input_fusionator_output_encoder1_sig,
      size_1_i    => size_1_sig,
      input_2     => input_fusionator_output_encoder2_sig,
      size_2_i    => size_2_sig,
      fusion_o      => output,
      out_ready   => output_ready
    );
  
  uut_ecnoder1: encoder_rle
    port map (
        characters_to_compress_i                 => input_encoder1_i,
        clk_i                   => clk_i,
        reset_i                 => reset_i,
        compression_o                => input_fusionator_output_encoder1_sig,
        ready_o                 => out_ready_enconder1_sig,
        input_signal_ready_i    => input_signal_ready_encoder1_i,
        size_o                  => size_1_sig
    );

  uut_ecnoder2: encoder_rle
    -- generic map (
    --   WIDTH_ENCODER => WIDTH_ENCODER
    -- )
    port map (
        characters_to_compress_i                 => input_encoder2_i,
        clk_i                   => clk_i,
        reset_i                 => reset_i,
        compression_o                => input_fusionator_output_encoder2_sig,
        ready_o                 => out_ready_enconder2_sig,
        input_signal_ready_i    => input_signal_ready_encoder2_i,
        size_o                  => size_2_sig
    );

end architecture rle16B_architecture;
