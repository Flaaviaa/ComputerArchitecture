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
-- A. Carrega R3 (o registrador 3) com o valor 0
-- B. Carrega R4 com 0
-- C. Soma R3 com R4 e guarda em R4
-- D. Soma 1 em R3
-- E. Se R3<30 salta para a instrução do passo C *
-- F. Copia valor de R4 para R5
architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(15 downto 0);
    constant conteudo_rom : mem := (
        0 =>    B"101_0_011_0_00000000",   -- LD R3,0 -- A600 -A
        1 =>    B"101_0_100_0_00000000",   -- LD R4,0 -- A800 -B
        2 =>    B"100_1_011_1_00000000",   -- MOV A,R3-- 9700 -C
        3 =>    B"001_1_100_000_000000",   -- ADD A,R4 --3800
        4 =>    B"100_1_100_0_00000000",   -- MOV R4,A --9800 
        5 =>    B"100_1_011_1_00000000",   -- MOV A,R3 --9700 -D
        6 =>    B"010_1_000_0_00000001",   -- ADDI A,1 --5001 
        7 =>    B"100_1_011_0_00000000",   -- MOV R3,A --9600
        8 =>    B"111_0_00_000_0011110",   -- ADD A,-30 --E21E
        9 =>    B"110_1_01_000_1111001",   -- BRANCH ZERO,-7 --D802
        10 =>    B"100_1_100_1_00000000",   -- MOV A,R4 --9900
        11 =>   B"100_1_101_0_00000000",   -- MOV R5,A --9A00
        12 =>   B"000_011_0000000000",  -- HALT
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