-------------------------------------------------------------------
--
--  Fichero:
--    rs232receiver.vhd  12/09/2023
--
--    (c) J.M. Mendias
--    Dise�o Autom�tico de Sistemas
--    Facultad de Inform�tica. Universidad Complutense de Madrid
--
--  Prop�sito:
--    Conversor elemental de una linea serie RS-232 a paralelo con 
--    protocolo de strobe
--
--  Notas de dise�o:
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
    rst     : in  std_logic;   -- reset s�ncrono del sistema
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
    constant CYCLES : natural := (FREQ_KHZ*1000)/BAUDRATE;
    variable count  : natural range 0 to CYCLES-1 := 0;
  begin
    readRxD <= ( count = CYCLES/2-1 );
    if rising_edge(clk) then
       if baudCntCE then
         count := count + 1; --Puede que se tenga que poner mod (@ Luque seria (count + 1) mod CYCLES-1 ??)
       else
         count := 0;
       end if;
    end if;
  end process;
  
  fsmd:
  process (clk)
    variable bitPos : natural range 0 to 10 := 0;   
    variable RxDShf : std_logic_vector(9 downto 0) := (others =>'1');
  begin
    data <= RxDShf(8 downto 1); -- Nada seguro de esto @Luque lo he cambiado de data <= RxDShf
    baudCntCE <= false;
    if rising_edge(clk) then
      if rst='1' then
        RxDShf := (others => '1');
        bitPos := 0;
      else
        case bitPos is
          when 0 =>                              -- Esperando bit de start
            dataRdy <= '0';      
            if RxDSync = '0' then
                bitPos := 1;
            end if;
          when others =>                         -- Desplaza
            baudCntCE <= true;
            if readRxD then 
              if bitPos = 10 then
                dataRdy <= '1';
              end if;
              bitPos := (bitPos + 1) mod 11;     -- @Luque Cambiado esto para que tenga el mod y vuelva a 0 cuando quiera pasar a 11
              RxDShf := RxDSync & RxDShf(9 downto 1);
            end if;
        end case;
      end if;
    end if;
  end process;
  
end syn;
