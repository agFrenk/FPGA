library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fusionator is
  port (
    clk           : in std_logic;
    rst             : in std_logic;
    in_ready        : in std_logic;
    input_1         : in std_logic_vector(128-1 downto 0);  -- primer input
    size_1          : in integer;   -- size del input 1
    input_2         : in std_logic_vector(128-1 downto 0);  -- segundo input
    size_2          : in integer;   -- size del input 2
    output          : out std_logic_vector(256-1 downto 0);   -- output
    out_ready       : out std_logic
    );
end entity fusionator;

architecture structural of fusionator is
  signal output_sig : std_logic_vector(output'range) := (others => '0');  -- senial de output
  signal out_ready_sig : std_logic := '0';  -- senial para output ready

begin  -- architecture structural

  process(clk)
  begin
    if (clk'event and clk = '1' and in_ready = '1') then
      -- Why is the following code failing a bound check?
        (output_sig(
          255 downto (256 - size_1))
         ) <= input_1(128 - 1 downto (128 -size_1));
        (output_sig(
          255 - size_1 downto (256 - size_1 - size_2))
         ) <= input_2(128 - 1 downto (128 - size_2));

        out_ready_sig <= '1';
    end if;
  end process;

  output <= output_sig;
  out_ready <= out_ready_sig;

end architecture structural;
