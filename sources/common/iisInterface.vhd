---------------------------------------------------------------------
--
--  Fichero:
--    issInterface.vhd  14/09/2023
--
--    (c) J.M. Mendias
--    Diseño Automático de Sistemas
--    Facultad de Informática. Universidad Complutense de Madrid
--
--  Propósito:
--    Transmite/recibe muestras de sonido por un bus IIS con
--    24 bits, fs=48.8 KHz, fsclk = 64fs y fmclk=256fs
--
--  Notas de diseño:
--    - Solo válido para 100 MHz de frecuencia de reloj
--
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity iisInterface is
  generic (
    WL         : natural;  -- anchura de las muestras
    FREQ_DIV    : natural;  -- razon entre la frecuencia de reloj del sistema y 25 MHz
    UNDERSAMPLE : natural   -- factor de submuestreo 
  );
  port ( 
    -- host side
    clk       : in  std_logic;   -- reloj del sistema
    rChannel  : out std_logic;   -- en alta cuando la muestra corresponde al canal derecho; a baja cuando es el izquierdo
    newSample : out std_logic;   -- se activa durante 1 ciclo cada vez que hay un nuevo dato recibido o que enviar
    inSample  : out std_logic_vector(WL-1 downto 0);  -- muestra recibida del AudioCodec
    outSample : in  std_logic_vector(WL-1 downto 0);  -- muestra a enviar al AudioCodec
    -- IIS side
    mclk      : out std_logic;   -- master clock, 256fs
    sclk      : out std_logic;   -- serial bit clocl, 64fs
    lrck      : out std_logic;   -- left-right clock, fs
    sdti      : out std_logic;   -- datos serie hacia DACs
    sdto      : in  std_logic    -- datos serie desde ADCs
  );
end iisInterface;

---------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;

architecture syn of iisInterface is

  constant CYCLESxMCLK : natural := FREQ_DIV*UNDERSAMPLE; -- hasta 32

  signal clkNum   : natural range 0 to CYCLESxMCLK-1 := 0;  

  signal clkGen   : unsigned(8 downto 0) := (others =>'0'); 
  signal cycleNum : unsigned(2 downto 0);
  signal bitNum   : unsigned(4 downto 0);

begin

  clkGenCounter: 
  process (clk)
  begin
    ...
  end process;
   
  mclk <= ...;
  sclk <= ...;
  lrck <= ...;
  
  cycleNum <= ...;
  bitNum   <= ...);

  rChannel <= ...;
  
  -------------  

  newSample <= ...;

  outSampleShifter: 
  process (clk)
    variable sample: std_logic_vector(23 downto 0) := (others => '0');
  begin
    sdti <= sample(23);
    if rising_edge(clk) then
      ...
    end if;
  end process;
  
  inSampleShifter:
  process (clk)
    variable sample: std_logic_vector (23 downto 0) := (others => '0');
  begin
    inSample <= sample(23 downto 24-WL);
    if rising_edge(clk) then
      ...
    end if;
  end process;
  
end syn;
