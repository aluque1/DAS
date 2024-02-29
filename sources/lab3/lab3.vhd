---------------------------------------------------------------------
--
--  Fichero:
--    lab3.vhd  12/09/2023
--
--    (c) J.M. Mendias
--    Dise�o Autom�tico de Sistemas
--    Facultad de Inform�tica. Universidad Complutense de Madrid
--
--  Prop�sito:
--    Laboratorio 3
--
--  Notas de dise�o:
--
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity lab3 is
port
(
  aRst   : in  std_logic;
  osc    : in  std_logic;
  coin   : in  std_logic;
  go     : in  std_logic;
  an_n   : out std_logic_vector(3 downto 0);  
  segs_n : out std_logic_vector(7 downto 0)
);
end lab3;

---------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use work.common.all;

architecture syn of lab3 is

  constant OSC_KHZ   : natural := 100_000;     -- frecuencia del oscilador externo en KHz
  constant FREQ_KHZ  : natural := OSC_KHZ/10;  -- frecuencia de operacion en KHz
  constant BOUNCE_MS : natural := 50;          -- tiempo de rebote de los pulsadores en ms
  
  type reelType is array (2 downto 0) of unsigned(3 downto 0);

  -- Registros  
  signal credit : unsigned(3 downto 0) := (others => '0');
  signal reel   : reelType             := (others => (others => '0'));

  -- Se�ales 
  signal clk, ready  : std_logic;
  signal rstSync, rstAux : std_logic;
  signal coinSync, coinDeb, coinRise : std_logic;
  signal goSync, goDeb, goRise       : std_logic;
  signal eq2, eq3 : std_logic;
  signal bins : std_logic_vector (15 downto 0);

  signal spin : std_logic_vector(2 downto 0);
  signal decCredit, incCredit, hasCredit : std_logic;
  signal cycleCntTC : std_logic;  

begin

  rstAux <= aRst or ready;
  
  resetSyncronizer : asyncRstSynchronizer
    generic map ( STAGES => 2, XPOL => '0' )
    port map ( clk => clk, rstIn => rstAux, rstOut => rstSync );
    
  clkGenerator : freqSynthesizer
    generic map ( FREQ_KHZ => OSC_KHZ, MULTIPLY => 1, DIVIDE => 10 )
    port map ( clkIn => osc, ready => ready, clkOut => clk );
      
  ------------------  
  
  coinSynchronizer : synchronizer
    generic map(STAGES => 2, XPOL => '0')
    port map(clk => clk, x => coin, xSync => coinSync);
   
  coinDebouncer : debouncer
    generic map ( FREQ_KHZ => FREQ_KHZ, BOUNCE_MS => BOUNCE_MS, XPOL => '0' )
    port map(clk => clk, rst => rstSync, x => coinSync, xDeb => coinDeb);
   
  coinEdgeDetector : edgeDetector
    generic map(XPOL => '0')
    port map(clk => clk, x => coinDeb, xFall => open, xRise => coinRise);
  
  ------------------  

  goSynchronizer : synchronizer
    generic map(STAGES => 2, XPOL => '0')
    port map (clk => clk, x => go, xSync => goSync);
   
  goDebouncer : debouncer
    generic map (FREQ_KHZ => FREQ_KHZ, BOUNCE_MS => BOUNCE_MS, XPOL => '0' )
    port map (clk => clk, rst => rstSync, x => goSync, xDeb => goDeb);
   
  goEdgeDetector : edgeDetector
    generic map(XPOL => '0')
    port map(clk => clk, x => goDeb, xFall => open, xRise => goDeb);
  
  ------------------ 

  -- reel_eq : TODO Pensar como hacerlo de manera combinacional 
 
  fsm:
  process (rstSync, clk, goRise, hasCredit)
    type states is (initial, S1, S2, S3, reward); 
    variable state: states := initial;
  begin 
    decCredit <= '0';
    incCredit <= '0';
    spin      <= (others => '0');
    case state is
      when initial =>
        spin <= (others => '0');
        if goRise = '1' and hasCredit = '1' then
            decCredit <= '1';
        end if;
      when S1 =>
        spin <= (others => '1');
      when S2 =>
        spin <= "011";
      when S3 =>
        spin <= "001";
      when reward =>
        spin <= (others => '0');
        incCredit <= '1'; --Esto puede estar mal
    end case;
    if rstSync='1' then
      state := initial;
    elsif rising_edge(clk) then
      case state is
        when initial =>
          if goRise = '1' and hasCredit = '1' then
            state := S1;
          else
            state := initial;
          end if;
        when S1 =>
          if goRise = '1' then
            state := S2;
          else
            state := S1;
          end if;
        when S2 =>
          if goRise = '1' then
            state := S3;
          else
            state := S2;
          end if;
        when S3 =>
          if goRise = '1' then
            state := reward;
          else
            state := S3;
          end if;
         when reward =>
            state := initial;
      end case;
    end if;
  end process;  
  
  cycleCounter :  
  process (clk)
    constant CYCLES : natural := ms2cycles(FREQ_KHZ, 50);
    variable count  : natural range 0 to CYCLES := 0;
  begin
    cycleCntTC <= '0';
    if rising_edge(clk) then
      if count = CYCLES then
        cycleCntTC <= '1';
        count := 0;
      else
        count := count + 1;
      end if;
    end if;
  end process;
     
  reelRegisters : 
  for i in reel'range generate
  begin
    process (rstSync, clk)
    begin
      if rstSync='1' then
        reel(i) <= (others => '0');
      elsif rising_edge(clk) then
        if spin(i)= '1' and cycleCntTC = '1' then
          if reel(i) = "0111" then 
            reel(i) <= "0000";
          else
            reel(i) <= reel(i) + 1; 
          end if;
        end if;
      end if;
    end process; 
  end generate;
 
  eq3comparator:
  eq3 <= '1' when reel(0) = reel(1) and reel(1) = reel(2) else '0';
  
  eq2comparator:
  eq2 <= '1' when reel(0) = reel(1) or reel(1) = reel(2) or reel(0) = reel(2) else '0';
  
  creditComparator: 
  hasCredit <= '1' when credit > "0000";
  
  creditRegister :
  process (rstSync, clk)
  begin
    if rstSync='1' then
      credit <= (others => '0');    
    elsif rising_edge(clk) then
      if coinRise='1' then
        credit <= credit + "1";
      elsif decCredit='1' then
        credit <= credit + "1";
      elsif incCredit='1' and (eq2 = '1' or eq3 = '1') then
        if eq3 = '1' then
            credit <= credit + 3;
        else
            credit <= credit + 2;
        end if;
      end if;
   end if; 
  end process; 
  bins(15 downto 12) <= std_logic_vector(credit);
  bins(11 downto 8) <= std_logic_vector(reel(0));
  bins(7 downto 4) <= std_logic_vector(reel(1));
  bins(3 downto 0) <= std_logic_vector(reel(2));
  displayInterface : segsBankRefresher
    generic map(FREQ_KHZ => FREQ_KHZ, SIZE => 4)
    port map(clk => clk, ens => (others => '1'), bins => bins, dps => "1000", an_n => an_n, segs_n => segs_n);

end syn;
