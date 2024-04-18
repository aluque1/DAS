---------------------------------------------------------------------
--
--  Fichero:
--    lab6.vhd  12/09/2023
--
--    (c) J.M. Mendias
--    Dise�o Autom�tico de Sistemas
--    Facultad de Inform�tica. Universidad Complutense de Madrid
--
--  Prop�sito:
--    Laboratorio 6: Pong
--
--  Notas de dise�o:
--
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity lab6pong is
  port ( 
    clk     : in  std_logic;
    rst     : in  std_logic;
    ps2Clk  : in  std_logic;
    ps2Data : in  std_logic;
    hSync   : out std_logic;
    vSync   : out std_logic;
    RGB     : out std_logic_vector(3*4-1 downto 0)
  );
end lab6pong;

---------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use work.common.all;

architecture syn of lab6pong is

  constant FREQ_KHZ : natural := 100_000;  -- frecuencia de operacion en KHz
  constant VGA_KHZ  : natural := 25_000;   -- frecuencia de envio de pixeles a la VGA en KHz
  constant FREQ_DIV : natural := FREQ_KHZ/VGA_KHZ; 
  
  signal yRight : unsigned(7 downto 0) := to_unsigned( 8, 8 );
  signal yLeft  : unsigned(7 downto 0) := to_unsigned( 8, 8 );
  signal yBall  : unsigned(7 downto 0) := to_unsigned( 60, 8 );
  signal xBall  : unsigned(7 downto 0) := to_unsigned( 79, 8 );
  signal qP, aP, pP, lP, spcP: boolean := false;

  signal rstSync : std_logic;
  signal data: std_logic_vector(7 downto 0);
  signal dataRdy: std_logic;
  
  signal color : std_logic_vector(3 downto 0);
  signal campoJuego, raquetaDer, raquetaIzq, pelota: std_logic;
  signal mover, finPartida, reiniciar: boolean;

  signal lineAux, pixelAux : std_logic_vector(9 downto 0);  
  signal line, pixel : unsigned(7 downto 0);


begin
 
  rstSynchronizer : synchronizer
    generic map ( STAGES => 2, XPOL => '0' )
    port map ( clk => clk, x => rst, xSync => rstSync );

  ------------------  
 
  ps2KeyboardInterface : ps2receiver
    port map ( clk => clk, rst => rstSync, dataRdy => dataRdy, data => data, ps2Clk => ps2Clk, ps2Data => ps2Data );   
   
  keyboardScanner:
  process (clk)
    type states is (keyON, keyOFF);
    variable state : states := keyON; --Puede estar mal no se
  begin
    if rising_edge(clk) then
      if rstSync='1' then
        state := keyOFF; --Revisar lo de el estado inicial
      elsif dataRdy='1' then
        case state is
          when keyON =>
            case data is
              when X"F0" => state := keyOFF;
              when X"15" => qP <= true;
              when X"1C" => aP <= true;
              when X"4D" => pP <= true;
              when X"4B" => lP <= true;
              when X"29" => spcP <= true;
            end case;
          when keyOFF =>
            state := keyON;
            case data is
              when X"15" => qP <= false; 
              when X"1C" => aP <= false;
              when X"4D" => pP <= false;
              when X"4B" => lP <= false;
              when X"29" => spcP <= false;
            end case;
        end case;
      end if;
    end if;
  end process;        

------------------  

  screenInteface: vgaRefresher
    generic map ( FREQ_DIV => FREQ_DIV )
    port map ( clk => clk, line => lineAux, pixel => pixelAux, R => color, G => color, B => color, hSync => hSync, vSync => vSync, RGB => RGB );

  pixel <= unsigned(pixelAux);
  line  <= unsigned(lineAux);
  
  color <= "0000" when campoJuego = '1' or raquetaIzq = '1' or raquetaDer = '1' or pelota = '1' else "1111";--REVISAR ESTO

 ------------------
  -- Horizontal = 8 ,79, 111 ; Vertical = 8 en 8 a partir de 8 
  campoJuego <= '1' when (line = 8 or line = 79 or line = 111)  else '0'; -- aqui faltan cosas si o si
  raquetaIzq <= '1' when ... else '0'; -- Horizontal = 8 ; Vertical = yLeftReg + 8
  raquetaDer <= '1' when ... else '0'; -- Horizontal = 151 ; Vertical = yRightReg + 8
  pelota     <= '1' when ... else '0'; -- Horizontal = xBallReg ; Vertical = yBallReg

------------------

  finPartida <= true when xBall = 0 or xBall = 159 else false; --revisar las igualdades
  reiniciar  <= true when spcP else false;   
  
------------------
  
  pulseGen:
  process (clk)
    constant CYCLES : natural := hz2cycles(FREQ_KHZ, 50);
    variable count  : natural range 0 to CYCLES-1 := 0;
  begin
    if rising_edge(clk) then
        count := (count + 1) mod CYCLES;
        if count = CYCLES-1 then 
            --Puede que falte una variable de la que dependa el juego
            count := 0;
        end if;
        -- si no me equivoco aqui se deberia de hacer el movimiento de la pelota y las raquetas que tienen que ir a 50 pts por segundo

    end if;
  end process;    
        
------------------ PUEDE QUE TODO A PARTIR DE AQUI ESTE MAL

  yRightRegister:
  process (clk)
  begin
    if pP = true and yRight > 8 then
      yRight <= yRight + 1;
    elsif lP = true and yRight < 103 then
      yRight <= yRight - 1;
    end if;
  end process;

  yLeftRegister:
  process (clk)
  begin
    if qP = true and yLeft > 8 then
      yLeft <= yLeft + 1;
    elsif aP = true and yLeft < 103 then
      yLeft <= yLeft - 1;
    end if;
  end process;
  
------------------
  
  xBallRegister:
  process (clk)
    type sense is (left, right);
    variable dir: sense := left;
  begin
    if xBall = 9 and yLeft <= YBall and yBall <= (yLeft + 8) then
        dir := right;
    elsif xBall = 150 and yRight <= YBall and YBall <= (yRight + 8) then
        dir := left;
    end if;
  end process;

  yBallRegister:
  process (clk)
    type sense is (up, down);
    variable dir: sense := up;
  begin
    if yBall = 9 then -- no se si la condicion es asi o de otra manera
        dir := down; 
    elsif yBall = 101 then
        dir := up;
    end if;
  end process;

end syn;

