library IEEE;
use IEEE.std_logic_1164.all;

entity divorciator_tb is
end entity divorciator_tb;

architecture tb_arch of divorciator_tb is
  constant CLK_PERIOD : time := 10 ns;  -- Define the clock period

  -- Component declaration
  component divorciator
    generic (
      WIDTH_INPUT : integer := 128;
      WIDTH_RLE : integer := 128 / 2
    );
    port (
      clk : in std_logic;
      rst_i : in std_logic;
      divorciator_in : in std_logic_vector(WIDTH_INPUT - 1 downto 0);
      divorced1_o : out std_logic_vector(WIDTH_RLE - 1 downto 0);
      divorced2_o : out std_logic_vector(WIDTH_RLE - 1 downto 0);
      ready_i : in std_logic;
      ready_o : out std_logic
    );
  end component divorciator;
  constant WIDTH_INPUT : integer := 128; -- ANCHO DE ENTRADA
  constant WIDTH_RLE : integer := WIDTH_INPUT / 2 ; -- ANCHO DE ENTRADA
  -- Test signals
  signal clk_tb : std_logic := '0';
  signal rst_tb : std_logic := '0';
  signal divorciator_in_tb : std_logic_vector(WIDTH_INPUT - 1 downto 0) := (others => '0');
  signal divorced1_tb : std_logic_vector(WIDTH_RLE - 1 downto 0);
  signal divorced2_tb : std_logic_vector(WIDTH_RLE - 1 downto 0);
  signal ready_i_tb : std_logic := '0';
  signal ready_o_tb : std_logic;

begin
  -- Instantiate the unit under test (UUT)
  uut: divorciator
    generic map (
      WIDTH_INPUT => 128,
      WIDTH_RLE => 64
    )
    port map (
      clk => clk_tb,
      rst_i => rst_tb,
      divorciator_in => divorciator_in_tb,
      divorced1_o => divorced1_tb,
      divorced2_o => divorced2_tb,
      ready_i => ready_i_tb,
      ready_o => ready_o_tb
    );

  -- Clock process
  clk_process : process
  begin
    while now < 1000 ns loop
      clk_tb <= '0';
      wait for CLK_PERIOD / 2;
      clk_tb <= '1';
      wait for CLK_PERIOD / 2;
    end loop;
    wait;
  end process clk_process;

  -- Stimulus process
  stim_process : process
  begin
    -- Reset
    rst_tb <= '1';
    wait for CLK_PERIOD;
    rst_tb <= '0';
    wait for CLK_PERIOD;

    -- Provide test data and control signals
    divorciator_in_tb <= x"01010101010101010101010101010101";
    ready_i_tb <= '1';
    wait for CLK_PERIOD * 5;

    rst_tb <= '1';
    wait for CLK_PERIOD * 5;

    divorciator_in_tb <= x"01010101010101000000000000000000";
    ready_i_tb <= '0';
    wait for CLK_PERIOD * 5;
    -- Change test data and control signals
    ready_i_tb <= '1';
    wait for CLK_PERIOD * 5;

    -- Add more test scenarios as needed

    wait;
  end process stim_process;

  -- Output checking process
  check_process : process
  begin
    wait for CLK_PERIOD * 10;  -- Wait for some time for valid output data

    -- Check the output signals against the expected values
    -- Adjust the assertions based on your expected results
    assert divorced1_tb = "0101010101010101"
      report "divorced1_tb does not match the expected value" severity error;
    assert divorced2_tb = "0000000000000000"
      report "divorced2_tb does not match the expected value" severity error;
    assert ready_o_tb = '1'
      report "ready_o_tb does not match the expected value" severity error;

    -- Add more assertions to validate the outputs

    wait;
  end process check_process;

end architecture tb_arch;
