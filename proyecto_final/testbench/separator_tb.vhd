library IEEE;
use IEEE.std_logic_1164.all;

entity separator_tb is
end entity separator_tb;

architecture tb_arch of separator_tb is
  constant CLK_PERIOD : time := 10 ns;  -- Define the clock period

  -- Component declaration
  component separator
    generic (
      WIDTH_INPUT : integer := 256;
      WIDTH_ENCODER : integer := 256 / 4
    );
    port (
      clk : in std_logic;
      rst_i : in std_logic;
      separator_in : in std_logic_vector(WIDTH_INPUT - 1 downto 0);
      separated1_o : out std_logic_vector(WIDTH_ENCODER - 1 downto 0);
      separated2_o : out std_logic_vector(WIDTH_ENCODER - 1 downto 0);
      separated3_o : out std_logic_vector(WIDTH_ENCODER - 1 downto 0);
      separated4_o : out std_logic_vector(WIDTH_ENCODER - 1 downto 0);
      ready_i : in std_logic;
      ready_o : out std_logic
    );
  end component separator;
  constant WIDTH_INPUT : integer := 256; -- ANCHO DE ENTRADA
  constant WIDTH_ENCODER : integer := WIDTH_INPUT / 4 ; -- ANCHO DE ENTRADA
  -- Test signals
  signal clk_tb : std_logic := '0';
  signal rst_tb : std_logic := '0';
  signal separator_in_tb : std_logic_vector(WIDTH_INPUT - 1 downto 0) := (others => '0');
  signal separated1_tb : std_logic_vector(WIDTH_ENCODER - 1 downto 0) := (others => '0');
  signal separated2_tb : std_logic_vector(WIDTH_ENCODER - 1 downto 0) := (others => '0');
  signal separated3_tb : std_logic_vector(WIDTH_ENCODER - 1 downto 0) := (others => '0');
  signal separated4_tb : std_logic_vector(WIDTH_ENCODER - 1 downto 0) := (others => '0');
  signal ready_i_tb : std_logic := '0';
  signal ready_o_tb : std_logic;

begin
  -- INSTANCIO EL SEPARATOR
  uut: separator
    generic map (
      WIDTH_INPUT => 256,
      WIDTH_ENCODER => 64
    )
    port map (
      clk => clk_tb,
      rst_i => rst_tb,
      separator_in => separator_in_tb,
      separated1_o => separated1_tb,
      separated2_o => separated2_tb,
      separated3_o => separated3_tb,
      separated4_o => separated4_tb,
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

    -- TEST  Y SENIALES DE CONTROL
    separator_in_tb <= x"0101010101010101010101010101010101010101010101010101010101010101";
    ready_i_tb <= '1';
    wait for CLK_PERIOD * 5;

    rst_tb <= '1';
    wait for CLK_PERIOD * 5;

    separator_in_tb <= x"0101010101010101010101010101010100000000000000000000000000000000";
    ready_i_tb <= '0';
    wait for CLK_PERIOD * 5;
    -- Cambiar test data y seniales de control
    ready_i_tb <= '1';
    wait for CLK_PERIOD * 5;

    -- MAS TESTS POR LAS 

    wait;
  end process stim_process;

  -- Output TEST
  check_process : process
  begin
    wait for CLK_PERIOD * 10;  -- Wait for some time for valid output data

    -- Check the output signals against the expected values

    assert separated1_tb = "010101010101010101010101010101010"
      report "separated1_tb does not match the expected value" severity error;
    assert separated2_tb = "010101010101010101010101010101010"
      report "separated1_tb does not match the expected value" severity error;
    assert separated3_tb = "000000000000000000000000000000000"
      report "separated2_tb does not match the expected value" severity error;
    assert separated4_tb = "000000000000000000000000000000000"
      report "separated2_tb does not match the expected value" severity error;
    assert ready_o_tb = '1'
      report "ready_o_tb does not match the expected value" severity error;

    wait;
  end process check_process;

end architecture tb_arch;
