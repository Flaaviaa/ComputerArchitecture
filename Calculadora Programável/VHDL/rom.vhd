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
        -- 0000000 000 000 000 I
        -- 0 000 000 000 000 000 R
        -- 0000000 000 000 000 B
        0 => "0000101000011000", --A
        1 => "0001000000100000", --B
        2 => "1000100011101011", --C
        3 => "0000001101101001", --D
        4 => "0010100000000110", --E
        5 => "0000000000101000", --F
        20 => "0000000101011000",--G
        21 => "0000010000000110",--H
        22 => "0000000000011000",--I
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