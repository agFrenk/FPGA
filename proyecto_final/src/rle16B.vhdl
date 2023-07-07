library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rle16B is
  port (
    clk_i                           : in  std_logic;
    reset_i                         : in  std_logic;
    rle_i                : in  std_logic_vector(128-1 downto 0); -- ACA EL 64 ES WITH_ENCODER
    ready_i               : in  std_logic;
    rle_compressed_o                : out std_logic_vector((128*2)-1 downto 0);
    ready_o                         : out std_logic);
end entity rle16B;

architecture rle16B_architecture of rle16B is
    -- Constants
    constant WIDTH_ENCODER      : natural := 64;
    constant WIDTH_FUSIONATOR   : integer := 128;      -- ANCHO DE ENTRADA 
    -- Component declaration
    component fusionator is
      generic ( WIDTH : integer := 128);
        port (
        clk                     : in std_logic;
        rst_i                   : in std_logic;
        compression_ready1_i    : in std_logic;
        compression_ready2_i    : in std_logic;
        compressed1_i           : in std_logic_vector(WIDTH_FUSIONATOR-1 downto 0);
        compression_size1_i     : in integer;   -- size del input 1
        compressed2_i           : in std_logic_vector(WIDTH_FUSIONATOR-1 downto 0);
        compression_size2_i     : in integer;   -- size del input 2
        fusion_o                : out std_logic_vector((WIDTH_FUSIONATOR*2)-1 downto 0);
        ready_o                 : out std_logic
        );
    end component fusionator;

    component divorciator is
      generic (
      WIDTH_INPUT : integer := 128;
      WIDTH_RLE : integer := 64
      );
      port (
        clk : in std_logic;
        rst_i : in std_logic;
        divorciator_in: in std_logic_vector(WIDTH_INPUT - 1 downto 0);
        divorced1_o : out std_logic_vector(WIDTH_RLE - 1 downto 0); -- salida primer rle
        divorced2_o : out std_logic_vector(WIDTH_RLE - 1 downto 0); -- salida segundo rle
        ready_i : in std_logic; -- ready de entrada
        ready_o : out std_logic -- ready de salida
      );
      end component divorciator;


    -- Component declaration
    component encoder_rle
        -- generic (WIDTH_ENCODER : natural := 64);
        port (
            characters_to_compress_i      : in std_logic_vector(WIDTH_ENCODER-1 downto 0);
            clk_i                         : in std_logic;
            reset_i                       : in std_logic;
            compression_o                 : out std_logic_vector((WIDTH_ENCODER*2)-1 downto 0);
            ready_o                       : out std_logic;
            ready_i                       : in std_logic;
            size_o                        : out integer
        );
    end component;

    -- signals divorciator y encoder compartidas
    signal divorced1_s                   : std_logic_vector(WIDTH_ENCODER - 1 downto 0);
    signal divorced2_s                   : std_logic_vector(WIDTH_ENCODER - 1 downto 0);
    signal out_ready_divorciator_sig     : std_logic;

    --signals encoder1 y fusionator compartidas 
    signal compressed1_s                : std_logic_vector(WIDTH_FUSIONATOR-1 downto 0);
    signal size_1_sig                   : integer;   -- size del input 2
    signal out_ready_enconder1_sig      : std_logic;
    
    --signals encoder2 y fusionator compartidas 
    signal compressed2_s                : std_logic_vector(WIDTH_FUSIONATOR-1 downto 0);
    signal size_2_sig                   : integer;   -- size del input 2
    signal out_ready_enconder2_sig      : std_logic;


begin  -- architecture behavioral

  -- Instantiate the fusionator component
  uut_fusionator: fusionator
    generic map (
      WIDTH  => WIDTH_FUSIONATOR
    )
    port map (
      clk                   => clk_i,
      rst_i                 => reset_i,
      compression_ready1_i  => out_ready_enconder1_sig,
      compression_ready2_i  => out_ready_enconder2_sig,
      compressed1_i         => compressed1_s,
      compression_size1_i   => size_1_sig,
      compressed2_i         => compressed2_s,
      compression_size2_i   => size_2_sig,
      fusion_o              => rle_compressed_o,
      ready_o               => ready_o
    );
  
  uut_divorciator: divorciator
      generic map (
        WIDTH_INPUT  => 128,
        WIDTH_RLE    =>  64
      )
      port map (
        clk            => clk_i,
        rst_i          => reset_i,
        divorciator_in => rle_i,
        divorced1_o    => divorced1_s,
        divorced2_o    => divorced2_s,
        ready_i        => ready_i,
        ready_o        => out_ready_divorciator_sig
      );

  uut_ecnoder1: encoder_rle
    port map (
        characters_to_compress_i      => divorced1_s,
        clk_i                         => clk_i,
        reset_i                       => reset_i,
        compression_o                 => compressed1_s,
        ready_o                       => out_ready_enconder1_sig,
        ready_i                       => out_ready_divorciator_sig,
        size_o                        => size_1_sig
    );

  uut_ecnoder2: encoder_rle
    -- generic map (
    --   WIDTH_ENCODER => WIDTH_ENCODER
    -- )
    port map (
        characters_to_compress_i          => divorced2_s,
        clk_i                             => clk_i,
        reset_i                           => reset_i,
        compression_o                     => compressed2_s,
        ready_o                           => out_ready_enconder2_sig,
        ready_i                           => out_ready_divorciator_sig,
        size_o                            => size_2_sig
    );

end architecture rle16B_architecture;
