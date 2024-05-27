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
    RGB : OUT STD_LOGIC_VECTOR(3 * 4 - 1 DOWNTO 0);
    -- parte para IIS y audio
    sdto     : in  std_logic;
    mclkAD   : out std_logic;
    sclkAD   : out std_logic;
    lrckAD   : out std_logic;
    mclkDA   : out std_logic;
    sclkDA   : out std_logic;
    lrckDA   : out std_logic;
    sdti     : out std_logic
  );
END proyecto;

---------------------------------------------------------------------

LIBRARY ieee;
use ieee.numeric_std.all;
use ieee.math_real.all;
USE ieee.std_logic_1164;
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
  
  signal distASuelo : natural := 2; -- variable que se modifica
  
  --Se�ales teclas
  SIGNAL aP, sP, dP, rP, spcP: BOOLEAN := false;
  --Se�ales posiciones
  signal CPos1, LinPos1, LinPos2, ZPos1, ZPos2, ZInvPos1, ZInvPos2, LPos1, LPos2, LPos3, LPos4, LInvPos1, LInvPos2, LInvPos3, LInvPos4, TPos1, TPos2, TPos3, TPos4 : boolean := false;
  --Se�ales de limpieza
  signal limpC, limpLin, limpZ, limpZInv, limpL, limpLInv, limpT: boolean := false;
  --Se�ales de pintado
  signal pintC, pintLin, pintZ, pintZInv, pintL, pintLInv, pintT: boolean := false;
  --colisiones
  --signal colision, colisionC, colisionLin, colisionZ, colisionZinv, colision

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
  SIGNAL mover, colision, finPartida, reiniciar : BOOLEAN;

  type tablero_t is array (0 to 230) of unsigned(2 downto 0); 
  signal tablero : tablero_t := (others => (others => '0'));

  SIGNAL lineAux, pixelAux : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL line, pixel : unsigned(7 DOWNTO 0);
  
  signal x : natural := 14;
  signal y : natural := 54;
  
  
  -- Constants and signals for sound gen
  
  constant IIS_KHZ      : natural := 25_000;            -- frecuencia de operacion del interfaz ISS en KHz
  constant FREQ_DIV_ISS : natural := FREQ_DIV/IIS_KHZ;  -- frecuencia div para el interfaz IIS
  
  constant UNDERSAMPLE : natural := 1; 
  constant FS          : real := real(((IIS_KHZ*1000)/512)/UNDERSAMPLE); 

  constant WL : natural := 16; 
  constant QM : natural := 14; 
  constant QN : natural := WL-QM;
  
  signal   a0, b1 : signed(WL-1 downto 0); 
  constant A : real := (2.0**(QN-1))/2.0;               -- amplitud: mitad de la m�xima
  
  signal sample, outSample : std_logic_vector (WL-1 downto 0);
  signal newSample, outSampleRqt, rChannel, stdo : std_logic;
  
  signal mclk, sclk, lrck : std_logic;

  signal song : natural range 0 to 12;
  signal code : std_logic_vector(7 downto 0);
  signal songPtr : std_logic_vector(3 downto 0) := (others => '0');
  
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
  process(clk, colision)
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
                    ld <= '0';
                    ce <= '1';
                    state := S2;
                when S2 =>
                    ce <= '0';
                    --NOTA hay que ponerlos a false en algun momento
                    --Aqui se actualizan las distancias de los bordes de las piezas
                    case piezaSig is
                        when "000" =>
                            CPos1 <= true;
                        when "001" =>
                            CPos1 <= true;
                        when "010" =>
                            LinPos1 <= true;
                        when "011" =>
                            ZPos1 <= true;
                        when "100" =>
                            ZInvPos1 <= true;
                        when "101" =>
                            LPos1 <= true;
                        when "110" =>
                            LInvPos1 <= true;
                        when "111" =>
                            TPos1 <= true;
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
                  --NOTA hay que ponerlos a false en algun momento
                    case piezaSig is
                            when "000" =>
                                pintC <= true;
                            when "001" =>
                                pintC <= true;
                            when "010" =>
                                pintLin <= true;
                            when "011" =>
                                pintZ <= true;
                            when "100" =>
                                pintZInv <= true;
                            when "101" =>
                                pintL <= true;
                            when "110" =>
                                pintLInv <= true;
                            when "111" =>
                                pintT <= true;
                     end case;
                     --si hay colision saltamos al estado de comprobar si linea completa, antes de la colision que sea final de tab
                     --si no, cae
                     when others =>
            end case;
        end if;
    end if;
  end process;
  
  --Replantear el movimiento entero de la pieza
  --movPiezaTab:
 -- process(clk)
 -- begin
 --   if rising_edge(clk) then
--        if mover then
  --          if yPiezaAct + distASuelo < 220 and ... and (xPiezaAct > 0 and xPiezaAct < 11) then --falta la se�al colision
 --               --Aqui se manda la se�al para borrar la pieza
  --              if sP then
   --                 yPiezaAct <= yPiezaAct + 2;
   --             else
   --                 yPiezaAct <= yPiezaAct + 1;
   --             end if;
    --            if aP then
   --                 xPiezaAct <= xPiezaAct - 1;
   --             end if;
   --             if dP then
   --                 xPiezaAct <= xPiezaAct + 1;
   --             end if;
   --         end if;
   --     end if;
   -- end if;
  --end process;


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
  
  colision <= true when CPos1 and (tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) /= 0 or tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+1))) /= 0) else false;
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
  
  colision <= true when LinPos1 and (tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) /= 0 or
                                    tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) /= 0 or
                                    tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2))) /= 0 or
                                    tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+3))) /= 0) else false;
  
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
  
  colision <= true when LinPos2 and tablero(to_integer(11*(yPiezaAct+3) + xPiezaAct)) /= 0 else false;

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
  
  colision <= true when ZPos1 and (tablero(to_integer(11*(yPiezaAct+3) + (xPiezaAct+1))) /= 0 or 
                                   tablero(to_integer(11*(yPiezaAct+3) + (xPiezaAct+2))) /= 0 or   
                                   tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) /= 0) else false;
  
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
  
  colision <= true when Zpos2 and (tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2))) /= 0) else false;
  
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
  
  colision <= true when ZInvPos1 and (tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) /= 0 or
                                      tablero(to_integer(11*(yPiezaAct+3) + xPiezaAct)) /= 0 or
                                      tablero(to_integer(11*(yPiezaAct+3) + (xPiezaAct-1))) /= 0) else false;
  
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
  
  colision <= true when ZInvPos2 and (tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) /= 0 or
                                      tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+1))) /= 0 or
                                      tablero(to_integer(11*(yPiezaAct+3) + (xPiezaAct+2))) /= 0) else false;
  
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
  
  colision <= true when LPos1 and (tablero(to_integer(11*(yPiezaAct+3) + xPiezaAct)) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+3) + (xPiezaAct+1))) /= 0) else false;
  
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
  
  colision <= true when LPos2 and (tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2))) /= 0) else false;
  
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
  
  colision <= true when LPos3 and (tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+4) + (xPiezaAct+1))) /= 0) else false;
  
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
  
  colision <= true when LPos4 and (tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2))) /= 0) else false;
  
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
  
  colision <= true when LInvPos1 and (tablero(to_integer(11*(yPiezaAct+3) + xPiezaAct)) /= 0 or
                                      tablero(to_integer(11*(yPiezaAct+3) + (xPiezaAct-1))) /= 0) else false;
  
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
  
  colision <= true when LInvPos2 and (tablero(to_integer(11*(yPiezaAct+2) + xPiezaAct)) /= 0 or
                                      tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+1))) /= 0 or
                                      tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+2))) /= 0) else false;
  
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
  
  colision <= true when LInvPos3 and (tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) /= 0 or
                                      tablero(to_integer(11*(yPiezaAct+4) + xPiezaAct)) /= 0) else false;
  
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
  
  colision <= true when LInvPos4 and (tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) /= 0 or
                                      tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) /= 0 or
                                      tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+2))) /= 0) else false;
  
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
  
  colision <= true when TPos1 and (tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct-1))) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+3) + xPiezaAct)) /= 0) else false;
  
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
  
  colision <= true when TPos2 and (tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+1))) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2))) /= 0) else false;
  
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
  
  colision <= true when TPos3 and (tablero(to_integer(11*(yPiezaAct+3) + xPiezaAct)) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+1))) /= 0) else false;
  
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
  
  colision <= true when TPos4 and (tablero(to_integer(11*(yPiezaAct+1) + xPiezaAct)) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+1) + (xPiezaAct+2))) /= 0 or
                                   tablero(to_integer(11*(yPiezaAct+2) + (xPiezaAct+1))) /= 0) else false;
    
  -- Sound generation ---------------------------------------
  
  songCounter:
  process(clk)

  begin
  end process;
  
  
  b1ROM : 
  with code select -- el code tiene que ser otra cosa
    b1 <=
      toFix( A*sin(2.0*MATH_PI*261.6/FS), QN, QM ) when X"1c",  -- A = Do
      toFix( A*sin(2.0*MATH_PI*277.2/FS), QN, QM ) when X"1d",  -- W = Do#
      toFix( A*sin(2.0*MATH_PI*293.7/FS), QN, QM ) when X"1b",  -- S = Re
      toFix( A*sin(2.0*MATH_PI*311.1/FS), QN, QM ) when X"24",  -- E = Re#
      toFix( A*sin(2.0*MATH_PI*329.6/FS), QN, QM ) when X"23",  -- D = Mi
      toFix( A*sin(2.0*MATH_PI*349.2/FS), QN, QM ) when X"2b",  -- F = Fa
      toFix( A*sin(2.0*MATH_PI*370.0/FS), QN, QM ) when X"2c",  -- T = Fa#
      toFix( A*sin(2.0*MATH_PI*392.0/FS), QN, QM ) when X"34",  -- G = Sol
      toFix( A*sin(2.0*MATH_PI*415.3/FS), QN, QM ) when X"35",  -- Y = Sol#
      toFix( A*sin(2.0*MATH_PI*440.0/FS), QN, QM ) when X"33",  -- H = La
      toFix( A*sin(2.0*MATH_PI*466.2/FS), QN, QM ) when X"3c",  -- U = La#
      toFix( A*sin(2.0*MATH_PI*493.9/FS), QN, QM ) when X"3b",  -- J = Si
      toFix( A*sin(2.0*MATH_PI*523.3/FS), QN, QM ) when X"42",  -- K = Do
      X"0000" when others;  
     
  y1ROM :
  with data select -- Todo esto hay que cambiarlo. no entiendo muy bien porque es data 
  -- supongo que el data va a ser nuestra "partitura"
    a0 <=
      toFix( A*sin(2.0*MATH_PI*261.6/FS), QN, QM ) when X"1c",  -- A = Do
      toFix( A*sin(2.0*MATH_PI*277.2/FS), QN, QM ) when X"1d",  -- W = Do#
      toFix( A*sin(2.0*MATH_PI*293.7/FS), QN, QM ) when X"1b",  -- S = Re
      toFix( A*sin(2.0*MATH_PI*311.1/FS), QN, QM ) when X"24",  -- E = Re#
      toFix( A*sin(2.0*MATH_PI*329.6/FS), QN, QM ) when X"23",  -- D = Mi
      toFix( A*sin(2.0*MATH_PI*349.2/FS), QN, QM ) when X"2b",  -- F = Fa
      toFix( A*sin(2.0*MATH_PI*370.0/FS), QN, QM ) when X"2c",  -- T = Fa#
      toFix( A*sin(2.0*MATH_PI*392.0/FS), QN, QM ) when X"34",  -- G = Sol
      toFix( A*sin(2.0*MATH_PI*415.3/FS), QN, QM ) when X"35",  -- Y = Sol#
      toFix( A*sin(2.0*MATH_PI*440.0/FS), QN, QM ) when X"33",  -- H = La
      toFix( A*sin(2.0*MATH_PI*466.2/FS), QN, QM ) when X"3c",  -- U = La#
      toFix( A*sin(2.0*MATH_PI*493.9/FS), QN, QM ) when X"3b",  -- J = Si
      toFix( A*sin(2.0*MATH_PI*523.3/FS), QN, QM ) when X"42",  -- K = Do
      X"0000" when others; 
  
  --  El new tone seguramente este mal pero no tengo ni idea de que es 
  soundGen : iirOscillator
    generic map (WL => WL, QM => QM, FS => FS )
    port map ( clk => clk, newTone => '1', newSample => newSample, b1 => std_logic_vector(b1), a0 => std_logic_vector(a0), sample => sample );  

    outSample <= sample;
    
  -- parte del iis
  mclkAD <= mclk;
  sclkAD <= sclk;
  lrckAD <= lrck;
  
  mclkDA <= mclk;
  sclkDA <= sclk;
  lrckDA <= lrck;
  
  codecInterface : iisInterface
    generic map( WL => WL,  FREQ_DIV => FREQ_DIV_ISS,  UNDERSAMPLE => UNDERSAMPLE ) 
    port map( 
      clk => clk, rChannel => rChannel, newSample => newSample, inSample => open, outSample => outSample,
      mclk => mclk, sclk => sclk, lrck => lrck, sdti => sdti, sdto => sdto
    );
  
  
END syn;
