library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stopwatch is
  
  generic(
    M: natural := 4);
  port (
    clk_i      : in  std_logic;
    reset_i    : in  std_logic;
    stpwatch_o : out std_logic_vector(11 downto 0));

end entity stopwatch;

architecture stopwatch_architecture of stopwatch is
  signal stopwatch_intermediate : std_logic_vector(11 downto 0) ;
  signal next_carry : std_logic_vector(2 downto 0);

    -- import the entity to be used
    component digit is
        generic(N:natural);
        port(
            clk_i           : in std_logic;
            reset_i          : in std_logic;
            carry_o         : out std_logic;
            clr_o           : out std_logic_vector(N-1 downto 0) 
        );
    end component;

begin  -- architecture stopwatch_architecture

  FIRST_DIGIT: digit
              generic map (
                N => M
              )
              port map (
                      clk_i => clk_i,
                      reset_i => reset_i,
                      carry_o => next_carry(0),
                      clr_o => stopwatch_intermediate(3 downto 0)
              );

   DIGITS: for i in 1 to 2 generate
       uut: digit
        
              generic map (
                N => M
              )
              port map (
                      clk_i => next_carry(i - 1),
                      reset_i => reset_i,
                      carry_o => next_carry(i),
                      clr_o => stopwatch_intermediate((i * 4) + 3  downto (i * 4))
              );
     end generate;

     stpwatch_o <= stopwatch_intermediate;

end architecture stopwatch_architecture;
