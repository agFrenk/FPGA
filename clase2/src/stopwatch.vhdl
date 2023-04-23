library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stopwatch is
  
  generic(
    M: natural := 4;
    clocks_to_decisecond: natural := 100001
    );
  port (
    clk_i      : in  std_logic;
    reset_i    : in  std_logic;
    stpwatch_o : out std_logic_vector(11 downto 0));

end entity stopwatch;

architecture stopwatch_architecture of stopwatch is
  signal stopwatch_intermediate : std_logic_vector(11 downto 0) ;
  signal next_carry : std_logic_vector(3 downto 0);
  signal noop : std_logic := '0';
  signal decisecond_intermediate : std_logic;

    -- import the entity to be used
    component digit is
        generic(N:natural);
        port(
            clk_i           : in std_logic;
            reset_i          : in std_logic;
            carry_i         : in std_logic;
            carry_o         : out std_logic;
            clr_o           : out std_logic_vector(N-1 downto 0) 
        );
    end component;
    component decisecond is
        generic(N:natural);
        port(
            clk_i           : in std_logic;
            reset_i          : in std_logic;
            decisecond_o      : out std_logic
        );
    end component;

begin  -- architecture stopwatch_architecture

  deciseconds: decisecond
              generic map (
                N => clocks_to_decisecond
              )
              port map (
                      clk_i => clk_i,
                      reset_i => reset_i,
                      decisecond_o => next_carry(0)
              );

   DIGITS: for i in 0 to 2 generate
       uut: digit
              generic map (
                N => M
              )
              port map (
                      clk_i => clk_i,
                      reset_i => reset_i,
                      carry_i => next_carry(i),
                      carry_o => next_carry(i+1),
                      clr_o => stopwatch_intermediate((i * 4) + 3  downto (i * 4))
              );
     end generate;

     stpwatch_o <= stopwatch_intermediate;

end architecture stopwatch_architecture;
