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
    QM : natural;  -- número de bits decimales en la muestra
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
  constant ISS_KHZ  : natural := 25_000;   -- frecuencia de operación del interfaz ISS en KHz
  constant FREQ_DIV : natural := FREQ_KHZ/ISS_KHZ; 

  constant UNDERSAMPLE : natural := 1; 
  constant FS          : real := real(((ISS_KHZ*1000)/512)/UNDERSAMPLE); 

  constant WL : natural := 16; 
  constant QM : natural := 14; 
  constant QN : natural := WL-QM;
  
  signal   a0, b1 : signed(WL-1 downto 0); 
  constant A : real := (2.0**(QN-1))/2.0;  -- amplitud: mitad de la máxima
  
  signal rstSync     : std_logic;
  signal code, data  : std_logic_vector(7 downto 0);
  

  signal sample, outSample : std_logic_vector (WL-1 downto 0);
  signal newSample, outSampleRqt, rChannel, stdo : std_logic;
  
  signal loadSample: std_logic;
  
  signal mclk, sclk, lrck : std_logic;
  
begin

  resetSynchronizer : synchronizer
    generic map ( STAGES => 2, XPOL => '0' )
    port map ( clk => clk, x => rst, xSync => rstSync );
  
  ------------------
  
  code <= X"1C";
  data <= X"1d";
  
  b1ROM : 
  with code select
    b1 <=
      toFix( 2.0*cos(2.0*MATH_PI*261.6/FS), QN, QM ) when X"1c",  -- A = Do
      toFix( 2.0*cos(2.0*MATH_PI*277.2/FS), QN, QM ) when X"1d",  -- W = Do#
      toFix( 2.0*cos(2.0*MATH_PI*293.7/FS), QN, QM ) when X"1b",  -- S = Re
      toFix( 2.0*cos(2.0*MATH_PI*311.1/FS), QN, QM ) when X"24",  -- E = Re#
      toFix( 2.0*cos(2.0*MATH_PI*329.6/FS), QN, QM ) when X"23",  -- D = Mi
      toFix( 2.0*cos(2.0*MATH_PI*349.2/FS), QN, QM ) when X"2b",  -- F = Fa
      toFix( 2.0*cos(2.0*MATH_PI*370.0/FS), QN, QM ) when X"2c",  -- T = Fa#
      toFix( 2.0*cos(2.0*MATH_PI*392.0/FS), QN, QM ) when X"34",  -- G = Sol
      toFix( 2.0*cos(2.0*MATH_PI*415.3/FS), QN, QM ) when X"35",  -- Y = Sol#
      toFix( 2.0*cos(2.0*MATH_PI*440.0/FS), QN, QM ) when X"33",  -- H = La
      toFix( 2.0*cos(2.0*MATH_PI*466.2/FS), QN, QM ) when X"3c",  -- U = La#
      toFix( 2.0*cos(2.0*MATH_PI*493.9/FS), QN, QM ) when X"3b",  -- J = Si
      toFix( 2.0*cos(2.0*MATH_PI*523.3/FS), QN, QM ) when X"42",  -- K = Do
      X"0000" when others;   
      
  y1ROM :
  with data select
    a0 <=
      toFix( A*sin(2.0*MATH_PI*261.6/FS), QN, QM ) when X"1c",  -- A = Do
      toFix( A*sin(2.0*MATH_PI*277.2/FS), QN, QM ) when X"1d",  -- W = Do#
      toFix( A*sin(2.0*MATH_PI*293.7/FS), QN, QM ) when X"1b",  -- S = Re
      toFix( A*sin(2.0*MATH_PI*311.1/FS), QN, QM ) when X"24",  -- E = Re#
      toFix( A*sin(2.0*MATH_PI*329.6/FS), QN, QM ) when X"23",  -- D = Mi
      toFix( A*sin(2.0*MATH_PI*349.2/FS), QN, QM ) when X"2b",  -- F = Fa
      toFix( A*sin(2.0*MATH_PI*370.0/FS), QN, QM ) when X"2c",  -- T = Fa#
      toFix( A*sin(2.0*MATH_PI*392.0/FS), QN, QM ) when X"34",  -- G = Sol
      toFix( A*sin(2.0*MATH_PI*415.3/FS), QN, QM ) when X"35",  -- Y = Sol#
      toFix( A*sin(2.0*MATH_PI*440.0/FS), QN, QM ) when X"33",  -- H = La
      toFix( A*sin(2.0*MATH_PI*466.2/FS), QN, QM ) when X"3c",  -- U = La#
      toFix( A*sin(2.0*MATH_PI*493.9/FS), QN, QM ) when X"3b",  -- J = Si
      toFix( A*sin(2.0*MATH_PI*523.3/FS), QN, QM ) when X"42",  -- K = Do
      X"0000" when others;    
     
  soundGen : iirOscillator
    generic map ( WL => WL, QM => QM, FS => FS )
    port map ( clk => clk, newTone => loadSample, newSample => newSample, b1 => std_logic_vector(b1), a0 => std_logic_vector(a0), sample => sample );  

  outSample <= 
    sample;
    
  ------------------ 

  mclkAD <= mclk;
  sclkAD <= sclk;
  lrckAD <= lrck;
  
  mclkDA <= mclk;
  sclkDA <= sclk;
  lrckDA <= lrck;

  newToneCnt:
  PROCESS (clk)
    CONSTANT CYCLES : NATURAL := hz2cycles(FREQ_KHZ, 50);
    VARIABLE count : NATURAL RANGE 0 TO CYCLES - 1 := 0;
  BEGIN
    IF rising_edge(clk) THEN
      IF rstSync = '1' THEN
        count := 0;
      ELSE
        count := (count + 1) MOD CYCLES;
        loadSample <= '0';
        IF count = (CYCLES - 1) THEN
          loadSample <= '1';
        END IF;
      END IF;
    END IF;
  END PROCESS;
  
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