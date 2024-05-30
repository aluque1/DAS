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
  constant negro : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000";
  constant grisOscuro : STD_LOGIC_VECTOR(11 DOWNTO 0) := "011101110111";
  constant grisClaro : STD_LOGIC_VECTOR(11 DOWNTO 0) := "100110011001";
  constant amarilloOscuro : STD_LOGIC_VECTOR(11 DOWNTO 0) := "110111010000";
  constant amarilloClaro : STD_LOGIC_VECTOR(11 DOWNTO 0) := "111111110000";
  constant azulClaroInt : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000100";
  constant azulClaroB : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000011";
  constant azulOscuroInt : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000001111";
  constant azulOscuroB : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000001101";
  constant rojoOscuro : STD_LOGIC_VECTOR(11 DOWNTO 0) := "111100000000";
  constant rojoClaro : STD_LOGIC_VECTOR(11 DOWNTO 0) := "110100000000";
  constant verdeOscuro : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000011110000";
  constant verdeClaro : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000011010000";
  constant naranjaOscuro : STD_LOGIC_VECTOR(11 DOWNTO 0) := "111101000000";
  constant naranjaClaro : STD_LOGIC_VECTOR(11 DOWNTO 0) := "110100110000"; --Peligro
  constant moradoOscuro : STD_LOGIC_VECTOR(11 DOWNTO 0) := "111100001111";
  constant moradoClaro : STD_LOGIC_VECTOR(11 DOWNTO 0) := "110100001101";

  --Se�ales teclas 
  SIGNAL aP, sP, dP, rP, spcP:  BOOLEAN := false;
  
  --Tablero
  signal dataIn, doa, dob: unsigned(2 downto 0) := (others => '0');
  signal addraIn, addrbIn, addraOut, addrbOut: unsigned(7 downto 0) := (others => '0');
  signal wr, rd, pinta, pintaVga: std_logic := '0';
  type tablero_t is array (0 to 230) of unsigned(2 downto 0); 
  signal tablero : tablero_t := (others => (others => '0'));

  SIGNAL rstSync : STD_LOGIC;
  SIGNAL data : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL dataRdy : STD_LOGIC;
  
  --Piezas
  signal ce, ld : std_logic := '0';
  signal seed : std_logic_vector(2 downto 0) := "011";
  signal piezaSig, pieza : std_logic_vector(2 downto 0);
  signal CPos1, LinPos1, LinPos2, ZPos1, ZPos2, ZInvPos1, ZInvPos2, LPos1, LPos2, LPos3, LPos4, LInvPos1, LInvPos2, LInvPos3, LInvPos4, TPos1, TPos2, TPos3, TPos4 : std_logic := '0';
  
  SIGNAL color : STD_LOGIC_VECTOR(11 DOWNTO 0);
  signal colorTablero : std_logic_vector (11 downto 0) := negro;
  
  signal visual: std_logic_vector(2 downto 0) := (others => '0');--Muy seguramente aumenten los bits
  --visual(0) bordes claritos de los bordes del campo
  --visual(1) interior oscuro
  --visual(2) lineas de las piezas
  SIGNAL mover, finPartida, reiniciar, colision, finPintadoVga: BOOLEAN;

  

  SIGNAL lineAux, pixelAux : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL line, pixel : unsigned(7 DOWNTO 0);
  
  signal x : natural := 14;
  signal y : natural := 54;
  
BEGIN

  rstSynchronizer : synchronizer
  GENERIC MAP(STAGES => 2, XPOL => '0')
  PORT MAP(clk => clk, x => rst, xSync => rstSync);

  ------------------  

  ps2KeyboardInterface : ps2receiver
  PORT MAP(clk => clk, rst => rstSync, dataRdy => dataRdy, data => data, ps2Clk => ps2Clk, ps2Data => ps2Data);

  generaPieza: lsfr
  generic map(WL => 3)
  port map(clk => clk, rst => rstSync, ce => ce, ld => ld, seed => seed, random => piezaSig);
  
  keyboardScanner :
  PROCESS (clk)
    TYPE states IS (keyON, keyOFF);
    VARIABLE state : states := keyON;
  BEGIN
    IF rising_edge(clk) THEN
      IF rstSync = '1' THEN
        state := keyOFF; 
      ELSIF dataRdy = '1' THEN
        CASE state IS
          WHEN keyON =>
            CASE data IS
              WHEN X"F0" => state := keyOFF;
              WHEN X"1C" => aP <= true;
              WHEN X"1B" => sP <= true;
              WHEN X"23" => dP <= true;
              WHEN X"2D" => rP <= true;
              WHEN X"29" => spcP <= true;
              WHEN OTHERS => state := keyON;
            END CASE;
          WHEN keyOFF =>
            state := keyON;
            CASE data IS
              WHEN X"1C" => aP <= false;
              WHEN X"1B" => sP <= false;
              WHEN X"23" => dP <= false;
              WHEN X"2D" => rP <= false;
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
    grisClaro when "001",
    grisOscuro when "010",
    grisClaro when "011",
    colorTablero when "100",
    negro when others;
  
  
  ------------------

  
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
                        
  visual(1) <= '1' when ((pixel > 49 and pixel < 109) and ((line > 9 and line < 14) or (line > 114 and line < 119))) or
                        ((line > 9 and line < 119) and ((pixel > 49 and pixel < 54) or (pixel > 104 and pixel < 109))) else '0';
                        
             
  
  --Implementar el aumento de velocidad
  pulseGen :
  PROCESS (clk)
    CONSTANT CYCLES : NATURAL := hz2cycles(FREQ_KHZ, 50) * 5;
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
  
  
  fsm:
  process(clk)
    type states is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9);
    variable state: states := S0;
    variable distASuelo : natural := 2;
    variable distDer : natural := 2;
    variable distIzq : natural := 0;
    variable x : natural := 0;
    variable j : natural := 0;
    variable i : natural := 0;
    variable bordeYCnt : natural := 0;
    variable bordeXCnt : natural := 0;
    variable dataCasilla : unsigned(2 downto 0);
    variable dataOut1 : unsigned(2 downto 0);
    variable dataOut2 : unsigned(2 downto 0);
    variable dataOut3 : unsigned(2 downto 0);
    variable dataOut4 : unsigned(2 downto 0);
    variable xPiezaAct : natural := 5;
    variable yPiezaAct : natural := 1;
  begin
    if rising_edge(clk) then
        if rstSync = '1' then 
            state := S0;
        else
            case state is
                when S0 =>
                    ld <= '1';
                    state := S1;
                when S1 =>
                    CPos1 <= '0'; LinPos1 <= '0'; LinPos2 <= '0'; ZPos1 <= '0'; ZPos2 <= '0'; ZInvPos1 <= '0'; ZInvPos2 <= '0';
                    LPos1 <= '0'; LPos2 <= '0'; LPos3 <= '0'; LPos4 <= '0'; LInvPos1 <= '0'; LInvPos2 <= '0'; LInvPos3 <= '0';
                    LInvPos4 <= '0'; TPos1 <= '0'; TPos2 <= '0'; TPos3 <= '0'; TPos4 <= '0';
                    pinta <= '0';
                    wr <= '0';
                    xPiezaAct := 5;
                    yPiezaAct := 1;
                    ld <= '0';
                    ce <= '1';
                    state := S2;
                when S2 =>
                    ce <= '0';
                    case piezaSig is
                        when "000" =>
                            CPos1 <= '1'; distAsuelo := 2;
                            distDer := 2; distIzq := 1; 
                        when "001" =>
                            CPos1 <= '1';distAsuelo := 2;
                            distDer := 2; distIzq := 1;
                        when "010" =>
                            LinPos1 <= '1'; distAsuelo := 1; 
                            distDer := 4; distIzq := 1; 
                        when "011" =>
                            ZPos1 <= '1'; distAsuelo := 3;
                            distDer := 3; distIzq := 1; 
                        when "100" =>
                            ZInvPos1 <= '1'; distAsuelo := 3;
                            distDer := 2; distIzq := 2;
                        when "101" =>
                            LPos1 <= '1'; distAsuelo := 3;
                            distDer := 2; distIzq := 1;
                        when "110" =>
                            LInvPos1 <= '1'; distAsuelo := 3;
                            distDer := 1; distIzq := 2;
                        when "111" =>
                            TPos1 <= '1'; distAsuelo := 3;
                            distDer := 1; distIzq := 2;
                    end case;
                    state := S3;
                when S3 =>
                    --Limpiar pieza 2 ciclos
                    wr <= '1';
                    dataIn <= (others => '0');
                    case piezaSig is
                        when "000" =>
                            if x = 0 then
                                addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct, 8);
                                addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                            else
                                addraIn <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                addrbIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                state := S4;
                            end if;
                            x := (x + 1) mod 2;
                        when "001" =>
                            if x = 0 then
                                addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct, 8);
                                addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                            else
                                addraIn <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                addrbIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                state := S4;
                            end if;
                            x := (x + 1) mod 2;
                        when "010" =>
                            if LinPos1 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                else
                                    addraIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+2),8);
                                    addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+3),8);
                                    state := S4;
                                end if;
                                x := (x + 1) mod 2;
                            elsif LinPos2 = '1' then
                                    if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+3) + xPiezaAct,8);
                                    state := S4;
                                end if;
                                x := (x + 1) mod 2;
                            end if;
                        when "011" =>
                             if ZPos1 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+2),8);
                                    state := S4;
                                end if;
                                x := (x + 1) mod 2;
                            elsif ZPos2 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct-1),8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct-1),8);
                                    state := S4;
                                end if;
                                x := (x + 1) mod 2;
                            end if;
                        when "100" =>
                            if ZInvPos1 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct-1) + (xPiezaAct+1),8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct-1) + (xPiezaAct+2),8);
                                    state := S4;
                                end if;
                                x := (x + 1) mod 2;
                            elsif ZInvPos2 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+1),8);
                                    state := S4;
                                end if;
                                x := (x + 1) mod 2;
                            end if;
                        when "101" =>
                            if LPos1 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+1),8);
                                    state := S4;
                                end if;
                                x := (x + 1) mod 2;
                            elsif LPos2 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                else
                                    addraIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                    addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+2),8);
                                    state := S4;
                                end if;
                                x := (x + 1) mod 2;
                            elsif LPos3 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+1),8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+3) + (xPiezaAct+1),8);
                                    state := S4;
                                end if;
                                x := (x + 1) mod 2;
                             elsif LPos4 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                else
                                    addraIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+2),8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct-1) + (xPiezaAct+2),8);
                                    state := S4;
                                end if;
                                x := (x + 1) mod 2;
                            end if;
                        when "110" =>
                           if LInvPos1 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct-1),8);
                                    state := S4;
                                end if;
                                x := (x + 1) mod 2;
                            elsif LInvPos2 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+2),8);
                                    state := S4;
                                end if;
                                x := (x + 1) mod 2;
                            elsif LInvPos3 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+3) + xPiezaAct,8);
                                    state := S4;
                                end if;
                                x := (x + 1) mod 2;
                             elsif LInvPos4 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                else
                                    addraIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+2),8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+2),8);
                                    state := S4;
                                end if;
                                x := (x + 1) mod 2;
                            end if;
                        when "111" =>
                            if TPos1 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct-1),8); 
                                    state := S4;
                                end if;
                                x := (x + 1) mod 2;
                            elsif TPos2 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                else
                                    addraIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+2),8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct-1) + (xPiezaAct+1),8);
                                    state := S4;
                                end if;
                                x := (x + 1) mod 2;
                            elsif TPos3 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    state := S4;
                                end if;
                                x := (x + 1) mod 2;
                             elsif TPos4 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                else
                                    addraIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+2),8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    state := S4;
                                end if;
                                x := (x + 1) mod 2;
                            end if;
                    end case;
                when S4 =>
                     --Pinta pieza 2 ciclos
                    --pinta <= '1';
                    dataIn <= unsigned(piezaSig);
                    case piezaSig is
                        when "000" =>
                            if x = 0 then
                                addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct, 8);
                                addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                            else
                                addraIn <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                addrbIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                state := S5;
                            end if;
                            x := (x + 1) mod 2;
                        when "001" =>
                            if x = 0 then
                                addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct, 8);
                                addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                            else
                                addraIn <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                addrbIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                state := S5;
                            end if;
                            x := (x + 1) mod 2;
                        when "010" =>
                            if LinPos1 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                else
                                    addraIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+2),8);
                                    addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+3),8);
                                    state := S5;
                                end if;
                                x := (x + 1) mod 2;
                            elsif LinPos2 = '1' then
                                    if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+3) + xPiezaAct,8);
                                    state := S5;
                                end if;
                                x := (x + 1) mod 2;
                            end if;
                        when "011" =>
                             if ZPos1 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+2),8);
                                    state := S5;
                                end if;
                                x := (x + 1) mod 2;
                            elsif ZPos2 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct-1),8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct-1),8);
                                    state := S5;
                                end if;
                                x := (x + 1) mod 2;
                            end if;
                        when "100" =>
                            if ZInvPos1 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct-1) + (xPiezaAct+1),8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct-1) + (xPiezaAct+2),8);
                                    state := S5;
                                end if;
                                x := (x + 1) mod 2;
                            elsif ZInvPos2 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+1),8);
                                    state := S5;
                                end if;
                                x := (x + 1) mod 2;
                            end if;
                        when "101" =>
                            if LPos1 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+1),8);
                                    state := S5;
                                end if;
                                x := (x + 1) mod 2;
                            elsif LPos2 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                else
                                    addraIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                    addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+2),8);
                                    state := S5;
                                end if;
                                x := (x + 1) mod 2;
                            elsif LPos3 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+1),8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+3) + (xPiezaAct+1),8);
                                    state := S5;
                                end if;
                                x := (x + 1) mod 2;
                             elsif LPos4 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                else
                                    addraIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+2),8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct-1) + (xPiezaAct+2),8);
                                    state := S5;
                                end if;
                                x := (x + 1) mod 2;
                            end if;
                        when "110" =>
                           if LInvPos1 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct-1),8);
                                    state := S5; 
                                end if;
                                x := (x + 1) mod 2;
                            elsif LInvPos2 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+2),8);
                                    state := S5;
                                end if;
                                x := (x + 1) mod 2;
                            elsif LInvPos3 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+3) + xPiezaAct,8);
                                    state := S5;
                                end if;
                                x := (x + 1) mod 2;
                             elsif LInvPos4 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                else
                                    addraIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+2),8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+2),8);
                                    state := S5;
                                end if;
                                x := (x + 1) mod 2;
                            end if;
                        when "111" =>
                            if TPos1 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct-1),8); 
                                    state := S5;
                                end if;
                                x := (x + 1) mod 2;
                            elsif TPos2 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                else
                                    addraIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+2),8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct-1) + (xPiezaAct+1),8);
                                    state := S5;
                                end if;
                                x := (x + 1) mod 2;
                            elsif TPos3 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                else
                                    addraIn <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    state := S5;
                                end if;
                                x := (x + 1) mod 2;
                             elsif TPos4 = '1' then
                                if x = 0 then
                                    addraIn <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrbIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                else
                                    addraIn <= to_unsigned(11*yPiezaAct + (xPiezaAct+2),8);
                                    addrbIn <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    state := S5;
                                end if;
                                x := (x + 1) mod 2;
                            end if;
                    end case;
                when S5 =>
                   --Se comprueba colision 2 ciclos
                   wr <= '0';
                    case piezaSig is
                        when "000" =>
                            addraOut <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                            addrbOut <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+1),8);
                            dataOut1 := doa;
                            dataOut2 := dob;
                            colision <= (dataOut1 /= 0 or dataOut2 /= 0);
                        when "001" =>
                           addraOut <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                            addrbOut <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+1),8);
                            dataOut1 := doa;
                            dataOut2 := dob;
                            colision <= (dataOut1 /= 0 or dataOut2 /= 0);
                        when "010" =>
                            if LinPos1 = '1' then
                                if x = 0 then
                                    addraOut <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    addrbOut <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    dataOut1 := doa;
                                    dataOut2 := dob;
                                else
                                    addraOut <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+2),8);
                                    addrbOut <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+3),8);
                                    dataOut3 := doa;
                                    dataOut4 := dob;
                                    colision <= (dataOut1 /= 0 or dataOut2 /= 0 or dataOut3 /= 0 or dataOut4 /= 0);
                                end if;
                                x := (x + 1) mod 2;
                            elsif LinPos2 = '1' then
                                addraOut <= to_unsigned(11*(yPiezaAct+3) + xPiezaAct,8);
                                dataOut1 := doa;
                                colision <= dataOut1 /= 0;
                            end if;
                        when "011" =>
                            if ZPos1 = '1' then
                                if x = 0 then
                                    addraOut <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+1),8);
                                    addrbOut <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+2),8);
                                    dataOut1 := doa;
                                    dataOut2 := dob;
                                else
                                    addraOut <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    dataOut3 := doa; 
                                    colision <= (dataOut1 /= 0 or dataOut2 /= 0 or dataOut3 /= 0);
                                end if;
                                x := (x + 1) mod 2;
                            elsif ZPos2 = '1' then
                                addraOut <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                addrbOut <= to_unsigned(11*(yPiezaAct+3) + (xPiezaAct-1),8);
                                dataOut1 := doa;
                                dataOut2 := dob;
                                colision <= (dataOut1 /= 0 or dataOut2 /= 0);
                            end if;
                        when "100" =>
                            if ZInvPos1 = '1' then
                                if x = 0 then
                                    addraOut <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    addrbOut <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    dataOut1 := doa;
                                    dataOut2 := dob;
                                else
                                    addraOut <= to_unsigned(11*yPiezaAct + (xPiezaAct+2),8);
                                    dataOut3 := doa; 
                                    colision <= (dataOut1 /= 0 or dataOut2 /= 0 or dataOut3 /= 0);
                                end if;
                                x := (x + 1) mod 2;
                            elsif ZInvPos2 = '1' then
                                addraOut <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                addrbOut <= to_unsigned(11*(yPiezaAct+3) + (xPiezaAct+1),8);
                                dataOut1 := doa;
                                dataOut2 := dob;
                                colision <= (dataOut1 /= 0 or dataOut2 /= 0);
                            end if;
                        when "101" =>
                            if LPos1 = '1' then
                                addraOut <= to_unsigned(11*(yPiezaAct+3) + xPiezaAct,8);
                                addrbOut <= to_unsigned(11*(yPiezaAct+3) + (xPiezaAct+1),8);
                                dataOut1 := doa;
                                dataOut2 := dob;
                                colision <= (dataOut1 /= 0 or dataOut2 /= 0);
                            elsif LPos2 = '1' then
                                if x = 0 then
                                    addraOut <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrbOut <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    dataOut1 := doa;
                                    dataOut2 := dob;
                                else
                                    addraOut <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+2),8);
                                    dataOut3 := doa; 
                                    colision <= (dataOut1 /= 0 or dataOut2 /= 0 or dataOut3 /= 0);
                                end if;
                                x := (x + 1) mod 2;
                            elsif LPos3 = '1' then
                                addraOut <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                addrbOut <= to_unsigned(11*(yPiezaAct+4) + (xPiezaAct+1),8);
                                dataOut1 := doa;
                                dataOut2 := dob;
                                colision <= (dataOut1 /= 0 or dataOut2 /= 0);
                            elsif LPos4 = '1' then
                                if x = 0 then
                                    addraOut <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    addrbOut <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    dataOut1 := doa;
                                    dataOut2 := dob;
                                else
                                    addraOut <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+2),8);
                                    dataOut3 := doa; 
                                    colision <= (dataOut1 /= 0 or dataOut2 /= 0 or dataOut3 /= 0);
                                end if;
                                x := (x + 1) mod 2;
                            end if;
                        when "110" =>
                           if LInvPos1 = '1' then
                                addraOut <= to_unsigned(11*(yPiezaAct+3) + xPiezaAct,8);
                                addrbOut <= to_unsigned(11*(yPiezaAct+3) + (xPiezaAct-1),8);
                                dataOut1 := doa;
                                dataOut2 := dob;
                                colision <= (dataOut1 /= 0 or dataOut2 /= 0);
                            elsif LInvPos2 = '1' then
                                if x = 0 then
                                    addraOut <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrbOut <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+1),8);
                                    dataOut1 := doa;
                                    dataOut2 := dob;
                                else
                                    addraOut <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+2),8);
                                    dataOut3 := doa; 
                                    colision <= (dataOut1 /= 0 or dataOut2 /= 0 or dataOut3 /= 0);
                                end if;
                                x := (x + 1) mod 2;
                            elsif LInvPos3 = '1' then
                                addraOut <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                addrbOut <= to_unsigned(11*(yPiezaAct+4) + xPiezaAct,8);
                                dataOut1 := doa;
                                dataOut2 := dob;
                                colision <= (dataOut1 /= 0 or dataOut2 /= 0);
                            elsif LInvPos4 = '1' then
                                if x = 0 then
                                    addraOut <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    addrbOut <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    dataOut1 := doa;
                                    dataOut2 := dob;
                                else
                                    addraOut <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+2),8);
                                    dataOut3 := doa; 
                                    colision <= (dataOut1 /= 0 or dataOut2 /= 0 or dataOut3 /= 0);
                                end if;
                                x := (x + 1) mod 2;
                            end if;
                        when "111" =>
                            if TPos1 = '1' then
                                addraOut <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct-1),8);
                                addrbOut <= to_unsigned(11*(yPiezaAct+3) + xPiezaAct,8);
                                dataOut1 := doa;
                                dataOut2 := dob;
                                colision <= (dataOut1 /= 0 or dataOut2 /= 0);
                            elsif TPos2 = '1' then
                                if x = 0 then
                                    addraOut <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    addrbOut <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    dataOut1 := doa;
                                    dataOut2 := dob;
                                else
                                    addraOut <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+2),8);
                                    dataOut3 := doa; 
                                    colision <= (dataOut1 /= 0 or dataOut2 /= 0 or dataOut3 /= 0);
                                end if;
                                x := (x + 1) mod 2;
                            elsif TPos3 = '1' then
                                addraOut <= to_unsigned(11*(yPiezaAct+3) + xPiezaAct,8);
                                addrbOut <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+1),8);
                                dataOut1 := doa;
                                dataOut2 := dob;
                                colision <= (dataOut1 /= 0 or dataOut2 /= 0);
                            elsif TPos4 = '1' then
                                if x = 0 then
                                    addraOut <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    addrbOut <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+2),8);
                                    dataOut1 := doa;
                                    dataOut2 := dob;
                                else
                                    addraOut <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+1),8);
                                    dataOut3 := doa; 
                                    colision <= (dataOut1 /= 0 or dataOut2 /= 0 or dataOut3 /= 0);
                                end if;
                                x := (x + 1) mod 2;
                            end if;
                    end case;
                    wr <= '0';
                    pinta <= '0';
                    --if colision or 11*(yPiezaAct + distASuelo) = 220 then
                        --state := S8;
                    --else
                        state := S6;
                    --end if;
                when S6 =>
                    --Se pinta en la VGA
                    if ((pixel > 54 and pixel < 104) and (line > 14 and line < 114)) then
                        visual(2) <= '1';            
                        addraOut <= to_unsigned(11*i + j, 8);
                        dataCasilla := doa;
                        bordeXCnt := (bordeXCnt + 1) mod 5;
                        if bordeXCnt = 4 then
                            j := (j + 1) mod 11;
                            if j = 10 then
                                bordeYCnt := (bordeYCnt + 1) mod 5;
                                if bordeYCnt = 4 then
                                    i := (i + 1) mod 21;
                                end if;
                            end if;
                        end if;
                        if j = 10 and i = 20 then
                            state := S7;
                        end if;
                        case dataCasilla is
                            when "000" =>
                                colorTablero <= negro;
                            when "001" =>
                                if bordeYCnt = 0 or bordeYCnt = 4 or bordeXCnt = 0 or bordeYCnt = 4 then
                                    colorTablero <= amarilloClaro;
                                else
                                    colorTablero <= amarilloOscuro;
                                end if;
                            when "010" =>
                                if bordeYCnt = 0 or bordeYCnt = 4 or bordeXCnt = 0 or bordeYCnt = 4 then
                                    colorTablero <= azulClaroB;
                                else
                                    colorTablero <= azulClaroInt;
                                end if;
                            when "011" =>
                                if bordeYCnt = 0 or bordeYCnt = 4 or bordeXCnt = 0 or bordeYCnt = 4 then
                                    colorTablero <= rojoClaro;
                                else
                                    colorTablero <= rojoOscuro;
                                end if;
                            when "100" =>
                                if bordeYCnt = 0 or bordeYCnt = 4 or bordeXCnt = 0 or bordeYCnt = 4 then
                                    colorTablero <= verdeClaro;
                                else
                                    colorTablero <= verdeOscuro;
                                end if;
                            when "101" =>
                                if bordeYCnt = 0 or bordeYCnt = 4 or bordeXCnt = 0 or bordeYCnt = 4 then
                                    colorTablero <= naranjaClaro;
                                else
                                    colorTablero <= naranjaOscuro;
                                end if;
                            when "110" =>
                                if bordeYCnt = 0 or bordeYCnt = 4 or bordeXCnt = 0 or bordeYCnt = 4 then
                                    colorTablero <= azulOscuroB;
                                else
                                    colorTablero <= azulOscuroInt;
                                end if;
                            when "111" =>
                                if bordeYCnt = 0 or bordeYCnt = 4 or bordeXCnt = 0 or bordeYCnt = 4 then
                                    colorTablero <= moradoClaro;
                                else
                                    colorTablero <= moradoOscuro;
                                end if;
                        end case;
                    else
                        visual(2) <= '0';
                    end if;
                        
                when S7 =>
                    --Se hace el movimiento
                    if mover then
                        if 11*(yPiezaAct + distASuelo) > 220 then
                            if sP then
                                yPiezaAct := yPiezaAct + 2;
                            else
                                yPiezaAct := yPiezaAct + 1;
                            end if;
                        end if;
                        if xPiezaAct + distDer < 10 and dP then
                            xPiezaAct := xPiezaAct + 1;
                        end if;
                        if xPiezaAct - distIzq > 0 and aP then
                            xPiezaAct := xPiezaAct - 1;
                        end if;
                        if rP then
                            case pieza is
                                when "000" =>
                                    CPos1 <= '1';
                                    distASuelo := 2;
                                    distDer  := 2;
                                    distIzq  := 1;
                                when "001" =>
                                    CPos1 <= '1';
                                    distASuelo := 2;
                                    distDer  := 2;
                                    distIzq  := 1;
                                when "010" =>
                                    if LinPos1 = '1' then
                                        LinPos1 <= '0';
                                        LinPos2 <= '1';
                                        distASuelo := 1;
                                        distDer  := 4;
                                        distIzq  := 1;
                                    elsif LinPos2 = '1' then
                                        LinPos1 <= '1';
                                        LinPos2 <= '0';
                                        distASuelo := 4;
                                        distDer  := 1;
                                        distIzq  := 1;
                                    end if;
                                when "011" =>
                                    if ZPos1 = '1' then
                                        ZPos1 <= '0';
                                        ZPos2 <= '1';
                                        distASuelo := 2;
                                        distDer  := 3;
                                        distIzq  := 1;
                                    elsif ZPos2 = '1' then
                                        ZPos1 <= '1';
                                        ZPos2 <= '0';
                                        distASuelo := 3;
                                        distDer  := 1;
                                        distIzq  := 2;
                                    end if;
                                when "100" =>
                                    if ZInvPos1 = '1' then
                                        ZInvPos1 <= '0';
                                        ZInvPos2 <= '1';
                                        distASuelo := 1;
                                        distDer  := 3;
                                        distIzq  := 1;
                                    elsif ZInvPos2 = '1' then
                                        ZInvPos1 <= '1';
                                        ZInvPos2 <= '0';
                                        distASuelo := 3;
                                        distDer  := 2;
                                        distIzq  := 1;
                                    end if;
                                when "101" =>
                                    if LPos1 = '1' then
                                        LPos1 <= '0';
                                        LPos2 <= '1';
                                        distASuelo := 2;
                                        distDer  := 3;
                                        distIzq  := 1;
                                    elsif LPos2 = '1' then
                                        LPos2 <= '0';
                                        LPos3 <= '1';
                                        distASuelo := 3;
                                        distDer  := 2;
                                        distIzq  := 1;
                                    elsif LPos3 = '1' then
                                        LPos3 <= '0';
                                        LPos4 <= '1';
                                        distASuelo := 1;
                                        distDer  := 3;
                                        distIzq  := 1;
                                    elsif LPos4 = '1' then
                                        LPos4 <= '0';
                                        LPos1 <= '1';
                                        distASuelo := 3;
                                        distDer  := 2;
                                        distIzq  := 1;
                                    end if;
                                when "110" =>
                                    if LInvPos1 = '1' then
                                        LInvPos1 <= '0';
                                        LInvPos2 <= '1';
                                        distASuelo := 2;
                                        distDer  := 3;
                                        distIzq  := 1;
                                    elsif LInvPos2 = '1' then
                                        LInvPos2 <= '0';
                                        LInvPos3 <= '1';
                                        distASuelo := 3;
                                        distDer  := 2;
                                        distIzq  := 1;
                                    elsif LInvPos3 = '1' then
                                        LInvPos3 <= '0';
                                        LInvPos4 <= '1';
                                        distASuelo := 2;
                                        distDer  := 3;
                                        distIzq  := 1;
                                    elsif LInvPos4 = '1' then
                                        LInvPos4 <= '0';
                                        LInvPos1 <= '1'; 
                                        distASuelo := 3;
                                        distDer  := 1;
                                        distIzq  := 2;
                                    end if;
                                when "111" =>
                                    if TPos1 = '1' then
                                        TPos1 <= '0';
                                        TPos2 <= '1';
                                        distASuelo := 1;
                                        distDer  := 3;
                                        distIzq  := 1;
                                    elsif TPos2 = '1' then
                                        TPos2 <= '0';
                                        TPos3 <= '1';
                                        distASuelo := 3;
                                        distDer  := 2;
                                        distIzq  := 1;
                                    elsif TPos3 = '1' then
                                        TPos3 <= '0';
                                        TPos4 <= '1';
                                        distASuelo := 2;
                                        distDer  := 3;
                                        distIzq  := 1;
                                    elsif TPos4 = '1' then
                                        TPos4 <= '0';
                                        TPos1 <= '1';
                                        distASuelo := 3;
                                        distDer  := 1;
                                        distIzq  := 2;
                                    end if;
                             end case;
                        end if;
                    end if;
                    state := S3;
                when S8 =>
                    rd <= '0';
                    --Se hace la comprobacion de la linea
                when others =>
            end case;
        end if;
    end if;
  end process;

  ------------------

  regSumX:
  process(clk)
  begin
    if rising_edge(clk) then
        if (line = x+1 and ((pixel > 49 and pixel < 54) or (pixel > 104 and pixel < 109))) then
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
        if (pixel = y+1 and ((line > 9 and line < 14) or (line > 114 and line < 119))) then
            y <= y + 5;
            if y = 104 then
                y <= 54;
            end if;
        end if;
    end if;
  end process;
  
  Ram:
  process(clk)
  begin
    if rising_edge(clk) then    
        if wr = '1' then
            tablero(to_integer(addraIn)) <= dataIn;
            tablero(to_integer(addrbIn)) <= dataIn;
        end if;
        doa <= tablero(to_integer(addraOut));
        dob <= tablero(to_integer(addrbOut));
    end if;
  end process;

        
  
END syn;
