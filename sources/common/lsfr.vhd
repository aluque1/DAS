---------------------------------------------------------------------
--
--  Fichero:
--    lsfr.vhd  24/7/2015
--
--    (c) J.M. Mendias
--    Diseño Automático de Sistemas
--    Facultad de Informática. Universidad Complutense de Madrid
--
--  Propósito:
--    Genera numeros aleatorios usando un Linear Feedback 
--    Shift-Register
--
--  Notas de diseño:
--    - La semilla no puede ser la secuencia "111...111"
--    - Vease Xilinx Application Note XAPP052
--
---------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity lsfr is
  generic(
    WL : natural   -- anchura del numero aleatorio
  );
  port(
    clk    : in  std_logic;   -- reloj del sistema
    rst    : in  std_logic;   -- reset síncrono del sistema
    ce     : in  std_logic;   -- activa la generacion de numeros aleatorios (1 por ciclo de reloj)
    ld     : in  std_logic;   -- carga la semilla
    seed   : in  std_logic_vector(WL-1 downto 0);   -- semilla
    random : out std_logic_vector(WL-1 downto 0)    -- numero aleatorio
   );
end lsfr;

-------------------------------------------------------------------

architecture syn of lsfr is

  signal shtOut      : std_logic_vector(WL-1 downto 0) := (others=>'0');
  signal feedbackBit : std_logic;

begin
   
  feedbackBit <=
    shtOut(1)  xnor shtOut(0)                                  when WL = 2  else
    shtOut(2)  xnor shtOut(1)                                  when WL = 3  else
    shtOut(3)  xnor shtOut(2)                                  when WL = 4  else
    shtOut(4)  xnor shtOut(2)                                  when WL = 5  else
    shtOut(5)  xnor shtOut(4)                                  when WL = 6  else
    shtOut(6)  xnor shtOut(5)                                  when WL = 7  else
    shtOut(7)  xnor shtOut(5)  xnor shtOut(4)  xnor shtOut(3)  when WL = 8  else
    shtOut(8)  xnor shtOut(4)                                  when WL = 9  else
    shtOut(9)  xnor shtOut(6)                                  when WL = 10 else
    shtOut(10) xnor shtOut(8)                                  when WL = 11 else
    shtOut(11) xnor shtOut(5)  xnor shtOut(3)  xnor shtOut(1)  when WL = 12 else
    shtOut(12) xnor shtOut(3)  xnor shtOut(2)  xnor shtOut(0)  when WL = 13 else
    shtOut(13) xnor shtOut(4)  xnor shtOut(2)  xnor shtOut(0)  when WL = 14 else
    shtOut(14) xnor shtOut(13)                                 when WL = 15 else
    shtOut(15) xnor shtOut(14) xnor shtOut(12) xnor shtOut(3)  when WL = 16 else
    shtOut(16) xnor shtOut(13)                                 when WL = 17 else
    shtOut(17) xnor shtOut(10)                                 when WL = 18 else
    shtOut(18) xnor shtOut(5)  xnor shtOut(1)  xnor shtOut(0)  when WL = 19 else
    shtOut(19) xnor shtOut(16)                                 when WL = 20 else
    shtOut(20) xnor shtOut(18)                                 when WL = 21 else
    shtOut(21) xnor shtOut(20)                                 when WL = 22 else
    shtOut(22) xnor shtOut(17)                                 when WL = 23 else
    shtOut(23) xnor shtOut(22) xnor shtOut(21) xnor shtOut(16) when WL = 24 else
    shtOut(24) xnor shtOut(21)                                 when WL = 25 else
    shtOut(25) xnor shtOut(5)  xnor shtOut(1)  xnor shtOut(0)  when WL = 26 else
    shtOut(26) xnor shtOut(4)  xnor shtOut(1)  xnor shtOut(0)  when WL = 27 else
    shtOut(27) xnor shtOut(24)                                 when WL = 28 else
    shtOut(28) xnor shtOut(26)                                 when WL = 29 else
    shtOut(29) xnor shtOut(5)  xnor shtOut(3)  xnor shtOut(0)  when WL = 30 else
    shtOut(30) xnor shtOut(27)                                 when WL = 31 else
    shtOut(31) xnor shtOut(21) xnor shtOut(1)  xnor shtOut(0)  when WL = 32 else
    shtOut(WL-1);

  shifter:	
  process (clk)
  begin
    if rising_edge(clk) then  
      if rst='1' then
        shtOut <= (others=>'0'); 
      elsif ld='1' then
        shtOut <= seed;
      elsif ce='1' then
        shtOut <= shtOut(shtOut'high-1 downto 0) & feedbackBit;
      end if;
    end if;
  end process;

  random <= shtOut;

end syn;
