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
        0 =>    B"101_0_011_0_00000000",   -- LD R3,0
        1 =>    B"101_0_100_0_00000000",   -- LD R4,0
        2 =>    B"100_1_111_0_00000000",   -- MOV A,R3
        3 =>    B"001_1_010_000_000000",   -- ADD A,R4
        4 =>    B"100_1_111_0_00000000",   -- MOV R3,A
        5 =>    B"111_00_0_000_0000000",   -- ADDI A,1
        6 =>    B"111_01_0_000_0001100",   -- MOV R3,A
        7 =>    B"000_000_100_000_000_0",   -- COMP A,30
        8 =>    B"110_00_0_000_0000011",   -- JUMP BG,2
        9 =>   B"110_01_1_000_0001100",   -- MOV R5,R4 <- CORRETO
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