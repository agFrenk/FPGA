library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fusionator_tb is
end entity fusionator_tb;

architecture behavioral of fusionator_tb is
  -- Component declaration
  component fusionator is
    generic (WIDTH : integer := 128);
    port (
      clk       : in std_logic;
      rst       : in std_logic;
      in_ready_1  : in std_logic;
      in_ready_2  : in std_logic;
      input_1   : in std_logic_vector(WIDTH-1 downto 0);
      size_1          : in integer;   -- size del input 1
      input_2   : in std_logic_vector(WIDTH-1 downto 0);
      size_2          : in integer;   -- size del input 2
      output    : out std_logic_vector((WIDTH*2)-1 downto 0);
      out_ready : out std_logic
    );
  end component fusionator;

  constant WIDTH : integer := 128;      -- ANCHO DE ENTRADA
  -- Signal declarations
  signal clk_tb         : std_logic := '0';
  signal rst_tb         : std_logic := '1';
  signal in_ready_1_tb    : std_logic;
  signal in_ready_2_tb    : std_logic;
  signal input_1_tb     : std_logic_vector(WIDTH-1 downto 0);
  signal size_1_tb      : integer;   -- size del input 2
  signal input_2_tb     : std_logic_vector(WIDTH-1 downto 0);
  signal size_2_tb      : integer;   -- size del input 2
  signal output_tb      : std_logic_vector((WIDTH*2)-1 downto 0);
  signal out_ready_tb   : std_logic;

begin  -- architecture behavioral

  -- Instantiate the fusionator component
  dut: fusionator
    port map (
      clk       => clk_tb,
      rst       => rst_tb,
      in_ready_1  => in_ready_1_tb,
      in_ready_2  => in_ready_2_tb,
      input_1   => input_1_tb,
      size_1    => size_1_tb,
      input_2   => input_2_tb,
      size_2    => size_2_tb,
      output    => output_tb,
      out_ready => out_ready_tb
    );

  -- Clock process
  clk_proc: process
  begin
    while now < 100 ns loop  -- Simulate for 100 ns
      clk_tb <= '0';
      wait for 1 ns;
      clk_tb <= '1';
      wait for 1 ns;
    end loop;
    wait;
  end process clk_proc;

  -- Stimulus process
  stimulus_proc: process
  begin
    -- Reset the design
    rst_tb <= '0';
    wait for 2 ns;
    rst_tb <= '1';

    -- Wait for some time after reset
    wait for 4 ns;

    -- Provide test inputs
    in_ready_1_tb <= '1';
    in_ready_2_tb <= '1';
    input_1_tb <= x"01020304050607080F10a1a2a3a4a5a6";
    size_1_tb <= 10;
    input_2_tb <= x"0F10aaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    size_2_tb <= 4;

    -- Wait for some time to observe the output
    wait for 4 ns;

    -- Stop the simulation
    wait;
  end process stimulus_proc;

end architecture behavioral;
