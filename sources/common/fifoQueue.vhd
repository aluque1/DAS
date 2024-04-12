-------------------------------------------------------------------
--
--  Fichero:
--    fifo.vhd  1/10/2015
--
--    (c) J.M. Mendias
--    Dise�o Autom�tico de Sistemas
--    Facultad de Inform�tica. Universidad Complutense de Madrid
--
--  Prop�sito:
--    Buffer de tipo FIFO
--
--  Notas de dise�o:
--    - Est� implementada como un banco de registros
--    - Si la FIFO est� llena, los nuevos datos que se intenten 
--      almacenar se ignoran
--    - Si la FIFO est� vac�a, las lecturas devuelven valores no
--      validos
--
-------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.common.ALL;

ENTITY fifoQueue IS
  GENERIC (
    WL : NATURAL; -- anchura de la palabra de fifo
    DEPTH : NATURAL -- numero de palabras en fifo
  );
  PORT (
    clk : IN STD_LOGIC; -- reloj del sistema
    rst : IN STD_LOGIC; -- reset s�ncrono del sistema
    wrE : IN STD_LOGIC; -- se activa durante 1 ciclo para escribir un dato en la fifo
    dataIn : IN STD_LOGIC_VECTOR(WL - 1 DOWNTO 0); -- dato a escribir
    rdE : IN STD_LOGIC; -- se activa durante 1 ciclo para leer un dato de la fifo
    dataOut : OUT STD_LOGIC_VECTOR(WL - 1 DOWNTO 0); -- dato a leer
    numData : OUT STD_LOGIC_VECTOR(log2(DEPTH) - 1 DOWNTO 0); -- numero de datos almacenados
    full : OUT STD_LOGIC; -- indicador de fifo llena
    empty : OUT STD_LOGIC -- indicador de fifo vacia
  );
END fifoQueue;

-------------------------------------------------------------------

LIBRARY ieee;
USE ieee.numeric_std.ALL;

ARCHITECTURE syn OF fifoQueue IS

  TYPE regFileType IS ARRAY (0 TO DEPTH - 1) OF STD_LOGIC_VECTOR(WL - 1 DOWNTO 0);

  -- Registros
  SIGNAL regFile : regFileType := (OTHERS => (OTHERS => '0'));
  SIGNAL wrPointer, rdPointer : NATURAL RANGE 0 TO DEPTH - 1 := 0;
  SIGNAL isFull : STD_LOGIC := '0';
  SIGNAL isEmpty : STD_LOGIC := '1';
  -- Se�ales  
  SIGNAL nextWrPointer, nextRdPointer : NATURAL RANGE 0 TO DEPTH - 1;
  SIGNAL rdFifo : STD_LOGIC;
  SIGNAL wrFifo : STD_LOGIC;

BEGIN

  registerFile :
  PROCESS (clk, rdPointer, regFile)
  BEGIN
    dataOut <= regFile(rdPointer);
    IF rising_edge(clk) THEN
      IF wrFifo = '1' THEN
        regFile(wrPointer) <= dataIn;
      END IF;
    END IF;
  END PROCESS;
  
  full <= isFull;
  empty <= isEmpty;
  
  numData <= STD_LOGIC_VECTOR(TO_unsigned(nextWrPointer - nextRdPointer, 4));

  wrFifo <= '1' WHEN wrE ='1' and isFull = '0' ELSE '0';
  rdFifo <= '1' WHEN rdE ='1' and isEmpty = '0' ELSE '0';
    
  nextWrPointer <= (wrPointer + 1) MOD DEPTH;
  nextRdPointer <= (rdPointer + 1) MOD DEPTH;
    
  fsmd :
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF rst = '1' THEN
        wrPointer <= 0;
        rdPointer <= 0;
        isFull <= '0';
        isEmpty <= '1';
      ELSE
        IF wrFifo = '1' THEN
          isEmpty <= '0';
          wrPointer <= nextWrPointer;
          IF nextWrPointer = rdPointer and rdFifo='0' THEN
            isFull <= '1';            
          END IF;
        END IF;
        IF rdFifo = '1' THEN
          isFull <= '0';
          rdPointer <= nextRdPointer;
          IF nextRdPointer = wrPointer and wrFifo='0' THEN
            isEmpty <= '1';            
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;
END syn;
