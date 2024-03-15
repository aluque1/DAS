-------------------------------------------------------------------
--
--  Fichero:
--    rs232receiver.vhd  12/09/2023
--
--    (c) J.M. Mendias
--    Diseño Automático de Sistemas
--    Facultad de Informática. Universidad Complutense de Madrid
--
--  Propósito:
--    Conversor elemental de una linea serie RS-232 a paralelo con 
--    protocolo de strobe
--
--  Notas de diseño:
--    - Parity: NONE
--    - Num data bits: 8
--    - Num stop bits: 1
--
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity rs232receiver is
  generic (
    FREQ_KHZ : natural;  -- frecuencia de operacion en KHz
    BAUDRATE : natural   -- velocidad de comunicacion
  );
  port (
    -- host side
    clk     : in  std_logic;   -- reloj del sistema
    rst     : in  std_logic;   -- reset síncrono del sistema
    dataRdy : out std_logic;   -- se activa durante 1 ciclo cada vez que hay un nuevo dato recibido
    data    : out std_logic_vector (7 downto 0);   -- dato recibido
    -- RS232 side
    RxD     : in  std_logic    -- entrada de datos serie del interfaz RS-232
  );
end rs232receiver;

-------------------------------------------------------------------

use work.common.all;

architecture syn of rs232receiver is

  signal RxDSync : std_logic;
  signal readRxD, baudCntCE : boolean;

begin

  RxDSynchronizer : synchronizer
    generic map ( STAGES => 2, XPOL => '1' )
    port map ( clk => clk, x => RxD, xSync => RxDSync );

  baudCnt:
  process (clk)
    ...
  begin
    readRxD <= ( count = CYCLES/2-1 );
    if rising_edge(clk) then
      ...
    end if;
  end process;
  
  fsmd:
  process (clk)
    ...
  begin
    data      <= ...;
    baudCntCE <= ...;
    if rising_edge(clk) then
      if rst='1' then
        ...
      else
        case bitPos is
          when 0 =>                              -- Esperando bit de start
            dataRdy   <= '0';      
            ...
          when others =>                         -- Desplaza
            if readRxD then 
              if bitPos = 10 then
                dataRdy <= '1';
              end if;
              ...
            end if;
        end case;
      end if;
    end if;
  end process;
  
end syn;
