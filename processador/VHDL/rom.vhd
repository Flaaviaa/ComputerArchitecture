library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port(
        clk         : in std_logic := '0';
        read_en     : in std_logic := '0';
        endereco    : in unsigned(6 downto 0) := "0000000";
        dado        : out unsigned(15 downto 0) := "0000000000000000"
    );
end entity;
architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(15 downto 0);
    constant conteudo_rom : mem := (
    0 => B"010_1_000_0_00100000",  -- ADDI A, 32 (00100000)
    1 => B"100_1_111_0_00000000",  -- MOV R7, A
    2 => B"101_1_000_1_00000000",  -- LD    A, 0
    3 => B"100_1_110_0_00000000",  -- MOV   R6, A
    4 => B"010_1_000_0_00000001",  -- ADDI  A, 1
    5 => B"100_1_001_0_00000000",  -- MOV  R1, A
    6 => B"011_01_000_1_0000_001", -- SW   R1, 0(A) 
    7 => B"001_01_111_1_00000000", -- CMP  A, R7
    8 => B"110_1_10_000_11111100", -- BEQ  -4
    9 => B"101_1_000_1_00000001",  -- LD    A, 1
    10 => B"100_1_001_0_00000000", -- MOV  R1, A
    11 => B"100_1_001_1_00000000", -- MOV  A, R1
    12 => B"010_1_000_0_00000001", -- ADDI A, 1
    13 => B"100_1_001_0_00000000", -- MOV  R1, A
    14 => B"100_1_010_0_00000000", -- MOV  R2, A
    15 => B"011_00_000_1_00000100" -- LW R4, 0(A)
    16 => B"001_01_100_1_00000000",-- SUB A, R4
    
    --BNE -6
    37 => B"110_1_10_000_00000001", -- BEQ  -1 --volta pra subtracao se o resultado for igual
    37 => B"110_0_00_000_00000000", -- volta 16 se for diferente

    18 => B"101_1_000_1_00000001", -- LD    A, 1 
    19 => B"100_1_011_0_00000000", -- MOV   R3, A 
    20 => B"100_1_011_1_00000000", -- MOV   A, R3 
    21 => B"010_1_000_0_00000001", -- ADDI A, 1
    22 => B"100_1_011_0_00000000", -- MOV   R3, A 
    23 => B"100_1_001_1_00000000", -- MOV   A, R1  
    24 => B"001_00_010_1_00000000",-- ADD R2, A   
    25 => B"100_1_010_1_00000000", -- MOV   A, R2 
    26 => B"011_00_000_1_0000_001", -- SW   R1, 0(A) 
    27 => B"001_01_111_1_00000000", -- CMP  A, R7
    28 => B"100_1_001_1_00000000", -- MOV  A, R1
    29 => B"001_01_011_1_00000000", -- CMP  A, R3
    30 => B"101_1_000_1_00000001", -- LD    A, 1 
    31 => B"100_1_110_0_00000000", -- MOV   R6, A
    32 => B"100_1_010_1_00000000", -- MOV   A, R2
    33 => B"001_01_111_1_00000000", -- CMP  A, R7
    -- BNE (-16)
    34 => B"100_1_101_0_00000000", -- MOV   R5, A
    37 => B"110_1_10_000_00001000", -- BEQ  -8 --volta pra onde salva no R7 se o resultado for igual
    37 => B"110_0_00_000_00000000", -- volta 16 se for diferente
    
    35 => B"100_1_110_1_00000000", -- MOV  A, R6
    36 => B"001_01_000_1_00000000", -- CMP  A, R0
    37 => B"110_1_10_000_11100111", -- BEQ  -25
    38 => B"001_01_111_1_00000000", -- CMP  A, R7
    39 => B"011_00_000_1_00000100" -- LW R4, 0(A)


MOV A, R7
LW  R5, 0(A)
        others => (others => '0')
    );
    begin
        process(clk)
        begin
            if read_en = '1' then
                if(rising_edge(clk)) then
                    dado <= conteudo_rom(to_integer(endereco));
                end if;
            end if;
        end process;
end architecture;