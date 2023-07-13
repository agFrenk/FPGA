library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity encoder_rle_tb is
end encoder_rle_tb;

architecture testbench_architecture of encoder_rle_tb is
    -- Constants
    constant WIDTH : natural := 64;
    
    -- Signals
    signal input_sig                : std_logic_vector(WIDTH-1 downto 0);
    signal clk_sig                  : std_logic := '0';
    signal reset_sig                : std_logic := '0';
    signal output_sig               : std_logic_vector((WIDTH*2)-1 downto 0);
    signal ready_sig                : std_logic;
    signal size_sig                 : integer;
    signal input_signal_ready_sig   : std_logic;

    -- Component declaration
    component encoder_rle
        generic (WIDTH : natural := 64);
        port (
            characters_to_compress_i : in std_logic_vector(WIDTH-1 downto 0);
            clk_i                    : in std_logic;
            reset_i                  : in std_logic;
            compression_o            : out std_logic_vector((WIDTH*2)-1 downto 0);
            ready_o                  : out std_logic;
            ready_i                  : in std_logic;
            size_o                   : out integer
        );
    end component;

begin
    -- DUT instantiation
    uut: encoder_rle
    generic map (
        WIDTH => WIDTH
    )
    port map (
        characters_to_compress_i                 => input_sig,
        clk_i                   => clk_sig,
        reset_i                 => reset_sig,
        compression_o                => output_sig,
        ready_o                 => ready_sig,
        ready_i    => input_signal_ready_sig,
        size_o                  => size_sig
    );

    -- Clock generation process
    process
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
        input_signal_ready_sig <= '1';
        input_sig <= x"AAAAAAAAAAAAAAAA";
        wait for 10 ns;
        input_signal_ready_sig <= '0';
        wait for 100 ns;
        
        -- Add additional test cases here if needed

        -- End the simulation
        wait;
    end process;
end testbench_architecture;
