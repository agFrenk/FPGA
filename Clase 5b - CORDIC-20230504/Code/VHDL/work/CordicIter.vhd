library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cordic_iter is
  generic(
    N     : natural := 8;  --Ancho de la palabra
    SHIFT : natural := 1); --Desplazamiento
  port(
    clk   : in std_logic;
    rst   : in std_logic;
    en_i  : in std_logic;               		 -- enable valid value por supuesto
    xi    : in std_logic_vector (N-1 downto 0);  -- X_i que entra
    yi    : in std_logic_vector (N-1 downto 0);  -- Y_i que entra
    zi    : in std_logic_vector (N-1 downto 0);  -- Valor resultante de la
                                                 -- cuenta del angulo
    ci    : in std_logic_vector (N-1 downto 0);  -- Angulo de la tabla en pos i
    dv_o  : out std_logic;              		 -- Salida valida??? mmm que
                                                 -- picara!! a ver O_o !!
    xip1  : out std_logic_vector (N-1 downto 0); -- X salida
    yip1  : out std_logic_vector (N-1 downto 0); -- Y salida
    zip1  : out std_logic_vector (N-1 downto 0)  -- Z salida
  );
end entity;

architecture strcutural of cordic_iter is

  signal di : integer := 0;  -- Signo para determinar si se suma o resta
  signal wire_z : signed(zi'range) := (others => '0');
  signal wire_y : signed(yi'range) := (others => '0');
  signal wire_x : signed(xi'range) := (others => '0');
  
begin

  process(clk)
  begin
    if (clk'event and clk = '1') then

      if signed(zi) > -1 then           -- di = 1
        wire_x <= signed(xi) - signed(shift_right(signed(yi) , SHIFT));
        wire_y <= signed(yi) + signed(shift_right(signed(xi) , SHIFT));
        wire_z <= signed(zi) - signed(shift_right(signed(ci), SHIFT));
      else -- di = -1
        wire_x <= signed(xi) + signed(shift_right(signed(yi) , SHIFT));
        wire_y <= signed(yi) - signed(shift_right(signed(xi) , SHIFT));
        wire_z <= signed(zi) + signed(shift_right( signed(ci), SHIFT));
      end if;
    end if;
  end process;

  xip1 <= std_logic_vector(wire_x);
  yip1 <= std_logic_vector(wire_y);
  zip1 <= std_logic_vector(wire_z);
  dv_o <= en_i;


end architecture;
