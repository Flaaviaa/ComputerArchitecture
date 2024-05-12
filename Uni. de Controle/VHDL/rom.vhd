library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port(
        clk         : in std_logic;
        read_en     : in std_logic;
        endereco    : in unsigned(6 downto 0);
        dado        : out unsigned(15 downto 0)
    );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(15 downto 0);
    constant conteudo_rom : mem := (
        0 => "0011000000000001",
        1 => "1011000000001100",
        2 => "0001000000100100",
        3 => "0011001110000000",
        4 => "1000000000000000",
        5 => "0000000000100000",
        6 => "1111000000110000",
        7 => "0000001110100011",
        8 => "0011100000100000",
        9 => "1100000000000100",
        10 => "0011000000000010",

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