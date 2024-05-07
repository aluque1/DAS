---------------------------------------------------------------------
--
--  Fichero:
--    lab11QVGAcolor.vhd  25/5/2023
--
--    (c) J.M. Mendias
--    Diseño Automático de Sistemas
--    Facultad de Informática. Universidad Complutense de Madrid
--
--  Propósito:
--    Laboratorio 11: QVGAcolor
--
--  Notas de diseño:
--
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity lab11VGAcolor is
  port ( 
    clk    : in  std_logic;
    cctvOn : in  std_logic;
    -- VGA side
    hSync  : out  std_logic;
    vSync  : out  std_logic;
    RGB    : out  std_logic_vector(11 downto 0);
    -- Camera side    
    pClk   : in  std_logic;
    xClk   : out std_logic;
    cvSync : in  std_logic;
    hRef   : in  std_logic;
    cData  : in  std_logic_vector(7 downto 0);
    sioc   : out std_logic;
    siod   : out std_logic;
    pwdn   : out std_logic;
    rst_n  : out std_logic
  );
end lab11VGAcolor;

library ieee;
use ieee.numeric_std.all;
use work.common.all;

architecture syn of lab11VGAcolor is
   
  component frameBuffer
    port (
      clka  : in  std_logic;
      wea   : in  std_logic_vector(...);
      addra : in  std_logic_vector(...);
      dina  : in  std_logic_vector(...);
      clkb  : in  std_logic;
      addrb : in  std_logic_vector(...);
      doutb : out std_logic_vector(...)
    );
  end component;
  
  component multAdd
    port (
      a        : in  std_logic_vector(...);
      b        : in  std_logic_vector(...);
      c        : in  std_logic_vector(...);
      subtract : in  std_logic;
      p        : out std_logic_vector(...);
      pcout    : out std_logic_vector(...)
    );
  end component;  
  
  constant FREQ_KHZ : natural := 100_000;  -- frecuencia de operacion en KHz
  constant VGA_KHZ  : natural := 25_000;   -- frecuencia de envio de pixeles a la VGA en KHz
  constant FREQ_DIV : natural := FREQ_KHZ/VGA_KHZ; 
  
  constant BAUDRATE : natural := 400_000;   -- velocidad de comunicacion con el interfaz SBBC

  signal cctvOnSync, progRdy, rec, xclkRdy : std_logic;

  signal wea            : std_logic_vector(0 downto 0);
  signal wrAddr, rdAddr : std_logic_vector(16 downto 0);
  signal wrData, rdData : std_logic_vector(11 downto 0);
  
  signal wrY, rdY : std_logic_vector(8 downto 0);
  signal rdYaux   : std_logic_vector(9 downto 0);
  signal wrX, rdX : std_logic_vector(9 downto 0);
  
begin
 
  rst_n <= '1';
  pwdn  <= '0';

  xclkGenerator : freqSynthesizer
    generic map ( FREQ_KHZ => FREQ_KHZ, MULTIPLY => 1, DIVIDE => 4 )
    port map ( clkIn => clk, ready => xclkRdy, clkOut => xclk );
    
  ------------------  

  cctvOnSynchronizer : synchronizer
    generic map ( STAGES => 2, XPOL => '0' )
    port map ( clk => clk, x => cctvOn, xSync => cctvOnSync );
    
  ------------------  

  programmer : ov7670programmer
    generic map ( FREQ_KHZ => FREQ_KHZ, BAUDRATE => BAUDRATE, DEV_ID => "0100001" )
    port map ( clk  => clk, rdy => progRdy, sioc => sioc, siod => siod );  
 
  ------------------  
     
  rec <= progRdy and xclkRdy and cctvOnSync;

  videoIn: ov7670reader 
    port map ( clk => clk, rec => rec, x => wrX, y => wrY, dataRdy => wea(0), data => wrData, pClk => pClk, cvSync => cvSync, hRef => hRef, cData => cData );
    
  ------------------  

  wrAddrCalculator: multAdd
    port map ( ... );
    
  rdAddrCalculator: multAdd
    port map ( ... );
  
  videoInMemory : frameBuffer 
    port map ( ... );
    
  ------------------  
    
  videoOut : vgaRefresher
    generic map ( FREQ_DIV => FREQ_DIV )
    port map ( clk => clk, line => rdYaux, pixel => rdX, R => rdData(11 downto 8), G => rdData(7 downto 4), B => rdData(3 downto 0), hSync => hSync, vSync => vSync, RGB => RGB );
      
  rdY  <= rdYaux(8 downto 0);
             
end syn;
