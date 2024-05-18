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

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY proyecto IS
  PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    ps2Clk : IN STD_LOGIC;
    ps2Data : IN STD_LOGIC;
    hSync : OUT STD_LOGIC;
    vSync : OUT STD_LOGIC;
    RGB : OUT STD_LOGIC_VECTOR(3 * 4 - 1 DOWNTO 0)
  );
END proyecto;

---------------------------------------------------------------------

LIBRARY ieee;
USE ieee.numeric_std.ALL;
USE work.common.ALL;

ARCHITECTURE syn OF proyecto IS

  CONSTANT FREQ_KHZ : NATURAL := 100_000; -- frecuencia de operacion en KHz
  CONSTANT VGA_KHZ : NATURAL := 25_000; -- frecuencia de envio de pixeles a la VGA en KHz
  CONSTANT FREQ_DIV : NATURAL := FREQ_KHZ/VGA_KHZ;

  SIGNAL yRight : unsigned(7 DOWNTO 0) := to_unsigned(8, 8);
  SIGNAL yLeft : unsigned(7 DOWNTO 0) := to_unsigned(8, 8);
  SIGNAL yBall : unsigned(7 DOWNTO 0) := to_unsigned(60, 8);
  SIGNAL xBall : unsigned(7 DOWNTO 0) := to_unsigned(79, 8);
  SIGNAL qP, aP, pP, lP, spcP : BOOLEAN := false;

  SIGNAL rstSync : STD_LOGIC;
  SIGNAL data : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL dataRdy : STD_LOGIC;

  SIGNAL color : STD_LOGIC_VECTOR(11 DOWNTO 0);
  signal visual: std_logic_vector(1 downto 0) := (others => '0');--Muy seguramente aumenten los bits
  --visual(0) bordes claritos de los bordes del campo
  --visual(1) interior oscuro
  SIGNAL campoJuego, raquetaDer, raquetaIzq, pelota : STD_LOGIC;
  SIGNAL mover, finPartida, reiniciar : BOOLEAN;

  SIGNAL lineAux, pixelAux : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL line, pixel : unsigned(7 DOWNTO 0);
  
  signal x : natural := 14;
  signal y : natural := 54;
  SIGNAL vToggle : BOOLEAN := false;
BEGIN

  rstSynchronizer : synchronizer
  GENERIC MAP(STAGES => 2, XPOL => '0')
  PORT MAP(clk => clk, x => rst, xSync => rstSync);

  ------------------  

  ps2KeyboardInterface : ps2receiver
  PORT MAP(clk => clk, rst => rstSync, dataRdy => dataRdy, data => data, ps2Clk => ps2Clk, ps2Data => ps2Data);

  keyboardScanner :
  PROCESS (clk)
    TYPE states IS (keyON, keyOFF);
    VARIABLE state : states := keyON; --Puede estar mal no se
  BEGIN
    IF rising_edge(clk) THEN
      IF rstSync = '1' THEN
        state := keyOFF; --Revisar lo de el estado inicial
      ELSIF dataRdy = '1' THEN
        CASE state IS
          WHEN keyON =>
            CASE data IS
              WHEN X"F0" => state := keyOFF;
              WHEN X"15" => qP <= true;
              WHEN X"1C" => aP <= true;
              WHEN X"4D" => pP <= true;
              WHEN X"4B" => lP <= true;
              WHEN X"29" => spcP <= true;
              WHEN OTHERS => state := keyON;
            END CASE;
          WHEN keyOFF =>
            state := keyON;
            CASE data IS
              WHEN X"15" => qP <= false;
              WHEN X"1C" => aP <= false;
              WHEN X"4D" => pP <= false;
              WHEN X"4B" => lP <= false;
              WHEN X"29" => spcP <= false;
              WHEN OTHERS => state := keyOFF;
            END CASE;
        END CASE;
      END IF;
    END IF;
  END PROCESS;

  ------------------  

  screenInteface : vgaRefresher
  GENERIC MAP(FREQ_DIV => FREQ_DIV)
  PORT MAP(clk => clk, line => lineAux, pixel => pixelAux, R => color(11 downto 8), G => color(7 downto 4), B => color(3 downto 0), hSync => hSync, vSync => vSync, RGB => RGB);

  pixel <= unsigned(pixelAux(9 DOWNTO 2));
  line <= unsigned(lineAux(9 DOWNTO 2));

  with visual select
    color <= 
    "011101110111" when "01",
    "100110011001" when "10",
    "011101110111" when "11",
    "000000000000" when others;
  
  --color <= "100010001000" when campoJuego = '1' else (others => '0');
  ------------------

  --REVISAR LAS CONDICIONES
  regSumX:
  process(clk)
  begin
    if rising_edge(clk) then
        if (line = x and ((pixel > 49 and pixel < 54) and (pixel > 104 and pixel < 109))) then
            x <= x + 5;
            if x = 114 then
                x <= 14;
            end if;
        end if;
    end if;
  end process;
  
  regSumY:
  process(clk)
  begin
  if rising_edge(clk) then
        if (pixel = y and ((line > 9 and line < 14) and (line > 114 and line < 119))) then
            y <= y + 5;
            if y = 104 then
                y <= 54;
            end if;
        end if;
    end if;
  end process;
  
  visual(0) <= '1' when (pixel = y and ((line > 9 and line < 14) or (line > 114 and line < 119))) or
                        (line = x and ((pixel > 49 and pixel < 54) or (pixel > 104 and pixel < 109))) or
                        (line = 9 and (pixel >= 49 and pixel <= 109)) or
                        (line = 14 and (pixel >= 54 and pixel <= 104)) or
                        (line = 114 and (pixel >= 54 and pixel <= 104)) or
                        (line = 119 and (pixel >= 49 and pixel <= 109)) or
                        (pixel = 49 and (line >= 9 and line <= 119)) or
                        (pixel = 54 and (line >= 14 and line <= 114)) or
                        (pixel = 104 and (line >= 14 and line <= 114)) or
                        (pixel = 109 and (line >= 9 and line <= 119)) else '0';
                        
  visual(1) <= '1' when ((pixel > 49 and pixel < 109) and (line > 9 and line < 14) and (line > 114 and line < 119)) or
                        ((line > 9 and line < 119) and (pixel > 49 and pixel < 54) and (pixel > 104 and pixel < 109)) else '0';
  campoJuego <= '1' when (((line >= 114 and line <= 119)or(line >= 9 and line <= 14)) and (pixel >= 49 and pixel <= 109)) or
                         (((pixel >= 49 and pixel <= 54) or (pixel >= 104 and pixel <= 109)) and (line >= 9 and line <= 119)) else '0';
                         
  raquetaIzq <= '1' WHEN pixel = 8 AND (line >= yLeft AND line <= yLeft + 16) ELSE
    '0';
  raquetaDer <= '1' WHEN pixel = 151 AND (line >= yRight AND line <= yRight + 16) ELSE
    '0';
  pelota <= '1' WHEN line = yBall AND pixel = xBall ELSE
    '0';

  ------------------

  finPartida <= true WHEN xBall = 0 OR xBall = 159 ELSE
    false; --revisar las igualdades
  reiniciar <= true WHEN spcP ELSE
    false;
  
  ------------------
  pulseGen :
  PROCESS (clk)
    CONSTANT CYCLES : NATURAL := hz2cycles(FREQ_KHZ, 50);
    VARIABLE count : NATURAL RANGE 0 TO CYCLES - 1 := 0;
  BEGIN
    IF rising_edge(clk) THEN
      IF rstSync = '1' THEN
        count := 0;
      ELSIF finPartida = false THEN
        count := (count + 1) MOD CYCLES;
        mover <= false;
        IF count = (CYCLES - 1) THEN
          mover <= true;
        END IF;
      END IF;
    END IF;
  END PROCESS;

  ------------------

  yRightRegister :
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF reiniciar = true OR rstSync = '1' THEN
        yRight <= TO_UNSIGNED(8, 8);
      ELSE
        IF mover = true THEN
          IF pP = true AND yRight > 8 THEN
            yRight <= yRight - 1;
          ELSIF lP = true AND yRight < 95 THEN
            yRight <= yRight + 1;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;

  yLeftRegister :
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF reiniciar = true OR rstSync = '1' THEN
        yLeft <= TO_UNSIGNED(8, 8);
      ELSE
        IF mover = true THEN
          IF qP = true AND yLeft > 8 THEN
            yLeft <= yLeft - 1;
          ELSIF aP = true AND yLeft < 95 THEN
            yLeft <= yLeft + 1;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;

  ------------------

  xBallRegister :
  PROCESS (clk)
    TYPE sense IS (left, right);
    VARIABLE dir : sense := left;
  BEGIN
    IF rising_edge(clk) THEN
      IF reiniciar = true OR rstSync = '1' THEN
        xBall <= to_unsigned(79, 8);
      ELSE
        IF mover = true THEN
          IF xBall = 9 AND yLeft <= yBall AND yBall <= (yLeft + 16) THEN
            dir := right;
          ELSIF xBall = 150 AND yRight <= yBall AND yBall <= (yRight + 16) THEN
            dir := left;
          END IF;
          IF dir = left THEN
            xBall <= xBall - 1;
          ELSE
            xBall <= xBall + 1;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;

  yBallRegister :
  PROCESS (clk)
    TYPE sense IS (up, down);
    VARIABLE dir : sense := up;
  BEGIN
    IF rising_edge(clk) THEN
      IF reiniciar = true OR rstSync = '1' THEN
        yBall <= to_unsigned(60, 8);
      ELSE
        IF mover = true THEN
          IF yBall = 9 THEN
            dir := down;
          ELSIF yBall = 110 THEN
            dir := up;
          END IF;
          IF dir = up THEN
            yBall <= yBall - 1;
          ELSE
            yBall <= yBall + 1;
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;

END syn;
