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
    15 => B"011_00_000_1_00000100", -- LW R4, 0(A)
    16 => B"001_01_100_1_00000000",-- SUB A, R4
    
    --BNE -6
    17 => B"110_1_10_000_00000001", -- BEQ  -1 --volta pra subtracao se o resultado for igual
    18 => B"110_0_00_000_00000000", -- volta 16 se for diferente

    19 => B"101_1_000_1_00000001", -- LD    A, 1 
    20 => B"100_1_011_0_00000000", -- MOV   R3, A 
    21 => B"100_1_011_1_00000000", -- MOV   A, R3 
    22 => B"010_1_000_0_00000001", -- ADDI A, 1
    23 => B"100_1_011_0_00000000", -- MOV   R3, A 
    24 => B"100_1_001_1_00000000", -- MOV   A, R1  
    25 => B"001_00_010_1_00000000",-- ADD R2, A   
    26 => B"100_1_010_1_00000000", -- MOV   A, R2 
    27 => B"011_00_000_1_0000_001", -- SW   R1, 0(A) 
    28 => B"001_01_111_1_00000000", -- CMP  A, R7
    29 => B"100_1_001_1_00000000", -- MOV  A, R1
    30 => B"001_01_011_1_00000000", -- CMP  A, R3
    31 => B"101_1_000_1_00000001", -- LD    A, 1 
    32 => B"100_1_110_0_00000000", -- MOV   R6, A
    33 => B"100_1_010_1_00000000", -- MOV   A, R2
    34 => B"001_01_111_1_00000000", -- CMP  A, R7
    -- BNE (-16)
    35 => B"100_1_101_0_00000000", -- MOV   R5, A
    36 => B"110_1_10_000_00001000", -- BEQ  -8 --volta pra onde salva no R7 se o resultado for igual
    37 => B"110_0_00_000_00000000", -- volta 16 se for diferente
    
    38 => B"100_1_110_1_00000000", -- MOV  A, R6
    39 => B"001_01_000_1_00000000", -- CMP  A, R0
    40 => B"110_1_10_000_11100111", -- BEQ  -25
    41 => B"001_01_111_1_00000000", -- CMP  A, R7
    42 => B"011_00_100_1_00000100", -- LW R4, 0(A)
    43 => B"100_1_111_1_00000000", -- MOV  A,     
    44 => B"011_00_101_1_00000100", -- LW R5, 0(A)

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