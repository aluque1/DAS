-------------------------------------------------------------------
--
--  Fichero:
--    ov7670Programmer.vhd  24/05/2023
--
--    (c) J.M. Mendias
--    Dise�o Autom�tico de Sistemas
--    Facultad de Inform�tica. Universidad Complutense de Madrid
--
--  Prop�sito:
--    Configura una camara ov7670 a traves del bus SBBC
--
--  Notas de dise�o:
--    - 2-wire SBBC
--    - tama�o VGA, modo RGB 4:4:4
--
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ov7670programmer is
  generic (
    FREQ_KHZ : natural;                        -- frecuencia de operacion en KHz
    BAUDRATE : natural;                        -- velocidad de comunicacion
    DEV_ID   : std_logic_vector (6 downto 0)   -- direcci�n SCCB (7 bits) de la camara
  );
  port ( 
    -- host side
    clk  : in  std_logic;         -- reloj del sistema
    rdy  : out std_logic;         -- indica si la programaci�n ha finalizado
    -- SSCB side
    sioc : out std_logic := '0';  -- reloj serie
    siod : out std_logic := '0'   -- datos serie
  );
end ov7670programmer;

---------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use work.common.all;

architecture syn of ov7670programmer is

  type t_conf is record
    reg  : std_logic_vector(7 downto 0);
    data : std_logic_vector(7 downto 0);
  end record t_conf;
 
  constant PROG_LEN : natural := 35;
  
  type romType is array (0 to PROG_LEN-1) of t_conf;
  
  signal confROM : romType := (
    ( X"12", X"80" ),  -- COM7   Reset
    ( X"12", X"04" ),  -- COM7   Salida RGB, VGA
    ( X"40", X"F0" ),  -- COM15  habilita rango completo de salida, RGB444 
    ( X"8C", X"02" ),  -- RGB444 habilita RGB444, formato xRGB   
    ( X"3C", X"00" ),  -- COM12  No HREF cuando VSYNC en baja   
    ( X"11", X"00" ),  -- CLKRC  Usar directamente xClk para generar pClk 
    ( X"6B", X"00" ),  -- DBLV   Bypass PLL, pClk = 25 MHz 30 fps
    ( X"3A", X"00" ),  -- TSLB   Imagen normal (no negativa)
    ( X"1E", X"10" ),  -- MVFP   Imagen invertida verticalmente
    ( X"4F", X"B3" ),  -- MTX1   Valores de la matriz de conversi�n de color
    ( X"50", X"B3" ),  -- MTX2 
    ( X"51", X"00" ),  -- MTX3 
    ( X"52", X"3D" ),  -- MTX4 
    ( X"53", X"A7" ),  -- MTX5 
    ( X"54", X"E4" ),  -- MTX6
    ( X"58", X"9E" ),  -- MTXS   Signo de la matriz y autocontraste   
    ( X"7A", X"20" ),  -- SLOP   Valores de curva gamma 
    ( X"7B", X"10" ),  -- GAM1
    ( X"7C", X"1E" ),  -- GAM2 
    ( X"7D", X"35" ),  -- GAM3 
    ( X"7E", X"5A" ),  -- GAM4 
    ( X"7F", X"69" ),  -- GAM5 
    ( X"80", X"76" ),  -- GAM6 
    ( X"81", X"80" ),  -- GAM7 
    ( X"82", X"88" ),  -- GAM8 
    ( X"83", X"8F" ),  -- GAM9 
    ( X"84", X"96" ),  -- GAM10 
    ( X"85", X"A3" ),  -- GAM11 
    ( X"86", X"AF" ),  -- GAM12 
    ( X"87", X"C4" ),  -- GAM13 
    ( X"88", X"D7" ),  -- GAM14 
    ( X"89", X"E8" ),  -- GAM15 
    ( X"3D", X"C0" ),  -- COM13  Habilita gamma y autoajuste UV   
    ( X"69", X"06" ),  -- GFIX   Ganancia RGB
    ( X"B0", X"84" )   -- RSVD   Valor m�gico encontrado en internet imprescindible para buen color        
  ); 
      
  -- Tiempos de operaci�n (en ciclos de reloj) de la camara 
  constant POWERUP_CYCLES : natural := ms2cycles(FREQ_KHZ, 2);  -- tiempo de arranque de la camara
  constant SWRST_CYCLES   : natural := ms2cycles(FREQ_KHZ, 1);  -- tiempo de espera entre tramas, para que act�e el sw reset
  
  constant SCK_CYCLES     : natural := (FREQ_KHZ*1000)/BAUDRATE;   -- tiempo de transmisi�n de 1b
  constant QSCK_CYCLES    : natural := SCK_CYCLES/4;               -- dividido entre 4

  --Tipos de trama SCCB
  constant RD : std_logic := '1';
  constant WR : std_logic := '0'; 
  constant FRAME_LEN : natural := 3*9;
  
begin

  fsmdt : 
  process(clk)
    type states is ( initial, loadFrame, start1, start2, wr1, wr2, wr3, wr4, stop1, stop2, check, idle );
    variable state: states := initial;
    variable numCycles : natural range 0 to POWERUP_CYCLES := POWERUP_CYCLES;
    variable bitPos    : natural range 0 to FRAME_LEN := 0;   
    variable shifter   : std_logic_vector(FRAME_LEN-1 downto 0) := (others => '0');
    variable addr      : natural range 0 to PROG_LEN := 0;
  begin
    if state=idle then
      rdy <= '1';
    else
      rdy <= '0';
    end if; 
    case state is
      when initial | loadFrame | check | idle =>
        sioc <= '1';
        siod <= '1';      
      when start1 | stop2 =>
        sioc <= '1';
        siod <= '0';
      when start2 | stop1 =>
        sioc <= '0';
        siod <= '0';
      when wr1 | wr4 =>
        sioc <= '0';
        siod <= shifter(26);
      when wr2 | wr3 =>
        sioc <= '1';
        siod <= shifter(26);
    end case;
    if rising_edge(clk) then
      if numCycles/=0 then
        numCycles := numCycles-1;
      else
        case state is       
          when initial =>                  -- Power on
            state     := loadFrame;
            numCycles := SWRST_CYCLES;
          when loadFrame =>                -- Carga trama
            state     := start1;
            numCycles := QSCK_CYCLES;
            shifter   := (DEV_ID & WR & "0") & (confRom( addr ).reg & "0") & (confRom( addr ).data & "0"); -- MSB first
            addr      := addr+1;
            bitPos    := 0;
          when start1 =>
            state := start2;
            numCycles := QSCK_CYCLES;
          when start2 =>
            state := wr1;
            numCycles := QSCK_CYCLES;
          when wr1 =>
            state := wr2;
            numCycles := QSCK_CYCLES;
          when wr2 =>
            state := wr3;
            numCycles := QSCK_CYCLES;
          when wr3 =>
            state := wr4;
            numCycles := QSCK_CYCLES;
          when wr4 =>
            if bitPos < 27 then
              state := wr1;
              shifter := shifter(25 downto 0) & '1';
              bitPos := bitPos + 1;
            elsif bitPos = 27 then
              state := stop1;
              numCycles := QSCK_CYCLES;
            end if;
          when stop1 => 
            state := stop2;
            numCycles := QSCK_CYCLES;
          when stop2 => 
            state := check;
          when check => 
            if addr < 35 then
              state := loadFrame;
            elsif addr = 35 then
              state := idle;
            end if; 
          when idle =>
            state := idle;
        end case;
      end if;
    end if;
  end process;
    
end syn;
