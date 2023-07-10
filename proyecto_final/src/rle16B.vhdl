library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rle16B is
  port (
    clk_i                           : in  std_logic;
    reset_i                         : in  std_logic;
    rle_i                           : in  std_logic_vector(256-1 downto 0); -- ACA EL 64 ES WITH_ENCODER
    ready_i                         : in  std_logic;
    rle_compressed_o                : out std_logic_vector((256*2)-1 downto 0);
    rle_size_o                      : out integer;
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
        compressed1_i           : in std_logic_vector(WIDTH - 1 downto 0);
        compression_size1_i     : in integer;   -- size del input 1
        compressed2_i           : in std_logic_vector(WIDTH - 1 downto 0);
        compression_size2_i     : in integer;   -- size del input 2
        fusion_o                : out std_logic_vector((WIDTH * 2)-1 downto 0);
        fusion_size_o           : out integer;
        ready_o                 : out std_logic
        );
    end component fusionator;

    component separator is
      generic (
      WIDTH_INPUT : integer := 256;
      WIDTH_ENCODER : integer := 64
      );
      port (
        clk : in std_logic;
        rst_i : in std_logic;
        separator_in: in std_logic_vector(WIDTH_INPUT - 1 downto 0);
        separated1_o : out std_logic_vector(WIDTH_ENCODER - 1 downto 0); -- salida primer rle
        separated2_o : out std_logic_vector(WIDTH_ENCODER - 1 downto 0); -- salida segundo rle
        separated3_o : out std_logic_vector(WIDTH_ENCODER - 1 downto 0); -- salida tercer rle
        separated4_o : out std_logic_vector(WIDTH_ENCODER - 1 downto 0); -- salida cuarto rle
        ready_i : in std_logic; -- ready de entrada
        ready_o : out std_logic -- ready de salida
      );
      end component separator;


    -- Component declaration
    component encoder_rle
        generic (WIDTH : natural := 64);
        port (
            characters_to_compress_i      : in std_logic_vector(WIDTH - 1 downto 0);
            clk_i                         : in std_logic;
            reset_i                       : in std_logic;
            compression_o                 : out std_logic_vector((WIDTH * 2)-1 downto 0);
            ready_o                       : out std_logic;
            ready_i                       : in std_logic;
            size_o                        : out integer
        );
    end component;

    -- signals separator y encoder compartidas
    signal separated1_s                   : std_logic_vector(WIDTH_ENCODER - 1 downto 0);
    signal separated2_s                   : std_logic_vector(WIDTH_ENCODER - 1 downto 0);
    signal separated3_s                   : std_logic_vector(WIDTH_ENCODER - 1 downto 0);
    signal separated4_s                   : std_logic_vector(WIDTH_ENCODER - 1 downto 0);
    signal out_ready_separator_sig     : std_logic;

    -- signals encoder1 y fusionator compartidas 
    signal compressed1_s                : std_logic_vector(WIDTH_FUSIONATOR-1 downto 0);
    signal size_1_sig                   : integer;   -- size del input 1
    signal out_ready_enconder1_sig      : std_logic;
    
    -- signals encoder2 y fusionator compartidas 
    signal compressed2_s                : std_logic_vector(WIDTH_FUSIONATOR-1 downto 0);
    signal size_2_sig                   : integer;   -- size del input 2
    signal out_ready_enconder2_sig      : std_logic;

    -- signals encoder3 y fusionator compartidas 
    signal compressed3_s                : std_logic_vector(WIDTH_FUSIONATOR-1 downto 0);
    signal size_3_sig                   : integer;   -- size del input 3
    signal out_ready_enconder3_sig      : std_logic;
    
    -- signals encoder4 y fusionator compartidas 
    signal compressed4_s                : std_logic_vector(WIDTH_FUSIONATOR-1 downto 0);
    signal size_4_sig                   : integer;   -- size del input 4
    signal out_ready_enconder4_sig      : std_logic;

    -- signals for fusionator_fusionators para fusionar salida de fusionators
    signal fusionator_enc_1_and_2          : std_logic_vector((WIDTH_FUSIONATOR * 2)- 1 downto 0);
    signal fusionator_enc_3_and_4          : std_logic_vector((WIDTH_FUSIONATOR * 2) - 1 downto 0);
    signal ready_fusionator_enc12_sig      : std_logic;
    signal ready_fusionator_enc34_sig      : std_logic;
    signal size_fusionator_enc12_sig       : integer;
    signal size_fusionator_enc34_sig       : integer;


begin  -- architecture behavioral

  uut_separator: separator
      generic map (
        WIDTH_INPUT  => 256,
        WIDTH_ENCODER    =>  64
      )
      port map (
        clk            => clk_i,
        rst_i          => reset_i,
        separator_in => rle_i,
        separated1_o    => separated1_s,
        separated2_o    => separated2_s,
        separated3_o    => separated3_s,
        separated4_o    => separated4_s,
        ready_i        => ready_i,
        ready_o        => out_ready_separator_sig
      );

  uut_ecnoder1: encoder_rle
    generic map (
      WIDTH => WIDTH_ENCODER
    )
    port map (
        characters_to_compress_i      => separated1_s,
        clk_i                         => clk_i,
        reset_i                       => reset_i,
        compression_o                 => compressed1_s,
        ready_o                       => out_ready_enconder1_sig,
        ready_i                       => out_ready_separator_sig,
        size_o                        => size_1_sig
    );

  uut_ecnoder2: encoder_rle
    generic map (
      WIDTH => WIDTH_ENCODER
    )
    port map (
        characters_to_compress_i          => separated2_s,
        clk_i                             => clk_i,
        reset_i                           => reset_i,
        compression_o                     => compressed2_s,
        ready_o                           => out_ready_enconder2_sig,
        ready_i                           => out_ready_separator_sig,
        size_o                            => size_2_sig
    );

  uut_ecnoder3: encoder_rle
    generic map (
      WIDTH => WIDTH_ENCODER
    )
    port map (
        characters_to_compress_i          => separated3_s,
        clk_i                             => clk_i,
        reset_i                           => reset_i,
        compression_o                     => compressed3_s,
        ready_o                           => out_ready_enconder3_sig,
        ready_i                           => out_ready_separator_sig,
        size_o                            => size_3_sig
    );

  uut_ecnoder4: encoder_rle
    generic map (
      WIDTH => WIDTH_ENCODER
    )
    port map (
        characters_to_compress_i          => separated4_s,
        clk_i                             => clk_i,
        reset_i                           => reset_i,
        compression_o                     => compressed4_s,
        ready_o                           => out_ready_enconder4_sig,
        ready_i                           => out_ready_separator_sig,
        size_o                            => size_4_sig
    );

  -- Instantiate the fusionator component
  uut_fusionator_encoders_1_and_2: fusionator
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
      fusion_o              => fusionator_enc_1_and_2,
      fusion_size_o         => size_fusionator_enc12_sig,
      ready_o               => ready_fusionator_enc12_sig
    );

  uut_fusionator_encoders_3_and_4: fusionator
    generic map (
      WIDTH  => WIDTH_FUSIONATOR
    )
    port map (
      clk                   => clk_i,
      rst_i                 => reset_i,
      compression_ready1_i  => out_ready_enconder3_sig,
      compression_ready2_i  => out_ready_enconder4_sig,
      compressed1_i         => compressed3_s,
      compression_size1_i   => size_3_sig,
      compressed2_i         => compressed4_s,
      compression_size2_i   => size_4_sig,
      fusion_o              => fusionator_enc_3_and_4,
      fusion_size_o         => size_fusionator_enc34_sig,
      ready_o               => ready_fusionator_enc34_sig
    );

  uut_fusionator_fusionators: fusionator
    generic map (
      WIDTH  => WIDTH_FUSIONATOR * 2
    )
    port map (
      clk                   => clk_i,
      rst_i                 => reset_i,
      compression_ready1_i  => ready_fusionator_enc12_sig,
      compression_ready2_i  => ready_fusionator_enc34_sig,
      compressed1_i         => fusionator_enc_1_and_2,
      compression_size1_i   => size_fusionator_enc12_sig,
      compressed2_i         => fusionator_enc_3_and_4,
      compression_size2_i   => size_fusionator_enc34_sig,
      fusion_o              => rle_compressed_o,
      fusion_size_o         => rle_size_o,
      ready_o               => ready_o
    );

end architecture rle16B_architecture;
