-------------------------------------------------------------------
--
--  Fichero:
--    ov7670colorReader.vhd  08/06/2023
--
--    (c) J.M. Mendias
--    Diseño Automático de Sistemas
--    Facultad de Informática. Universidad Complutense de Madrid
--
--  Propósito:
--    Captura vídeo desde una camara ov7670
--
--  Notas de diseño:
--    - tamaño VGA, modo RGB 4:4:4
--
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ov7670reader is
  port ( 
    -- host side
    clk      : in  std_logic;  -- reloj del sistema    
    rec      : in  std_logic;  -- captura video mientras esta activa
    -- frame buffer side
    y        : out std_logic_vector (8 downto 0);    -- coordenada vertical del pixel (0: arriba)
    x        : out std_logic_vector (9 downto 0);    -- coordenada horizontal del pixel (0: izquierda)
    dataRdy  : out std_logic;                        -- se activa durante 1 ciclo cada vez que ha recibido un nuevo pixel
    data     : out std_logic_vector (11 downto 0);   -- color del pixel recibido
    frameRdy : out std_logic;                        -- se activa durante 1 ciclo cada vez que ha recibido una nueva frame
    -- ov7670 video side
    pclk     : in  std_logic;                        -- reloj de pixel
    cvSync   : in  std_logic;                        -- sincronizacion vertical
    href     : in  std_logic;                        -- se activa durante la transmisión de un frame horizontal
    cData    : in  std_logic_vector (7 downto 0)     -- muestra recibida del sensor de imagen   
  );
end ov7670reader;

---------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use work.common.all;

architecture syn of ov7670reader is
        
  -- Señales
  signal cDataD : std_logic_vector (7 downto 0); 
  signal pclkD, hrefD  : std_logic;
  signal pclkRise, cvSyncRise : std_logic; 

begin
  
  inputsDelayer:
  process ( clk )
    variable aux0, aux1: std_logic_vector (8 downto 0) := (others => '0');
  begin 
    hrefD  <= aux1(8);
    cDataD <= aux1(7 downto 0);
    if rising_edge(clk) then
      aux1 := aux0;
      aux0 := href & cData;
    end if;
  end process;
  
  pclkEdgeDetector : edgeDetector
    generic map ( XPOL => '0' )
    port map ( clk => clk, x => pclk, xFall => open, xRise => pclkRise );
  
  cvSyncEdgeDetector : edgeDetector
    generic map ( XPOL => '0' )
    port map ( clk => clk, x => cvSync, xFall => open, xRise => cvSyncRise );
    
  frameRdy <= cvSyncRise and rec;
  
  reader : 
  process( clk )
    variable nibble  : std_logic_vector(3 downto 0) := (others => '0');
    variable byteCnt : unsigned(10 downto 0)        := (others => '0');
    variable lineCnt : unsigned(8 downto 0)         := (others => '0');
  begin
    if rising_edge(clk) then
      if cvSyncRise='1'and rec='1' then
        nibble := (others => '0');
        byteCnt := (others => '0');
        lineCnt := (others => '0');
      else
        if hRef='1' and pclkRise='1' and rec='1' then
          nibble := cData(3 downto 0);
          byteCnt := (byteCnt + 1) mod 1280;
        end if;
        data <= nibble & cData;
        x <= std_logic_vector(byteCnt(10 downto 1));
        if hRef='1' and pclkRise='1' and rec='1' and byteCnt(0)='1' then
          dataRdy <= '1';
        else
          dataRdy <= '0';
        end if;
        y <= std_logic_vector(lineCnt);
      end if;
    end if;
  end process;
  
end syn;