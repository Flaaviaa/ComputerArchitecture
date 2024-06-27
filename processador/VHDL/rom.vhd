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
    
    1 => B"101_1_000_1_0000_0110",  -- LD A, 6
    2 => B"001_00_110_1_0000_000", -- R6 + A
    3 => B"010_1_000_0_00000000",  -- A + 1
    4 => B"011_00_110_1_0000000", -- LW A,R6;
    5 => B"111_0_00_110_0010000", -- CMP R6, 32
    6 => B"110_1_10_000_0000101", -- BNE R6, 32 - volta 5
    7 => B"101_0_001_0_00_000_010",  -- LD R1, 2
    8 => B"101_0_010_0_00_000_110",  -- LD R2, 6
    9 => B"101_0_011_0_00_000_001",  -- LD R3, 1
    10 => B"101_1_000_1_00000001",  -- LD A, 1
    11 => B"001_00_001_1_0000_000", -- R1 + A
    12 => B"101_0_011_0_00_000_001",  -- LD R3, 1
    13 => B"101_0_100_0_00_100_000",  -- LD R4, 32
    14 => B"101_0_101_0_00_000_000",  -- LD R5, 0
    15 => B"100_1_101_1_00_000_000", -- MOV A,R5;
    16 => B"001_00_001_1_0000_000", -- ADD A,R1;
    17 => B"100_1_101_0_0000_0000", -- MOV R5,A;
    18 => B"101_1_000_1_00000001",  -- LD A, 1
    19 => B"001_00_011_1_0000_000", -- R3 + A
    20 => B"011_00_011_0_0000000", -- LW R3, 0;
    21 => B"100_1_011_1_00_000_000", -- MOV A,R3;
    22 => B"111_0_01_100_0000_000", -- CMP R3, R4
    23 => B"110_1_10_000_000_0110", --volta 6
    24 => B"100_1_001_1_00_000_000", -- MOV A,R1;
    25 => B"111_0_01_010_000_0000", -- CMP R1, R2
    26 => B"110_1_10_000_001_0001", --volta 17

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