library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common.all;

entity iirOscillator is
  generic (
    WL : natural;  -- anchura de la muestra
    QM : natural;  -- número de bits decimales en la muestra
    FS : real      -- frecuencia de muestreo
  );
  port(
    clk       : in    std_logic;  -- reloj del sistema
    newTone   : in    std_logic;  --- indica si existe una nueva nota a generar
    b1        : in    std_logic_vector(WL-1 downto 0);  -- coeficiente
    a0        : in    std_logic_vector(WL-1 downto 0);  -- coeficiente
    newSample : in    std_logic;  -- indica si existe una nueva muestra
    sample    : out   std_logic_vector(WL-1 downto 0)   -- muestra de salida
  );
end iirOscillator;

architecture syn of iirOscillator is

  constant QN : natural := WL-QM;
  
  type signedArray is array (0 to 2) of signed(WL-1 downto 0);
  
  signal y : signedArray;
  signal acc  : signed(2*WL-1 downto 0);

  constant b2 : signed(WL-1 downto 0) := toFix( -1.0, QN, QM );
  
begin
 
  sample <= std_logic_vector(y(0));
 
  filterFU :
  acc <= signed(b1)*y(1) + b2*y(2);

  wrapping :
  y(0) <= acc(WL-1+QM downto QM);

  filterRegisters :
  process (clk)
  begin
    if rising_edge(clk) then
      if newTone='1' then
        y(1) <= signed(a0);
        y(2) <= (others => '0');
      elsif newSample='1' then
        y(1) <= y(0);
        y(2) <= y(1);
      end if;
    end if; 
  end process;
   
end syn;