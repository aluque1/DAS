---------------------------------------------------------------------
--
--  Fichero:
--    proyecto.vhd  12/09/2023
--
--    Alejandro Luque Villegas, Javier Orbis Ramirez
--    Dise�o Autom�tico de Sistemas
--    Facultad de Inform�tica. Universidad Complutense de Madrid
--
--  Prop�sito:
--    Proyecto 
--
--  Notas de dise�o:
--
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity proyecto is
  port
  (
    clk     : in  std_logic;
    rst     : in  std_logic;
    mclkAD   : out std_logic;
    sclkAD   : out std_logic;
    lrckAD   : out std_logic;
    sdto     : in  std_logic;
    mclkDA   : out std_logic;
    sclkDA   : out std_logic;
    lrckDA   : out std_logic;
    sdti     : out std_logic
  );
end proyecto;

---------------------------------------------------------------------

library ieee;
use work.common.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

architecture syn of proyecto is
 
  component iirOscillator is
  generic (
    WL : natural;  -- anchura de la muestra
    QM : natural;  -- n�mero de bits decimales en la muestra
    FS : real      -- frecuencia de muestreo
  );
  port(
    clk       : in    std_logic;  -- reloj del sistema
    newTone   : in    std_logic;  -- indica si existe una nueva nota a generar
    b1        : in    std_logic_vector(WL-1 downto 0);  -- coeficiente
    a0        : in    std_logic_vector(WL-1 downto 0);  -- coeficiente
    newSample : in    std_logic;  -- indica si existe una nueva muestra
    sample    : out   std_logic_vector(WL-1 downto 0)   -- muestra de salida
  );
  end component;

  constant FREQ_KHZ : natural := 100_000;  -- frecuencia de operacion en KHz
  constant ISS_KHZ  : natural := 25_000;   -- frecuencia de operaci�n del interfaz ISS en KHz
  constant FREQ_DIV : natural := FREQ_KHZ/ISS_KHZ; 

  constant UNDERSAMPLE : natural := 1; 
  constant FS          : real := real(((ISS_KHZ*1000)/512)/UNDERSAMPLE); 

  constant WL : natural := 16; 
  constant QM : natural := 14; 
  constant QN : natural := WL-QM;
  
  signal   a0, b1 : signed(WL-1 downto 0); 
  constant A : real := (2.0**(QN-1))/2.0;  -- amplitud: mitad de la m�xima
  
  signal rstSync     : std_logic;
  signal ldSound     : std_logic;
  signal songPtr     : natural range 0 to 38 := 0;
  signal soundEnable : std_logic;
  signal longNote    : boolean := false;

  signal sample, outSample : std_logic_vector (WL-1 downto 0);
  signal newSample, outSampleRqt, rChannel, stdo : std_logic;
  
  signal mclk, sclk, lrck : std_logic;
  
begin

  resetSynchronizer : synchronizer
    generic map ( STAGES => 2, XPOL => '0' )
    port map ( clk => clk, x => rst, xSync => rstSync );

  a1SongRom:
  with songPtr select
    a0 <=
      toFix( A*sin(2.0*MATH_PI*659.3/FS), QN, QM ) when 0,  -- E5
      toFix( A*sin(2.0*MATH_PI*493.9/FS), QN, QM ) when 1,  -- B4
      toFix( A*sin(2.0*MATH_PI*523.3/FS), QN, QM ) when 2,  -- C5
      toFix( A*sin(2.0*MATH_PI*587.3/FS), QN, QM ) when 3,  -- D5
      toFix( A*sin(2.0*MATH_PI*523.3/FS), QN, QM ) when 4,  -- C5 
      toFix( A*sin(2.0*MATH_PI*493.9/FS), QN, QM ) when 5,  -- B4
      toFix( A*sin(2.0*MATH_PI*440.0/FS), QN, QM ) when 6,  -- A4
      toFix( A*sin(2.0*MATH_PI*440.0/FS), QN, QM ) when 7,  -- A4
      toFix( A*sin(2.0*MATH_PI*523.3/FS), QN, QM ) when 8,  -- C5
      toFix( A*sin(2.0*MATH_PI*659.3/FS), QN, QM ) when 9,  -- E5
      toFix( A*sin(2.0*MATH_PI*587.3/FS), QN, QM ) when 10,  -- D5
      toFix( A*sin(2.0*MATH_PI*523.3/FS), QN, QM ) when 11,  -- C5
      toFix( A*sin(2.0*MATH_PI*493.9/FS), QN, QM ) when 12,  -- B4
      toFix( A*sin(2.0*MATH_PI*493.9/FS), QN, QM ) when 13,  -- B4
      toFix( A*sin(2.0*MATH_PI*523.3/FS), QN, QM ) when 14,  -- C5
      toFix( A*sin(2.0*MATH_PI*587.3/FS), QN, QM ) when 15,  -- D5
      toFix( A*sin(2.0*MATH_PI*659.3/FS), QN, QM ) when 16,  -- E5
      toFix( A*sin(2.0*MATH_PI*523.3/FS), QN, QM ) when 17,  -- C5
      toFix( A*sin(2.0*MATH_PI*440.0/FS), QN, QM ) when 18,  -- A4
      toFix( A*sin(2.0*MATH_PI*440.0/FS), QN, QM ) when 19,  -- A4
      toFix( A*sin(2.0*MATH_PI*587.3/FS), QN, QM ) when 20,  -- D5
      toFix( A*sin(2.0*MATH_PI*698.5/FS), QN, QM ) when 21,  -- F5
      toFix( A*sin(2.0*MATH_PI*880.0/FS), QN, QM ) when 22,  -- A5
      toFix( A*sin(2.0*MATH_PI*783.9/FS), QN, QM ) when 23,  -- G5
      toFix( A*sin(2.0*MATH_PI*698.5/FS), QN, QM ) when 24,  -- F5
      toFix( A*sin(2.0*MATH_PI*659.3/FS), QN, QM ) when 25,  -- E5
      toFix( A*sin(2.0*MATH_PI*523.3/FS), QN, QM ) when 26,  -- C5
      toFix( A*sin(2.0*MATH_PI*659.3/FS), QN, QM ) when 27,  -- E5
      toFix( A*sin(2.0*MATH_PI*587.3/FS), QN, QM ) when 28,  -- D5
      toFix( A*sin(2.0*MATH_PI*523.3/FS), QN, QM ) when 29,  -- C5
      toFix( A*sin(2.0*MATH_PI*493.9/FS), QN, QM ) when 30,  -- B4
      toFix( A*sin(2.0*MATH_PI*493.9/FS), QN, QM ) when 31,  -- B4
      toFix( A*sin(2.0*MATH_PI*523.3/FS), QN, QM ) when 32,  -- C5
      toFix( A*sin(2.0*MATH_PI*587.3/FS), QN, QM ) when 33,  -- D5
      toFix( A*sin(2.0*MATH_PI*659.3/FS), QN, QM ) when 34,  -- E5
      toFix( A*sin(2.0*MATH_PI*523.3/FS), QN, QM ) when 35,  -- C5
      toFix( A*sin(2.0*MATH_PI*440.0/FS), QN, QM ) when 36,  -- A4
      toFix( A*sin(2.0*MATH_PI*440.0/FS), QN, QM ) when 37,  -- A4
      X"0000" when others;  
    
  b1SongRom:
  with songPtr select
    b1 <=
      toFix( 2.0*cos(2.0*MATH_PI*659.3/FS), QN, QM ) when 0,  -- E5
      toFix( 2.0*cos(2.0*MATH_PI*493.9/FS), QN, QM ) when 1,  -- B4
      toFix( 2.0*cos(2.0*MATH_PI*523.3/FS), QN, QM ) when 2,  -- C5
      toFix( 2.0*cos(2.0*MATH_PI*587.3/FS), QN, QM ) when 3,  -- D5
      toFix( 2.0*cos(2.0*MATH_PI*523.3/FS), QN, QM ) when 4,  -- C5 
      toFix( 2.0*cos(2.0*MATH_PI*493.9/FS), QN, QM ) when 5,  -- B4
      toFix( 2.0*cos(2.0*MATH_PI*440.0/FS), QN, QM ) when 6,  -- A4
      toFix( 2.0*cos(2.0*MATH_PI*440.0/FS), QN, QM ) when 7,  -- A4
      toFix( 2.0*cos(2.0*MATH_PI*523.3/FS), QN, QM ) when 8,  -- C5
      toFix( 2.0*cos(2.0*MATH_PI*659.3/FS), QN, QM ) when 9,  -- E5
      toFix( 2.0*cos(2.0*MATH_PI*587.3/FS), QN, QM ) when 10,  -- D5
      toFix( 2.0*cos(2.0*MATH_PI*523.3/FS), QN, QM ) when 11,  -- C5
      toFix( 2.0*cos(2.0*MATH_PI*493.9/FS), QN, QM ) when 12,  -- B4
      toFix( 2.0*cos(2.0*MATH_PI*493.9/FS), QN, QM ) when 13,  -- B4
      toFix( 2.0*cos(2.0*MATH_PI*523.3/FS), QN, QM ) when 14,  -- C5
      toFix( 2.0*cos(2.0*MATH_PI*587.3/FS), QN, QM ) when 15,  -- D5
      toFix( 2.0*cos(2.0*MATH_PI*659.3/FS), QN, QM ) when 16,  -- E5
      toFix( 2.0*cos(2.0*MATH_PI*523.3/FS), QN, QM ) when 17,  -- C5
      toFix( 2.0*cos(2.0*MATH_PI*440.0/FS), QN, QM ) when 18,  -- A4
      toFix( 2.0*cos(2.0*MATH_PI*440.0/FS), QN, QM ) when 19,  -- A4
      toFix( 2.0*cos(2.0*MATH_PI*587.3/FS), QN, QM ) when 20,  -- D5
      toFix( 2.0*cos(2.0*MATH_PI*698.5/FS), QN, QM ) when 21,  -- F5
      toFix( 2.0*cos(2.0*MATH_PI*880.0/FS), QN, QM ) when 22,  -- A5
      toFix( 2.0*cos(2.0*MATH_PI*783.9/FS), QN, QM ) when 23,  -- G5
      toFix( 2.0*cos(2.0*MATH_PI*698.5/FS), QN, QM ) when 24,  -- F5
      toFix( 2.0*cos(2.0*MATH_PI*659.3/FS), QN, QM ) when 25,  -- E5
      toFix( 2.0*cos(2.0*MATH_PI*523.3/FS), QN, QM ) when 26,  -- C5
      toFix( 2.0*cos(2.0*MATH_PI*659.3/FS), QN, QM ) when 27,  -- E5
      toFix( 2.0*cos(2.0*MATH_PI*587.3/FS), QN, QM ) when 28,  -- D5
      toFix( 2.0*cos(2.0*MATH_PI*523.3/FS), QN, QM ) when 29,  -- C5
      toFix( 2.0*cos(2.0*MATH_PI*493.9/FS), QN, QM ) when 30,  -- B4
      toFix( 2.0*cos(2.0*MATH_PI*493.9/FS), QN, QM ) when 31,  -- B4
      toFix( 2.0*cos(2.0*MATH_PI*523.3/FS), QN, QM ) when 32,  -- C5
      toFix( 2.0*cos(2.0*MATH_PI*587.3/FS), QN, QM ) when 33,  -- D5  
      toFix( 2.0*cos(2.0*MATH_PI*659.3/FS), QN, QM ) when 34,  -- E5
      toFix( 2.0*cos(2.0*MATH_PI*523.3/FS), QN, QM ) when 35,  -- C5
      toFix( 2.0*cos(2.0*MATH_PI*440.0/FS), QN, QM ) when 36,  -- A4
      toFix( 2.0*cos(2.0*MATH_PI*440.0/FS), QN, QM ) when 37,  -- A4
      X"0000" when others;
      
 
  longNote <= true when 
    songPtr = 0 or
    songPtr = 3 or
    songPtr = 6 or
    songPtr = 9 or
    songPtr = 12 or
    songPtr = 15 or
    songPtr = 16 or
    songPtr = 17 or
    songPtr = 18 or
    songPtr = 19 or
    songPtr = 20 or
    songPtr = 21 or
    songPtr = 22 or
    songPtr = 25 or
    songPtr = 27 or
    songPtr = 30 or
    songPtr = 33 or
    songPtr = 34 or
    songPtr = 35 or
    songPtr = 36 or
    songPtr = 37
    else false;
  
  
  songPulse :
  PROCESS (clk)
    CONSTANT CYCLES : NATURAL := ms2cycles(FREQ_KHZ, 250);
    VARIABLE count : NATURAL RANGE 0 TO CYCLES - 1 := 0;
  BEGIN
    IF rising_edge(clk) THEN
      IF rstSync = '1' THEN
        count := 0;
        ldSound <= '0';
        songPtr <= 0;  
      else
        count := (count + 1) MOD CYCLES;
        IF count = (CYCLES - 1) THEN
          ldSound <= not ldSound;
          if ldSound = '0' then
            songPtr <= (songPtr + 1) mod 38;
          end if;
        elsif count = (CYCLES / 2) and not longNote then
          if ldSound = '0' then
            songPtr <= (songPtr + 1) mod 38;
            ldSound <= '1';
          end if;
        END IF;
      END IF;
    END IF;
  END PROCESS;
     
  soundGen : iirOscillator
    generic map ( WL => WL, QM => QM, FS => FS )
    port map ( clk => clk, newTone => ldSound, newSample => newSample, b1 => std_logic_vector(b1), a0 => std_logic_vector(a0), sample => sample );  

  outSample <= sample ;
    
  ------------------ 

  mclkAD <= mclk;
  sclkAD <= sclk;
  lrckAD <= lrck;
  
  mclkDA <= mclk;
  sclkDA <= sclk;
  lrckDA <= lrck;

  codecInterface : iisInterface
    generic map( WL => WL,  FREQ_DIV => FREQ_DIV,  UNDERSAMPLE => UNDERSAMPLE ) 
    port map( 
      clk => clk, rChannel => rChannel, newSample => newSample, inSample => open, outSample => outSample,
      mclk => mclk, sclk => sclk, lrck => lrck, sdti => sdti, sdto => sdto
    );
   
end syn;


library ieee;
use ieee.std_logic_1164.all;

entity iirOscillator is
  generic (
    WL : natural;  -- anchura de la muestra
    QM : natural;  -- n�mero de bits decimales en la muestra
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

-------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use work.common.all;

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
