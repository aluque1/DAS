---------------------------------------------------------------------
--
--  Fichero:
--    lab4.vhd  12/09/2023
--
--    (c) J.M. Mendias
--    Dise�o Autom�tico de Sistemas
--    Facultad de Inform�tica. Universidad Complutense de Madrid
--
--  Prop�sito:
--    Laboratorio 4
--
--  Notas de dise�o:
--
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity lab4 is
  port
  (
    clk     : in  std_logic;
    rst     : in  std_logic;
    ps2Clk  : in  std_logic;
    ps2Data : in  std_logic;
    speaker : out std_logic;
    an_n    : out std_logic_vector (3 downto 0);
    segs_n  : out std_logic_vector(7 downto 0)
  );
end lab4;

---------------------------------------------------------------------

use work.common.all;

architecture syn of lab4 is

  constant FREQ_KHZ : natural := 100_000;        -- frecuencia de operacion en KHz
  constant FREQ_HZ  : natural := FREQ_KHZ*1000;  -- frecuencia de operacion en Hz
  
  -- Registros  

  signal code       : std_logic_vector(7 downto 0) := (others => '0');
  signal speakerTFF : std_logic := '0';
  
  -- Se�ales
  
  signal rstSync     : std_logic;
  signal dataRdy     : std_logic;
  signal ldCode      : std_logic;
  signal halfPeriod  : natural;
  signal data        : std_logic_vector(7 downto 0);
  signal soundEnable : std_logic;

  -- Descomentar para instrumentar el dise�o
  -- attribute mark_debug : string;
  -- attribute mark_debug of ps2Clk  : signal is "true";
  -- attribute mark_debug of ps2Data : signal is "true";
  -- attribute mark_debug of dataRdy : signal is "true";
  -- attribute mark_debug of data    : signal is "true";

begin

   resetSynchronizer : synchronizer
    ...

 ------------------
 
  ps2KeyboardInterface : ps2receiver
    ...

  codeRegister :
  process (clk)
  begin
    if rising_edge(clk) then
      ...
    end if; 
  end process;
   
  halfPeriodROM :
  with code select
    halfPeriod <=
      FREQ_HZ/(2*262) when X"1c",  -- A = Do
      ...             when X"1d",  -- W = Do#
      ...             when ...  ,  -- S = Re
      ...             when ...  ,  -- E = Re#
      ...             when ...  ,  -- D = Mi
      ...             when ...  ,  -- F = Fa
      ...             when ...  ,  -- T = Fa#
      ...             when ...  ,  -- G = Sol
      ...             when ...  ,  -- Y = Sol#
      ...             when ...  ,  -- H = La
      ...             when ...  ,  -- U = La#
      ...             when ...  ,  -- J = Si
      ...             when ...  ,  -- K = Do
      0 when others;    
    
  cycleCounter :
  process (clk)
    variable count : natural := 0;
  begin
    if rising_edge(clk) then
      ...
    end if; 
  end process;
  
  fsm:
  process (clk, dataRdy, data, code)
    type states is (S0, S1, S2, S3); 
    variable state: states := S0;
  begin 
    soundEnable <= '0';
    case state is
      when S0 =>
        if dataRdy = '1' and data != X"F0" then
          ldCode = '1';
        end if;
      when S1 =>
        soundEnable <= '1';
      when S2 =>
        soundEnable <= '1';
      when S3 =>
        soundEnable <= '0';
    end case;

    if rising_edge(clk) then
      if rst = '1' then
        state := S0;
      else
        case state is
          when S0 =>
            if dataRdy = '1' and data != X"F0" then
              state := S1;
            elsif dataRdy = '1' and data = X"F0" then
              state := S3;
            end if;
          when S1 =>
            if dataRdy = '1' and data = X"F0" then
              state := S2;
            end if;
          when S2 =>
            if dataRdy = '1' and data != code then
              state := S1;
            elsif dataRdy = '1' and data = code then
              state := S0;
            end if;
          when S3 =>
            if  dataRdy = '1' them
              state := S0;
            end if;
        end case;
      end if;
    end if;
  end process;  
  
  speaker <= 
    speakerTFF when ... else ...;

  displayInterface : segsBankRefresher
    ...
  
end syn;
