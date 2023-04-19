library IEEE;
library UTILS;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use UTILS.TIPOS.all;

--* @brief Librería de funciones básicas
package funciones is

  --* Devuelve la mínima potencia de 2 mayor o igual a <var>N</var>
  function ceil2power (N   :    natural) return natural;
  --* Devuelve la mínima potencia de <var>radix</var> mayor o igual 
  --* a <var>N</var>
  function ceilpower (N    : in natural; radix : in natural) return natural;
  --* Devuelve un std_logic_vector de <var>int</var> ceros
  function zeros(int       : in integer) return std_logic_vector;
  --* Convierte un std_logic a un std_logic_vector(0 downto 0)
  function to_slv(sl       : in std_logic) return std_logic_vector;
  --* Convierte un natural a un std_logic_vector de largo<var>b</var> 
  function to_slv(n, b     :    natural) return std_logic_vector;
  --* Convierte un std_logic_vector(0 downto 0) a un std_logic
  function to_sl(slv       : in std_logic_vector) return std_logic;
  --* Incrementa en 1 el valor sin signo del std_logic_vector
  function increment(value : in std_logic_vector) return std_logic_vector;
  --* Incrementa en 1 un natural y lo devuelve como std_logic_vector
  function increment(value : in natural) return std_logic_vector;
  --* Incrementa en <var>amount</var> el valor sin signo del std_logic_vector
  function increment(value : in std_logic_vector; amount : in natural)
    return std_logic_vector;
  --* Decrementa en 1 el valor sin signo del std_logic_vector           
  function decrement(value : in std_logic_vector)
    return std_logic_vector;
  --* Decrementa en 1 un natural y lo devuelve como std_logic_vector           
  function decrement(value : in natural) return std_logic_vector;
  --* Decrementa en <var>amount</var> el valor sin signo del std_logic_vector
  function decrement(value : in std_logic_vector; amount : in natural)
    return std_logic_vector;
  
end package;


package body funciones is

------------------------------------------------------------------------

  function ceil2power(N : natural) return natural is

    variable m, p : natural;
  begin
    m := 0;
    p := 1;

    while p <= N loop
      m := m + 1;
      p := p * 2;
    end loop;

    return m;
    
  end ceil2power;

------------------------------------------------------------------------

  function ceilpower(N : in natural; radix : in natural) return natural is

    variable m, p : natural;
  begin
    m := 0;
    p := 1;

    while p <= N loop
      m := m + 1;
      p := p * radix;
    end loop;

    return m;
    
  end ceilpower;
------------------------------------------------------------------------

  function zeros(int : in integer) return std_logic_vector is
    variable result : std_logic_vector(int -1 downto 0);
  begin
    for index in result'range loop
      result(index) := '0';
    end loop;
    return result;
  end zeros;

------------------------------------------------------------------------

  function to_slv(sl : in std_logic) return std_logic_vector is
    
    variable result : std_logic_vector(0 downto 0);
  begin
    result(0) := sl;
    return result;
  end to_slv;

------------------------------------------------------------------------

  function to_sl(slv : in std_logic_vector) return std_logic is
    
    variable result : std_logic;
  begin
    result := slv(0);
    return result;
  end to_sl;

------------------------------------------------------------------------

  function increment(value : in std_logic_vector) return std_logic_vector is

    variable result : std_logic_vector(value'range);
  begin
    result := std_logic_vector(unsigned(value) + to_unsigned(1, value'length));
    return result;
  end increment;

------------------------------------------------------------------------

  function increment(value : in std_logic_vector; amount : in natural) return std_logic_vector is

    variable result : std_logic_vector(value'range);
  begin
    result := std_logic_vector(unsigned(value) + to_unsigned(amount, value'length));
    return result;
  end increment;
------------------------------------------------------------------------

  function decrement(value : in std_logic_vector) return std_logic_vector is

    variable result : std_logic_vector(value'range);
  begin
    result := std_logic_vector(unsigned(value) - to_unsigned(1, value'length));
    return result;
  end decrement;

---------------------------------------------------------------------------------       


  function increment(value : in natural) return std_logic_vector is
    
    variable result : std_logic_vector(ceil2power(value) - 1 downto 0);
    
  begin
    result := std_logic_vector(to_unsigned(value + 1, result'length));
    return result;
  end increment;

  ----------------------------------------------------------------------

  function decrement(value : in natural) return std_logic_vector is
    
    variable result : std_logic_vector(ceil2power(value) - 1 downto 0);
    
  begin
    result := std_logic_vector(to_unsigned(value - 1, result'length));
    return result;
  end decrement;

------------------------------------------------------------------------

  function decrement(value : in std_logic_vector; amount : in natural) return std_logic_vector is

    variable result : std_logic_vector(value'range);
  begin
    result := std_logic_vector(unsigned(value) - to_unsigned(amount, value'length));
    return result;
  end decrement;

------------------------------------------------------------------------    

  function to_slv(n, b : natural) return std_logic_vector is
    
    variable result : std_logic_vector(b - 1 downto 0);
    
  begin
    result := std_logic_vector(to_unsigned(n, result'length));
    return result;
  end to_slv;

------------------------------------------------------------------------  
end package body;
