library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity acumulador_tb is
end entity;

architecture a_acumulador_tb of acumulador_tb is

    signal atualizar : std_logic := '0';
    signal entrada,saida : unsigned(15 downto 0) := "0000000000000000";
    signal contador : unsigned(3 downto 0) := "0000";

    component acumulador is
        port(
        atualizar : in std_logic;
        entrada : in unsigned(15 downto 0);
        saida : out unsigned(15 downto 0)
    );
    end component;

    begin 
    uut : acumulador port map(
        atualizar => atualizar,
        entrada => entrada,
        saida => saida
    );
    
    process
    begin
        while contador /= "1111" loop
            atualizar <= not atualizar;
            wait for 50 ns;
            entrada <= entrada + 10;
            contador <= contador + 1;
        end loop;
        wait;
    end process;
end architecture;