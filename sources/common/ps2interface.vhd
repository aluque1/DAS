-------------------------------------------------------------------
--
--  Fichero:
--    ps2interface.vhd  14/02/2024
--
--    (c) J.M. Mendias
--    Diseï¿½o Automï¿½tico de Sistemas
--    Facultad de Informï¿½tica. Universidad Complutense de Madrid
--
--  Propï¿½sito:
--    Interfaz bidireccional con un dispositivo PS2
--
--  Notas de diseï¿½o:
--    - No chequea paraidad en recepcion
--
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ps2interface is
  generic(
    FREQ_KHZ  : natural    -- frecuencia de operacion en KHz
  );
  port (
    -- host side
    clk        : in  std_logic;   -- reloj del sistema
    rst        : in  std_logic;   -- reset sï¿½ncrono del sistema      
    RxDataRdy  : out std_logic;   -- se activa durante 1 ciclo cada vez que hay un nuevo dato recibido
    RxData     : out std_logic_vector (7 downto 0);   -- dato recibido
    TxDataRdy  : in  std_logic;   -- se activa durante 1 ciclo cada vez que hay un nuevo dato a transmitir   
    TxData     : in  std_logic_vector (7 downto 0);   -- dato a transmitir
    busy       : out std_logic;   -- se activa mientras esta transmitiendo
    -- PS2 side
    ps2Clk     : inout  std_logic;   -- reloj del interfaz PS2
    ps2Data    : inout  std_logic    -- datos serie del interfaz PS2
  );
end ps2interface;

-------------------------------------------------------------------

use work.common.all;

architecture syn of ps2interface is
  
  signal ps2ClkSync, ps2DataSync, ps2ClkFall, ps2ClkRise : std_logic;
  signal TxParity : std_logic;
    
begin

  ps2ClkSynchronizer : synchronizer
    generic map ( STAGES => 2, XPOL => '1' )
    port map ( clk => clk, x => ps2Clk, xSync => ps2ClkSync );

  ps2ClkEdgeDetector : edgeDetector
    generic map ( XPOL => '1' )
    port map ( clk => clk, x => ps2ClkSync, xFall => ps2ClkFall, xRise => ps2ClkRise );

------------------

  ps2DataSynchronizer : synchronizer
    generic map ( STAGES => 2, XPOL => '1' )
    port map ( clk => clk, x => ps2Data, xSync => ps2DataSync );

------------------
      
  TxOddParityGenerator :
  process (TxData)
    variable aux : std_logic;
  begin
    aux := TxData(0);
    for i in 1 to 7 loop
      aux := aux xor TxData(i);
    end loop;
    TxParity <= not aux;
  end process;
  
------------------
-- Revisar todo esto de aqui, creo que esta bien pero por si acaso.
  fsmdt:
  process (clk)
    type states is ( idle, receiving, clkDown, dataDown, waitingClkRise, sending );
    variable state     : states := idle;
    variable numCycles : natural := 0;
    variable bitPos    : natural range 0 to 10 := 0;
    variable shifter   : std_logic_vector (10 downto 0) := (others => '0');
  begin
  
    RxData <= shifter(8 downto 1);
    case state is
      when idle | receiving =>
        ps2Clk  <= 'Z';
        ps2Data <= 'Z';
        busy <= '0';            
      when clkDown => 
        ps2Clk <= '0';
        ps2Data <= 'Z';
        busy <= '1';
      when dataDown =>
        ps2Clk <= '0';
        ps2Data <= shifter(0); -- Revisar, esto puede que sea shifter(bitPos)
        busy <= '1';
      when waitingClkRise =>
        ps2Clk <= 'Z';
        ps2Data <= shifter(0); -- Igual que lo de arriba
        busy <= '1';
      when sending =>
        ps2Clk <= 'Z';
        ps2Data <= shifter(0); -- Igual que lo de arriba
        busy <= '1';
    end case; 
    
    if rising_edge(clk) then
      if rst='1' then
        state     := idle;
        numCycles := 0;
        shifter   := (others => '0');
      elsif numCycles /= 0 then
        numCycles := numCycles - 1;
      else
        case state is
          when idle =>         
            RxDataRdy <= '0';
            if txDataRdy='1' then
              state     := clkDown;
              numCycles := us2cycles(FREQ_KHZ, 100);
              shifter   := "1" & TxParity & TxData & "0";
              bitPos    := 0;
            elsif ps2ClkFall='1' then
              state     := receiving;
              shifter   := (others => '0');
              bitPos    := 1;
            end if;
          when receiving =>     
            if ps2ClkFall='1' and bitPos < 10 then
              shifter := ps2DataSync & shifter(10 downto 1); -- REVISAR esto lo he cambiado porque se quejaba de tamaño aunque en las diapos dice que es 9 downto 1
              bitPos := bitPos + 1 mod 11;
            elsif ps2ClkFall='1' and bitPos = 10 then
              state := idle;
              shifter := ps2DataSync & shifter(10 downto 1); -- REVISAR esto lo he cambiado porque se quejaba de tamaño aunque en las diapos dice que es 9 downto 1
              RxDataRdy <= '1';
            end if;
          when clkDown =>
            state     := dataDown;
            numCycles := us2cycles(FREQ_KHZ, 20);
          when dataDown =>
            state     := waitingClkRise;
            -- numCycles := us2cycles(FREQ_KHZ, 20); -- Por si acaso pero creo que se hace en el estado anterior
          when waitingClkRise =>
            if ps2ClkRise='1' then
              state   := sending;
            end if;
          when sending =>
            if ps2ClkRise='1' and bitPos < 10 then
              shifter := '1'&shifter(10 downto 1);
              bitPos := bitPos + 1 mod 11;
            elsif ps2ClkRise='1' and bitPos = 10 then
              state := idle;
            end if;
        end case;
      end if;
    end if;
    
  end process;

end syn;
 
  