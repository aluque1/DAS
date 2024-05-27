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
  --constant azulOscuro : STD_LOGIC_VECTOR(11 DOWNTO 0) := "";
  --constant azulClaro : STD_LOGIC_VECTOR(11 DOWNTO 0) := "";

  --Señales teclas 
  SIGNAL aP, sP, dP, rP, spcP:  BOOLEAN := false;
  
  signal dataIn, dataOut1, dataOut2, dataOut3, dataOut4: unsigned(2 downto 0) := (others => '0');
  signal addrWr1, addrWr2, addrWr3, addrWr4, addrWr5, addrRd1, addrRd2, addrRd3, addrRd4: unsigned(7 downto 0) := (others => '0'); 

  SIGNAL rstSync : STD_LOGIC;
  SIGNAL data : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL dataRdy : STD_LOGIC;
  
  signal ce, ld : std_logic := '0';
  signal seed : std_logic_vector(2 downto 0) := "001";
  signal piezaSig : std_logic_vector(2 downto 0);
  
  SIGNAL color : STD_LOGIC_VECTOR(11 DOWNTO 0);
  signal colorPiezaActB : std_logic_vector (11 downto 0) := amarilloClaro;
  signal colorPiezaActI : std_logic_vector (11 downto 0) := amarilloOscuro;
  
  signal visual: std_logic_vector(3 downto 0) := (others => '0');--Muy seguramente aumenten los bits
  --visual(0) bordes claritos de los bordes del campo
  --visual(1) interior oscuro
  --visual(2) lineas de las piezas
  --visual(3) relleno de las piezas
  --A IMPLEMENTAR
  --visual(4) lineas piezas en el campo
  --visual(5) relleno piezas en el campo
  SIGNAL wr, cuadradoB, cuadradoI, piezaActualB, piezaActualI: STD_LOGIC;
  SIGNAL mover, finPartida, reiniciar : BOOLEAN;

  type tablero_t is array (0 to 230) of unsigned(2 downto 0); 
  signal tablero : tablero_t := (others => (others => '0'));

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
    grisClaro when "0001",
    grisOscuro when "0010",
    grisClaro when "0011",
    colorPiezaActB when "0100",
    colorPiezaActB when "1100",
    colorPiezaActI when "1000",
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
  
  visual(2) <= '1' when piezaActualB = '1' else '0';
  
  visual(3) <= '1' when piezaActualI = '1' else '0';
  
  piezaActualB <= '1' when cuadradoB = '1' else '0'; --piezaActualB <= '1' when cuadradoB = '1' or .... else '0';
  piezaActualI <= '1' when cuadradoI = '1' else '0'; --piezaActualI <= '1' when cuadradoI = '1' or .... else '0';
  
  --Implementar el aumento de velocidad
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
  
  fsm:
  process(clk, dataOut1, dataOut2, dataOut3, dataOut4)
    type states is (S0, S1, S2, S3, S4, S5, S6);
    variable state: states := S0;
    variable colision : boolean := false;
    variable CPos1, LinPos1, LinPos2, ZPos1, ZPos2, ZInvPos1, ZInvPos2, LPos1, LPos2, LPos3, LPos4, LInvPos1, LInvPos2, LInvPos3, LInvPos4, TPos1, TPos2, TPos3, TPos4 : boolean := false;
    variable distASuelo : natural := 2;
    variable distDer : natural := 2;
    variable distIzq : natural := 0;
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
                    CPos1 := false; LinPos1 := false; LinPos2 := false; ZPos1 := false; ZPos2 := false; ZInvPos1 := false; ZInvPos2 := false;
                    LPos1 := false; LPos2 := false; LPos3 := false; LPos4 := false; LInvPos1 := false; LInvPos2 := false; LInvPos3 := false;
                    LInvPos4 := false; TPos1 := false; TPos2 := false; TPos3 := false; TPos4 := false;
                    xPiezaAct := 5;
                    yPiezaAct := 1;
                    ld <= '0';
                    wr <= '0';
                    ce <= '1';
                    state := S2;
                when S2 =>
                    ce <= '0';
                    case piezaSig is
                        when "000" =>
                            CPos1 := true; distAsuelo := 2;
                            distDer := 2; distIzq := 1; 
                        when "001" =>
                            CPos1 := true;distAsuelo := 2;
                            distDer := 2; distIzq := 1;
                        when "010" =>
                            LinPos1 := true;
                            distAsuelo := 1; 
                            distDer := 4;
                            distIzq := 1; 
                        when "011" =>
                            ZPos1 := true;
                            distAsuelo := 3;
                            distDer := 3;
                            distIzq := 1; 
                        when "100" =>
                            ZInvPos1 := true;
                            distAsuelo := 3;
                            distDer := 2;
                            distIzq := 2;
                        when "101" =>
                            LPos1 := true;
                            distAsuelo := 3;
                            distDer := 2;
                            distIzq := 1;
                        when "110" =>
                            LInvPos1 := true;
                            distAsuelo := 3;
                            distDer := 1;
                            distIzq := 2;
                        when "111" =>
                            TPos1 := true;
                            distAsuelo := 3;
                            distDer := 1;
                            distIzq := 2;
                    end case;
                    state := S3;
                when S3 =>
                     dataIn <= (others => '0');
                     wr <= '1';
                     case piezaSig is
                            when "000" =>
                                addrWr1 <= to_unsigned(11*yPiezaAct + xPiezaAct, 8);
                                addrWr2 <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                addrWr3 <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                addrWr4 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                addrWr5 <= (others => '0');
                            when "001" =>
                                addrWr1 <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                addrWr2 <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                addrWr3 <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                addrWr4 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                addrWr5 <= (others => '0');
                            when "010" =>
                                if LinPos1 then
                                    addrWr1 <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrWr2 <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                    addrWr3 <= to_unsigned(11*yPiezaAct + (xPiezaAct+2),8);
                                    addrWr4 <= to_unsigned(11*yPiezaAct + (xPiezaAct+3),8);
                                    addrWr5 <= (others => '0');
                                elsif LinPos2 then
                                    addrWr1 <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrWr2 <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    addrWr3 <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrWr4 <= to_unsigned(11*(yPiezaAct+3) + xPiezaAct,8);
                                    addrWr5 <= (others => '0');
                                end if;
                            when "011" =>
                                if ZPos1 then
                                    addrWr1 <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrWr2 <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                    addrWr3 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    addrWr4 <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+1),8);
                                    addrWr5 <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+2),8);
                                elsif ZPos2 then
                                    addrWr1 <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrWr2 <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    addrWr3 <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                    addrWr4 <= to_unsigned(11*yPiezaAct + (xPiezaAct+2),8);
                                    addrWr5 <= to_unsigned(11*(yPiezaAct-1) + (xPiezaAct+2),8);
                                end if;
                            when "100" =>
                                if ZInvPos1 then
                                    addrWr1 <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrWr2 <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                    addrWr3 <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    addrWr4 <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrWr5 <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct-1),8);
                                elsif ZInvPos2 then
                                    addrWr1 <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrWr2 <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    addrWr3 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    addrWr4 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+2),8);
                                    addrWr5 <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+2),8);
                                end if;
                            when "101" =>
                                if LPos1 then
                                    addrWr1 <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrWr2 <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    addrWr3 <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrWr4 <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+1),8);
                                    addrWr5 <= (others => '0');
                                elsif LPos2 then
                                    addrWr1 <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrWr2 <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    addrWr3 <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                    addrWr4 <= to_unsigned(11*yPiezaAct + (xPiezaAct+2),8);
                                    addrWr5 <= (others => '0');
                                elsif LPos3 then
                                    addrWr1 <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrWr2 <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                    addrWr3 <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+1),8);
                                    addrWr4 <= to_unsigned(11*(yPiezaAct+3) + (xPiezaAct+1),8);
                                    addrWr5 <= (others => '0');
                                elsif LPos4 then
                                    addrWr1 <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrWr2 <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                    addrWr3 <= to_unsigned(11*yPiezaAct + (xPiezaAct+2),8);
                                    addrWr4 <= to_unsigned(11*(yPiezaAct-1) + (xPiezaAct+2),8);
                                    addrWr5 <= (others => '0');
                                end if;
                            when "110" =>
                                if LInvPos1 then
                                    addrWr1 <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrWr2 <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    addrWr3 <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrWr4 <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct-1),8);
                                    addrWr5 <= (others => '0');
                                elsif LInvPos2 then
                                    addrWr1 <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrWr2 <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    addrWr3 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    addrWr4 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+2),8);
                                    addrWr5 <= (others => '0');
                                elsif LInvPos3 then
                                    addrWr1 <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrWr2 <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                    addrWr3 <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrWr4 <= to_unsigned(11*(yPiezaAct+3) + xPiezaAct,8);
                                    addrWr5 <= (others => '0');
                                elsif LInvPos4 then
                                    addrWr1 <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrWr2 <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                    addrWr3 <= to_unsigned(11*yPiezaAct + (xPiezaAct+2),8);
                                    addrWr4 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+2),8);
                                    addrWr5 <= (others => '0');
                                end if;
                            when "111" =>
                                if TPos1 then
                                    addrWr1 <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrWr2 <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    addrWr3 <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrWr4 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct-1),8);
                                    addrWr5 <= (others => '0');
                                elsif TPos2 then
                                    addrWr1 <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrWr2 <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                    addrWr3 <= to_unsigned(11*yPiezaAct + (xPiezaAct+2),8);
                                    addrWr4 <= to_unsigned(11*(yPiezaAct-1) + (xPiezaAct+1),8);
                                    addrWr5 <= (others => '0');
                                elsif TPos3 then
                                    addrWr1 <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrWr2 <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    addrWr3 <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrWr4 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    addrWr5 <= (others => '0');
                                elsif TPos4 then
                                    addrWr1 <= to_unsigned(11*yPiezaAct + xPiezaAct,8);
                                    addrWr2 <= to_unsigned(11*yPiezaAct + (xPiezaAct+1),8);
                                    addrWr3 <= to_unsigned(11*yPiezaAct + (xPiezaAct+2),8);
                                    addrWr4 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    addrWr5 <= (others => '0');
                                end if;
                      end case;
                      state := S4;
                when S4 =>
                    colision := false;
                    if piezaSig = "000" then
                        dataIn <= to_unsigned(1, 3);
                    else
                        dataIn <= unsigned(piezaSig);
                    end if;
                    case piezaSig is
                            when "000" =>
                                addrRd1 <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                addrRd2 <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+1),8);
                                addrRd3 <= (others => '0');
                                addrRd4 <= (others => '0');
                                colision := (dataOut1 /= 0 or dataOut2 /= 0);
                            when "001" =>
                                addrRd1 <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                addrRd2 <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+1),8);
                                addrRd3 <= (others => '0');
                                addrRd4 <= (others => '0');
                                colision := (dataOut1 /= 0 or dataOut2 /= 0);
                            when "010" =>
                                if LinPos1 then
                                    addrRd1 <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    addrRd2 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    addrRd3 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+2),8);
                                    addrRd4 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+3),8);
                                    colision := (dataOut1 /= 0 or dataOut2 /= 0 or dataOut3 /= 0 or dataOut4 /= 0);
                                elsif LinPos2 then
                                    addrRd1 <= to_unsigned(11*(yPiezaAct+3) + xPiezaAct,8);
                                    addrRd2 <= (others => '0');
                                    addrRd3 <= (others => '0');
                                    addrRd4 <= (others => '0');
                                    colision := dataOut1 /= 0;
                                end if;
                            when "011" =>
                                if ZPos1 then
                                    addrRd1 <= to_unsigned(11*(yPiezaAct+3) + (xPiezaAct+1),8);
                                    addrRd2 <= to_unsigned(11*(yPiezaAct+3) + (xPiezaAct+2),8);
                                    addrRd3 <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    addrRd4 <= (others => '0');
                                    colision := (dataOut1 /= 0 or dataOut2 /= 0 or dataOut3 /= 0);
                                elsif ZPos2 then
                                    addrRd1 <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrRd2 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    addrRd3 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+2),8);
                                    addrRd4 <= (others => '0');
                                    colision := (dataOut1 /= 0 or dataOut2 /= 0 or dataOut3 /= 0);
                                end if;
                            when "100" =>
                                if ZInvPos1 then
                                    addrRd1 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    addrRd2 <= to_unsigned(11*(yPiezaAct+3) + xPiezaAct,8);
                                    addrRd3 <= to_unsigned(11*(yPiezaAct+3) + (xPiezaAct-1),8);
                                    addrRd4 <= (others => '0');
                                    colision := (dataOut1 /= 0 or dataOut2 /= 0 or dataOut3 /= 0);
                                elsif ZInvPos2 then
                                    addrRd1 <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrRd2 <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+1),8);
                                    addrRd3 <= to_unsigned(11*(yPiezaAct+3) + (xPiezaAct+2),8);
                                    addrRd4 <= (others => '0');
                                    colision := (dataOut1 /= 0 or dataOut2 /= 0 or dataOut3 /= 0);
                                end if;
                            when "101" =>
                                if LPos1 then
                                    addrRd1 <= to_unsigned(11*(yPiezaAct+3) + xPiezaAct,8);
                                    addrRd2 <= to_unsigned(11*(yPiezaAct+3) + (xPiezaAct+1),8);
                                    addrRd3 <= (others => '0');
                                    addrRd4 <= (others => '0');
                                    colision := (dataOut1 /= 0 or dataOut2 /= 0);
                                elsif LPos2 then
                                    addrRd1 <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrRd2 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    addrRd3 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+2),8);
                                    addrRd4 <= (others => '0');
                                    colision := (dataOut1 /= 0 or dataOut2 /= 0 or dataOut3 /= 0);
                                elsif LPos3 then
                                    addrRd1 <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    addrRd2 <= to_unsigned(11*(yPiezaAct+4) + (xPiezaAct+1),8);
                                    addrRd3 <= (others => '0');
                                    addrRd4 <= (others => '0');
                                    colision := (dataOut1 /= 0 or dataOut2 /= 0);
                                elsif LPos4 then
                                    addrRd1 <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    addrRd2 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    addrRd3 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+2),8);
                                    addrRd4 <= (others => '0');
                                    colision := (dataOut1 /= 0 or dataOut2 /= 0 or dataOut3 /= 0);
                                end if;
                            when "110" =>
                                if LInvPos1 then
                                    addrRd1 <= to_unsigned(11*(yPiezaAct+3) + xPiezaAct,8);
                                    addrRd2 <= to_unsigned(11*(yPiezaAct+3) + (xPiezaAct-1),8);
                                    addrRd3 <= (others => '0');
                                    addrRd4 <= (others => '0');
                                    colision := (dataOut1 /= 0 or dataOut2 /= 0);
                                elsif LInvPos2 then
                                    addrRd1 <= to_unsigned(11*(yPiezaAct+2) + xPiezaAct,8);
                                    addrRd2 <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+1),8);
                                    addrRd3 <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+2),8);
                                    addrRd4 <= (others => '0');
                                    colision := (dataOut1 /= 0 or dataOut2 /= 0 or dataOut3 /= 0);
                                elsif LInvPos3 then
                                    addrRd1 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    addrRd2 <= to_unsigned(11*(yPiezaAct+4) + xPiezaAct,8);
                                    addrRd3 <= (others => '0');
                                    addrRd4 <= (others => '0');
                                    colision := (dataOut1 /= 0 or dataOut2 /= 0);
                                elsif LInvPos4 then 
                                    addrRd1 <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    addrRd2 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    addrRd3 <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+2),8);
                                    addrRd4 <= (others => '0');
                                    colision := (dataOut1 /= 0 or dataOut2 /= 0 or dataOut3 /= 0);
                                end if;
                            when "111" =>
                                if TPos1 then
                                    addrRd1 <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct-1),8);
                                    addrRd2 <= to_unsigned(11*(yPiezaAct+3) + xPiezaAct,8);
                                    addrRd3 <= (others => '0');
                                    addrRd4 <= (others => '0');
                                    colision := (dataOut1 /= 0 or dataOut2 /= 0);
                                elsif TPos2 then
                                    addrRd1 <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    addrRd2 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+1),8);
                                    addrRd3 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+2),8);
                                    addrRd4 <= (others => '0');
                                    colision := (dataOut1 /= 0 or dataOut2 /= 0 or dataOut3 /= 0);
                                elsif TPos3 then
                                    addrRd1 <= to_unsigned(11*(yPiezaAct+3) + xPiezaAct,8);
                                    addrRd2 <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+1),8);
                                    addrRd3 <= (others => '0');
                                    addrRd4 <= (others => '0');
                                    colision := (dataOut1 /= 0 or dataOut2 /= 0);
                                elsif TPos4 then
                                    addrRd1 <= to_unsigned(11*(yPiezaAct+1) + xPiezaAct,8);
                                    addrRd2 <= to_unsigned(11*(yPiezaAct+1) + (xPiezaAct+2),8);
                                    addrRd3 <= to_unsigned(11*(yPiezaAct+2) + (xPiezaAct+1),8);
                                    addrRd4 <= (others => '0');
                                    colision := (dataOut1 /= 0 or dataOut2 /= 0 or dataOut3 /= 0);
                                end if;
                     end case;
                     if colision then
                        state := S6;
                     elsif 11*(yPiezaAct + distASuelo) = 220 then
                        state := S1;
                     else
                        state := S5;
                     end if;
                     when S5 =>
                        wr <= '0';
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
                                case piezaSig is
                                        when "000" =>
                                            CPos1 := true;
                                            distASuelo := 2;
                                            distDer  := 2;
                                            distIzq  := 1;
                                        when "001" =>
                                            CPos1 := true;
                                            distASuelo := 2;
                                            distDer  := 2;
                                            distIzq  := 1;
                                        when "010" =>
                                            if LinPos1 then
                                                LinPos1 := false;
                                                LinPos2 := true;
                                                distASuelo := 1;
                                                distDer  := 4;
                                                distIzq  := 1;
                                            elsif LinPos2 then
                                                LinPos1 := true;
                                                LinPos2 := false;
                                                distASuelo := 4;
                                                distDer  := 1;
                                                distIzq  := 1;
                                            end if;
                                        when "011" =>
                                            if ZPos1 then
                                                ZPos1 := false;
                                                ZPos2 := true;
                                                distASuelo := 2;
                                                distDer  := 3;
                                                distIzq  := 1;
                                            elsif ZPos2 then
                                                ZPos1 := true;
                                                ZPos2 := false;
                                                distASuelo := 3;
                                                distDer  := 3;
                                                distIzq  := 1;
                                            end if;
                                        when "100" =>
                                            if ZInvPos1 then
                                                ZInvPos1 := false;
                                                ZInvPos2 := true;
                                                distASuelo := 3;
                                                distDer  := 3;
                                                distIzq  := 1;
                                            elsif ZInvPos2 then
                                                ZInvPos1 := true;
                                                ZInvPos2 := false;
                                                distASuelo := 3;
                                                distDer  := 2;
                                                distIzq  := 2;
                                            end if;
                                        when "101" =>
                                            if LPos1 then
                                                LPos1 := false;
                                                LPos2 := true;
                                                distASuelo := 2;
                                                distDer  := 3;
                                                distIzq  := 1;
                                            elsif LPos2 then
                                                LPos2 := false;
                                                LPos3 := true;
                                                distASuelo := 3;
                                                distDer  := 2;
                                                distIzq  := 1;
                                            elsif LPos3 then
                                                LPos3 := false;
                                                LPos4 := true;
                                                distASuelo := 1;
                                                distDer  := 3;
                                                distIzq  := 1;
                                            elsif LPos4 then
                                                LPos4 := false;
                                                LPos1 := true;
                                                distASuelo := 3;
                                                distDer  := 2;
                                                distIzq  := 1;
                                            end if;
                                        when "110" =>
                                            if LInvPos1 then
                                                LInvPos1 := false;
                                                LInvPos2 := true;
                                                distASuelo := 2;
                                                distDer  := 3;
                                                distIzq  := 1;
                                            elsif LInvPos2 then
                                                LInvPos2 := false;
                                                LInvPos3 := true;
                                                distASuelo := 3;
                                                distDer  := 2;
                                                distIzq  := 1;
                                            elsif LInvPos3 then
                                                LInvPos3 := false;
                                                LInvPos4 := true;
                                                distASuelo := 2;
                                                distDer  := 3;
                                                distIzq  := 1;
                                            elsif LInvPos4 then
                                                LInvPos4 := false;
                                                LInvPos1 := true; 
                                                distASuelo := 3;
                                                distDer  := 1;
                                                distIzq  := 2;
                                            end if;
                                        when "111" =>
                                            if TPos1 then
                                                TPos1 := false;
                                                TPos2 := true;
                                                distASuelo := 1;
                                                distDer  := 3;
                                                distIzq  := 1;
                                            elsif TPos2 then
                                                TPos2 := false;
                                                TPos3 := true;
                                                distASuelo := 3;
                                                distDer  := 2;
                                                distIzq  := 1;
                                            elsif TPos3 then
                                                TPos3 := false;
                                                TPos4 := true;
                                                distASuelo := 2;
                                                distDer  := 3;
                                                distIzq  := 1;
                                            elsif TPos4 then
                                                TPos4 := false;
                                                TPos1 := true;
                                                distASuelo := 3;
                                                distDer  := 1;
                                                distIzq  := 2;
                                            end if;
                                 end case;
                            end if;
                        end if;
                        state := S3;
                     when S6 =>
                     --for i in 0 to 20 loop
                        --for j in 0 to 10 loop
                            
                        --end loop;
                     --end loop;
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

  escrituraRam:
  process(clk)
  begin
    if rising_edge(clk) then
        if wr = '1' then
            tablero(to_integer(addrWr1)) <= dataIn;
            tablero(to_integer(addrWr2)) <= dataIn;
            tablero(to_integer(addrWr3)) <= dataIn;
            tablero(to_integer(addrWr4)) <= dataIn;
            tablero(to_integer(addrWr5)) <= dataIn;
        end if;
    end if;
  end process;
  
  lecturaRam:
  dataOut1 <= tablero(to_integer(addrRd1));
  dataOut2 <= tablero(to_integer(addrRd2));
  dataOut3 <= tablero(to_integer(addrRd3));
  dataOut4 <= tablero(to_integer(addrRd4));
END syn;
