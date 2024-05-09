---------------------------------------------------------------------
--
--  Fichero:
--    lab9.vhd  09/02/2024
--
--    (c) J.M. Mendias
--    Dise�o Autom�tico de Sistemas
--    Facultad de Inform�tica. Universidad Complutense de Madrid
--
--  Prop�sito:
--    Laboratorio 9
--
--  Notas de dise�o:
--
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity lab9 is
  port ( 
    clk     : in  std_logic;
    rst     : in  std_logic;
    ps2Clk  : inout  std_logic;
    ps2Data : inout  std_logic;
    sws     : in std_logic_vector(2 downto 0);
    hSync   : out std_logic;
    vSync   : out std_logic;
    RGB     : out std_logic_vector(3*4-1 downto 0)
  );
end lab9;

---------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use work.common.all;

architecture syn of lab9 is

  constant FREQ_KHZ : natural := 100_000;  -- frecuencia de operacion en KHz
  constant VGA_KHZ  : natural := 25_000;   -- frecuencia de envio de pixeles a la VGA en KHz
  constant FREQ_DIV : natural := FREQ_KHZ/VGA_KHZ; 
  
  constant PIXELSxLINE : natural := 640;
  constant LINESxFRAME : natural := 480;
  
  signal rstSync : std_logic;
  
  signal TxData    : std_logic_vector(7 downto 0) := (others => '0');
  signal TxDataRdy : std_logic := '0';
  
  signal RXData    : std_logic_vector(7 downto 0);
  signal RxDataRdy : std_logic;
    
  signal status   : std_logic_vector(7 downto 0) := (others => '0');
  signal x        : unsigned(log2(PIXELSxLINE)-1 downto 0) := (others => '0');
  signal y        : unsigned(log2(LINESxFRAME)-1 downto 0) := (others => '0');
  signal colorRdy : std_logic := '0';
 
  signal pixel : std_logic_vector(9 downto 0);
  signal line  : std_logic_vector(8 downto 0);

  signal RGBinterface : std_logic_vector (RGB'range);
  
begin
   
  rstSynchronizer : synchronizer
    generic map ( STAGES => 2, XPOL => '0' )
    port map ( clk => clk, x => rst, xSync => rstSync );

  ------------------  
  
  mouseInterface : ps2Interface
    generic map ( FREQ_KHZ => FREQ_KHZ )
    port map ( clk => clk, rst => rstSync, RxDataRdy => RxDataRdy, RxData => RxData, TxDataRdy => TxDataRdy, TxData => TxData, busy => open, ps2Clk => ps2Clk, ps2Data => ps2Data );

  mouseScanner : 
  process(clk)
    type states is ( sendEnable, waitACK, waitingStatus, waitingXoffset, waitingYoffset );
    variable state     : states := sendEnable;
    variable xOffset   : signed(x'range);
    variable yOffset   : signed(y'range);
  begin
    if rising_edge(clk) then
      if rstSync='1' then
        TxDataRdy <= '0';
        TxData    <= (others => '0');
        x         <= (others => '0');
        y         <= (others => '0');
        status    <= (others => '0');
        state     := sendEnable;
      else
        case state is
          when sendEnable =>
            state := waitACK;
            TxData <= X"F4";
            TxDataRdy <= '1';
          when waitACK => 
            TxDataRdy <= '0';
            if RxDataRdy='1' then
              state := waitingStatus;         
            end if;
          when waitingStatus =>
            status <= RXData;
            if RxDataRdy='1' then
                state := waitingXoffset;
            end if;
          when waitingXoffset =>
            -- xsign = status(4)
            -- ysign = status(5)
            -- xov = status(6)
            -- yov = status(7)
            xOffset := resize(signed(RxData), log2(PIXELSxLINE));
            if status(4) = '0' then
              if status(6) = '1' then
                x <= to_unsigned(PIXELSxLINE-1, log2(PIXELSxLINE));
              else
                x <= x + to_unsigned(to_integer(xOffset), log2(PIXELSxLINE));
              end if;
            else
              if status(6) = '1' then
                x <= to_unsigned(0, log2(PIXELSxLINE));
              else
                x <= x - to_unsigned(to_integer(xOffset), log2(PIXELSxLINE));
              end if;
            end if;
            if RxDataRdy='1' then
              state := waitingYoffset;
            end if;
          when waitingYoffset =>
            yOffset := resize(signed(RxData), log2(LINESxFRAME));
            if status(5) = '0' then
              if status(7) = '1' then
                y <=  to_unsigned(LINESxFRAME-1, log2(LINESxFRAME-1));
              else
                y <= y + to_unsigned(to_integer(yOffset), log2(LINESxFRAME));
              end if;
            else
              if status(7) = '1' then
                y <= to_unsigned(0, log2(LINESxFRAME - 1));
              else
                y <= y - to_unsigned(to_integer(yOffset), log2(LINESxFRAME));
              end if;
            end if;
            -- Aqui lo que pide en la diapo es que pinte si estamos pulsando el boton izquierdo del raton.
            -- Para saber si estamos pulsando el boton izquierdo del raton, miramos el bit 0 de status, LButton
            -- Supongo que es poner colorRdy a 1 si esta pulsado y a 0 si no lo esta.
            if status(0)='1' then
              colorRdy <= '1';
            else
              colorRdy <= '0';
            end if;

            if RxDataRdy='1' then
              state := waitingStatus;
            end if;
        end case;         
      end if;
    end if;
  end process;
                      
  ------------------  

  screenInterface: vgaGraphicInterface 
    generic map ( FREQ_DIV => FREQ_DIV )
    port map ( clk => clk, clear => status(1), x => std_logic_vector(x), y => std_logic_vector(y), color => sws, dataRdy => colorRdy, line => line, pixel => pixel, hSync => hSync, vSync => vSync, RGB => RGBinterface );   
 
 ------------------
 
  cursorRender:
  process (pixel, line, x,  y)
     -- Puntero 16x16: 0-negro, 1-blanco, 2-transparente
    constant SIZE : natural := 16;
    type pointerRom is array(0 to SIZE*SIZE-1) of natural range 0 to 2;
    constant rom: pointerRom := (
      0,0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
      0,1,0,2,2,2,2,2,2,2,2,2,2,2,2,2,
      0,1,1,0,2,2,2,2,2,2,2,2,2,2,2,2,
      0,1,1,1,0,2,2,2,2,2,2,2,2,2,2,2,
      0,1,1,1,1,0,2,2,2,2,2,2,2,2,2,2,
      0,1,1,1,1,1,0,2,2,2,2,2,2,2,2,2,
      0,1,1,1,1,1,1,0,2,2,2,2,2,2,2,2,
      0,1,1,1,1,1,1,1,0,2,2,2,2,2,2,2,
      0,1,1,1,1,1,0,0,0,0,2,2,2,2,2,2,
      0,1,1,1,1,1,0,2,2,2,2,2,2,2,2,2,
      0,1,0,0,1,1,0,2,2,2,2,2,2,2,2,2,
      0,0,2,2,0,1,1,0,2,2,2,2,2,2,2,2,
      0,2,2,2,0,1,1,0,2,2,2,2,2,2,2,2,
      2,2,2,2,2,0,1,1,0,2,2,2,2,2,2,2,
      2,2,2,2,2,0,1,1,0,2,2,2,2,2,2,2,
      2,2,2,2,2,2,0,0,2,2,2,2,2,2,2,2
    );
    variable xAddr : natural range 0 to 15;
    variable yAddr : natural range 0 to 15;    
  begin
    RGB <= RGBInterface;
    if unsigned(line) = y and unsigned(pixel) = x then
      xAddr := (xAddr + 1) mod 16;
      yAddr := (yAddr + 1) mod 16;
      case rom(xAddr + yAddr*SIZE) is
        when 0 => RGB <= (others => '0');
        when 1 => RGB <= (others => '1');
        when 2 => null;
      end case;
    end if;
  end process;   

end syn;