---------------------------------------------------------------------
--
--  Fichero:
--    monocycleNotchFilter.vhd  14/09/2023
--
--    (c) J.M. Mendias
--    Dise�o Autom�tico de Sistemas
--    Facultad de Inform�tica. Universidad Complutense de Madrid
--
--  Prop�sito:
--    Filtro IIR de segundo orden tipo notch de caracteristicas 
--    configurables e implementaci�n monociclo
--
--  Notas de dise�o:
--    - Los coeficientes se calculan segun las especificaciones de
--      S.J. Orfanidis, "Introduction to Signal Processing" 
--
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity monocycleNotchFilter is
  generic (
    WL : natural;  -- anchura de la muestra
    QM : natural;  -- n�mero de bits decimales en la muestra
    FS : real;     -- frecuencia de muestreo
    F0 : real      -- frecuencia de corte
  );
  port(
    clk       : in    std_logic;  -- reloj del sistema
    newSample : in    std_logic;  -- indica si existe una nueva muestra que procesar
    inSample  : in    std_logic_vector(WL-1 downto 0);  -- muestra de entrada
    outSample : out   std_logic_vector(WL-1 downto 0)   -- muestra de salida
  );
end monocycleNotchFilter;

-------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.common.all;

architecture syn of monocycleNotchFilter is

  constant QN : natural := WL-QM;  -- n�mero de bits enteros en la muestra

  type signedArray is array (0 to 2) of signed(WL-1 downto 0);
  
  constant QF : real := 60.0;                            -- factor de calidad
  constant w0 : real := 2.0*MATH_PI*F0/FS;               -- frecuencia de corte en radianes/muestra
  constant k  : real := 1.0 / (1.0 + tan(w0/(2.0*QF)));  -- factor de escala 
   
  constant a : signedArray := ( 
    toFix( k, QN, QM ), 
    toFix( -2.0*k*cos(w0), QN, QM ), 
    toFix( k, QN, QM ) 
  ); 
  constant b : signedArray := ( 
    toFix(0.0, QN, QM),
    toFix(2.0*k*cos(w0), QN, QM),
    toFix(-(2.0*k - 1.0), QN, QM)
  );
 
  signal x, y : signedArray := (others => (others => '0'));
  signal acc  : signed(2*WL-1 downto 0);

begin
 
  outSample <= std_logic_vector (y(0));

  filterFU : --Esto hay que ver si se usa el toFix
  acc <= ((((a(0) * x(0)) + (a(1) * x(1))) + (a(2) * x(2))) + (b(1) * y(1))) + (b(2) * y(2));

  wrapping :
  y(0) <= acc((2*WL-1) - QN downto QM);
  
  xIni:
  --x(0) <= toFix(real(to_integer(signed (inSample))), QN, QM);--creo que esta bien pero no estoy seguro
  x(0) <= signed (inSample); --Esto a lo mejor tambien esta bien
  
  filterRegisters :
  process (clk)
  begin
    if rising_edge(clk) then
      if newSample='1' then
        x(1) <= x(0);
        x(2) <= x(1);
        y(1) <= y(0);
        y(2) <= y(1);
      end if;
    end if; 
  end process;
   
end syn;

