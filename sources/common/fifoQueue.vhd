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

library ieee;
use ieee.std_logic_1164.all;
use work.common.all;

entity fifoQueue is
  generic (
    WL    : natural;   -- anchura de la palabra de fifo
    DEPTH : natural    -- numero de palabras en fifo
  );
  port (
    clk     : in  std_logic;   -- reloj del sistema
    rst     : in  std_logic;   -- reset s�ncrono del sistema
    wrE     : in  std_logic;   -- se activa durante 1 ciclo para escribir un dato en la fifo
    dataIn  : in  std_logic_vector(WL-1 downto 0);   -- dato a escribir
    rdE     : in  std_logic;   -- se activa durante 1 ciclo para leer un dato de la fifo
    dataOut : out std_logic_vector(WL-1 downto 0);   -- dato a leer
    numData : out std_logic_vector(log2(DEPTH)-1 downto 0);   -- numero de datos almacenados
    full    : out std_logic;   -- indicador de fifo llena
    empty   : out std_logic    -- indicador de fifo vacia
  );
end fifoQueue;

-------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;

architecture syn of fifoQueue is

  type regFileType is array (0 to DEPTH-1) of std_logic_vector(WL-1 downto 0);

  -- Registros
  signal regFile : regFileType := (others => (others => '0'));
  signal wrPointer, rdPointer : natural range 0 to DEPTH-1 := 0;
  signal isFull  : std_logic := '0';
  signal isEmpty : std_logic := '1';
  -- Se�ales  
  signal nextWrPointer, nextRdPointer : natural range 0 to DEPTH-1;
  signal rdFifo  : std_logic;
  signal wrFifo  : std_logic;
  
begin

  registerFile:
  process (clk, rdPointer, regFile)
  begin
    dataOut <= regFile(rdPointer);
    if rising_edge(clk) then
      if wrFifo='1' then
        -- regFileType(wrPointer) <= dataIn;
      end if;
    end if;
  end process;
 
  wrFifo <= '0' when isFull='1' else wrE;   -- No estoy seguro de que esto sea asi
  rdFifo <= '0' when isEmpty='1' else rdE;  -- No estoy seguro de que esto sea asi
  
  nextWrPointer <= (nextWrPointer + wrFifo) mod DEPTH;
  nextRdPointer <= (nextRdPointer + rdFifo) mod DEPTH;
    
  fsmd:
  process (clk) 
  begin     
    if rising_edge(clk) then
      if rst='1' then
        wrPointer <= 0;
        rdPointer <= 0;
        isFull    <= '0';
        isEmpty   <= '1';
      else
        if wrFifo='1' then
          if isFull='0' then
            isFull    <= (nextWrPointer=nextRdPointer);
            wrPointer <= nextWrPointer;
            isEmpty   <= '0';
          end if;
        end if;
        if rdFifo='1' then
          if isEmpty='0' then
            isEmpty   <= (nextWrPointer=nextRdPointer);
            rdPointer <= nextRdPointer;
            isFull    <= '0';
        end if;
      end if;
    end if;
  end process;
 
  full    <= isFull;
  empty   <= isEmpty;
  numData <= nextWrPointer - nextRdPointer;
 
end syn;


