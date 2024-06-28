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
    -- preenche tudo com 1

    1 => B"101_1_011_0_00100000", -- LD R3,32
    2 => B"101_1_000_1_00000000", -- LD A,0
    3 => B"010_1_000_0_00000001", -- ADDI A,1
    4 => B"100_1_001_0_00000000", -- MOV R1,A
    5 => B"101_1_000_1_00000000", -- LD A,0
    6 => B"010_1_000_0_00000001", -- ADDI A,1
    7 => B"011_01_001_00000000", -- SW A, R1;
    8 => B"100_1_001_1_00000000", -- MOV A, R1
    9 => B"111_1_01_011_0000000", -- CMP A,R3
    10 => B"110_1_10_000_1111001", -- BNE A,R3,-7

    --zera os registradores r3 e r1
    11 => B"101_1_011_0_00000000", -- LD R3,0
    12 => B"101_1_001_0_00000000", -- LD R1,0
    
    -- R1 sao os primos de 1 a 5
    -- R2 contador
    -- R4 somador
    
    --loop externo 2 até 6
    13 => B"101_1_001_0_00100000", -- LD R1,6
    14 => B"101_1_010_0_00000001", -- LD R2,1
    15 => B"100_1_010_1_00000000", -- MOV A, R2
    16 => B"010_1_000_0_00000001", -- ADDI A,1
    17 => B"100_1_010_0_00000000", -- MOV R2, A
    
    --salvar valor de R2
    18 => B"100_1_010_1_00000000", -- MOV A, R2
    19 => B"100_1_100_0_00000000", -- MOV R4, A
    
    
        --loop interno 2 até 32 somando os primos
        20 => B"101_1_010_0_00100000", -- LD R3,32
        21 => B"101_1_000_1_00000000", -- LD A,0
        22 => B"001_00_100_1_0000000", -- ADD A, R4
        23 => B"100_1_100_0_00000000", -- MOV R4,A
        24 => B"101_1_000_1_00000000", -- LD A,0
        25 => B"011_01_100_00000000", -- SW A, R4;
        26 => B"100_1_100_1_00000000", -- MOV A, R4
        27 => B"111_1_01_011_0000000", -- CMP A,R3
        28 => B"110_1_10_000_1111001", -- BNE A,R3,-6

    --se R4 = 6 termina
    29 => B"100_1_010_1_00000000", -- MOV A, R2
    30 => B"111_1_01_001_0000000", -- CMP A,R1
    31 => B"110_1_10_000_1110000", -- BNE A,R1,-16

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