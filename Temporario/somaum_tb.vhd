library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity somaum_tb is
end;

architecture a_somaum_tb of somaum_tb is
    signal clk : std_logic;
    signal contador : unsigned(6 downto 0) := "0000000";
    signal entrada,saida : unsigned(6 downto 0);

    component somaum
    port(
        clk : in std_logic;
        entrada : in unsigned(6 downto 0);
        saida : out unsigned(6 downto 0)
    );
    end component;
    

    begin
        uut : somaum port map(
            clk => clk,
            entrada => entrada,
            saida => saida
        );

    process
        begin
            while contador /= "1111111" loop
                wait for 50 ns;
                clk <= '0';
                wait for 50 ns;
                clk <= '1';
                contador <= contador + "0000001";
            end loop;
            wait;
        end process;
    entrada <= contador;
end architecture;
	