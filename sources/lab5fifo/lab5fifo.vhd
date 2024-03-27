---------------------------------------------------------------------
--
--  Fichero:
--    lab5.vhd  12/09/2023
--
--    (c) J.M. Mendias
--    Dise�o Autom�tico de Sistemas
--    Facultad de Inform�tica. Universidad Complutense de Madrid
--
--  Prop�sito:
--    Laboratorio 5: Loopback con FIFO
--
--  Notas de dise�o:
--
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity lab5 is
  port (
    clk    :  in std_logic;
    rst    :  in std_logic;
    RxD    :  in std_logic; 
    TxD    : out std_logic;
    TxEn   :  in  std_logic;
    leds   : out std_logic_vector(15 downto 0);
    an_n   : out std_logic_vector (3 downto 0);   -- selector de display  
    segs_n : out std_logic_vector(7 downto 0)     -- c�digo 7 segmentos
  );
END lab5;

-----------------------------------------------------------------
library ieee;
use ieee.numeric_std.all;
use work.common.all;

architecture syn of lab5 is

  constant FREQ_KHZ : natural := 100_000;  -- frecuencia de operacion en KHz
  constant BAUDRATE : natural := 1200;     -- vaelocidad de transmisi�n
  
  signal dataRx, dataTx: std_logic_vector (7 downto 0);
  signal dataRdyTx, dataRdyRx, busy, empty, full: std_logic;
  
  signal rstSync, TxEnSync : std_logic;
  signal fifostatus : std_logic_vector (3 downto 0);
  
  signal numData : std_logic_vector (3 downto 0);
  signal en : std_logic;
  
begin

  rstSynchronizer : synchronizer
    generic map ( STAGES => 2, XPOL => '0' )
    port map ( clk => clk, x => rst, xSync => rstSync );
    
  TxEnSynchronizer : synchronizer
    generic map ( STAGES => 2, XPOL => '0' )
    port map ( clk => clk, x => TxEn, xSync => TxEnSync );

  receiver: rs232receiver
    generic map ( FREQ_KHZ => FREQ_KHZ, BAUDRATE => BAUDRATE )
    port map ( clk => clk, rst => rstSync, dataRdy => dataRdyRx, data => dataRx, RxD => RxD );

  fifo : fifoQueue
    generic map ( WL => 8, DEPTH => 16 )
    port map ( clk => clk, rst => rstSync, wrE => dataRdyRx, dataIn => dataRx, rdE => dataRdyTx, dataOut => dataTx, numData => numData, full => full, empty => empty );

  dataRdyTx <= dataRdyRx and not full and TxEnSync; -- Esto puede tener fallos
   
  transmitter: rs232transmitter 
    generic map ( FREQ_KHZ => FREQ_KHZ, BAUDRATE => BAUDRATE )
    port map ( clk => clk, rst => rstSync, dataRdy => dataRdyTx, data => dataTx, busy => busy, TxD => TxD );

  fifoStatus <= X"F" when full='1' else X"E";
  
  en <= full or empty;

  numDataDecoder:
  process( numData, full )
    variable i : natural;
  begin
      leds <= ( others => '0' );
      if full='1' then
        ...
      else
        for i in 0 to 15 loop
          ...
        end loop;
       end if;
  end process;
  
  displayInterface : segsBankRefresher
    generic map ( FREQ_KHZ => FREQ_KHZ, SIZE => 4 )
    port map ( clk => clk, ens => "110"&en, bins => dataRx(7 downto 4) & dataRx(3 downto 0) & "0000" & fifoStatus, dps => "0000", an_n => an_n, segs_n => segs_n ); 
    
end syn;