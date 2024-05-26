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
  
  signal xPiezaAct : unsigned(7 downto 0) := to_unsigned(5, 8);
  signal yPiezaAct : unsigned(7 downto 0) := to_unsigned(1, 8);
  
  signal distASuelo : natural := 2;
  signal distDer : natural := 2;
  signal distIzq : natural := 0;
  
  --Se�ales teclas 
  SIGNAL aP, sP, dP, rP, spcP:  BOOLEAN := false;
  --Se�ales posiciones
  signal CPos1, LinPos1, LinPos2, ZPos1, ZPos2, ZInvPos1, ZInvPos2, LPos1, LPos2, LPos3, LPos4, LInvPos1, LInvPos2, LInvPos3, LInvPos4, TPos1, TPos2, TPos3, TPos4 : boolean := false;
  --Se�ales de limpieza
  signal limpC, limpLin, limpZ, limpZInv, limpL, limpLInv, limpT: boolean := false;
  --Se�ales de pintado
  signal pintC, pintLin, pintZ, pintZInv, pintL, pintLInv, pintT: boolean := false;
  
  signal colision, colCPos1, colLinPos1, colLinPos2, colZPos1, colZPos2, colZInvPos1, colZInvPos2, colLPos1, colLPos2, colLPos3, colLPos4, colLInvPos1, colLInvPos2, colLInvPos3, colLInvPos4, colTPos1, colTPos2, colTPos3, colTPos4 : std_logic;
  
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
  SIGNAL cuadradoB, cuadradoI, piezaActualB, piezaActualI: STD_LOGIC;
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
  
  cuadradoB <= '1' when ((pixel = xPiezaAct or pixel = (xPiezaAct + 10) or pixel = (xPiezaAct + 5)) and (line >= yPiezaAct and line <= (yPiezaAct + 10))) or
                         ((line = yPiezaAct or line = (yPiezaAct + 10) or line = (yPiezaAct + 5)) and (pixel >= xPiezaAct and pixel <= (xPiezaAct + 10))) else '0';
                         --Aqui poner variable que le indique cuando pintarse
  cuadradoI <= '1' when (pixel > xPiezaAct and pixel < (xPiezaAct + 10)) and (line > yPiezaAct and line < (yPiezaAct + 10)) else '0';
  
  
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
  process(clk)
    type states is (S0, S1, S2, S3, S4, S5, S6);
    variable state: states := S0;
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
                    CPos1 <= false; LinPos1 <= false; LinPos2 <= false; ZPos1 <= false; ZPos2 <= false; ZInvPos1 <= false; ZInvPos2 <= false;
                    LPos1 <= false; LPos2 <= false; LPos3 <= false; LPos4 <= false; LInvPos1 <= false; LInvPos2 <= false; LInvPos3 <= false;
                    LInvPos4 <= false; TPos1 <= false; TPos2 <= false; TPos3 <= false; TPos4 <= false; limpC  <= false; limpLin <= false; 
                    limpZ <= false; limpZInv <= false; limpL <= false; limpLInv <= false; limpT <= false; pintC <= false; pintLin <= false; 
                    pintZ <= false; pintZInv <= false; pintL <= false; pintLInv <= false; pintT <= false;
                    xPiezaAct <= to_unsigned(5, 8);
                    yPiezaAct <= to_unsigned(1, 8);
                    ld <= '0';
                    ce <= '1';
                    state := S2;
                when S2 =>
                    ce <= '0';
                    case piezaSig is
                        when "000" =>
                            CPos1 <= true;
                            distAsuelo <= 2;
                            distDer <= 2;
                            distIzq <= 1; 
                        when "001" =>
                            CPos1 <= true;
                            distAsuelo <= 2;
                            distDer <= 2;
                            distIzq <= 1; 
                        when "010" =>
                            LinPos1 <= true;
                            distAsuelo <= 1; 
                            distDer <= 4;
                            distIzq <= 1; 
                        when "011" =>
                            ZPos1 <= true;
                            distAsuelo <= 3;
                            distDer <= 3;
                            distIzq <= 1; 
                        when "100" =>
                            ZInvPos1 <= true;
                            distAsuelo <= 3;
                            distDer <= 2;
                            distIzq <= 2;
                        when "101" =>
                            LPos1 <= true;
                            distAsuelo <= 3;
                            distDer <= 2;
                            distIzq <= 1;
                        when "110" =>
                            LInvPos1 <= true;
                            distAsuelo <= 3;
                            distDer <= 1;
                            distIzq <= 2;
                        when "111" =>
                            TPos1 <= true;
                            distAsuelo <= 3;
                            distDer <= 1;
                            distIzq <= 2;
                    end case;
                    state := S3;
                 when S3 =>
                 --NOTA hay que ponerlos a false en algun momento
                     case piezaSig is
                            when "000" =>
                                limpC <= true;
                            when "001" =>
                                limpC <= true;
                            when "010" =>
                                limpLin <= true;
                            when "011" =>
                                limpZ <= true;
                            when "100" =>
                                limpZInv <= true;
                            when "101" =>
                                limpL <= true;
                            when "110" =>
                                limpLInv <= true;
                            when "111" =>
                                limpT <= true;
                      end case;
                        state := S4;
                  when S4 =>
                    case piezaSig is
                            when "000" =>
                                limpC <= false;
                                pintC <= true;
                            when "001" =>
                                limpC <= false;
                                pintC <= true;
                            when "010" =>
                                limpLin <= false;
                                pintLin <= true;
                            when "011" =>
                                limpZ <= false;
                                pintZ <= true;
                            when "100" =>
                                limpZInv <= false;
                                pintZInv <= true;
                            when "101" =>
                                limpL <= false;
                                pintL <= true;
                            when "110" =>
                                limpLInv <= false;
                                pintLInv <= true;
                            when "111" =>
                                limpT <= false;
                                pintT <= true;
                     end case;
                     if colision = '1' then
                        state := S6;
                     elsif 11*(yPiezaAct + distASuelo) = 220 then
                        state := S1;
                     else
                        state := S5;
                     end if;
                     when S5 =>
                        pintC <= false; pintLin <= false; pintZ <= false; pintZInv <= false; pintL <= false; pintLInv <= false; pintT <= false;
                        if mover then
                            if 11*(yPiezaAct + distASuelo) > 220 then
                                if sP then
                                    yPiezaAct <= yPiezaAct + 2;
                                else
                                    yPiezaAct <= yPiezaAct + 1;
                                end if;
                            end if;
                            if xPiezaAct + distDer < 10 and dP then
                                xPiezaAct <= xPiezaAct + 1;
                            end if;
                            if xPiezaAct - distIzq > 0 and aP then
                                xPiezaAct <= xPiezaAct - 1;
                            end if;
                        end if;
                        state := S3;
                     when S6 =>
                     pintC <= false; pintLin <= false; pintZ <= false; pintZInv <= false; pintL <= false; pintLInv <= false; pintT <= false;
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

-------------------------------------------
--Limpiado, dibujado de piezas y colision--
-------------------------------------------
  
  colision <= '1' when colCPos1 = '1' or colLinPos1 = '1' or colLinPos2 = '1' or colZPos1 = '1' or colZPos2 = '1' or colZInvPos1 = '1' or colZInvPos2 = '1' or colLPos1 = '1' or colLPos2 = '1' or colLPos3 = '1' or colLPos4 = '1' or colLInvPos1 = '1' or colLInvPos2 = '1' or colLInvPos3 = '1' or colLInvPos4 = '1' or colTPos1 = '1' or colTPos2 = '1' or colTPos3 = '1' or colTPos4 = '1' else '0'; 
    
  limpiaCuadrado:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= (others => '0') when limpC and CPos1 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= (others => '0') when limpC and CPos1 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) <= (others => '0') when limpC and CPos1 else tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) <= (others => '0') when limpC and CPos1 else tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1)));
  
  pintaCuadrado:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= to_unsigned(1,3) when pintC and CPos1 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= to_unsigned(1,3) when pintC and CPos1 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) <= to_unsigned(1,3) when pintC and CPos1 else tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) <= to_unsigned(1,3) when pintC and CPos1 else tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1)));
  
  colCPos1 <= '1' when CPos1 and (tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) /= 0 or tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+1))) /= 0) else '0';
---------------------------------
   
  limpiaLineaPos1:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= (others => '0') when limpLin and LinPos1 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= (others => '0') when limpLin and LinPos1 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+2))) <= (others => '0') when limpLin and LinPos1 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+2)));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+3))) <= (others => '0') when limpLin and LinPos1 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+3)));
  
  pintaLineaPos1:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= to_unsigned(2,3) when pintLin and LinPos1 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= to_unsigned(2,3) when pintLin and LinPos1 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+2))) <= to_unsigned(2,3) when pintLin and LinPos1 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+2)));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+3))) <= to_unsigned(2,3) when pintLin and LinPos1 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+3)));
  
  colLinPos1 <= '1' when LinPos1 and (tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) /= 0 or
                                    tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) /= 0 or
                                    tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2))) /= 0 or
                                    tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+3))) /= 0) else '0';
  
  limpiaLineaPos2:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= (others => '0') when limpLin and LinPos2 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) <= (others => '0') when limpLin and LinPos2 else tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) <= (others => '0') when limpLin and LinPos2 else tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+3) + xPiezaAct)) <= (others => '0') when limpLin and LinPos2 else tablero(to_integer(11*(yPiezaAct+3) + xPiezaAct));
  
  pintaLineaPos2:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= to_unsigned(2,3) when pintLin and LinPos2 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) <= to_unsigned(2,3) when pintLin and LinPos2 else tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) <= to_unsigned(2,3) when pintLin and LinPos2 else tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+3) + xPiezaAct)) <= to_unsigned(2,3) when pintLin and LinPos2 else tablero(to_integer(11*(yPiezaAct+3) + xPiezaAct));
  
  colLinPos2 <= '1' when LinPos2 and tablero(to_integer(11*(yPiezaAct+3) + xPiezaAct)) /= 0 else '0';

---------------------------------

  limpiaZetaPos1:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= (others => '0') when limpZ and ZPos1 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= (others => '0') when limpZ and ZPos1 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) <= (others => '0') when limpZ and ZPos1 else tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1)));
  tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+1))) <= (others => '0') when limpZ and ZPos1 else tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+1)));
  tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+2))) <= (others => '0') when limpZ and ZPos1 else tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+2)));
  
  pintaZetaPos1:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= to_unsigned(3,3) when pintZ and ZPos1 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= to_unsigned(3,3) when pintZ and ZPos1 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) <= to_unsigned(3,3) when pintZ and ZPos1 else tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1)));
  tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+1))) <= to_unsigned(3,3) when pintZ and ZPos1 else tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+1)));
  tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+2))) <= to_unsigned(3,3) when pintZ and ZPos1 else tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+2)));
  
  colZPos1 <= '1' when ZPos1 and (tablero(to_integer(11*(yPiezaAct+3) + (xPiezaAct+1))) /= 0 or 
                                   tablero(to_integer(11*(yPiezaAct+3) + (xPiezaAct+2))) /= 0 or   
                                   tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) /= 0) else '0';
  
  limpiaZetaPos2:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= (others => '0') when limpZ and ZPos2 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) <= (others => '0') when limpZ and ZPos2 else tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= (others => '0') when limpZ and ZPos2 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+2))) <= (others => '0') when limpZ and ZPos2 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+2)));
  tablero(to_integer(11*(yPiezaAct-1) + (xPiezaAct+2))) <= (others => '0') when limpZ and ZPos2 else tablero(to_integer(11*(yPiezaAct-1) + (xPiezaAct+2)));
  
  pintaZetaPos2:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= to_unsigned(3,3) when pintZ and ZPos2 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) <= to_unsigned(3,3) when pintZ and ZPos2 else tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= to_unsigned(3,3) when pintZ and ZPos2 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+2))) <= to_unsigned(3,3) when pintZ and ZPos2 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+2)));
  tablero(to_integer(11*(yPiezaAct-1) + (xPiezaAct+2))) <= to_unsigned(3,3) when pintZ and ZPos2 else tablero(to_integer(11*(yPiezaAct-1) + (xPiezaAct+2)));
  
  colZPos2 <= '1' when Zpos2 and (tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2))) /= 0) else '0';
  
---------------------------------
  
  limpiaZetaInvPos1:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= (others => '0') when limpZInv and ZInvPos1 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= (others => '0') when limpZInv and ZInvPos1 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) <= (others => '0') when limpZInv and ZInvPos1 else tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) <= (others => '0') when limpZInv and ZInvPos1 else tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct-1))) <= (others => '0') when limpZInv and ZInvPos1 else tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct-1)));
  
  pintaZetaInvPos1:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= to_unsigned(4,3) when pintZInv and ZInvPos1 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= to_unsigned(4,3) when pintZInv and ZInvPos1 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) <= to_unsigned(4,3) when pintZInv and ZInvPos1 else tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) <= to_unsigned(4,3) when pintZInv and ZInvPos1 else tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct-1))) <= to_unsigned(4,3) when pintZInv and ZInvPos1 else tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct-1)));
  
  colZInvPos1 <= '1' when ZInvPos1 and (tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) /= 0 or
                                      tablero(to_integer(11*(yPiezaAct+3) + xPiezaAct)) /= 0 or
                                      tablero(to_integer(11*(yPiezaAct+3) + (xPiezaAct-1))) /= 0) else '0';
  
  limpiaZetaInvPos2:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= (others => '0') when limpZInv and ZInvPos2 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) <= (others => '0') when limpZInv and ZInvPos2 else tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) <= (others => '0') when limpZInv and ZInvPos2 else tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1)));
  tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2))) <= (others => '0') when limpZInv and ZInvPos2 else tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2)));
  tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+2))) <= (others => '0') when limpZInv and ZInvPos2 else tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+2)));
  
  pintaZetaInvPos2:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= to_unsigned(4,3) when pintZInv and ZInvPos2 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) <= to_unsigned(4,3) when pintZInv and ZInvPos2 else tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) <= to_unsigned(4,3) when pintZInv and ZInvPos2 else tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1)));
  tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2))) <= to_unsigned(4,3) when pintZInv and ZInvPos2 else tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2)));
  tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+2))) <= to_unsigned(4,3) when pintZInv and ZInvPos2 else tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+2)));
  
  colZInvPos2 <= '1' when ZInvPos2 and (tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) /= 0 or
                                      tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+1))) /= 0 or
                                      tablero(to_integer(11*(yPiezaAct+3) + (xPiezaAct+2))) /= 0) else '0';
  
---------------------------------
  
  limpiaElePos1:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= (others => '0') when limpL and LPos1 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) <= (others => '0') when limpL and LPos1 else tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) <= (others => '0') when limpL and LPos1 else tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+1))) <= (others => '0') when limpL and LPos1 else tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+1)));
  
  pintaElePos1:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= to_unsigned(5,3) when pintL and LPos1 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) <= to_unsigned(5,3) when pintL and LPos1 else tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) <= to_unsigned(5,3) when pintL and LPos1 else tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+1))) <= to_unsigned(5,3) when pintL and LPos1 else tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+1)));
  
  colLPos1 <= '1' when LPos1 and (tablero(to_integer(11*(yPiezaAct+3) + xPiezaAct)) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+3) + (xPiezaAct+1))) /= 0) else '0';
  
  limpiaElePos2:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= (others => '0') when limpL and LPos2 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) <= (others => '0') when limpL and LPos2 else tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= (others => '0') when limpL and LPos2 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+2))) <= (others => '0') when limpL and LPos2 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+2)));
  
  pintaElePos2:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= to_unsigned(5,3) when pintL and LPos2 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) <= to_unsigned(5,3) when pintL and LPos2 else tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= to_unsigned(5,3) when pintL and LPos2 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+2))) <= to_unsigned(5,3) when pintL and LPos2 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+2)));
  
  colLPos2 <= '1' when LPos2 and (tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2))) /= 0) else '0';
  
  limpiaElePos3:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= (others => '0') when limpL and LPos3 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= (others => '0') when limpL and LPos3 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+1))) <= (others => '0') when limpL and LPos3 else tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+1)));
  tablero(to_integer(11*(yPiezaAct+3) + (xPiezaAct+1))) <= (others => '0') when limpL and LPos3 else tablero(to_integer(11*(yPiezaAct+3) + (xPiezaAct+1)));
   
  pintaElePos3:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= to_unsigned(5,3) when pintL and LPos3 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= to_unsigned(5,3) when pintL and LPos3 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+1))) <= to_unsigned(5,3) when pintL and LPos3 else tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+1)));
  tablero(to_integer(11*(yPiezaAct+3) + (xPiezaAct+1))) <= to_unsigned(5,3) when pintL and LPos3 else tablero(to_integer(11*(yPiezaAct+3) + (xPiezaAct+1)));
  
  colLPos3 <= '1' when LPos3 and (tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+4) + (xPiezaAct+1))) /= 0) else '0';
  
  limpiaElePos4:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= (others => '0') when limpL and LPos4 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= (others => '0') when limpL and LPos4 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+2))) <= (others => '0') when limpL and LPos4 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+2)));
  tablero(to_integer(11*(yPiezaAct-1) + (xPiezaAct+2))) <= (others => '0') when limpL and LPos4 else tablero(to_integer(11*(yPiezaAct-1) + (xPiezaAct+2)));
  
  pintaElePos4:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= to_unsigned(5,3) when pintL and LPos4 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= to_unsigned(5,3) when pintL and LPos4 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+2))) <= to_unsigned(5,3) when pintL and LPos4 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+2)));
  tablero(to_integer(11*(yPiezaAct-1) + (xPiezaAct+2))) <= to_unsigned(5,3) when pintL and LPos4 else tablero(to_integer(11*(yPiezaAct-1) + (xPiezaAct+2)));
  
  colLPos4 <= '1' when LPos4 and (tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2))) /= 0) else '0';
---------------------------------
  
  limpiaEleInvPos1:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= (others => '0') when limpLInv and LInvPos1 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) <= (others => '0') when limpLInv and LInvPos1 else tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) <= (others => '0') when limpLInv and LInvPos1 else tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct-1))) <= (others => '0') when limpLInv and LInvPos1 else tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct-1)));
  
  pintaEleInvPos1:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= to_unsigned(6,3) when pintLInv and LInvPos1 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) <= to_unsigned(6,3) when pintLInv and LInvPos1 else tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) <= to_unsigned(6,3) when pintLInv and LInvPos1 else tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct-1))) <= to_unsigned(6,3) when pintLInv and LInvPos1 else tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct-1)));
  
  colLInvPos1 <= '1' when LInvPos1 and (tablero(to_integer(11*(yPiezaAct+3) + xPiezaAct)) /= 0 or
                                      tablero(to_integer(11*(yPiezaAct+3) + (xPiezaAct-1))) /= 0) else '0';
  
  limpiaEleInvPos2:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= (others => '0') when limpLInv and LInvPos2 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) <= (others => '0') when limpLInv and LInvPos2 else tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) <= (others => '0') when limpLInv and LInvPos2 else tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1)));
  tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2))) <= (others => '0') when limpLInv and LInvPos2 else tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2)));
  
  pintaEleInvPos2:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= to_unsigned(6,3) when pintLInv and LInvPos2 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) <= to_unsigned(6,3) when pintLInv and LInvPos2 else tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) <= to_unsigned(6,3) when pintLInv and LInvPos2 else tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1)));
  tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2))) <= to_unsigned(6,3) when pintLInv and LInvPos2 else tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2)));
  
  colLInvPos2 <= '1' when LInvPos2 and (tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) /= 0 or
                                      tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+1))) /= 0 or
                                      tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+2))) /= 0) else '0';
  
  limpiaEleInvPos3:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= (others => '0') when limpLInv and LInvPos3 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= (others => '0') when limpLInv and LInvPos3 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) <= (others => '0') when limpLInv and LInvPos3 else tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+3) + xPiezaAct)) <= (others => '0') when limpLInv and LInvPos3 else tablero(to_integer(11*(yPiezaAct+3) + xPiezaAct));
  
  pintaEleInvPos3:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= to_unsigned(6,3) when pintLInv and LInvPos3 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= to_unsigned(6,3) when pintLInv and LInvPos3 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) <= to_unsigned(6,3) when pintLInv and LInvPos3 else tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+3) + xPiezaAct)) <= to_unsigned(6,3) when pintLInv and LInvPos3 else tablero(to_integer(11*(yPiezaAct+3) + xPiezaAct));
  
  colLInvPos3 <= '1' when LInvPos3 and (tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) /= 0 or
                                      tablero(to_integer(11*(yPiezaAct+4) + xPiezaAct)) /= 0) else '0';
  
  limpiaEleInvPos4:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= (others => '0') when limpLInv and LInvPos4 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= (others => '0') when limpLInv and LInvPos4 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+2))) <= (others => '0') when limpLInv and LInvPos4 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+2)));
  tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2))) <= (others => '0') when limpLInv and LInvPos4 else tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2)));
  
  pintaEleInvPos4:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= to_unsigned(6,3) when pintLInv and LInvPos4 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= to_unsigned(6,3) when pintLInv and LInvPos4 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+2))) <= to_unsigned(6,3) when pintLInv and LInvPos4 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+2)));
  tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2))) <= to_unsigned(6,3) when pintLInv and LInvPos4 else tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2)));
  
  colLInvPos4 <= '1' when LInvPos4 and (tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) /= 0 or
                                      tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) /= 0 or
                                      tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+2))) /= 0) else '0';
  
---------------------------------
  
  limpiaTePos1:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= (others => '0') when limpT and TPos1 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) <= (others => '0') when limpT and TPos1 else tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) <= (others => '0') when limpT and TPos1 else tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct-1))) <= (others => '0') when limpT and TPos1 else tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct-1)));
   
  pintaTePos1:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= to_unsigned(7,3) when pintT and TPos1 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) <= to_unsigned(7,3) when pintT and TPos1 else tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) <= to_unsigned(7,3) when pintT and TPos1 else tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct-1))) <= to_unsigned(7,3) when pintT and TPos1 else tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct-1)));
  
  colTPos1 <= '1' when TPos1 and (tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct-1))) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+3) + xPiezaAct)) /= 0) else '0';
  
  limpiaTePos2:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= (others => '0') when limpT and TPos2 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= (others => '0') when limpT and TPos2 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+2))) <= (others => '0') when limpT and TPos2 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+2)));
  tablero(to_integer(11*(yPiezaAct-1) + (xPiezaAct+1))) <= (others => '0') when limpT and TPos2 else tablero(to_integer(11*(yPiezaAct-1) + (xPiezaAct+1)));
   
  pintaTePos2:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= to_unsigned(7,3) when pintT and TPos2 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= to_unsigned(7,3) when pintT and TPos2 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+2))) <= to_unsigned(7,3) when pintT and TPos2 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+2)));
  tablero(to_integer(11*(yPiezaAct-1) + (xPiezaAct+1))) <= to_unsigned(7,3) when pintT and TPos2 else tablero(to_integer(11*(yPiezaAct-1) + (xPiezaAct+1)));
  
  colTPos2 <= '1' when TPos2 and (tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2))) /= 0) else '0';
  
  limpiaTePos3:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= (others => '0') when limpT and TPos3 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) <= (others => '0') when limpT and TPos3 else tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) <= (others => '0') when limpT and TPos3 else tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) <= (others => '0') when limpT and TPos3 else tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1)));
   
  pintaTePos3:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= to_unsigned(7,3) when pintT and TPos3 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) <= to_unsigned(7,3) when pintT and TPos3 else tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) <= to_unsigned(7,3) when pintT and TPos3 else tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct));
  tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) <= to_unsigned(7,3) when pintT and TPos3 else tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1)));
  
  colTPos3 <= '1' when TPos3 and (tablero(to_integer(11*(yPiezaAct+3) + xPiezaAct)) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+1))) /= 0) else '0';
  
  limpiaTePos4:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= (others => '0') when limpT and TPos4 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= (others => '0') when limpT and TPos4 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+2))) <= (others => '0') when limpT and TPos4 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+2)));
  tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) <= (others => '0') when limpT and TPos4 else tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1)));
   
  pintaTePos4:
  tablero(to_integer(11*yPiezaAct + xPiezaAct)) <= to_unsigned(7,3) when pintT and TPos4 else tablero(to_integer(11*yPiezaAct + xPiezaAct));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+1))) <= to_unsigned(7,3) when pintT and TPos4 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+1)));
  tablero(to_integer(11*yPiezaAct + (xPiezaAct+2))) <= to_unsigned(7,3) when pintT and TPos4 else tablero(to_integer(11*yPiezaAct + (xPiezaAct+2)));
  tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) <= to_unsigned(7,3) when pintT and TPos4 else tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1)));
  
  colTPos4 <= '1' when TPos4 and (tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2))) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+1))) /= 0) else '0';
  
END syn;
